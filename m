Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE6C2CE91B
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 08:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbgLDH6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 02:58:24 -0500
Received: from mslow2.mail.gandi.net ([217.70.178.242]:45486 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728722AbgLDH6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 02:58:24 -0500
Received: from relay6-d.mail.gandi.net (unknown [217.70.183.198])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id 817113A9EF0
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 07:57:37 +0000 (UTC)
X-Originating-IP: 86.194.74.19
Received: from localhost (lfbn-lyo-1-997-19.w86-194.abo.wanadoo.fr [86.194.74.19])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 23B6AC000E;
        Fri,  4 Dec 2020 07:56:33 +0000 (UTC)
Date:   Fri, 4 Dec 2020 08:56:33 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Steen Hegelund <steen.hegelund@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 3/4] phy: Add Sparx5 ethernet serdes PHY driver
Message-ID: <20201204075633.GC74177@piout.net>
References: <20201203103015.3735373-1-steen.hegelund@microchip.com>
 <20201203103015.3735373-4-steen.hegelund@microchip.com>
 <20201203215253.GL2333853@lunn.ch>
 <20201203225232.GI1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203225232.GI1551@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On 03/12/2020 22:52:33+0000, Russell King - ARM Linux admin wrote:
> You still have not Cc'd me on your patches. Please can you either:
> 
> 1) use get_maintainer.pl to find out whom you should be sending
>    your patches to
> or
> 2) include me in your cc for this patch set as phylink maintainer in
>    your patch set so I can review your use of phylink.
> 

Note that this series is different from the network (switchdev) driver
series and doesn't make use of phylink.

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
