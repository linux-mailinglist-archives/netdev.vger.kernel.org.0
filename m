Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598E5447831
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 02:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235058AbhKHBPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 20:15:44 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:15371 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbhKHBPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 20:15:44 -0500
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HnY4r2ZMBz90WN;
        Mon,  8 Nov 2021 09:12:44 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.15; Mon, 8 Nov 2021 09:12:55 +0800
Received: from [10.174.179.215] (10.174.179.215) by
 dggema769-chm.china.huawei.com (10.1.198.211) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.15; Mon, 8 Nov 2021 09:12:53 +0800
Subject: Re: [syzbot] WARNING in sta_info_insert_rcu
To:     syzbot <syzbot+ef4ca92d9d6f5ba2f880@syzkaller.appspotmail.com>,
        <davem@davemloft.net>, <expedicao@bandup.com.br>,
        <hdanton@sina.com>, <johannes.berg@intel.com>,
        <johannes@sipsolutions.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <syzkaller-bugs@googlegroups.com>
References: <000000000000af312005d020fa29@google.com>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <41236031-9178-0170-04d9-d971b19c5876@huawei.com>
Date:   Mon, 8 Nov 2021 09:12:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <000000000000af312005d020fa29@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggema769-chm.china.huawei.com (10.1.198.211)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/11/7 0:09, syzbot wrote:
> syzbot suspects this issue was fixed by commit:
> 
> commit a6555f844549cd190eb060daef595f94d3de1582
> Author: YueHaibing <yuehaibing@huawei.com>
> Date:   Fri Aug 27 14:42:30 2021 +0000
> 
>     mac80211: Drop frames from invalid MAC address in ad-hoc mode
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=103db432b00000
> start commit:   7266f2030eb0 Merge tag 'pm-5.13-rc8' of git://git.kernel.o..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=533cb04fad26afdb
> dashboard link: https://syzkaller.appspot.com/bug?extid=ef4ca92d9d6f5ba2f880
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11be2fd0300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10d85b14300000
> 
> If the result looks correct, please mark the issue as fixed by replying with:
> 
> #syz fix: mac80211: Drop frames from invalid MAC address in ad-hoc mode

#syz fix: mac80211: Drop frames from invalid MAC address in ad-hoc mode

> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> .
> 
