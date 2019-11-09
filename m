Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2778AF6149
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 21:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfKIUCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 15:02:04 -0500
Received: from mout-p-102.mailbox.org ([80.241.56.152]:32798 "EHLO
        mout-p-102.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbfKIUCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 15:02:03 -0500
X-Greylist: delayed 531 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Nov 2019 15:02:02 EST
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 479SVZ3zVPzKmQS;
        Sat,  9 Nov 2019 20:53:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:message-id:date:date:subject:subject
        :from:from:received; s=mail20150812; t=1573329177; bh=M7oLHM6GTq
        fgSDX0vgvOtgGwC8zzgFftT7dUZlMbO0k=; b=b63V1dqu9dyA86AtCs8CL1cx/F
        qZeFbJ5BWE92Icg54qxGj9JreMgnPVQt6NljKpXNdXcQxF7xceqdnAtdfKQhDEez
        7LoAcGcZo1ODymxkIc+KuvS0orUzWPoRWRDl53XXUoz9jwTTiFKCKd40FUYos8eC
        JOV82+SBQqC9nAcbpz4IwwTSGKfh+OjNCvYifJfqcKnP4rj/Rplquf+PwTc6zBfM
        s2QaLmw3MfZlyjtVxLbJlCraEIXHV7Wla5IKddVleCDRp5TU9vdqgf36TUXLjYah
        vuMVwjzinSlJwh17z2XyJgS5sbyi8ITIRwqvKU7YyEr8rU4v3X41RlFYMlVw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1573329188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0TaijmMVk5bwn35HLiLpfyHZS0CXVgZsMgJ8IFKWEvM=;
        b=sNxawXykxIzAXTxNRSPAQvGs/YRwYpamJMw8YN7F+Er9Oz4Qa3DAvCG7JGyFRsZ7hgPVe7
        tzf6bj+qWncE9cNyZqFucBPVAeV038pP0sPmrrJuytebWo2pueFiWvAzy7schsorucLt2R
        FFk4zbSxB3DOcGwyboU2muHX35NoCI/UNFDMgi2P4GFY9MrHLaNlEOiyyRZUpre+op+MBS
        MyzXblFzGxdBWoUO84O+By8+8n5LptJn0LjTCp4AHWUCNt/DujsLSQ1TBrXIWI03K+1FLZ
        gUnNjLvELLtePLoyfCZH2x1JvD0d3qS6kRNLsZj4iDm2dozG6bWDVaSg3D2tfA==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by hefe.heinlein-support.de (hefe.heinlein-support.de [91.198.250.172]) (amavisd-new, port 10030)
        with ESMTP id asZD_HPxi0tO; Sat,  9 Nov 2019 20:52:57 +0100 (CET)
From:   Alexander Stein <alexander.stein@mailbox.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, shawnguo@kernel.org,
        mark.rutland@arm.com, devicetree@vger.kernel.org,
        leoyang.li@nxp.com, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: ls1021a-tsn: Use interrupts for the SGMII PHYs
Date:   Sat, 09 Nov 2019 20:52:54 +0100
Message-ID: <393335751.FoSYQk3TTC@kongar>
In-Reply-To: <CA+h21hoqkE2D03BHrFeU+STbK8pStRRFu+x7+9j2nwFf+EHJNg@mail.gmail.com>
References: <20191109105642.30700-1-olteanv@gmail.com> <20191109150953.GJ22978@lunn.ch> <CA+h21hoqkE2D03BHrFeU+STbK8pStRRFu+x7+9j2nwFf+EHJNg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 On Saturday, November 9, 2019, 4:21:51 PM CET Vladimir Oltean wrote:
> On 09/11/2019, Andrew Lunn <andrew@lunn.ch> wrote:
> > On Sat, Nov 09, 2019 at 12:56:42PM +0200, Vladimir Oltean wrote:
> >> On the LS1021A-TSN board, the 2 Atheros AR8031 PHYs for eth0 and eth1
> >> have interrupt lines connected to the shared IRQ2_B LS1021A pin.
> >>
> >> The interrupts are active low, but the GICv2 controller does not support
> >> active-low and falling-edge interrupts, so the only mode it can be
> >> configured in is rising-edge.
> >
> > Hi Vladimir
> >
> > So how does this work? The rising edge would occur after the interrupt
> > handler has completed? What triggers the interrupt handler?
> >
> > 	Andrew
> >
> 
> Hi Andrew,
> 
> I hope I am not terribly confused about this. I thought I am telling
> the interrupt controller to raise an IRQ as a result of the
> low-to-high transition of the electrical signal. Experimentation sure
> seems to agree with me. So the IRQ is generated immediately _after_
> the PHY has left the line in open drain and it got pulled up to Vdd.

It is correct GIC only supports raising edge and active-high. The IRQ[0:5] on ls1021a are a bit special though.
They not directly connected to GIC, but there is an optional inverter, enabled by default. See RM for register SCFG_INTPCR.
If left to default, those pins get actually active-high internally.
There was a patch 2 years ago to add support for this inverter: https://lore.kernel.org/patchwork/patch/860993/

Best regards,
Alexander


