Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C8D2675EA
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 00:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgIKWbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 18:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbgIKWaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 18:30:55 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27581C061757
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 15:30:55 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id lo4so15665111ejb.8
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 15:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cbsgtymQQ+k5DoVmuVgnlVLNs03jFloCzfSe+ygMz6Q=;
        b=kOM8v5NWLchtg2F/hFiMvTKUWMlVh9bukM8zHiApNM/soLAMUeQf1HYDr6guPsAYon
         2Oe8Zbt21k1FexzEdEzX5DZsjExKN1LJUtPFnYSncA4E0RN3n5pQQ58LwVma23mGyjwF
         zhSrwfFlO2H+t+qxcSz1zoM7AP73WQD3jM60be0rKF4RxSTMNnw+VplnBzb55EOdZA5t
         zYSOATKyNvOMddk8axdwS+iOnPnalEIPrQediqa/YqBy5m3KSpWdShYp+kZGLaoErZkH
         OD6ETDaZrEbUMKFmVg5+kd8DQ8Zg2rJdrVlCbBl74nvDclBwDayc06GBxvqTx1gEuvQ7
         7fpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cbsgtymQQ+k5DoVmuVgnlVLNs03jFloCzfSe+ygMz6Q=;
        b=X1vBG6Gw6DQdaWLp/yYzezywibOBYchR/MbAJnsv/gpHNBNgCg4DCyCHWmG8URum7v
         ou9l0CPQVp5gzoFoIMVl0goYG2GwEB1Xx1Cw9ZIJz9SYUv21WgRzDxNFu2Wixsv6NKix
         2ncUs9W+jq0rdD2IyUjXds9BSLMlQ0+rNgxvghbNfwhjGEzm9RquVpAxF8CwVlL3hEaw
         icXvmgSbzwaT0DQpqkEHN9Hx5IdrZopjkiAWjC2kDobEh68/6YlK6nJwx8tW6+TfgBir
         XvRfYZTfkFBysiXCw7P7dcU75JcMwo0WfCUuuDyr76mzG/9Ds2ooJO30HpW8QmbyHQe+
         XnFA==
X-Gm-Message-State: AOAM530jmmvKgs5qiG8DoApfukWOv1LjsXSfNI5V1tGqHp/h4ABN/cmb
        IuvANfqxKWDJkXG58122ZUI=
X-Google-Smtp-Source: ABdhPJwO17lD5Micyxro2sjvPWD1/uchoPLhrSYt3O12UxG3RasPe7CjKTev4uDj4eIxjl8AUeamHQ==
X-Received: by 2002:a17:906:14c9:: with SMTP id y9mr4240641ejc.523.1599863453769;
        Fri, 11 Sep 2020 15:30:53 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id b13sm2864471edf.89.2020.09.11.15.30.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 15:30:53 -0700 (PDT)
Date:   Sat, 12 Sep 2020 01:30:51 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     davem@davemloft.net, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] net: dsa: set
 configure_vlan_while_not_filtering to true by default
Message-ID: <20200911223051.cp6uprsdtyqk5fzn@skbuf>
References: <20200909175325.bshts3hl537xtz2q@skbuf>
 <5edf3aa2-c417-e708-b259-7235de7bc8d2@gmail.com>
 <7e45b733-de6a-67c8-2e28-30a5ba84f544@gmail.com>
 <20200911000337.htwr366ng3nc3a7d@skbuf>
 <04823ca9-728f-cd06-a4b2-bb943d04321b@gmail.com>
 <20200911154340.mfe7lwtklfepd5go@skbuf>
 <b6ec9450-6b3e-0473-a2f9-b57016f010c1@gmail.com>
 <20200911183556.l3cazdcwkosyw45v@skbuf>
 <ac73600d-6c1d-83a3-9b49-19f853ba0226@gmail.com>
 <7cbe45bd-efb0-ec3e-cc37-4d3154e91fd5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cbe45bd-efb0-ec3e-cc37-4d3154e91fd5@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 12:48:37PM -0700, Florian Fainelli wrote:
> > > I'm conflicted. So you prefer having the CPU port as egress-tagged?
> >
> > I do, because I realized that some of the switches we support are still
> > configured in DSA_TAG_NONE mode because the CPU port they chose is not
> > Broadcom tag capable and there is an user out there who cares a lot
> > about that case not to "break".
> >

Ok.

> > > Also, I think I'll also experiment with a version of this patch that is
> > > local to the DSA RX path. The bridge people may not like it, and as far
> > > as I understand, only DSA has this situation where pvid-tagged traffic
> > > may end up with a vlan tag on ingress.
> >
> > OK so something along the lines of: port is bridged, and bridge has
> > vlan_filtering=0 and switch does egress tagging and VID is bridge's
> > default_pvid then pop the tag?
> >
> > Should this be a helper function that is utilized by the relevant tagger
> > drivers or do you want this in dsa_switch_rcv()?
>
> The two drivers that appear to be untagging the CPU port unconditionally are
> b53 and kzs9477.

