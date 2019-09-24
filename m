Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2FBBC135
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 07:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408919AbfIXFFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 01:05:50 -0400
Received: from mga05.intel.com ([192.55.52.43]:32387 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408869AbfIXFFt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 01:05:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Sep 2019 22:05:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,542,1559545200"; 
   d="scan'208";a="179363733"
Received: from msuckert-mobl2.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.38.73])
  by orsmga007.jf.intel.com with ESMTP; 23 Sep 2019 22:05:43 -0700
Subject: Re: general protection fault in xsk_map_update_elem
To:     Daniel Borkmann <daniel@iogearbox.net>,
        syzbot <syzbot+491c1b7565ba9069ecae@syzkaller.appspotmail.com>
Cc:     ast@kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        hawk@kernel.org, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, jonathan.lemon@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, magnus.karlsson@intel.com,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
References: <0000000000006a3a2f05933a5c53@google.com>
 <20190923225050.GA26406@pc-63.home>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <4aa3445e-7f45-2ef3-4e7c-d4f2df17ba71@intel.com>
Date:   Tue, 24 Sep 2019 07:05:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190923225050.GA26406@pc-63.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-09-24 00:50, Daniel Borkmann wrote:
> On Mon, Sep 23, 2019 at 08:49:11AM -0700, syzbot wrote:
>> Hello,
>>
>> syzbot found the following crash on:
>>
>> HEAD commit:    b41dae06 Merge tag 'xfs-5.4-merge-7' of git://git.kernel.o..
>> git tree:       net-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=130b25ad600000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=dfcf592db22b9132
>> dashboard link: https://syzkaller.appspot.com/bug?extid=491c1b7565ba9069ecae
>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=155a0c29600000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=172bf6d9600000
>>
>> The bug was bisected to:
>>
>> commit 0402acd683c678874df6bdbc23530ca07ea19353
>> Author: Björn Töpel <bjorn.topel@intel.com>
>> Date:   Thu Aug 15 09:30:13 2019 +0000
>>
>>      xsk: remove AF_XDP socket from map when the socket is released
> 
> Bjorn, PTAL, thanks.
> 

I'm on it! Thanks for the poke.
