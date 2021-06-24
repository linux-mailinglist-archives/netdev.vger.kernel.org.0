Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC8293B34F6
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 19:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbhFXRsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 13:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbhFXRsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 13:48:06 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB0FC061574
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 10:45:45 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id u13so11735522lfk.2
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 10:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-transfer-encoding;
        bh=UT2KpUi2z1pe34o22xQyCXWKBky3hcJiip6CrlGj7L0=;
        b=S848uJAtlJOM9cCvyn/OjGV7O6gNwqxzVRlXt5Qkkls+nQgPDeNTF0Bmg7J72pvDks
         Mb/GQiE9MUpIPjffqdC1orFKF1pvw+HHlms+WZ5iTEve+C36IlRdd919i6a5BmSxhqAY
         vgYRmhZcuKFB1T/Dea3LsA3esDy8b6r80AbQ01vpmhy9D2nFPWfPc9njYQqZN3nnisdp
         quid+hIgKNex4772u72ycDz4ZamL03upLQIvjQj6URayZJ5Aa2He36EVo2RwqwwBxCCy
         ZOay5Nu1uX+FEiLWL/ljJA80vp6AxyIBErO/7VYIt11GnvYIPvCkYgau0teZXbrRgiez
         n1/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-transfer-encoding;
        bh=UT2KpUi2z1pe34o22xQyCXWKBky3hcJiip6CrlGj7L0=;
        b=C2ATZVfHI9OkE/eE+oaW5ICDUmShG/uXBv3Ds1ClJjhnQyzMlwQJLkb80EG+AFp/H/
         2AUj2+bVAmxf8IcFCmfzSgf1d2L/TUuQS0CNLtMTLhl0gCJK5bhWBOMZIS4AD4l+5D01
         p4v5zprpKrvpxWYrRq0ZW1+ALPZMAgMSD2ZQJY5stio0HhnJoCZ3qIvMPyWlsmCVeBWr
         wV9hcPV6ZFpzp81b2QnsxrS0tm3FOuVpnecdO09XF7361VrDL9Mn2esSxVlazDYqjSU8
         kx6RaWkwFjfXYJaP4WM5aMsSzUYzWEvk66QzBhte4WrFYsIh797juZckPJf/EaN+10cm
         uBRw==
X-Gm-Message-State: AOAM5302ly+8noJ0do33T0LizFR2t01xGXg7tHS5Uw8GnuuB12so7tku
        3UkXwqRtlDNt9Qrh3tYxyuk=
X-Google-Smtp-Source: ABdhPJy1CJ63OQRr9aHPxCUrsZqgqt5mF6jHarWiVUEx6Gprj0+vkTd684ozzz42GXTLHeFS1zMNBg==
X-Received: by 2002:ac2:4206:: with SMTP id y6mr4721337lfh.206.1624556743967;
        Thu, 24 Jun 2021 10:45:43 -0700 (PDT)
Received: from [192.168.0.91] ([188.242.181.97])
        by smtp.googlemail.com with ESMTPSA id u3sm185554ljk.32.2021.06.24.10.45.43
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Thu, 24 Jun 2021 10:45:43 -0700 (PDT)
Message-ID: <60D4C75C.30701@gmail.com>
Date:   Thu, 24 Jun 2021 20:56:44 +0300
From:   Nikolai Zhubr <zhubr.2@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
CC:     Arnd Bergmann <arnd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Realtek 8139 problem on 486.
References: <60B24AC2.9050505@gmail.com> <60B514A0.1020701@gmail.com> <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com> <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com> <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com> <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com> <60B65BBB.2040507@gmail.com> <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com> <alpine.DEB.2.21.2106032014320.2979@angie.orcam.me.uk> <CAK8P3a0oLiBD+zjmBxsrHxdMeYSeNhg6fhC+VPV8TAf9wbauSg@mail.gmail.com> <877dipgyrb.ffs@nanos.tec.linutronix.de> <alpine.DEB.2.21.2106200749300.61140@angie.orcam.me.uk> <CAK8P3a0Z56XvLHJHjvsX3F76ZF0n-VXwPoWbvfQdTgfEBfOneg@mail.gmail.com> <60D1DAC1.9060200@gmail.com> <CAK8P3a1XaTUgxM3YBa=iHGrLX_Wn66NhTTEXtV=vaNre7K3GOA@mail.gmail.com> <60D22F1D.1000205@gmail.com> <CAK8P3a3Jk+zNnQ5r9gb60deqCmJT+S07VvL3SipKRYXdxM2kPQ@mail.gmail.com> <alpine.DEB.2.21.2106230244460.37803@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2106230244460.37803@angie.orcam.me.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maciej,

23.06.2021 4:04, Maciej W. Rozycki:
[...]
>   Ah, so this is the SiS 85C496/497 chipset; another one that does not have
> its southbridge visible in the PCI configuration space, perhaps because it
> doesn't put the southbridge on PCI in the first place, and instead it maps
> its configuration registers in the upper half of the northbridge's space.
> Oh, the joys of early attempts!

I see your patches for this chipset have now arrived and I'll test them 
as soon as I get to that box.
Meanwhile I've captured a similar log from another (and actually this 
one is my main concern because it can not be replaced easily):

https://pastebin.com/NVfRcMww

Something is clearly different here, 8259A.pl reports all irqs are edge 
no matter what. BIOS setup only offers some strange "PCI IDE IRQ mode" 
(Edge/Level) and apparently it has no effect anyway.
(A modified version of 8139too works fine though)


Thank you,

Regards,
Nikolai

>   It does PCI interrupt steering, it has the ELCR, but we don't have a PIRQ
> router implemented for it.  I have a datasheet, so this should be fairly
> trivial to do, and hopefully things will then work automagically, no need
> for hacks.
>
>   It's very late tonight here, so let me come back with something tomorrow.
>
>    Maciej
>

