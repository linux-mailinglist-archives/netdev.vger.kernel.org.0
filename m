Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFA2B16AE04
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 18:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727636AbgBXRwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 12:52:16 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49658 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727259AbgBXRwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 12:52:15 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01OHnQiC003213;
        Mon, 24 Feb 2020 17:51:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=IdkzpILR6vBAHlc8aaDsjs8ao4gxJyHcYNKDq6bhgwo=;
 b=O7yCyLmDlRlL/snRdEAddiBsq1jhkdE9wiqNbDoUTEDtecDQWq6VkCb1+YyrS1GwXLIS
 HprZ9WYRHvgv6jPkWi/y2+LjjsP4D/3vpDmc49xUSNF6GiA7+nEfeh1UcGRe3zRKEK6l
 qvDGNWCKMNfKdXew0ROWHV4OEKjNabhGWQFlv4IQT5At2z64qv9owVFxZP/zw5LyejsO
 ILir0ngDtThZdKM83zD3Enanw+GJENgzFHuiiXaIwVwHzX04WnteVakYiwpgTWR1x9z7
 xoQ2xR/HueUuWqt2X3EVfWo+zwXuvHq1uofgM/HZZgnfk2wCEsETXtfHpPahYvwL+IEi ww== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2yauqu909w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 17:51:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01OHltqr121370;
        Mon, 24 Feb 2020 17:51:05 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 2ybe11rqn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 24 Feb 2020 17:51:05 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01OHp4kg130076;
        Mon, 24 Feb 2020 17:51:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2ybe11rqm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 17:51:04 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01OHp2fW012446;
        Mon, 24 Feb 2020 17:51:02 GMT
