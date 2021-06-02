Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7E7398E98
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 17:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbhFBPcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 11:32:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:43510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230479AbhFBPcU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 11:32:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACA7E613B8
        for <netdev@vger.kernel.org>; Wed,  2 Jun 2021 15:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622647837;
        bh=28HQy4xdxQQRM7g2BkxGS7VtKj/3w4+HWrOnVjwVp0A=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=pQNzTEiGaHzTHEGNRKFw/1dDPX5z2+0+0q3utkkOxMhnF8uTZI/GkmAdm4S9xY9wH
         ziGyIMCMWO6uUWdQBtSdkNZuZKHVjPdxCGK8wxULozvTCwFAXrczo/7MCuU1HW6yka
         NEjOn0DTSP1ZtZSsNbb4ceIqG8rGUz3veZ2OytMsWccDwc9R8v10pEB0UD7jWBCkaE
         wAYmdVMu3seFQJi5PHoUyQRunJ1MdaOC4ezCz8RcukRg5PqV/90NIUCZebgFRiolaC
         NG/et2kZ2M81vZTFwiDngQt1ETvqsIZ584Iw0Hv18o0hfdfH2HdMQoMMGQKurQUPcD
         6jE3dtl+0GyHw==
Received: by mail-wm1-f43.google.com with SMTP id g204so1563622wmf.5
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 08:30:37 -0700 (PDT)
X-Gm-Message-State: AOAM533y1qPcqSkEU4lUR7bip4Hwx21+V5AjanMCMqQMjWywRsy2z1bv
        SHQ4xfqzzVRSIJHygceQEYdjWx+9JUAoesQwgJA=
X-Google-Smtp-Source: ABdhPJzSlVwkZXmOwUSMkDRCz7ktO6Lav1wYTvmIj1PJMGtsDw89BLKKDYazqKaBzhkRHZysUUZVKgURMRDNu/sweSk=
X-Received: by 2002:a1c:7210:: with SMTP id n16mr5563003wmc.75.1622647836372;
 Wed, 02 Jun 2021 08:30:36 -0700 (PDT)
MIME-Version: 1.0
References: <60B24AC2.9050505@gmail.com> <ca333156-f839-9850-6e3d-696d7b725b09@gmail.com>
 <CAP8WD_bKiGLczUfRVOWY3y4TT80yhRCPmLkN7pDMhkJ5m=2Pew@mail.gmail.com>
 <60B2E0FF.4030705@gmail.com> <60B36A9A.4010806@gmail.com> <60B3CAF8.90902@gmail.com>
 <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com>
 <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com> <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com>
 <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com>
 <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com>
 <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com>
 <alpine.DEB.2.21.2106011918390.11113@angie.orcam.me.uk> <60B7A05D.3070704@gmail.com>
In-Reply-To: <60B7A05D.3070704@gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Wed, 2 Jun 2021 17:28:56 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0h4jaTdg9CmjQKNK+YniThmp4JyNbSdNJMEBj4czHGdg@mail.gmail.com>
Message-ID: <CAK8P3a0h4jaTdg9CmjQKNK+YniThmp4JyNbSdNJMEBj4czHGdg@mail.gmail.com>
Subject: Re: Realtek 8139 problem on 486.
To:     Nikolai Zhubr <zhubr.2@gmail.com>
Cc:     "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 2, 2021 at 5:14 PM Nikolai Zhubr <zhubr.2@gmail.com> wrote:
>
> Hi all,
>
> 01.06.2021 20:44, Maciej W. Rozycki:
> [...]
> >   You might be able to add a quirk based on your chipset's vendor/device ID
> > though, which would call `elcr_set_level_irq' for interrupt lines claimed
> > by PCI devices.  You'd have to match on the southbridge's ID I imagine, if
> > any (ISTR at least one Intel chipset did not have a southbridge visible on
> > PCI), as it's where the 8259A cores along with any ELCR reside.
>
> I'm looking at this comment in arch/x86/kernel/acpi/boot.c:
>
>         /*
>          * Make sure all (legacy) PCI IRQs are set as level-triggered.
>          */
>
> Doesn't it target exactly the case in question? If so, why it does not
> actually work?
>
> By legacy they likely mean non-ACPI IRQs, so for 486 it's just all of
> them.

I think this means non-MSI interrupts

> So I'd suppose, if the kernel readily knows a particular IRQ is
> assigned to PCI bus (I'm almost sure it does) shouldn't it already take
> care of proper triggering mode automatically? Because then there would
> be no need to add workarounds to individual drivers.

Without ACPI, this code is never called, instead of acpi_pci_irq_enable(),
you use pirq_enable_irq()/pcibios_lookup_irq(). There are already
some hardware specific quirks in there, it's possible this could be
changed to address your case as well, but it already looks a bit fragile.

       Arnd
