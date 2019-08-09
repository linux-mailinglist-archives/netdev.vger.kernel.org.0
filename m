Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79D1087238
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 08:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405616AbfHIG0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 02:26:03 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37744 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405510AbfHIG0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 02:26:03 -0400
Received: by mail-wr1-f67.google.com with SMTP id b3so4748662wro.4
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 23:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JKiFay5eBqukapA4alffEWfvrAV3V9xOblgnuEA8dhg=;
        b=qHlyhNu1MdEK9mi8MY9vxa3FlbRPd+xrVkbZmjoQ+ztCCduQVA21ZB5z7TacMlsX7Q
         4kbWZJXxEkNVA/j2y3VpfF8Bn9P8YnxfA9pgH70IUPOWosp3ajeBRCdtB/eW+IYwW42h
         O+sJMyAzl/INVSxqBcpp5Gy3vlT5AFvCSUHunjWp2VQOg/mCIToVLI2DiYC67dJOU/7J
         u0w+CDdKeatStJl8C2q3r8HPa1ij/Q8aafYL7lJCIggp82dTzbeKFCnnDxJdzq2Z4dO8
         JaFQAgdMjXFHV2jFvK2/zz5m1lXJouWzTo3qAl5gl98Rcctt/PyRfaAn2fq6ULbaCaHb
         FhjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JKiFay5eBqukapA4alffEWfvrAV3V9xOblgnuEA8dhg=;
        b=gNgBYQp0de4tRc6CxcyTECBte7adlyf5+0dGtRpPjaqwuIzBCUjZJH3LqTQmto5aQK
         zp4EvUIFBhQk/kWcyUKXSqDnr0iGu0AaesS6yAO/1Vxm2i6GhsAVb8zJoLaK1Y0ac06T
         go5nOFUc6HbbFblKzKnB/PqvyQZK7bLOqOqgvOuukxJddv2S3MDI9Mb35YyMyaMrEMCN
         g07yuSSzGPkCGvZnpvk3817rHJkGO0Nq209qnlSY0O20afLEGJRw1BaSw3z3gRZ2ea0a
         hi8gB7emwhpEIFpBPq0Ifomx4v5AazCWLzwacMdj/6m0yYffwUhdM2RlApYGPP02bvdj
         4zoA==
X-Gm-Message-State: APjAAAUBAIiKdi/GExRLsO54x7BIhlY6lTzmNn9vJ+V1+NMLaHiGEmUi
        /wV43ozha7uULM7ndC6p7gBJYQ==
X-Google-Smtp-Source: APXvYqxph0nClC4F93u03pczqcXVtb7yym30OY7WlRIzF8LL8awwMq5kpsXQtJ2AlffZlvtg8Y4TYQ==
X-Received: by 2002:a5d:46d1:: with SMTP id g17mr8940614wrs.131.1565331959248;
        Thu, 08 Aug 2019 23:25:59 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id a19sm14645132wra.2.2019.08.08.23.25.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 23:25:58 -0700 (PDT)
Date:   Fri, 9 Aug 2019 08:25:58 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        David Ahern <dsahern@gmail.com>, dcbw@redhat.com,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
Message-ID: <20190809062558.GA2344@nanopsycho.orion>
References: <20190719110029.29466-1-jiri@resnulli.us>
 <20190719110029.29466-4-jiri@resnulli.us>
 <CAJieiUi+gKKc94bKfC-N5LBc=FdzGGo_8+x2oTstihFaUpkKSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJieiUi+gKKc94bKfC-N5LBc=FdzGGo_8+x2oTstihFaUpkKSA@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Aug 09, 2019 at 06:11:30AM CEST, roopa@cumulusnetworks.com wrote:
>On Fri, Jul 19, 2019 at 4:00 AM Jiri Pirko <jiri@resnulli.us> wrote:
>>
>> From: Jiri Pirko <jiri@mellanox.com>
>>
>> Add two commands to add and delete alternative ifnames for net device.
>> Each net device can have multiple alternative names.
>>
>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>> ---
>>  include/linux/netdevice.h      |   4 ++
>>  include/uapi/linux/if.h        |   1 +
>>  include/uapi/linux/if_link.h   |   1 +
>>  include/uapi/linux/rtnetlink.h |   7 +++
>>  net/core/dev.c                 |  58 ++++++++++++++++++-
>>  net/core/rtnetlink.c           | 102 +++++++++++++++++++++++++++++++++
>>  security/selinux/nlmsgtab.c    |   4 +-
>>  7 files changed, 175 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>> index 74f99f127b0e..6922fdb483ca 100644
>> --- a/include/linux/netdevice.h
>> +++ b/include/linux/netdevice.h
>> @@ -920,10 +920,14 @@ struct tlsdev_ops;
>>
>>  struct netdev_name_node {
>>         struct hlist_node hlist;
>> +       struct list_head list;
>>         struct net_device *dev;
>>         char *name;
>>  };
>>
>> +int netdev_name_node_alt_create(struct net_device *dev, char *name);
>> +int netdev_name_node_alt_destroy(struct net_device *dev, char *name);
>> +
>>  /*
>>   * This structure defines the management hooks for network devices.
>>   * The following hooks can be defined; unless noted otherwise, they are
>> diff --git a/include/uapi/linux/if.h b/include/uapi/linux/if.h
>> index 7fea0fd7d6f5..4bf33344aab1 100644
>> --- a/include/uapi/linux/if.h
>> +++ b/include/uapi/linux/if.h
>> @@ -33,6 +33,7 @@
>>  #define        IFNAMSIZ        16
>>  #endif /* __UAPI_DEF_IF_IFNAMSIZ */
>>  #define        IFALIASZ        256
>> +#define        ALTIFNAMSIZ     128
>>  #include <linux/hdlc/ioctl.h>
>>
>>  /* For glibc compatibility. An empty enum does not compile. */
>> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
>> index 4a8c02cafa9a..92268946e04a 100644
>> --- a/include/uapi/linux/if_link.h
>> +++ b/include/uapi/linux/if_link.h
>> @@ -167,6 +167,7 @@ enum {
>>         IFLA_NEW_IFINDEX,
>>         IFLA_MIN_MTU,
>>         IFLA_MAX_MTU,
>> +       IFLA_ALT_IFNAME_MOD, /* Alternative ifname to add/delete */
>>         __IFLA_MAX
>>  };
>>
>> diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
>> index ce2a623abb75..b36cfd83eb76 100644
>> --- a/include/uapi/linux/rtnetlink.h
>> +++ b/include/uapi/linux/rtnetlink.h
>> @@ -164,6 +164,13 @@ enum {
>>         RTM_GETNEXTHOP,
>>  #define RTM_GETNEXTHOP RTM_GETNEXTHOP
>>
>> +       RTM_NEWALTIFNAME = 108,
>> +#define RTM_NEWALTIFNAME       RTM_NEWALTIFNAME
>> +       RTM_DELALTIFNAME,
>> +#define RTM_DELALTIFNAME       RTM_DELALTIFNAME
>> +       RTM_GETALTIFNAME,
>> +#define RTM_GETALTIFNAME       RTM_GETALTIFNAME
>> +
>
>I might have missed the prior discussion, why do we need new commands
>?. can't this simply be part of RTM_*LINK and we use RTM_SETLINK to
>set alternate names ?

How? This is to add/remove. How do you suggest to to add/remove by
setlink?


>
>
>
>>         __RTM_MAX,
>>  #define RTM_MAX                (((__RTM_MAX + 3) & ~3) - 1)
>>  };
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index ad0d42fbdeee..2a3be2b279d3 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -244,7 +244,13 @@ static struct netdev_name_node *netdev_name_node_alloc(struct net_device *dev,
>>  static struct netdev_name_node *
>>  netdev_name_node_head_alloc(struct net_device *dev)
>>  {
>> -       return netdev_name_node_alloc(dev, dev->name);
>> +       struct netdev_name_node *name_node;
>> +
>> +       name_node = netdev_name_node_alloc(dev, dev->name);
>> +       if (!name_node)
>> +               return NULL;
>> +       INIT_LIST_HEAD(&name_node->list);
>> +       return name_node;
>>  }
>>
>>  static void netdev_name_node_free(struct netdev_name_node *name_node)
>> @@ -288,6 +294,55 @@ static struct netdev_name_node *netdev_name_node_lookup_rcu(struct net *net,
>>         return NULL;
>>  }
>>
>> +int netdev_name_node_alt_create(struct net_device *dev, char *name)
>> +{
>> +       struct netdev_name_node *name_node;
>> +       struct net *net = dev_net(dev);
>> +
>> +       name_node = netdev_name_node_lookup(net, name);
>> +       if (name_node)
>> +               return -EEXIST;
>> +       name_node = netdev_name_node_alloc(dev, name);
>> +       if (!name_node)
>> +               return -ENOMEM;
>> +       netdev_name_node_add(net, name_node);
>> +       /* The node that holds dev->name acts as a head of per-device list. */
>> +       list_add_tail(&name_node->list, &dev->name_node->list);
>> +
>> +       return 0;
>> +}
>> +EXPORT_SYMBOL(netdev_name_node_alt_create);
>> +
>> +static void __netdev_name_node_alt_destroy(struct netdev_name_node *name_node)
>> +{
>> +       list_del(&name_node->list);
>> +       netdev_name_node_del(name_node);
>> +       kfree(name_node->name);
>> +       netdev_name_node_free(name_node);
>> +}
>> +
>> +int netdev_name_node_alt_destroy(struct net_device *dev, char *name)
>> +{
>> +       struct netdev_name_node *name_node;
>> +       struct net *net = dev_net(dev);
>> +
>> +       name_node = netdev_name_node_lookup(net, name);
>> +       if (!name_node)
>> +               return -ENOENT;
>> +       __netdev_name_node_alt_destroy(name_node);
>> +
>> +       return 0;
>> +}
>> +EXPORT_SYMBOL(netdev_name_node_alt_destroy);
>> +
>> +static void netdev_name_node_alt_flush(struct net_device *dev)
>> +{
>> +       struct netdev_name_node *name_node, *tmp;
>> +
>> +       list_for_each_entry_safe(name_node, tmp, &dev->name_node->list, list)
>> +               __netdev_name_node_alt_destroy(name_node);
>> +}
>> +
>>  /* Device list insertion */
>>  static void list_netdevice(struct net_device *dev)
>>  {
>> @@ -8258,6 +8313,7 @@ static void rollback_registered_many(struct list_head *head)
>>                 dev_uc_flush(dev);
>>                 dev_mc_flush(dev);
>>
>> +               netdev_name_node_alt_flush(dev);
>>                 netdev_name_node_free(dev->name_node);
>>
>>                 if (dev->netdev_ops->ndo_uninit)
>> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
>> index 1ee6460f8275..7a2010b16e10 100644
>> --- a/net/core/rtnetlink.c
>> +++ b/net/core/rtnetlink.c
>> @@ -1750,6 +1750,8 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
>>         [IFLA_CARRIER_DOWN_COUNT] = { .type = NLA_U32 },
>>         [IFLA_MIN_MTU]          = { .type = NLA_U32 },
>>         [IFLA_MAX_MTU]          = { .type = NLA_U32 },
>> +       [IFLA_ALT_IFNAME_MOD]   = { .type = NLA_STRING,
>> +                                   .len = ALTIFNAMSIZ - 1 },
>>  };
>>
>>  static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
>> @@ -3373,6 +3375,103 @@ static int rtnl_getlink(struct sk_buff *skb, struct nlmsghdr *nlh,
>>         return err;
>>  }
>>
>> +static int rtnl_newaltifname(struct sk_buff *skb, struct nlmsghdr *nlh,
>> +                            struct netlink_ext_ack *extack)
>> +{
>> +       struct net *net = sock_net(skb->sk);
>> +       struct nlattr *tb[IFLA_MAX + 1];
>> +       struct net_device *dev;
>> +       struct ifinfomsg *ifm;
>> +       char *new_alt_ifname;
>> +       int err;
>> +
>> +       err = nlmsg_parse(nlh, sizeof(*ifm), tb, IFLA_MAX, ifla_policy, extack);
>> +       if (err)
>> +               return err;
>> +
>> +       err = rtnl_ensure_unique_netns(tb, extack, true);
>> +       if (err)
>> +               return err;
>> +
>> +       ifm = nlmsg_data(nlh);
>> +       if (ifm->ifi_index > 0) {
>> +               dev = __dev_get_by_index(net, ifm->ifi_index);
>> +       } else if (tb[IFLA_IFNAME]) {
>> +               char ifname[IFNAMSIZ];
>> +
>> +               nla_strlcpy(ifname, tb[IFLA_IFNAME], IFNAMSIZ);
>> +               dev = __dev_get_by_name(net, ifname);
>> +       } else {
>> +               return -EINVAL;
>> +       }
>> +
>> +       if (!dev)
>> +               return -ENODEV;
>> +
>> +       if (!tb[IFLA_ALT_IFNAME_MOD])
>> +               return -EINVAL;
>> +
>> +       new_alt_ifname = nla_strdup(tb[IFLA_ALT_IFNAME_MOD], GFP_KERNEL);
>> +       if (!new_alt_ifname)
>> +               return -ENOMEM;
>> +
>> +       err = netdev_name_node_alt_create(dev, new_alt_ifname);
>> +       if (err)
>> +               goto out_free_new_alt_ifname;
>> +
>> +       return 0;
>> +
>> +out_free_new_alt_ifname:
>> +       kfree(new_alt_ifname);
>> +       return err;
>> +}
>> +
>> +static int rtnl_delaltifname(struct sk_buff *skb, struct nlmsghdr *nlh,
>> +                            struct netlink_ext_ack *extack)
>> +{
>> +       struct net *net = sock_net(skb->sk);
>> +       struct nlattr *tb[IFLA_MAX + 1];
>> +       struct net_device *dev;
>> +       struct ifinfomsg *ifm;
>> +       char *del_alt_ifname;
>> +       int err;
>> +
>> +       err = nlmsg_parse(nlh, sizeof(*ifm), tb, IFLA_MAX, ifla_policy, extack);
>> +       if (err)
>> +               return err;
>> +
>> +       err = rtnl_ensure_unique_netns(tb, extack, true);
>> +       if (err)
>> +               return err;
>> +
>> +       ifm = nlmsg_data(nlh);
>> +       if (ifm->ifi_index > 0) {
>> +               dev = __dev_get_by_index(net, ifm->ifi_index);
>> +       } else if (tb[IFLA_IFNAME]) {
>> +               char ifname[IFNAMSIZ];
>> +
>> +               nla_strlcpy(ifname, tb[IFLA_IFNAME], IFNAMSIZ);
>> +               dev = __dev_get_by_name(net, ifname);
>> +       } else {
>> +               return -EINVAL;
>> +       }
>> +
>> +       if (!dev)
>> +               return -ENODEV;
>> +
>> +       if (!tb[IFLA_ALT_IFNAME_MOD])
>> +               return -EINVAL;
>> +
>> +       del_alt_ifname = nla_strdup(tb[IFLA_ALT_IFNAME_MOD], GFP_KERNEL);
>> +       if (!del_alt_ifname)
>> +               return -ENOMEM;
>> +
>> +       err = netdev_name_node_alt_destroy(dev, del_alt_ifname);
>> +       kfree(del_alt_ifname);
>> +
>> +       return err;
>> +}
>> +
>>  static u16 rtnl_calcit(struct sk_buff *skb, struct nlmsghdr *nlh)
>>  {
>>         struct net *net = sock_net(skb->sk);
>> @@ -5331,6 +5430,9 @@ void __init rtnetlink_init(void)
>>         rtnl_register(PF_UNSPEC, RTM_GETROUTE, NULL, rtnl_dump_all, 0);
>>         rtnl_register(PF_UNSPEC, RTM_GETNETCONF, NULL, rtnl_dump_all, 0);
>>
>> +       rtnl_register(PF_UNSPEC, RTM_NEWALTIFNAME, rtnl_newaltifname, NULL, 0);
>> +       rtnl_register(PF_UNSPEC, RTM_DELALTIFNAME, rtnl_delaltifname, NULL, 0);
>> +
>>         rtnl_register(PF_BRIDGE, RTM_NEWNEIGH, rtnl_fdb_add, NULL, 0);
>>         rtnl_register(PF_BRIDGE, RTM_DELNEIGH, rtnl_fdb_del, NULL, 0);
>>         rtnl_register(PF_BRIDGE, RTM_GETNEIGH, rtnl_fdb_get, rtnl_fdb_dump, 0);
>> diff --git a/security/selinux/nlmsgtab.c b/security/selinux/nlmsgtab.c
>> index 58345ba0528e..a712b54c666c 100644
>> --- a/security/selinux/nlmsgtab.c
>> +++ b/security/selinux/nlmsgtab.c
>> @@ -83,6 +83,8 @@ static const struct nlmsg_perm nlmsg_route_perms[] =
>>         { RTM_NEWNEXTHOP,       NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
>>         { RTM_DELNEXTHOP,       NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
>>         { RTM_GETNEXTHOP,       NETLINK_ROUTE_SOCKET__NLMSG_READ  },
>> +       { RTM_NEWALTIFNAME,     NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
>> +       { RTM_DELALTIFNAME,     NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
>>  };
>>
>>  static const struct nlmsg_perm nlmsg_tcpdiag_perms[] =
>> @@ -166,7 +168,7 @@ int selinux_nlmsg_lookup(u16 sclass, u16 nlmsg_type, u32 *perm)
>>                  * structures at the top of this file with the new mappings
>>                  * before updating the BUILD_BUG_ON() macro!
>>                  */
>> -               BUILD_BUG_ON(RTM_MAX != (RTM_NEWNEXTHOP + 3));
>> +               BUILD_BUG_ON(RTM_MAX != (RTM_NEWALTIFNAME + 3));
>>                 err = nlmsg_perm(nlmsg_type, perm, nlmsg_route_perms,
>>                                  sizeof(nlmsg_route_perms));
>>                 break;
>> --
>> 2.21.0
>>
