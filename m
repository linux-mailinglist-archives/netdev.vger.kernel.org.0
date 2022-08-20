Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E832659AD86
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 13:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345246AbiHTLda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 07:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345244AbiHTLdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 07:33:25 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2DD7644A;
        Sat, 20 Aug 2022 04:33:20 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id x25so6642737ljm.5;
        Sat, 20 Aug 2022 04:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=JI8hmzVkIliXB2itc9Fzu8tTu86mjKBtsV24uAMvB4U=;
        b=EO5YpZB9aHyigW2ImJtzczrmymqyN5EkvMWsy14DvJ4YDGx6FA3uqB3RKIUmeGBlOj
         FOf0gm3Mt22FAS224NqIUQvEJksvGClVRskOg8s5ksUpnrJGBRabfdF2qj6Oj9yLqPEj
         tINOyGlDwfLB4GN0dfcEevLylbsS6/yRcGyC06KBorLndqbD6vqlPpiPdQezzWMML6+K
         KX4KvBgbVVDBBm+xWZOZHrBOootKq7tcC/sIiQCk2IIK+8BvADe+zyWrDZK8hzu4Bgsg
         v1d1TEShZuZDza2rv0SosdMl9hJ/0KG4GMcO2Bvt8dt6cP4cORX5ZmyO+pqbgY0wbJ5H
         mecA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=JI8hmzVkIliXB2itc9Fzu8tTu86mjKBtsV24uAMvB4U=;
        b=DVZV/W4FaWS8ATSEGXPGdmx0x8HPK1/hcHzAgNvBJrvgRaAyOzzcJUVQgZtVMNoKh2
         GGhu61iLQZEhRgOIpjN4MWMTvlEoP2cMCT7TfxyPlynrsgCKhtWWn0CpvaXFp+VBN6gy
         ysdejfvQTQ8wu3EHQwo+eB29fbQoR4ZEFTZHJosDo8DArX2/aOyjTWAGpbwfp3lBFsw9
         vMC/FG/TMis1QC5noAtaxbJ26bF/R49CPDVAwdrsyNyVuqH6HkCi7CAMM+NlehgVl1vt
         XWhxJGg4SBvYWqH2mQ5Nd94i95/bwpzk2GENITgX/vy0egto2oTiHEGXrBIRl20z6xZk
         Y2zQ==
X-Gm-Message-State: ACgBeo0k9lxvK6OPKE9NfkgRSQTSFwd/9GDMMcPzrQIg32YO0jlN9RqI
        CvBPCCg/IXU+qWl3nXBJV0anllNDf9amIh1N+bkxTa4XBkxZ/Q==
X-Google-Smtp-Source: AA6agR4MEEib+GJWIjLV+euWjp/9q4hOTpcHzdWB5L+/zQKd0RPUKYYpzwsVyj4EbgnyW8q02CwXUKp5hQrv7GagwL0=
X-Received: by 2002:a2e:a28d:0:b0:25e:66ea:637b with SMTP id
 k13-20020a2ea28d000000b0025e66ea637bmr3157582lja.24.1660995198843; Sat, 20
 Aug 2022 04:33:18 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1660100506.git.sevinj.aghayeva@gmail.com>
 <94ec6182-0804-7a0e-dcba-42655ff19884@blackwall.org> <CAMWRUK4Mo2KHfa-6Z4Ka+ZLx8TtmzSvq9CLmMmEwE5S7Yp7-Kw@mail.gmail.com>
 <34228958-081d-52b5-f363-d2df6ecf251d@blackwall.org> <CAMWRUK43+NG63J2YCiKijREjUg5zjii=_2knN6ZCL6PHMP3q8w@mail.gmail.com>
 <46deef15-a67b-91ad-bc47-1b1306d1d654@blackwall.org>
In-Reply-To: <46deef15-a67b-91ad-bc47-1b1306d1d654@blackwall.org>
From:   Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
Date:   Sat, 20 Aug 2022 07:33:07 -0400
Message-ID: <CAMWRUK6BQpABuutUwaX36rmQsfuJShQbDjyjSdfDawrQ=pcvaA@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 0/3] net: vlan: fix bridge binding behavior
 and add selftests
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, aroulin@nvidia.com, sbrivio@redhat.com,
        roopa@nvidia.com, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 8:00 AM Nikolay Aleksandrov <razor@blackwall.org> wrote:
