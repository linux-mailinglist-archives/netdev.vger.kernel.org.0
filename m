Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7953CBFDD
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 01:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbhGPXvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 19:51:06 -0400
Received: from angie.orcam.me.uk ([78.133.224.34]:60742 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbhGPXvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 19:51:05 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id F301E92009C; Sat, 17 Jul 2021 01:48:07 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id E464292009B;
        Sat, 17 Jul 2021 01:48:07 +0200 (CEST)
Date:   Sat, 17 Jul 2021 01:48:07 +0200 (CEST)
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
In-Reply-To: <60EFE489.40502@gmail.com>
Message-ID: <alpine.DEB.2.21.2107170045440.9461@angie.orcam.me.uk>
References: <60B24AC2.9050505@gmail.com> <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com> <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com> <60B65BBB.2040507@gmail.com> <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com>
 <alpine.DEB.2.21.2106032014320.2979@angie.orcam.me.uk> <CAK8P3a0oLiBD+zjmBxsrHxdMeYSeNhg6fhC+VPV8TAf9wbauSg@mail.gmail.com> <877dipgyrb.ffs@nanos.tec.linutronix.de> <alpine.DEB.2.21.2106200749300.61140@angie.orcam.me.uk> <CAK8P3a0Z56XvLHJHjvsX3F76ZF0n-VXwPoWbvfQdTgfEBfOneg@mail.gmail.com>
 <60D1DAC1.9060200@gmail.com> <CAK8P3a1XaTUgxM3YBa=iHGrLX_Wn66NhTTEXtV=vaNre7K3GOA@mail.gmail.com> <60D22F1D.1000205@gmail.com> <CAK8P3a3Jk+zNnQ5r9gb60deqCmJT+S07VvL3SipKRYXdxM2kPQ@mail.gmail.com> <alpine.DEB.2.21.2106230244460.37803@angie.orcam.me.uk>
 <60D4C75C.30701@gmail.com> <alpine.DEB.2.21.2106242013340.37803@angie.orcam.me.uk> <alpine.DEB.2.21.2107150042560.9461@angie.orcam.me.uk> <60EFE489.40502@gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Nikolai,

> >   I have actually tracked a datasheet down now, so I'll see what I can do.
> > The southbridge has a separate edge/level trigger mode control register
> > for PIRQ lines in addition to the usual ELCR register, so it will require
> > extra handling and the wording is not as clear as with Intel documentation
> > (understandably), so it may require further experimentation.
> 
> Thank you very much for investigating this! Tomorrow I'll likely be able 
> to pull this motherboard out and arrange it for whatever testing might 
> be necessary. However I'll be in a trip for a couple of weeks soon so 
> please excuse some possible delay in my replies. I'm definitely willing 
> to make all efforts to get it supported.

 I have preliminary code ready for submission, so I only need to wrap it 
up for posting.  However it requires some additional infrastructure shared 
with other parts of the kernel, so it will be a small patch series again, 
and due to code dependencies I'll include support for another PIRQ router 
as well as some clean-ups, because they all need to be applied in order.  
With that in place we should have complete coverage for Intel chipsets.

 Moreover based on the ALi M1533 datasheet I have also tracked down I have 
noticed we have bugs in the handling for the other ALi chipsets, which I 
seem unable to satisfactorily resolve without a copy of the ALi M1563 
datasheet I don't have.  I've noticed Nvidia does continue having at least 
some ALi-related stuff online, so chances are they have retained the ALi 
legacy internally.  I have therefore requested a copy of the M1563 
datasheet and will likely extend the patch series accordingly, whether I 
do or do not receive the document.

 Stay tuned.

  Maciej
