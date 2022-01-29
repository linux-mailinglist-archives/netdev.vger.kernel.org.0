Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD604A329E
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 00:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353395AbiA2Xa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 18:30:58 -0500
Received: from ip59.38.31.103.in-addr.arpa.unknwn.cloudhost.asia ([103.31.38.59]:49292
        "EHLO gnuweeb.org" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S238951AbiA2Xa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 18:30:58 -0500
Received: from [192.168.88.87] (unknown [36.81.38.25])
        by gnuweeb.org (Postfix) with ESMTPSA id AE5C8C32D0;
        Sat, 29 Jan 2022 23:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=gnuweeb.org;
        s=default; t=1643499055;
        bh=B4K+3+JFTWWKU/O0tyev275Y374cFJ34SuhCQURx7oc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=JKJ5Ct61wVnrR2iphOOxgQYDqWKHYayo3MF1SEnxb+dYFC0P7aw2idbQ1+YoOhngb
         Wfkb89NKejxQCeTxH4CWHkbjtRsG7pIj5zktfZT0kPzn9bMyUvtgicacW1FFwLRK3p
         LYnE7fh5WJIpxBqXMoVo4LAArpgAxK/IEXPT00uFhLkIZFJG8zKXO016l1qH/RhrMH
         Hx2N0lsxNpHe3lpPcQgWY/+HUwJ6IkJ9jpIZX6sQ0V7ThEfaXCLVpQn3ekYrLlL3uq
         YxK4kUYb395e8tCKQC9goRn4GwgbKq3TK69ts9um/JEMhdJ77rZOzaY/KrO95ambO1
         bsnQtR12AyXng==
Message-ID: <8c5e3b16-15ac-45fe-d9c2-14615eccb981@gnuweeb.org>
Date:   Sun, 30 Jan 2022 06:30:52 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH for-5.18 v1 0/3] Add `sendto(2)` and `recvfrom(2)` support
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        netdev Mailing List <netdev@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>,
        Tea Inside Mailing List <timl@vger.teainside.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Nugra <richiisei@gmail.com>,
        Praveen Kumar <kpraveen.lkml@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>
References: <20220129125021.15223-1-ammarfaizi2@gnuweeb.org>
 <98d4f268-5945-69a7-cec7-bccfcdedde1c@kernel.dk>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <98d4f268-5945-69a7-cec7-bccfcdedde1c@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/30/22 1:32 AM, Jens Axboe wrote:
> On 1/29/22 5:50 AM, Ammar Faizi wrote:
>> Hello,
>>
>> This patchset adds sendto(2) and recvfrom(2) support for io_uring. It
>> also addresses an issue in the liburing GitHub repository [1].
>>
>> ## Motivations:
>>
>> 1) By using `sendto()` and `recvfrom()` we can make the submission
>>     simpler compared to always using `sendmsg()` and `recvmsg()` from
>>     the userspace. Especially for UDP socket.
>>
>> 2) There is a historical patch that tried to add the same
>>     functionality, but did not end up being applied. [2]
> 
> As far as I can tell, the only win from sendto/recvfrom is that we can
> handle async offload a bit cheaper compared to sendmsg/recvmsg. Is this
> enough to warrant adding them separately? I don't know, which is why
> this has been somewhat stalled for a while.
> 
> Maybe you have done some testing and have numbers (or other reasons) to
> back up the submission? There's not a whole lot of justification in this
> patchset.
> 

So far, I haven't done it. I only created a test that ensures the
functionality is working properly.

I will play with this further. If I win, I will submit the v2 of
this series for review. Thanks, Jens!

-- 
Ammar Faizi
