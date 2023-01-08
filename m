Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F273A6619F8
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 22:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbjAHVah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 16:30:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbjAHVaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 16:30:35 -0500
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B056158;
        Sun,  8 Jan 2023 13:30:33 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id 05EEC604F1;
        Sun,  8 Jan 2023 22:30:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1673213431; bh=6bFY0+6U8NZmKtX+MFR+30MPyUxcHqLB8IlTkTcposo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=rxmXkq9HoXu7DXK4ce6GFsCmqY7ysp6CbaVYtzS9ijxKx9sLmIP9kDFbZ6JOct4dl
         Fm+O8Tgogty4G/KCzr8+xdF6mnDgB47C+Z0zqWZYkzU5zEZBdU3+hibuUyzYfoRPTk
         PsUdr7mkYGhpdvdg+qNPaH6WwFuF4vhrmrJLa0A/zC2mGbharIjnz6T/9vunWGsbXq
         rIGsXfLzXkul5TJRJ9yGp36AAqaSk1rOZL1zwFDqi3GK6sHWrsxTwydOvCn2BwGmm+
         4LOsRVS9QGdWWfziY0gtlZc+Rvlr29EW0rFGjnaVVYZ3+NSXtOO/VunNq6PJs5weZx
         8S9XG2ykeFfZA==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id nTFwe5H3eL8x; Sun,  8 Jan 2023 22:30:28 +0100 (CET)
Received: from [192.168.0.12] (unknown [188.252.196.35])
        by domac.alu.hr (Postfix) with ESMTPSA id E9886604F0;
        Sun,  8 Jan 2023 22:30:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1673213428; bh=6bFY0+6U8NZmKtX+MFR+30MPyUxcHqLB8IlTkTcposo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=qWVcdqMnK7LJZKG0xyZE8Wh0alvO/npanPaBF0GUGiXSwlR0ydvx/lQfaKoyduv4n
         Hjn0kSkR6dDqyQykiy+0gMxA4Z7TkEv7/JEezjSf/2MgyQtfQn6rB/apNyEsk+LFdo
         CkRb9Mhn6eBRhy2UhDvai9QbpS/Z6O6XL1369a0pd2O3ByEoil+XqICGALVZ78kfmz
         cDG2Io7t97B3Lue0n3L4VcSMR977OfJEYb/80kyWs8FVZLzLcrNR/4cNCbxAPahaeE
         rhIpbUptcjPYDWYCNVRgSiswpj2YdbWg2XUsa6ssUWsv+o/mF/l0DHuM0AWdkiJqS0
         7zscghNkIMEuw==
Message-ID: <a0add3e5-5e37-1585-bcf6-57ead27ccdae@alu.unizg.hr>
Date:   Sun, 8 Jan 2023 22:30:27 +0100
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
 <8fb1a2c5-ee35-67eb-ef3c-e2673061850d@alu.unizg.hr>
 <20230106180808.51550e82@kernel.org>
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <20230106180808.51550e82@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07. 01. 2023. 03:08, Jakub Kicinski wrote:
> On Sat, 7 Jan 2023 02:42:43 +0100 Mirsad Goran Todorovac wrote:
>>> still doesn't apply, probably because there are two email footers  
>>
>> Thank you for the guidelines to make your robots happy :), the next
>> time I will assume all these from start, provided that I find and
>> patch another bug or issue.
> 
> Ah, sorry, wrong assumption :S
> 
> Your email client converts tabs to spaces, that's the problem.
> 
> Could you try get send-email ?

Sorry, Jakub, just to "remove this from stack", did the
[PATCH net v4] af_unix: selftest: Fix the size of the parameter to connect()
apply?

I can't seem to handle more than about half a dozen of bug reports at a time or
I started overlooking emails :(

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

