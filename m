Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F9032F5E1
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 23:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbhCEW2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 17:28:12 -0500
Received: from mga03.intel.com ([134.134.136.65]:17442 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229493AbhCEW16 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 17:27:58 -0500
IronPort-SDR: ZMys+L0MIczsPNZ5878mMY5yscugJ9YIYU///cEcqRyJWZeS5SbgUoMmKPGC+hJuzCWzL7KoMu
 vk2nMlOYQW6A==
X-IronPort-AV: E=McAfee;i="6000,8403,9914"; a="187795258"
X-IronPort-AV: E=Sophos;i="5.81,226,1610438400"; 
   d="scan'208";a="187795258"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2021 14:27:57 -0800
IronPort-SDR: 92OmTRiUUZKOY9LdNXkXV2ihqbtzwhCjJE6qOHbCDD67txo2lZxzYIt4HVv113pBaf152Dsa0R
 wJWXDy13vZVQ==
X-IronPort-AV: E=Sophos;i="5.81,226,1610438400"; 
   d="scan'208";a="508213011"
Received: from bfrahm-mobl2.amr.corp.intel.com (HELO vcostago-mobl2.amr.corp.intel.com) ([10.212.101.47])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2021 14:27:57 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+aa7d098bd6fa788fae8e@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        =?utf-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: INFO: rcu detected stall in corrupted (4)
In-Reply-To: <CACT4Y+Z1MD2VyjDbz5h7UhPqihSBCnOUjA0E5_DoJqAZEHciAg@mail.gmail.com>
References: <000000000000cedbc405ae81531f@google.com>
 <CACT4Y+Z1MD2VyjDbz5h7UhPqihSBCnOUjA0E5_DoJqAZEHciAg@mail.gmail.com>
Date:   Fri, 05 Mar 2021 14:27:55 -0800
Message-ID: <87ft19nslw.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dmitry Vyukov <dvyukov@google.com> writes:

> On Fri, Sep 4, 2020 at 8:49 PM syzbot
> <syzbot+aa7d098bd6fa788fae8e@syzkaller.appspotmail.com> wrote:
>>
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    0f091e43 netlabel: remove unused param from audit_log_form..
>> git tree:       net-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=14551a71900000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=61025c6fd3261bb1
>> dashboard link: https://syzkaller.appspot.com/bug?extid=aa7d098bd6fa788fae8e
>> compiler:       gcc (GCC) 10.1.0-syz 20200507
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14eeda25900000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=161472f5900000
>>
>> The issue was bisected to:
>>
>> commit 5a781ccbd19e4664babcbe4b4ead7aa2b9283d22
>> Author: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>> Date:   Sat Sep 29 00:59:43 2018 +0000
>>
>>     tc: Add support for configuring the taprio scheduler
>
> This still happens. The bisection and repro look correct, the repro
> also sets up taprio scheduler;
> https://syzkaller.appspot.com/bug?id=7349616606afa3c986c377792f7ccbf9daae1142
>
> Vinicius, could you please take a look? Thanks

Ugh.

Sure. Taking a look.


Cheers,
-- 
Vinicius
