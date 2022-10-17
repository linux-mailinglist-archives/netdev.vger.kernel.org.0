Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5267D60057E
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 04:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbiJQCzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Oct 2022 22:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231550AbiJQCzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Oct 2022 22:55:21 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D937647BA3
        for <netdev@vger.kernel.org>; Sun, 16 Oct 2022 19:55:20 -0700 (PDT)
Received: from fsav114.sakura.ne.jp (fsav114.sakura.ne.jp [27.133.134.241])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 29H2s2ib029133;
        Mon, 17 Oct 2022 11:54:02 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav114.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav114.sakura.ne.jp);
 Mon, 17 Oct 2022 11:54:02 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav114.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 29H2s1uW029130
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 17 Oct 2022 11:54:01 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <50e2ecf5-4b83-3ba1-70a2-796d988d4c0b@I-love.SAKURA.ne.jp>
Date:   Mon, 17 Oct 2022 11:54:01 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [syzbot] WARNING in c_start
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Yury Norov <yury.norov@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Borislav Petkov <bp@alien8.de>,
        syzbot <syzbot+d0fd2bf0dd6da72496dd@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com,
        Andrew Jones <ajones@ventanamicro.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk,
        caraitto@google.com, willemb@google.com, jonolson@google.com,
        amritha.nambiar@intel.com, linux-kernel@vger.kernel.org
References: <0000000000007647ec05eb05249c@google.com>
 <Y0nTd9HSnnt/KDap@zn.tnic>
 <2eaf1386-8ab0-bd65-acee-e29f1c5a6623@I-love.SAKURA.ne.jp>
 <Y0qfLyhSoTodAdxu@zn.tnic> <Y0sbwpRcipI564yp@yury-laptop>
 <23488f06-c4b4-8bd8-b0bc-85914ba4d1c6@I-love.SAKURA.ne.jp>
 <Y0tafD7qI2x5xzTc@yury-laptop>
 <CAHk-=wihz-GXx66MmEyaADgS1fQE_LDcB9wrHAmkvXkd8nx9tA@mail.gmail.com>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <CAHk-=wihz-GXx66MmEyaADgS1fQE_LDcB9wrHAmkvXkd8nx9tA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/10/17 2:52, Linus Torvalds wrote:
> Anyway, since rc1 is fairly imminent, I will just revert it for now -
> I don't want to have a pending revert wait until -rc2.

Thank you, Linus.

Yury or Jakub, please send a revert request on commit 854701ba4c39 ("net: fix cpu_max_bits_warn()
usage in netif_attrmask_next{,_and}"), for https://syzkaller.appspot.com/bug?extid=9abe5ecc348676215427
says that boot is still failing.

> But I actually suspect that the thing we should really do is to just
> remove the check entirely for these functions that are already defined
> in terms of "if no more bits, return nr_cpu_ids". They already
> basically return an error case, having them *warn* about the error
> they are going to return is just obnoxious.

I agree.

