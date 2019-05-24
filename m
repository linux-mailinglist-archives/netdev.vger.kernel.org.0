Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3F8828F4B
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 04:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388147AbfEXCy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 22:54:29 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:37342 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387560AbfEXCy1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 22:54:27 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 377D3BC6E59CB42BC67B;
        Fri, 24 May 2019 10:54:25 +0800 (CST)
Received: from [127.0.0.1] (10.184.191.73) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Fri, 24 May 2019
 10:54:21 +0800
Subject: Re: BUG: spinlock bad magic in rhashtable_walk_enter
To:     syzbot <syzbot+01dd5c4b3c34a5cf9308@syzkaller.appspotmail.com>,
        <davem@davemloft.net>, <jon.maloy@ericsson.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <syzkaller-bugs@googlegroups.com>,
        <tipc-discussion@lists.sourceforge.net>, <ying.xue@windriver.com>
References: <0000000000003df61e05899887d3@google.com>
From:   hujunwei <hujunwei4@huawei.com>
Message-ID: <7da38946-ae8f-93bf-99c3-28949eb46354@huawei.com>
Date:   Fri, 24 May 2019 10:53:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <0000000000003df61e05899887d3@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.184.191.73]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/5/24 9:58, syzbot wrote:
> syzbot has bisected this bug to:
> 
> commit 7e27e8d6130c5e88fac9ddec4249f7f2337fe7f8
> Author: Junwei Hu <hujunwei4@huawei.com>
> Date:   Thu May 16 02:51:15 2019 +0000
> 
>     tipc: switch order of device registration to fix a crash>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17c22c72a00000
> start commit:   510e2ced ipv6: fix src addr routing with the exception table
> git tree:       net
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=14222c72a00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=10222c72a00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=82f0809e8f0a8c87
> dashboard link: https://syzkaller.appspot.com/bug?extid=01dd5c4b3c34a5cf9308
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16b6373ca00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1251e73ca00000
> 
> Reported-by: syzbot+01dd5c4b3c34a5cf9308@syzkaller.appspotmail.com
> Fixes: 7e27e8d6130c ("tipc: switch order of device registration to fix a crash")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> 
> .
> 

This bug was fixed by:
commit 526f5b851a96 (" tipc: fix modprobe tipc failed after switch order of device registration")

Regards,
Junwei

