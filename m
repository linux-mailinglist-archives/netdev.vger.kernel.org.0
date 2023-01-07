Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFBB2660B92
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 02:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236354AbjAGBmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 20:42:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjAGBmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 20:42:49 -0500
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87DC1848CB;
        Fri,  6 Jan 2023 17:42:47 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id 0B2CD604F1;
        Sat,  7 Jan 2023 02:42:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1673055766; bh=MPp03RqFDDII3pCxtM5zY007hKOOyd2B13p3wePRZJc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=sMTZqWtoMERYQ9T5OH8Ogmqf3oUwJqtnqnhvj5YhgAGif1v3v+V86Q3e4dgklrHn6
         9ux9zSQM3JaQgzUDvwgowOaFYWPwNpI7i1SfpQPiu3IVciVcQI5cDhaLgOdEQX+5p7
         HH/G02np9lHHrJxR1Dxy85v5rJ3xm07cJQp4pXPRfeeNXY77+Rl+C9AOMMougkzz9n
         Fh7blIASQJwhavKY281V/omQj7BV80373fD2PKHYMpYVZg8DfAd0EDtotmK91Byh78
         p8mkFf529BMiSivm01BFcxYDVpBB2oy/NswYWocWFkWYxuOs24Uak+Oy7nZZzdR6IP
         N25cUyWmJ2DiQ==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 6pKu9zfMkWMh; Sat,  7 Jan 2023 02:42:43 +0100 (CET)
Received: from [192.168.0.12] (unknown [188.252.196.35])
        by domac.alu.hr (Postfix) with ESMTPSA id 977FA604F0;
        Sat,  7 Jan 2023 02:42:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1673055763; bh=MPp03RqFDDII3pCxtM5zY007hKOOyd2B13p3wePRZJc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ZOXL44W8XCvgvcmBpDdiadLc+g5dzvw+A34JgUHNnblAr1eOU+1NHjpZRSYJgLxqV
         ulFAmGcrurQOaBmL7cYjC8BT6Y7mUiggyRoil8a6K9zcwvvDAVcYoVTFeYXfNx07kf
         52d60jW8YSy7Fxu3Zy0/T5fM4kQYgwQQt326JqdULcMIKChXx6zbXMxEhQspfufije
         eG6UJCqh0hKj/wYcP4MomKmNfSXLzvS/6MapRdPgaUyE0FJZ3x4WIJvbaBtDWmGJg5
         d05V905aAUwbtoQx/BVT6Uqt7wj5UYxu7z6eUHrMf/a9xlhGH34hZdIHchqdvLyGlU
         nTXfy3AHWi3fw==
Message-ID: <8fb1a2c5-ee35-67eb-ef3c-e2673061850d@alu.unizg.hr>
Date:   Sat, 7 Jan 2023 02:42:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net v2] af_unix: selftest: Fix the size of the parameter
 to connect()
Content-Language: en-US, hr
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kuniyuki Iwashima <kuniyu@amazon.com>, davem@davemloft.net,
        edumazet@google.com, fw@strlen.de, kuniyu@amazon.co.jp,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, shuah@kernel.org
References: <bd7ff00a-6892-fd56-b3ca-4b3feb6121d8@alu.unizg.hr>
 <20230106175828.13333-1-kuniyu@amazon.com>
 <b80ffedf-3f53-08f7-baf0-db0450b8853f@alu.unizg.hr>
 <20230106161450.1d5579bf@kernel.org>
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <20230106161450.1d5579bf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07. 01. 2023. 01:14, Jakub Kicinski wrote:
> On Fri, 6 Jan 2023 20:28:33 +0100 Mirsad Goran Todorovac wrote:
>> The patch is generated against the "vanilla" torvalds mainline tree 6.2-rc2.
>> (Tested to apply against net.git tree.)
> 
> This kind of info belongs outside of the commit message (under the
> --- line).
> 
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Eric Dumazet <edumazet@google.com>
>> Cc: Jakub Kicinski <kuba@kernel.org>
>> Cc: Paolo Abeni <pabeni@redhat.com>
>> Cc: Shuah Khan <shuah@kernel.org>
>> Cc: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
>> Cc: Florian Westphal <fw@strlen.de>
>> Reviewed-by: Florian Westphal <fw@strlen.de>
>> Fixes: 314001f0bf92 ("af_unix: Add OOB support")
>> Signed-off-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
>>
> 
> no new line here
> 
>> ---
> 
> still doesn't apply, probably because there are two email footers

Thank you for the guidelines to make your robots happy :), the next
time I will assume all these from start, provided that I find and
patch another bug or issue.

Thanks,
Mirsad

-- 
Mirsad Goran Todorovac
Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu

System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb, Republic of Croatia
The European Union

