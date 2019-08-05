Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5D8182635
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 22:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730457AbfHEUnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 16:43:41 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39865 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727460AbfHEUnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 16:43:41 -0400
Received: by mail-wm1-f65.google.com with SMTP id u25so63916491wmc.4;
        Mon, 05 Aug 2019 13:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=i2XGE2Z11j/HAtt+j/gd5n5e0wTahlYLx2T1A1NIrRs=;
        b=laNxJbv37gm8fJBOH6CcGff2dn8YF5iK6aR6fA3eOLq1nIsAsYNvQ3cM+83yKGvQbK
         F++KQDb/VLay4RFMS2eyZgNBEM98c0edISZ1RuzhlbMfx2t0WnV+Lf8ppA0ast+VTOI8
         lsdq9JpI0+uKJeHx61ct3Sxl7lAFdhraw5ZbFhkBSk+WHxNh2i+eCmoxpeaZfD8NLOET
         /mZdJJ4nv0OLsr8Bx3CyEGtPJYIGxmb8F31sXmi1lo1T7i1pFlL0/jEpE8uxRKXIcUbN
         saINO7alOFX/VZntFNTfdyaWNtvf8rlqQtDYhXfS+Q1OEAgInVbCAPaHrI3GRREn1Cq1
         KN5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=i2XGE2Z11j/HAtt+j/gd5n5e0wTahlYLx2T1A1NIrRs=;
        b=pOCCXzCTJfnxzBihxvOaMPPJBdYPjsI6eFdWv4Ahpq20QZe8VQBz/HhXZx1fBdo8S2
         1xpqvwtsXhyn2GNA+FitfphZmmQmVjl9oJs3oNlclXjoV9qE0ScdjhHGkGD84DIdVVZh
         KEfz5ioUwwCq1va74hK5k9PyURsEO12tNoXEegcb675RbSC2Y1b2i9eSqqKfv5q0xNmr
         s7Mg32X6XZP+BKBmermV6Lezf4lEgce8rCjW3xKyGchN4/MFCESrQ+fPWAbHrGnT9ldD
         uJ0VmhYZ/Y5Z6eQMrcVLULiXwCR4jn74dZhG4VXjjfVeQ6F130cD7n6lrtQSW8yxs9ac
         ahHQ==
X-Gm-Message-State: APjAAAVz+1xyA3OGHWZvTGsZDtKcwxH2Jm6Fhozr8nwAEL1kkm05UpHx
        dGiomVojjqfCK7jCoqIjNw==
X-Google-Smtp-Source: APXvYqweJon31W8UQR4KKJSdNtbo2IHCPWsgQmPLl2wOBg9ze8UIAGzikNKnYtpRdHTjv0Ix/OcnIA==
X-Received: by 2002:a1c:9cd1:: with SMTP id f200mr142613wme.157.1565037814060;
        Mon, 05 Aug 2019 13:43:34 -0700 (PDT)
Received: from avx2 ([46.53.248.54])
        by smtp.gmail.com with ESMTPSA id b8sm76483650wrr.43.2019.08.05.13.43.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 13:43:33 -0700 (PDT)
Date:   Mon, 5 Aug 2019 23:43:31 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-sctp@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH net-next] net: use "nb" for notifier blocks
Message-ID: <20190805204331.GA25178@avx2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use more pleasant looking

	struct notifier_block *nb,

