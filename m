Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A66845FD34
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 08:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352458AbhK0HS5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 27 Nov 2021 02:18:57 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:48099 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352639AbhK0HQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 02:16:56 -0500
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id CD32860006;
        Sat, 27 Nov 2021 07:13:39 +0000 (UTC)
Date:   Sat, 27 Nov 2021 08:13:30 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Denis Kirjanov <dkirjanov@suse.de>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: Re: [PATCH net-next v3 1/4] dt-bindings: net: mscc,vsc7514-switch:
 convert txt bindings to yaml
Message-ID: <20211127081330.0eff57f9@fixe.home>
In-Reply-To: <YaFiljIjC6gkScSi@lunn.ch>
References: <20211126172739.329098-1-clement.leger@bootlin.com>
        <20211126172739.329098-2-clement.leger@bootlin.com>
        <YaFiljIjC6gkScSi@lunn.ch>
Organization: Bootlin
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Fri, 26 Nov 2021 23:41:26 +0100,
Andrew Lunn <andrew@lunn.ch> a écrit :

> On Fri, Nov 26, 2021 at 06:27:36PM +0100, Clément Léger wrote:
> > Convert existing txt bindings to yaml format. Additionally, add bindings
> > for FDMA support and phy-mode property.  
> 
> Whenever i see 'additionally' i think a patch is doing two things, and
> it should probably be two or more patches. Do these needs to be
> combined into one patch?
> 
>     Andrew

Hi Andrew,

You are right, actually, only the FDMA support should be in this patch.
I'll resubmit a series only for this support.

-- 
Clément Léger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
