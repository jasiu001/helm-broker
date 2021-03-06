---
title: Basic architecture
type: Architecture
---

Helm Broker is installed alongside other Kyma components and it automatically registers itself in Service Catalog as a ClusterServiceBroker. The installation provides the default [helm-repos-urls](https://github.com/kyma-project/kyma/blob/main/resources/helm-broker/templates/addons-cfg.yaml) ClusterAddonsConfiguration (CAC) custom resource (CR). It contains URLs from which Helm Broker fetches addons. You can also add your own addons with URLs that point to [your addons repository](./04-create-addons.md).

If you want Helm Broker to act as a Namespace-scoped ServiceBroker, create the [AddonsConfiguration](./13-cr-addonsconfiguration.md) (AC) CR. In such a case, Helm Broker creates a service and registers itself in Service Catalog as a ServiceBroker inside the Namespace in which the CR is created.

The Helm Broker workflow starts with the registration process, during which Helm Broker fetches addons from URLs provided in the ClusterAddonsConfiguration or AddonsConfiguration CRs and registers them as Service Classes in Service Catalog.

## Cluster-wide addons flow

1. Helm Broker watches for ClusterAddonsConfiguration CRs in a given cluster.
2. The user creates a ClusterAddonsConfiguration CR.
3. Helm Broker fetches and parses the data of all addon repositories defined in the ClusterAddonsConfiguration CR.
4. Helm Broker creates a ClusterServiceBroker. There is always only one ClusterServiceBroker, even if there are multiple ClusterAddonsConfiguration CRs.
>**NOTE:** Helm Broker is the sole component that manages the Cluster Service Broker. The user should not create or delete this resource.
5. Service Catalog fetches services that the ClusterServiceBroker exposes.
6. Service Catalog creates a ClusterServiceClass for each service received from the ClusterServiceBroker.

![Helm Broker cluster](./assets/hb-cluster.svg)

## Namespace-scoped addons flow

1. Helm Broker watches for AddonsConfiguration CRs in all Namespaces.
2. The user creates an AddonsConfiguration CR in a given Namespace.
3. Helm Broker fetches and parses the data of all addon repositories defined in the AddonsConfiguration CR.
4. Helm Broker creates a Service Broker (SB) inside the Namespace in which the AddonsConfiguration CR is created. There is always a single ServiceBroker per Namespace, even if there are more AddonsConfigurations CRs.
>**NOTE:** Helm Broker is the sole component that manages the Service Broker. The user should not create or delete this resource.
5. Service Catalog fetches the services that the Service Broker exposes.
6. Service Catalog creates a ServiceClass for each service received from the Service Broker.

![Helm Broker cluster](./assets/hb-namespaced.svg)

## Provisioning and binding

After you register your addons in Service Catalog, you can provision and bind Service Classes that your addons provide.

1. Select a given addon Service Class from Service Catalog.
2. Provision this Service Class by creating its ServiceInstance in a given Namespace.
3. Bind your ServiceInstance to a service or a Function.
4. The service or Function calls a given addon.

![Helm Broker architecture](./assets/hb-architecture.svg)
