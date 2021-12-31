Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3455948248A
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 16:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhLaPRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 10:17:46 -0500
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:43577 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbhLaPRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 10:17:46 -0500
Received: (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id AE88D40009;
        Fri, 31 Dec 2021 15:17:44 +0000 (UTC)
Date:   Fri, 31 Dec 2021 16:17:44 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: packets trickling out of STP-blocked ports
Message-ID: <Yc8fGODCp2BmvszE@piout.net>
References: <20211230230740.GA1510894@euler>
 <Yc7bBLupVUQC9b3X@piout.net>
 <20211231150651.GA1657469@euler>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211231150651.GA1657469@euler>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/12/2021 07:06:51-0800, Colin Foster wrote:
> Hi Alexandre
> 
> On Fri, Dec 31, 2021 at 11:27:16AM +0100, Alexandre Belloni wrote:
> > Hi,
> > 
> > On 30/12/2021 15:07:40-0800, Colin Foster wrote:
> > > Hi all,
> > > 
> > > An idea of how frequently this happens - my system has been currently up
> > > for 3700 seconds. Eight "own address as source address" events have
> > > happened at 66, 96, 156, 279, 509, 996, 1897, and 3699 seconds. 
> > > 
> > 
> > This is something I solved back in 2017. I can exactly remember how, you

Sorry, I meant "I can't exactly" ;)

> > can try:
> > 
> > sysctl -w net.ipv6.conf.swp3.autoconf=0
> 
> That sounds very promising! Sorry you had to fix my system config, but
> glad that this all makes perfect sense. 
> 

Let me know if this works ;) The bottom line being that you should
probably disable ipv6 autoconf on individual interfaces and then enable
it on the bridge.


-- 
Alexandre Belloni, co-owner and COO, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
