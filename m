Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 324E317A812
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 15:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgCEOtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 09:49:45 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:36959 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726049AbgCEOto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 09:49:44 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 340FF22125;
        Thu,  5 Mar 2020 09:49:40 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 05 Mar 2020 09:49:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=jMwzpE
        iaRLQLGJW7Zc6FVJNQKAEABOA9iDYUJYfWWHQ=; b=oQhL85rqC4DUV3cKnpRDTH
        KnEWJI2ZF+gtWtvAMyJs1iuN5icHRexYBXwnNuIStsn3hkIOE5Xt10SkcbuzQERJ
        m+fuYlMvuPCL/k0wMeKC5eno3DV4MQowiM9nSgoWqwdp9STV6yNmbBI673ejNo+B
        zMuLS28DPflolU+fcfD1D7DwVe+0Uv2imLgXREH/ZOvQZYl/yEyB3EDWISE7BTFt
        zKYXtozGTDYk3sc0GbLSST17ZBE64m8jWq2x+9yFLkt4ECTfEP426TmVYNfd2Ixi
        ER4TAfH95t0gR8G7xWJeAIWROIGEcq7b2sjfF2yIY0nKOAEVq0HZ02H3+7EOqK4Q
        ==
X-ME-Sender: <xms:hBFhXhcyixgGKgFS8mMTjVKMaMLINqgxIRGL5eE9-l0Tw6Lr8DqsZA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddutddgjeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucffohhmrghinh
    epuggvvhhitggvshdrnhgvthdptggrphdrlhhinhhkpdhprghrrghmrdhlihhnkhenucfk
    phepudelfedrgeejrdduieehrddvhedunecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:hBFhXm1ZUxUzhTj5gUuWcGbJC5qnZCKB44adkEfJ7WjGUvSS2aLNcA>
    <xmx:hBFhXoL8uXsexWt-rPqXH2G3KnO82XVpleFbdW-_wPU1QxG7tmBjTA>
    <xmx:hBFhXlENct5wVwuiPbKtV-zj3519q-_hCh55vLAHHk0RitBER-bnyw>
    <xmx:hBFhXiQXLXVnMrNop_pgH1q7ud_3d1W2NAUfRvaYFVaTOyUtKuoiJw>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5CB313280059;
        Thu,  5 Mar 2020 09:49:39 -0500 (EST)
Date:   Thu, 5 Mar 2020 16:49:37 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>
Subject: Re: [RFC net-next 1/3] net: marvell: prestera: Add Switchdev driver
 for Prestera family ASIC device 98DX325x (AC3x)
Message-ID: <20200305144937.GA132852@splinter>
References: <20200225163025.9430-1-vadym.kochan@plvision.eu>
 <20200225163025.9430-2-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225163025.9430-2-vadym.kochan@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 04:30:54PM +0000, Vadym Kochan wrote:
> +int mvsw_pr_port_learning_set(struct mvsw_pr_port *port, bool learn)
> +{
> +	return mvsw_pr_hw_port_learning_set(port, learn);
> +}
> +
> +int mvsw_pr_port_flood_set(struct mvsw_pr_port *port, bool flood)
> +{
> +	return mvsw_pr_hw_port_flood_set(port, flood);
> +}

Flooding and learning are per-port attributes? Not per-{port, VLAN} ?
If so, you need to have various restrictions in the driver in case
someone configures multiple vlan devices on top of a port and enslaves
them to different bridges.

> +
> +int mvsw_pr_port_pvid_set(struct mvsw_pr_port *port, u16 vid)
> +{
> +	int err;
> +
> +	if (!vid) {
> +		err = mvsw_pr_hw_port_accept_frame_type_set
> +		    (port, MVSW_ACCEPT_FRAME_TYPE_TAGGED);
> +		if (err)
> +			return err;
> +	} else {
> +		err = mvsw_pr_hw_vlan_port_vid_set(port, vid);
> +		if (err)
> +			return err;
> +		err = mvsw_pr_hw_port_accept_frame_type_set
> +		    (port, MVSW_ACCEPT_FRAME_TYPE_ALL);
> +		if (err)
> +			goto err_port_allow_untagged_set;
> +	}
> +
> +	port->pvid = vid;
> +	return 0;
> +
> +err_port_allow_untagged_set:
> +	mvsw_pr_hw_vlan_port_vid_set(port, port->pvid);
> +	return err;
> +}
> +
> +struct mvsw_pr_port_vlan*
> +mvsw_pr_port_vlan_find_by_vid(const struct mvsw_pr_port *port, u16 vid)
> +{
> +	struct mvsw_pr_port_vlan *port_vlan;
> +
> +	list_for_each_entry(port_vlan, &port->vlans_list, list) {
> +		if (port_vlan->vid == vid)
> +			return port_vlan;
> +	}
> +
> +	return NULL;
> +}
> +
> +struct mvsw_pr_port_vlan*
> +mvsw_pr_port_vlan_create(struct mvsw_pr_port *port, u16 vid)
> +{
> +	bool untagged = vid == MVSW_PR_DEFAULT_VID;
> +	struct mvsw_pr_port_vlan *port_vlan;
> +	int err;
> +
> +	port_vlan = mvsw_pr_port_vlan_find_by_vid(port, vid);
> +	if (port_vlan)
> +		return ERR_PTR(-EEXIST);
> +
> +	err = mvsw_pr_port_vlan_set(port, vid, true, untagged);
> +	if (err)
> +		return ERR_PTR(err);
> +
> +	port_vlan = kzalloc(sizeof(*port_vlan), GFP_KERNEL);
> +	if (!port_vlan) {
> +		err = -ENOMEM;
> +		goto err_port_vlan_alloc;
> +	}
> +
> +	port_vlan->mvsw_pr_port = port;
> +	port_vlan->vid = vid;
> +
> +	list_add(&port_vlan->list, &port->vlans_list);
> +
> +	return port_vlan;
> +
> +err_port_vlan_alloc:
> +	mvsw_pr_port_vlan_set(port, vid, false, false);
> +	return ERR_PTR(err);
> +}
> +
> +static void
> +mvsw_pr_port_vlan_cleanup(struct mvsw_pr_port_vlan *port_vlan)
> +{
> +	if (port_vlan->bridge_port)
> +		mvsw_pr_port_vlan_bridge_leave(port_vlan);
> +}
> +
> +void mvsw_pr_port_vlan_destroy(struct mvsw_pr_port_vlan *port_vlan)
> +{
> +	struct mvsw_pr_port *port = port_vlan->mvsw_pr_port;
> +	u16 vid = port_vlan->vid;
> +
> +	mvsw_pr_port_vlan_cleanup(port_vlan);
> +	list_del(&port_vlan->list);
> +	kfree(port_vlan);
> +	mvsw_pr_hw_vlan_port_set(port, vid, false, false);
> +}
> +
> +int mvsw_pr_port_vlan_set(struct mvsw_pr_port *port, u16 vid,
> +			  bool is_member, bool untagged)
> +{
> +	return mvsw_pr_hw_vlan_port_set(port, vid, is_member, untagged);
> +}
> +
> +static int mvsw_pr_port_create(struct mvsw_pr_switch *sw, u32 id)
> +{
> +	struct net_device *net_dev;
> +	struct mvsw_pr_port *port;
> +	char *mac;
> +	int err;
> +
> +	net_dev = alloc_etherdev(sizeof(*port));
> +	if (!net_dev)
> +		return -ENOMEM;
> +
> +	port = netdev_priv(net_dev);
> +
> +	INIT_LIST_HEAD(&port->vlans_list);
> +	port->pvid = MVSW_PR_DEFAULT_VID;

If you're using VID 1, then you need to make sure that user cannot
configure a VLAN device with with this VID. If possible, I suggest that
you use VID 4095, as it cannot be configured from user space.

I'm actually not entirely sure why you need a default VID.

> +	port->net_dev = net_dev;
> +	port->id = id;
> +	port->sw = sw;
> +
> +	err = mvsw_pr_hw_port_info_get(port, &port->fp_id,
> +				       &port->hw_id, &port->dev_id);
> +	if (err) {
> +		dev_err(mvsw_dev(sw), "Failed to get port(%u) info\n", id);
> +		goto err_register_netdev;
> +	}
> +
> +	net_dev->features |= NETIF_F_NETNS_LOCAL | NETIF_F_HW_L2FW_DOFFLOAD;

Not sure why you need 'NETIF_F_HW_L2FW_DOFFLOAD'. It was introduced by
commit a6cc0cfa72e0 ("net: Add layer 2 hardware acceleration operations
for macvlan devices").


> +	net_dev->ethtool_ops = &mvsw_pr_ethtool_ops;
> +	net_dev->netdev_ops = &mvsw_pr_netdev_ops;
> +
> +	netif_carrier_off(net_dev);
> +
> +	net_dev->mtu = min_t(unsigned int, sw->mtu_max, MVSW_PR_MTU_DEFAULT);
> +	net_dev->min_mtu = sw->mtu_min;
> +	net_dev->max_mtu = sw->mtu_max;
> +
> +	err = mvsw_pr_hw_port_mtu_set(port, net_dev->mtu);
> +	if (err) {
> +		dev_err(mvsw_dev(sw), "Failed to set port(%u) mtu\n", id);
> +		goto err_register_netdev;
> +	}
> +
> +	/* Only 0xFF mac addrs are supported */
> +	if (port->fp_id >= 0xFF)
> +		goto err_register_netdev;
> +
> +	mac = net_dev->dev_addr;
> +	memcpy(mac, sw->base_mac, net_dev->addr_len - 1);
> +	mac[net_dev->addr_len - 1] = (char)port->fp_id;
> +
> +	err = mvsw_pr_hw_port_mac_set(port, mac);
> +	if (err) {
> +		dev_err(mvsw_dev(sw), "Failed to set port(%u) mac addr\n", id);
> +		goto err_register_netdev;
> +	}
> +
> +	err = mvsw_pr_hw_port_cap_get(port, &port->caps);
> +	if (err) {
> +		dev_err(mvsw_dev(sw), "Failed to get port(%u) caps\n", id);
> +		goto err_register_netdev;
> +	}
> +
> +	port->adver_link_modes = 0;
> +	port->adver_fec = 1 << MVSW_PORT_FEC_OFF_BIT;
> +	port->autoneg = false;
> +	mvsw_pr_port_autoneg_set(port, true, port->caps.supp_link_modes,
> +				 port->caps.supp_fec);
> +
> +	err = mvsw_pr_hw_port_state_set(port, false);
> +	if (err) {
> +		dev_err(mvsw_dev(sw), "Failed to set port(%u) down\n", id);
> +		goto err_register_netdev;
> +	}
> +
> +	INIT_DELAYED_WORK(&port->cached_hw_stats.caching_dw,
> +			  &update_stats_cache);
> +
> +	err = register_netdev(net_dev);
> +	if (err)
> +		goto err_register_netdev;
> +
> +	list_add(&port->list, &sw->port_list);

Once you register the netdev it can be accessed by anyone, so it should
be the last operation.

> +
> +	return 0;
> +
> +err_register_netdev:
> +	free_netdev(net_dev);
> +	return err;
> +}

You need to have port_destroy() here. It's much easier to review when
create / destroy are next to each other. You can easily check that they
are symmetric. Same for other functions in the driver.

> +
> +static void mvsw_pr_port_vlan_flush(struct mvsw_pr_port *port,
> +				    bool flush_default)
> +{
> +	struct mvsw_pr_port_vlan *port_vlan, *tmp;
> +
> +	list_for_each_entry_safe(port_vlan, tmp, &port->vlans_list, list) {
> +		if (!flush_default && port_vlan->vid == MVSW_PR_DEFAULT_VID)
> +			continue;
> +
> +		mvsw_pr_port_vlan_destroy(port_vlan);
> +	}
> +}
> +
> +int mvsw_pr_8021d_bridge_create(struct mvsw_pr_switch *sw, u16 *bridge_id)
> +{
> +	return mvsw_pr_hw_bridge_create(sw, bridge_id);
> +}
> +
> +int mvsw_pr_8021d_bridge_delete(struct mvsw_pr_switch *sw, u16 bridge_id)
> +{
> +	return mvsw_pr_hw_bridge_delete(sw, bridge_id);
> +}
> +
> +int mvsw_pr_8021d_bridge_port_add(struct mvsw_pr_port *port, u16 bridge_id)
> +{
> +	return mvsw_pr_hw_bridge_port_add(port, bridge_id);
> +}
> +
> +int mvsw_pr_8021d_bridge_port_delete(struct mvsw_pr_port *port, u16 bridge_id)
> +{
> +	return mvsw_pr_hw_bridge_port_delete(port, bridge_id);
> +}
> +
> +int mvsw_pr_switch_ageing_set(struct mvsw_pr_switch *sw, u32 ageing_time)
> +{
> +	return mvsw_pr_hw_switch_ageing_set(sw, ageing_time);
> +}
> +
> +int mvsw_pr_fdb_flush_vlan(struct mvsw_pr_switch *sw, u16 vid,
> +			   enum mvsw_pr_fdb_flush_mode mode)
> +{
> +	return mvsw_pr_hw_fdb_flush_vlan(sw, vid, mode);
> +}
> +
> +int mvsw_pr_fdb_flush_port_vlan(struct mvsw_pr_port *port, u16 vid,
> +				enum mvsw_pr_fdb_flush_mode mode)
> +{
> +	return mvsw_pr_hw_fdb_flush_port_vlan(port, vid, mode);
> +}
> +
> +int mvsw_pr_fdb_flush_port(struct mvsw_pr_port *port,
> +			   enum mvsw_pr_fdb_flush_mode mode)
> +{
> +	return mvsw_pr_hw_fdb_flush_port(port, mode);
> +}
> +
> +static int mvsw_pr_clear_ports(struct mvsw_pr_switch *sw)
> +{
> +	struct net_device *net_dev;
> +	struct list_head *pos, *n;
> +	struct mvsw_pr_port *port;
> +
> +	list_for_each_safe(pos, n, &sw->port_list) {
> +		port = list_entry(pos, typeof(*port), list);
> +		net_dev = port->net_dev;
> +
> +		cancel_delayed_work_sync(&port->cached_hw_stats.caching_dw);
> +		unregister_netdev(net_dev);
> +		mvsw_pr_port_vlan_flush(port, true);
> +		WARN_ON_ONCE(!list_empty(&port->vlans_list));
> +		free_netdev(net_dev);
> +		list_del(pos);
> +	}
> +	return (!list_empty(&sw->port_list));
> +}
> +
> +static void mvsw_pr_port_handle_event(struct mvsw_pr_switch *sw,
> +				      struct mvsw_pr_event *evt)
> +{
> +	struct mvsw_pr_port *port;
> +	struct delayed_work *caching_dw;
> +
> +	port = __find_pr_port(sw, evt->port_evt.port_id);
> +	if (!port)
> +		return;
> +
> +	caching_dw = &port->cached_hw_stats.caching_dw;
> +
> +	switch (evt->id) {
> +	case MVSW_PORT_EVENT_STATE_CHANGED:
> +		if (evt->port_evt.data.oper_state) {
> +			netif_carrier_on(port->net_dev);
> +			if (!delayed_work_pending(caching_dw))
> +				queue_delayed_work(mvsw_pr_wq, caching_dw, 0);
> +		} else {
> +			netif_carrier_off(port->net_dev);
> +			if (delayed_work_pending(caching_dw))
> +				cancel_delayed_work(caching_dw);
> +		}
> +		break;
> +	}
> +}
> +
> +static void mvsw_pr_fdb_handle_event(struct mvsw_pr_switch *sw,
> +				     struct mvsw_pr_event *evt)
> +{
> +	struct switchdev_notifier_fdb_info info;
> +	struct mvsw_pr_port *port;
> +
> +	port = __find_pr_port(sw, evt->fdb_evt.port_id);
> +	if (!port)
> +		return;
> +
> +	info.addr = evt->fdb_evt.data.mac;
> +	info.vid = evt->fdb_evt.vid;
> +	info.offloaded = true;
> +
> +	rtnl_lock();
> +	switch (evt->id) {
> +	case MVSW_FDB_EVENT_LEARNED:
> +		call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE,
> +					 port->net_dev, &info.info, NULL);
> +		break;
> +	case MVSW_FDB_EVENT_AGED:
> +		call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_BRIDGE,
> +					 port->net_dev, &info.info, NULL);
> +		break;
> +	}

This looks misplaced. You update the bridge about new FDBs in
prestera.c, but offload FDBs from the bridge in prestera_switchdev.c

Both should be implemented in the file that implements all
bridge-related operations.

