Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D03973C948A
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 01:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237699AbhGNXfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 19:35:07 -0400
Received: from angie.orcam.me.uk ([78.133.224.34]:60636 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbhGNXfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 19:35:06 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 7093E92009C; Thu, 15 Jul 2021 01:32:10 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 6919192009B;
        Thu, 15 Jul 2021 01:32:10 +0200 (CEST)
Date:   Thu, 15 Jul 2021 01:32:10 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Nikolai Zhubr <zhubr.2@gmail.com>
cc:     Arnd Bergmann <arnd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Realtek 8139 problem on 486.
In-Reply-To: <alpine.DEB.2.21.2106242013340.37803@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2107150042560.9461@angie.orcam.me.uk>
References: <60B24AC2.9050505@gmail.com> <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com> <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com> <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com>
 <60B65BBB.2040507@gmail.com> <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com> <alpine.DEB.2.21.2106032014320.2979@angie.orcam.me.uk> <CAK8P3a0oLiBD+zjmBxsrHxdMeYSeNhg6fhC+VPV8TAf9wbauSg@mail.gmail.com> <877dipgyrb.ffs@nanos.tec.linutronix.de>
 <alpine.DEB.2.21.2106200749300.61140@angie.orcam.me.uk> <CAK8P3a0Z56XvLHJHjvsX3F76ZF0n-VXwPoWbvfQdTgfEBfOneg@mail.gmail.com> <60D1DAC1.9060200@gmail.com> <CAK8P3a1XaTUgxM3YBa=iHGrLX_Wn66NhTTEXtV=vaNre7K3GOA@mail.gmail.com> <60D22F1D.1000205@gmail.com>
 <CAK8P3a3Jk+zNnQ5r9gb60deqCmJT+S07VvL3SipKRYXdxM2kPQ@mail.gmail.com> <alpine.DEB.2.21.2106230244460.37803@angie.orcam.me.uk> <60D4C75C.30701@gmail.com> <alpine.DEB.2.21.2106242013340.37803@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Jun 2021, Maciej W. Rozycki wrote:

>  Anyway, this the ALi M1489/M1487 chipset and no datasheet is easily 
> available (perhaps Nvidia, which bought the chipset part of ALi back in 
> 2006, has a copy, but I wouldn't bet on it).  A product brief is available 
> that says the chipset supports PCI steering, but we can only guess how it 
> works.

 I have actually tracked a datasheet down now, so I'll see what I can do.  
The southbridge has a separate edge/level trigger mode control register 
for PIRQ lines in addition to the usual ELCR register, so it will require 
extra handling and the wording is not as clear as with Intel documentation 
(understandably), so it may require further experimentation.

  Maciej
