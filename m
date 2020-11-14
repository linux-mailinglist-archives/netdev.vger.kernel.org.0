Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 200112B2F27
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 18:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgKNRoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 12:44:01 -0500
Received: from mail.nic.cz ([217.31.204.67]:37848 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726088AbgKNRoA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 12:44:00 -0500
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id 5C40F140A66;
        Sat, 14 Nov 2020 18:43:59 +0100 (CET)
Date:   Sat, 14 Nov 2020 18:43:57 +0100
From:   Marek Behun <marek.behun@nic.cz>
To:     "Tj (Elloe Linux)" <ml.linux@elloe.vision>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        chris.packham@alliedtelesis.co.nz, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, info <info@turris.cz>
Subject: Re: dsa: mv88e6xxx not receiving IPv6 multicast packets
Message-ID: <20201114184357.41902445@nic.cz>
In-Reply-To: <eed7bc92-e1e6-35df-a2cf-97e74a8730fd@elloe.vision>
References: <1b6ba265-4651-79d2-9b43-f14e7f6ec19b@alliedtelesis.co.nz>
        <0538958b-44b8-7187-650b-35ce276e9d83@elloe.vision>
        <3390878f-ca70-7714-3f89-c4455309d917@elloe.vision>
        <20201114155614.GZ1480543@lunn.ch>
        <eed7bc92-e1e6-35df-a2cf-97e74a8730fd@elloe.vision>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 Nov 2020 16:06:33 +0000
"Tj (Elloe Linux)" <ml.linux@elloe.vision> wrote:

> On 14/11/2020 15:56, Andrew Lunn wrote:
> >> 1) with isc-dhcp-server configured with very short lease times (180
> >> seconds). After mox reboot (or systemctl restart systemd-networkd)
> >> clients successfully obtain a lease and a couple of RENEWs (requested
> >> after 90 seconds) but then all goes silent, Mox OS no longer sees the
> >> IPv6 multicast RENEW packets and client leases expire.  
> > 
> > So it takes about 3 minutes to reproduce this?
> > 
> > Can you do a git bisect to figure out which change broke it? It will
> > take you maybe 5 minutes per step, and given the wide range of
> > kernels, i'm guessing you need around 15 steps. So maybe two hours of
> > work.
> > 
> > 	Andrew
> >  
> 
> I'll check if we can - the problem might be the Turris Mox kernel is
> based on a board support package drop by Marvell so I'm not clear right
> now how divergent they are. Hopefully the Turris kernel devs can help on
> that.
> 
No, TurrisOS kernel is just current OpenWRT 4.14 kernel with some
patches added onto it. Turris MOX is also supported in upstream kernel.
If this error can be reproduced on upstream kernel, you can try bisect
there...

Marek
