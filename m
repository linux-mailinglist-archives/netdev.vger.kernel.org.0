Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4D791521EC
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 22:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbgBDVWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 16:22:52 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39128 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727483AbgBDVWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 16:22:52 -0500
Received: from localhost (dhcp-077-249-119-090.chello.nl [77.249.119.90])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8D16014DD3D87;
        Tue,  4 Feb 2020 13:22:49 -0800 (PST)
Date:   Tue, 04 Feb 2020 22:22:45 +0100 (CET)
Message-Id: <20200204.222245.1920371518669295397.davem@davemloft.net>
To:     eric.dumazet@gmail.com
Cc:     syzbot+f0bbb2287b8993d4fa74@syzkaller.appspotmail.com,
        jhs@mojatatu.com, jiri@resnulli.us, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Subject: Re: memory leak in tcindex_set_parms
From:   David Miller <davem@davemloft.net>
In-Reply-To: <a1673e4f-6382-d7df-6942-6e4ffd2b81ce@gmail.com>
References: <0000000000009a59d2059dc3c8e9@google.com>
        <a1673e4f-6382-d7df-6942-6e4ffd2b81ce@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Feb 2020 13:22:51 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 4 Feb 2020 10:03:16 -0800

> 
> 
> On 2/4/20 9:58 AM, syzbot wrote:
>> Hello,
>> 
>> syzbot found the following crash on:
>> 
>> HEAD commit:    322bf2d3 Merge branch 'for-5.6' of git://git.kernel.org/pu..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=1111f8e6e00000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=8d0490614a000a37
>> dashboard link: https://syzkaller.appspot.com/bug?extid=f0bbb2287b8993d4fa74
>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17db90f6e00000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13a94511e00000
>> 
>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>> Reported-by: syzbot+f0bbb2287b8993d4fa74@syzkaller.appspotmail.com
>> 
>>
> 
> Might have been fixed already ?
> 
> commit 599be01ee567b61f4471ee8078870847d0a11e8e    net_sched: fix an OOB access in cls_tcindex

My reaction was actually that this bug is caused by this commit :)
