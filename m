Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C56327D1AF
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 16:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731199AbgI2OpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 10:45:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728937AbgI2OpH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 10:45:07 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 391612074B;
        Tue, 29 Sep 2020 14:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601390707;
        bh=cCruI2TZTNKs0ZkGC7Ns+2Pw5WFnv7xFM8BGfdpDEMk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uwedBfooJss6UHMRjnYzv8DpkTWnUqFMEt1LkWUXEXxLyZV+JrEbLRKNflM1z3hrB
         7iXwqRwZtoLcALQ3cWM7OqXao56OB66EQbrCH9JdA/6NW/7BUEOfLiXEsrJ5AfI12X
         NJzyJOTJ318/YkwP2H8uWVrCFhOuRaRGEyBdat7M=
Date:   Tue, 29 Sep 2020 07:45:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     davem@davemloft.net, alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: Re: [RFC PATCH v2 net-next 17/21] net: mscc: ocelot: offload egress
 VLAN rewriting to VCAP ES0
Message-ID: <20200929074504.331218ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200929101016.3743530-18-vladimir.oltean@nxp.com>
References: <20200929101016.3743530-1-vladimir.oltean@nxp.com>
        <20200929101016.3743530-18-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Sep 2020 13:10:12 +0300 Vladimir Oltean wrote:
> From: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> 
> VCAP ES0 is an egress VCAP operating on all outgoing frames.
> This patch added ES0 driver to support vlan push action of tc filter.
> Usage:
> 
> tc filter add dev swp1 egress protocol 802.1Q flower indev swp0 skip_sw \
>         vlan_id 1 vlan_prio 1 action vlan push id 2 priority 2
> 
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

drivers/net/ethernet/mscc/ocelot_flower.c:295:31: warning: cast to restricted __be16
drivers/net/ethernet/mscc/ocelot_flower.c:295:31: warning: cast to restricted __be16
drivers/net/ethernet/mscc/ocelot_flower.c:295:31: warning: cast to restricted __be16
drivers/net/ethernet/mscc/ocelot_flower.c:295:31: warning: cast to restricted __be16
drivers/net/ethernet/mscc/ocelot_flower.c:298:31: warning: cast to restricted __be16
drivers/net/ethernet/mscc/ocelot_flower.c:298:31: warning: cast to restricted __be16
drivers/net/ethernet/mscc/ocelot_flower.c:298:31: warning: cast to restricted __be16
drivers/net/ethernet/mscc/ocelot_flower.c:298:31: warning: cast to restricted __be16
drivers/net/ethernet/mscc/ocelot_flower.c:294:40: warning: restricted __be16 degrades to integer
drivers/net/ethernet/mscc/ocelot_flower.c:294:40: warning: restricted __be16 degrades to integer
