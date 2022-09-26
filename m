Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17C2A5E9CB6
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 11:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234621AbiIZJAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 05:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234413AbiIZI7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 04:59:50 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914A4233;
        Mon, 26 Sep 2022 01:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fPCxvmc2DBE43wFG2vddH622TgaWjDjckiQMxbrPvHs=; b=mQ/UCJVAfxVljFWNLkEMdVdYJf
        hGWFtFlOCMMrhhfzpLzf6EnNmaMUB5nSNTB4ZqN26R37j8knBIsS9+OjesDO+m4bIQ89sMWHxR+Ux
        d0+HEEe7qSundbBuobyTBbXd606W4hgaSo46P6XUl5MYMCMSkbvQq2iBfm5RscNfjQiCobr/Z0ipD
        Gl9QSbKJwDmgbnIwnVYV2YZpchjM+Ie/NtJKRavrVsW+a2MSaMSLRpnbN/NCU7clQajTixA1kOq1S
        PQlv4+uiUzXyXMmKFV6w0Ayrf9GCtqydvM1gsZMFAR5FDCEZTV6nsHDi+g6iQH9M7aIxyAfFqL67h
        qHpeg56w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34490)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ocjxS-0000DE-UC; Mon, 26 Sep 2022 09:59:22 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ocjxM-00050w-R4; Mon, 26 Sep 2022 09:59:16 +0100
Date:   Mon, 26 Sep 2022 09:59:16 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Hector Martin <marcan@marcan.st>,
        "~postmarketos/upstreaming@lists.sr.ht" 
        <~postmarketos/upstreaming@lists.sr.ht>,
        "martin.botka@somainline.org" <martin.botka@somainline.org>,
        "angelogioacchino.delregno@somainline.org" 
        <angelogioacchino.delregno@somainline.org>,
        "marijn.suijten@somainline.org" <marijn.suijten@somainline.org>,
        "jamipkettunen@somainline.org" <jamipkettunen@somainline.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Marek Vasut <marex@denx.de>,
        "Zhao, Jiaqing" <jiaqing.zhao@intel.com>,
        Soon Tak Lee <soontak.lee@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Stockholm syndrome with Linux wireless?
Message-ID: <YzFp5BdPPgcqG7zK@shell.armlinux.org.uk>
References: <20220921001630.56765-1-konrad.dybcio@somainline.org>
 <83b90478-3974-28e6-cf13-35fc4f62e0db@marcan.st>
 <13b8c67c-399c-d1a6-4929-61aea27aa57d@somainline.org>
 <0e65a8b2-0827-af1e-602c-76d9450e3d11@marcan.st>
 <7fd077c5-83f8-02e2-03c1-900a47f05dc1@somainline.org>
 <CACRpkda3uryD6TOEaTi3pPX5No40LBWoyHR4VcEuKw4iYT0dqA@mail.gmail.com>
 <20220922133056.eo26da4npkg6bpf2@bang-olufsen.dk>
 <CACRpkdYwJLO18t08zqu_Y1gaSpZJMc+3MFxRUtQzLkJF2MqmqQ@mail.gmail.com>
 <87wn9q35tp.fsf_-_@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87wn9q35tp.fsf_-_@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 11:20:18AM +0300, Kalle Valo wrote:
> (changing the subject as this has nothing to do with brcmfmac)
> 
> Linus Walleij <linus.walleij@linaro.org> writes:
> 
> > On Thu, Sep 22, 2022 at 3:31 PM Alvin Šipraga <ALSI@bang-olufsen.dk> wrote:
> >
> >> I would also point out that the BCM4359 is equivalent to the
> >> CYW88359/CYW89359 chipset, which we are using in some of our
> >> products. Note that this is a Cypress chipset (identifiable by the
> >> Version: ... (... CY) tag in the version string). But the FW Konrad is
> >> linking appears to be for a Broadcom chipset.
> >
> > This just makes me think about Peter Robinsons seminar at
> > LPC last week...
> > "All types of wireless in Linux are terrible and why the vendors
> > should feel bad"
> > https://lpc.events/event/16/contributions/1278/attachments/1120/2153/wireless-issues.pdf
> 
> Thanks, this was a good read! I'm always interested about user and
> downstream feedback, both good and bad :) But I didn't get the Stockholm
> syndrome comment in the end, what does he mean with that?
> 
> BTW we have a wireless workshop in netdevconf 0x16, it would be great to
> have there a this kind of session discussing user pain points:
> 
> https://netdevconf.info/0x16/session.html?Wireless-Workshop

You asked. :)

It's probably outside of your control as it's probably firmware issues
is when using Broadcom or TI WiFi in AP mode, and the resulting
instability.

Over the years, SolidRun have used Broadcom 4329 and 4330 chipsets on
their iMX6 products, and then switched to using a TI WL18xx chipset.
I forget what the issues were with the Broadcom chipsets, as I'm
currently using the TI variants.

In order to keep the WiFi network stable, I implemented a userspace
program that polls the WL18xx statistics in debugfs every 100ms, and
when it seems the adapter has got stuck, it takes the interface down
and brings it back up again to reset stuff. This seems to improve the
overall stability, but it's still far from perfect as one regularly
sees latency go through the roof.

I recently noticed (earlier this month) a bigger problem with it -
I had one laptop running zoom, another laptop running interactive
stuff, and while zoom was running, the other laptop basically lost
network access - which came back when zoom was stopped. I'm not
sure what was going on there, because if you don't have the ability
to do interactive stuff it's pretty hard to debug what's going on
at the machine with the AP.

I've just looked at that machine, which has been mostly idle (as in
no clients connected) and I see:

[271559.346460] wlcore: ERROR Tx stuck (in FW) for 5000 ms. Starting recovery
[271559.353395] WARNING: CPU: 1 PID: 6395 at drivers/net/wireless/ti/wlcore/main.c:803 wl12xx_queue_recovery_work.part.0+0x50/0x54 [wlcore]

with the resutling entirely useless backtrace - that's 3 days, 3 hours
and 25 minutes ago, which would make it Friday 6:25am when nothing
was connected to the wifi network.

I've turned off all the runtime PM for the hardware path for wifi
conenctivity (every single power/control file is forced to "on") so
it isn't being triggered by some runtime PM behaviour.

Like I think many, I've come to the conclusion that WiFi is just a
completely unstable medium, and wired networking is just far superior,
even though it comes with the nusience of needing wires.

I don't think this is the fault of the Linux WiFi core code, I think
this is down to vendors, and vendors just do not want to know about
problems.

That said, running this stuff in AP mode isn't vendors primary goal,
since that isn't what most users want to do, so it's probably
understandable that AP mode tends to be flakey.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
