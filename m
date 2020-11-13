Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD4BF2B19B8
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 12:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgKMLNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 06:13:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726431AbgKMLN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 06:13:26 -0500
Received: from confino.investici.org (confino.investici.org [IPv6:2a00:c38:11e:ffff::a020])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B46C0617A6
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 03:13:25 -0800 (PST)
Received: from mx1.investici.org (unknown [127.0.0.1])
        by confino.investici.org (Postfix) with ESMTP id 4CXbQS4dRpz12W4;
        Fri, 13 Nov 2020 11:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=privacyrequired.com;
        s=stigmate; t=1605265920;
        bh=9GJSgaygYZ7K4AlfZz5fniMCQN4RejRnhLgP/H2yNoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A7cZXumNxN7fUvmMzHLf/61Txdf3sRLCMrX3D/jTC0/usn4I2YB/aoH1qo/+b31/r
         vbsgQ+s2yhFtd3IwDtcoygAOe7xXII25NBNAa1AT2QZbL8WCCdqr+yeILw0+1s/Jfk
         jNqVOH4U7PY6Q/mIb2ErTEbfmooPn6H6rRO3UjWA=
Received: from [212.103.72.250] (mx1.investici.org [212.103.72.250]) (Authenticated sender: laniel_francis@privacyrequired.com) by localhost (Postfix) with ESMTPSA id 4CXbQS2gmYz12WW;
        Fri, 13 Nov 2020 11:12:00 +0000 (UTC)
From:   laniel_francis@privacyrequired.com
To:     linux-hardening@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, keescook@chromium.org,
        Francis Laniel <laniel_francis@privacyrequired.com>
Subject: [PATCH v5 3/3] treewide: rename nla_strlcpy to nla_strscpy.
Date:   Fri, 13 Nov 2020 12:11:33 +0100
Message-Id: <20201113111133.15011-4-laniel_francis@privacyrequired.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201113111133.15011-1-laniel_francis@privacyrequired.com>
References: <20201113111133.15011-1-laniel_francis@privacyrequired.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Francis Laniel <laniel_francis@privacyrequired.com>

Calls to nla_strlcpy are now replaced by calls to nla_strscpy which is the new
name of this function.

