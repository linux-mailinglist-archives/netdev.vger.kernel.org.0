Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE061B4CC8
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 20:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgDVSlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 14:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbgDVSlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 14:41:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3185AC03C1A9
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 11:41:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3D2F5120ED563;
        Wed, 22 Apr 2020 11:41:09 -0700 (PDT)
Date:   Wed, 22 Apr 2020 11:41:06 -0700 (PDT)
Message-Id: <20200422.114106.1866124310620310824.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, idosch@idosch.org,
        allan.nielsen@microchip.com, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, antoine.tenart@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, claudiu.manoil@nxp.com,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com, po.liu@nxp.com,
        jiri@mellanox.com, kuba@kernel.org
Subject: Re: [PATCH net-next 0/3] Ocelot MAC_ETYPE tc-flower key
 improvements
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200420162743.15847-1-olteanv@gmail.com>
References: <20200420162743.15847-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Apr 2020 11:41:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Mon, 20 Apr 2020 19:27:40 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> As discussed in the comments surrounding this patch:
> https://patchwork.ozlabs.org/project/netdev/patch/20200417190308.32598-1-olteanv@gmail.com/
> 
> the restrictions imposed on non-MAC_ETYPE rules were harsher than they
> needed to be. IP, IPv6, ARP rules can still be added concurrently with
> src_mac and dst_mac rules, as long as those MAC address rules do not ask
> for an offending EtherType.
> 
> For that to actually be supported, we need to parse the EtherType from
> the flower classification rule first.

Series applied, thanks.