>
> On 18/08/2022 14:50, Sevinj Aghayeva wrote:
> > On Sun, Aug 14, 2022 at 3:38 AM Nikolay Aleksandrov <razor@blackwall.org> wrote:
> >>
> >> On 12/08/2022 18:30, Sevinj Aghayeva wrote:
> >>> On Wed, Aug 10, 2022 at 4:54 AM Nikolay Aleksandrov <razor@blackwall.org> wrote:
> >>>>
> >>>> On 10/08/2022 06:11, Sevinj Aghayeva wrote:
> >>>>> When bridge binding is enabled for a vlan interface, it is expected
> >>>>> that the link state of the vlan interface will track the subset of the
> >>>>> ports that are also members of the corresponding vlan, rather than
> >>>>> that of all ports.
> >>>>>
> >>>>> Currently, this feature works as expected when a vlan interface is
> >>>>> created with bridge binding enabled:
> >>>>>
> >>>>>   ip link add link br name vlan10 type vlan id 10 protocol 802.1q \
> >>>>>         bridge_binding on
> >>>>>
> >>>>> However, the feature does not work when a vlan interface is created
> >>>>> with bridge binding disabled, and then enabled later:
> >>>>>
> >>>>>   ip link add link br name vlan10 type vlan id 10 protocol 802.1q \
> >>>>>         bridge_binding off
> >>>>>   ip link set vlan10 type vlan bridge_binding on
> >>>>>
> >>>>> After these two commands, the link state of the vlan interface
> >>>>> continues to track that of all ports, which is inconsistent and
> >>>>> confusing to users. This series fixes this bug and introduces two
> >>>>> tests for the valid behavior.
> >>>>>
> >>>>> Sevinj Aghayeva (3):
> >>>>>   net: core: export call_netdevice_notifiers_info
> >>>>>   net: 8021q: fix bridge binding behavior for vlan interfaces
> >>>>>   selftests: net: tests for bridge binding behavior
> >>>>>
> >>>>>  include/linux/netdevice.h                     |   2 +
> >>>>>  net/8021q/vlan.h                              |   2 +-
> >>>>>  net/8021q/vlan_dev.c                          |  25 ++-
> >>>>>  net/core/dev.c                                |   7 +-
> >>>>>  tools/testing/selftests/net/Makefile          |   1 +
> >>>>>  .../selftests/net/bridge_vlan_binding_test.sh | 143 ++++++++++++++++++
> >>>>>  6 files changed, 172 insertions(+), 8 deletions(-)
> >>>>>  create mode 100755 tools/testing/selftests/net/bridge_vlan_binding_test.sh
> >>>>>
> >>>>
> >>>> Hi,
> >>>> NETDEV_CHANGE event is already propagated when the vlan changes flags,
> >>>> NETDEV_CHANGEUPPER is used when the devices' relationship changes not their flags.
> >>>> The only problem you have to figure out is that the flag has changed. The fix itself
> >>>> must be done within the bridge, not 8021q. You can figure it out based on current bridge
> >>>> loose binding state and the vlan's changed state, again in the bridge's NETDEV_CHANGE
> >>>> handler. Unfortunately the proper fix is much more involved and will need new
> >>>> infra, you'll have to track the loose binding vlans in the bridge. To do that you should
> >>>> add logic that reflects the current vlans' loose binding state *only* for vlans that also
> >>>> exist in the bridge, the rest which are upper should be carrier off if they have the loose
> >>>> binding flag set.
> >>>>
> >>>> Alternatively you can add a new NETDEV_ notifier (using something similar to struct netdev_notifier_pre_changeaddr_info)
> >>>> and add link type-specific space (e.g. union of link type-specific structs) in the struct which will contain
> >>>> what changed for 8021q and will be properly interpreted by the bridge. The downside is that we'll generate
> >>>> 2 notifications when changing the loose binding flag, but on the bright side won't have to track anything
> >>>> in the bridge, just handle the new notifier type. This might be the easiest path, the fix is still in
> >>>> the bridge though, the 8021q module just needs to fill in the new struct and emit the notification on
> >>>> any loose binding changes, the bridge must decide if it should process it (i.e. based on upper/lower
> >>>> relationship). Such notifier can be also re-used by other link types to propagate link-type specific
> >>>> changes.
> >>
> >> Hi,
> >>
> >>>
> >>> Hi Nik,
> >>>
> >>> Can you please clarify the following?
> >>>
> >>> 1) should the new NETDEV_ notifier be about the vlan device and not
> >>> the bridge? That is, should I handle it in br_device_event?
> >>
> >> Yes, it should be about the vlan device (i.e. the target device that changes its state).
> >
> > Hi Nik,
> >
> > I implemented this and tried to handle NETDEV_CHANGE_DETAILS in
> > br_device_event, but there's a check there that performs early return
> > if the device is not a bridge port:
> >
> > https://github.com/torvalds/linux/blob/master/net/bridge/br.c#L55-L57
> >
> > Should I add a new function before that check, e.g.
> > br_vlan_device_event, and handle vlan device events there, similar to
> > br_vlan_bridge_event? Or do you have a better idea?
> >
> > Thanks
> >
>
> Hi,
> Handling all vlan device-related changes in br_vlan_device_event() sounds good to me.
> Please add it to br_vlan.c.