Signed-off-by: Francis Laniel <laniel_francis@privacyrequired.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 drivers/infiniband/core/nldev.c            | 10 +++++-----
 drivers/net/can/vxcan.c                    |  4 ++--
 drivers/net/veth.c                         |  4 ++--
 include/linux/genl_magic_struct.h          |  2 +-
 include/net/netlink.h                      |  4 ++--
 include/net/pkt_cls.h                      |  2 +-
 kernel/taskstats.c                         |  2 +-
 lib/nlattr.c                               |  6 +++---
 net/core/fib_rules.c                       |  4 ++--
 net/core/rtnetlink.c                       | 12 ++++++------
 net/decnet/dn_dev.c                        |  2 +-
 net/ieee802154/nl-mac.c                    |  2 +-
 net/ipv4/devinet.c                         |  2 +-
 net/ipv4/fib_semantics.c                   |  2 +-
 net/ipv4/metrics.c                         |  2 +-
 net/netfilter/ipset/ip_set_hash_netiface.c |  4 ++--
 net/netfilter/nf_tables_api.c              |  6 +++---
 net/netfilter/nfnetlink_acct.c             |  2 +-
 net/netfilter/nfnetlink_cthelper.c         |  4 ++--
 net/netfilter/nft_ct.c                     |  2 +-
 net/netfilter/nft_log.c                    |  2 +-
 net/netlabel/netlabel_mgmt.c               |  2 +-
 net/nfc/netlink.c                          |  2 +-
 net/sched/act_api.c                        |  2 +-
 net/sched/act_ipt.c                        |  2 +-
 net/sched/act_simple.c                     |  4 ++--
 net/sched/cls_api.c                        |  2 +-
 net/sched/sch_api.c                        |  2 +-
 net/tipc/netlink_compat.c                  |  2 +-
 29 files changed, 49 insertions(+), 49 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 12d29d54a081..08366e254b1d 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -932,7 +932,7 @@ static int nldev_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (tb[RDMA_NLDEV_ATTR_DEV_NAME]) {
 		char name[IB_DEVICE_NAME_MAX] = {};
 
-		nla_strlcpy(name, tb[RDMA_NLDEV_ATTR_DEV_NAME],
+		nla_strscpy(name, tb[RDMA_NLDEV_ATTR_DEV_NAME],
 			    IB_DEVICE_NAME_MAX);
 		if (strlen(name) == 0) {
 			err = -EINVAL;
@@ -1529,13 +1529,13 @@ static int nldev_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	    !tb[RDMA_NLDEV_ATTR_LINK_TYPE] || !tb[RDMA_NLDEV_ATTR_NDEV_NAME])
 		return -EINVAL;
 
-	nla_strlcpy(ibdev_name, tb[RDMA_NLDEV_ATTR_DEV_NAME],
+	nla_strscpy(ibdev_name, tb[RDMA_NLDEV_ATTR_DEV_NAME],
 		    sizeof(ibdev_name));
 	if (strchr(ibdev_name, '%') || strlen(ibdev_name) == 0)
 		return -EINVAL;
 
-	nla_strlcpy(type, tb[RDMA_NLDEV_ATTR_LINK_TYPE], sizeof(type));
-	nla_strlcpy(ndev_name, tb[RDMA_NLDEV_ATTR_NDEV_NAME],
+	nla_strscpy(type, tb[RDMA_NLDEV_ATTR_LINK_TYPE], sizeof(type));
+	nla_strscpy(ndev_name, tb[RDMA_NLDEV_ATTR_NDEV_NAME],
 		    sizeof(ndev_name));
 
 	ndev = dev_get_by_name(sock_net(skb->sk), ndev_name);
@@ -1602,7 +1602,7 @@ static int nldev_get_chardev(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err || !tb[RDMA_NLDEV_ATTR_CHARDEV_TYPE])
 		return -EINVAL;
 
-	nla_strlcpy(client_name, tb[RDMA_NLDEV_ATTR_CHARDEV_TYPE],
+	nla_strscpy(client_name, tb[RDMA_NLDEV_ATTR_CHARDEV_TYPE],
 		    sizeof(client_name));
 
 	if (tb[RDMA_NLDEV_ATTR_DEV_INDEX]) {
diff --git a/drivers/net/can/vxcan.c b/drivers/net/can/vxcan.c
index d6ba9426be4d..fa47bab510bb 100644
--- a/drivers/net/can/vxcan.c
+++ b/drivers/net/can/vxcan.c
@@ -186,7 +186,7 @@ static int vxcan_newlink(struct net *net, struct net_device *dev,
 	}
 
 	if (ifmp && tbp[IFLA_IFNAME]) {
-		nla_strlcpy(ifname, tbp[IFLA_IFNAME], IFNAMSIZ);
+		nla_strscpy(ifname, tbp[IFLA_IFNAME], IFNAMSIZ);
 		name_assign_type = NET_NAME_USER;
 	} else {
 		snprintf(ifname, IFNAMSIZ, DRV_NAME "%%d");
@@ -223,7 +223,7 @@ static int vxcan_newlink(struct net *net, struct net_device *dev,
 
 	/* register first device */
 	if (tb[IFLA_IFNAME])
-		nla_strlcpy(dev->name, tb[IFLA_IFNAME], IFNAMSIZ);
+		nla_strscpy(dev->name, tb[IFLA_IFNAME], IFNAMSIZ);
 	else
 		snprintf(dev->name, IFNAMSIZ, DRV_NAME "%%d");
 
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 8c737668008a..359d3ab33c4d 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1329,7 +1329,7 @@ static int veth_newlink(struct net *src_net, struct net_device *dev,
 	}
 
 	if (ifmp && tbp[IFLA_IFNAME]) {
-		nla_strlcpy(ifname, tbp[IFLA_IFNAME], IFNAMSIZ);
+		nla_strscpy(ifname, tbp[IFLA_IFNAME], IFNAMSIZ);
 		name_assign_type = NET_NAME_USER;
 	} else {
 		snprintf(ifname, IFNAMSIZ, DRV_NAME "%%d");
@@ -1379,7 +1379,7 @@ static int veth_newlink(struct net *src_net, struct net_device *dev,
 		eth_hw_addr_random(dev);
 
 	if (tb[IFLA_IFNAME])
-		nla_strlcpy(dev->name, tb[IFLA_IFNAME], IFNAMSIZ);
+		nla_strscpy(dev->name, tb[IFLA_IFNAME], IFNAMSIZ);
 	else
 		snprintf(dev->name, IFNAMSIZ, DRV_NAME "%%d");
 
diff --git a/include/linux/genl_magic_struct.h b/include/linux/genl_magic_struct.h
index eeae59d3ceb7..35d21fddaf2d 100644
--- a/include/linux/genl_magic_struct.h
+++ b/include/linux/genl_magic_struct.h
@@ -89,7 +89,7 @@ static inline int nla_put_u64_0pad(struct sk_buff *skb, int attrtype, u64 value)
 			nla_get_u64, nla_put_u64_0pad, false)
 #define __str_field(attr_nr, attr_flag, name, maxlen) \
 	__array(attr_nr, attr_flag, name, NLA_NUL_STRING, char, maxlen, \
-			nla_strlcpy, nla_put, false)
+			nla_strscpy, nla_put, false)
 #define __bin_field(attr_nr, attr_flag, name, maxlen) \
 	__array(attr_nr, attr_flag, name, NLA_BINARY, char, maxlen, \
 			nla_memcpy, nla_put, false)
diff --git a/include/net/netlink.h b/include/net/netlink.h
index 446ca182e13d..1ceec518ab49 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -142,7 +142,7 @@
  * Attribute Misc:
  *   nla_memcpy(dest, nla, count)	copy attribute into memory
  *   nla_memcmp(nla, data, size)	compare attribute with memory area
- *   nla_strlcpy(dst, nla, size)	copy attribute to a sized string
+ *   nla_strscpy(dst, nla, size)	copy attribute to a sized string
  *   nla_strcmp(nla, str)		compare attribute with string
  *
  * Attribute Parsing:
@@ -506,7 +506,7 @@ int __nla_parse(struct nlattr **tb, int maxtype, const struct nlattr *head,
 		struct netlink_ext_ack *extack);
 int nla_policy_len(const struct nla_policy *, int);
 struct nlattr *nla_find(const struct nlattr *head, int len, int attrtype);
-ssize_t nla_strlcpy(char *dst, const struct nlattr *nla, size_t dstsize);
+ssize_t nla_strscpy(char *dst, const struct nlattr *nla, size_t dstsize);
 char *nla_strdup(const struct nlattr *nla, gfp_t flags);
 int nla_memcpy(void *dest, const struct nlattr *src, int count);
 int nla_memcmp(const struct nlattr *nla, const void *data, size_t size);
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index db9a828f4f4f..133f9ad4d4f9 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -512,7 +512,7 @@ tcf_change_indev(struct net *net, struct nlattr *indev_tlv,
 	char indev[IFNAMSIZ];
 	struct net_device *dev;
 
-	if (nla_strlcpy(indev, indev_tlv, IFNAMSIZ) < 0) {
+	if (nla_strscpy(indev, indev_tlv, IFNAMSIZ) < 0) {
 		NL_SET_ERR_MSG_ATTR(extack, indev_tlv,
 				    "Interface name too long");
 		return -EINVAL;
diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index a2802b6ff4bb..2b4898b4752e 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -346,7 +346,7 @@ static int parse(struct nlattr *na, struct cpumask *mask)
 	data = kmalloc(len, GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
-	nla_strlcpy(data, na, len);
+	nla_strscpy(data, na, len);
 	ret = cpulist_parse(data, mask);
 	kfree(data);
 	return ret;
diff --git a/lib/nlattr.c b/lib/nlattr.c
index 447182543c03..09aa181569e0 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -709,7 +709,7 @@ struct nlattr *nla_find(const struct nlattr *head, int len, int attrtype)
 EXPORT_SYMBOL(nla_find);
 
 /**
- * nla_strlcpy - Copy string attribute payload into a sized buffer
+ * nla_strscpy - Copy string attribute payload into a sized buffer
  * @dst: Where to copy the string to.
  * @nla: Attribute to copy the string from.
  * @dstsize: Size of destination buffer.
@@ -722,7 +722,7 @@ EXPORT_SYMBOL(nla_find);
  * * -E2BIG - If @dstsize is 0 or greater than U16_MAX or @nla length greater
  *            than @dstsize.
  */
-ssize_t nla_strlcpy(char *dst, const struct nlattr *nla, size_t dstsize)
+ssize_t nla_strscpy(char *dst, const struct nlattr *nla, size_t dstsize)
 {
 	size_t srclen = nla_len(nla);
 	char *src = nla_data(nla);
@@ -749,7 +749,7 @@ ssize_t nla_strlcpy(char *dst, const struct nlattr *nla, size_t dstsize)
 
 	return ret;
 }
-EXPORT_SYMBOL(nla_strlcpy);
+EXPORT_SYMBOL(nla_strscpy);
 
 /**
  * nla_strdup - Copy string attribute payload into a newly allocated buffer
diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index 7bcfb16854cb..cd80ffed6d26 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -563,7 +563,7 @@ static int fib_nl2rule(struct sk_buff *skb, struct nlmsghdr *nlh,
 		struct net_device *dev;
 
 		nlrule->iifindex = -1;
-		nla_strlcpy(nlrule->iifname, tb[FRA_IIFNAME], IFNAMSIZ);
+		nla_strscpy(nlrule->iifname, tb[FRA_IIFNAME], IFNAMSIZ);
 		dev = __dev_get_by_name(net, nlrule->iifname);
 		if (dev)
 			nlrule->iifindex = dev->ifindex;
@@ -573,7 +573,7 @@ static int fib_nl2rule(struct sk_buff *skb, struct nlmsghdr *nlh,
 		struct net_device *dev;
 
 		nlrule->oifindex = -1;
-		nla_strlcpy(nlrule->oifname, tb[FRA_OIFNAME], IFNAMSIZ);
+		nla_strscpy(nlrule->oifname, tb[FRA_OIFNAME], IFNAMSIZ);
 		dev = __dev_get_by_name(net, nlrule->oifname);
 		if (dev)
 			nlrule->oifindex = dev->ifindex;
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 7d7223691783..60917ff4a00b 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1939,7 +1939,7 @@ static const struct rtnl_link_ops *linkinfo_to_kind_ops(const struct nlattr *nla
 	if (linfo[IFLA_INFO_KIND]) {
 		char kind[MODULE_NAME_LEN];
 
-		nla_strlcpy(kind, linfo[IFLA_INFO_KIND], sizeof(kind));
+		nla_strscpy(kind, linfo[IFLA_INFO_KIND], sizeof(kind));
 		ops = rtnl_link_ops_get(kind);
 	}
 
@@ -2953,9 +2953,9 @@ static struct net_device *rtnl_dev_get(struct net *net,
 	if (!ifname) {
 		ifname = buffer;
 		if (ifname_attr)
-			nla_strlcpy(ifname, ifname_attr, IFNAMSIZ);
+			nla_strscpy(ifname, ifname_attr, IFNAMSIZ);
 		else if (altifname_attr)
-			nla_strlcpy(ifname, altifname_attr, ALTIFNAMSIZ);
+			nla_strscpy(ifname, altifname_attr, ALTIFNAMSIZ);
 		else
 			return NULL;
 	}
@@ -2983,7 +2983,7 @@ static int rtnl_setlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto errout;
 
 	if (tb[IFLA_IFNAME])
-		nla_strlcpy(ifname, tb[IFLA_IFNAME], IFNAMSIZ);
+		nla_strscpy(ifname, tb[IFLA_IFNAME], IFNAMSIZ);
 	else
 		ifname[0] = '\0';
 
@@ -3264,7 +3264,7 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return err;
 
 	if (tb[IFLA_IFNAME])
-		nla_strlcpy(ifname, tb[IFLA_IFNAME], IFNAMSIZ);
+		nla_strscpy(ifname, tb[IFLA_IFNAME], IFNAMSIZ);
 	else
 		ifname[0] = '\0';
 
@@ -3296,7 +3296,7 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		memset(linkinfo, 0, sizeof(linkinfo));
 
 	if (linkinfo[IFLA_INFO_KIND]) {
-		nla_strlcpy(kind, linkinfo[IFLA_INFO_KIND], sizeof(kind));
+		nla_strscpy(kind, linkinfo[IFLA_INFO_KIND], sizeof(kind));
 		ops = rtnl_link_ops_get(kind);
 	} else {
 		kind[0] = '\0';
diff --git a/net/decnet/dn_dev.c b/net/decnet/dn_dev.c
index 15d42353f1a3..d1c50a48614b 100644
--- a/net/decnet/dn_dev.c
+++ b/net/decnet/dn_dev.c
@@ -658,7 +658,7 @@ static int dn_nl_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
 	ifa->ifa_dev = dn_db;
 
 	if (tb[IFA_LABEL])
-		nla_strlcpy(ifa->ifa_label, tb[IFA_LABEL], IFNAMSIZ);
+		nla_strscpy(ifa->ifa_label, tb[IFA_LABEL], IFNAMSIZ);
 	else
 		memcpy(ifa->ifa_label, dev->name, IFNAMSIZ);
 
diff --git a/net/ieee802154/nl-mac.c b/net/ieee802154/nl-mac.c
index 6d091e419d3e..9c640d670ffe 100644
--- a/net/ieee802154/nl-mac.c
+++ b/net/ieee802154/nl-mac.c
@@ -149,7 +149,7 @@ static struct net_device *ieee802154_nl_get_dev(struct genl_info *info)
 	if (info->attrs[IEEE802154_ATTR_DEV_NAME]) {
 		char name[IFNAMSIZ + 1];
 
-		nla_strlcpy(name, info->attrs[IEEE802154_ATTR_DEV_NAME],
+		nla_strscpy(name, info->attrs[IEEE802154_ATTR_DEV_NAME],
 			    sizeof(name));
 		dev = dev_get_by_name(&init_net, name);
 	} else if (info->attrs[IEEE802154_ATTR_DEV_INDEX]) {
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 123a6d39438f..a50951a90f63 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -881,7 +881,7 @@ static struct in_ifaddr *rtm_to_ifaddr(struct net *net, struct nlmsghdr *nlh,
 		ifa->ifa_broadcast = nla_get_in_addr(tb[IFA_BROADCAST]);
 
 	if (tb[IFA_LABEL])
-		nla_strlcpy(ifa->ifa_label, tb[IFA_LABEL], IFNAMSIZ);
+		nla_strscpy(ifa->ifa_label, tb[IFA_LABEL], IFNAMSIZ);
 	else
 		memcpy(ifa->ifa_label, dev->name, IFNAMSIZ);
 
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 1f75dc686b6b..4b505074b24f 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -973,7 +973,7 @@ bool fib_metrics_match(struct fib_config *cfg, struct fib_info *fi)
 			char tmp[TCP_CA_NAME_MAX];
 			bool ecn_ca = false;
 
-			nla_strlcpy(tmp, nla, sizeof(tmp));
+			nla_strscpy(tmp, nla, sizeof(tmp));
 			val = tcp_ca_get_key_by_name(fi->fib_net, tmp, &ecn_ca);
 		} else {
 			if (nla_len(nla) != sizeof(u32))
diff --git a/net/ipv4/metrics.c b/net/ipv4/metrics.c
index 3205d5f7c8c9..25ea6ac44db9 100644
--- a/net/ipv4/metrics.c
+++ b/net/ipv4/metrics.c
@@ -31,7 +31,7 @@ static int ip_metrics_convert(struct net *net, struct nlattr *fc_mx,
 		if (type == RTAX_CC_ALGO) {
 			char tmp[TCP_CA_NAME_MAX];
 
-			nla_strlcpy(tmp, nla, sizeof(tmp));
+			nla_strscpy(tmp, nla, sizeof(tmp));
 			val = tcp_ca_get_key_by_name(net, tmp, &ecn_ca);
 			if (val == TCP_CA_UNSPEC) {
 				NL_SET_ERR_MSG(extack, "Unknown tcp congestion algorithm");
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index be5e95a0d876..b96fd0c55eaa 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -225,7 +225,7 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 		if (e.cidr > HOST_MASK)
 			return -IPSET_ERR_INVALID_CIDR;
 	}
-	nla_strlcpy(e.iface, tb[IPSET_ATTR_IFACE], IFNAMSIZ);
+	nla_strscpy(e.iface, tb[IPSET_ATTR_IFACE], IFNAMSIZ);
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
@@ -442,7 +442,7 @@ hash_netiface6_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	ip6_netmask(&e.ip, e.cidr);
 
-	nla_strlcpy(e.iface, tb[IPSET_ATTR_IFACE], IFNAMSIZ);
+	nla_strscpy(e.iface, tb[IPSET_ATTR_IFACE], IFNAMSIZ);
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0f58e98542be..a4908d264768 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1281,7 +1281,7 @@ static struct nft_chain *nft_chain_lookup(struct net *net,
 	if (nla == NULL)
 		return ERR_PTR(-EINVAL);
 
-	nla_strlcpy(search, nla, sizeof(search));
+	nla_strscpy(search, nla, sizeof(search));
 
 	WARN_ON(!rcu_read_lock_held() &&
 		!lockdep_commit_lock_is_held(net));
@@ -1721,7 +1721,7 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 		goto err_hook_alloc;
 	}
 
-	nla_strlcpy(ifname, attr, IFNAMSIZ);
+	nla_strscpy(ifname, attr, IFNAMSIZ);
 	dev = __dev_get_by_name(net, ifname);
 	if (!dev) {
 		err = -ENOENT;
@@ -5734,7 +5734,7 @@ struct nft_object *nft_obj_lookup(const struct net *net,
 	struct rhlist_head *tmp, *list;
 	struct nft_object *obj;
 
-	nla_strlcpy(search, nla, sizeof(search));
+	nla_strscpy(search, nla, sizeof(search));
 	k.name = search;
 
 	WARN_ON_ONCE(!rcu_read_lock_held() &&
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index 5bfec829c12f..5e511df8d709 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -112,7 +112,7 @@ static int nfnl_acct_new(struct net *net, struct sock *nfnl,
 		nfacct->flags = flags;
 	}
 
-	nla_strlcpy(nfacct->name, tb[NFACCT_NAME], NFACCT_NAME_MAX);
+	nla_strscpy(nfacct->name, tb[NFACCT_NAME], NFACCT_NAME_MAX);
 
 	if (tb[NFACCT_BYTES]) {
 		atomic64_set(&nfacct->bytes,
diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index 5b0d0a77379c..0f94fce1d3ed 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -146,7 +146,7 @@ nfnl_cthelper_expect_policy(struct nf_conntrack_expect_policy *expect_policy,
 	    !tb[NFCTH_POLICY_EXPECT_TIMEOUT])
 		return -EINVAL;
 
-	nla_strlcpy(expect_policy->name,
+	nla_strscpy(expect_policy->name,
 		    tb[NFCTH_POLICY_NAME], NF_CT_HELPER_NAME_LEN);
 	expect_policy->max_expected =
 		ntohl(nla_get_be32(tb[NFCTH_POLICY_EXPECT_MAX]));
@@ -233,7 +233,7 @@ nfnl_cthelper_create(const struct nlattr * const tb[],
 	if (ret < 0)
 		goto err1;
 
-	nla_strlcpy(helper->name,
+	nla_strscpy(helper->name,
 		    tb[NFCTH_NAME], NF_CT_HELPER_NAME_LEN);
 	size = ntohl(nla_get_be32(tb[NFCTH_PRIV_DATA_LEN]));
 	if (size > sizeof_field(struct nf_conn_help, data)) {
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 322bd674963e..a8c4d442231c 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -990,7 +990,7 @@ static int nft_ct_helper_obj_init(const struct nft_ctx *ctx,
 	if (!priv->l4proto)
 		return -ENOENT;
 
-	nla_strlcpy(name, tb[NFTA_CT_HELPER_NAME], sizeof(name));
+	nla_strscpy(name, tb[NFTA_CT_HELPER_NAME], sizeof(name));
 
 	if (tb[NFTA_CT_HELPER_L3PROTO])
 		family = ntohs(nla_get_be16(tb[NFTA_CT_HELPER_L3PROTO]));
diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index 57899454a530..a06a46b039c5 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -152,7 +152,7 @@ static int nft_log_init(const struct nft_ctx *ctx,
 		priv->prefix = kmalloc(nla_len(nla) + 1, GFP_KERNEL);
 		if (priv->prefix == NULL)
 			return -ENOMEM;
-		nla_strlcpy(priv->prefix, nla, nla_len(nla) + 1);
+		nla_strscpy(priv->prefix, nla, nla_len(nla) + 1);
 	} else {
 		priv->prefix = (char *)nft_log_null_prefix;
 	}
diff --git a/net/netlabel/netlabel_mgmt.c b/net/netlabel/netlabel_mgmt.c
index eb1d66d20afb..df1b41ed73fd 100644
--- a/net/netlabel/netlabel_mgmt.c
+++ b/net/netlabel/netlabel_mgmt.c
@@ -95,7 +95,7 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
 			ret_val = -ENOMEM;
 			goto add_free_entry;
 		}
-		nla_strlcpy(entry->domain,
+		nla_strscpy(entry->domain,
 			    info->attrs[NLBL_MGMT_A_DOMAIN], tmp_size);
 	}
 
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 8709f3d4e7c4..573b38ad2f8e 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1226,7 +1226,7 @@ static int nfc_genl_fw_download(struct sk_buff *skb, struct genl_info *info)
 	if (!dev)
 		return -ENODEV;
 
-	nla_strlcpy(firmware_name, info->attrs[NFC_ATTR_FIRMWARE_NAME],
+	nla_strscpy(firmware_name, info->attrs[NFC_ATTR_FIRMWARE_NAME],
 		    sizeof(firmware_name));
 
 	rc = nfc_fw_download(dev, firmware_name);
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 541574520c52..eac24a73115f 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -935,7 +935,7 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 			NL_SET_ERR_MSG(extack, "TC action kind must be specified");
 			goto err_out;
 		}
-		if (nla_strlcpy(act_name, kind, IFNAMSIZ) < 0) {
+		if (nla_strscpy(act_name, kind, IFNAMSIZ) < 0) {
 			NL_SET_ERR_MSG(extack, "TC action name too long");
 			goto err_out;
 		}
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index 8dc3bec0d325..ac7297f42355 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -166,7 +166,7 @@ static int __tcf_ipt_init(struct net *net, unsigned int id, struct nlattr *nla,
 	if (unlikely(!tname))
 		goto err1;
 	if (tb[TCA_IPT_TABLE] == NULL ||
-	    nla_strlcpy(tname, tb[TCA_IPT_TABLE], IFNAMSIZ) >= IFNAMSIZ)
+	    nla_strscpy(tname, tb[TCA_IPT_TABLE], IFNAMSIZ) >= IFNAMSIZ)
 		strcpy(tname, "mangle");
 
 	t = kmemdup(td, td->u.target_size, GFP_KERNEL);
diff --git a/net/sched/act_simple.c b/net/sched/act_simple.c
index a4f3d0f0daa9..726cc956d06f 100644
--- a/net/sched/act_simple.c
+++ b/net/sched/act_simple.c
@@ -52,7 +52,7 @@ static int alloc_defdata(struct tcf_defact *d, const struct nlattr *defdata)
 	d->tcfd_defdata = kzalloc(SIMP_MAX_DATA, GFP_KERNEL);
 	if (unlikely(!d->tcfd_defdata))
 		return -ENOMEM;
-	nla_strlcpy(d->tcfd_defdata, defdata, SIMP_MAX_DATA);
+	nla_strscpy(d->tcfd_defdata, defdata, SIMP_MAX_DATA);
 	return 0;
 }
 
@@ -71,7 +71,7 @@ static int reset_policy(struct tc_action *a, const struct nlattr *defdata,
 	spin_lock_bh(&d->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(a, p->action, goto_ch);
 	memset(d->tcfd_defdata, 0, SIMP_MAX_DATA);
-	nla_strlcpy(d->tcfd_defdata, defdata, SIMP_MAX_DATA);
+	nla_strscpy(d->tcfd_defdata, defdata, SIMP_MAX_DATA);
 	spin_unlock_bh(&d->tcf_lock);
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index d3787a67b3da..9cf9e175dbc8 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -223,7 +223,7 @@ static inline u32 tcf_auto_prio(struct tcf_proto *tp)
 static bool tcf_proto_check_kind(struct nlattr *kind, char *name)
 {
 	if (kind)
-		return nla_strlcpy(name, kind, IFNAMSIZ) < 0;
+		return nla_strscpy(name, kind, IFNAMSIZ) < 0;
 	memset(name, 0, IFNAMSIZ);
 	return false;
 }
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 05449286d889..1a2d2471b078 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1170,7 +1170,7 @@ static struct Qdisc *qdisc_create(struct net_device *dev,
 #ifdef CONFIG_MODULES
 	if (ops == NULL && kind != NULL) {
 		char name[IFNAMSIZ];
-		if (nla_strlcpy(name, kind, IFNAMSIZ) >= 0) {
+		if (nla_strscpy(name, kind, IFNAMSIZ) >= 0) {
 			/* We dropped the RTNL semaphore in order to
 			 * perform the module load.  So, even if we
 			 * succeeded in loading the module we have to
diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index 1c7aa51cc2a3..644c7ec41ddf 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -695,7 +695,7 @@ static int tipc_nl_compat_link_dump(struct tipc_nl_compat_msg *msg,
 
 	link_info.dest = nla_get_flag(link[TIPC_NLA_LINK_DEST]);
 	link_info.up = htonl(nla_get_flag(link[TIPC_NLA_LINK_UP]));
-	nla_strlcpy(link_info.str, link[TIPC_NLA_LINK_NAME],
+	nla_strscpy(link_info.str, link[TIPC_NLA_LINK_NAME],
 		    TIPC_MAX_LINK_NAME);
 
 	return tipc_add_tlv(msg->rep, TIPC_TLV_LINK_INFO,
-- 
2.20.1

