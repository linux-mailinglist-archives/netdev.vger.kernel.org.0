Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A613B1E8C
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 18:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhFWQXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 12:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFWQXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 12:23:23 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4569DC061574
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 09:21:04 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id r5so5095699lfr.5
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 09:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-transfer-encoding;
        bh=dtQMs/e3dyJqCEZr8lIONXDOdaz9ORs5NcPMJLB1K/k=;
        b=s7BoWm4WeId1KqfshPLT1jR0/8o25eQNCWpKq/bigUmx8IpVuVxwPD2IY9JZFnUPyF
         ulEgsC88bdPW8jBTcg/udgMQ5OAdZsOQqdY6iYqvaXJ4vEKPgoqE/pxd/OwxI9EQ9qmX
         rNteeUpHVy8GGPPrWWRht+SPJLkEAMPyShqH/OfS8K+cszv63KF60k4zC1G6qmaUkCj8
         xsZSLDdE0nwgORXnmUzZRW1h8wusFvBM7TFOQLDXc8GdfF51xSSULceOt9IDOgBPF9Mh
         wTuiH9voMFGLfxFfgRaEJYaY0JsQTkpke9ioU4C0HyLITZtTEOEIBzmcvVGmWe14Ytsi
         zNzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-transfer-encoding;
        bh=dtQMs/e3dyJqCEZr8lIONXDOdaz9ORs5NcPMJLB1K/k=;
        b=aw4g7yIpACiYEeq9LDdcE95gsnX5xinozcoTIfJFSNqv6uAOY07jcAnDR2+P4KJmkj
         /4nTT0j19qXIFi3NqOs7GveO5DXAXbIu6fpPrmI38B+0JLD46eX7H0M4LCH/sUp5YlF6
         K9Kyumudwn3NPVZuvmO3Qr9O2yIz/Moj0mvF/fD9bRpxzLI7fpPGfb9uh18u+Lz8rRUL
         K548n9wum7urWluQVoETxYFTTbVS+TqpvwNzORan6pSpqXSF2t/NdJPMlvOogTIY5Ag5
         fM9oGrUXsjliuG8CeBGAxVes2nJXSo0bwHTGV7HIOCAJYekgUxf7mnpcOavLZJEaZn4u
         L4BA==
X-Gm-Message-State: AOAM532+vG6cQSxp/avFjUErDxzTo3Y79W5JLTTnb/WAdlOwaBWn8Rp1
        Z5gDGXCvtalQ1YxPQKXcLoQ=
X-Google-Smtp-Source: ABdhPJxvVS0K7yen95yVyGLsv/ahnzE3r/3vMhwqzF11L3Gz5xX3qLcAfVUm0CgA5WPoNUaOru7irg==
X-Received: by 2002:a19:7d04:: with SMTP id y4mr287755lfc.201.1624465260771;
        Wed, 23 Jun 2021 09:21:00 -0700 (PDT)
Received: from [192.168.0.91] ([188.242.181.97])
        by smtp.googlemail.com with ESMTPSA id z26sm40217lfi.7.2021.06.23.09.20.59
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Wed, 23 Jun 2021 09:21:00 -0700 (PDT)
Message-ID: <60D361FF.70905@gmail.com>
Date:   Wed, 23 Jun 2021 19:31:59 +0300
From:   Nikolai Zhubr <zhubr.2@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To:     Arnd Bergmann <arnd@kernel.org>
CC:     "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Realtek 8139 problem on 486.
References: <60B24AC2.9050505@gmail.com> <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com> <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com> <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com> <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com> <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com> <60B65BBB.2040507@gmail.com> <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com> <alpine.DEB.2.21.2106032014320.2979@angie.orcam.me.uk> <CAK8P3a0oLiBD+zjmBxsrHxdMeYSeNhg6fhC+VPV8TAf9wbauSg@mail.gmail.com> <877dipgyrb.ffs@nanos.tec.linutronix.de> <alpine.DEB.2.21.2106200749300.61140@angie.orcam.me.uk> <CAK8P3a0Z56XvLHJHjvsX3F76ZF0n-VXwPoWbvfQdTgfEBfOneg@mail.gmail.com> <60D1DAC1.9060200@gmail.com> <CAK8P3a1XaTUgxM3YBa=iHGrLX_Wn66NhTTEXtV=vaNre7K3GOA@mail.gmail.com> <60D22F1D.1000205@gmail.com> <CAK8P3a3Jk+zNnQ5r9gb60deqCmJT+S07VvL3SipKRYXdxM2kPQ@mail.gmail.com>
In-Reply-To: <CAK8P3a3Jk+zNnQ5r9gb60deqCmJT+S07VvL3SipKRYXdxM2kPQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

22.06.2021 22:26, Arnd Bergmann:
[...]
> As I said before, I still think we should also merge the 8139 driver patch,
> probably without that loop. It's not great, but I'm much more confident
> I understand what that does and that the patched version is better than
> the current code.

Yes, the 'poll' approach apparently works stable and does not cause any 
measurable performance decrease. But it would need some carefull 
cleanup/review, especially WRT locking. Now that all real event handling 
work is happening in the poll function, it still has to be protected 
against the (potentially also long-running) reset function which in 
current design can be called e.g. from a different thread due to tx 
timeout, and this does not look good, but it is a bit beyond my 
capability to arrange it better. Besides, the idea was to keep the fix 
simple and avoid a massive rework...


Thank you,

Regards,
Nikolai


>
>        Arnd
>

