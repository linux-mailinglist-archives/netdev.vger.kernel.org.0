Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 441FD531638
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbiEWTAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 15:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243276AbiEWTAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 15:00:01 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 731B47CDC3
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 11:41:48 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id bo5so14455460pfb.4
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 11:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=gGYYjU/noBclHDawBnqQiQJMm2fohCKixwdC+ZDLg98=;
        b=PQDVxDFAuUaKXXYrMA3WGBTRZxVmGDR6GdFAAzJ4m60DTCGWImT/NEnYRTxM60E7gM
         tyLHnNzb7Elz3SW+o9BFUqtiWfk+UczuRnWUfX9Ss8VggPdDhOMy49fBxN6PVr8/dys4
         g8v7fZBTh0/2p8fK4tj0rhFG/L5k+zcXnbqnYadfRBUblsU5ESM7KWE/otT/iSiwl425
         ACFZZbZg/o4BL4p464/N+Rn3WDukyPhLDkNPDd2eLRvwx5+FNsunXnMR4C/jurMndxnO
         goWdZYTurOd5nwuDxWQzLN2yaWzp5iyrItTY9vvMLgPXApTesvnVB6WvDy21TAJ/Fd/l
         JXig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gGYYjU/noBclHDawBnqQiQJMm2fohCKixwdC+ZDLg98=;
        b=uFB5cQF96dkLzk9hc5GM5Xdi/vab5ABFyaaR2/szht5ZICMuI62HDdOb/Op2QEahvP
         NC0PODJb/fSQrnzU6s8iiFTdrVJB2+U23XSy8eO9IWWqUeIuuYPgSDYKU0UvAEAH2Zw0
         n5V77dH3eU54uJPILYMj4+x9Xt++Gc0NXPQ5yk+bFKM2U01qL9E0q8j5RRIEmiopxlGT
         kRxmKIGMS98Vymk10q0HdRH5JMOrs9JV9yynVveM7VGRdrIUK4guS7vlX4YJCk8580AN
         O6XlrMzwcRqUh7V5gl81d4lv2nXkMCEX4TPGfw1gHp7VI9xgqe7gCIrTUUm92z43OKMK
         mRUA==
X-Gm-Message-State: AOAM530NC92KOzl4QoKiOpS7PbJBJPfxQ9a4pXqkwkhFSMkSV7iV6N2s
        Rk1EN1tOOpJRTCWyeTuNDYQ=
X-Google-Smtp-Source: ABdhPJzFymQQ9ABrkxdpfBhRo6e9i7AXEPOwxxf+GN7YPFgVuQSozHxvBVp66ly2Xuuob78lY9i8CA==
X-Received: by 2002:a63:2b87:0:b0:3f6:6d07:7d98 with SMTP id r129-20020a632b87000000b003f66d077d98mr16646966pgr.475.1653331308082;
        Mon, 23 May 2022 11:41:48 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bu5-20020a17090aee4500b001dc7623950csm37498pjb.11.2022.05.23.11.41.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 11:41:47 -0700 (PDT)
Message-ID: <d5d485e3-bddf-f052-2f46-f306f53f3d34@gmail.com>
Date:   Mon, 23 May 2022 11:41:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [RFC PATCH net-next 10/12] net: dsa: allow the DSA master to be
 seen and changed through rtnetlink
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Frank Wunderlich <frank-w@public-files.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20220523104256.3556016-1-olteanv@gmail.com>
 <20220523104256.3556016-11-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220523104256.3556016-11-olteanv@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/23/22 03:42, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Some DSA switches have multiple CPU ports, which can be used to improve
> CPU termination throughput, but DSA, through dsa_tree_setup_cpu_ports(),
> sets up only the first one, leading to suboptimal use of hardware.
> 
> The desire is to not change the default configuration but to permit the
> user to create a dynamic mapping between individual user ports and the
> CPU port that they are served by, configurable through rtnetlink. It is
> also intended to permit load balancing between CPU ports, and in that
> case, the foreseen model is for the DSA master to be a bonding interface
> whose lowers are the physical DSA masters.
> 
> To that end, we create a struct rtnl_link_ops for DSA user ports with
> the "dsa" kind. We expose the IFLA_DSA_MASTER link attribute that
> contains the ifindex of the newly desired DSA master.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

