Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECD8519CFAA
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 07:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730898AbgDCFMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 01:12:03 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:56558 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbgDCFMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 01:12:03 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0335BmNs071109;
        Fri, 3 Apr 2020 00:11:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1585890708;
        bh=jofktekZwJmynwAp+73dh/VN6DTrbyAH++7Gc/JbF2c=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=dyRE1GZpuDhhxymx4cHTF/J5WNzncrW1a9rh/0gJcmwGMKWXhQvXZ056vLZNYiOBh
         IU1hnyhT/djvFb7+LGb07eqkOx++BJ99CokPud4r3arsgzE8zKeOU5aTFBPWMsCTBR
         6moFnRAwIx61s/1mT2YeJVkp24XPxaxpUAfmIxMY=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0335Bm4u097176
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 3 Apr 2020 00:11:48 -0500
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 3 Apr
 2020 00:11:48 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 3 Apr 2020 00:11:48 -0500
Received: from [10.24.69.198] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0335Bg4R055217;
        Fri, 3 Apr 2020 00:11:43 -0500
Subject: Re: [PATCH net-next v6 00/11] net: ethernet: ti: add networking
 support for k3 am65x/j721e soc
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
CC:     Will Deacon <will@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>, <devicetree@vger.kernel.org>,
        <kishon@ti.com>, Jakub Kicinski <kuba@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, <m-karicheri2@ti.com>,
        Network Development <netdev@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, <olteanv@gmail.com>,
        <peter.ujfalusi@ti.com>, Rob Herring <robh@kernel.org>,
        <rogerq@ti.com>, <t-kristo@ti.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>
References: <20200401.113627.1377328159361906184.davem@davemloft.net>
 <20200401223500.224253-1-ndesaulniers@google.com>
 <20200402094239.GA3770@willie-the-truck>
 <adc2aa08-60e2-cdc3-6b5b-6d96f8805c44@ti.com>
 <CAKwvOdk4H052Y=t4_XXy=rMV=CUYPNhb5CN6x8-dBTNaTt3aPA@mail.gmail.com>
From:   Sekhar Nori <nsekhar@ti.com>
Message-ID: <818261f1-0075-94ee-f73b-3f72a058999f@ti.com>
Date:   Fri, 3 Apr 2020 10:41:42 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAKwvOdk4H052Y=t4_XXy=rMV=CUYPNhb5CN6x8-dBTNaTt3aPA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/04/20 10:57 PM, Nick Desaulniers wrote:
> On Thu, Apr 2, 2020 at 4:05 AM Grygorii Strashko
> <grygorii.strashko@ti.com> wrote:
>>
>>
>>
>> On 02/04/2020 12:42, Will Deacon wrote:
>>> On Wed, Apr 01, 2020 at 03:35:00PM -0700, Nick Desaulniers wrote:
>>>>>> I think the ARM64 build is now also broken on Linus' master branch,
>>>>>> after the net-next merge? I am not quite sure if the device tree
>>>>>> patches were supposed to land in mainline the way they did.
>>>>>
>>>>> There's a fix in my net tree and it will go to Linus soon.
>>>>>
>>>>> There is no clear policy for dt change integration, and honestly
>>>>> I try to deal with the situation on a case by case basis.
>>>>
>>>> Yep, mainline aarch64-linux-gnu- builds are totally hosed.  DTC fails the build
>>>> very early on:
>>>> https://travis-ci.com/github/ClangBuiltLinux/continuous-integration/jobs/311246218
>>>> https://travis-ci.com/github/ClangBuiltLinux/continuous-integration/jobs/311246270
>>>> There was no failure in -next, not sure how we skipped our canary in the coal
>>>> mine.
>>>
>>> Yes, one of the things linux-next does a really good job at catching is
>>> build breakage so it would've been nice to have seen this there rather
>>> than end up with breakage in Linus' tree :(
>>>
>>> Was the timing just bad, or are we missing DT coverage or something else?
>>
>> It seems issue was not caught in -next because the patch that fixes the issue was already in -next
>> before this series was pushed.
>>
>> Sorry for the mess again.
> 
> No worries, it's just worthwhile to study failures.  So IIUC, in this case:
> mainline was 5.6
> the broken patch was merged in 5.7 merge window
> a fix was already in -next, but not slated for the new merge window.
> (Maybe scheduled for 5.8?)

No, the "fix" is scheduled to go into v5.7 kernel as well. It is here:

git://git.kernel.org/pub/scm/linux/kernel/git/kristo/linux tags/ti-k3-soc-for-v5.7

This is already part of ARM SoC tree, and slated for v5.7

https://git.kernel.org/pub/scm/linux/kernel/git/soc/soc.git/log/?h=arm/dt

Arnd, Olof,

Can you please help by either queuing the arm/dt entirely or just the K3 SoC 
parts to Linus sooner than later?

Thanks,
Sekhar
