Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2217F19839B
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 20:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbgC3SoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 14:44:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40864 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbgC3SoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 14:44:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C888E15C60D01;
        Mon, 30 Mar 2020 11:44:17 -0700 (PDT)
Date:   Mon, 30 Mar 2020 11:44:16 -0700 (PDT)
Message-Id: <20200330.114416.1872962832740552526.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        netdev@vger.kernel.org, xiaoliang.yang_1@nxp.com,
        linux-kernel@vger.kernel.org, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        joergen.andreasen@microchip.com, UNGLinuxDriver@microchip.com,
        yangbo.lu@nxp.com, alexandru.marginean@nxp.com, po.liu@nxp.com,
        claudiu.manoil@nxp.com, leoyang.li@nxp.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: Re: [PATCH v2 net-next 0/6] Port and flow policers for DSA
 (SJA1105, Felix/Ocelot)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200329115202.16348-1-olteanv@gmail.com>
References: <20200329115202.16348-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Mar 2020 11:44:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sun, 29 Mar 2020 14:51:56 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This series adds support for 2 types of policers:
>  - port policers, via tc matchall filter
>  - flow policers, via tc flower filter
> for 2 DSA drivers:
>  - sja1105
>  - felix/ocelot
> 
> First we start with ocelot/felix. Prior to this patch, the ocelot core
> library currently only supported:
> - Port policers
> - Flow-based dropping and trapping
> But the felix wrapper could not actually use the port policers due to
> missing linkage and support in the DSA core. So one of the patches
> addresses exactly that limitation by adding the missing support to the
> DSA core. The other patch for felix flow policers (via the VCAP IS2
> engine) is actually in the ocelot library itself, since the linkage with
> the ocelot flower classifier has already been done in an earlier patch
> set.
> 
> Then with the newly added .port_policer_add and .port_policer_del, we
> can also start supporting the L2 policers on sja1105.
> 
> Then, for full functionality of these L2 policers on sja1105, we also
> implement a more limited set of flow-based policing keys for this
> switch, namely for broadcast and VLAN PCP.
> 
> Series version 1 was submitted here:
> https://patchwork.ozlabs.org/cover/1263353/
> 
> Nothing functional changed in v2, only a rebase.

This looks fine to me, series applied, thanks.
