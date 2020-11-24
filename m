Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B212C2C2321
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 11:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732153AbgKXKlq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 24 Nov 2020 05:41:46 -0500
Received: from pic75-3-78-194-244-226.fbxo.proxad.net ([78.194.244.226]:40976
        "EHLO mail.corsac.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1732140AbgKXKlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 05:41:46 -0500
Received: from scapa.corsac.net (unknown [IPv6:2a01:e34:ec2f:4e20:6af7:28ff:fe8d:2119])
        by mail.corsac.net (Postfix) with ESMTPS id E9D62A2
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 11:41:40 +0100 (CET)
Received: from corsac (uid 1000)
        (envelope-from corsac@corsac.net)
        id a00a5
        by scapa.corsac.net (DragonFly Mail Agent v0.12);
        Tue, 24 Nov 2020 11:41:40 +0100
Message-ID: <02c032512dab22c1ab758d953affd94a4064fdbd.camel@corsac.net>
Subject: Re: [PATCH] usbnet: ipheth: fix connectivity with iOS 14
From:   Yves-Alexis Perez <corsac@corsac.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Martin Habets <mhabets@solarflare.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matti Vuorela <matti.vuorela@bitfactor.fi>,
        stable@vger.kernel.org
Date:   Tue, 24 Nov 2020 11:41:40 +0100
In-Reply-To: <20201121140311.42585c68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <CAAn0qaXmysJ9vx3ZEMkViv_B19ju-_ExN8Yn_uSefxpjS6g4Lw@mail.gmail.com>
         <20201119172439.94988-1-corsac@corsac.net>
         <20201121140311.42585c68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.38.1-2 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-11-21 at 14:03 -0800, Jakub Kicinski wrote:
> Applied to net with the typo fixed, thanks!

Thanks!

Is there any chance it'll be in 5.10 or will it have to wait for the 5.11
merge window?

Also it should be applied to all supported/stable kernels. I guess that'll
have to wait until it's in Linus tree according [1] to but I'm unsure if I
need to trigger the action myself or if Greg (or Dave, according to [2]) will
do it.

I looked at [3] and it seems that adding the CC: stable in my commit message
maybe was an error because it's marked as a Failure, so if there's anything
needed from me here, don't hesitate to ask.

[1] https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
[2]
https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html#q-how-can-i-tell-what-patches-are-queued-up-for-backporting-to-the-various-stable-releases
[3] https://patchwork.kernel.org/bundle/netdev/stable/?state=*

Regards,
-- 
Yves-Alexis