instead of "this".

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/net/bonding/bond_main.c                      |    2 +-
 drivers/net/ethernet/broadcom/cnic.c                 |    2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c      |    2 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c       |    4 ++--
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h         |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c      |    4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/lag.c        |    4 ++--
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c |    4 ++--
 drivers/net/ethernet/qlogic/qede/qede_main.c         |    2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c     |    4 ++--
 drivers/net/ethernet/sfc/efx.c                       |    2 +-
 drivers/net/ethernet/sfc/falcon/efx.c                |    2 +-
 drivers/net/hamradio/bpqether.c                      |    2 +-
 drivers/net/hyperv/netvsc_drv.c                      |    2 +-
 drivers/net/macsec.c                                 |    2 +-
 drivers/net/netconsole.c                             |    2 +-
 drivers/net/ppp/pppoe.c                              |    2 +-
 drivers/net/wan/hdlc.c                               |    2 +-
 drivers/net/wan/lapbether.c                          |    2 +-
 net/appletalk/aarp.c                                 |    2 +-
 net/appletalk/ddp.c                                  |    2 +-
 net/atm/br2684.c                                     |    2 +-
 net/atm/clip.c                                       |    6 +++---
 net/ax25/af_ax25.c                                   |    2 +-
 net/batman-adv/hard-interface.c                      |    2 +-
 net/core/failover.c                                  |    2 +-
 net/core/fib_rules.c                                 |    2 +-
 net/core/rtnetlink.c                                 |    2 +-
 net/decnet/af_decnet.c                               |    2 +-
 net/decnet/dn_fib.c                                  |    2 +-
 net/ipv4/arp.c                                       |    2 +-
 net/ipv4/devinet.c                                   |    2 +-
 net/ipv4/fib_frontend.c                              |    4 ++--
 net/ipv4/igmp.c                                      |    2 +-
 net/ipv4/ipmr.c                                      |    2 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c                   |    2 +-
 net/ipv4/nexthop.c                                   |    2 +-
 net/ipv6/addrconf.c                                  |    2 +-
 net/ipv6/ip6mr.c                                     |    2 +-
 net/ipv6/mcast.c                                     |    2 +-
 net/ipv6/ndisc.c                                     |    2 +-
 net/ipv6/route.c                                     |    2 +-
 net/iucv/af_iucv.c                                   |    2 +-
 net/iucv/iucv.c                                      |    2 +-
 net/mpls/af_mpls.c                                   |    2 +-
 net/ncsi/ncsi-manage.c                               |    2 +-
 net/netfilter/ipvs/ip_vs_ctl.c                       |    2 +-
 net/netfilter/nf_nat_masquerade.c                    |    6 +++---
 net/netfilter/nf_tables_api.c                        |    2 +-
 net/netfilter/nfnetlink_log.c                        |    2 +-
 net/netfilter/nfnetlink_queue.c                      |    4 ++--
 net/netfilter/nft_chain_filter.c                     |    2 +-
 net/netfilter/nft_flow_offload.c                     |    2 +-
 net/netfilter/xt_TEE.c                               |    2 +-
 net/netlabel/netlabel_unlabeled.c                    |    2 +-
 net/netrom/af_netrom.c                               |    2 +-
 net/nfc/netlink.c                                    |    2 +-
 net/packet/af_packet.c                               |    2 +-
 net/rose/af_rose.c                                   |    2 +-
 net/sctp/ipv6.c                                      |    2 +-
 net/sctp/protocol.c                                  |    2 +-
 net/smc/smc_pnet.c                                   |    2 +-
 net/tls/tls_device.c                                 |    2 +-
 net/x25/af_x25.c                                     |   12 ++++++------
 net/xdp/xsk.c                                        |    2 +-
 net/xfrm/xfrm_device.c                               |    2 +-
 66 files changed, 82 insertions(+), 82 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3202,7 +3202,7 @@ static int bond_slave_netdev_event(unsigned long event,
  * locks for us to safely manipulate the slave devices (RTNL lock,
  * dev_probe_lock).
  */
-static int bond_netdev_event(struct notifier_block *this,
+static int bond_netdev_event(struct notifier_block *nb,
 			     unsigned long event, void *ptr)
 {
 	struct net_device *event_dev = netdev_notifier_info_to_dev(ptr);
--- a/drivers/net/ethernet/broadcom/cnic.c
+++ b/drivers/net/ethernet/broadcom/cnic.c
@@ -5672,7 +5672,7 @@ static void cnic_rcv_netevent(struct cnic_local *cp, unsigned long event,
 }
 
 /* netdev event handler */
-static int cnic_netdev_event(struct notifier_block *this, unsigned long event,
+static int cnic_netdev_event(struct notifier_block *nb, unsigned long event,
 							 void *ptr)
 {
 	struct net_device *netdev = netdev_notifier_info_to_dev(ptr);
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -2273,7 +2273,7 @@ static void notify_ulds(struct adapter *adap, enum cxgb4_state new_state)
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
-static int cxgb4_inet6addr_handler(struct notifier_block *this,
+static int cxgb4_inet6addr_handler(struct notifier_block *nb,
 				   unsigned long event, void *data)
 {
 	struct inet6_ifaddr *ifa = data;
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -3020,7 +3020,7 @@ static int mlx4_en_queue_bond_work(struct mlx4_en_priv *priv, int is_bonded,
 	return 0;
 }
 
-int mlx4_en_netdev_event(struct notifier_block *this,
+int mlx4_en_netdev_event(struct notifier_block *nb,
 			 unsigned long event, void *ptr)
 {
 	struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
@@ -3036,7 +3036,7 @@ int mlx4_en_netdev_event(struct notifier_block *this,
 	if (!net_eq(dev_net(ndev), &init_net))
 		return NOTIFY_DONE;
 
-	mdev = container_of(this, struct mlx4_en_dev, nb);
+	mdev = container_of(nb, struct mlx4_en_dev, nb);
 	dev = mdev->dev;
 
 	/* Go into this mode only when two network devices set on two ports
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -794,7 +794,7 @@ void mlx4_en_update_pfc_stats_bitmap(struct mlx4_dev *dev,
 				     struct mlx4_en_stats_bitmap *stats_bitmap,
 				     u8 rx_ppp, u8 rx_pause,
 				     u8 tx_ppp, u8 tx_pause);
-int mlx4_en_netdev_event(struct notifier_block *this,
+int mlx4_en_netdev_event(struct notifier_block *nb,
 			 unsigned long event, void *ptr);
 
 /*
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3657,7 +3657,7 @@ static void mlx5e_tc_hairpin_update_dead_peer(struct mlx5e_priv *priv,
 	}
 }
 
-static int mlx5e_tc_netdev_event(struct notifier_block *this,
+static int mlx5e_tc_netdev_event(struct notifier_block *nb,
 				 unsigned long event, void *ptr)
 {
 	struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
@@ -3671,7 +3671,7 @@ static int mlx5e_tc_netdev_event(struct notifier_block *this,
 	    ndev->reg_state == NETREG_REGISTERED)
 		return NOTIFY_DONE;
 
-	tc = container_of(this, struct mlx5e_tc_table, netdevice_nb);
+	tc = container_of(nb, struct mlx5e_tc_table, netdevice_nb);
 	fs = container_of(tc, struct mlx5e_flow_steering, tc);
 	priv = container_of(fs, struct mlx5e_priv, fs);
 	peer_priv = netdev_priv(ndev);
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -453,7 +453,7 @@ static int mlx5_handle_changelowerstate_event(struct mlx5_lag *ldev,
 	return 1;
 }
 
-static int mlx5_lag_netdev_event(struct notifier_block *this,
+static int mlx5_lag_netdev_event(struct notifier_block *nb,
 				 unsigned long event, void *ptr)
 {
 	struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
@@ -467,7 +467,7 @@ static int mlx5_lag_netdev_event(struct notifier_block *this,
 	if ((event != NETDEV_CHANGEUPPER) && (event != NETDEV_CHANGELOWERSTATE))
 		return NOTIFY_DONE;
 
-	ldev    = container_of(this, struct mlx5_lag, nb);
+	ldev    = container_of(nb, struct mlx5_lag, nb);
 	tracker = ldev->tracker;
 
 	switch (event) {
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -3344,7 +3344,7 @@ static void netxen_config_master(struct net_device *dev, unsigned long event)
 		netxen_free_ip_list(adapter, true);
 }
 
-static int netxen_netdev_event(struct notifier_block *this,
+static int netxen_netdev_event(struct notifier_block *nb,
 				 unsigned long event, void *ptr)
 {
 	struct netxen_adapter *adapter;
@@ -3387,7 +3387,7 @@ static int netxen_netdev_event(struct notifier_block *this,
 }
 
 static int
-netxen_inetaddr_event(struct notifier_block *this,
+netxen_inetaddr_event(struct notifier_block *nb,
 		unsigned long event, void *ptr)
 {
 	struct netxen_adapter *adapter;
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -228,7 +228,7 @@ static struct qed_eth_cb_ops qede_ll_ops = {
 	.ports_update = qede_udp_ports_update,
 };
 
-static int qede_netdev_event(struct notifier_block *this, unsigned long event,
+static int qede_netdev_event(struct notifier_block *nb, unsigned long event,
 			     void *ptr)
 {
 	struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -4162,7 +4162,7 @@ void qlcnic_restore_indev_addr(struct net_device *netdev, unsigned long event)
 	rcu_read_unlock();
 }
 
-static int qlcnic_netdev_event(struct notifier_block *this,
+static int qlcnic_netdev_event(struct notifier_block *nb,
 				 unsigned long event, void *ptr)
 {
 	struct qlcnic_adapter *adapter;
@@ -4194,7 +4194,7 @@ static int qlcnic_netdev_event(struct notifier_block *this,
 }
 
 static int
-qlcnic_inetaddr_event(struct notifier_block *this,
+qlcnic_inetaddr_event(struct notifier_block *nb,
 		unsigned long event, void *ptr)
 {
 	struct qlcnic_adapter *adapter;
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -2498,7 +2498,7 @@ static void efx_update_name(struct efx_nic *efx)
 	efx_set_channel_names(efx);
 }
 
-static int efx_netdev_event(struct notifier_block *this,
+static int efx_netdev_event(struct notifier_block *nb,
 			    unsigned long event, void *ptr)
 {
 	struct net_device *net_dev = netdev_notifier_info_to_dev(ptr);
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2237,7 +2237,7 @@ static void ef4_update_name(struct ef4_nic *efx)
 	ef4_set_channel_names(efx);
 }
 
-static int ef4_netdev_event(struct notifier_block *this,
+static int ef4_netdev_event(struct notifier_block *nb,
 			    unsigned long event, void *ptr)
 {
 	struct net_device *net_dev = netdev_notifier_info_to_dev(ptr);
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -524,7 +524,7 @@ static void bpq_free_device(struct net_device *ndev)
 /*
  *	Handle device status changes.
  */
-static int bpq_device_event(struct notifier_block *this,
+static int bpq_device_event(struct notifier_block *nb,
 			    unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2416,7 +2416,7 @@ static struct  hv_driver netvsc_drv = {
  * to the guest. When the corresponding VF instance is registered,
  * we will take care of switching the data path.
  */
-static int netvsc_netdev_event(struct notifier_block *this,
+static int netvsc_netdev_event(struct notifier_block *nb,
 			       unsigned long event, void *ptr)
 {
 	struct net_device *event_dev = netdev_notifier_info_to_dev(ptr);
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3478,7 +3478,7 @@ static bool is_macsec_master(struct net_device *dev)
 	return rcu_access_pointer(dev->rx_handler) == macsec_handle_frame;
 }
 
-static int macsec_notify(struct notifier_block *this, unsigned long event,
+static int macsec_notify(struct notifier_block *nb, unsigned long event,
 			 void *ptr)
 {
 	struct net_device *real_dev = netdev_notifier_info_to_dev(ptr);
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -688,7 +688,7 @@ static struct configfs_subsystem netconsole_subsys = {
 #endif	/* CONFIG_NETCONSOLE_DYNAMIC */
 
 /* Handle network interface device notifications */
-static int netconsole_netdev_event(struct notifier_block *this,
+static int netconsole_netdev_event(struct notifier_block *nb,
 				   unsigned long event, void *ptr)
 {
 	unsigned long flags;
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -329,7 +329,7 @@ static void pppoe_flush_dev(struct net_device *dev)
 	write_unlock_bh(&pn->hash_lock);
 }
 
-static int pppoe_device_event(struct notifier_block *this,
+static int pppoe_device_event(struct notifier_block *nb,
 			      unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/drivers/net/wan/hdlc.c
+++ b/drivers/net/wan/hdlc.c
@@ -85,7 +85,7 @@ static inline void hdlc_proto_stop(struct net_device *dev)
 
 
 
-static int hdlc_device_event(struct notifier_block *this, unsigned long event,
+static int hdlc_device_event(struct notifier_block *nb, unsigned long event,
 			     void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -359,7 +359,7 @@ static void lapbeth_free_device(struct lapbethdev *lapbeth)
  *
  * Called from notifier with RTNL held.
  */
-static int lapbeth_device_event(struct notifier_block *this,
+static int lapbeth_device_event(struct notifier_block *nb,
 				unsigned long event, void *ptr)
 {
 	struct lapbethdev *lapbeth;
--- a/net/appletalk/aarp.c
+++ b/net/appletalk/aarp.c
@@ -324,7 +324,7 @@ static void aarp_expire_timeout(struct timer_list *unused)
 }
 
 /* Network device notifier chain handler. */
-static int aarp_device_event(struct notifier_block *this, unsigned long event,
+static int aarp_device_event(struct notifier_block *nb, unsigned long event,
 			     void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -635,7 +635,7 @@ static inline void atalk_dev_down(struct net_device *dev)
  * A device event has occurred. Watch for devices going down and
  * delete our use of them (iface and route).
  */
-static int ddp_device_event(struct notifier_block *this, unsigned long event,
+static int ddp_device_event(struct notifier_block *nb, unsigned long event,
 			    void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/atm/br2684.c
+++ b/net/atm/br2684.c
@@ -144,7 +144,7 @@ static struct net_device *br2684_find_dev(const struct br2684_if_spec *s)
 	return NULL;
 }
 
-static int atm_dev_event(struct notifier_block *this, unsigned long event,
+static int atm_dev_event(struct notifier_block *nb, unsigned long event,
 		 void *arg)
 {
 	struct atm_dev *atm_dev = arg;
--- a/net/atm/clip.c
+++ b/net/atm/clip.c
@@ -542,7 +542,7 @@ static int clip_create(int number)
 	return number;
 }
 
-static int clip_device_event(struct notifier_block *this, unsigned long event,
+static int clip_device_event(struct notifier_block *nb, unsigned long event,
 			     void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
@@ -575,7 +575,7 @@ static int clip_device_event(struct notifier_block *this, unsigned long event,
 	return NOTIFY_DONE;
 }
 
-static int clip_inet_event(struct notifier_block *this, unsigned long event,
+static int clip_inet_event(struct notifier_block *nb, unsigned long event,
 			   void *ifa)
 {
 	struct in_device *in_dev;
@@ -589,7 +589,7 @@ static int clip_inet_event(struct notifier_block *this, unsigned long event,
 	if (event != NETDEV_UP)
 		return NOTIFY_DONE;
 	netdev_notifier_info_init(&info, in_dev->dev);
-	return clip_device_event(this, NETDEV_CHANGE, &info);
+	return clip_device_event(nb, NETDEV_CHANGE, &info);
 }
 
 static struct notifier_block clip_dev_notifier = {
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -106,7 +106,7 @@ static void ax25_kill_by_device(struct net_device *dev)
 /*
  *	Handle device status changes.
  */
-static int ax25_device_event(struct notifier_block *this, unsigned long event,
+static int ax25_device_event(struct notifier_block *nb, unsigned long event,
 			     void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -1015,7 +1015,7 @@ static int batadv_hard_if_event_softif(unsigned long event,
 	return NOTIFY_DONE;
 }
 
-static int batadv_hard_if_event(struct notifier_block *this,
+static int batadv_hard_if_event(struct notifier_block *nb,
 				unsigned long event, void *ptr)
 {
 	struct net_device *net_dev = netdev_notifier_info_to_dev(ptr);
--- a/net/core/failover.c
+++ b/net/core/failover.c
@@ -183,7 +183,7 @@ static int failover_slave_name_change(struct net_device *slave_dev)
 }
 
 static int
-failover_event(struct notifier_block *this, unsigned long event, void *ptr)
+failover_event(struct notifier_block *nb, unsigned long event, void *ptr)
 {
 	struct net_device *event_dev = netdev_notifier_info_to_dev(ptr);
 
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -1187,7 +1187,7 @@ static void detach_rules(struct list_head *rules, struct net_device *dev)
 }
 
 
-static int fib_rules_event(struct notifier_block *this, unsigned long event,
+static int fib_rules_event(struct notifier_block *nb, unsigned long event,
 			   void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -5253,7 +5253,7 @@ static int rtnetlink_bind(struct net *net, int group)
 	return 0;
 }
 
-static int rtnetlink_event(struct notifier_block *this, unsigned long event, void *ptr)
+static int rtnetlink_event(struct notifier_block *nb, unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -2076,7 +2076,7 @@ static int dn_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	return err;
 }
 
-static int dn_device_event(struct notifier_block *this, unsigned long event,
+static int dn_device_event(struct notifier_block *nb, unsigned long event,
 			   void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/decnet/dn_fib.c
+++ b/net/decnet/dn_fib.c
@@ -672,7 +672,7 @@ static void dn_fib_disable_addr(struct net_device *dev, int force)
 	neigh_ifdown(&dn_neigh_table, dev);
 }
 
-static int dn_fib_dnaddr_event(struct notifier_block *this, unsigned long event, void *ptr)
+static int dn_fib_dnaddr_event(struct notifier_block *nb, unsigned long event, void *ptr)
 {
 	struct dn_ifaddr *ifa = (struct dn_ifaddr *)ptr;
 
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -1236,7 +1236,7 @@ int arp_ioctl(struct net *net, unsigned int cmd, void __user *arg)
 	return err;
 }
 
-static int arp_netdev_event(struct notifier_block *this, unsigned long event,
+static int arp_netdev_event(struct notifier_block *nb, unsigned long event,
 			    void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1517,7 +1517,7 @@ static void inetdev_send_gratuitous_arp(struct net_device *dev,
 
 /* Called only under RTNL semaphore */
 
-static int inetdev_event(struct notifier_block *this, unsigned long event,
+static int inetdev_event(struct notifier_block *nb, unsigned long event,
 			 void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -1415,7 +1415,7 @@ static void fib_disable_ip(struct net_device *dev, unsigned long event,
 	arp_ifdown(dev);
 }
 
-static int fib_inetaddr_event(struct notifier_block *this, unsigned long event, void *ptr)
+static int fib_inetaddr_event(struct notifier_block *nb, unsigned long event, void *ptr)
 {
 	struct in_ifaddr *ifa = (struct in_ifaddr *)ptr;
 	struct net_device *dev = ifa->ifa_dev->dev;
@@ -1446,7 +1446,7 @@ static int fib_inetaddr_event(struct notifier_block *this, unsigned long event,
 	return NOTIFY_DONE;
 }
 
-static int fib_netdev_event(struct notifier_block *this, unsigned long event, void *ptr)
+static int fib_netdev_event(struct notifier_block *nb, unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct netdev_notifier_changeupper_info *upper_info = ptr;
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -3044,7 +3044,7 @@ static struct pernet_operations igmp_net_ops = {
 };
 #endif
 
-static int igmp_netdev_event(struct notifier_block *this,
+static int igmp_netdev_event(struct notifier_block *nb,
 			     unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1741,7 +1741,7 @@ int ipmr_compat_ioctl(struct sock *sk, unsigned int cmd, void __user *arg)
 }
 #endif
 
-static int ipmr_device_event(struct notifier_block *this, unsigned long event, void *ptr)
+static int ipmr_device_event(struct notifier_block *nb, unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct net *net = dev_net(dev);
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -185,7 +185,7 @@ clusterip_config_init_nodelist(struct clusterip_config *c,
 }
 
 static int
-clusterip_netdev_event(struct notifier_block *this, unsigned long event,
+clusterip_netdev_event(struct notifier_block *nb, unsigned long event,
 		       void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1753,7 +1753,7 @@ static void nexthop_sync_mtu(struct net_device *dev, u32 orig_mtu)
 }
 
 /* rtnl */
-static int nh_netdev_event(struct notifier_block *this,
+static int nh_netdev_event(struct notifier_block *nb,
 			   unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3473,7 +3473,7 @@ static void addrconf_permanent_addr(struct net *net, struct net_device *dev)
 	write_unlock_bh(&idev->lock);
 }
 
-static int addrconf_notify(struct notifier_block *this, unsigned long event,
+static int addrconf_notify(struct notifier_block *nb, unsigned long event,
 			   void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1226,7 +1226,7 @@ static int ip6mr_mfc_delete(struct mr_table *mrt, struct mf6cctl *mfc,
 	return 0;
 }
 
-static int ip6mr_device_event(struct notifier_block *this,
+static int ip6mr_device_event(struct notifier_block *nb,
 			      unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -2638,7 +2638,7 @@ static void ipv6_mc_rejoin_groups(struct inet6_dev *idev)
 		mld_send_report(idev, NULL);
 }
 
-static int ipv6_mc_netdev_event(struct notifier_block *this,
+static int ipv6_mc_netdev_event(struct notifier_block *nb,
 				unsigned long event,
 				void *ptr)
 {
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1771,7 +1771,7 @@ int ndisc_rcv(struct sk_buff *skb)
 	return 0;
 }
 
-static int ndisc_netdev_event(struct notifier_block *this, unsigned long event, void *ptr)
+static int ndisc_netdev_event(struct notifier_block *nb, unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct netdev_notifier_change_info *change_info;
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5954,7 +5954,7 @@ void fib6_rt_update(struct net *net, struct fib6_info *rt,
 		rtnl_set_sk_err(net, RTNLGRP_IPV6_ROUTE, err);
 }
 
-static int ip6_route_dev_notify(struct notifier_block *this,
+static int ip6_route_dev_notify(struct notifier_block *nb,
 				unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -2339,7 +2339,7 @@ static void afiucv_hs_callback_txnotify(struct sk_buff *skb,
 /*
  * afiucv_netdev_event: handle netdev notifier chain events
  */
-static int afiucv_netdev_event(struct notifier_block *this,
+static int afiucv_netdev_event(struct notifier_block *nb,
 			       unsigned long event, void *ptr)
 {
 	struct net_device *event_dev = netdev_notifier_info_to_dev(ptr);
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -824,7 +824,7 @@ void iucv_unregister(struct iucv_handler *handler, int smp)
 }
 EXPORT_SYMBOL(iucv_unregister);
 
-static int iucv_reboot_event(struct notifier_block *this,
+static int iucv_reboot_event(struct notifier_block *nb,
 			     unsigned long event, void *ptr)
 {
 	int i;
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -1578,7 +1578,7 @@ static void mpls_ifup(struct net_device *dev, unsigned int flags)
 	}
 }
 
-static int mpls_dev_notify(struct notifier_block *this, unsigned long event,
+static int mpls_dev_notify(struct notifier_block *nb, unsigned long event,
 			   void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/ncsi/ncsi-manage.c
+++ b/net/ncsi/ncsi-manage.c
@@ -1484,7 +1484,7 @@ int ncsi_process_next_channel(struct ncsi_dev_priv *ndp)
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
-static int ncsi_inet6addr_event(struct notifier_block *this,
+static int ncsi_inet6addr_event(struct notifier_block *nb,
 				unsigned long event, void *data)
 {
 	struct inet6_ifaddr *ifa = data;
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1641,7 +1641,7 @@ ip_vs_forget_dev(struct ip_vs_dest *dest, struct net_device *dev)
 /* Netdev event receiver
  * Currently only NETDEV_DOWN is handled to release refs to cached dsts
  */
-static int ip_vs_dst_event(struct notifier_block *this, unsigned long event,
+static int ip_vs_dst_event(struct notifier_block *nb, unsigned long event,
 			   void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/netfilter/nf_nat_masquerade.c
+++ b/net/netfilter/nf_nat_masquerade.c
@@ -72,7 +72,7 @@ static int device_cmp(struct nf_conn *i, void *ifindex)
 	return nat->masq_index == (int)(long)ifindex;
 }
 
-static int masq_device_event(struct notifier_block *this,
+static int masq_device_event(struct notifier_block *nb,
 			     unsigned long event,
 			     void *ptr)
 {
@@ -106,7 +106,7 @@ static int inet_cmp(struct nf_conn *ct, void *ptr)
 	return ifa->ifa_address == tuple->dst.u3.ip;
 }
 
-static int masq_inet_event(struct notifier_block *this,
+static int masq_inet_event(struct notifier_block *nb,
 			   unsigned long event,
 			   void *ptr)
 {
@@ -228,7 +228,7 @@ static void iterate_cleanup_work(struct work_struct *work)
  * As we can have 'a lot' of inet_events (depending on amount of ipv6
  * addresses being deleted), we also need to limit work item queue.
  */
-static int masq_inet6_event(struct notifier_block *this,
+static int masq_inet6_event(struct notifier_block *nb,
 			    unsigned long event, void *ptr)
 {
 	struct inet6_ifaddr *ifa = ptr;
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6154,7 +6154,7 @@ static void nft_flowtable_event(unsigned long event, struct net_device *dev,
 	}
 }
 
-static int nf_tables_flowtable_event(struct notifier_block *this,
+static int nf_tables_flowtable_event(struct notifier_block *nb,
 				     unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -758,7 +758,7 @@ nfulnl_log_packet(struct net *net,
 }
 
 static int
-nfulnl_rcv_nl_event(struct notifier_block *this,
+nfulnl_rcv_nl_event(struct notifier_block *nb,
 		   unsigned long event, void *ptr)
 {
 	struct netlink_notify *n = ptr;
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -941,7 +941,7 @@ nfqnl_dev_drop(struct net *net, int ifindex)
 }
 
 static int
-nfqnl_rcv_dev_event(struct notifier_block *this,
+nfqnl_rcv_dev_event(struct notifier_block *nb,
 		    unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
@@ -971,7 +971,7 @@ static void nfqnl_nf_hook_drop(struct net *net)
 }
 
 static int
-nfqnl_rcv_nl_event(struct notifier_block *this,
+nfqnl_rcv_nl_event(struct notifier_block *nb,
 		   unsigned long event, void *ptr)
 {
 	struct netlink_notify *n = ptr;
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -311,7 +311,7 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
 	}
 }
 
-static int nf_tables_netdev_event(struct notifier_block *this,
+static int nf_tables_netdev_event(struct notifier_block *nb,
 				  unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -208,7 +208,7 @@ static struct nft_expr_type nft_flow_offload_type __read_mostly = {
 	.owner		= THIS_MODULE,
 };
 
-static int flow_offload_netdev_event(struct notifier_block *this,
+static int flow_offload_netdev_event(struct notifier_block *nb,
 				     unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/netfilter/xt_TEE.c
+++ b/net/netfilter/xt_TEE.c
@@ -57,7 +57,7 @@ tee_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 }
 #endif
 
-static int tee_netdev_event(struct notifier_block *this, unsigned long event,
+static int tee_netdev_event(struct notifier_block *nb, unsigned long event,
 			    void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -695,7 +695,7 @@ int netlbl_unlhsh_remove(struct net *net,
  * related entries from the unlabeled connection hash table.
  *
  */
-static int netlbl_unlhsh_netdev_handler(struct notifier_block *this,
+static int netlbl_unlhsh_netdev_handler(struct notifier_block *nb,
 					unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -112,7 +112,7 @@ static void nr_kill_by_device(struct net_device *dev)
 /*
  *	Handle device status changes.
  */
-static int nr_device_event(struct notifier_block *this, unsigned long event, void *ptr)
+static int nr_device_event(struct notifier_block *nb, unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1811,7 +1811,7 @@ static void nfc_urelease_event_work(struct work_struct *work)
 	kfree(w);
 }
 
-static int nfc_genl_rcv_nl_event(struct notifier_block *this,
+static int nfc_genl_rcv_nl_event(struct notifier_block *nb,
 				 unsigned long event, void *ptr)
 {
 	struct netlink_notify *n = ptr;
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -4035,7 +4035,7 @@ static int compat_packet_setsockopt(struct socket *sock, int level, int optname,
 }
 #endif
 
-static int packet_notifier(struct notifier_block *this,
+static int packet_notifier(struct notifier_block *nb,
 			   unsigned long msg, void *ptr)
 {
 	struct sock *sk;
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -200,7 +200,7 @@ static void rose_kill_by_device(struct net_device *dev)
 /*
  *	Handle device status changes.
  */
-static int rose_device_event(struct notifier_block *this,
+static int rose_device_event(struct notifier_block *nb,
 			     unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -71,7 +71,7 @@ static int sctp_v6_cmp_addr(const union sctp_addr *addr1,
  * time and thus corrupt the list.
  * The reader side is protected with RCU.
  */
-static int sctp_inet6addr_event(struct notifier_block *this, unsigned long ev,
+static int sctp_inet6addr_event(struct notifier_block *nb, unsigned long ev,
 				void *ptr)
 {
 	struct inet6_ifaddr *ifa = (struct inet6_ifaddr *)ptr;
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -751,7 +751,7 @@ void sctp_addr_wq_mgmt(struct net *net, struct sctp_sockaddr_entry *addr, int cm
  * time and thus corrupt the list.
  * The reader side is protected with RCU.
  */
-static int sctp_inetaddr_event(struct notifier_block *this, unsigned long ev,
+static int sctp_inetaddr_event(struct notifier_block *nb, unsigned long ev,
 			       void *ptr)
 {
 	struct in_ifaddr *ifa = (struct in_ifaddr *)ptr;
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -651,7 +651,7 @@ static struct genl_family smc_pnet_nl_family __ro_after_init = {
 	.n_ops =  ARRAY_SIZE(smc_pnet_ops)
 };
 
-static int smc_pnet_netdev_event(struct notifier_block *this,
+static int smc_pnet_netdev_event(struct notifier_block *nb,
 				 unsigned long event, void *ptr)
 {
 	struct net_device *event_dev = netdev_notifier_info_to_dev(ptr);
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1134,7 +1134,7 @@ static int tls_device_down(struct net_device *netdev)
 	return NOTIFY_DONE;
 }
 
-static int tls_dev_event(struct notifier_block *this, unsigned long event,
+static int tls_dev_event(struct notifier_block *nb, unsigned long event,
 			 void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -218,11 +218,11 @@ static void x25_kill_by_device(struct net_device *dev)
 /*
  *	Handle device status changes.
  */
-static int x25_device_event(struct notifier_block *this, unsigned long event,
+static int x25_device_event(struct notifier_block *nb, unsigned long event,
 			    void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
-	struct x25_neigh *nb;
+	struct x25_neigh *neigh;
 
 	if (!net_eq(dev_net(dev), &init_net))
 		return NOTIFY_DONE;
@@ -237,10 +237,10 @@ static int x25_device_event(struct notifier_block *this, unsigned long event,
 			x25_link_device_up(dev);
 			break;
 		case NETDEV_GOING_DOWN:
-			nb = x25_get_neigh(dev);
-			if (nb) {
-				x25_terminate_link(nb);
-				x25_neigh_put(nb);
+			neigh = x25_get_neigh(dev);
+			if (neigh) {
+				x25_terminate_link(neigh);
+				x25_neigh_put(neigh);
 			}
 			break;
 		case NETDEV_DOWN:
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -747,7 +747,7 @@ static int xsk_mmap(struct file *file, struct socket *sock,
 			       size, vma->vm_page_prot);
 }
 
-static int xsk_notifier(struct notifier_block *this,
+static int xsk_notifier(struct notifier_block *nb,
 			unsigned long msg, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -378,7 +378,7 @@ static int xfrm_dev_down(struct net_device *dev)
 	return NOTIFY_DONE;
 }
 
-static int xfrm_dev_event(struct notifier_block *this, unsigned long event, void *ptr)
+static int xfrm_dev_event(struct notifier_block *nb, unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 