> +	rtnl_unlock();
> +	return;
> +}
> +
> +int mvsw_pr_fdb_add(struct mvsw_pr_port *port, const unsigned char *mac,
> +		    u16 vid, bool dynamic)
> +{
> +	return mvsw_pr_hw_fdb_add(port, mac, vid, dynamic);
> +}
> +
> +int mvsw_pr_fdb_del(struct mvsw_pr_port *port, const unsigned char *mac,
> +		    u16 vid)
> +{
> +	return mvsw_pr_hw_fdb_del(port, mac, vid);
> +}
> +
> +static void mvsw_pr_fdb_event_handler_unregister(struct mvsw_pr_switch *sw)
> +{
> +	mvsw_pr_hw_event_handler_unregister(sw, MVSW_EVENT_TYPE_FDB,
> +					    mvsw_pr_fdb_handle_event);
> +}
> +
> +static void mvsw_pr_port_event_handler_unregister(struct mvsw_pr_switch *sw)
> +{
> +	mvsw_pr_hw_event_handler_unregister(sw, MVSW_EVENT_TYPE_PORT,
> +					    mvsw_pr_port_handle_event);
> +}
> +
> +static void mvsw_pr_event_handlers_unregister(struct mvsw_pr_switch *sw)
> +{
> +	mvsw_pr_fdb_event_handler_unregister(sw);
> +	mvsw_pr_port_event_handler_unregister(sw);
> +}
> +
> +static int mvsw_pr_fdb_event_handler_register(struct mvsw_pr_switch *sw)
> +{
> +	return mvsw_pr_hw_event_handler_register(sw, MVSW_EVENT_TYPE_FDB,
> +						 mvsw_pr_fdb_handle_event);
> +}
> +
> +static int mvsw_pr_port_event_handler_register(struct mvsw_pr_switch *sw)
> +{
> +	return mvsw_pr_hw_event_handler_register(sw, MVSW_EVENT_TYPE_PORT,
> +						 mvsw_pr_port_handle_event);
> +}
> +
> +static int mvsw_pr_event_handlers_register(struct mvsw_pr_switch *sw)
> +{
> +	int err;
> +
> +	err = mvsw_pr_port_event_handler_register(sw);
> +	if (err)
> +		return err;
> +
> +	err = mvsw_pr_fdb_event_handler_register(sw);
> +	if (err)
> +		goto err_fdb_handler_register;
> +
> +	return 0;
> +
> +err_fdb_handler_register:
> +	mvsw_pr_port_event_handler_unregister(sw);
> +	return err;
> +}
> +
> +static int mvsw_pr_init(struct mvsw_pr_switch *sw)
> +{
> +	u32 port;
> +	int err;
> +
> +	err = mvsw_pr_hw_switch_init(sw);
> +	if (err) {
> +		dev_err(mvsw_dev(sw), "Failed to init Switch device\n");
> +		return err;
> +	}
> +
> +	dev_info(mvsw_dev(sw), "Initialized Switch device\n");

Best to remove it, it has very little value. Same in other places.

> +
> +	err = mvsw_pr_switchdev_register(sw);
> +	if (err)
> +		return err;
> +
> +	INIT_LIST_HEAD(&sw->port_list);

I understand ports cannot come and go now, but in the future you might
support port splitting and need to remove netdevs mid-operation. So
please consider how you're going to handle locking around this list.

> +
> +	for (port = 0; port < sw->port_count; port++) {
> +		err = mvsw_pr_port_create(sw, port);
> +		if (err)
> +			goto err_ports_init;
> +	}
> +
> +	err = mvsw_pr_event_handlers_register(sw);

This looks incorrect to me. IIUC, here you register handlers for port up
/ down events and FDB entries learn / age-out events. However, by this
time the netdevs are already registered and therefore it is possible
that you missed a few events.

Registering the netdevs should probably be the last thing you do during
init.

> +	if (err)
> +		goto err_ports_init;
> +
> +	return 0;
> +
> +err_ports_init:
> +	mvsw_pr_clear_ports(sw);
> +	return err;
> +}
> +
> +static void mvsw_pr_fini(struct mvsw_pr_switch *sw)
> +{
> +	mvsw_pr_event_handlers_unregister(sw);
> +

No need for this blank line

> +	mvsw_pr_switchdev_unregister(sw);
> +	mvsw_pr_clear_ports(sw);

This is not symmetric with respect to mvsw_pr_init().

Also, you create each port individually by calling
mvsw_pr_port_create(), but destroy all of them by calling
mvsw_pr_clear_ports(). I suggest to add mvsw_pr_ports_create() which
will call mvsw_pr_port_create() for each port. Then have
mvsw_pr_ports_destroy() and mvsw_pr_port_destroy()

Much easier to review and less error-prone. Same for other functions
that have a reverse function.

> +}
> +
> +int mvsw_pr_device_register(struct mvsw_pr_device *dev)
> +{
> +	struct mvsw_pr_switch *sw;
> +	int err;
> +
> +	sw = kzalloc(sizeof(*sw), GFP_KERNEL);
> +	if (!sw)
> +		return -ENOMEM;
> +
> +	dev->priv = sw;
> +	sw->dev = dev;
> +
> +	err = mvsw_pr_init(sw);
> +	if (err) {
> +		kfree(sw);

goto

> +		return err;
> +	}
> +
> +	list_add(&sw->list, &switches_registered);

Looks like this list is never iterated, so best to remove it.

> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(mvsw_pr_device_register);
> +
> +void mvsw_pr_device_unregister(struct mvsw_pr_device *dev)
> +{
> +	struct mvsw_pr_switch *sw = dev->priv;
> +
> +	list_del(&sw->list);
> +	mvsw_pr_fini(sw);
> +	kfree(sw);
> +}
> +EXPORT_SYMBOL(mvsw_pr_device_unregister);
> +
> +static int __init mvsw_pr_module_init(void)
> +{
> +	INIT_LIST_HEAD(&switches_registered);
> +
> +	mvsw_pr_wq = alloc_workqueue(mvsw_driver_name, 0, 0);
> +	if (!mvsw_pr_wq)
> +		return -ENOMEM;
> +
> +	pr_info("Loading Marvell Prestera Switch Driver\n");
> +	return 0;
> +}
> +
> +static void __exit mvsw_pr_module_exit(void)
> +{
> +	destroy_workqueue(mvsw_pr_wq);
> +
> +	pr_info("Unloading Marvell Prestera Switch Driver\n");
> +}
> +
> +module_init(mvsw_pr_module_init);
> +module_exit(mvsw_pr_module_exit);
> +
> +MODULE_AUTHOR("Marvell Semi.");
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("Marvell Prestera switch driver");
> +MODULE_VERSION(PRESTERA_DRV_VER);
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
> new file mode 100644
> index 000000000000..cbc6b0c78937
> --- /dev/null
> +++ b/drivers/net/ethernet/marvell/prestera/prestera.h
> @@ -0,0 +1,244 @@
> +/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
> + *
> + * Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved.
> + *
> + */
> +
> +#ifndef _MVSW_PRESTERA_H_
> +#define _MVSW_PRESTERA_H_
> +
> +#include <linux/skbuff.h>
> +#include <linux/notifier.h>
> +#include <uapi/linux/if_ether.h>
> +#include <linux/workqueue.h>
> +
> +#define MVSW_MSG_MAX_SIZE 1500
> +
> +#define MVSW_PR_DEFAULT_VID 1
> +
> +#define MVSW_PR_MIN_AGEING_TIME 10
> +#define MVSW_PR_MAX_AGEING_TIME 1000000
> +#define MVSW_PR_DEFAULT_AGEING_TIME 300

I assume this is in seconds, so you might want to note it in the name or
comment

> +
> +struct mvsw_fw_rev {
> +	u16 maj;
> +	u16 min;
> +	u16 sub;
> +};
> +
> +struct mvsw_pr_bridge_port;
> +
> +struct mvsw_pr_port_vlan {
> +	struct list_head list;
> +	struct mvsw_pr_port *mvsw_pr_port;
> +	u16 vid;
> +	struct mvsw_pr_bridge_port *bridge_port;
> +	struct list_head bridge_vlan_node;
> +};
> +
> +struct mvsw_pr_port_stats {
> +	u64 good_octets_received;
> +	u64 bad_octets_received;
> +	u64 mac_trans_error;
> +	u64 broadcast_frames_received;
> +	u64 multicast_frames_received;
> +	u64 frames_64_octets;
> +	u64 frames_65_to_127_octets;
> +	u64 frames_128_to_255_octets;
> +	u64 frames_256_to_511_octets;
> +	u64 frames_512_to_1023_octets;
> +	u64 frames_1024_to_max_octets;
> +	u64 excessive_collision;
> +	u64 multicast_frames_sent;
> +	u64 broadcast_frames_sent;
> +	u64 fc_sent;
> +	u64 fc_received;
> +	u64 buffer_overrun;
> +	u64 undersize;
> +	u64 fragments;
> +	u64 oversize;
> +	u64 jabber;
> +	u64 rx_error_frame_received;
> +	u64 bad_crc;
> +	u64 collisions;
> +	u64 late_collision;
> +	u64 unicast_frames_received;
> +	u64 unicast_frames_sent;
> +	u64 sent_multiple;
> +	u64 sent_deferred;
> +	u64 frames_1024_to_1518_octets;
> +	u64 frames_1519_to_max_octets;
> +	u64 good_octets_sent;
> +};
> +
> +struct mvsw_pr_port_caps {
> +	u64 supp_link_modes;
> +	u8 supp_fec;
> +	u8 type;
> +	u8 transceiver;
> +};
> +
> +struct mvsw_pr_port {
> +	struct net_device *net_dev;
> +	struct mvsw_pr_switch *sw;
> +	u32 id;
> +	u32 hw_id;
> +	u32 dev_id;
> +	u16 fp_id;
> +	u16 pvid;
> +	bool autoneg;
> +	u64 adver_link_modes;
> +	u8 adver_fec;
> +	struct mvsw_pr_port_caps caps;
> +	struct list_head list;
> +	struct list_head vlans_list;
> +	struct {
> +		struct mvsw_pr_port_stats stats;
> +		struct delayed_work caching_dw;
> +	} cached_hw_stats;
> +};
> +
> +struct mvsw_pr_switchdev {
> +	struct mvsw_pr_switch *sw;
> +	struct notifier_block swdev_n;
> +	struct notifier_block swdev_blocking_n;
> +};
> +
> +struct mvsw_pr_fib {
> +	struct mvsw_pr_switch *sw;
> +	struct notifier_block fib_nb;
> +	struct notifier_block netevent_nb;
> +};

Does not seem to be used anywhere.

> +
> +struct mvsw_pr_device {
> +	struct device *dev;
> +	struct mvsw_fw_rev fw_rev;
> +	void *priv;
> +
> +	/* called by device driver to pass event up to the higher layer */
> +	int (*recv_msg)(struct mvsw_pr_device *dev, u8 *msg, size_t size);
> +
> +	/* called by higher layer to send request to the firmware */
> +	int (*send_req)(struct mvsw_pr_device *dev, u8 *in_msg,
> +			size_t in_size, u8 *out_msg, size_t out_size,
> +			unsigned int wait);
> +};
> +
> +enum mvsw_pr_event_type {
> +	MVSW_EVENT_TYPE_UNSPEC,
> +	MVSW_EVENT_TYPE_PORT,
> +	MVSW_EVENT_TYPE_FDB,
> +
> +	MVSW_EVENT_TYPE_MAX,
> +};
> +
> +enum mvsw_pr_port_event_id {
> +	MVSW_PORT_EVENT_UNSPEC,
> +	MVSW_PORT_EVENT_STATE_CHANGED,
> +
> +	MVSW_PORT_EVENT_MAX,
> +};
> +
> +enum mvsw_pr_fdb_event_id {
> +	MVSW_FDB_EVENT_UNSPEC,
> +	MVSW_FDB_EVENT_LEARNED,
> +	MVSW_FDB_EVENT_AGED,
> +
> +	MVSW_FDB_EVENT_MAX,
> +};
> +
> +struct mvsw_pr_fdb_event {
> +	u32 port_id;
> +	u32 vid;
> +	union {
> +		u8 mac[ETH_ALEN];
> +	} data;
> +};
> +
> +struct mvsw_pr_port_event {
> +	u32 port_id;
> +	union {
> +		u32 oper_state;
> +	} data;
> +};
> +
> +struct mvsw_pr_event {
> +	u16 id;
> +	union {
> +		struct mvsw_pr_port_event port_evt;
> +		struct mvsw_pr_fdb_event fdb_evt;
> +	};
> +};
> +
> +struct mvsw_pr_bridge;
> +
> +struct mvsw_pr_switch {
> +	struct list_head list;
> +	struct mvsw_pr_device *dev;
> +	struct list_head event_handlers;
> +	char base_mac[ETH_ALEN];
> +	struct list_head port_list;
> +	u32 port_count;
> +	u32 mtu_min;
> +	u32 mtu_max;
> +	u8 id;
> +	struct mvsw_pr_bridge *bridge;
> +	struct mvsw_pr_switchdev *switchdev;
> +	struct mvsw_pr_fib *fib;

Not used

> +	struct notifier_block netdevice_nb;
> +};
> +
> +enum mvsw_pr_fdb_flush_mode {
> +	MVSW_PR_FDB_FLUSH_MODE_DYNAMIC = BIT(0),
> +	MVSW_PR_FDB_FLUSH_MODE_STATIC = BIT(1),
> +	MVSW_PR_FDB_FLUSH_MODE_ALL = MVSW_PR_FDB_FLUSH_MODE_DYNAMIC
> +				   | MVSW_PR_FDB_FLUSH_MODE_STATIC,
> +};
> +
> +int mvsw_pr_switch_ageing_set(struct mvsw_pr_switch *sw, u32 ageing_time);
> +
> +int mvsw_pr_port_learning_set(struct mvsw_pr_port *mvsw_pr_port,
> +			      bool learn_enable);
> +int mvsw_pr_port_flood_set(struct mvsw_pr_port *mvsw_pr_port, bool flood);
> +int mvsw_pr_port_pvid_set(struct mvsw_pr_port *mvsw_pr_port, u16 vid);
> +struct mvsw_pr_port_vlan *
> +mvsw_pr_port_vlan_create(struct mvsw_pr_port *mvsw_pr_port, u16 vid);
> +void mvsw_pr_port_vlan_destroy(struct mvsw_pr_port_vlan *mvsw_pr_port_vlan);
> +int mvsw_pr_port_vlan_set(struct mvsw_pr_port *mvsw_pr_port, u16 vid,
> +			  bool is_member, bool untagged);
> +
> +int mvsw_pr_8021d_bridge_create(struct mvsw_pr_switch *sw, u16 *bridge_id);
> +int mvsw_pr_8021d_bridge_delete(struct mvsw_pr_switch *sw, u16 bridge_id);
> +int mvsw_pr_8021d_bridge_port_add(struct mvsw_pr_port *mvsw_pr_port,
> +				  u16 bridge_id);
> +int mvsw_pr_8021d_bridge_port_delete(struct mvsw_pr_port *mvsw_pr_port,
> +				     u16 bridge_id);
> +
> +int mvsw_pr_fdb_add(struct mvsw_pr_port *mvsw_pr_port, const unsigned char *mac,
> +		    u16 vid, bool dynamic);
> +int mvsw_pr_fdb_del(struct mvsw_pr_port *mvsw_pr_port, const unsigned char *mac,
> +		    u16 vid);
> +int mvsw_pr_fdb_flush_vlan(struct mvsw_pr_switch *sw, u16 vid,
> +			   enum mvsw_pr_fdb_flush_mode mode);
> +int mvsw_pr_fdb_flush_port_vlan(struct mvsw_pr_port *port, u16 vid,
> +				enum mvsw_pr_fdb_flush_mode mode);
> +int mvsw_pr_fdb_flush_port(struct mvsw_pr_port *port,
> +			   enum mvsw_pr_fdb_flush_mode mode);
> +
> +struct mvsw_pr_port_vlan *
> +mvsw_pr_port_vlan_find_by_vid(const struct mvsw_pr_port *mvsw_pr_port, u16 vid);
> +void
> +mvsw_pr_port_vlan_bridge_leave(struct mvsw_pr_port_vlan *mvsw_pr_port_vlan);
> +
> +int mvsw_pr_switchdev_register(struct mvsw_pr_switch *sw);
> +void mvsw_pr_switchdev_unregister(struct mvsw_pr_switch *sw);
> +
> +int mvsw_pr_device_register(struct mvsw_pr_device *dev);
> +void mvsw_pr_device_unregister(struct mvsw_pr_device *dev);
> +
> +bool mvsw_pr_netdev_check(const struct net_device *dev);
> +struct mvsw_pr_port *mvsw_pr_port_dev_lower_find(struct net_device *dev);
> +
> +const struct mvsw_pr_port *mvsw_pr_port_find(u32 dev_hw_id, u32 port_hw_id);
> +
> +#endif /* _MVSW_PRESTERA_H_ */
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_drv_ver.h b/drivers/net/ethernet/marvell/prestera/prestera_drv_ver.h
> new file mode 100644
> index 000000000000..d6617a16d7e1
> --- /dev/null
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_drv_ver.h
> @@ -0,0 +1,23 @@
> +/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
> + *
> + * Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved.
> + *
> + */
> +#ifndef _PRESTERA_DRV_VER_H_
> +#define _PRESTERA_DRV_VER_H_
> +
> +#include <linux/stringify.h>
> +
> +/* Prestera driver version */
> +#define PRESTERA_DRV_VER_MAJOR	1
> +#define PRESTERA_DRV_VER_MINOR	0
> +#define PRESTERA_DRV_VER_PATCH	0
> +#define PRESTERA_DRV_VER_EXTRA
> +
> +#define PRESTERA_DRV_VER \
> +		__stringify(PRESTERA_DRV_VER_MAJOR)  "." \
> +		__stringify(PRESTERA_DRV_VER_MINOR)  "." \
> +		__stringify(PRESTERA_DRV_VER_PATCH)  \
> +		__stringify(PRESTERA_DRV_VER_EXTRA)
> +
> +#endif  /* _PRESTERA_DRV_VER_H_ */
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
> new file mode 100644
> index 000000000000..c97bafdd734e
> --- /dev/null
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
> @@ -0,0 +1,1094 @@
> +/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
> + *
> + * Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved.
> + *
> + */
> +#include <linux/etherdevice.h>
> +#include <linux/ethtool.h>
> +#include <linux/netdevice.h>
> +#include <linux/list.h>
> +
> +#include "prestera.h"
> +#include "prestera_hw.h"
> +
> +#define MVSW_PR_INIT_TIMEOUT 30000000	/* 30sec */
> +#define MVSW_PR_MIN_MTU 64
> +
> +enum mvsw_msg_type {
> +	MVSW_MSG_TYPE_SWITCH_UNSPEC,
> +	MVSW_MSG_TYPE_SWITCH_INIT,
> +
> +	MVSW_MSG_TYPE_AGEING_TIMEOUT_SET,
> +
> +	MVSW_MSG_TYPE_PORT_ATTR_SET,
> +	MVSW_MSG_TYPE_PORT_ATTR_GET,
> +	MVSW_MSG_TYPE_PORT_INFO_GET,
> +
> +	MVSW_MSG_TYPE_VLAN_CREATE,
> +	MVSW_MSG_TYPE_VLAN_DELETE,
> +	MVSW_MSG_TYPE_VLAN_PORT_SET,
> +	MVSW_MSG_TYPE_VLAN_PVID_SET,
> +
> +	MVSW_MSG_TYPE_FDB_ADD,
> +	MVSW_MSG_TYPE_FDB_DELETE,
> +	MVSW_MSG_TYPE_FDB_FLUSH_PORT,
> +	MVSW_MSG_TYPE_FDB_FLUSH_VLAN,
> +	MVSW_MSG_TYPE_FDB_FLUSH_PORT_VLAN,
> +
> +	MVSW_MSG_TYPE_LOG_LEVEL_SET,
> +
> +	MVSW_MSG_TYPE_BRIDGE_CREATE,
> +	MVSW_MSG_TYPE_BRIDGE_DELETE,
> +	MVSW_MSG_TYPE_BRIDGE_PORT_ADD,
> +	MVSW_MSG_TYPE_BRIDGE_PORT_DELETE,
> +
> +	MVSW_MSG_TYPE_ACK,
> +	MVSW_MSG_TYPE_MAX
> +};
> +
> +enum mvsw_msg_port_attr {
> +	MVSW_MSG_PORT_ATTR_ADMIN_STATE,
> +	MVSW_MSG_PORT_ATTR_OPER_STATE,
> +	MVSW_MSG_PORT_ATTR_MTU,
> +	MVSW_MSG_PORT_ATTR_MAC,
> +	MVSW_MSG_PORT_ATTR_SPEED,
> +	MVSW_MSG_PORT_ATTR_ACCEPT_FRAME_TYPE,
> +	MVSW_MSG_PORT_ATTR_LEARNING,
> +	MVSW_MSG_PORT_ATTR_FLOOD,
> +	MVSW_MSG_PORT_ATTR_CAPABILITY,
> +	MVSW_MSG_PORT_ATTR_REMOTE_CAPABILITY,
> +	MVSW_MSG_PORT_ATTR_LINK_MODE,
> +	MVSW_MSG_PORT_ATTR_TYPE,
> +	MVSW_MSG_PORT_ATTR_FEC,
> +	MVSW_MSG_PORT_ATTR_AUTONEG,
> +	MVSW_MSG_PORT_ATTR_DUPLEX,
> +	MVSW_MSG_PORT_ATTR_STATS,
> +	MVSW_MSG_PORT_ATTR_MDIX,
> +	MVSW_MSG_PORT_ATTR_MAX
> +};
> +
> +enum {
> +	MVSW_MSG_ACK_OK,
> +	MVSW_MSG_ACK_FAILED,
> +	MVSW_MSG_ACK_MAX
> +};
> +
> +enum {
> +	MVSW_MODE_FORCED_MDI,
> +	MVSW_MODE_FORCED_MDIX,
> +	MVSW_MODE_AUTO_MDI,
> +	MVSW_MODE_AUTO_MDIX,
> +	MVSW_MODE_AUTO
> +};
> +
> +enum {
> +	MVSW_PORT_GOOD_OCTETS_RCV_CNT,
> +	MVSW_PORT_BAD_OCTETS_RCV_CNT,
> +	MVSW_PORT_MAC_TRANSMIT_ERR_CNT,
> +	MVSW_PORT_BRDC_PKTS_RCV_CNT,
> +	MVSW_PORT_MC_PKTS_RCV_CNT,
> +	MVSW_PORT_PKTS_64_OCTETS_CNT,
> +	MVSW_PORT_PKTS_65TO127_OCTETS_CNT,
> +	MVSW_PORT_PKTS_128TO255_OCTETS_CNT,
> +	MVSW_PORT_PKTS_256TO511_OCTETS_CNT,
> +	MVSW_PORT_PKTS_512TO1023_OCTETS_CNT,
> +	MVSW_PORT_PKTS_1024TOMAX_OCTETS_CNT,
> +	MVSW_PORT_EXCESSIVE_COLLISIONS_CNT,
> +	MVSW_PORT_MC_PKTS_SENT_CNT,
> +	MVSW_PORT_BRDC_PKTS_SENT_CNT,
> +	MVSW_PORT_FC_SENT_CNT,
> +	MVSW_PORT_GOOD_FC_RCV_CNT,
> +	MVSW_PORT_DROP_EVENTS_CNT,
> +	MVSW_PORT_UNDERSIZE_PKTS_CNT,
> +	MVSW_PORT_FRAGMENTS_PKTS_CNT,
> +	MVSW_PORT_OVERSIZE_PKTS_CNT,
> +	MVSW_PORT_JABBER_PKTS_CNT,
> +	MVSW_PORT_MAC_RCV_ERROR_CNT,
> +	MVSW_PORT_BAD_CRC_CNT,
> +	MVSW_PORT_COLLISIONS_CNT,
> +	MVSW_PORT_LATE_COLLISIONS_CNT,
> +	MVSW_PORT_GOOD_UC_PKTS_RCV_CNT,
> +	MVSW_PORT_GOOD_UC_PKTS_SENT_CNT,
> +	MVSW_PORT_MULTIPLE_PKTS_SENT_CNT,
> +	MVSW_PORT_DEFERRED_PKTS_SENT_CNT,
> +	MVSW_PORT_PKTS_1024TO1518_OCTETS_CNT,
> +	MVSW_PORT_PKTS_1519TOMAX_OCTETS_CNT,
> +	MVSW_PORT_GOOD_OCTETS_SENT_CNT,
> +	MVSW_PORT_CNT_MAX,
> +};
> +
> +struct mvsw_msg_cmd {
> +	u32 type;
> +} __packed __aligned(4);
> +
> +struct mvsw_msg_ret {
> +	struct mvsw_msg_cmd cmd;
> +	u32 status;
> +} __packed __aligned(4);
> +
> +struct mvsw_msg_common_request {
> +	struct mvsw_msg_cmd cmd;
> +} __packed __aligned(4);
> +
> +struct mvsw_msg_common_response {
> +	struct mvsw_msg_ret ret;
> +} __packed __aligned(4);
> +
> +union mvsw_msg_switch_param {
> +	u32 ageing_timeout;
> +};
> +
> +struct mvsw_msg_switch_attr_cmd {
> +	struct mvsw_msg_cmd cmd;
> +	union mvsw_msg_switch_param param;
> +} __packed __aligned(4);
> +
> +struct mvsw_msg_switch_init_ret {
> +	struct mvsw_msg_ret ret;
> +	u32 port_count;
> +	u32 mtu_max;
> +	u8  switch_id;
> +	u8  mac[ETH_ALEN];
> +} __packed __aligned(4);
> +
> +struct mvsw_msg_port_autoneg_param {
> +	u64 link_mode;
> +	u8  enable;
> +	u8  fec;
> +};
> +
> +struct mvsw_msg_port_cap_param {
> +	u64 link_mode;
> +	u8  type;
> +	u8  fec;
> +	u8  transceiver;
> +};
> +
> +union mvsw_msg_port_param {
> +	u8  admin_state;
> +	u8  oper_state;
> +	u32 mtu;
> +	u8  mac[ETH_ALEN];
> +	u8  accept_frm_type;
> +	u8  learning;
> +	u32 speed;
> +	u8  flood;
> +	u32 link_mode;
> +	u8  type;
> +	u8  duplex;
> +	u8  fec;
> +	u8  mdix;
> +	struct mvsw_msg_port_autoneg_param autoneg;
> +	struct mvsw_msg_port_cap_param cap;
> +};
> +
> +struct mvsw_msg_port_attr_cmd {
> +	struct mvsw_msg_cmd cmd;
> +	u32 attr;
> +	u32 port;
> +	u32 dev;
> +	union mvsw_msg_port_param param;
> +} __packed __aligned(4);
> +
> +struct mvsw_msg_port_attr_ret {
> +	struct mvsw_msg_ret ret;
> +	union mvsw_msg_port_param param;
> +} __packed __aligned(4);
> +
> +struct mvsw_msg_port_stats_ret {
> +	struct mvsw_msg_ret ret;
> +	u64 stats[MVSW_PORT_CNT_MAX];
> +} __packed __aligned(4);
> +
> +struct mvsw_msg_port_info_cmd {
> +	struct mvsw_msg_cmd cmd;
> +	u32 port;
> +} __packed __aligned(4);
> +
> +struct mvsw_msg_port_info_ret {
> +	struct mvsw_msg_ret ret;
> +	u32 hw_id;
> +	u32 dev_id;
> +	u16 fp_id;
> +} __packed __aligned(4);
> +
> +struct mvsw_msg_vlan_cmd {
> +	struct mvsw_msg_cmd cmd;
> +	u32 port;
> +	u32 dev;
> +	u16 vid;
> +	u8  is_member;
> +	u8  is_tagged;
> +} __packed __aligned(4);
> +
> +struct mvsw_msg_fdb_cmd {
> +	struct mvsw_msg_cmd cmd;
> +	u32 port;
> +	u32 dev;
> +	u8  mac[ETH_ALEN];
> +	u16 vid;
> +	u8  dynamic;
> +	u32 flush_mode;
> +} __packed __aligned(4);
> +
> +struct mvsw_msg_event {
> +	u16 type;
> +	u16 id;
> +} __packed __aligned(4);
> +
> +union mvsw_msg_event_fdb_param {
> +	u8 mac[ETH_ALEN];
> +};
> +
> +struct mvsw_msg_event_fdb {
> +	struct mvsw_msg_event id;
> +	u32 port_id;
> +	u32 vid;
> +	union mvsw_msg_event_fdb_param param;
> +} __packed __aligned(4);
> +
> +union mvsw_msg_event_port_param {
> +	u32 oper_state;
> +};
> +
> +struct mvsw_msg_event_port {
> +	struct mvsw_msg_event id;
> +	u32 port_id;
> +	union mvsw_msg_event_port_param param;
> +} __packed __aligned(4);
> +
> +struct mvsw_msg_bridge_cmd {
> +	struct mvsw_msg_cmd cmd;
> +	u32 port;
> +	u32 dev;
> +	u16 bridge;
> +} __packed __aligned(4);
> +
> +struct mvsw_msg_bridge_ret {
> +	struct mvsw_msg_ret ret;
> +	u16 bridge;
> +} __packed __aligned(4);
> +
> +#define fw_check_resp(_response)	\
> +({								\
> +	int __er = 0;						\
> +	typeof(_response) __r = (_response);			\
> +	if (__r->ret.cmd.type != MVSW_MSG_TYPE_ACK)		\
> +		__er = -EBADE;					\
> +	else if (__r->ret.status != MVSW_MSG_ACK_OK)		\
> +		__er = -EINVAL;					\
> +	(__er);							\
> +})
> +
> +#define __fw_send_req_resp(_switch, _type, _request, _response, _wait)	\
> +({								\
> +	int __e;						\
> +	typeof(_switch) __sw = (_switch);			\
> +	typeof(_request) __req = (_request);			\
> +	typeof(_response) __resp = (_response);			\
> +	__req->cmd.type = (_type);				\
> +	__e = __sw->dev->send_req(__sw->dev,			\
> +		(u8 *)__req, sizeof(*__req),			\
> +		(u8 *)__resp, sizeof(*__resp),			\
> +		_wait);						\
> +	if (!__e)						\
> +		__e = fw_check_resp(__resp);			\
> +	(__e);							\
> +})
> +
> +#define fw_send_req_resp(_sw, _t, _req, _resp)	\
> +	__fw_send_req_resp(_sw, _t, _req, _resp, 0)
> +
> +#define fw_send_req_resp_wait(_sw, _t, _req, _resp, _wait)	\
> +	__fw_send_req_resp(_sw, _t, _req, _resp, _wait)
> +
> +#define fw_send_req(_sw, _t, _req)	\
> +({							\
> +	struct mvsw_msg_common_response __re;		\
> +	(fw_send_req_resp(_sw, _t, _req, &__re));	\
> +})
> +
> +struct mvsw_fw_event_handler {
> +	struct list_head list;
> +	enum mvsw_pr_event_type type;
> +	void (*func)(struct mvsw_pr_switch *sw, struct mvsw_pr_event *evt);
> +};
> +
> +static int fw_parse_port_evt(u8 *msg, struct mvsw_pr_event *evt)
> +{
> +	struct mvsw_msg_event_port *hw_evt = (struct mvsw_msg_event_port *)msg;
> +
> +	evt->port_evt.port_id = hw_evt->port_id;
> +
> +	if (evt->id == MVSW_PORT_EVENT_STATE_CHANGED)
> +		evt->port_evt.data.oper_state = hw_evt->param.oper_state;
> +	else
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int fw_parse_fdb_evt(u8 *msg, struct mvsw_pr_event *evt)
> +{
> +	struct mvsw_msg_event_fdb *hw_evt = (struct mvsw_msg_event_fdb *)msg;
> +
> +	evt->fdb_evt.port_id	= hw_evt->port_id;
> +	evt->fdb_evt.vid	= hw_evt->vid;
> +
> +	memcpy(&evt->fdb_evt.data, &hw_evt->param, sizeof(u8) * ETH_ALEN);
> +
> +	return 0;
> +}
> +
> +struct mvsw_fw_evt_parser {
> +	int (*func)(u8 *msg, struct mvsw_pr_event *evt);
> +};
> +
> +static struct mvsw_fw_evt_parser fw_event_parsers[MVSW_EVENT_TYPE_MAX] = {
> +	[MVSW_EVENT_TYPE_PORT] = {.func = fw_parse_port_evt},
> +	[MVSW_EVENT_TYPE_FDB] = {.func = fw_parse_fdb_evt},
> +};
> +
> +static struct mvsw_fw_event_handler *
> +__find_event_handler(const struct mvsw_pr_switch *sw,
> +		     enum mvsw_pr_event_type type)
> +{
> +	struct mvsw_fw_event_handler *eh;
> +
> +	list_for_each_entry_rcu(eh, &sw->event_handlers, list) {
> +		if (eh->type == type)
> +			return eh;
> +	}
> +
> +	return NULL;
> +}
> +
> +static int fw_event_recv(struct mvsw_pr_device *dev, u8 *buf, size_t size)
> +{
> +	void (*cb)(struct mvsw_pr_switch *sw, struct mvsw_pr_event *evt) = NULL;
> +	struct mvsw_msg_event *msg = (struct mvsw_msg_event *)buf;
> +	struct mvsw_pr_switch *sw = dev->priv;
> +	struct mvsw_fw_event_handler *eh;
> +	struct mvsw_pr_event evt;
> +	int err;
> +
> +	if (msg->type >= MVSW_EVENT_TYPE_MAX)
> +		return -EINVAL;
> +
> +	rcu_read_lock();
> +	eh = __find_event_handler(sw, msg->type);
> +	if (eh)
> +		cb = eh->func;
> +	rcu_read_unlock();
> +
> +	if (!cb || !fw_event_parsers[msg->type].func)
> +		return 0;
> +
> +	evt.id = msg->id;
> +
> +	err = fw_event_parsers[msg->type].func(buf, &evt);
> +	if (!err)
> +		cb(sw, &evt);
> +
> +	return err;
> +}
> +
> +int mvsw_pr_hw_port_info_get(const struct mvsw_pr_port *port,
> +			     u16 *fp_id, u32 *hw_id, u32 *dev_id)
> +{
> +	struct mvsw_msg_port_info_ret resp;
> +	struct mvsw_msg_port_info_cmd req = {
> +		.port = port->id
> +	};
> +	int err;
> +
> +	err = fw_send_req_resp(port->sw, MVSW_MSG_TYPE_PORT_INFO_GET,
> +			       &req, &resp);
> +	if (err)
> +		return err;
> +
> +	*hw_id = resp.hw_id;
> +	*dev_id = resp.dev_id;
> +	*fp_id = resp.fp_id;
> +
> +	return 0;
> +}
> +
> +int mvsw_pr_hw_switch_init(struct mvsw_pr_switch *sw)
> +{
> +	struct mvsw_msg_switch_init_ret resp;
> +	struct mvsw_msg_common_request req;
> +	int err = 0;
> +
> +	INIT_LIST_HEAD(&sw->event_handlers);
> +
> +	err = fw_send_req_resp_wait(sw, MVSW_MSG_TYPE_SWITCH_INIT, &req, &resp,
> +				    MVSW_PR_INIT_TIMEOUT);
> +	if (err)
> +		return err;
> +
> +	sw->id = resp.switch_id;
> +	sw->port_count = resp.port_count;
> +	sw->mtu_min = MVSW_PR_MIN_MTU;
> +	sw->mtu_max = resp.mtu_max;
> +	sw->dev->recv_msg = fw_event_recv;
> +	memcpy(sw->base_mac, resp.mac, ETH_ALEN);
> +
> +	return err;
> +}
> +
> +int mvsw_pr_hw_switch_ageing_set(const struct mvsw_pr_switch *sw,
> +				 u32 ageing_time)
> +{
> +	struct mvsw_msg_switch_attr_cmd req = {
> +		.param = {.ageing_timeout = ageing_time}
> +	};
> +
> +	return fw_send_req(sw, MVSW_MSG_TYPE_AGEING_TIMEOUT_SET, &req);
> +}
> +
> +int mvsw_pr_hw_port_state_set(const struct mvsw_pr_port *port,
> +			      bool admin_state)
> +{
> +	struct mvsw_msg_port_attr_cmd req = {
> +		.attr = MVSW_MSG_PORT_ATTR_ADMIN_STATE,
> +		.port = port->hw_id,
> +		.dev = port->dev_id,
> +		.param = {.admin_state = admin_state ? 1 : 0}
> +	};
> +
> +	return fw_send_req(port->sw, MVSW_MSG_TYPE_PORT_ATTR_SET, &req);
> +}
> +
> +int mvsw_pr_hw_port_state_get(const struct mvsw_pr_port *port,
> +			      bool *admin_state, bool *oper_state)
> +{
> +	struct mvsw_msg_port_attr_ret resp;
> +	struct mvsw_msg_port_attr_cmd req = {
> +		.port = port->hw_id,
> +		.dev = port->dev_id
> +	};
> +	int err;
> +
> +	if (admin_state) {
> +		req.attr = MVSW_MSG_PORT_ATTR_ADMIN_STATE;
> +		err = fw_send_req_resp(port->sw, MVSW_MSG_TYPE_PORT_ATTR_GET,
> +				       &req, &resp);
> +		if (err)
> +			return err;
> +		*admin_state = resp.param.admin_state != 0;
> +	}
> +
> +	if (oper_state) {
> +		req.attr = MVSW_MSG_PORT_ATTR_OPER_STATE;
> +		err = fw_send_req_resp(port->sw, MVSW_MSG_TYPE_PORT_ATTR_GET,
> +				       &req, &resp);
> +		if (err)
> +			return err;
> +		*oper_state = resp.param.oper_state != 0;
> +	}
> +
> +	return 0;
> +}
> +
> +int mvsw_pr_hw_port_mtu_set(const struct mvsw_pr_port *port, u32 mtu)
> +{
> +	struct mvsw_msg_port_attr_cmd req = {
> +		.attr = MVSW_MSG_PORT_ATTR_MTU,
> +		.port = port->hw_id,
> +		.dev = port->dev_id,
> +		.param = {.mtu = mtu}
> +	};
> +
> +	return fw_send_req(port->sw, MVSW_MSG_TYPE_PORT_ATTR_SET, &req);
> +}
> +
> +int mvsw_pr_hw_port_mtu_get(const struct mvsw_pr_port *port, u32 *mtu)
> +{
> +	struct mvsw_msg_port_attr_ret resp;
> +	struct mvsw_msg_port_attr_cmd req = {
> +		.attr = MVSW_MSG_PORT_ATTR_MTU,
> +		.port = port->hw_id,
> +		.dev = port->dev_id
> +	};
> +	int err;
> +
> +	err = fw_send_req_resp(port->sw, MVSW_MSG_TYPE_PORT_ATTR_GET,
> +			       &req, &resp);
> +	if (err)
> +		return err;
> +
> +	*mtu = resp.param.mtu;
> +
> +	return err;
> +}
> +
> +int mvsw_pr_hw_port_mac_set(const struct mvsw_pr_port *port, char *mac)
> +{
> +	struct mvsw_msg_port_attr_cmd req = {
> +		.attr = MVSW_MSG_PORT_ATTR_MAC,
> +		.port = port->hw_id,
> +		.dev = port->dev_id
> +	};
> +	memcpy(&req.param.mac, mac, sizeof(req.param.mac));
> +
> +	return fw_send_req(port->sw, MVSW_MSG_TYPE_PORT_ATTR_SET, &req);
> +}
> +
> +int mvsw_pr_hw_port_mac_get(const struct mvsw_pr_port *port, char *mac)
> +{
> +	struct mvsw_msg_port_attr_ret resp;
> +	struct mvsw_msg_port_attr_cmd req = {
> +		.attr = MVSW_MSG_PORT_ATTR_MAC,
> +		.port = port->hw_id,
> +		.dev = port->dev_id
> +	};
> +	int err;
> +
> +	err = fw_send_req_resp(port->sw, MVSW_MSG_TYPE_PORT_ATTR_GET,
> +			       &req, &resp);
> +	if (err)
> +		return err;
> +
> +	memcpy(mac, resp.param.mac, sizeof(resp.param.mac));
> +
> +	return err;
> +}
> +
> +int mvsw_pr_hw_port_accept_frame_type_set(const struct mvsw_pr_port *port,
> +					  enum mvsw_pr_accept_frame_type type)
> +{
> +	struct mvsw_msg_port_attr_cmd req = {
> +		.attr = MVSW_MSG_PORT_ATTR_ACCEPT_FRAME_TYPE,
> +		.port = port->hw_id,
> +		.dev = port->dev_id,
> +		.param = {.accept_frm_type = type}
> +	};
> +
> +	return fw_send_req(port->sw, MVSW_MSG_TYPE_PORT_ATTR_SET, &req);
> +}
> +
> +int mvsw_pr_hw_port_learning_set(const struct mvsw_pr_port *port, bool enable)
> +{
> +	struct mvsw_msg_port_attr_cmd req = {
> +		.attr = MVSW_MSG_PORT_ATTR_LEARNING,
> +		.port = port->hw_id,
> +		.dev = port->dev_id,
> +		.param = {.learning = enable ? 1 : 0}
> +	};
> +
> +	return fw_send_req(port->sw, MVSW_MSG_TYPE_PORT_ATTR_SET, &req);
> +}
> +
> +int mvsw_pr_hw_event_handler_register(struct mvsw_pr_switch *sw,
> +				      enum mvsw_pr_event_type type,
> +				      void (*cb)(struct mvsw_pr_switch *sw,
> +						 struct mvsw_pr_event *evt))
> +{
> +	struct mvsw_fw_event_handler *eh;
> +
> +	eh = __find_event_handler(sw, type);
> +	if (eh)
> +		return -EEXIST;
> +	eh = kmalloc(sizeof(*eh), GFP_KERNEL);
> +	if (!eh)
> +		return -ENOMEM;
> +
> +	eh->type = type;
> +	eh->func = cb;
> +
> +	INIT_LIST_HEAD(&eh->list);
> +
> +	list_add_rcu(&eh->list, &sw->event_handlers);
> +
> +	return 0;
> +}
> +
> +void mvsw_pr_hw_event_handler_unregister(struct mvsw_pr_switch *sw,
> +					 enum mvsw_pr_event_type type,
> +					 void (*cb)(struct mvsw_pr_switch *sw,
> +						    struct mvsw_pr_event *evt))
> +{
> +	struct mvsw_fw_event_handler *eh;
> +
> +	eh = __find_event_handler(sw, type);
> +	if (!eh)
> +		return;
> +
> +	list_del_rcu(&eh->list);
> +	synchronize_rcu();
> +	kfree(eh);
> +}
> +
> +int mvsw_pr_hw_vlan_create(const struct mvsw_pr_switch *sw, u16 vid)
> +{
> +	struct mvsw_msg_vlan_cmd req = {
> +		.vid = vid,
> +	};
> +
> +	return fw_send_req(sw, MVSW_MSG_TYPE_VLAN_CREATE, &req);
> +}
> +
> +int mvsw_pr_hw_vlan_delete(const struct mvsw_pr_switch *sw, u16 vid)
> +{
> +	struct mvsw_msg_vlan_cmd req = {
> +		.vid = vid,
> +	};
> +
> +	return fw_send_req(sw, MVSW_MSG_TYPE_VLAN_DELETE, &req);
> +}
> +
> +int mvsw_pr_hw_vlan_port_set(const struct mvsw_pr_port *port,
> +			     u16 vid, bool is_member, bool untagged)
> +{
> +	struct mvsw_msg_vlan_cmd req = {
> +		.port = port->hw_id,
> +		.dev = port->dev_id,
> +		.vid = vid,
> +		.is_member = is_member ? 1 : 0,
> +		.is_tagged = untagged ? 0 : 1
> +	};
> +
> +	return fw_send_req(port->sw, MVSW_MSG_TYPE_VLAN_PORT_SET, &req);
> +}
> +
> +int mvsw_pr_hw_vlan_port_vid_set(const struct mvsw_pr_port *port, u16 vid)
> +{
> +	struct mvsw_msg_vlan_cmd req = {
> +		.port = port->hw_id,
> +		.dev = port->dev_id,
> +		.vid = vid
> +	};
> +
> +	return fw_send_req(port->sw, MVSW_MSG_TYPE_VLAN_PVID_SET, &req);
> +}
> +
> +int mvsw_pr_hw_port_speed_get(const struct mvsw_pr_port *port, u32 *speed)
> +{
> +	struct mvsw_msg_port_attr_ret resp;
> +	struct mvsw_msg_port_attr_cmd req = {
> +		.attr = MVSW_MSG_PORT_ATTR_SPEED,
> +		.port = port->hw_id,
> +		.dev = port->dev_id
> +	};
> +	int err;
> +
> +	err = fw_send_req_resp(port->sw, MVSW_MSG_TYPE_PORT_ATTR_GET,
> +			       &req, &resp);
> +	if (err)
> +		return err;
> +
> +	*speed = resp.param.speed;
> +
> +	return err;
> +}
> +
> +int mvsw_pr_hw_port_flood_set(const struct mvsw_pr_port *port, bool flood)
> +{
> +	struct mvsw_msg_port_attr_cmd req = {
> +		.attr = MVSW_MSG_PORT_ATTR_FLOOD,
> +		.port = port->hw_id,
> +		.dev = port->dev_id,
> +		.param = {.flood = flood ? 1 : 0}
> +	};
> +
> +	return fw_send_req(port->sw, MVSW_MSG_TYPE_PORT_ATTR_SET, &req);
> +}
> +
> +int mvsw_pr_hw_fdb_add(const struct mvsw_pr_port *port,
> +		       const unsigned char *mac, u16 vid, bool dynamic)
> +{
> +	struct mvsw_msg_fdb_cmd req = {
> +		.port = port->hw_id,
> +		.dev = port->dev_id,
> +		.vid = vid,
> +		.dynamic = dynamic ? 1 : 0
> +	};
> +
> +	memcpy(req.mac, mac, sizeof(req.mac));
> +
> +	return fw_send_req(port->sw, MVSW_MSG_TYPE_FDB_ADD, &req);
> +}
> +
> +int mvsw_pr_hw_fdb_del(const struct mvsw_pr_port *port,
> +		       const unsigned char *mac, u16 vid)
> +{
> +	struct mvsw_msg_fdb_cmd req = {
> +		.port = port->hw_id,
> +		.dev = port->dev_id,
> +		.vid = vid
> +	};
> +
> +	memcpy(req.mac, mac, sizeof(req.mac));
> +
> +	return fw_send_req(port->sw, MVSW_MSG_TYPE_FDB_DELETE, &req);
> +}
> +
> +int mvsw_pr_hw_port_cap_get(const struct mvsw_pr_port *port,
> +			    struct mvsw_pr_port_caps *caps)
> +{
> +	struct mvsw_msg_port_attr_ret resp;
> +	struct mvsw_msg_port_attr_cmd req = {
> +		.attr = MVSW_MSG_PORT_ATTR_CAPABILITY,
> +		.port = port->hw_id,
> +		.dev = port->dev_id
> +	};
> +	int err;
> +
> +	err = fw_send_req_resp(port->sw, MVSW_MSG_TYPE_PORT_ATTR_GET,
> +			       &req, &resp);
> +	if (err)
> +		return err;
> +
> +	caps->supp_link_modes = resp.param.cap.link_mode;
> +	caps->supp_fec = resp.param.cap.fec;
> +	caps->type = resp.param.cap.type;
> +	caps->transceiver = resp.param.cap.transceiver;
> +
> +	return err;
> +}
> +
> +int mvsw_pr_hw_port_remote_cap_get(const struct mvsw_pr_port *port,
> +				   u64 *link_mode_bitmap)
> +{
> +	struct mvsw_msg_port_attr_ret resp;
> +	struct mvsw_msg_port_attr_cmd req = {
> +		.attr = MVSW_MSG_PORT_ATTR_REMOTE_CAPABILITY,
> +		.port = port->hw_id,
> +		.dev = port->dev_id
> +	};
> +	int err;
> +
> +	err = fw_send_req_resp(port->sw, MVSW_MSG_TYPE_PORT_ATTR_GET,
> +			       &req, &resp);
> +	if (err)
> +		return err;
> +
> +	*link_mode_bitmap = resp.param.cap.link_mode;
> +
> +	return err;
> +}
> +
> +int mvsw_pr_hw_port_mdix_get(const struct mvsw_pr_port *port, u8 *mode)
> +{
> +	struct mvsw_msg_port_attr_ret resp;
> +	struct mvsw_msg_port_attr_cmd req = {
> +		.attr = MVSW_MSG_PORT_ATTR_MDIX,
> +		.port = port->hw_id,
> +		.dev = port->dev_id
> +	};
> +	int err;
> +
> +	err = fw_send_req_resp(port->sw, MVSW_MSG_TYPE_PORT_ATTR_GET,
> +			       &req, &resp);
> +	if (err)
> +		return err;
> +
> +	switch (resp.param.mdix) {
> +	case MVSW_MODE_FORCED_MDI:
> +	case MVSW_MODE_AUTO_MDI:
> +		*mode = ETH_TP_MDI;
> +		break;
> +
> +	case MVSW_MODE_FORCED_MDIX:
> +	case MVSW_MODE_AUTO_MDIX:
> +		*mode = ETH_TP_MDI_X;
> +		break;
> +
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +int mvsw_pr_hw_port_mdix_set(const struct mvsw_pr_port *port, u8 mode)
> +{
> +	struct mvsw_msg_port_attr_cmd req = {
> +		.attr = MVSW_MSG_PORT_ATTR_MDIX,
> +		.port = port->hw_id,
> +		.dev = port->dev_id
> +	};
> +
> +	switch (mode) {
> +	case ETH_TP_MDI:
> +		req.param.mdix = MVSW_MODE_FORCED_MDI;
> +		break;
> +
> +	case ETH_TP_MDI_X:
> +		req.param.mdix = MVSW_MODE_FORCED_MDIX;
> +		break;
> +
> +	case ETH_TP_MDI_AUTO:
> +		req.param.mdix = MVSW_MODE_AUTO;
> +		break;
> +
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return fw_send_req(port->sw, MVSW_MSG_TYPE_PORT_ATTR_SET, &req);
> +}
> +
> +int mvsw_pr_hw_port_type_get(const struct mvsw_pr_port *port, u8 *type)
> +{
> +	struct mvsw_msg_port_attr_ret resp;
> +	struct mvsw_msg_port_attr_cmd req = {
> +		.attr = MVSW_MSG_PORT_ATTR_TYPE,
> +		.port = port->hw_id,
> +		.dev = port->dev_id
> +	};
> +	int err;
> +
> +	err = fw_send_req_resp(port->sw, MVSW_MSG_TYPE_PORT_ATTR_GET,
> +			       &req, &resp);
> +	if (err)
> +		return err;
> +
> +	*type = resp.param.type;
> +
> +	return err;
> +}
> +
> +int mvsw_pr_hw_port_fec_get(const struct mvsw_pr_port *port, u8 *fec)
> +{
> +	struct mvsw_msg_port_attr_ret resp;
> +	struct mvsw_msg_port_attr_cmd req = {
> +		.attr = MVSW_MSG_PORT_ATTR_FEC,
> +		.port = port->hw_id,
> +		.dev = port->dev_id
> +	};
> +	int err;
> +
> +	err = fw_send_req_resp(port->sw, MVSW_MSG_TYPE_PORT_ATTR_GET,
> +			       &req, &resp);
> +	if (err)
> +		return err;
> +
> +	*fec = resp.param.fec;
> +
> +	return err;
> +}
> +
> +int mvsw_pr_hw_port_fec_set(const struct mvsw_pr_port *port, u8 fec)
> +{
> +	struct mvsw_msg_port_attr_cmd req = {
> +		.attr = MVSW_MSG_PORT_ATTR_FEC,
> +		.port = port->hw_id,
> +		.dev = port->dev_id,
> +		.param = {.fec = fec}
> +	};
> +
> +	return fw_send_req(port->sw, MVSW_MSG_TYPE_PORT_ATTR_SET, &req);
> +}
> +
> +int mvsw_pr_hw_port_autoneg_set(const struct mvsw_pr_port *port,
> +				bool autoneg, u64 link_modes, u8 fec)
> +{
> +	struct mvsw_msg_port_attr_cmd req = {
> +		.attr = MVSW_MSG_PORT_ATTR_AUTONEG,
> +		.port = port->hw_id,
> +		.dev = port->dev_id,
> +		.param = {.autoneg = {.link_mode = link_modes,
> +				      .enable = autoneg ? 1 : 0,
> +				      .fec = fec}
> +		}
> +	};
> +
> +	return fw_send_req(port->sw, MVSW_MSG_TYPE_PORT_ATTR_SET, &req);
> +}
> +
> +int mvsw_pr_hw_port_duplex_get(const struct mvsw_pr_port *port, u8 *duplex)
> +{
> +	struct mvsw_msg_port_attr_ret resp;
> +	struct mvsw_msg_port_attr_cmd req = {
> +		.attr = MVSW_MSG_PORT_ATTR_DUPLEX,
> +		.port = port->hw_id,
> +		.dev = port->dev_id
> +	};
> +	int err;
> +
> +	err = fw_send_req_resp(port->sw, MVSW_MSG_TYPE_PORT_ATTR_GET,
> +			       &req, &resp);
> +	if (err)
> +		return err;
> +
> +	*duplex = resp.param.duplex;
> +
> +	return err;
> +}
> +
> +int mvsw_pr_hw_port_stats_get(const struct mvsw_pr_port *port,
> +			      struct mvsw_pr_port_stats *stats)
> +{
> +	struct mvsw_msg_port_stats_ret resp;
> +	struct mvsw_msg_port_attr_cmd req = {
> +		.attr = MVSW_MSG_PORT_ATTR_STATS,
> +		.port = port->hw_id,
> +		.dev = port->dev_id
> +	};
> +	u64 *hw_val = resp.stats;
> +	int err;
> +
> +	err = fw_send_req_resp(port->sw, MVSW_MSG_TYPE_PORT_ATTR_GET,
> +			       &req, &resp);
> +	if (err)
> +		return err;
> +
> +	stats->good_octets_received = hw_val[MVSW_PORT_GOOD_OCTETS_RCV_CNT];
> +	stats->bad_octets_received = hw_val[MVSW_PORT_BAD_OCTETS_RCV_CNT];
> +	stats->mac_trans_error = hw_val[MVSW_PORT_MAC_TRANSMIT_ERR_CNT];
> +	stats->broadcast_frames_received = hw_val[MVSW_PORT_BRDC_PKTS_RCV_CNT];
> +	stats->multicast_frames_received = hw_val[MVSW_PORT_MC_PKTS_RCV_CNT];
> +	stats->frames_64_octets = hw_val[MVSW_PORT_PKTS_64_OCTETS_CNT];
> +	stats->frames_65_to_127_octets =
> +		hw_val[MVSW_PORT_PKTS_65TO127_OCTETS_CNT];
> +	stats->frames_128_to_255_octets =
> +		hw_val[MVSW_PORT_PKTS_128TO255_OCTETS_CNT];
> +	stats->frames_256_to_511_octets =
> +		hw_val[MVSW_PORT_PKTS_256TO511_OCTETS_CNT];
> +	stats->frames_512_to_1023_octets =
> +		hw_val[MVSW_PORT_PKTS_512TO1023_OCTETS_CNT];
> +	stats->frames_1024_to_max_octets =
> +		hw_val[MVSW_PORT_PKTS_1024TOMAX_OCTETS_CNT];
> +	stats->excessive_collision = hw_val[MVSW_PORT_EXCESSIVE_COLLISIONS_CNT];
> +	stats->multicast_frames_sent = hw_val[MVSW_PORT_MC_PKTS_SENT_CNT];
> +	stats->broadcast_frames_sent = hw_val[MVSW_PORT_BRDC_PKTS_SENT_CNT];
> +	stats->fc_sent = hw_val[MVSW_PORT_FC_SENT_CNT];
> +	stats->fc_received = hw_val[MVSW_PORT_GOOD_FC_RCV_CNT];
> +	stats->buffer_overrun = hw_val[MVSW_PORT_DROP_EVENTS_CNT];
> +	stats->undersize = hw_val[MVSW_PORT_UNDERSIZE_PKTS_CNT];
> +	stats->fragments = hw_val[MVSW_PORT_FRAGMENTS_PKTS_CNT];
> +	stats->oversize = hw_val[MVSW_PORT_OVERSIZE_PKTS_CNT];
> +	stats->jabber = hw_val[MVSW_PORT_JABBER_PKTS_CNT];
> +	stats->rx_error_frame_received = hw_val[MVSW_PORT_MAC_RCV_ERROR_CNT];
> +	stats->bad_crc = hw_val[MVSW_PORT_BAD_CRC_CNT];
> +	stats->collisions = hw_val[MVSW_PORT_COLLISIONS_CNT];
> +	stats->late_collision = hw_val[MVSW_PORT_LATE_COLLISIONS_CNT];
> +	stats->unicast_frames_received = hw_val[MVSW_PORT_GOOD_UC_PKTS_RCV_CNT];
> +	stats->unicast_frames_sent = hw_val[MVSW_PORT_GOOD_UC_PKTS_SENT_CNT];
> +	stats->sent_multiple = hw_val[MVSW_PORT_MULTIPLE_PKTS_SENT_CNT];
> +	stats->sent_deferred = hw_val[MVSW_PORT_DEFERRED_PKTS_SENT_CNT];
> +	stats->frames_1024_to_1518_octets =
> +		hw_val[MVSW_PORT_PKTS_1024TO1518_OCTETS_CNT];
> +	stats->frames_1519_to_max_octets =
> +		hw_val[MVSW_PORT_PKTS_1519TOMAX_OCTETS_CNT];
> +	stats->good_octets_sent = hw_val[MVSW_PORT_GOOD_OCTETS_SENT_CNT];
> +
> +	return 0;
> +}
> +
> +int mvsw_pr_hw_bridge_create(const struct mvsw_pr_switch *sw, u16 *bridge_id)
> +{
> +	struct mvsw_msg_bridge_cmd req;
> +	struct mvsw_msg_bridge_ret resp;
> +	int err;
> +
> +	err = fw_send_req_resp(sw, MVSW_MSG_TYPE_BRIDGE_CREATE, &req, &resp);
> +	if (err)
> +		return err;
> +
> +	*bridge_id = resp.bridge;
> +	return err;
> +}
> +
> +int mvsw_pr_hw_bridge_delete(const struct mvsw_pr_switch *sw, u16 bridge_id)
> +{
> +	struct mvsw_msg_bridge_cmd req = {
> +		.bridge = bridge_id
> +	};
> +
> +	return fw_send_req(sw, MVSW_MSG_TYPE_BRIDGE_DELETE, &req);
> +}
> +
> +int mvsw_pr_hw_bridge_port_add(const struct mvsw_pr_port *port, u16 bridge_id)
> +{
> +	struct mvsw_msg_bridge_cmd req = {
> +		.bridge = bridge_id,
> +		.port = port->hw_id,
> +		.dev = port->dev_id
> +	};
> +
> +	return fw_send_req(port->sw, MVSW_MSG_TYPE_BRIDGE_PORT_ADD, &req);
> +}
> +
> +int mvsw_pr_hw_bridge_port_delete(const struct mvsw_pr_port *port,
> +				  u16 bridge_id)
> +{
> +	struct mvsw_msg_bridge_cmd req = {
> +		.bridge = bridge_id,
> +		.port = port->hw_id,
> +		.dev = port->dev_id
> +	};
> +
> +	return fw_send_req(port->sw, MVSW_MSG_TYPE_BRIDGE_PORT_DELETE, &req);
> +}
> +
> +int mvsw_pr_hw_fdb_flush_port(const struct mvsw_pr_port *port, u32 mode)
> +{
> +	struct mvsw_msg_fdb_cmd req = {
> +		.port = port->hw_id,
> +		.dev = port->dev_id,
> +		.flush_mode = mode,
> +	};
> +
> +	return fw_send_req(port->sw, MVSW_MSG_TYPE_FDB_FLUSH_PORT, &req);
> +}
> +
> +int mvsw_pr_hw_fdb_flush_vlan(const struct mvsw_pr_switch *sw, u16 vid,
> +			      u32 mode)
> +{
> +	struct mvsw_msg_fdb_cmd req = {
> +		.vid = vid,
> +		.flush_mode = mode,
> +	};
> +
> +	return fw_send_req(sw, MVSW_MSG_TYPE_FDB_FLUSH_VLAN, &req);
> +}
> +
> +int mvsw_pr_hw_fdb_flush_port_vlan(const struct mvsw_pr_port *port, u16 vid,
> +				   u32 mode)
> +{
> +	struct mvsw_msg_fdb_cmd req = {
> +		.port = port->hw_id,
> +		.dev = port->dev_id,
> +		.vid = vid,
> +		.flush_mode = mode,
> +	};
> +
> +	return fw_send_req(port->sw, MVSW_MSG_TYPE_FDB_FLUSH_PORT_VLAN, &req);
> +}
> +
> +int mvsw_pr_hw_port_link_mode_get(const struct mvsw_pr_port *port,
> +				  u32 *mode)
> +{
> +	struct mvsw_msg_port_attr_ret resp;
> +	struct mvsw_msg_port_attr_cmd req = {
> +		.attr = MVSW_MSG_PORT_ATTR_LINK_MODE,
> +		.port = port->hw_id,
> +		.dev = port->dev_id
> +	};
> +	int err;
> +
> +	err = fw_send_req_resp(port->sw, MVSW_MSG_TYPE_PORT_ATTR_GET,
> +			       &req, &resp);
> +	if (err)
> +		return err;
> +
> +	*mode = resp.param.link_mode;
> +
> +	return err;
> +}
> +
> +int mvsw_pr_hw_port_link_mode_set(const struct mvsw_pr_port *port,
> +				  u32 mode)
> +{
> +	struct mvsw_msg_port_attr_cmd req = {
> +		.attr = MVSW_MSG_PORT_ATTR_LINK_MODE,
> +		.port = port->hw_id,
> +		.dev = port->dev_id,
> +		.param = {.link_mode = mode}
> +	};
> +
> +	return fw_send_req(port->sw, MVSW_MSG_TYPE_PORT_ATTR_SET, &req);
> +}
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
> new file mode 100644
> index 000000000000..dfae2631160e
> --- /dev/null
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
> @@ -0,0 +1,159 @@
> +/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
> + *
> + * Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved.
> + *
> + */
> +
> +#ifndef _MVSW_PRESTERA_HW_H_
> +#define _MVSW_PRESTERA_HW_H_
> +
> +#include <linux/types.h>
> +
> +enum mvsw_pr_accept_frame_type {
> +	MVSW_ACCEPT_FRAME_TYPE_TAGGED,
> +	MVSW_ACCEPT_FRAME_TYPE_UNTAGGED,
> +	MVSW_ACCEPT_FRAME_TYPE_ALL
> +};
> +
> +enum {
> +	MVSW_LINK_MODE_10baseT_Half_BIT,
> +	MVSW_LINK_MODE_10baseT_Full_BIT,
> +	MVSW_LINK_MODE_100baseT_Half_BIT,
> +	MVSW_LINK_MODE_100baseT_Full_BIT,
> +	MVSW_LINK_MODE_1000baseT_Half_BIT,
> +	MVSW_LINK_MODE_1000baseT_Full_BIT,
> +	MVSW_LINK_MODE_1000baseX_Full_BIT,
> +	MVSW_LINK_MODE_1000baseKX_Full_BIT,
> +	MVSW_LINK_MODE_10GbaseKR_Full_BIT,
> +	MVSW_LINK_MODE_10GbaseSR_Full_BIT,
> +	MVSW_LINK_MODE_10GbaseLR_Full_BIT,
> +	MVSW_LINK_MODE_20GbaseKR2_Full_BIT,
> +	MVSW_LINK_MODE_25GbaseCR_Full_BIT,
> +	MVSW_LINK_MODE_25GbaseKR_Full_BIT,
> +	MVSW_LINK_MODE_25GbaseSR_Full_BIT,
> +	MVSW_LINK_MODE_40GbaseKR4_Full_BIT,
> +	MVSW_LINK_MODE_40GbaseCR4_Full_BIT,
> +	MVSW_LINK_MODE_40GbaseSR4_Full_BIT,
> +	MVSW_LINK_MODE_50GbaseCR2_Full_BIT,
> +	MVSW_LINK_MODE_50GbaseKR2_Full_BIT,
> +	MVSW_LINK_MODE_50GbaseSR2_Full_BIT,
> +	MVSW_LINK_MODE_100GbaseKR4_Full_BIT,
> +	MVSW_LINK_MODE_100GbaseSR4_Full_BIT,
> +	MVSW_LINK_MODE_100GbaseCR4_Full_BIT,
> +	MVSW_LINK_MODE_MAX,
> +};
> +
> +enum {
> +	MVSW_PORT_TYPE_NONE,
> +	MVSW_PORT_TYPE_TP,
> +	MVSW_PORT_TYPE_AUI,
> +	MVSW_PORT_TYPE_MII,
> +	MVSW_PORT_TYPE_FIBRE,
> +	MVSW_PORT_TYPE_BNC,
> +	MVSW_PORT_TYPE_DA,
> +	MVSW_PORT_TYPE_OTHER,
> +	MVSW_PORT_TYPE_MAX,
> +};
> +
> +enum {
> +	MVSW_PORT_TRANSCEIVER_COPPER,
> +	MVSW_PORT_TRANSCEIVER_SFP,
> +	MVSW_PORT_TRANSCEIVER_MAX,
> +};
> +
> +enum {
> +	MVSW_PORT_FEC_OFF_BIT,
> +	MVSW_PORT_FEC_BASER_BIT,
> +	MVSW_PORT_FEC_RS_BIT,
> +	MVSW_PORT_FEC_MAX,
> +};
> +
> +enum {
> +	MVSW_PORT_DUPLEX_HALF,
> +	MVSW_PORT_DUPLEX_FULL
> +};
> +
> +struct mvsw_pr_switch;
> +struct mvsw_pr_port;
> +struct mvsw_pr_port_stats;
> +struct mvsw_pr_port_caps;
> +
> +enum mvsw_pr_event_type;
> +struct mvsw_pr_event;
> +
> +/* Switch API */
> +int mvsw_pr_hw_switch_init(struct mvsw_pr_switch *sw);
> +int mvsw_pr_hw_switch_ageing_set(const struct mvsw_pr_switch *sw,
> +				 u32 ageing_time);
> +
> +/* Port API */
> +int mvsw_pr_hw_port_info_get(const struct mvsw_pr_port *port,
> +			     u16 *fp_id, u32 *hw_id, u32 *dev_id);
> +int mvsw_pr_hw_port_state_set(const struct mvsw_pr_port *port,
> +			      bool admin_state);
> +int mvsw_pr_hw_port_state_get(const struct mvsw_pr_port *port,
> +			      bool *admin_state, bool *oper_state);
> +int mvsw_pr_hw_port_mtu_set(const struct mvsw_pr_port *port, u32 mtu);
> +int mvsw_pr_hw_port_mtu_get(const struct mvsw_pr_port *port, u32 *mtu);
> +int mvsw_pr_hw_port_mac_set(const struct mvsw_pr_port *port, char *mac);
> +int mvsw_pr_hw_port_mac_get(const struct mvsw_pr_port *port, char *mac);
> +int mvsw_pr_hw_port_accept_frame_type_set(const struct mvsw_pr_port *port,
> +					  enum mvsw_pr_accept_frame_type type);
> +int mvsw_pr_hw_port_learning_set(const struct mvsw_pr_port *port, bool enable);
> +int mvsw_pr_hw_port_speed_get(const struct mvsw_pr_port *port, u32 *speed);
> +int mvsw_pr_hw_port_flood_set(const struct mvsw_pr_port *port, bool flood);
> +int mvsw_pr_hw_port_cap_get(const struct mvsw_pr_port *port,
> +			    struct mvsw_pr_port_caps *caps);
> +int mvsw_pr_hw_port_remote_cap_get(const struct mvsw_pr_port *port,
> +				   u64 *link_mode_bitmap);
> +int mvsw_pr_hw_port_type_get(const struct mvsw_pr_port *port, u8 *type);
> +int mvsw_pr_hw_port_fec_get(const struct mvsw_pr_port *port, u8 *fec);
> +int mvsw_pr_hw_port_fec_set(const struct mvsw_pr_port *port, u8 fec);
> +int mvsw_pr_hw_port_autoneg_set(const struct mvsw_pr_port *port,
> +				bool autoneg, u64 link_modes, u8 fec);
> +int mvsw_pr_hw_port_duplex_get(const struct mvsw_pr_port *port, u8 *duplex);
> +int mvsw_pr_hw_port_stats_get(const struct mvsw_pr_port *port,
> +			      struct mvsw_pr_port_stats *stats);
> +int mvsw_pr_hw_port_link_mode_get(const struct mvsw_pr_port *port,
> +				  u32 *mode);
> +int mvsw_pr_hw_port_link_mode_set(const struct mvsw_pr_port *port,
> +				  u32 mode);
> +int mvsw_pr_hw_port_mdix_get(const struct mvsw_pr_port *port, u8 *mode);
> +int mvsw_pr_hw_port_mdix_set(const struct mvsw_pr_port *port, u8 mode);
> +
> +/* Vlan API */
> +int mvsw_pr_hw_vlan_create(const struct mvsw_pr_switch *sw, u16 vid);
> +int mvsw_pr_hw_vlan_delete(const struct mvsw_pr_switch *sw, u16 vid);
> +int mvsw_pr_hw_vlan_port_set(const struct mvsw_pr_port *port,
> +			     u16 vid, bool is_member, bool untagged);
> +int mvsw_pr_hw_vlan_port_vid_set(const struct mvsw_pr_port *port, u16 vid);
> +
> +/* FDB API */
> +int mvsw_pr_hw_fdb_add(const struct mvsw_pr_port *port,
> +		       const unsigned char *mac, u16 vid, bool dynamic);
> +int mvsw_pr_hw_fdb_del(const struct mvsw_pr_port *port,
> +		       const unsigned char *mac, u16 vid);
> +int mvsw_pr_hw_fdb_flush_port(const struct mvsw_pr_port *port, u32 mode);
> +int mvsw_pr_hw_fdb_flush_vlan(const struct mvsw_pr_switch *sw, u16 vid,
> +			      u32 mode);
> +int mvsw_pr_hw_fdb_flush_port_vlan(const struct mvsw_pr_port *port, u16 vid,
> +				   u32 mode);
> +
> +/* Bridge API */
> +int mvsw_pr_hw_bridge_create(const struct mvsw_pr_switch *sw, u16 *bridge_id);
> +int mvsw_pr_hw_bridge_delete(const struct mvsw_pr_switch *sw, u16 bridge_id);
> +int mvsw_pr_hw_bridge_port_add(const struct mvsw_pr_port *port, u16 bridge_id);
> +int mvsw_pr_hw_bridge_port_delete(const struct mvsw_pr_port *port,
> +				  u16 bridge_id);
> +
> +/* Event handlers */
> +int mvsw_pr_hw_event_handler_register(struct mvsw_pr_switch *sw,
> +				      enum mvsw_pr_event_type type,
> +				      void (*cb)(struct mvsw_pr_switch *sw,
> +						 struct mvsw_pr_event *evt));
> +void mvsw_pr_hw_event_handler_unregister(struct mvsw_pr_switch *sw,
> +					 enum mvsw_pr_event_type type,
> +					 void (*cb)(struct mvsw_pr_switch *sw,
> +						    struct mvsw_pr_event *evt));
> +
> +#endif /* _MVSW_PRESTERA_HW_H_ */
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
> new file mode 100644
> index 000000000000..18fa6bbe5ace
> --- /dev/null
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
> @@ -0,0 +1,1217 @@
> +/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
> + *
> + * Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved.
> + *
> + */
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/if_vlan.h>
> +#include <linux/if_bridge.h>
> +#include <linux/notifier.h>
> +#include <net/switchdev.h>
> +#include <net/netevent.h>
> +#include <net/vxlan.h>

Doesn't seem like you have VXLAN support at the moment, so this is not
needed.

> +
> +#include "prestera.h"
> +
> +struct mvsw_pr_bridge {
> +	struct mvsw_pr_switch *sw;
> +	u32 ageing_time;
> +	struct list_head bridge_list;
> +	bool bridge_8021q_exists;
> +};
> +
> +struct mvsw_pr_bridge_device {
> +	struct net_device *dev;
> +	struct list_head bridge_node;
> +	struct list_head port_list;
> +	u16 bridge_id;
> +	u8 vlan_enabled:1, multicast_enabled:1, mrouter:1;
> +};
> +
> +struct mvsw_pr_bridge_port {
> +	struct net_device *dev;
> +	struct mvsw_pr_bridge_device *bridge_device;
> +	struct list_head bridge_device_node;
> +	struct list_head vlan_list;
> +	unsigned int ref_count;
> +	u8 stp_state;
> +	unsigned long flags;
> +};
> +
> +struct mvsw_pr_bridge_vlan {
> +	struct list_head bridge_port_node;
> +	struct list_head port_vlan_list;
> +	u16 vid;
> +};
> +
> +struct mvsw_pr_event_work {
> +	struct work_struct work;
> +	struct switchdev_notifier_fdb_info fdb_info;
> +	struct net_device *dev;
> +	unsigned long event;
> +};
> +
> +static struct workqueue_struct *mvsw_owq;
> +
> +static struct mvsw_pr_bridge_port *
> +mvsw_pr_bridge_port_get(struct mvsw_pr_bridge *bridge,
> +			struct net_device *brport_dev);
> +
> +static void mvsw_pr_bridge_port_put(struct mvsw_pr_bridge *bridge,
> +				    struct mvsw_pr_bridge_port *br_port);
> +
> +static struct mvsw_pr_bridge_device *
> +mvsw_pr_bridge_device_find(const struct mvsw_pr_bridge *bridge,
> +			   const struct net_device *br_dev)
> +{
> +	struct mvsw_pr_bridge_device *bridge_device;
> +
> +	list_for_each_entry(bridge_device, &bridge->bridge_list,
> +			    bridge_node)
> +		if (bridge_device->dev == br_dev)
> +			return bridge_device;
> +
> +	return NULL;
> +}
> +
> +static bool
> +mvsw_pr_bridge_device_is_offloaded(const struct mvsw_pr_switch *sw,
> +				   const struct net_device *br_dev)
> +{
> +	return !!mvsw_pr_bridge_device_find(sw->bridge, br_dev);
> +}
> +
> +static struct mvsw_pr_bridge_port *
> +__mvsw_pr_bridge_port_find(const struct mvsw_pr_bridge_device *bridge_device,
> +			   const struct net_device *brport_dev)
> +{
> +	struct mvsw_pr_bridge_port *br_port;
> +
> +	list_for_each_entry(br_port, &bridge_device->port_list,
> +			    bridge_device_node) {
> +		if (br_port->dev == brport_dev)
> +			return br_port;
> +	}
> +
> +	return NULL;
> +}
> +
> +static struct mvsw_pr_bridge_port *
> +mvsw_pr_bridge_port_find(struct mvsw_pr_bridge *bridge,
> +			 struct net_device *brport_dev)
> +{
> +	struct net_device *br_dev = netdev_master_upper_dev_get(brport_dev);
> +	struct mvsw_pr_bridge_device *bridge_device;
> +
> +	if (!br_dev)
> +		return NULL;
> +
> +	bridge_device = mvsw_pr_bridge_device_find(bridge, br_dev);
> +	if (!bridge_device)
> +		return NULL;
> +
> +	return __mvsw_pr_bridge_port_find(bridge_device, brport_dev);
> +}
> +
> +static struct mvsw_pr_bridge_vlan *
> +mvsw_pr_bridge_vlan_find(const struct mvsw_pr_bridge_port *br_port, u16 vid)
> +{
> +	struct mvsw_pr_bridge_vlan *br_vlan;
> +
> +	list_for_each_entry(br_vlan, &br_port->vlan_list, bridge_port_node) {
> +		if (br_vlan->vid == vid)
> +			return br_vlan;
> +	}
> +
> +	return NULL;
> +}
> +
> +static struct mvsw_pr_bridge_vlan *
> +mvsw_pr_bridge_vlan_create(struct mvsw_pr_bridge_port *br_port, u16 vid)
> +{
> +	struct mvsw_pr_bridge_vlan *br_vlan;
> +
> +	br_vlan = kzalloc(sizeof(*br_vlan), GFP_KERNEL);
> +	if (!br_vlan)
> +		return NULL;
> +
> +	INIT_LIST_HEAD(&br_vlan->port_vlan_list);
> +	br_vlan->vid = vid;
> +	list_add(&br_vlan->bridge_port_node, &br_port->vlan_list);
> +
> +	return br_vlan;
> +}
> +
> +static void
> +mvsw_pr_bridge_vlan_destroy(struct mvsw_pr_bridge_vlan *br_vlan)
> +{
> +	list_del(&br_vlan->bridge_port_node);
> +	WARN_ON(!list_empty(&br_vlan->port_vlan_list));
> +	kfree(br_vlan);
> +}
> +
> +static struct mvsw_pr_bridge_vlan *
> +mvsw_pr_bridge_vlan_get(struct mvsw_pr_bridge_port *br_port, u16 vid)
> +{
> +	struct mvsw_pr_bridge_vlan *br_vlan;
> +
> +	br_vlan = mvsw_pr_bridge_vlan_find(br_port, vid);
> +	if (br_vlan)
> +		return br_vlan;
> +
> +	return mvsw_pr_bridge_vlan_create(br_port, vid);
> +}
> +
> +static void mvsw_pr_bridge_vlan_put(struct mvsw_pr_bridge_vlan *br_vlan)
> +{
> +	if (list_empty(&br_vlan->port_vlan_list))
> +		mvsw_pr_bridge_vlan_destroy(br_vlan);
> +}
> +
> +static int
> +mvsw_pr_port_vlan_bridge_join(struct mvsw_pr_port_vlan *port_vlan,
> +			      struct mvsw_pr_bridge_port *br_port,
> +			      struct netlink_ext_ack *extack)
> +{
> +	struct mvsw_pr_port *port = port_vlan->mvsw_pr_port;
> +	struct mvsw_pr_bridge_vlan *br_vlan;
> +	u16 vid = port_vlan->vid;
> +	int err;
> +
> +	if (port_vlan->bridge_port)
> +		return 0;
> +
> +	err = mvsw_pr_port_flood_set(port, br_port->flags & BR_FLOOD);
> +	if (err)
> +		return err;
> +
> +	err = mvsw_pr_port_learning_set(port, br_port->flags & BR_LEARNING);
> +	if (err)
> +		goto err_port_learning_set;

It seems that learning and flooding are not per-{port, VLAN} attributes,
so I'm not sure why you have this here.

The fact that you don't undo this in mvsw_pr_port_vlan_bridge_leave()
tells me it should not be here.

> +
> +	br_vlan = mvsw_pr_bridge_vlan_get(br_port, vid);
> +	if (!br_vlan) {
> +		err = -ENOMEM;
> +		goto err_bridge_vlan_get;
> +	}
> +
> +	list_add(&port_vlan->bridge_vlan_node, &br_vlan->port_vlan_list);
> +
> +	mvsw_pr_bridge_port_get(port->sw->bridge, br_port->dev);
> +	port_vlan->bridge_port = br_port;
> +
> +	return 0;
> +
> +err_bridge_vlan_get:
> +	mvsw_pr_port_learning_set(port, false);
> +err_port_learning_set:
> +	return err;
> +}
> +
> +static int
> +mvsw_pr_bridge_vlan_port_count_get(struct mvsw_pr_bridge_device *bridge_device,
> +				   u16 vid)
> +{
> +	int count = 0;
> +	struct mvsw_pr_bridge_port *br_port;
> +	struct mvsw_pr_bridge_vlan *br_vlan;
> +
> +	list_for_each_entry(br_port, &bridge_device->port_list,
> +			    bridge_device_node) {
> +		list_for_each_entry(br_vlan, &br_port->vlan_list,
> +				    bridge_port_node) {
> +			if (br_vlan->vid == vid) {
> +				count += 1;
> +				break;
> +			}
> +		}
> +	}
> +
> +	return count;
> +}
> +
> +void
> +mvsw_pr_port_vlan_bridge_leave(struct mvsw_pr_port_vlan *port_vlan)
> +{
> +	struct mvsw_pr_port *port = port_vlan->mvsw_pr_port;
> +	struct mvsw_pr_bridge_vlan *br_vlan;
> +	struct mvsw_pr_bridge_port *br_port;
> +	int port_count;
> +	u16 vid = port_vlan->vid;
> +	bool last_port, last_vlan;
> +
> +	br_port = port_vlan->bridge_port;
> +	last_vlan = list_is_singular(&br_port->vlan_list);
> +	port_count =
> +	    mvsw_pr_bridge_vlan_port_count_get(br_port->bridge_device, vid);
> +	br_vlan = mvsw_pr_bridge_vlan_find(br_port, vid);
> +	last_port = port_count == 1;
> +	if (last_vlan) {
> +		mvsw_pr_fdb_flush_port(port, MVSW_PR_FDB_FLUSH_MODE_DYNAMIC);
> +	} else if (last_port) {
> +		mvsw_pr_fdb_flush_vlan(port->sw, vid,
> +				       MVSW_PR_FDB_FLUSH_MODE_DYNAMIC);
> +	} else {
> +		mvsw_pr_fdb_flush_port_vlan(port, vid,
> +					    MVSW_PR_FDB_FLUSH_MODE_DYNAMIC);

If you always flush based on {port, VID}, then why do you need the other
two?

> +	}
> +
> +	list_del(&port_vlan->bridge_vlan_node);
> +	mvsw_pr_bridge_vlan_put(br_vlan);
> +	mvsw_pr_bridge_port_put(port->sw->bridge, br_port);
> +	port_vlan->bridge_port = NULL;
> +}
> +
> +static int
> +mvsw_pr_bridge_port_vlan_add(struct mvsw_pr_port *port,
> +			     struct mvsw_pr_bridge_port *br_port,
> +			     u16 vid, bool is_untagged, bool is_pvid,
> +			     struct netlink_ext_ack *extack)
> +{
> +	u16 pvid;
> +	struct mvsw_pr_port_vlan *port_vlan;
> +	u16 old_pvid = port->pvid;
> +	int err;
> +
> +	if (is_pvid)
> +		pvid = vid;
> +	else
> +		pvid = port->pvid == vid ? 0 : port->pvid;
> +
> +	port_vlan = mvsw_pr_port_vlan_find_by_vid(port, vid);
> +	if (port_vlan && port_vlan->bridge_port != br_port)
> +		return -EEXIST;
> +
> +	if (!port_vlan) {
> +		port_vlan = mvsw_pr_port_vlan_create(port, vid);
> +		if (IS_ERR(port_vlan))
> +			return PTR_ERR(port_vlan);
> +	}
> +
> +	err = mvsw_pr_port_vlan_set(port, vid, true, is_untagged);
> +	if (err)
> +		goto err_port_vlan_set;
> +
> +	err = mvsw_pr_port_pvid_set(port, pvid);
> +	if (err)
> +		goto err_port_pvid_set;
> +
> +	err = mvsw_pr_port_vlan_bridge_join(port_vlan, br_port, extack);
> +	if (err)
> +		goto err_port_vlan_bridge_join;
> +
> +	return 0;
> +
> +err_port_vlan_bridge_join:
> +	mvsw_pr_port_pvid_set(port, old_pvid);
> +err_port_pvid_set:
> +	mvsw_pr_port_vlan_set(port, vid, false, false);
> +err_port_vlan_set:
> +	mvsw_pr_port_vlan_destroy(port_vlan);
> +
> +	return err;
> +}
> +
> +static int mvsw_pr_port_vlans_add(struct mvsw_pr_port *port,
> +				  const struct switchdev_obj_port_vlan *vlan,
> +				  struct switchdev_trans *trans,
> +				  struct netlink_ext_ack *extack)
> +{
> +	bool flag_untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
> +	bool flag_pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
> +	struct net_device *orig_dev = vlan->obj.orig_dev;
> +	struct mvsw_pr_bridge_port *br_port;
> +	struct mvsw_pr_switch *sw = port->sw;
> +	u16 vid;
> +
> +	if (netif_is_bridge_master(orig_dev))
> +		return 0;
> +
> +	if (switchdev_trans_ph_commit(trans))
> +		return 0;
> +
> +	br_port = mvsw_pr_bridge_port_find(sw->bridge, orig_dev);
> +	if (WARN_ON(!br_port))
> +		return -EINVAL;
> +
> +	if (!br_port->bridge_device->vlan_enabled)
> +		return 0;
> +
> +	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
> +		int err;
> +
> +		err = mvsw_pr_bridge_port_vlan_add(port, br_port,
> +						   vid, flag_untagged,
> +						   flag_pvid, extack);
> +		if (err)
> +			return err;
> +	}
> +
> +	return 0;
> +}
> +
> +static int mvsw_pr_port_obj_add(struct net_device *dev,
> +				const struct switchdev_obj *obj,
> +				struct switchdev_trans *trans,
> +				struct netlink_ext_ack *extack)
> +{
> +	int err = 0;
> +	struct mvsw_pr_port *port = netdev_priv(dev);
> +	const struct switchdev_obj_port_vlan *vlan;
> +
> +	switch (obj->id) {
> +	case SWITCHDEV_OBJ_ID_PORT_VLAN:
> +		vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
> +		err = mvsw_pr_port_vlans_add(port, vlan, trans, extack);
> +		break;
> +	default:
> +		err = -EOPNOTSUPP;
> +	}
> +
> +	return err;
> +}
> +
> +static void
> +mvsw_pr_bridge_port_vlan_del(struct mvsw_pr_port *port,
> +			     struct mvsw_pr_bridge_port *br_port, u16 vid)
> +{
> +	u16 pvid = port->pvid == vid ? 0 : port->pvid;
> +	struct mvsw_pr_port_vlan *port_vlan;
> +
> +	port_vlan = mvsw_pr_port_vlan_find_by_vid(port, vid);
> +	if (WARN_ON(!port_vlan))
> +		return;
> +
> +	mvsw_pr_port_vlan_bridge_leave(port_vlan);
> +	mvsw_pr_port_pvid_set(port, pvid);
> +	mvsw_pr_port_vlan_destroy(port_vlan);
> +}
> +
> +static int mvsw_pr_port_vlans_del(struct mvsw_pr_port *port,
> +				  const struct switchdev_obj_port_vlan *vlan)
> +{
> +	struct mvsw_pr_switch *sw = port->sw;
> +	struct net_device *orig_dev = vlan->obj.orig_dev;
> +	struct mvsw_pr_bridge_port *br_port;
> +	u16 vid;
> +
> +	if (netif_is_bridge_master(orig_dev))
> +		return -EOPNOTSUPP;
> +
> +	br_port = mvsw_pr_bridge_port_find(sw->bridge, orig_dev);
> +	if (WARN_ON(!br_port))
> +		return -EINVAL;
> +
> +	if (!br_port->bridge_device->vlan_enabled)
> +		return 0;
> +
> +	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++)
> +		mvsw_pr_bridge_port_vlan_del(port, br_port, vid);
> +
> +	return 0;
> +}
> +
> +static int mvsw_pr_port_obj_del(struct net_device *dev,
> +				const struct switchdev_obj *obj)
> +{
> +	int err = 0;
> +	struct mvsw_pr_port *port = netdev_priv(dev);
> +
> +	switch (obj->id) {
> +	case SWITCHDEV_OBJ_ID_PORT_VLAN:
> +		err = mvsw_pr_port_vlans_del(port,
> +					     SWITCHDEV_OBJ_PORT_VLAN(obj));
> +		break;
> +	default:
> +		err = -EOPNOTSUPP;
> +		break;
> +	}
> +
> +	return err;
> +}
> +
> +static int mvsw_pr_port_attr_br_vlan_set(struct mvsw_pr_port *port,
> +					 struct switchdev_trans *trans,
> +					 struct net_device *orig_dev,
> +					 bool vlan_enabled)
> +{
> +	struct mvsw_pr_switch *sw = port->sw;
> +	struct mvsw_pr_bridge_device *bridge_device;
> +
> +	if (!switchdev_trans_ph_prepare(trans))
> +		return 0;
> +
> +	bridge_device = mvsw_pr_bridge_device_find(sw->bridge, orig_dev);
> +	if (WARN_ON(!bridge_device))
> +		return -EINVAL;
> +
> +	if (bridge_device->vlan_enabled == vlan_enabled)
> +		return 0;
> +
> +	netdev_err(bridge_device->dev,
> +		   "VLAN filtering can't be changed for existing bridge\n");
> +	return -EINVAL;
> +}
> +
> +static int mvsw_pr_port_attr_br_flags_set(struct mvsw_pr_port *port,
> +					  struct switchdev_trans *trans,
> +					  struct net_device *orig_dev,
> +					  unsigned long flags)
> +{
> +	struct mvsw_pr_bridge_port *br_port;
> +	int err;
> +
> +	if (switchdev_trans_ph_prepare(trans))
> +		return 0;
> +
> +	br_port = mvsw_pr_bridge_port_find(port->sw->bridge, orig_dev);
> +	if (!br_port)
> +		return 0;
> +
> +	err = mvsw_pr_port_flood_set(port, flags & BR_FLOOD);
> +	if (err)
> +		return err;
> +
> +	err = mvsw_pr_port_learning_set(port, flags & BR_LEARNING);
> +	if (err)
> +		return err;
> +
> +	memcpy(&br_port->flags, &flags, sizeof(flags));
> +	return 0;
> +}
> +
> +static int mvsw_pr_port_attr_br_ageing_set(struct mvsw_pr_port *port,
> +					   struct switchdev_trans *trans,
> +					   unsigned long ageing_clock_t)
> +{
> +	int err;
> +	struct mvsw_pr_switch *sw = port->sw;
> +	unsigned long ageing_jiffies = clock_t_to_jiffies(ageing_clock_t);
> +	u32 ageing_time = jiffies_to_msecs(ageing_jiffies) / 1000;
> +
> +	if (switchdev_trans_ph_prepare(trans)) {
> +		if (ageing_time < MVSW_PR_MIN_AGEING_TIME ||
> +		    ageing_time > MVSW_PR_MAX_AGEING_TIME)
> +			return -ERANGE;
> +		else
> +			return 0;
> +	}
> +
> +	err = mvsw_pr_switch_ageing_set(sw, ageing_time);
> +	if (!err)
> +		sw->bridge->ageing_time = ageing_time;
> +
> +	return err;
> +}
> +
> +static int mvsw_pr_port_obj_attr_set(struct net_device *dev,
> +				     const struct switchdev_attr *attr,
> +				     struct switchdev_trans *trans)
> +{
> +	int err = 0;
> +	struct mvsw_pr_port *port = netdev_priv(dev);
> +
> +	switch (attr->id) {
> +	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
> +		err = -EOPNOTSUPP;

You don't support STP?

> +		break;
> +	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
> +		if (attr->u.brport_flags &
> +		    ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD))
> +			err = -EINVAL;
> +		break;
> +	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
> +		err = mvsw_pr_port_attr_br_flags_set(port, trans,
> +						     attr->orig_dev,
> +						     attr->u.brport_flags);
> +		break;
> +	case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
> +		err = mvsw_pr_port_attr_br_ageing_set(port, trans,
> +						      attr->u.ageing_time);
> +		break;
> +	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
> +		err = mvsw_pr_port_attr_br_vlan_set(port, trans,
> +						    attr->orig_dev,
> +						    attr->u.vlan_filtering);
> +		break;
> +	default:
> +		err = -EOPNOTSUPP;
> +	}
> +
> +	return err;
> +}
> +
> +static void mvsw_fdb_offload_notify(struct mvsw_pr_port *port,
> +				    struct switchdev_notifier_fdb_info *info)
> +{
> +	struct switchdev_notifier_fdb_info send_info;
> +
> +	send_info.addr = info->addr;
> +	send_info.vid = info->vid;
> +	send_info.offloaded = true;
> +	call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED,
> +				 port->net_dev, &send_info.info, NULL);
> +}
> +
> +static int
> +mvsw_pr_port_fdb_set(struct mvsw_pr_port *port,
> +		     struct switchdev_notifier_fdb_info *fdb_info, bool adding)
> +{
> +	struct mvsw_pr_switch *sw = port->sw;
> +	struct mvsw_pr_bridge_port *br_port;
> +	struct mvsw_pr_bridge_device *bridge_device;
> +	struct net_device *orig_dev = fdb_info->info.dev;
> +	int err;
> +	u16 vid;
> +
> +	br_port = mvsw_pr_bridge_port_find(sw->bridge, orig_dev);
> +	if (!br_port)
> +		return -EINVAL;
> +
> +	bridge_device = br_port->bridge_device;
> +
> +	if (bridge_device->vlan_enabled)
> +		vid = fdb_info->vid;
> +	else
> +		vid = bridge_device->bridge_id;
> +
> +	if (adding)
> +		err = mvsw_pr_fdb_add(port, fdb_info->addr, vid, false);
> +	else
> +		err = mvsw_pr_fdb_del(port, fdb_info->addr, vid);
> +
> +	return err;
> +}
> +
> +static void mvsw_pr_bridge_fdb_event_work(struct work_struct *work)
> +{
> +	int err = 0;
> +	struct mvsw_pr_event_work *switchdev_work =
> +	    container_of(work, struct mvsw_pr_event_work, work);
> +	struct net_device *dev = switchdev_work->dev;
> +	struct switchdev_notifier_fdb_info *fdb_info;
> +	struct mvsw_pr_port *port;
> +
> +	rtnl_lock();
> +	if (netif_is_vxlan(dev))
> +		goto out;
> +
> +	port = mvsw_pr_port_dev_lower_find(dev);
> +	if (!port)
> +		goto out;
> +
> +	switch (switchdev_work->event) {
> +	case SWITCHDEV_FDB_ADD_TO_DEVICE:
> +		fdb_info = &switchdev_work->fdb_info;
> +		if (!fdb_info->added_by_user)
> +			break;
> +		err = mvsw_pr_port_fdb_set(port, fdb_info, true);
> +		if (err)
> +			break;
> +		mvsw_fdb_offload_notify(port, fdb_info);
> +		break;
> +	case SWITCHDEV_FDB_DEL_TO_DEVICE:
> +		fdb_info = &switchdev_work->fdb_info;
> +		mvsw_pr_port_fdb_set(port, fdb_info, false);
> +		break;
> +	case SWITCHDEV_FDB_ADD_TO_BRIDGE:
> +	case SWITCHDEV_FDB_DEL_TO_BRIDGE:
> +		break;
> +	}
> +
> +out:
> +	rtnl_unlock();
> +	kfree(switchdev_work->fdb_info.addr);
> +	kfree(switchdev_work);
> +	dev_put(dev);
> +}
> +
> +static int mvsw_pr_switchdev_event(struct notifier_block *unused,
> +				   unsigned long event, void *ptr)
> +{
> +	int err = 0;
> +	struct net_device *net_dev = switchdev_notifier_info_to_dev(ptr);
> +	struct mvsw_pr_event_work *switchdev_work;
> +	struct switchdev_notifier_fdb_info *fdb_info;
> +	struct switchdev_notifier_info *info = ptr;
> +	struct net_device *upper_br;
> +
> +	if (event == SWITCHDEV_PORT_ATTR_SET) {
> +		err = switchdev_handle_port_attr_set(net_dev, ptr,
> +						     mvsw_pr_netdev_check,
> +						     mvsw_pr_port_obj_attr_set);
> +		return notifier_from_errno(err);
> +	}
> +
> +	upper_br = netdev_master_upper_dev_get_rcu(net_dev);
> +	if (!upper_br)
> +		return NOTIFY_DONE;
> +
> +	if (!netif_is_bridge_master(upper_br))
> +		return NOTIFY_DONE;

Looks too complicated for the use cases you support. Just check that the
netdev is a prestera netdev.

> +
> +	switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
> +	if (!switchdev_work)
> +		return NOTIFY_BAD;
> +
> +	switchdev_work->dev = net_dev;
> +	switchdev_work->event = event;
> +
> +	switch (event) {
> +	case SWITCHDEV_FDB_ADD_TO_DEVICE:
> +	case SWITCHDEV_FDB_DEL_TO_DEVICE:
> +	case SWITCHDEV_FDB_ADD_TO_BRIDGE:
> +	case SWITCHDEV_FDB_DEL_TO_BRIDGE:
> +		fdb_info = container_of(info,
> +					struct switchdev_notifier_fdb_info,
> +					info);
> +
> +		INIT_WORK(&switchdev_work->work, mvsw_pr_bridge_fdb_event_work);
> +		memcpy(&switchdev_work->fdb_info, ptr,
> +		       sizeof(switchdev_work->fdb_info));
> +		switchdev_work->fdb_info.addr = kzalloc(ETH_ALEN, GFP_ATOMIC);
> +		if (!switchdev_work->fdb_info.addr)
> +			goto out;
> +		ether_addr_copy((u8 *)switchdev_work->fdb_info.addr,
> +				fdb_info->addr);
> +		dev_hold(net_dev);
> +
> +		break;
> +	case SWITCHDEV_VXLAN_FDB_ADD_TO_DEVICE:
> +	case SWITCHDEV_VXLAN_FDB_DEL_TO_DEVICE:

You can remove these, that's why you have 'default'...

> +	default:
> +		kfree(switchdev_work);
> +		return NOTIFY_DONE;
> +	}
> +
> +	queue_work(mvsw_owq, &switchdev_work->work);

Once you defer the operation you cannot return an error, which is
problematic. Do you have a way to know if the operation will succeed or
not? That is, if the hardware has enough space for this new FDB entry?

> +	return NOTIFY_DONE;
> +out:
> +	kfree(switchdev_work);
> +	return NOTIFY_BAD;
> +}
> +
> +static int mvsw_pr_switchdev_blocking_event(struct notifier_block *unused,
> +					    unsigned long event, void *ptr)
> +{
> +	int err = 0;
> +	struct net_device *net_dev = switchdev_notifier_info_to_dev(ptr);
> +
> +	switch (event) {
> +	case SWITCHDEV_PORT_OBJ_ADD:
> +		if (netif_is_vxlan(net_dev)) {

You don't need this because you don't support VXLAN.
mvsw_pr_netdev_check() will return false for the VXLAN device and your
driver will not be called.

If you want to forbid enslavement of non-prestera to the bridge, then
you should do it in the netdev notifier. Then you can remove all these
netif_is_vxlan() checks.

> +			err = -EOPNOTSUPP;
> +		} else {
> +			err = switchdev_handle_port_obj_add
> +			    (net_dev, ptr, mvsw_pr_netdev_check,
> +			     mvsw_pr_port_obj_add);
> +		}
> +		break;
> +	case SWITCHDEV_PORT_OBJ_DEL:
> +		if (netif_is_vxlan(net_dev)) {
> +			err = -EOPNOTSUPP;
> +		} else {
> +			err = switchdev_handle_port_obj_del
> +			    (net_dev, ptr, mvsw_pr_netdev_check,
> +			     mvsw_pr_port_obj_del);
> +		}
> +		break;
> +	case SWITCHDEV_PORT_ATTR_SET:
> +		err = switchdev_handle_port_attr_set
> +		    (net_dev, ptr, mvsw_pr_netdev_check,
> +		    mvsw_pr_port_obj_attr_set);
> +		break;
> +	default:
> +		err = -EOPNOTSUPP;
> +	}
> +
> +	return notifier_from_errno(err);
> +}
> +
> +static struct mvsw_pr_bridge_device *
> +mvsw_pr_bridge_device_create(struct mvsw_pr_bridge *bridge,
> +			     struct net_device *br_dev)
> +{
> +	struct mvsw_pr_bridge_device *bridge_device;
> +	bool vlan_enabled = br_vlan_enabled(br_dev);
> +	u16 bridge_id;
> +	int err;
> +
> +	if (vlan_enabled && bridge->bridge_8021q_exists) {
> +		netdev_err(br_dev, "Only one VLAN-aware bridge is supported\n");

Propagate extack to this function and use it here instead of writing to
kernel log

> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	bridge_device = kzalloc(sizeof(*bridge_device), GFP_KERNEL);
> +	if (!bridge_device)
> +		return ERR_PTR(-ENOMEM);
> +
> +	if (vlan_enabled) {
> +		bridge->bridge_8021q_exists = true;
> +	} else {
> +		err = mvsw_pr_8021d_bridge_create(bridge->sw, &bridge_id);
> +		if (err) {
> +			kfree(bridge_device);
> +			return ERR_PTR(err);
> +		}
> +
> +		bridge_device->bridge_id = bridge_id;
> +	}
> +
> +	bridge_device->dev = br_dev;
> +	bridge_device->vlan_enabled = vlan_enabled;
> +	bridge_device->multicast_enabled = br_multicast_enabled(br_dev);
> +	bridge_device->mrouter = br_multicast_router(br_dev);
> +	INIT_LIST_HEAD(&bridge_device->port_list);
> +
> +	list_add(&bridge_device->bridge_node, &bridge->bridge_list);
> +
> +	return bridge_device;
> +}
> +
> +static void
> +mvsw_pr_bridge_device_destroy(struct mvsw_pr_bridge *bridge,
> +			      struct mvsw_pr_bridge_device *bridge_device)
> +{
> +	list_del(&bridge_device->bridge_node);
> +	if (bridge_device->vlan_enabled)
> +		bridge->bridge_8021q_exists = false;
> +	else
> +		mvsw_pr_8021d_bridge_delete(bridge->sw,
> +					    bridge_device->bridge_id);
> +
> +	WARN_ON(!list_empty(&bridge_device->port_list));
> +	kfree(bridge_device);
> +}
> +
> +static struct mvsw_pr_bridge_device *
> +mvsw_pr_bridge_device_get(struct mvsw_pr_bridge *bridge,
> +			  struct net_device *br_dev)
> +{
> +	struct mvsw_pr_bridge_device *bridge_device;
> +
> +	bridge_device = mvsw_pr_bridge_device_find(bridge, br_dev);
> +	if (bridge_device)
> +		return bridge_device;
> +
> +	return mvsw_pr_bridge_device_create(bridge, br_dev);
> +}
> +
> +static void
> +mvsw_pr_bridge_device_put(struct mvsw_pr_bridge *bridge,
> +			  struct mvsw_pr_bridge_device *bridge_device)
> +{
> +	if (list_empty(&bridge_device->port_list))
> +		mvsw_pr_bridge_device_destroy(bridge, bridge_device);
> +}
> +
> +static struct mvsw_pr_bridge_port *
> +mvsw_pr_bridge_port_create(struct mvsw_pr_bridge_device *bridge_device,
> +			   struct net_device *brport_dev)
> +{
> +	struct mvsw_pr_bridge_port *br_port;
> +	struct mvsw_pr_port *port;
> +
> +	br_port = kzalloc(sizeof(*br_port), GFP_KERNEL);
> +	if (!br_port)
> +		return NULL;
> +
> +	port = mvsw_pr_port_dev_lower_find(brport_dev);
> +
> +	br_port->dev = brport_dev;
> +	br_port->bridge_device = bridge_device;
> +	br_port->stp_state = BR_STATE_DISABLED;
> +	br_port->flags = BR_LEARNING | BR_FLOOD | BR_LEARNING_SYNC |
> +				BR_MCAST_FLOOD;
> +	INIT_LIST_HEAD(&br_port->vlan_list);
> +	list_add(&br_port->bridge_device_node, &bridge_device->port_list);
> +	br_port->ref_count = 1;
> +
> +	return br_port;
> +}
> +
> +static void
> +mvsw_pr_bridge_port_destroy(struct mvsw_pr_bridge_port *br_port)
> +{
> +	list_del(&br_port->bridge_device_node);
> +	WARN_ON(!list_empty(&br_port->vlan_list));
> +	kfree(br_port);
> +}
> +
> +static struct mvsw_pr_bridge_port *
> +mvsw_pr_bridge_port_get(struct mvsw_pr_bridge *bridge,
> +			struct net_device *brport_dev)
> +{
> +	struct net_device *br_dev = netdev_master_upper_dev_get(brport_dev);
> +	struct mvsw_pr_bridge_device *bridge_device;
> +	struct mvsw_pr_bridge_port *br_port;
> +	int err;
> +
> +	br_port = mvsw_pr_bridge_port_find(bridge, brport_dev);
> +	if (br_port) {
> +		br_port->ref_count++;
> +		return br_port;
> +	}
> +
> +	bridge_device = mvsw_pr_bridge_device_get(bridge, br_dev);
> +	if (IS_ERR(bridge_device))
> +		return ERR_CAST(bridge_device);
> +
> +	br_port = mvsw_pr_bridge_port_create(bridge_device, brport_dev);
> +	if (!br_port) {
> +		err = -ENOMEM;
> +		goto err_brport_create;
> +	}
> +
> +	return br_port;
> +
> +err_brport_create:
> +	mvsw_pr_bridge_device_put(bridge, bridge_device);
> +	return ERR_PTR(err);
> +}
> +
> +static void mvsw_pr_bridge_port_put(struct mvsw_pr_bridge *bridge,
> +				    struct mvsw_pr_bridge_port *br_port)
> +{
> +	struct mvsw_pr_bridge_device *bridge_device;
> +
> +	if (--br_port->ref_count != 0)
> +		return;
> +	bridge_device = br_port->bridge_device;
> +	mvsw_pr_bridge_port_destroy(br_port);
> +	mvsw_pr_bridge_device_put(bridge, bridge_device);
> +}
> +
> +static int
> +mvsw_pr_bridge_8021q_port_join(struct mvsw_pr_bridge_device *bridge_device,
> +			       struct mvsw_pr_bridge_port *br_port,
> +			       struct mvsw_pr_port *port,
> +			       struct netlink_ext_ack *extack)
> +{
> +	if (is_vlan_dev(br_port->dev)) {

How can this happen? In the netdev notifier you only allow bridge
uppers. Trying to configure a VLAN device on top of a prestera netdev
should error out with "Unknown upper device type".

> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "Can not enslave a VLAN device to a VLAN-aware bridge");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int
> +mvsw_pr_bridge_8021d_port_join(struct mvsw_pr_bridge_device *bridge_device,
> +			       struct mvsw_pr_bridge_port *br_port,
> +			       struct mvsw_pr_port *port,
> +			       struct netlink_ext_ack *extack)
> +{
> +	int err;
> +
> +	if (is_vlan_dev(br_port->dev)) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "Enslaving of a VLAN device is not supported");
> +		return -ENOTSUPP;
> +	}
> +	err = mvsw_pr_8021d_bridge_port_add(port, bridge_device->bridge_id);
> +	if (err)
> +		return err;
> +
> +	err = mvsw_pr_port_flood_set(port, br_port->flags & BR_FLOOD);
> +	if (err)
> +		goto err_port_flood_set;
> +
> +	err = mvsw_pr_port_learning_set(port, br_port->flags & BR_LEARNING);
> +	if (err)
> +		goto err_port_learning_set;
> +
> +	return err;
> +
> +err_port_learning_set:
> +	mvsw_pr_port_flood_set(port, false);
> +err_port_flood_set:
> +	mvsw_pr_8021d_bridge_port_delete(port, bridge_device->bridge_id);
> +	return err;
> +}
> +
> +static int mvsw_pr_port_bridge_join(struct mvsw_pr_port *port,
> +				    struct net_device *brport_dev,
> +				    struct net_device *br_dev,
> +				    struct netlink_ext_ack *extack)
> +{
> +	struct mvsw_pr_bridge_device *bridge_device;
> +	struct mvsw_pr_switch *sw = port->sw;
> +	struct mvsw_pr_bridge_port *br_port;
> +	int err;
> +
> +	br_port = mvsw_pr_bridge_port_get(sw->bridge, brport_dev);
> +	if (IS_ERR(br_port))
> +		return PTR_ERR(br_port);
> +
> +	bridge_device = br_port->bridge_device;
> +
> +	if (bridge_device->vlan_enabled) {
> +		err = mvsw_pr_bridge_8021q_port_join(bridge_device, br_port,
> +						     port, extack);
> +	} else {
> +		err = mvsw_pr_bridge_8021d_port_join(bridge_device, br_port,
> +						     port, extack);
> +	}
> +
> +	if (err)
> +		goto err_port_join;
> +
> +	return 0;
> +
> +err_port_join:
> +	mvsw_pr_bridge_port_put(sw->bridge, br_port);
> +	return err;
> +}
> +
> +static void
> +mvsw_pr_bridge_8021d_port_leave(struct mvsw_pr_bridge_device *bridge_device,
> +				struct mvsw_pr_bridge_port *br_port,
> +				struct mvsw_pr_port *port)
> +{
> +	mvsw_pr_fdb_flush_port(port, MVSW_PR_FDB_FLUSH_MODE_ALL);
> +	mvsw_pr_8021d_bridge_port_delete(port, bridge_device->bridge_id);
> +}
> +
> +static void
> +mvsw_pr_bridge_8021q_port_leave(struct mvsw_pr_bridge_device *bridge_device,
> +				struct mvsw_pr_bridge_port *br_port,
> +				struct mvsw_pr_port *port)
> +{
> +	mvsw_pr_fdb_flush_port(port, MVSW_PR_FDB_FLUSH_MODE_ALL);
> +	mvsw_pr_port_pvid_set(port, MVSW_PR_DEFAULT_VID);
> +}
> +

Please have mvsw_pr_port_bridge_join() and mvsw_pr_port_bridge_leave()
next to each other. Easier to see that rollback correctly.

> +static void mvsw_pr_port_bridge_leave(struct mvsw_pr_port *port,
> +				      struct net_device *brport_dev,
> +				      struct net_device *br_dev)
> +{
> +	struct mvsw_pr_switch *sw = port->sw;
> +	struct mvsw_pr_bridge_device *bridge_device;
> +	struct mvsw_pr_bridge_port *br_port;
> +
> +	bridge_device = mvsw_pr_bridge_device_find(sw->bridge, br_dev);
> +	if (!bridge_device)
> +		return;
> +	br_port = __mvsw_pr_bridge_port_find(bridge_device, brport_dev);
> +	if (!br_port)
> +		return;
> +
> +	if (bridge_device->vlan_enabled)
> +		mvsw_pr_bridge_8021q_port_leave(bridge_device, br_port, port);
> +	else
> +		mvsw_pr_bridge_8021d_port_leave(bridge_device, br_port, port);
> +
> +	mvsw_pr_port_learning_set(port, false);
> +	mvsw_pr_port_flood_set(port, false);
> +	mvsw_pr_bridge_port_put(sw->bridge, br_port);
> +}
> +
> +static int mvsw_pr_netdevice_port_upper_event(struct net_device *lower_dev,
> +					      struct net_device *dev,
> +					      unsigned long event, void *ptr)
> +{
> +	struct netdev_notifier_changeupper_info *info;
> +	struct mvsw_pr_port *port;
> +	struct netlink_ext_ack *extack;
> +	struct net_device *upper_dev;
> +	struct mvsw_pr_switch *sw;
> +	int err = 0;
> +
> +	port = netdev_priv(dev);
> +	sw = port->sw;
> +	info = ptr;
> +	extack = netdev_notifier_info_to_extack(&info->info);
> +
> +	switch (event) {
> +	case NETDEV_PRECHANGEUPPER:
> +		upper_dev = info->upper_dev;
> +		if (!netif_is_bridge_master(upper_dev)) {
> +			NL_SET_ERR_MSG_MOD(extack, "Unknown upper device type");
> +			return -EINVAL;
> +		}
> +		if (!info->linking)
> +			break;
> +		if (netdev_has_any_upper_dev(upper_dev) &&
> +		    (!netif_is_bridge_master(upper_dev) ||
> +		     !mvsw_pr_bridge_device_is_offloaded(sw, upper_dev))) {

You only need netdev_has_any_upper_dev().

> +			NL_SET_ERR_MSG_MOD(extack,
> +					   "Enslaving a port to a device that already has an upper device is not supported");

You can have both in the same line. Same in other places.

> +			return -EINVAL;
> +		}

Does not seem like you support multicast snooping at this stage, so you
need to check this here via br_multicast_enabled()

> +		break;
> +	case NETDEV_CHANGEUPPER:
> +		upper_dev = info->upper_dev;
> +		if (netif_is_bridge_master(upper_dev)) {
> +			if (info->linking)
> +				err = mvsw_pr_port_bridge_join(port,
> +							       lower_dev,
> +							       upper_dev,
> +							       extack);
> +			else
> +				mvsw_pr_port_bridge_leave(port,
> +							  lower_dev,
> +							  upper_dev);
> +		}
> +		break;
> +	}
> +
> +	return err;
> +}
> +
> +static int mvsw_pr_netdevice_port_event(struct net_device *lower_dev,
> +					struct net_device *port_dev,
> +					unsigned long event, void *ptr)
> +{
> +	switch (event) {
> +	case NETDEV_PRECHANGEUPPER:
> +	case NETDEV_CHANGEUPPER:
> +		return mvsw_pr_netdevice_port_upper_event(lower_dev, port_dev,
> +							  event, ptr);
> +	}
> +
> +	return 0;
> +}
> +
> +static int mvsw_pr_netdevice_event(struct notifier_block *nb,
> +				   unsigned long event, void *ptr)
> +{
> +	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
> +	struct mvsw_pr_switch *sw;
> +	int err = 0;
> +
> +	sw = container_of(nb, struct mvsw_pr_switch, netdevice_nb);
> +
> +	if (mvsw_pr_netdev_check(dev))
> +		err = mvsw_pr_netdevice_port_event(dev, dev, event, ptr);
> +
> +	return notifier_from_errno(err);
> +}
> +
> +static int mvsw_pr_fdb_init(struct mvsw_pr_switch *sw)
> +{
> +	int err;

This would be a good place to register the handler for the FDB learn /
age-out events

> +
> +	err = mvsw_pr_switch_ageing_set(sw, MVSW_PR_DEFAULT_AGEING_TIME);
> +	if (err)
> +		return err;
> +
> +	return 0;
> +}

And unregister the handler here, in mvsw_pr_fdb_fini()

> +
> +static int mvsw_pr_switchdev_init(struct mvsw_pr_switch *sw)
> +{
> +	int err = 0;
> +	struct mvsw_pr_switchdev *swdev;
> +	struct mvsw_pr_bridge *bridge;

Reverse xmas tree (RXT)... Elsewhere as well

> +
> +	if (sw->switchdev)
> +		return -EPERM;

Unclear why this is needed

> +
> +	bridge = kzalloc(sizeof(*sw->bridge), GFP_KERNEL);
> +	if (!bridge)
> +		return -ENOMEM;
> +
> +	swdev = kzalloc(sizeof(*sw->switchdev), GFP_KERNEL);
> +	if (!swdev) {
> +		kfree(bridge);

goto

> +		return -ENOMEM;
> +	}

Why do you need both 'struct mvsw_pr_switchdev' and 'struct
mvsw_pr_bridge'? I think the second is enough. Also, I assume
'switchdev' naming is inspired by mlxsw, but 'bridge' is better.

> +
> +	sw->bridge = bridge;
> +	bridge->sw = sw;
> +	sw->switchdev = swdev;
> +	swdev->sw = sw;
> +
> +	INIT_LIST_HEAD(&sw->bridge->bridge_list);
> +
> +	mvsw_owq = alloc_ordered_workqueue("%s_ordered", 0, "prestera_sw");
> +	if (!mvsw_owq) {
> +		err = -ENOMEM;
> +		goto err_alloc_workqueue;
> +	}
> +
> +	swdev->swdev_n.notifier_call = mvsw_pr_switchdev_event;
> +	err = register_switchdev_notifier(&swdev->swdev_n);
> +	if (err)
> +		goto err_register_switchdev_notifier;
> +
> +	swdev->swdev_blocking_n.notifier_call =
> +			mvsw_pr_switchdev_blocking_event;
> +	err = register_switchdev_blocking_notifier(&swdev->swdev_blocking_n);
> +	if (err)
> +		goto err_register_block_switchdev_notifier;
> +
> +	mvsw_pr_fdb_init(sw);
> +
> +	return 0;
> +
> +err_register_block_switchdev_notifier:
> +	unregister_switchdev_notifier(&swdev->swdev_n);
> +err_register_switchdev_notifier:
> +	destroy_workqueue(mvsw_owq);
> +err_alloc_workqueue:
> +	kfree(swdev);
> +	kfree(bridge);
> +	return err;
> +}
> +
> +static void mvsw_pr_switchdev_fini(struct mvsw_pr_switch *sw)
> +{
> +	if (!sw->switchdev)
> +		return;

?

> +
> +	unregister_switchdev_notifier(&sw->switchdev->swdev_n);
> +	unregister_switchdev_blocking_notifier
> +	    (&sw->switchdev->swdev_blocking_n);

Should be on the same line

You registered the blocking one last, so you should unregister it first

> +	flush_workqueue(mvsw_owq);
> +	destroy_workqueue(mvsw_owq);

The comment says "Safely destroy a workqueue. All work currently pending
will be done first." and it calls drain_workqueue(), which calls
flush_workqueue(). So I don't think you need to call flush_workqueue()
first.

> +	kfree(sw->switchdev);
> +	sw->switchdev = NULL;

Does not seem necessary.

> +	kfree(sw->bridge);
> +}
> +
> +static int mvsw_pr_netdev_init(struct mvsw_pr_switch *sw)
> +{
> +	int err = 0;
> +
> +	if (sw->netdevice_nb.notifier_call)
> +		return -EPERM;
> +
> +	sw->netdevice_nb.notifier_call = mvsw_pr_netdevice_event;
> +	err = register_netdevice_notifier(&sw->netdevice_nb);

You register the netdev notifier in prestera_switchdev.c, which seems to
be specific to bridge-related operations. However, in the future, as
your driver grows, you'll need to handle events that are not related to
bridge.

Therefore, I suggest registering this notifier in the main driver file,
prestera.c

> +	return err;
> +}
> +
> +static void mvsw_pr_netdev_fini(struct mvsw_pr_switch *sw)
> +{
> +	if (sw->netdevice_nb.notifier_call)

Unclear why this is needed.

> +		unregister_netdevice_notifier(&sw->netdevice_nb);
> +}
> +
> +int mvsw_pr_switchdev_register(struct mvsw_pr_switch *sw)
> +{
> +	int err;
> +
> +	err = mvsw_pr_switchdev_init(sw);
> +	if (err)
> +		return err;
> +
> +	err = mvsw_pr_netdev_init(sw);
> +	if (err)
> +		goto err_netdevice_notifier;
> +
> +	return 0;
> +
> +err_netdevice_notifier:
> +	mvsw_pr_switchdev_fini(sw);
> +	return err;
> +}
> +
> +void mvsw_pr_switchdev_unregister(struct mvsw_pr_switch *sw)
> +{
> +	mvsw_pr_netdev_fini(sw);
> +	mvsw_pr_switchdev_fini(sw);
> +}
> -- 
> 2.17.1
> 
