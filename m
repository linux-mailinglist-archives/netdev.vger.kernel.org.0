Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA4F398DCE
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 17:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbhFBPGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 11:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbhFBPGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 11:06:09 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23094C061574
        for <netdev@vger.kernel.org>; Wed,  2 Jun 2021 08:04:18 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id 131so3016002ljj.3
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 08:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-transfer-encoding;
        bh=9ij1rLKcb66TqcGsHaACAAhCtKGL8BLekxoiNL+rtkA=;
        b=bRd0sBX06RafIbCnimO3ZsuDcTEldblYPa76FFbR3qZ0UncMDNdUqKBHd8C07T0VG1
         9KSrE8XGfrKc2SOs0E86F7JiJVgv7nNeB1JkToY3Vv0L29yGlsPycQBtL5wFOV/3Xf7h
         V7vaWigtIfFNGtK+w4q1jpYTkktY8/+HlmTaiNhmDG9x3l7kqcUaUyUsX3iDWUh/jals
         QTFhthd2faalLj4cDvJ0HM664tfZYAdM8jj4DrCpUi+iQ+Nk/odpLuChvDiobSuvWfqs
         KhNHK2SDn6HvFdYnbGtRqhjSOfpCJIEVGRv9vahLM0dFSqsa4YWdXTmQGRCdwgVazB5T
         yXNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-transfer-encoding;
        bh=9ij1rLKcb66TqcGsHaACAAhCtKGL8BLekxoiNL+rtkA=;
        b=BqQyEHr0eeKmTuncFkO5+j7iEeCqthIrW+0BICUtwc2pBZUryg0L6hvMGgrIehKKOW
         RRMKhsUwf1tlVUlNOSGKOBeI6TLsw26iEJS81BD0OjeW+sVQq/psRe80cfoDovmWEaMQ
         fXZEVVVnImEzR0j5XHR0XAVKiOqAYSHtsGzwwkfEM7Qnm3VTPQUC1XEM0wyzz/vg0Tby
         jXOI98mx8mkpMM+u6hdxJIlIQnQ3bwymefdT5eCTs2lCHqVoppUB4c6m5nDZz+on/y9l
         1jaIYkwfH1Mf8VGLw8HjiQ9djMcEuPAvsXQdW6jpn99e0iDtvetlRi3EloIQvPe24tzA
         VSuw==
X-Gm-Message-State: AOAM530bG59XTYHkhDBFwvfeweainHrpaveJAugxjCVhgtrN8Hlx55ys
        UIQas5JM1/M+B7MoFyCfQvo=
X-Google-Smtp-Source: ABdhPJye4aclZAjpXkDPkhevwA3QuQjPy6VJxyBiGwl8L7vNKtg+BQr7sNvmS/qOr34mlqUd9JTYjg==
X-Received: by 2002:a2e:9c4a:: with SMTP id t10mr26298893ljj.307.1622646256323;
        Wed, 02 Jun 2021 08:04:16 -0700 (PDT)
Received: from [192.168.0.91] ([188.242.181.97])
        by smtp.googlemail.com with ESMTPSA id 76sm7758ljj.32.2021.06.02.08.04.15
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Wed, 02 Jun 2021 08:04:15 -0700 (PDT)
Message-ID: <60B7A05D.3070704@gmail.com>
Date:   Wed, 02 Jun 2021 18:14:37 +0300
From:   Nikolai Zhubr <zhubr.2@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
CC:     Heiner Kallweit <hkallweit1@gmail.com>,
        Arnd Bergmann <arnd@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: Realtek 8139 problem on 486.
References: <60B24AC2.9050505@gmail.com> <ca333156-f839-9850-6e3d-696d7b725b09@gmail.com> <CAP8WD_bKiGLczUfRVOWY3y4TT80yhRCPmLkN7pDMhkJ5m=2Pew@mail.gmail.com> <60B2E0FF.4030705@gmail.com> <60B36A9A.4010806@gmail.com> <60B3CAF8.90902@gmail.com> <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com> <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com> <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com> <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com> <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com> <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com> <alpine.DEB.2.21.2106011918390.11113@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2106011918390.11113@angie.orcam.me.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

01.06.2021 20:44, Maciej W. Rozycki:
[...]
>   You might be able to add a quirk based on your chipset's vendor/device ID
> though, which would call `elcr_set_level_irq' for interrupt lines claimed
> by PCI devices.  You'd have to match on the southbridge's ID I imagine, if
> any (ISTR at least one Intel chipset did not have a southbridge visible on
> PCI), as it's where the 8259A cores along with any ELCR reside.

I'm looking at this comment in arch/x86/kernel/acpi/boot.c:

	/*
	 * Make sure all (legacy) PCI IRQs are set as level-triggered.
	 */

Doesn't it target exactly the case in question? If so, why it does not 
actually work?

By legacy they likely mean non-ACPI IRQs, so for 486 it's just all of 
them. So I'd suppose, if the kernel readily knows a particular IRQ is 
assigned to PCI bus (I'm almost sure it does) shouldn't it already take 
care of proper triggering mode automatically? Because then there would 
be no need to add workarounds to individual drivers.


Thank you,

Regards,
Nikolai

>   It would be the right thing to do IMO; those early PCI systems often got
> these things wrong, and the selection for the trigger mode shouldn't have
> been there in the BIOS setup in the first place (the manufacturer couldn't
> obviously figure it out how to do this correctly by just scanning PCI, so
> they shifted the burden onto the end user; though I have to admit odd hw
> used to be made too, e.g. I remember seeing a PCI PATA option card with an
> extra cable and a tiny PCB stub to be plugged into the upper part of a
> spare ISA slot to get IRQ 14/15 routed from there).
>
>   HTH,
>
>    Maciej
>