So, a helper in DSA would look something like this:

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 75c8fac82017..c0bb978c6ff7 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -204,6 +204,7 @@ struct dsa_port {
 	const char		*mac;
 	struct device_node	*dn;
 	unsigned int		ageing_time;
+	int			pvid;
 	bool			vlan_filtering;
 	u8			stp_state;
 	struct net_device	*bridge_dev;
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 4a5e2832009b..84d47f838b4e 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -273,6 +273,8 @@ static int dsa_port_setup(struct dsa_port *dp)
 	if (dp->setup)
 		return 0;
 
+	dp->pvid = -1;
+
 	switch (dp->type) {
 	case DSA_PORT_TYPE_UNUSED:
 		dsa_port_disable(dp);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 2da656d984ef..d1dec232fc45 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -7,6 +7,7 @@
 #ifndef __DSA_PRIV_H
 #define __DSA_PRIV_H
 
+#include <linux/if_bridge.h>
 #include <linux/phy.h>
 #include <linux/netdevice.h>
 #include <linux/netpoll.h>
@@ -194,6 +195,40 @@ dsa_slave_to_master(const struct net_device *dev)
 	return dp->cpu_dp->master;
 }
 
+/* If under a bridge with vlan_filtering=0, make sure to send pvid-tagged
+ * frames as untagged, since the bridge will not untag them.
+ */
+static inline struct sk_buff *dsa_untag_bridge_pvid(struct sk_buff *skb)
+{
+	struct dsa_port *dp = dsa_slave_to_port(skb->dev);
+	struct vlan_ethhdr *hdr = vlan_eth_hdr(skb);
+	struct net_device *br = dp->bridge_dev;
+	u16 proto;
+	int err;
+
+	if (!br || br_vlan_enabled(br))
+		return skb;
+
+	err = br_vlan_get_proto(br, &proto);
+	if (err)
+		return skb;
+
+	if (!skb_vlan_tag_present(skb) && hdr->h_vlan_proto == htons(proto)) {
+		skb = skb_vlan_untag(skb);
+		if (!skb)
+			return NULL;
+	}
+
+	if (!skb_vlan_tag_present(skb))
+		return skb;
+
+	/* Cannot use br_vlan_get_pvid here as that requires RTNL */
+	if (skb_vlan_tag_get_id(skb) == dp->pvid)
+		__vlan_hwaccel_clear_tag(skb);
+
+	return skb;
+}
+
 /* switch.c */
 int dsa_switch_register_notifier(struct dsa_switch *ds);
 void dsa_switch_unregister_notifier(struct dsa_switch *ds);
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 86c8dc5c32a0..9167cc678f41 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -315,21 +315,45 @@ static int dsa_switch_vlan_add(struct dsa_switch *ds,
 	if (!ds->ops->port_vlan_add)
 		return 0;
 
-	for (port = 0; port < ds->num_ports; port++)
-		if (dsa_switch_vlan_match(ds, port, info))
+	for (port = 0; port < ds->num_ports; port++) {
+		if (dsa_switch_vlan_match(ds, port, info)) {
 			ds->ops->port_vlan_add(ds, port, info->vlan);
 
+			if (info->vlan->flags & BRIDGE_VLAN_INFO_PVID) {
+				struct dsa_port *dp = dsa_to_port(ds, port);
+
+				dp->pvid = info->vlan->vid_end;
+			}
+		}
+	}
+
 	return 0;
 }
 
 static int dsa_switch_vlan_del(struct dsa_switch *ds,
 			       struct dsa_notifier_vlan_info *info)
 {
+	int err;
+
 	if (!ds->ops->port_vlan_del)
 		return -EOPNOTSUPP;
 
-	if (ds->index == info->sw_index)
-		return ds->ops->port_vlan_del(ds, info->port, info->vlan);
+	if (ds->index == info->sw_index) {
+		const struct switchdev_obj_port_vlan *vlan = info->vlan;
+		struct dsa_port *dp = dsa_to_port(ds, info->port);
+		int vid;
+
+		err = ds->ops->port_vlan_del(ds, info->port, info->vlan);
+		if (err)
+			return err;
+
+		for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
+			if (vid == dp->pvid) {
+				dp->pvid = -1;
+				break;
+			}
+		}
+	}
 
 	/* Do not deprogram the DSA links as they may be used as conduit
 	 * for other VLAN members in the fabric.

It's quite a bit more complex, I don't like it.

Thanks,
-Vladimir
