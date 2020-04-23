Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3421F1B5279
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 04:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgDWC0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 22:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgDWC0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 22:26:47 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6185C03C1AA
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 19:26:47 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C7D78127A8972;
        Wed, 22 Apr 2020 19:26:46 -0700 (PDT)
Date:   Wed, 22 Apr 2020 19:26:45 -0700 (PDT)
Message-Id: <20200422.192645.1573131164417353209.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     horatiu.vultur@microchip.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        yangbo.lu@nxp.com, po.liu@nxp.com
Subject: Re: [PATCH net-next] net: dsa: felix: allow flooding for all
 traffic classes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200421181347.14261-1-olteanv@gmail.com>
References: <20200421181347.14261-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Apr 2020 19:26:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Tue, 21 Apr 2020 21:13:47 +0300

> From: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> 
> Right now it can be seen that the VSC9959 (Felix) switch will not flood
> frames if they have a VLAN tag with a PCP of 1-7 (nonzero).
> 
> It turns out that Felix is quite different from its cousin, Ocelot, in
> that frame flooding can be allowed/denied per traffic class. Where
> Ocelot has 1 instance of the ANA_FLOODING register, Felix has 8.
> 
> The approach that this driver is going to take is "thanks, but no
> thanks". We have no use case of limiting the flooding domain based on
> traffic class, so we just want to allow packets to be flooded, no matter
> what traffic class they have.
> 
> So we copy the line of code from ocelot.c which does the one-shot
> initialization of the flooding PGIDs, and we add it to felix.c as well -
> except replicated 8 times.
> 
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied, thanks.