Received: from [10.209.227.41] (/10.209.227.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 09:51:02 -0800
Subject: Re: general protection fault in rds_ib_add_one
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+274094e62023782eeb17@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        rds-devel@oss.oracle.com, syzkaller-bugs@googlegroups.com
References: <20200224103913.2776-1-hdanton@sina.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <8c0a6d58-fd96-ded0-d5ad-a8ffc8d7a620@oracle.com>
Date:   Mon, 24 Feb 2020 09:51:01 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200224103913.2776-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1011 malwarescore=0 impostorscore=0 adultscore=0 phishscore=0
 priorityscore=1501 mlxlogscore=999 spamscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240132
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/24/20 2:39 AM, Hillf Danton wrote:
> 
> On Mon, 24 Feb 2020 00:38:13 -0800
>> syzbot found the following crash on:
>>
>> HEAD commit:    b0dd1eb2 Merge branch 'akpm' (patches from Andrew)
>> git tree:       upstream
>> console output: https://urldefense.com/v3/__https://syzkaller.appspot.com/x/log.txt?x=13db9de9e00000__;!!GqivPVa7Brio!O9xt2mwp7Vb5SndsHmi1c7ynTdDMNXebFTWfSklgQdlUqRdC218qPSAXMuDUauXTR6PmUg$
>> kernel config:  https://urldefense.com/v3/__https://syzkaller.appspot.com/x/.config?x=a6001be4097ab13c__;!!GqivPVa7Brio!O9xt2mwp7Vb5SndsHmi1c7ynTdDMNXebFTWfSklgQdlUqRdC218qPSAXMuDUauUIjkEraA$
>> dashboard link: https://urldefense.com/v3/__https://syzkaller.appspot.com/bug?extid=274094e62023782eeb17__;!!GqivPVa7Brio!O9xt2mwp7Vb5SndsHmi1c7ynTdDMNXebFTWfSklgQdlUqRdC218qPSAXMuDUauXEUExfYg$
>> compiler:       clang version 10.0.0 (https://urldefense.com/v3/__https://github.com/llvm/llvm-project/__;!!GqivPVa7Brio!O9xt2mwp7Vb5SndsHmi1c7ynTdDMNXebFTWfSklgQdlUqRdC218qPSAXMuDUauUcUeVf2A$  c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
>> syz repro:      https://urldefense.com/v3/__https://syzkaller.appspot.com/x/repro.syz?x=10ad6a7ee00000__;!!GqivPVa7Brio!O9xt2mwp7Vb5SndsHmi1c7ynTdDMNXebFTWfSklgQdlUqRdC218qPSAXMuDUauX2w5ISoA$
>> C reproducer:   https://urldefense.com/v3/__https://syzkaller.appspot.com/x/repro.c?x=13da7a29e00000__;!!GqivPVa7Brio!O9xt2mwp7Vb5SndsHmi1c7ynTdDMNXebFTWfSklgQdlUqRdC218qPSAXMuDUauUf3qIVeQ$
>>
>> Bisection is inconclusive: the first bad commit could be any of:

[...]

>> 868df536 Merge branch 'odp_fixes' into rdma.git for-next
>>
>> bisection log:  https://urldefense.com/v3/__https://syzkaller.appspot.com/x/bisect.txt?x=1542127ee00000__;!!GqivPVa7Brio!O9xt2mwp7Vb5SndsHmi1c7ynTdDMNXebFTWfSklgQdlUqRdC218qPSAXMuDUauVrB3NY9g$
>>
>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>> Reported-by: syzbot+274094e62023782eeb17@syzkaller.appspotmail.com
>>
>> batman_adv: batadv0: Interface activated: batadv_slave_1
>> infiniband syz1: set active
>> infiniband syz1: added vlan0
>> general protection fault, probably for non-canonical address 0xdffffc0000000086: 0000 [#1] PREEMPT SMP KASAN
>> KASAN: null-ptr-deref in range [0x0000000000000430-0x0000000000000437]
>> CPU: 0 PID: 8852 Comm: syz-executor043 Not tainted 5.6.0-rc2-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> RIP: 0010:dev_to_node include/linux/device.h:663 [inline]
>> RIP: 0010:rds_ib_add_one+0x81/0xe50 net/rds/ib.c:140
>> Code: b7 a8 06 00 00 4c 89 f0 48 c1 e8 03 42 80 3c 28 00 74 08 4c 89 f7 e8 0e e4 1d fa bb 30 04 00 00 49 03 1e 48 89 d8 48 c1 e8 03 <42> 8a 04 28 84 c0 0f 85 f0 0a 00 00 8b 1b 48 c7 c0 28 0c 09 89 48
>> RSP: 0018:ffffc90003087298 EFLAGS: 00010202
>> RAX: 0000000000000086 RBX: 0000000000000430 RCX: 0000000000000000
>> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
>> RBP: ffffc900030872f0 R08: ffffffff87964c3c R09: ffffed1014fd109c
>> R10: ffffed1014fd109c R11: 0000000000000000 R12: 0000000000000000
>> R13: dffffc0000000000 R14: ffff8880a7e886a8 R15: ffff8880a7e88000
>> FS:  0000000000c3d880(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00007f0318ed0000 CR3: 00000000a3167000 CR4: 00000000001406f0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Call Trace:
>>   add_client_context+0x482/0x660 drivers/infiniband/core/device.c:681
>>   enable_device_and_get+0x15b/0x370 drivers/infiniband/core/device.c:1316
>>   ib_register_device+0x124d/0x15b0 drivers/infiniband/core/device.c:1382
>>   rxe_register_device+0x3f6/0x530 drivers/infiniband/sw/rxe/rxe_verbs.c:1231
>>   rxe_add+0x1373/0x14f0 drivers/infiniband/sw/rxe/rxe.c:302
>>   rxe_net_add+0x79/0xe0 drivers/infiniband/sw/rxe/rxe_net.c:539
>>   rxe_newlink+0x31/0x90 drivers/infiniband/sw/rxe/rxe.c:318
>>   nldev_newlink+0x403/0x4a0 drivers/infiniband/core/nldev.c:1538
>>   rdma_nl_rcv_msg drivers/infiniband/core/netlink.c:195 [inline]
>>   rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
>>   rdma_nl_rcv+0x701/0xa20 drivers/infiniband/core/netlink.c:259
>>   netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
>>   netlink_unicast+0x766/0x920 net/netlink/af_netlink.c:1328
>>   netlink_sendmsg+0xa2b/0xd40 net/netlink/af_netlink.c:1917
>>   sock_sendmsg_nosec net/socket.c:652 [inline]
>>   sock_sendmsg net/socket.c:672 [inline]
>>   ____sys_sendmsg+0x4f7/0x7f0 net/socket.c:2343
>>   ___sys_sendmsg net/socket.c:2397 [inline]
>>   __sys_sendmsg+0x1ed/0x290 net/socket.c:2430
>>   __do_sys_sendmsg net/socket.c:2439 [inline]
>>   __se_sys_sendmsg net/socket.c:2437 [inline]
>>   __x64_sys_sendmsg+0x7f/0x90 net/socket.c:2437
>>   do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:294
>>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Fall back to NUMA_NO_NODE if needed.
> 
> --- a/net/rds/ib.c
> +++ b/net/rds/ib.c
> @@ -137,7 +137,8 @@ static void rds_ib_add_one(struct ib_dev
>   		return;
>   
>   	rds_ibdev = kzalloc_node(sizeof(struct rds_ib_device), GFP_KERNEL,
> -				 ibdev_to_node(device));
> +				 device->dev.parent ?
> +				 ibdev_to_node(device) : NUMA_NO_NODE);
>   	if (!rds_ibdev)
>   		return;
>   
> 
This seems good. Can you please post it as properly formatted patch ?
