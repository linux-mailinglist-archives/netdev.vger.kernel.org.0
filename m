Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8359D295C2C
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 11:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896135AbgJVJrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 05:47:12 -0400
Received: from latitanza.investici.org ([82.94.249.234]:34589 "EHLO
        latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2509987AbgJVJrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 05:47:10 -0400
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Oct 2020 05:47:07 EDT
Received: from mx3.investici.org (unknown [127.0.0.1])
        by latitanza.investici.org (Postfix) with ESMTP id 4CH2SD3rp9z8shV;
        Thu, 22 Oct 2020 09:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=privacyrequired.com;
        s=stigmate; t=1603359692;
        bh=Pl/AMFfbFwFf0HmKijz+gPWff16a+jWI5Uu1Vg5KusM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PJz3JE/SQMJR5Wh9tQ2ik5ELdRxB5XkgUSxbWGMNh6atQ1ZqzIoMuQ0uXYfC0sSbt
         tcM3kukJOCERHLxxPK+VX57MMZjFgAnyj7WojYE4DDRq52TQgpKk82RTH7YnL2we25
         ARiDvxsGpuPl48E8rB+hDe8C0w/bVHyPmctLu+1w=
Received: from [82.94.249.234] (mx3.investici.org [82.94.249.234]) (Authenticated sender: laniel_francis@privacyrequired.com) by localhost (Postfix) with ESMTPSA id 4CH2SD04NSz8sfy;
        Thu, 22 Oct 2020 09:41:31 +0000 (UTC)
From:   Francis Laniel <laniel_francis@privacyrequired.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-hardening@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [RFC][PATCH v3 3/3] Rename nla_strlcpy to nla_strscpy.
Date:   Thu, 22 Oct 2020 11:41:31 +0200
Message-ID: <2286512.66XcFyAlgq@machine>
In-Reply-To: <202010211649.ABD53841B@keescook>
References: <20201020164707.30402-1-laniel_francis@privacyrequired.com> <20201020164707.30402-4-laniel_francis@privacyrequired.com> <202010211649.ABD53841B@keescook>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le jeudi 22 octobre 2020, 01:49:59 CEST Kees Cook a =E9crit :
> On Tue, Oct 20, 2020 at 06:47:07PM +0200, laniel_francis@privacyrequired.=
com=20
wrote:
> > From: Francis Laniel <laniel_francis@privacyrequired.com>
> >=20
> > Calls to nla_strlcpy are now replaced by calls to nla_strscpy which is =
the
> > new name of this function.
> >=20
> > Signed-off-by: Francis Laniel <laniel_francis@privacyrequired.com>
>=20
> The Subject could also be: "treewide: Rename nla_strlcpy to nla_strscpy"
>=20
> But otherwise, yup, easy mechanical change.

Should I submit a v4 for this change?

>=20
> Reviewed-by: Kees Cook <keescook@chromium.org>
>=20
> > ---
> >=20
> >  drivers/infiniband/core/nldev.c            | 10 +++++-----
> >  drivers/net/can/vxcan.c                    |  4 ++--
> >  drivers/net/veth.c                         |  4 ++--
> >  include/linux/genl_magic_struct.h          |  2 +-
> >  include/net/netlink.h                      |  4 ++--
> >  include/net/pkt_cls.h                      |  2 +-
> >  kernel/taskstats.c                         |  2 +-
> >  lib/nlattr.c                               |  6 +++---
> >  net/core/fib_rules.c                       |  4 ++--
> >  net/core/rtnetlink.c                       | 12 ++++++------
> >  net/decnet/dn_dev.c                        |  2 +-
> >  net/ieee802154/nl-mac.c                    |  2 +-
> >  net/ipv4/devinet.c                         |  2 +-
> >  net/ipv4/fib_semantics.c                   |  2 +-
> >  net/ipv4/metrics.c                         |  2 +-
> >  net/netfilter/ipset/ip_set_hash_netiface.c |  4 ++--
> >  net/netfilter/nf_tables_api.c              |  6 +++---
> >  net/netfilter/nfnetlink_acct.c             |  2 +-
> >  net/netfilter/nfnetlink_cthelper.c         |  4 ++--
> >  net/netfilter/nft_ct.c                     |  2 +-
> >  net/netfilter/nft_log.c                    |  2 +-
> >  net/netlabel/netlabel_mgmt.c               |  2 +-
> >  net/nfc/netlink.c                          |  2 +-
> >  net/sched/act_api.c                        |  2 +-
> >  net/sched/act_ipt.c                        |  2 +-
> >  net/sched/act_simple.c                     |  4 ++--
> >  net/sched/cls_api.c                        |  2 +-
> >  net/sched/sch_api.c                        |  2 +-
> >  net/tipc/netlink_compat.c                  |  2 +-
> >  29 files changed, 49 insertions(+), 49 deletions(-)
> >=20
> > diff --git a/drivers/infiniband/core/nldev.c
> > b/drivers/infiniband/core/nldev.c index 12d29d54a081..08366e254b1d 1006=
44
> > --- a/drivers/infiniband/core/nldev.c
> > +++ b/drivers/infiniband/core/nldev.c
> > @@ -932,7 +932,7 @@ static int nldev_set_doit(struct sk_buff *skb, stru=
ct
> > nlmsghdr *nlh,>=20
> >  	if (tb[RDMA_NLDEV_ATTR_DEV_NAME]) {
> >  =09
> >  		char name[IB_DEVICE_NAME_MAX] =3D {};
> >=20
> > -		nla_strlcpy(name, tb[RDMA_NLDEV_ATTR_DEV_NAME],
> > +		nla_strscpy(name, tb[RDMA_NLDEV_ATTR_DEV_NAME],
> >=20
> >  			    IB_DEVICE_NAME_MAX);
> >  	=09
> >  		if (strlen(name) =3D=3D 0) {
> >  	=09
> >  			err =3D -EINVAL;
> >=20
> > @@ -1529,13 +1529,13 @@ static int nldev_newlink(struct sk_buff *skb,
> > struct nlmsghdr *nlh,>=20
> >  	    !tb[RDMA_NLDEV_ATTR_LINK_TYPE] || !tb[RDMA_NLDEV_ATTR_NDEV_NAME])
> >  	=09
> >  		return -EINVAL;
> >=20
> > -	nla_strlcpy(ibdev_name, tb[RDMA_NLDEV_ATTR_DEV_NAME],
> > +	nla_strscpy(ibdev_name, tb[RDMA_NLDEV_ATTR_DEV_NAME],
> >=20
> >  		    sizeof(ibdev_name));
> >  =09
> >  	if (strchr(ibdev_name, '%') || strlen(ibdev_name) =3D=3D 0)
> >  =09
> >  		return -EINVAL;
> >=20
> > -	nla_strlcpy(type, tb[RDMA_NLDEV_ATTR_LINK_TYPE], sizeof(type));
> > -	nla_strlcpy(ndev_name, tb[RDMA_NLDEV_ATTR_NDEV_NAME],
> > +	nla_strscpy(type, tb[RDMA_NLDEV_ATTR_LINK_TYPE], sizeof(type));
> > +	nla_strscpy(ndev_name, tb[RDMA_NLDEV_ATTR_NDEV_NAME],
> >=20
> >  		    sizeof(ndev_name));
> >  =09
> >  	ndev =3D dev_get_by_name(sock_net(skb->sk), ndev_name);
> >=20
> > @@ -1602,7 +1602,7 @@ static int nldev_get_chardev(struct sk_buff *skb,
> > struct nlmsghdr *nlh,>=20
> >  	if (err || !tb[RDMA_NLDEV_ATTR_CHARDEV_TYPE])
> >  =09
> >  		return -EINVAL;
> >=20
> > -	nla_strlcpy(client_name, tb[RDMA_NLDEV_ATTR_CHARDEV_TYPE],
> > +	nla_strscpy(client_name, tb[RDMA_NLDEV_ATTR_CHARDEV_TYPE],
> >=20
> >  		    sizeof(client_name));
> >  =09
> >  	if (tb[RDMA_NLDEV_ATTR_DEV_INDEX]) {
> >=20
> > diff --git a/drivers/net/can/vxcan.c b/drivers/net/can/vxcan.c
> > index d6ba9426be4d..fa47bab510bb 100644
> > --- a/drivers/net/can/vxcan.c
> > +++ b/drivers/net/can/vxcan.c
> > @@ -186,7 +186,7 @@ static int vxcan_newlink(struct net *net, struct
> > net_device *dev,>=20
> >  	}
> >  =09
> >  	if (ifmp && tbp[IFLA_IFNAME]) {
> >=20
> > -		nla_strlcpy(ifname, tbp[IFLA_IFNAME], IFNAMSIZ);
> > +		nla_strscpy(ifname, tbp[IFLA_IFNAME], IFNAMSIZ);
> >=20
> >  		name_assign_type =3D NET_NAME_USER;
> >  =09
> >  	} else {
> >  =09
> >  		snprintf(ifname, IFNAMSIZ, DRV_NAME "%%d");
> >=20
> > @@ -223,7 +223,7 @@ static int vxcan_newlink(struct net *net, struct
> > net_device *dev,>=20
> >  	/* register first device */
> >  	if (tb[IFLA_IFNAME])
> >=20
> > -		nla_strlcpy(dev->name, tb[IFLA_IFNAME], IFNAMSIZ);
> > +		nla_strscpy(dev->name, tb[IFLA_IFNAME], IFNAMSIZ);
> >=20
> >  	else
> >  =09
> >  		snprintf(dev->name, IFNAMSIZ, DRV_NAME "%%d");
> >=20
> > diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> > index 8c737668008a..359d3ab33c4d 100644
> > --- a/drivers/net/veth.c
> > +++ b/drivers/net/veth.c
> > @@ -1329,7 +1329,7 @@ static int veth_newlink(struct net *src_net, stru=
ct
> > net_device *dev,>=20
> >  	}
> >  =09
> >  	if (ifmp && tbp[IFLA_IFNAME]) {
> >=20
> > -		nla_strlcpy(ifname, tbp[IFLA_IFNAME], IFNAMSIZ);
> > +		nla_strscpy(ifname, tbp[IFLA_IFNAME], IFNAMSIZ);
> >=20
> >  		name_assign_type =3D NET_NAME_USER;
> >  =09
> >  	} else {
> >  =09
> >  		snprintf(ifname, IFNAMSIZ, DRV_NAME "%%d");
> >=20
> > @@ -1379,7 +1379,7 @@ static int veth_newlink(struct net *src_net, stru=
ct
> > net_device *dev,>=20
> >  		eth_hw_addr_random(dev);
> >  =09
> >  	if (tb[IFLA_IFNAME])
> >=20
> > -		nla_strlcpy(dev->name, tb[IFLA_IFNAME], IFNAMSIZ);
> > +		nla_strscpy(dev->name, tb[IFLA_IFNAME], IFNAMSIZ);
> >=20
> >  	else
> >  =09
> >  		snprintf(dev->name, IFNAMSIZ, DRV_NAME "%%d");
> >=20
> > diff --git a/include/linux/genl_magic_struct.h
> > b/include/linux/genl_magic_struct.h index eeae59d3ceb7..35d21fddaf2d
> > 100644
> > --- a/include/linux/genl_magic_struct.h
> > +++ b/include/linux/genl_magic_struct.h
> > @@ -89,7 +89,7 @@ static inline int nla_put_u64_0pad(struct sk_buff *sk=
b,
> > int attrtype, u64 value)>=20
> >  			nla_get_u64, nla_put_u64_0pad, false)
> > =20
> >  #define __str_field(attr_nr, attr_flag, name, maxlen) \
> > =20
> >  	__array(attr_nr, attr_flag, name, NLA_NUL_STRING, char, maxlen, \
> >=20
> > -			nla_strlcpy, nla_put, false)
> > +			nla_strscpy, nla_put, false)
> >=20
> >  #define __bin_field(attr_nr, attr_flag, name, maxlen) \
> > =20
> >  	__array(attr_nr, attr_flag, name, NLA_BINARY, char, maxlen, \
> >  =09
> >  			nla_memcpy, nla_put, false)
> >=20
> > diff --git a/include/net/netlink.h b/include/net/netlink.h
> > index 446ca182e13d..1ceec518ab49 100644
> > --- a/include/net/netlink.h
> > +++ b/include/net/netlink.h
> > @@ -142,7 +142,7 @@
> >=20
> >   * Attribute Misc:
> >   *   nla_memcpy(dest, nla, count)	copy attribute into memory
> >   *   nla_memcmp(nla, data, size)	compare attribute with memory area
> >=20
> > - *   nla_strlcpy(dst, nla, size)	copy attribute to a sized string
> > + *   nla_strscpy(dst, nla, size)	copy attribute to a sized string
> >=20
> >   *   nla_strcmp(nla, str)		compare attribute with string
> >   *
> >=20
> >   * Attribute Parsing:
> > @@ -506,7 +506,7 @@ int __nla_parse(struct nlattr **tb, int maxtype, co=
nst
> > struct nlattr *head,>=20
> >  		struct netlink_ext_ack *extack);
> > =20
> >  int nla_policy_len(const struct nla_policy *, int);
> >  struct nlattr *nla_find(const struct nlattr *head, int len, int
> >  attrtype);
> >=20
> > -ssize_t nla_strlcpy(char *dst, const struct nlattr *nla, size_t dstsiz=
e);
> > +ssize_t nla_strscpy(char *dst, const struct nlattr *nla, size_t dstsiz=
e);
> >=20
> >  char *nla_strdup(const struct nlattr *nla, gfp_t flags);
> >  int nla_memcpy(void *dest, const struct nlattr *src, int count);
> >  int nla_memcmp(const struct nlattr *nla, const void *data, size_t size=
);
> >=20
> > diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
> > index db9a828f4f4f..133f9ad4d4f9 100644
> > --- a/include/net/pkt_cls.h
> > +++ b/include/net/pkt_cls.h
> > @@ -512,7 +512,7 @@ tcf_change_indev(struct net *net, struct nlattr
> > *indev_tlv,>=20
> >  	char indev[IFNAMSIZ];
> >  	struct net_device *dev;
> >=20
> > -	if (nla_strlcpy(indev, indev_tlv, IFNAMSIZ) < 0) {
> > +	if (nla_strscpy(indev, indev_tlv, IFNAMSIZ) < 0) {
> >=20
> >  		NL_SET_ERR_MSG_ATTR(extack, indev_tlv,
> >  	=09
> >  				    "Interface name too long");
> >  	=09
> >  		return -EINVAL;
> >=20
> > diff --git a/kernel/taskstats.c b/kernel/taskstats.c
> > index a2802b6ff4bb..2b4898b4752e 100644
> > --- a/kernel/taskstats.c
> > +++ b/kernel/taskstats.c
> > @@ -346,7 +346,7 @@ static int parse(struct nlattr *na, struct cpumask
> > *mask)>=20
> >  	data =3D kmalloc(len, GFP_KERNEL);
> >  	if (!data)
> >  =09
> >  		return -ENOMEM;
> >=20
> > -	nla_strlcpy(data, na, len);
> > +	nla_strscpy(data, na, len);
> >=20
> >  	ret =3D cpulist_parse(data, mask);
> >  	kfree(data);
> >  	return ret;
> >=20
> > diff --git a/lib/nlattr.c b/lib/nlattr.c
> > index 447182543c03..09aa181569e0 100644
> > --- a/lib/nlattr.c
> > +++ b/lib/nlattr.c
> > @@ -709,7 +709,7 @@ struct nlattr *nla_find(const struct nlattr *head, =
int
> > len, int attrtype)>=20
> >  EXPORT_SYMBOL(nla_find);
> > =20
> >  /**
> >=20
> > - * nla_strlcpy - Copy string attribute payload into a sized buffer
> > + * nla_strscpy - Copy string attribute payload into a sized buffer
> >=20
> >   * @dst: Where to copy the string to.
> >   * @nla: Attribute to copy the string from.
> >   * @dstsize: Size of destination buffer.
> >=20
> > @@ -722,7 +722,7 @@ EXPORT_SYMBOL(nla_find);
> >=20
> >   * * -E2BIG - If @dstsize is 0 or greater than U16_MAX or @nla length
> >   greater *            than @dstsize.
> >   */
> >=20
> > -ssize_t nla_strlcpy(char *dst, const struct nlattr *nla, size_t dstsiz=
e)
> > +ssize_t nla_strscpy(char *dst, const struct nlattr *nla, size_t dstsiz=
e)
> >=20
> >  {
> > =20
> >  	size_t srclen =3D nla_len(nla);
> >  	char *src =3D nla_data(nla);
> >=20
> > @@ -749,7 +749,7 @@ ssize_t nla_strlcpy(char *dst, const struct nlattr
> > *nla, size_t dstsize)>=20
> >  	return ret;
> > =20
> >  }
> >=20
> > -EXPORT_SYMBOL(nla_strlcpy);
> > +EXPORT_SYMBOL(nla_strscpy);
> >=20
> >  /**
> > =20
> >   * nla_strdup - Copy string attribute payload into a newly allocated
> >   buffer
> >=20
> > diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
> > index 7bcfb16854cb..cd80ffed6d26 100644
> > --- a/net/core/fib_rules.c
> > +++ b/net/core/fib_rules.c
> > @@ -563,7 +563,7 @@ static int fib_nl2rule(struct sk_buff *skb, struct
> > nlmsghdr *nlh,>=20
> >  		struct net_device *dev;
> >  	=09
> >  		nlrule->iifindex =3D -1;
> >=20
> > -		nla_strlcpy(nlrule->iifname, tb[FRA_IIFNAME], IFNAMSIZ);
> > +		nla_strscpy(nlrule->iifname, tb[FRA_IIFNAME], IFNAMSIZ);
> >=20
> >  		dev =3D __dev_get_by_name(net, nlrule->iifname);
> >  		if (dev)
> >  	=09
> >  			nlrule->iifindex =3D dev->ifindex;
> >=20
> > @@ -573,7 +573,7 @@ static int fib_nl2rule(struct sk_buff *skb, struct
> > nlmsghdr *nlh,>=20
> >  		struct net_device *dev;
> >  	=09
> >  		nlrule->oifindex =3D -1;
> >=20
> > -		nla_strlcpy(nlrule->oifname, tb[FRA_OIFNAME], IFNAMSIZ);
> > +		nla_strscpy(nlrule->oifname, tb[FRA_OIFNAME], IFNAMSIZ);
> >=20
> >  		dev =3D __dev_get_by_name(net, nlrule->oifname);
> >  		if (dev)
> >  	=09
> >  			nlrule->oifindex =3D dev->ifindex;
> >=20
> > diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> > index 68e0682450c6..e0059256fe93 100644
> > --- a/net/core/rtnetlink.c
> > +++ b/net/core/rtnetlink.c
> > @@ -1939,7 +1939,7 @@ static const struct rtnl_link_ops
> > *linkinfo_to_kind_ops(const struct nlattr *nla>=20
> >  	if (linfo[IFLA_INFO_KIND]) {
> >  =09
> >  		char kind[MODULE_NAME_LEN];
> >=20
> > -		nla_strlcpy(kind, linfo[IFLA_INFO_KIND], sizeof(kind));
> > +		nla_strscpy(kind, linfo[IFLA_INFO_KIND], sizeof(kind));
> >=20
> >  		ops =3D rtnl_link_ops_get(kind);
> >  =09
> >  	}
> >=20
> > @@ -2953,9 +2953,9 @@ static struct net_device *rtnl_dev_get(struct net
> > *net,>=20
> >  	if (!ifname) {
> >  =09
> >  		ifname =3D buffer;
> >  		if (ifname_attr)
> >=20
> > -			nla_strlcpy(ifname, ifname_attr, IFNAMSIZ);
> > +			nla_strscpy(ifname, ifname_attr, IFNAMSIZ);
> >=20
> >  		else if (altifname_attr)
> >=20
> > -			nla_strlcpy(ifname, altifname_attr, ALTIFNAMSIZ);
> > +			nla_strscpy(ifname, altifname_attr, ALTIFNAMSIZ);
> >=20
> >  		else
> >  	=09
> >  			return NULL;
> >  =09
> >  	}
> >=20
> > @@ -2983,7 +2983,7 @@ static int rtnl_setlink(struct sk_buff *skb, stru=
ct
> > nlmsghdr *nlh,>=20
> >  		goto errout;
> >  =09
> >  	if (tb[IFLA_IFNAME])
> >=20
> > -		nla_strlcpy(ifname, tb[IFLA_IFNAME], IFNAMSIZ);
> > +		nla_strscpy(ifname, tb[IFLA_IFNAME], IFNAMSIZ);
> >=20
> >  	else
> >  =09
> >  		ifname[0] =3D '\0';
> >=20
> > @@ -3264,7 +3264,7 @@ static int __rtnl_newlink(struct sk_buff *skb,
> > struct nlmsghdr *nlh,>=20
> >  		return err;
> >  =09
> >  	if (tb[IFLA_IFNAME])
> >=20
> > -		nla_strlcpy(ifname, tb[IFLA_IFNAME], IFNAMSIZ);
> > +		nla_strscpy(ifname, tb[IFLA_IFNAME], IFNAMSIZ);
> >=20
> >  	else
> >  =09
> >  		ifname[0] =3D '\0';
> >=20
> > @@ -3296,7 +3296,7 @@ static int __rtnl_newlink(struct sk_buff *skb,
> > struct nlmsghdr *nlh,>=20
> >  		memset(linkinfo, 0, sizeof(linkinfo));
> >  =09
> >  	if (linkinfo[IFLA_INFO_KIND]) {
> >=20
> > -		nla_strlcpy(kind, linkinfo[IFLA_INFO_KIND], sizeof(kind));
> > +		nla_strscpy(kind, linkinfo[IFLA_INFO_KIND], sizeof(kind));
> >=20
> >  		ops =3D rtnl_link_ops_get(kind);
> >  =09
> >  	} else {
> >  =09
> >  		kind[0] =3D '\0';
> >=20
> > diff --git a/net/decnet/dn_dev.c b/net/decnet/dn_dev.c
> > index 15d42353f1a3..d1c50a48614b 100644
> > --- a/net/decnet/dn_dev.c
> > +++ b/net/decnet/dn_dev.c
> > @@ -658,7 +658,7 @@ static int dn_nl_newaddr(struct sk_buff *skb, struct
> > nlmsghdr *nlh,>=20
> >  	ifa->ifa_dev =3D dn_db;
> >  =09
> >  	if (tb[IFA_LABEL])
> >=20
> > -		nla_strlcpy(ifa->ifa_label, tb[IFA_LABEL], IFNAMSIZ);
> > +		nla_strscpy(ifa->ifa_label, tb[IFA_LABEL], IFNAMSIZ);
> >=20
> >  	else
> >  =09
> >  		memcpy(ifa->ifa_label, dev->name, IFNAMSIZ);
> >=20
> > diff --git a/net/ieee802154/nl-mac.c b/net/ieee802154/nl-mac.c
> > index 6d091e419d3e..9c640d670ffe 100644
> > --- a/net/ieee802154/nl-mac.c
> > +++ b/net/ieee802154/nl-mac.c
> > @@ -149,7 +149,7 @@ static struct net_device *ieee802154_nl_get_dev(str=
uct
> > genl_info *info)>=20
> >  	if (info->attrs[IEEE802154_ATTR_DEV_NAME]) {
> >  =09
> >  		char name[IFNAMSIZ + 1];
> >=20
> > -		nla_strlcpy(name, info->attrs[IEEE802154_ATTR_DEV_NAME],
> > +		nla_strscpy(name, info->attrs[IEEE802154_ATTR_DEV_NAME],
> >=20
> >  			    sizeof(name));
> >  	=09
> >  		dev =3D dev_get_by_name(&init_net, name);
> >  =09
> >  	} else if (info->attrs[IEEE802154_ATTR_DEV_INDEX]) {
> >=20
> > diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
> > index 123a6d39438f..a50951a90f63 100644
> > --- a/net/ipv4/devinet.c
> > +++ b/net/ipv4/devinet.c
> > @@ -881,7 +881,7 @@ static struct in_ifaddr *rtm_to_ifaddr(struct net
> > *net, struct nlmsghdr *nlh,>=20
> >  		ifa->ifa_broadcast =3D nla_get_in_addr(tb[IFA_BROADCAST]);
> >  =09
> >  	if (tb[IFA_LABEL])
> >=20
> > -		nla_strlcpy(ifa->ifa_label, tb[IFA_LABEL], IFNAMSIZ);
> > +		nla_strscpy(ifa->ifa_label, tb[IFA_LABEL], IFNAMSIZ);
> >=20
> >  	else
> >  =09
> >  		memcpy(ifa->ifa_label, dev->name, IFNAMSIZ);
> >=20
> > diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
> > index 1f75dc686b6b..4b505074b24f 100644
> > --- a/net/ipv4/fib_semantics.c
> > +++ b/net/ipv4/fib_semantics.c
> > @@ -973,7 +973,7 @@ bool fib_metrics_match(struct fib_config *cfg, stru=
ct
> > fib_info *fi)>=20
> >  			char tmp[TCP_CA_NAME_MAX];
> >  			bool ecn_ca =3D false;
> >=20
> > -			nla_strlcpy(tmp, nla, sizeof(tmp));
> > +			nla_strscpy(tmp, nla, sizeof(tmp));
> >=20
> >  			val =3D tcp_ca_get_key_by_name(fi->fib_net, tmp, &ecn_ca);
> >  	=09
> >  		} else {
> >  	=09
> >  			if (nla_len(nla) !=3D sizeof(u32))
> >=20
> > diff --git a/net/ipv4/metrics.c b/net/ipv4/metrics.c
> > index 3205d5f7c8c9..25ea6ac44db9 100644
> > --- a/net/ipv4/metrics.c
> > +++ b/net/ipv4/metrics.c
> > @@ -31,7 +31,7 @@ static int ip_metrics_convert(struct net *net, struct
> > nlattr *fc_mx,>=20
> >  		if (type =3D=3D RTAX_CC_ALGO) {
> >  	=09
> >  			char tmp[TCP_CA_NAME_MAX];
> >=20
> > -			nla_strlcpy(tmp, nla, sizeof(tmp));
> > +			nla_strscpy(tmp, nla, sizeof(tmp));
> >=20
> >  			val =3D tcp_ca_get_key_by_name(net, tmp, &ecn_ca);
> >  			if (val =3D=3D TCP_CA_UNSPEC) {
> >  		=09
> >  				NL_SET_ERR_MSG(extack, "Unknown tcp congestion algorithm");
> >=20
> > diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c
> > b/net/netfilter/ipset/ip_set_hash_netiface.c index
> > be5e95a0d876..b96fd0c55eaa 100644
> > --- a/net/netfilter/ipset/ip_set_hash_netiface.c
> > +++ b/net/netfilter/ipset/ip_set_hash_netiface.c
> > @@ -225,7 +225,7 @@ hash_netiface4_uadt(struct ip_set *set, struct nlat=
tr
> > *tb[],>=20
> >  		if (e.cidr > HOST_MASK)
> >  	=09
> >  			return -IPSET_ERR_INVALID_CIDR;
> >  =09
> >  	}
> >=20
> > -	nla_strlcpy(e.iface, tb[IPSET_ATTR_IFACE], IFNAMSIZ);
> > +	nla_strscpy(e.iface, tb[IPSET_ATTR_IFACE], IFNAMSIZ);
> >=20
> >  	if (tb[IPSET_ATTR_CADT_FLAGS]) {
> >  =09
> >  		u32 cadt_flags =3D ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
> >=20
> > @@ -442,7 +442,7 @@ hash_netiface6_uadt(struct ip_set *set, struct nlat=
tr
> > *tb[],>=20
> >  	ip6_netmask(&e.ip, e.cidr);
> >=20
> > -	nla_strlcpy(e.iface, tb[IPSET_ATTR_IFACE], IFNAMSIZ);
> > +	nla_strscpy(e.iface, tb[IPSET_ATTR_IFACE], IFNAMSIZ);
> >=20
> >  	if (tb[IPSET_ATTR_CADT_FLAGS]) {
> >  =09
> >  		u32 cadt_flags =3D ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
> >=20
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_ap=
i.c
> > index 9957e0ed8658..90c39e694e87 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -1281,7 +1281,7 @@ static struct nft_chain *nft_chain_lookup(struct =
net
> > *net,>=20
> >  	if (nla =3D=3D NULL)
> >  =09
> >  		return ERR_PTR(-EINVAL);
> >=20
> > -	nla_strlcpy(search, nla, sizeof(search));
> > +	nla_strscpy(search, nla, sizeof(search));
> >=20
> >  	WARN_ON(!rcu_read_lock_held() &&
> >  =09
> >  		!lockdep_commit_lock_is_held(net));
> >=20
> > @@ -1721,7 +1721,7 @@ static struct nft_hook *nft_netdev_hook_alloc(str=
uct
> > net *net,>=20
> >  		goto err_hook_alloc;
> >  =09
> >  	}
> >=20
> > -	nla_strlcpy(ifname, attr, IFNAMSIZ);
> > +	nla_strscpy(ifname, attr, IFNAMSIZ);
> >=20
> >  	dev =3D __dev_get_by_name(net, ifname);
> >  	if (!dev) {
> >  =09
> >  		err =3D -ENOENT;
> >=20
> > @@ -5734,7 +5734,7 @@ struct nft_object *nft_obj_lookup(const struct net
> > *net,>=20
> >  	struct rhlist_head *tmp, *list;
> >  	struct nft_object *obj;
> >=20
> > -	nla_strlcpy(search, nla, sizeof(search));
> > +	nla_strscpy(search, nla, sizeof(search));
> >=20
> >  	k.name =3D search;
> >  =09
> >  	WARN_ON_ONCE(!rcu_read_lock_held() &&
> >=20
> > diff --git a/net/netfilter/nfnetlink_acct.c
> > b/net/netfilter/nfnetlink_acct.c index 5bfec829c12f..5e511df8d709 100644
> > --- a/net/netfilter/nfnetlink_acct.c
> > +++ b/net/netfilter/nfnetlink_acct.c
> > @@ -112,7 +112,7 @@ static int nfnl_acct_new(struct net *net, struct so=
ck
> > *nfnl,>=20
> >  		nfacct->flags =3D flags;
> >  =09
> >  	}
> >=20
> > -	nla_strlcpy(nfacct->name, tb[NFACCT_NAME], NFACCT_NAME_MAX);
> > +	nla_strscpy(nfacct->name, tb[NFACCT_NAME], NFACCT_NAME_MAX);
> >=20
> >  	if (tb[NFACCT_BYTES]) {
> >  =09
> >  		atomic64_set(&nfacct->bytes,
> >=20
> > diff --git a/net/netfilter/nfnetlink_cthelper.c
> > b/net/netfilter/nfnetlink_cthelper.c index 5b0d0a77379c..0f94fce1d3ed
> > 100644
> > --- a/net/netfilter/nfnetlink_cthelper.c
> > +++ b/net/netfilter/nfnetlink_cthelper.c
> > @@ -146,7 +146,7 @@ nfnl_cthelper_expect_policy(struct
> > nf_conntrack_expect_policy *expect_policy,>=20
> >  	    !tb[NFCTH_POLICY_EXPECT_TIMEOUT])
> >  	=09
> >  		return -EINVAL;
> >=20
> > -	nla_strlcpy(expect_policy->name,
> > +	nla_strscpy(expect_policy->name,
> >=20
> >  		    tb[NFCTH_POLICY_NAME], NF_CT_HELPER_NAME_LEN);
> >  =09
> >  	expect_policy->max_expected =3D
> >  =09
> >  		ntohl(nla_get_be32(tb[NFCTH_POLICY_EXPECT_MAX]));
> >=20
> > @@ -233,7 +233,7 @@ nfnl_cthelper_create(const struct nlattr * const tb=
[],
> >=20
> >  	if (ret < 0)
> >  =09
> >  		goto err1;
> >=20
> > -	nla_strlcpy(helper->name,
> > +	nla_strscpy(helper->name,
> >=20
> >  		    tb[NFCTH_NAME], NF_CT_HELPER_NAME_LEN);
> >  =09
> >  	size =3D ntohl(nla_get_be32(tb[NFCTH_PRIV_DATA_LEN]));
> >  	if (size > sizeof_field(struct nf_conn_help, data)) {
> >=20
> > diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
> > index 322bd674963e..a8c4d442231c 100644
> > --- a/net/netfilter/nft_ct.c
> > +++ b/net/netfilter/nft_ct.c
> > @@ -990,7 +990,7 @@ static int nft_ct_helper_obj_init(const struct nft_=
ctx
> > *ctx,>=20
> >  	if (!priv->l4proto)
> >  =09
> >  		return -ENOENT;
> >=20
> > -	nla_strlcpy(name, tb[NFTA_CT_HELPER_NAME], sizeof(name));
> > +	nla_strscpy(name, tb[NFTA_CT_HELPER_NAME], sizeof(name));
> >=20
> >  	if (tb[NFTA_CT_HELPER_L3PROTO])
> >  =09
> >  		family =3D ntohs(nla_get_be16(tb[NFTA_CT_HELPER_L3PROTO]));
> >=20
> > diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
> > index 57899454a530..a06a46b039c5 100644
> > --- a/net/netfilter/nft_log.c
> > +++ b/net/netfilter/nft_log.c
> > @@ -152,7 +152,7 @@ static int nft_log_init(const struct nft_ctx *ctx,
> >=20
> >  		priv->prefix =3D kmalloc(nla_len(nla) + 1, GFP_KERNEL);
> >  		if (priv->prefix =3D=3D NULL)
> >  	=09
> >  			return -ENOMEM;
> >=20
> > -		nla_strlcpy(priv->prefix, nla, nla_len(nla) + 1);
> > +		nla_strscpy(priv->prefix, nla, nla_len(nla) + 1);
> >=20
> >  	} else {
> >  =09
> >  		priv->prefix =3D (char *)nft_log_null_prefix;
> >  =09
> >  	}
> >=20
> > diff --git a/net/netlabel/netlabel_mgmt.c b/net/netlabel/netlabel_mgmt.c
> > index eb1d66d20afb..df1b41ed73fd 100644
> > --- a/net/netlabel/netlabel_mgmt.c
> > +++ b/net/netlabel/netlabel_mgmt.c
> > @@ -95,7 +95,7 @@ static int netlbl_mgmt_add_common(struct genl_info
> > *info,
> >=20
> >  			ret_val =3D -ENOMEM;
> >  			goto add_free_entry;
> >  	=09
> >  		}
> >=20
> > -		nla_strlcpy(entry->domain,
> > +		nla_strscpy(entry->domain,
> >=20
> >  			    info->attrs[NLBL_MGMT_A_DOMAIN], tmp_size);
> >  =09
> >  	}
> >=20
> > diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
> > index e894254c17d4..438ff1f30a33 100644
> > --- a/net/nfc/netlink.c
> > +++ b/net/nfc/netlink.c
> > @@ -1226,7 +1226,7 @@ static int nfc_genl_fw_download(struct sk_buff *s=
kb,
> > struct genl_info *info)>=20
> >  	if (!dev)
> >  =09
> >  		return -ENODEV;
> >=20
> > -	nla_strlcpy(firmware_name, info->attrs[NFC_ATTR_FIRMWARE_NAME],
> > +	nla_strscpy(firmware_name, info->attrs[NFC_ATTR_FIRMWARE_NAME],
> >=20
> >  		    sizeof(firmware_name));
> >  =09
> >  	rc =3D nfc_fw_download(dev, firmware_name);
> >=20
> > diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> > index 541574520c52..eac24a73115f 100644
> > --- a/net/sched/act_api.c
> > +++ b/net/sched/act_api.c
> > @@ -935,7 +935,7 @@ struct tc_action *tcf_action_init_1(struct net *net,
> > struct tcf_proto *tp,>=20
> >  			NL_SET_ERR_MSG(extack, "TC action kind must be specified");
> >  			goto err_out;
> >  	=09
> >  		}
> >=20
> > -		if (nla_strlcpy(act_name, kind, IFNAMSIZ) < 0) {
> > +		if (nla_strscpy(act_name, kind, IFNAMSIZ) < 0) {
> >=20
> >  			NL_SET_ERR_MSG(extack, "TC action name too long");
> >  			goto err_out;
> >  	=09
> >  		}
> >=20
> > diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
> > index 8dc3bec0d325..ac7297f42355 100644
> > --- a/net/sched/act_ipt.c
> > +++ b/net/sched/act_ipt.c
> > @@ -166,7 +166,7 @@ static int __tcf_ipt_init(struct net *net, unsigned
> > int id, struct nlattr *nla,>=20
> >  	if (unlikely(!tname))
> >  =09
> >  		goto err1;
> >  =09
> >  	if (tb[TCA_IPT_TABLE] =3D=3D NULL ||
> >=20
> > -	    nla_strlcpy(tname, tb[TCA_IPT_TABLE], IFNAMSIZ) >=3D IFNAMSIZ)
> > +	    nla_strscpy(tname, tb[TCA_IPT_TABLE], IFNAMSIZ) >=3D IFNAMSIZ)
> >=20
> >  		strcpy(tname, "mangle");
> >  =09
> >  	t =3D kmemdup(td, td->u.target_size, GFP_KERNEL);
> >=20
> > diff --git a/net/sched/act_simple.c b/net/sched/act_simple.c
> > index a4f3d0f0daa9..726cc956d06f 100644
> > --- a/net/sched/act_simple.c
> > +++ b/net/sched/act_simple.c
> > @@ -52,7 +52,7 @@ static int alloc_defdata(struct tcf_defact *d, const
> > struct nlattr *defdata)>=20
> >  	d->tcfd_defdata =3D kzalloc(SIMP_MAX_DATA, GFP_KERNEL);
> >  	if (unlikely(!d->tcfd_defdata))
> >  =09
> >  		return -ENOMEM;
> >=20
> > -	nla_strlcpy(d->tcfd_defdata, defdata, SIMP_MAX_DATA);
> > +	nla_strscpy(d->tcfd_defdata, defdata, SIMP_MAX_DATA);
> >=20
> >  	return 0;
> > =20
> >  }
> >=20
> > @@ -71,7 +71,7 @@ static int reset_policy(struct tc_action *a, const
> > struct nlattr *defdata,>=20
> >  	spin_lock_bh(&d->tcf_lock);
> >  	goto_ch =3D tcf_action_set_ctrlact(a, p->action, goto_ch);
> >  	memset(d->tcfd_defdata, 0, SIMP_MAX_DATA);
> >=20
> > -	nla_strlcpy(d->tcfd_defdata, defdata, SIMP_MAX_DATA);
> > +	nla_strscpy(d->tcfd_defdata, defdata, SIMP_MAX_DATA);
> >=20
> >  	spin_unlock_bh(&d->tcf_lock);
> >  	if (goto_ch)
> >  =09
> >  		tcf_chain_put_by_act(goto_ch);
> >=20
> > diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> > index c78241c853a5..6ff3b817083a 100644
> > --- a/net/sched/cls_api.c
> > +++ b/net/sched/cls_api.c
> > @@ -223,7 +223,7 @@ static inline u32 tcf_auto_prio(struct tcf_proto *t=
p)
> >=20
> >  static bool tcf_proto_check_kind(struct nlattr *kind, char *name)
> >  {
> > =20
> >  	if (kind)
> >=20
> > -		return nla_strlcpy(name, kind, IFNAMSIZ) < 0;
> > +		return nla_strscpy(name, kind, IFNAMSIZ) < 0;
> >=20
> >  	memset(name, 0, IFNAMSIZ);
> >  	return false;
> > =20
> >  }
> >=20
> > diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
> > index f9b053b30a7b..cb4f30700c74 100644
> > --- a/net/sched/sch_api.c
> > +++ b/net/sched/sch_api.c
> > @@ -1170,7 +1170,7 @@ static struct Qdisc *qdisc_create(struct net_devi=
ce
> > *dev,>=20
> >  #ifdef CONFIG_MODULES
> > =20
> >  	if (ops =3D=3D NULL && kind !=3D NULL) {
> >  =09
> >  		char name[IFNAMSIZ];
> >=20
> > -		if (nla_strlcpy(name, kind, IFNAMSIZ) > 0) {
> > +		if (nla_strscpy(name, kind, IFNAMSIZ) > 0) {
> >=20
> >  			/* We dropped the RTNL semaphore in order to
> >  		=09
> >  			 * perform the module load.  So, even if we
> >  			 * succeeded in loading the module we have to
> >=20
> > diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
> > index 1c7aa51cc2a3..644c7ec41ddf 100644
> > --- a/net/tipc/netlink_compat.c
> > +++ b/net/tipc/netlink_compat.c
> > @@ -695,7 +695,7 @@ static int tipc_nl_compat_link_dump(struct
> > tipc_nl_compat_msg *msg,>=20
> >  	link_info.dest =3D nla_get_flag(link[TIPC_NLA_LINK_DEST]);
> >  	link_info.up =3D htonl(nla_get_flag(link[TIPC_NLA_LINK_UP]));
> >=20
> > -	nla_strlcpy(link_info.str, link[TIPC_NLA_LINK_NAME],
> > +	nla_strscpy(link_info.str, link[TIPC_NLA_LINK_NAME],
> >=20
> >  		    TIPC_MAX_LINK_NAME);
> >  =09
> >  	return tipc_add_tlv(msg->rep, TIPC_TLV_LINK_INFO,



