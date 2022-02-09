Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A2A4AE8B3
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 06:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233276AbiBIFGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 00:06:24 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:56656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbiBIFCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 00:02:18 -0500
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C81C03E926;
        Tue,  8 Feb 2022 21:02:19 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R821e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0V3ze3Rg_1644382934;
Received: from 30.225.24.53(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V3ze3Rg_1644382934)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 09 Feb 2022 13:02:15 +0800
Message-ID: <4da041e7-d88c-16ba-d180-f8e8b8c2ef31@linux.alibaba.com>
Date:   Wed, 9 Feb 2022 13:02:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [syzbot] BUG: MAX_LOCK_DEPTH too low! (3)
To:     syzbot <syzbot+4de3c0e8a263e1e499bc@syzkaller.appspotmail.com>,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net,
        john.fastabend@gmail.com, kafai@fb.com, kgraul@linux.ibm.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
References: <0000000000006d045e05d78776f6@google.com>
From:   Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <0000000000006d045e05d78776f6@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/2/9 4:21 am, syzbot wrote:

> 
> The issue was bisected to:
> 
> commit 341adeec9adad0874f29a0a1af35638207352a39
> Author: Wen Gu <guwen@linux.alibaba.com>
> Date:   Wed Jan 26 15:33:04 2022 +0000
> 
>      net/smc: Forward wakeup to smc socket waitqueue after fallback
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11c2637c700000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=13c2637c700000
> console output: https://syzkaller.appspot.com/x/log.txt?x=15c2637c700000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+4de3c0e8a263e1e499bc@syzkaller.appspotmail.com
> Fixes: 341adeec9ada ("net/smc: Forward wakeup to smc socket waitqueue after fallback")
> 
> BUG: MAX_LOCK_DEPTH too low!
> turning off the locking correctness validator.
> depth: 48  max: 48!

Thanks for syzbot's report.

I will look into this issue and give feedback as soon as possible.

Thanks,
Wen Gu
