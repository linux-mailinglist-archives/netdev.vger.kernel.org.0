Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7218D87E41
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 17:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436700AbfHIPkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 11:40:36 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:42875 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbfHIPkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 11:40:36 -0400
Received: by mail-ed1-f68.google.com with SMTP id m44so1896142edd.9
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 08:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LjOtCPnu8w9O4z2ZoysTGSfIGpNrZKl6AqymfMqLL7g=;
        b=T7aUqFKrNwVNiK1t1a2hY9FU6oxWvdHJ3Mw5BB1tZRX/cl68ozY6obx0azf4vqm7yO
         TbMJEaygF6e8F/iYwiOYFDM+PWq2yIQXOI/xj8WjB2wAhdQV3xiK6b8uoQ91CzrNDzbh
         GrsqomfhK9IP+Satpvrez8EKjXi0/mZr5ilm0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LjOtCPnu8w9O4z2ZoysTGSfIGpNrZKl6AqymfMqLL7g=;
        b=PHROn8Nm0QOAPOqNAjhvRFAI3ZCY0AJfK1h//NeO4VgwWeW1ed3JUD0/O0FYgrodku
         +Qkgv0ACHdP6j6sRafyjbRk620+cxOyhLwuTFnC84z4AGjjmBSUnOtbcMfLqtH9LR2tZ
         NJMGmS5F3vL+HhtVKSwqx/GVTlQ4S5tlNfJBMPiIiAniDLjsWpyvvV/ZLk+cEGretgxh
         BOw1odSWqB3w3C5AMgLgjiMJrJ+Cfl87KS3A0LlFbwiFPQkZzplBJ1WdQz0fj1LPq4i2
         LuQG+ClTKvMBtrEsLVJL8FHizAdq6LbPyqP07u0cYCQrKA9NZ1wusfIUPAFXFpKbzq9V
         aj/Q==
X-Gm-Message-State: APjAAAW7S42YL/w0DAcsw+uoGAj4ltMEOV26XZulb3wDa2jA8+vCwB15
        1/3JI9cWry1yF3bm/JpM7Ma/AfoO6fOH3GjfkuwymQ==
X-Google-Smtp-Source: APXvYqwdzAjWWsI0cUgD4fFg32docrmqDBc8lzFTQfgqZvSjYIIVTs6dQRpTa/Gw9DpNj86L4jh8XfSihzp2sCtupDk=
X-Received: by 2002:a17:906:6888:: with SMTP id n8mr18868594ejr.134.1565365233906;
 Fri, 09 Aug 2019 08:40:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190719110029.29466-1-jiri@resnulli.us> <20190719110029.29466-4-jiri@resnulli.us>
 <CAJieiUi+gKKc94bKfC-N5LBc=FdzGGo_8+x2oTstihFaUpkKSA@mail.gmail.com> <20190809062558.GA2344@nanopsycho.orion>