[snip]

> +
> +static int dsa_changelink(struct net_device *dev, struct nlattr *tb[],
> +			  struct nlattr *data[],
> +			  struct netlink_ext_ack *extack)
> +{
> +	int err;
> +
> +	if (!data)
> +		return 0;
> +
> +	if (data[IFLA_DSA_MASTER]) {

We could add a comment to explain that IFLA_LINK is "reserved" for 
standard usage of associating the DSA device with a different upper 
type, like VLAN, bridge master etc.

> +		u32 ifindex = nla_get_u32(data[IFLA_DSA_MASTER]);
> +		struct net_device *master;
> +
> +		master = __dev_get_by_index(dev_net(dev), ifindex);
> +		if (!master)
> +			return -EINVAL;
> +
> +		err = dsa_slave_change_master(dev, master, extack);
> +		if (err)
> +			return err;
> +	}

I would be tempted to reduce the indentation here because we are almost 
guaranteed to add code in that conditional section?

[snip]

>   
> +static int dsa_port_assign_master(struct dsa_port *dp,
> +				  struct net_device *master,
> +				  struct netlink_ext_ack *extack,
> +				  bool fail_on_err)
> +{
> +	struct dsa_switch *ds = dp->ds;
> +	int port = dp->index, err;
> +
> +	err = ds->ops->port_change_master(ds, port, master, extack);
> +	if (err && !fail_on_err)
> +		dev_err(ds->dev, "port %d failed to assign master %s: %pe\n",
> +			port, master->name, ERR_PTR(err));

Should not that go over extack instead?

> +
> +	if (err && fail_on_err)
> +		return err;
> +
> +	dp->cpu_dp = master->dsa_ptr;
> +
> +	return 0;
> +}
> +
> +/* Change the dp->cpu_dp affinity for a user port. Note that both cross-chip
> + * notifiers and drivers have implicit assumptions about user-to-CPU-port
> + * mappings, so we unfortunately cannot delay the deletion of the objects
> + * (switchdev, standalone addresses, standalone VLANs) on the old CPU port
> + * until the new CPU port has been set up. So we need to completely tear down
> + * the old CPU port before changing it, and restore it on errors during the
> + * bringup of the new one.
> + */
> +int dsa_port_change_master(struct dsa_port *dp, struct net_device *master,
> +			   struct netlink_ext_ack *extack)
> +{
> +	struct net_device *bridge_dev = dsa_port_bridge_dev_get(dp);
> +	struct net_device *old_master = dsa_port_to_master(dp);
> +	struct net_device *dev = dp->slave;
> +	struct dsa_switch *ds = dp->ds;
> +	int port = dp->index;
> +	bool vlan_filtering;
> +	int err, tmp;
> +
> +	/* Bridges may hold host FDB, MDB and VLAN objects. These need to be
> +	 * migrated, so dynamically unoffload and later reoffload the bridge
> +	 * port.
> +	 */
> +	if (bridge_dev) {
> +		dsa_port_pre_bridge_leave(dp, bridge_dev);
> +		dsa_port_bridge_leave(dp, bridge_dev);
> +	}
> +
> +	/* The port might still be VLAN filtering even if it's no longer
> +	 * under a bridge, either due to ds->vlan_filtering_is_global or
> +	 * ds->needs_standalone_vlan_filtering. In turn this means VLANs
> +	 * on the CPU port.
> +	 */
> +	vlan_filtering = dsa_port_is_vlan_filtering(dp);
> +	if (vlan_filtering) {
> +		err = dsa_slave_manage_vlan_filtering(dev, false);
> +		if (err) {
> +			dev_err(ds->dev,
> +				"port %d failed to remove standalone VLANs: %pe\n",
> +				port, ERR_PTR(err));

Likewise, should not that be via extack? And likewise for pretty much 
any message down below.

[snip]

> +	if (!ds->ops->port_change_master)
> +		return -EOPNOTSUPP;

This could be provided over extactk since it is not even supposed to be 
happening.
-- 
Florian
