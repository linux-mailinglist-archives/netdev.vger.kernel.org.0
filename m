Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE1A323F579
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 02:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgHHAYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 20:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgHHAYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 20:24:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A72C061A28;
        Fri,  7 Aug 2020 17:24:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 107D81276E422;
        Fri,  7 Aug 2020 17:07:27 -0700 (PDT)
Date:   Fri, 07 Aug 2020 17:24:11 -0700 (PDT)
Message-Id: <20200807.172411.1117824106907149799.davem@davemloft.net>
To:     hongbo.wang@nxp.com
Cc:     xiaoliang.yang_1@nxp.com, allan.nielsen@microchip.com,
        po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, mingkai.hu@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, jiri@resnulli.us,
        idosch@idosch.org, kuba@kernel.org, vinicius.gomes@intel.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, ivecera@redhat.com
Subject: Re: [PATCH v5 0/2] Add 802.1AD protocol support for dsa switch and
 ocelot driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200807111349.20649-1-hongbo.wang@nxp.com>
References: <20200807111349.20649-1-hongbo.wang@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Aug 2020 17:07:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: hongbo.wang@nxp.com
Date: Fri,  7 Aug 2020 19:13:47 +0800

> From: "hongbo.wang" <hongbo.wang@nxp.com>
> 
> 1. the patch 0001* is for setting single port into 802.1AD(QinQ) mode,
> before this patch, the function dsa_slave_vlan_rx_add_vid didn't pass 
> the parameter "proto" to next port level, so switch's port can't get
> parameter "proto"
>   after applying this patch, the following command can be supported:
>   ip link set br0 type bridge vlan_protocol 802.1ad
>   ip link add link swp1 name swp1.100 type vlan protocol 802.1ad id 100
> 
> 2. the patch 0002* is for setting QinQ related registers in ocelot 
> switch driver, after applying this patch, the switch(VSC99599)'s port can
> enable or disable QinQ mode.
> 
> 3. Version log
> v5:
> a. add devlink to enable qinq_mode of ocelot's single port
> b. modify br_switchdev_port_vlan_add to pass bridge's vlan_proto to port driver
> c. enable NETIF_F_HW_VLAN_STAG_FILTER in ocelot driver
> v4:
> a. modify slave.c to support "ip set br0 type bridge vlan_protocol 802.1ad"
> b. modify ocelot.c, if enable QinQ, set VLAN_AWARE_ENA and VLAN_POP_CNT per
>    port when vlan_filter=1
> v3: combine two patches to one post

Please defer new feature changes, like this, until the net-next tree is open
again.  It is closed right now.

Thank you.
