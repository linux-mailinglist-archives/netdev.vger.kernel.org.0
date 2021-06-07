Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9288C39D2AF
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 03:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhFGBpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 21:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbhFGBpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 21:45:23 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1051AC061766;
        Sun,  6 Jun 2021 18:43:33 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Fyx3P4ngMz9s1l;
        Mon,  7 Jun 2021 11:43:29 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1623030210;
        bh=FPR7ExVACiu4J+7LLh/Oh6D3FGm5nnJ0+HrdvUx8z6w=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=hDY5h37A1YZT6orGetPUzskyKgpBxev4EUFkEkTf0PqJeFYu98qyvjlBUuOOOGHTa
         nRfLqrla3XWtpk4bffBFELKazKURK92xytEtykmQQqgLrR0yPC3rCqfFnKlt4OTnKC
         +YVoLMJOmZJzJ/OIbOW+39mEXqLpDooK7E5HseQrEuULON9Reg+aooTO0JYMruQ7aF
         U9QjsR41EnrdEQPHuFydRjX7RmbaClurrJbaXh180Q+QyPPdWENnrcS+vXlT/FYoB5
         uFz/7xtECDJ5Gmwsv4PNW3r8SvRmmWFJZWtKaxl4+R6N+jhOeCkwpmcxj/31yOzhTp
         2ukahEiZIlT5A==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Guenter Roeck <linux@roeck-us.net>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-watchdog@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] watchdog: Remove MV64x60 watchdog driver
In-Reply-To: <e2a33fc1-f519-653d-9230-b06506b961c5@roeck-us.net>
References: <9c2952bcfaec3b1789909eaa36bbce2afbfab7ab.1616085654.git.christophe.leroy@csgroup.eu>
 <31d702e5-22d1-1766-76dd-e24860e5b1a4@roeck-us.net>
 <87im3hk3t2.fsf@mpe.ellerman.id.au>
 <e2a33fc1-f519-653d-9230-b06506b961c5@roeck-us.net>
Date:   Mon, 07 Jun 2021 11:43:26 +1000
Message-ID: <87czsyfo01.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Guenter Roeck <linux@roeck-us.net> writes:
> On 5/17/21 4:17 AM, Michael Ellerman wrote:
>> Guenter Roeck <linux@roeck-us.net> writes:
>>> On 3/18/21 10:25 AM, Christophe Leroy wrote:
>>>> Commit 92c8c16f3457 ("powerpc/embedded6xx: Remove C2K board support")
>>>> removed the last selector of CONFIG_MV64X60.
>>>>
>>>> Therefore CONFIG_MV64X60_WDT cannot be selected anymore and
>>>> can be removed.
>>>>
>>>> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
>>>
>>> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
>>>
>>>> ---
>>>>   drivers/watchdog/Kconfig       |   4 -
>>>>   drivers/watchdog/Makefile      |   1 -
>>>>   drivers/watchdog/mv64x60_wdt.c | 324 ---------------------------------
>>>>   include/linux/mv643xx.h        |   8 -
>>>>   4 files changed, 337 deletions(-)
>>>>   delete mode 100644 drivers/watchdog/mv64x60_wdt.c
>> 
>> I assumed this would go via the watchdog tree, but seems like I
>> misinterpreted.
>> 
>
> Wim didn't send a pull request this time around.
>
> Guenter
>
>> Should I take this via the powerpc tree for v5.14 ?

I still don't see this in the watchdog tree, should I take it?

cheers
