Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 985403C998D
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 09:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240329AbhGOHXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 03:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbhGOHXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 03:23:48 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4BFC06175F
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 00:20:55 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id bn5so6955925ljb.10
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 00:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-transfer-encoding;
        bh=zL9UrdEFMnfagAWY1Ed9JOHfHwLnrg2hB2DNBHMz6I8=;
        b=gm2CGVubAChQxfmFd1DQRf7fJc1PvK/fwmbz2Cf4+RlEF6L9m2bfTa/WkawNRyVdo2
         qtFPgH9PAG7DmrXrYNB3hhOPSFvqPU9IHItePxYtJwlt4RxI1ZuKBXDO4IZ0vYEA1Am5
         fZJo5OdD1/QGOVNEwx0C/XmTVgb31HO7+aUN7/53B31KODa3fUi0QaT9GbiiYcYlShuf
         ZbC8UscR5e5XSHE0Vkydwh0HVBlfCm8UrvPqP3U8l0G7KJiQ9E5JDZjJ8hA7QF376Sv+
         WNOqmjKoin1swStQKd5pM1CEKOvX5URe7vAel4kkGMciAEdsz1iroWMzrh+OCnflLXEh
         AApQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-transfer-encoding;
        bh=zL9UrdEFMnfagAWY1Ed9JOHfHwLnrg2hB2DNBHMz6I8=;
        b=NxUTaPUs2FPdx7ACx7xAlFolwppOSHhj7VPU5iKgi7SdsD0kzlBHlx81pe5pOGuhh4
         uJ+HRcEHUw36ad4FaPHm1liLMJEmTuAkHqNA4qWg/bpON3+Tp2O+1JG6CYzOQBd8ApKC
         nLtjSX0CsyT11eVJosJAr0xEOH68rFWbQFeMSidLfhD7bQJHYdBXe2rjkVlqO7E8WhJ9
         9azmQYAczFCJIW+Sf5aVwaG8TkzjBzR9vKmeHNbkl5lSYkHtTcq8ZOWh3X4OaNSjy2CY
         CVMRJT4rk/peFoC2uFTWze4ivpYDvFn/om3KGsyXmOL31p0meboiANsZOK/wkGfg1Mew
         akYA==
X-Gm-Message-State: AOAM532GU66dvDAKI7Sty06ivQU8+vnNHWGI8NA71dfyf1nvNjoK9mu+
        fVYvfPpm1uWqI/5hsya/6gYSpWgRPDPnLA==
X-Google-Smtp-Source: ABdhPJzbumjQuhrp4MfMRC/ihqzoJiUeLSX9YoSPRTTheHNg32JhmUXznorqN9VuhUqQFemaXsU6GA==
X-Received: by 2002:a2e:85d7:: with SMTP id h23mr2616509ljj.329.1626333653739;
        Thu, 15 Jul 2021 00:20:53 -0700 (PDT)
Received: from [192.168.0.91] ([188.242.181.97])
        by smtp.googlemail.com with ESMTPSA id t12sm339600lfg.148.2021.07.15.00.20.52
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Thu, 15 Jul 2021 00:20:53 -0700 (PDT)
Message-ID: <60EFE489.40502@gmail.com>
Date:   Thu, 15 Jul 2021 10:32:25 +0300
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
References: <60B24AC2.9050505@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com> <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com> <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com> <60B65BBB.2040507@gmail.com> <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com> <alpine.DEB.2.21.2106032014320.2979@angie.orcam.me.uk> <CAK8P3a0oLiBD+zjmBxsrHxdMeYSeNhg6fhC+VPV8TAf9wbauSg@mail.gmail.com> <877dipgyrb.ffs@nanos.tec.linutronix.de> <alpine.DEB.2.21.2106200749300.61140@angie.orcam.me.uk> <CAK8P3a0Z56XvLHJHjvsX3F76ZF0n-VXwPoWbvfQdTgfEBfOneg@mail.gmail.com> <60D1DAC1.9060200@gmail.com> <CAK8P3a1XaTUgxM3YBa=iHGrLX_Wn66NhTTEXtV=vaNre7K3GOA@mail.gmail.com> <60D22F1D.1000205@gmail.com> <CAK8P3a3Jk+zNnQ5r9gb60deqCmJT+S07VvL3SipKRYXdxM2kPQ@mail.gmail.com> <alpine.DEB.2.21.2106230244460.37803@angie.orcam.me.uk> <60D4C75C.30701@gmail.com> <alpine.DEB.2.21.2106242013340.37803@angie.orcam.me.uk> <alpine.DEB.2.21.2107150042560.9461@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2107150042560.9461@angie.orcam.me.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Maciej,

15.07.2021 2:32, Maciej W. Rozycki:
>>   Anyway, this the ALi M1489/M1487 chipset and no datasheet is easily
>> available (perhaps Nvidia, which bought the chipset part of ALi back in
>> 2006, has a copy, but I wouldn't bet on it).  A product brief is available
>> that says the chipset supports PCI steering, but we can only guess how it
>> works.
>
>   I have actually tracked a datasheet down now, so I'll see what I can do.
> The southbridge has a separate edge/level trigger mode control register
> for PIRQ lines in addition to the usual ELCR register, so it will require
> extra handling and the wording is not as clear as with Intel documentation
> (understandably), so it may require further experimentation.

Thank you very much for investigating this! Tomorrow I'll likely be able 
to pull this motherboard out and arrange it for whatever testing might 
be necessary. However I'll be in a trip for a couple of weeks soon so 
please excuse some possible delay in my replies. I'm definitely willing 
to make all efforts to get it supported.


Regards,
Nikolai


>
>    Maciej
>

