Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47BDE450660
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 15:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbhKOONp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 15 Nov 2021 09:13:45 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:56605 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232200AbhKOONK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 09:13:10 -0500
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 4A2FAE001A;
        Mon, 15 Nov 2021 14:10:08 +0000 (UTC)
Date:   Mon, 15 Nov 2021 15:06:20 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH v2 3/6] net: ocelot: pre-compute injection frame header
 content
Message-ID: <20211115150620.057674ae@fixe.home>
In-Reply-To: <20211115060800.44493c2f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211103091943.3878621-1-clement.leger@bootlin.com>
        <20211103091943.3878621-4-clement.leger@bootlin.com>
        <20211103123811.im5ua7kirogoltm7@skbuf>
        <20211103145351.793538c3@fixe.home>
        <20211115111344.03376026@fixe.home>
        <20211115060800.44493c2f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Mon, 15 Nov 2021 06:08:00 -0800,
Jakub Kicinski <kuba@kernel.org> a écrit :

> On Mon, 15 Nov 2021 11:13:44 +0100 Clément Léger wrote:
> > Test on standard packets with UDP (iperf3 -t 100 -l 1460 -u -b 0 -c *)
> > - With pre-computed header: UDP TX: 	33Mbit/s
> > - Without UDP TX: 			31Mbit/s  
> > -> 6.5% improvement    
> > 
> > Test on small packets with UDP (iperf3 -t 100 -l 700 -u -b 0 -c *)
> > - With pre-computed header: UDP TX: 	15.8Mbit/s
> > - Without UDP TX: 			16.4Mbit/s  
> > -> 4.3% improvement    
> 
> Something's wrong with these numbers or I'm missing context.
> You say improvement in both cases yet in the latter case the 
> new number is lower?

You are right Jakub, I swapped the last two results, 

Test on small packets with UDP (iperf3 -t 100 -l 700 -u -b 0 -c *)
 - With pre-computed header: UDP TX: 	16.4Mbit/s 
 - Without UDP TX: 			15.8Mbit/s
 -> 4.3% improvement

-- 
Clément Léger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
