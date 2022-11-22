Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A56DD633121
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 01:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbiKVAKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 19:10:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiKVAJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 19:09:58 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C937DAD478;
        Mon, 21 Nov 2022 16:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=sFTGwuVvO920/q8Vnx2F3klIfO6Ol/GqZd/U+at8KWI=; b=jepW1Eh1qGCCVVpoMggb5VHJhA
        njMojeFvlm7Vmn+NONKVBu1HEuW+5fZLp5Gh98engKl55h5VOYb0V/dPkbzHAD5t2TPBp8tQxPJ3i
        pTAY5Miu8vZxE4rIwbWPzyO2rfkXvZZDxQFx+LCAn71Qj0Ok04JIIVj5l1fk7pzaa75UYOBLURifu
        fsRGxM7fRNyCktFEPSuon/E8R5JonyWuNihHyCQ4V8Ot1dn6AtoRDAgnsRCPcJ/9hUHubT6eJ15nL
        9PBI+jJTUF5El84uOTP2AsPJ8dmGBYOJzYb9dhslEFg4feH3GEAX5SSu5Xm+0TKqzPsdGtbrTAnnk
        WTNOur/g==;
Received: from [2601:1c2:d80:3110::a2e7]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oxGrB-001UTQ-Eh; Tue, 22 Nov 2022 00:09:45 +0000
Message-ID: <6c104724-1095-6307-1dbb-aefbb55dc5b1@infradead.org>
Date:   Mon, 21 Nov 2022 16:09:43 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [patch 06/15] timers: Update kernel-doc for various functions
To:     Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
References: <20221115195802.415956561@linutronix.de>
 <20221115202117.323694948@linutronix.de>
 <20221121154358.36856ca6@gandalf.local.home>
Content-Language: en-US
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20221121154358.36856ca6@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/21/22 12:43, Steven Rostedt wrote:
> On Tue, 15 Nov 2022 21:28:43 +0100 (CET)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
>> The kernel-doc of timer related functions is partially uncomprehensible
>> word salad. Rewrite it to make it useful.
>>
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>> ---
>>  kernel/time/timer.c |  131 ++++++++++++++++++++++++++++++----------------------
>>  1 file changed, 77 insertions(+), 54 deletions(-)
>>
>> --- a/kernel/time/timer.c
>> +++ b/kernel/time/timer.c
>> @@ -1121,14 +1121,16 @@ static inline int
>>  }
>>  
>>  /**
>> - * mod_timer_pending - modify a pending timer's timeout
>> - * @timer: the pending timer to be modified
>> - * @expires: new timeout in jiffies
>> + * mod_timer_pending - Modify a pending timer's timeout
>> + * @timer:	The pending timer to be modified
>> + * @expires:	New timeout in jiffies
>>   *
>> - * mod_timer_pending() is the same for pending timers as mod_timer(),
>> - * but will not re-activate and modify already deleted timers.
>> + * mod_timer_pending() is the same for pending timers as mod_timer(), but
>> + * will not activate inactive timers.
>>   *
>> - * It is useful for unserialized use of timers.
>> + * Return:
>> + * * %0 - The timer was inactive and not modified
>> + * * %1 - The timer was active and requeued to expire at @expires
> 
> I didn't know of the '%' option in kernel-doc.
> 
> Looking it up, I see it's for constants. Although it's missing in the
> examples for return values:
> 
>   Documentation/doc-guide/kernel-doc.rst:
> 
> ```
> Return values
> ~~~~~~~~~~~~~
> 
> The return value, if any, should be described in a dedicated section
> named ``Return``.
> 
> .. note::
> 
>   #) The multi-line descriptive text you provide does *not* recognize
>      line breaks, so if you try to format some text nicely, as in::
> 
>         * Return:
>         * 0 - OK
>         * -EINVAL - invalid argument
>         * -ENOMEM - out of memory
> 
>      this will all run together and produce::
> 
>         Return: 0 - OK -EINVAL - invalid argument -ENOMEM - out of memory
> 
>      So, in order to produce the desired line breaks, you need to use a
>      ReST list, e. g.::
> 
>       * Return:
>       * * 0             - OK to runtime suspend the device
>       * * -EBUSY        - Device should not be runtime suspended
> ```
> 
> Should this be updated?

Sure. Do you want to do it?

-- 
~Randy
