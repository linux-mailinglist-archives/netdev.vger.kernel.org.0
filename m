Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95C3B31DCC9
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 16:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233905AbhBQP5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 10:57:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:54608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233901AbhBQP5J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 10:57:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 782EB64DA1;
        Wed, 17 Feb 2021 15:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613577386;
        bh=b9fBt+ej2vO4foVBIklKpPzfmDmDGzNgOt496HpJmyU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=RDvgYMaJntoxNEgOFcHuJLkW/0EDXJomCx6bokly0GcgYl30NXq42mLvEGqlhFEkv
         LkevpMCGOlBE7jpCWgMJY9/0aDgwVquJaJgKrCXE0p8y2+u23pHzCigepba5MN7F9r
         /q3IYH8AbCSDYotEJVlbAaEzn+vDN68TgJ4kLv5fGDRfomiwCqFMwpipvi6x9IOqlX
         M4pKInP04YIQZl4psBwhI2xCjIqYwaRaOQaeCyu8BA53bhb3tYQeZRaI78aAyD4Y/+
         1LzoiuL+mP5Hb5i9RH0rdsh5iXICAiKBWlURMJywcqa7C6NAJlfE/1sVmzPA5VJYx5
         nbMh4HCFEIRUA==
Received: by mail-oi1-f171.google.com with SMTP id 18so15433113oiz.7;
        Wed, 17 Feb 2021 07:56:26 -0800 (PST)
X-Gm-Message-State: AOAM531exmj7P+RwSBU8L/tP+fUFiO1oQ0TUbr5zZvHzLjs+EGlOzFJO
        Mj6wKSKT6VRsY6rXtN7IZoyU6zkg2EGCeF7INAE=
X-Google-Smtp-Source: ABdhPJyh6Wu655aO2Um9XGrM2VPaQJnkaIX2U987Oai785QHYTW76/WDBgkH2zKec22DnLFiQYTRn3pCPLzjACmwlDA=
X-Received: by 2002:aca:aad4:: with SMTP id t203mr5740518oie.67.1613577385876;
 Wed, 17 Feb 2021 07:56:25 -0800 (PST)
MIME-Version: 1.0
References: <1613012611-8489-1-git-send-email-min.li.xe@renesas.com>
 <CAK8P3a3YhAGEfrvmi4YhhnG_3uWZuQi0ChS=0Cu9c4XCf5oGdw@mail.gmail.com>
 <OSBPR01MB47732017A97D5C911C4528F0BA8B9@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a2KDO4HutsXNJzjmRJTvW1QW4Kt8H7U53_QqpmgvZtd3A@mail.gmail.com>
 <OSBPR01MB4773B22EA094A362DD807F83BA8B9@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a3k5dAF=X3_NrYAAp5gPJ_uvF3XfmC4rKz0oGTrGRriCw@mail.gmail.com>
 <OSBPR01MB47732AFC03DA8A0DDF626706BA879@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a2TeeLfsTNkZPnC3YowdOS=bFM5yYj58crP6F5U9Y_r-Q@mail.gmail.com> <OSBPR01MB47739CBDE12E1F3A19649772BA879@OSBPR01MB4773.jpnprd01.prod.outlook.com>
In-Reply-To: <OSBPR01MB47739CBDE12E1F3A19649772BA879@OSBPR01MB4773.jpnprd01.prod.outlook.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Wed, 17 Feb 2021 16:56:09 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2fRgDJZv-vzy_X6Y5t3daaVdCiXtMwkmXUyG0EQZ0a6Q@mail.gmail.com>
Message-ID: <CAK8P3a2fRgDJZv-vzy_X6Y5t3daaVdCiXtMwkmXUyG0EQZ0a6Q@mail.gmail.com>
Subject: Re: [PATCH net-next] misc: Add Renesas Synchronization Management
 Unit (SMU) support
To:     Min Li <min.li.xe@renesas.com>
Cc:     Derek Kiernan <derek.kiernan@xilinx.com>,
        Dragan Cvetic <dragan.cvetic@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>,
        gregkh <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 11:14 PM Min Li <min.li.xe@renesas.com> wrote:
> > I can't help but think you are evading my question I asked. If there is no
> > specific action that this pcm4l tool needs to perform, then I'd think we
> > should better not provide any interface for it at all.
> >
> > I also found a reference to only closed source software at
> > https://www.renesas.com/us/en/software-tool/ptp-clock-manager-linux
> > We don't add low-level interfaces to the kernel that are only usable by
> > closed-source software.
> >
> > Once you are able to describe the requirements for what pcm4l actually
> > needs from the hardware, we can start discussing what a high-level
> > interface would look like that can be used to replace the your current
> > interface, in a way that would work across vendors and with both pcm4l and
> > open-source tools that do the same job.
>
> This driver is used by pcm4l to access functionalities that cannot be accessed through PHC(ptp hardware clock) interface.
>
> All these functions are kind of specific to Renesas SMU device and I have never heard other devices offering similar functions
>
> The 3 functions currently provided are (more to be added in the future)
>
> - set combomode
>
> In Telecom Boundary Clock (T-BC) and Telecom Time Slave Clock (T-TSC) applications
> per ITU-T G.8275.2, two DPLLs can be used:
> one DPLL is configured as a DCO to synthesize PTP clocks, and the other DPLL is
> configured as an EEC(Ethernet Equipment Clock) to generate physical layer clocks.
> Combo mode provides physical layer frequency support from the EEC/SEC to the PTP
> clock.

Thank you for the explanation. Now, to take the question to an even
higher level, is it useful to leave it up to the user to pick one of the two
modes explicitly, or can the kernel make that decision based on some
other information that it already has, or that can be supplied to it
using a more abstract interface?

In other words, when would a user pick combomode over non-combomode
or vice versa? Would it make sense to have this configured according to
the hardware platform, e.g. in a device tree property of the device, rather
than having the user choose a mode?

Which of the two possible modes do other PTP devices use that support
DCO and EEC but are not configurable?

> - read DPLL's FFO
>
> Read fractional frequency offset (FFO) from a DPLL.
>
> For a DPLL channel, a Frequency Control Word (FCW) is used to adjust the
> frequency output of the DCO. A positive value will increase the output frequency
> and a negative one will decrease the output frequency.
>
> This function will read FCW first and convert it to FFO.

Is this related to the information in the timex->freq field? It sounds
like this would already be accessible through the existing
clock_adjtime() interface.

> -read DPLL's state
>
> The DPLLs support four primary operating modes: Free-Run, Locked,
> Holdover, and DCO. In Free-Run mode the DPLLs synthesize clocks
>  based on the system clock alone. In Locked mode the DPLLs filter
> reference clock jitter with the selected bandwidth. Additionally in
> Locked mode, the long-term output frequency accuracy is the same
> as the long-term frequency accuracy of the selected input reference.
> In Holdover mode, the DPLL uses frequency data acquired while in
> Locked mode to generate accurate frequencies when input
> references are not available. In DCO mode, the DPLL control loop
> is opened and the DCO can be controlled by a PTP clock recovery
> servo running on an external processor to synthesize PTP clocks.

Wouldn't any PTP clock run in one of these modes? If this is just
informational, it might be appropriate to have another sysfs attribute
for each PTP clock that shows the state of the DPLL, and then
have the PTP driver either fill in the current value in 'struct ptp_clock',
or provide a callback to report the state when a user reads the sysfs
attribute.

      Arnd