Hi Nik,

Can you please review this diff before I make it into a proper patchset? Thanks!

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 2563d30736e9..0ce3da42325e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2762,6 +2762,7 @@ enum netdev_cmd {
  NETDEV_UNREGISTER,
  NETDEV_CHANGEMTU, /* notify after mtu change happened */
  NETDEV_CHANGEADDR, /* notify after the address change */
+ NETDEV_CHANGE_DETAILS,
  NETDEV_PRE_CHANGEADDR, /* notify before the address change */
  NETDEV_GOING_DOWN,
  NETDEV_CHANGENAME,
@@ -2837,6 +2838,13 @@ struct netdev_notifier_changelowerstate_info {
  void *lower_state_info; /* is lower dev state */
 };

+struct netdev_notifier_change_details_info {
+ struct netdev_notifier_info info; /* must be first */
+ union {
+ bool bridge_binding;
+ } details;
+};
+
 struct netdev_notifier_pre_changeaddr_info {
  struct netdev_notifier_info info; /* must be first */
  const unsigned char *dev_addr;
@@ -3836,6 +3844,8 @@ int __dev_set_mtu(struct net_device *, int);
 int dev_set_mtu(struct net_device *, int);
 int dev_pre_changeaddr_notify(struct net_device *dev, const char *addr,
        struct netlink_ext_ack *extack);
+int dev_change_details_notify(struct net_device *dev, bool bridge_binding,
+       struct netlink_ext_ack *extack);
 int dev_set_mac_address(struct net_device *dev, struct sockaddr *sa,
  struct netlink_ext_ack *extack);
 int dev_set_mac_address_user(struct net_device *dev, struct sockaddr *sa,
diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
index 5eaf38875554..71947cdcfaaa 100644
--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -130,7 +130,7 @@ void vlan_dev_set_ingress_priority(const struct
net_device *dev,
 int vlan_dev_set_egress_priority(const struct net_device *dev,
  u32 skb_prio, u16 vlan_prio);
 void vlan_dev_free_egress_priority(const struct net_device *dev);
-int vlan_dev_change_flags(const struct net_device *dev, u32 flag, u32 mask);
+int vlan_dev_change_flags(struct net_device *dev, u32 flag, u32 mask);
 void vlan_dev_get_realdev_name(const struct net_device *dev, char *result,
         size_t size);

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 839f2020b015..489baa8435de 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -211,7 +211,7 @@ int vlan_dev_set_egress_priority(const struct
net_device *dev,
 /* Flags are defined in the vlan_flags enum in
  * include/uapi/linux/if_vlan.h file.
  */
-int vlan_dev_change_flags(const struct net_device *dev, u32 flags, u32 mask)
+int vlan_dev_change_flags(struct net_device *dev, u32 flags, u32 mask)
 {
  struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
  u32 old_flags = vlan->flags;
@@ -223,19 +223,29 @@ int vlan_dev_change_flags(const struct
net_device *dev, u32 flags, u32 mask)

  vlan->flags = (old_flags & ~mask) | (flags & mask);

- if (netif_running(dev) && (vlan->flags ^ old_flags) & VLAN_FLAG_GVRP) {
+ if (!netif_running(dev))
+ return 0;
+
+ if ((vlan->flags ^ old_flags) & VLAN_FLAG_GVRP) {
  if (vlan->flags & VLAN_FLAG_GVRP)
  vlan_gvrp_request_join(dev);
  else
  vlan_gvrp_request_leave(dev);
  }

- if (netif_running(dev) && (vlan->flags ^ old_flags) & VLAN_FLAG_MVRP) {
+ if ((vlan->flags ^ old_flags) & VLAN_FLAG_MVRP) {
  if (vlan->flags & VLAN_FLAG_MVRP)
  vlan_mvrp_request_join(dev);
  else
  vlan_mvrp_request_leave(dev);
  }
+
+ if ((vlan->flags ^ old_flags) & VLAN_FLAG_BRIDGE_BINDING &&
+     netif_is_bridge_master(vlan->real_dev)) {
+ dev_change_details_notify(dev,
+     !!(vlan->flags & VLAN_FLAG_BRIDGE_BINDING), NULL);
+ }
+
  return 0;
 }

diff --git a/net/bridge/br.c b/net/bridge/br.c
index 96e91d69a9a8..62e939c6a3f0 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -51,6 +51,11 @@ static int br_device_event(struct notifier_block
*unused, unsigned long event, v
  }
  }

+ if (is_vlan_dev(dev)) {
+ br_vlan_device_event(dev, event, ptr);
+ return NOTIFY_DONE;
+ }
+
  /* not a port of a bridge */
  p = br_port_get_rtnl(dev);
  if (!p)
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 06e5f6faa431..a9a08e49c76c 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1470,6 +1470,8 @@ void br_vlan_get_stats(const struct net_bridge_vlan *v,
 void br_vlan_port_event(struct net_bridge_port *p, unsigned long event);
 int br_vlan_bridge_event(struct net_device *dev, unsigned long event,
  void *ptr);
+void br_vlan_device_event(struct net_device *dev, unsigned long event,
+   void *ptr);
 void br_vlan_rtnl_init(void);
 void br_vlan_rtnl_uninit(void);
 void br_vlan_notify(const struct net_bridge *br,
@@ -1701,6 +1703,11 @@ static inline int br_vlan_bridge_event(struct
net_device *dev,
  return 0;
 }

+static void br_vlan_device_event(struct net_device *dev,
+ unsigned long event, void *ptr)
+{
+}
+
 static inline void br_vlan_rtnl_init(void)
 {
 }
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 0f5e75ccac79..70a9950df175 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1768,6 +1768,20 @@ void br_vlan_port_event(struct net_bridge_port
*p, unsigned long event)
  }
 }

+void br_vlan_device_event(struct net_device *dev, unsigned long
event, void *ptr)
+{
+ struct netdev_notifier_change_details_info *info;
+ struct net_device *br_dev;
+
+ switch (event) {
+ case NETDEV_CHANGE_DETAILS:
+ info = ptr;
+ br_dev = vlan_dev_priv(dev)->real_dev;
+ br_vlan_upper_change(br_dev, dev, info->details.bridge_binding);
+ break;
+ }
+}
+
 static bool br_vlan_stats_fill(struct sk_buff *skb,
         const struct net_bridge_vlan *v)
 {
diff --git a/net/core/dev.c b/net/core/dev.c
index 30a1603a7225..dcdbc625585d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1624,7 +1624,7 @@ const char *netdev_cmd_to_name(enum netdev_cmd cmd)
  N(POST_INIT) N(RELEASE) N(NOTIFY_PEERS) N(JOIN) N(CHANGEUPPER)
  N(RESEND_IGMP) N(PRECHANGEMTU) N(CHANGEINFODATA) N(BONDING_INFO)
  N(PRECHANGEUPPER) N(CHANGELOWERSTATE) N(UDP_TUNNEL_PUSH_INFO)
- N(UDP_TUNNEL_DROP_INFO) N(CHANGE_TX_QUEUE_LEN)
+ N(UDP_TUNNEL_DROP_INFO) N(CHANGE_TX_QUEUE_LEN) N(CHANGE_DETAILS)
  N(CVLAN_FILTER_PUSH_INFO) N(CVLAN_FILTER_DROP_INFO)
  N(SVLAN_FILTER_PUSH_INFO) N(SVLAN_FILTER_DROP_INFO)
  N(PRE_CHANGEADDR) N(OFFLOAD_XSTATS_ENABLE) N(OFFLOAD_XSTATS_DISABLE)
@@ -8767,6 +8767,27 @@ int dev_pre_changeaddr_notify(struct net_device
*dev, const char *addr,
 }
 EXPORT_SYMBOL(dev_pre_changeaddr_notify);

+/**
+ * dev_change_details_notify - Call NETDEV_PRE_CHANGE_DETAILS.
+ * @dev: device
+ * @bridge_binding: bridge binding setting
+ * @extack: netlink extended ack
+ */
+int dev_change_details_notify(struct net_device *dev, bool bridge_binding,
+       struct netlink_ext_ack *extack)
+{
+ struct netdev_notifier_change_details_info info = {
+ .info.dev = dev,
+ .info.extack = extack,
+ .details.bridge_binding = bridge_binding,
+ };
+ int rc;
+
+ rc = call_netdevice_notifiers_info(NETDEV_CHANGE_DETAILS, &info.info);
+ return notifier_to_errno(rc);
+}
+EXPORT_SYMBOL(dev_change_details_notify);
+
 /**
  * dev_set_mac_address - Change Media Access Control Address
  * @dev: device


>
> Thanks,
>  Nik
>
>


-- 

Sevinj.Aghayeva