In-Reply-To: <20190809062558.GA2344@nanopsycho.orion>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Fri, 9 Aug 2019 08:40:25 -0700
Message-ID: <CAJieiUj7nzHdRUjBpnfL5bKPszJL0b_hKjxpjM0RGd9ocF3EoA@mail.gmail.com>
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        David Ahern <dsahern@gmail.com>, dcbw@redhat.com,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 8, 2019 at 11:25 PM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Fri, Aug 09, 2019 at 06:11:30AM CEST, roopa@cumulusnetworks.com wrote:
> >On Fri, Jul 19, 2019 at 4:00 AM Jiri Pirko <jiri@resnulli.us> wrote:
> >>
> >> From: Jiri Pirko <jiri@mellanox.com>
> >>
> >> Add two commands to add and delete alternative ifnames for net device.
> >> Each net device can have multiple alternative names.
> >>
> >> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> >> ---
> >>  include/linux/netdevice.h      |   4 ++
> >>  include/uapi/linux/if.h        |   1 +
> >>  include/uapi/linux/if_link.h   |   1 +
> >>  include/uapi/linux/rtnetlink.h |   7 +++
> >>  net/core/dev.c                 |  58 ++++++++++++++++++-
> >>  net/core/rtnetlink.c           | 102 +++++++++++++++++++++++++++++++++
> >>  security/selinux/nlmsgtab.c    |   4 +-
> >>  7 files changed, 175 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> >> index 74f99f127b0e..6922fdb483ca 100644
> >> --- a/include/linux/netdevice.h
> >> +++ b/include/linux/netdevice.h
> >> @@ -920,10 +920,14 @@ struct tlsdev_ops;
> >>
> >>  struct netdev_name_node {
> >>         struct hlist_node hlist;
> >> +       struct list_head list;
> >>         struct net_device *dev;
> >>         char *name;
> >>  };
> >>
> >> +int netdev_name_node_alt_create(struct net_device *dev, char *name);
> >> +int netdev_name_node_alt_destroy(struct net_device *dev, char *name);
> >> +
> >>  /*
> >>   * This structure defines the management hooks for network devices.
> >>   * The following hooks can be defined; unless noted otherwise, they are
> >> diff --git a/include/uapi/linux/if.h b/include/uapi/linux/if.h
> >> index 7fea0fd7d6f5..4bf33344aab1 100644
> >> --- a/include/uapi/linux/if.h
> >> +++ b/include/uapi/linux/if.h
> >> @@ -33,6 +33,7 @@
> >>  #define        IFNAMSIZ        16
> >>  #endif /* __UAPI_DEF_IF_IFNAMSIZ */
> >>  #define        IFALIASZ        256
> >> +#define        ALTIFNAMSIZ     128
> >>  #include <linux/hdlc/ioctl.h>
> >>
> >>  /* For glibc compatibility. An empty enum does not compile. */
> >> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> >> index 4a8c02cafa9a..92268946e04a 100644
> >> --- a/include/uapi/linux/if_link.h
> >> +++ b/include/uapi/linux/if_link.h
> >> @@ -167,6 +167,7 @@ enum {
> >>         IFLA_NEW_IFINDEX,
> >>         IFLA_MIN_MTU,
> >>         IFLA_MAX_MTU,
> >> +       IFLA_ALT_IFNAME_MOD, /* Alternative ifname to add/delete */
> >>         __IFLA_MAX
> >>  };
> >>
> >> diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
> >> index ce2a623abb75..b36cfd83eb76 100644
> >> --- a/include/uapi/linux/rtnetlink.h
> >> +++ b/include/uapi/linux/rtnetlink.h
> >> @@ -164,6 +164,13 @@ enum {
> >>         RTM_GETNEXTHOP,
> >>  #define RTM_GETNEXTHOP RTM_GETNEXTHOP
> >>
> >> +       RTM_NEWALTIFNAME = 108,
> >> +#define RTM_NEWALTIFNAME       RTM_NEWALTIFNAME
> >> +       RTM_DELALTIFNAME,
> >> +#define RTM_DELALTIFNAME       RTM_DELALTIFNAME
> >> +       RTM_GETALTIFNAME,
> >> +#define RTM_GETALTIFNAME       RTM_GETALTIFNAME
> >> +
> >
> >I might have missed the prior discussion, why do we need new commands
> >?. can't this simply be part of RTM_*LINK and we use RTM_SETLINK to
> >set alternate names ?
>
> How? This is to add/remove. How do you suggest to to add/remove by
> setlink?

to that point, I am also not sure why we have a new API For multiple
names. I mean why support more than two names  (existing old name and
a new name to remove the length limitation) ?

Your patch series addresses a very important problem (we run into this
limitation all  the time and its hard to explain it to network
operators) and
 its already unfortunate that we have to have more than one name
because we cannot resize the existing one.

The best we can do for simpler transition/management from user-space
is to keep the api simple..
ie keep it close to the management of existing link attributes. Hence
the question.

I assumed this would be like alias. A single new field that can be
referenced in lieu of the old one.

Your series is very useful to many of us...but when i think about
changing our network manager to accommodate this, I am worried about
how many apps will have to change.
I agree they have to change regardless but now they will have to
listen to yet another notification and msg format for names ?

(apologies for joining the thread late and if i missed prior discussion on this)


>
>
> >
> >
> >
> >>         __RTM_MAX,
> >>  #define RTM_MAX                (((__RTM_MAX + 3) & ~3) - 1)
> >>  };
> >> diff --git a/net/core/dev.c b/net/core/dev.c
> >> index ad0d42fbdeee..2a3be2b279d3 100644
> >> --- a/net/core/dev.c
> >> +++ b/net/core/dev.c
> >> @@ -244,7 +244,13 @@ static struct netdev_name_node *netdev_name_node_alloc(struct net_device *dev,
> >>  static struct netdev_name_node *
> >>  netdev_name_node_head_alloc(struct net_device *dev)
> >>  {
> >> -       return netdev_name_node_alloc(dev, dev->name);
> >> +       struct netdev_name_node *name_node;
> >> +
> >> +       name_node = netdev_name_node_alloc(dev, dev->name);
> >> +       if (!name_node)
> >> +               return NULL;
> >> +       INIT_LIST_HEAD(&name_node->list);
> >> +       return name_node;
> >>  }
> >>
> >>  static void netdev_name_node_free(struct netdev_name_node *name_node)
> >> @@ -288,6 +294,55 @@ static struct netdev_name_node *netdev_name_node_lookup_rcu(struct net *net,
> >>         return NULL;
> >>  }
> >>
> >> +int netdev_name_node_alt_create(struct net_device *dev, char *name)
> >> +{
> >> +       struct netdev_name_node *name_node;
> >> +       struct net *net = dev_net(dev);
> >> +
> >> +       name_node = netdev_name_node_lookup(net, name);
> >> +       if (name_node)
> >> +               return -EEXIST;
> >> +       name_node = netdev_name_node_alloc(dev, name);
> >> +       if (!name_node)
> >> +               return -ENOMEM;
> >> +       netdev_name_node_add(net, name_node);
> >> +       /* The node that holds dev->name acts as a head of per-device list. */
> >> +       list_add_tail(&name_node->list, &dev->name_node->list);
> >> +
> >> +       return 0;
> >> +}
> >> +EXPORT_SYMBOL(netdev_name_node_alt_create);
> >> +
> >> +static void __netdev_name_node_alt_destroy(struct netdev_name_node *name_node)
> >> +{
> >> +       list_del(&name_node->list);
> >> +       netdev_name_node_del(name_node);
> >> +       kfree(name_node->name);
> >> +       netdev_name_node_free(name_node);
> >> +}
> >> +
> >> +int netdev_name_node_alt_destroy(struct net_device *dev, char *name)
> >> +{
> >> +       struct netdev_name_node *name_node;
> >> +       struct net *net = dev_net(dev);
> >> +
> >> +       name_node = netdev_name_node_lookup(net, name);
> >> +       if (!name_node)
> >> +               return -ENOENT;
> >> +       __netdev_name_node_alt_destroy(name_node);
> >> +
> >> +       return 0;
> >> +}
> >> +EXPORT_SYMBOL(netdev_name_node_alt_destroy);
> >> +
> >> +static void netdev_name_node_alt_flush(struct net_device *dev)
> >> +{
> >> +       struct netdev_name_node *name_node, *tmp;
> >> +
> >> +       list_for_each_entry_safe(name_node, tmp, &dev->name_node->list, list)
> >> +               __netdev_name_node_alt_destroy(name_node);
> >> +}
> >> +
> >>  /* Device list insertion */
> >>  static void list_netdevice(struct net_device *dev)
> >>  {
> >> @@ -8258,6 +8313,7 @@ static void rollback_registered_many(struct list_head *head)
> >>                 dev_uc_flush(dev);
> >>                 dev_mc_flush(dev);
> >>
> >> +               netdev_name_node_alt_flush(dev);
> >>                 netdev_name_node_free(dev->name_node);
> >>
> >>                 if (dev->netdev_ops->ndo_uninit)
> >> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> >> index 1ee6460f8275..7a2010b16e10 100644
> >> --- a/net/core/rtnetlink.c
> >> +++ b/net/core/rtnetlink.c
> >> @@ -1750,6 +1750,8 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
> >>         [IFLA_CARRIER_DOWN_COUNT] = { .type = NLA_U32 },
> >>         [IFLA_MIN_MTU]          = { .type = NLA_U32 },
> >>         [IFLA_MAX_MTU]          = { .type = NLA_U32 },
> >> +       [IFLA_ALT_IFNAME_MOD]   = { .type = NLA_STRING,
> >> +                                   .len = ALTIFNAMSIZ - 1 },
> >>  };
> >>
> >>  static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
> >> @@ -3373,6 +3375,103 @@ static int rtnl_getlink(struct sk_buff *skb, struct nlmsghdr *nlh,
> >>         return err;
> >>  }
> >>
> >> +static int rtnl_newaltifname(struct sk_buff *skb, struct nlmsghdr *nlh,
> >> +                            struct netlink_ext_ack *extack)
> >> +{
> >> +       struct net *net = sock_net(skb->sk);
> >> +       struct nlattr *tb[IFLA_MAX + 1];
> >> +       struct net_device *dev;
> >> +       struct ifinfomsg *ifm;
> >> +       char *new_alt_ifname;
> >> +       int err;
> >> +
> >> +       err = nlmsg_parse(nlh, sizeof(*ifm), tb, IFLA_MAX, ifla_policy, extack);
> >> +       if (err)
> >> +               return err;
> >> +
> >> +       err = rtnl_ensure_unique_netns(tb, extack, true);
> >> +       if (err)
> >> +               return err;
> >> +
> >> +       ifm = nlmsg_data(nlh);
> >> +       if (ifm->ifi_index > 0) {
> >> +               dev = __dev_get_by_index(net, ifm->ifi_index);
> >> +       } else if (tb[IFLA_IFNAME]) {
> >> +               char ifname[IFNAMSIZ];
> >> +
> >> +               nla_strlcpy(ifname, tb[IFLA_IFNAME], IFNAMSIZ);
> >> +               dev = __dev_get_by_name(net, ifname);
> >> +       } else {
> >> +               return -EINVAL;
> >> +       }
> >> +
> >> +       if (!dev)
> >> +               return -ENODEV;
> >> +
> >> +       if (!tb[IFLA_ALT_IFNAME_MOD])
> >> +               return -EINVAL;
> >> +
> >> +       new_alt_ifname = nla_strdup(tb[IFLA_ALT_IFNAME_MOD], GFP_KERNEL);
> >> +       if (!new_alt_ifname)
> >> +               return -ENOMEM;
> >> +
> >> +       err = netdev_name_node_alt_create(dev, new_alt_ifname);
> >> +       if (err)
> >> +               goto out_free_new_alt_ifname;
> >> +
> >> +       return 0;
> >> +
> >> +out_free_new_alt_ifname:
> >> +       kfree(new_alt_ifname);
> >> +       return err;
> >> +}
> >> +
> >> +static int rtnl_delaltifname(struct sk_buff *skb, struct nlmsghdr *nlh,
> >> +                            struct netlink_ext_ack *extack)
> >> +{
> >> +       struct net *net = sock_net(skb->sk);
> >> +       struct nlattr *tb[IFLA_MAX + 1];
> >> +       struct net_device *dev;
> >> +       struct ifinfomsg *ifm;
> >> +       char *del_alt_ifname;
> >> +       int err;
> >> +
> >> +       err = nlmsg_parse(nlh, sizeof(*ifm), tb, IFLA_MAX, ifla_policy, extack);
> >> +       if (err)
> >> +               return err;
> >> +
> >> +       err = rtnl_ensure_unique_netns(tb, extack, true);
> >> +       if (err)
> >> +               return err;
> >> +
> >> +       ifm = nlmsg_data(nlh);
> >> +       if (ifm->ifi_index > 0) {
> >> +               dev = __dev_get_by_index(net, ifm->ifi_index);
> >> +       } else if (tb[IFLA_IFNAME]) {
> >> +               char ifname[IFNAMSIZ];
> >> +
> >> +               nla_strlcpy(ifname, tb[IFLA_IFNAME], IFNAMSIZ);
> >> +               dev = __dev_get_by_name(net, ifname);
> >> +       } else {
> >> +               return -EINVAL;
> >> +       }
> >> +
> >> +       if (!dev)
> >> +               return -ENODEV;
> >> +
> >> +       if (!tb[IFLA_ALT_IFNAME_MOD])
> >> +               return -EINVAL;
> >> +
> >> +       del_alt_ifname = nla_strdup(tb[IFLA_ALT_IFNAME_MOD], GFP_KERNEL);
> >> +       if (!del_alt_ifname)
> >> +               return -ENOMEM;
> >> +
> >> +       err = netdev_name_node_alt_destroy(dev, del_alt_ifname);
> >> +       kfree(del_alt_ifname);
> >> +
> >> +       return err;
> >> +}
> >> +
> >>  static u16 rtnl_calcit(struct sk_buff *skb, struct nlmsghdr *nlh)
> >>  {
> >>         struct net *net = sock_net(skb->sk);
> >> @@ -5331,6 +5430,9 @@ void __init rtnetlink_init(void)
> >>         rtnl_register(PF_UNSPEC, RTM_GETROUTE, NULL, rtnl_dump_all, 0);
> >>         rtnl_register(PF_UNSPEC, RTM_GETNETCONF, NULL, rtnl_dump_all, 0);
> >>
> >> +       rtnl_register(PF_UNSPEC, RTM_NEWALTIFNAME, rtnl_newaltifname, NULL, 0);
> >> +       rtnl_register(PF_UNSPEC, RTM_DELALTIFNAME, rtnl_delaltifname, NULL, 0);
> >> +
> >>         rtnl_register(PF_BRIDGE, RTM_NEWNEIGH, rtnl_fdb_add, NULL, 0);
> >>         rtnl_register(PF_BRIDGE, RTM_DELNEIGH, rtnl_fdb_del, NULL, 0);
> >>         rtnl_register(PF_BRIDGE, RTM_GETNEIGH, rtnl_fdb_get, rtnl_fdb_dump, 0);
> >> diff --git a/security/selinux/nlmsgtab.c b/security/selinux/nlmsgtab.c
> >> index 58345ba0528e..a712b54c666c 100644
> >> --- a/security/selinux/nlmsgtab.c
> >> +++ b/security/selinux/nlmsgtab.c
> >> @@ -83,6 +83,8 @@ static const struct nlmsg_perm nlmsg_route_perms[] =
> >>         { RTM_NEWNEXTHOP,       NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
> >>         { RTM_DELNEXTHOP,       NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
> >>         { RTM_GETNEXTHOP,       NETLINK_ROUTE_SOCKET__NLMSG_READ  },
> >> +       { RTM_NEWALTIFNAME,     NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
> >> +       { RTM_DELALTIFNAME,     NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
> >>  };
> >>
> >>  static const struct nlmsg_perm nlmsg_tcpdiag_perms[] =
> >> @@ -166,7 +168,7 @@ int selinux_nlmsg_lookup(u16 sclass, u16 nlmsg_type, u32 *perm)
> >>                  * structures at the top of this file with the new mappings
> >>                  * before updating the BUILD_BUG_ON() macro!
> >>                  */
> >> -               BUILD_BUG_ON(RTM_MAX != (RTM_NEWNEXTHOP + 3));
> >> +               BUILD_BUG_ON(RTM_MAX != (RTM_NEWALTIFNAME + 3));
> >>                 err = nlmsg_perm(nlmsg_type, perm, nlmsg_route_perms,
> >>                                  sizeof(nlmsg_route_perms));
> >>                 break;
> >> --
> >> 2.21.0
> >>
