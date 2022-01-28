Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B466B49F5C7
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 09:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbiA1I6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 03:58:17 -0500
Received: from smtpout140.security-mail.net ([85.31.212.146]:34101 "EHLO
        fx601.security-mail.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231162AbiA1I6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 03:58:17 -0500
Received: from localhost (localhost [127.0.0.1])
        by fx601.security-mail.net (Postfix) with ESMTP id 9686D3ACF82
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 09:58:07 +0100 (CET)
Received: from fx601 (localhost [127.0.0.1]) by fx601.security-mail.net
 (Postfix) with ESMTP id C35853ACF6F; Fri, 28 Jan 2022 09:58:06 +0100 (CET)
Received: from zimbra2.kalray.eu (unknown [217.181.231.53]) by
 fx601.security-mail.net (Postfix) with ESMTPS id EC6873ACF56; Fri, 28 Jan
 2022 09:58:05 +0100 (CET)
Received: from zimbra2.kalray.eu (localhost [127.0.0.1]) by
 zimbra2.kalray.eu (Postfix) with ESMTPS id CD70C27E034A; Fri, 28 Jan 2022
 09:58:05 +0100 (CET)
Received: from localhost (localhost [127.0.0.1]) by zimbra2.kalray.eu
 (Postfix) with ESMTP id B2EA027E03FF; Fri, 28 Jan 2022 09:58:05 +0100 (CET)
Received: from zimbra2.kalray.eu ([127.0.0.1]) by localhost
 (zimbra2.kalray.eu [127.0.0.1]) (amavisd-new, port 10026) with ESMTP id
 JCnfkgol7IPI; Fri, 28 Jan 2022 09:58:05 +0100 (CET)
Received: from zimbra2.kalray.eu (localhost [127.0.0.1]) by
 zimbra2.kalray.eu (Postfix) with ESMTP id 9D00427E034A; Fri, 28 Jan 2022
 09:58:05 +0100 (CET)
X-Virus-Scanned: E-securemail, by Secumail
Secumail-id: <1e10.61f3b01d.ead36.0>
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra2.kalray.eu B2EA027E03FF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kalrayinc.com;
 s=4F334102-7B72-11EB-A74E-42D0B9747555; t=1643360285;
 bh=nlpzg0KFtNedtEh1YwHkj7kGTfoHZeLtEq7Tx40DMtE=;
 h=Date:From:To:Message-ID:MIME-Version;
 b=DdxaJ6xfnOEQ89pm0cL5d1XXLaPcLmEIBQ56XmT/isrZcqQtCsqXu6nakIV8nEpWs
 EU5EEyEpo7ar0ntLd3pq/Qr56okTsf5Keho5do821Vsb6qWv0OsMKLGPpBsBYpnDyB
 TcIaSkspwDG7CZklZ50dZH3ps/LRGpE7rCqqT6kWmhrlxynQoHe9ArD3ewZ/vG9hN4
 K2X7IxpIU9DVFi4GFercbmXIPqopdqlwe2bgWz8ImL+7akDddBIyI3RxfHq5+p+VNe
 /kyH5zbKsGzVzfP4KVx6uJIrLJxahgol5ZC21UYHpUZSqpFmF09CXPjICuvOykzzir
 kWqajj6pqWa3w==
Date:   Fri, 28 Jan 2022 09:58:05 +0100 (CET)
From:   Vincent Ray <vray@kalrayinc.com>
To:     linyunsheng <linyunsheng@huawei.com>
Cc:     vladimir oltean <vladimir.oltean@nxp.com>, kuba <kuba@kernel.org>,
        Samuel Jones <sjones@kalrayinc.com>,
        netdev <netdev@vger.kernel.org>, davem <davem@davemloft.net>
Message-ID: <851805746.1848130.1643360285530.JavaMail.zimbra@kalray.eu>
In-Reply-To: <1c53c5c0-4e77-723b-4260-de83e8f8e40c@huawei.com>
References: <1862202329.1457162.1643113633513.JavaMail.zimbra@kalray.eu>
 <698739062.1462023.1643115337201.JavaMail.zimbra@kalray.eu>
 <1c53c5c0-4e77-723b-4260-de83e8f8e40c@huawei.com>
Subject: Re: packet stuck in qdisc
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary=secu_1e1a996326f675e173a89128911a5535_part1
X-Originating-IP: [192.168.40.202]
X-Mailer: Zimbra 9.0.0_GA_4126 (ZimbraWebClient - FF96
 (Linux)/9.0.0_GA_4126)
Thread-Topic: packet stuck in qdisc
Thread-Index: bEA8+QCtJyM0lomo8QsyiI6BYJoFug==
X-ALTERMIMEV2_out: done
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This message is in MIME format.

--secu_1e1a996326f675e173a89128911a5535_part1
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Hello,

It seems the problem can be reproduced easily. Is there some testcase without
hw dependency, so that I can reproduce the problem myself?

[VR]
Well, in my case, I produced it with the setup described below, which does include the Kalray board.
However, I am quite confident this has nothing to do with the board, not even with any particular Host NIC / cable, so that you can surely reproduce it in a different environment.
I think you just need to send some NVME-over-TCP traffic to any target able to receive it. In fact I suspect that any TCP traffic will do.
Attached is the fio test case we are running after doing the following nvme connect :
nvme connect -n nqn.2014-06.com.kalrayinc:nvme:ecca9057-4b59-5332-8d75-5acdcdd8a88e -t tcp -i 4 -a 10.20.0.1'      
And then simply
fio ./fio_jobs_randwr4k_60s.spdk


Which cpu is used in the testing? It seems the cpu arch's
memory semantic is importance when handling the rare case.

[VR] 
It's x86_64
FWIW, I've seen the problem happen both on native host and whithin a VM (be vcpu pinned or not, be fio threads pinned or not).


----- Original Message -----
From: "linyunsheng" <linyunsheng@huawei.com>
To: "Vincent Ray" <vray@kalrayinc.com>, "vladimir oltean" <vladimir.oltean@nxp.com>, "kuba" <kuba@kernel.org>, "davem" <davem@davemloft.ne>
Cc: "Samuel Jones" <sjones@kalrayinc.com>, "netdev" <netdev@vger.kernel.org>
Sent: Friday, January 28, 2022 3:36:27 AM
Subject: Re: packet stuck in qdisc

On 2022/1/25 20:55, Vincent Ray wrote:
> Dear kernel maintainers / developers,
> 
> I work at Kalray where we are developping an NVME-over-TCP target controller board.
> My setup is as such :
> - a development workstation running Linux 5.x.y (the host)
> - sending NVME-TCP traffic to our board, to which it is connected through a Mellanox NIC (Connect-X-5) and a 100G ETH cable
> 
> While doing performance tests, using simple fio scenarios running over the regular kernel nvme-tcp driver on the host, we noticed important performance variations.
> After some digging (using tcpdump on the host), we found that there were big "holes" in the tcp traffic sent by the host.
> The scenario we observed is the following :
> 1) a TCP segment gets lost (not sent by the host) on a particular TCP connection, leading to a gap in the seq numbers received by the board
> 2) the board sends dup-acks and/or sacks (if configured) to signal this loss
> 3) then, sometimes, the host stops emitting on that TCP connection for several seconds (as much as 14s observed)
> 4) finally the host resumes emission, sending the missing packet
> 5) then the TCP connection continues correctly with the appropriate throughput
> 
> Such a scenario can be observed in the attached tcpdump (+ comments).

Hi,
    Thanks for reporting the problem.

> 
> We noticed that this was happening only in recent versions of the kernel, so we dichotomized until we found the culprit commits :
> we believe that the bug was introduced in qdisc updates for 5.14.rc1 by this set of commits, more precisely the middle one :
> 
> [2021-06-22] d3e0f57 Yunsheng Lin net: sched: remove qdisc->empty for lockless qdisc
> [2021-06-22] c4fef01 Yunsheng Lin net: sched: implement TCQ_F_CAN_BYPASS for lockless qdisc    *=> KO*
> [2021-06-22] dd25296 Yunsheng Lin net: sched: avoid unnecessary seqcount operation for lockless qdisc   *=> still OK*
> 
> As far as I can tell, the bug is still present in the mainline (at least it was in 5.16-rc4).
> From what I understand / guess, some optimizations in lockless qdiscs have lead to a race making the qdisc unaware that a packet has been enqueued and is waiting for emission.
> I suspect that, when this happens with TCP packets "to be retransmitted", the TCP stack will not timeout and try to retransmitt again because it uses skb_still_in_host_queue() to avoid useless re-retransmissions
> From net/ipv4/ tcp_output.c :
> //* Thanks to skb fast clones, we can detect if a prior transmit of                                                                                                                                                   /
> / * a packet is still in a qdisc or driver queue.                                                                                                                                                                     /
> / * In this case, there is very little point doing a retransmit !                                                                                                                                                     /
> / */  /
> I guess this plays a role in making these holes grow up to 14s, and an other layer than TCP might not experience it (?).
> 
> The interface through which my traffic is going is :
> eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
>     link/ether b8:ce:f6:60:c9:97 brd ff:ff:ff:ff:ff:ff
>     inet 10.20.0.254/24 scope global eth3
> 
> As you can see, it uses a mq qdisc. I did not try with other qdiscs yet.
> 
> Finally, if/when troubleshooting this problem in kernels older than 5.14.7, it's a good idea to first cherry-pick this patch :
> [2021-09-09] ae66447 Keith Busch nvme-tcp: fix io_work priority inversion
> because it fixes a nvme-tcp bug whose performance impact is itself so big that it "hides" the one we've discovered (bringing itself lots of holes at the nvme-tcp layer ...)
> 
> On impacted kernels, the "pkt_stuck_in_qdisc" bug shows up in the order of zero to a few occurences per minute per TCP connection.

It seems the problem can be reproduced easily. Is there some testcase without
hw dependency, so that I can reproduce the problem myself?

> 
> I did not really have time to understand it thoroughly, nor am I a network stack expert, so I don't propose any particular patch for it but I'll be happy to help testing fix attempts if it can help.
> Please feel free to ask any additional information.

Which cpu is used in the testing? It seems the cpu arch's
memory semantic is importance when handling the rare case.


> Best regards,
> 
> 
> *Vincent Ray*
> *Senior Architect • Kalray*
> Phone: +33 6 43 94 87 65
> _vray@kalrayinc.com_ • _www.kalrayinc.com_ <https://www.kalrayinc.com>
> 
> Kalray logo <https://www.kalrayinc.com>
> 	
> Intelligent Data Processing
> From Cloud to Edge
> 
> 
> *Please consider the environment before printing this e-mail.*
> This message contains information that may be privileged or confidential and is the property of Kalray S.A. It is intended only for the person to whom it is addressed. If you are not the intended recipient, you are not authorized to print, retain, copy, disseminate, distribute, or use this message or any part thereof. If you receive this message in error, please notify the sender immediately and delete all copies of this message.
> 


To declare a filtering error, please use the following link : https://www.security-mail.net/reporter.php?mid=12154.61f356b5.a06c1.0&r=vray%40kalrayinc.com&s=linyunsheng%40huawei.com&o=Re%3A+packet+stuck+in+qdisc&verdict=C&c=d26dcdd346e4be7ae9b35c1fc91bb6e71c6850cc


--secu_1e1a996326f675e173a89128911a5535_part1
Content-Type: application/octet-stream; name=fio_jobs_randwr4k_60s.spdk
Content-Disposition: attachment; filename=fio_jobs_randwr4k_60s.spdk
Content-Transfer-Encoding: base64

W2pvYjAwMF0KZmlsZW5hbWU9L2Rldi9udm1lMG4xCmlvZW5naW5lPWxpYmFpbwp0aHJlYWQ9MQpn
cm91cF9yZXBvcnRpbmc9MApkaXJlY3Q9MQpub3JhbmRvbW1hcD0xCnJ3PXJhbmRydwpyd21peHJl
YWQ9MApicz00awppb2RlcHRoPTE2CnRpbWVfYmFzZWQ9MQpydW50aW1lPTYwCmNwdXNfYWxsb3dl
ZD0wCgpbam9iMDAxXQpmaWxlbmFtZT0vZGV2L252bWUwbjEKaW9lbmdpbmU9bGliYWlvCnRocmVh
ZD0xCmdyb3VwX3JlcG9ydGluZz0wCmRpcmVjdD0xCm5vcmFuZG9tbWFwPTEKcnc9cmFuZHJ3CnJ3
bWl4cmVhZD0wCmJzPTRrCmlvZGVwdGg9MTYKdGltZV9iYXNlZD0xCnJ1bnRpbWU9NjAKY3B1c19h
bGxvd2VkPTEKCltqb2IwMDJdCmZpbGVuYW1lPS9kZXYvbnZtZTBuMQppb2VuZ2luZT1saWJhaW8K
dGhyZWFkPTEKZ3JvdXBfcmVwb3J0aW5nPTAKZGlyZWN0PTEKbm9yYW5kb21tYXA9MQpydz1yYW5k
cncKcndtaXhyZWFkPTAKYnM9NGsKaW9kZXB0aD0xNgp0aW1lX2Jhc2VkPTEKcnVudGltZT02MApj
cHVzX2FsbG93ZWQ9MgoKW2pvYjAwM10KZmlsZW5hbWU9L2Rldi9udm1lMG4xCmlvZW5naW5lPWxp
YmFpbwp0aHJlYWQ9MQpncm91cF9yZXBvcnRpbmc9MApkaXJlY3Q9MQpub3JhbmRvbW1hcD0xCnJ3
PXJhbmRydwpyd21peHJlYWQ9MApicz00awppb2RlcHRoPTE2CnRpbWVfYmFzZWQ9MQpydW50aW1l
PTYwCmNwdXNfYWxsb3dlZD0zCgpbam9iMDA0XQpmaWxlbmFtZT0vZGV2L252bWUwbjEKaW9lbmdp
bmU9bGliYWlvCnRocmVhZD0xCmdyb3VwX3JlcG9ydGluZz0wCmRpcmVjdD0xCm5vcmFuZG9tbWFw
PTEKcnc9cmFuZHJ3CnJ3bWl4cmVhZD0wCmJzPTRrCmlvZGVwdGg9MTYKdGltZV9iYXNlZD0xCnJ1
bnRpbWU9NjAKY3B1c19hbGxvd2VkPTQKCltqb2IwMDVdCmZpbGVuYW1lPS9kZXYvbnZtZTBuMQpp
b2VuZ2luZT1saWJhaW8KdGhyZWFkPTEKZ3JvdXBfcmVwb3J0aW5nPTAKZGlyZWN0PTEKbm9yYW5k
b21tYXA9MQpydz1yYW5kcncKcndtaXhyZWFkPTAKYnM9NGsKaW9kZXB0aD0xNgp0aW1lX2Jhc2Vk
PTEKcnVudGltZT02MApjcHVzX2FsbG93ZWQ9NQoKW2pvYjAwNl0KZmlsZW5hbWU9L2Rldi9udm1l
MG4xCmlvZW5naW5lPWxpYmFpbwp0aHJlYWQ9MQpncm91cF9yZXBvcnRpbmc9MApkaXJlY3Q9MQpu
b3JhbmRvbW1hcD0xCnJ3PXJhbmRydwpyd21peHJlYWQ9MApicz00awppb2RlcHRoPTE2CnRpbWVf
YmFzZWQ9MQpydW50aW1lPTYwCmNwdXNfYWxsb3dlZD02Cgpbam9iMDA3XQpmaWxlbmFtZT0vZGV2
L252bWUwbjEKaW9lbmdpbmU9bGliYWlvCnRocmVhZD0xCmdyb3VwX3JlcG9ydGluZz0wCmRpcmVj
dD0xCm5vcmFuZG9tbWFwPTEKcnc9cmFuZHJ3CnJ3bWl4cmVhZD0wCmJzPTRrCmlvZGVwdGg9MTYK
dGltZV9iYXNlZD0xCnJ1bnRpbWU9NjAKY3B1c19hbGxvd2VkPTcKCltqb2IwMDhdCmZpbGVuYW1l
PS9kZXYvbnZtZTBuMQppb2VuZ2luZT1saWJhaW8KdGhyZWFkPTEKZ3JvdXBfcmVwb3J0aW5nPTAK
ZGlyZWN0PTEKbm9yYW5kb21tYXA9MQpydz1yYW5kcncKcndtaXhyZWFkPTAKYnM9NGsKaW9kZXB0
aD0xNgp0aW1lX2Jhc2VkPTEKcnVudGltZT02MApjcHVzX2FsbG93ZWQ9OAoKW2pvYjAwOV0KZmls
ZW5hbWU9L2Rldi9udm1lMG4xCmlvZW5naW5lPWxpYmFpbwp0aHJlYWQ9MQpncm91cF9yZXBvcnRp
bmc9MApkaXJlY3Q9MQpub3JhbmRvbW1hcD0xCnJ3PXJhbmRydwpyd21peHJlYWQ9MApicz00awpp
b2RlcHRoPTE2CnRpbWVfYmFzZWQ9MQpydW50aW1lPTYwCmNwdXNfYWxsb3dlZD05Cgpbam9iMDEw
XQpmaWxlbmFtZT0vZGV2L252bWUwbjEKaW9lbmdpbmU9bGliYWlvCnRocmVhZD0xCmdyb3VwX3Jl
cG9ydGluZz0wCmRpcmVjdD0xCm5vcmFuZG9tbWFwPTEKcnc9cmFuZHJ3CnJ3bWl4cmVhZD0wCmJz
PTRrCmlvZGVwdGg9MTYKdGltZV9iYXNlZD0xCnJ1bnRpbWU9NjAKY3B1c19hbGxvd2VkPTEwCgpb
am9iMDExXQpmaWxlbmFtZT0vZGV2L252bWUwbjEKaW9lbmdpbmU9bGliYWlvCnRocmVhZD0xCmdy
b3VwX3JlcG9ydGluZz0wCmRpcmVjdD0xCm5vcmFuZG9tbWFwPTEKcnc9cmFuZHJ3CnJ3bWl4cmVh
ZD0wCmJzPTRrCmlvZGVwdGg9MTYKdGltZV9iYXNlZD0xCnJ1bnRpbWU9NjAKY3B1c19hbGxvd2Vk
PTExCgpbam9iMDEyXQpmaWxlbmFtZT0vZGV2L252bWUwbjEKaW9lbmdpbmU9bGliYWlvCnRocmVh
ZD0xCmdyb3VwX3JlcG9ydGluZz0wCmRpcmVjdD0xCm5vcmFuZG9tbWFwPTEKcnc9cmFuZHJ3CnJ3
bWl4cmVhZD0wCmJzPTRrCmlvZGVwdGg9MTYKdGltZV9iYXNlZD0xCnJ1bnRpbWU9NjAKY3B1c19h
bGxvd2VkPTEyCgpbam9iMDEzXQpmaWxlbmFtZT0vZGV2L252bWUwbjEKaW9lbmdpbmU9bGliYWlv
CnRocmVhZD0xCmdyb3VwX3JlcG9ydGluZz0wCmRpcmVjdD0xCm5vcmFuZG9tbWFwPTEKcnc9cmFu
ZHJ3CnJ3bWl4cmVhZD0wCmJzPTRrCmlvZGVwdGg9MTYKdGltZV9iYXNlZD0xCnJ1bnRpbWU9NjAK
Y3B1c19hbGxvd2VkPTEzCgpbam9iMDE0XQpmaWxlbmFtZT0vZGV2L252bWUwbjEKaW9lbmdpbmU9
bGliYWlvCnRocmVhZD0xCmdyb3VwX3JlcG9ydGluZz0wCmRpcmVjdD0xCm5vcmFuZG9tbWFwPTEK
cnc9cmFuZHJ3CnJ3bWl4cmVhZD0wCmJzPTRrCmlvZGVwdGg9MTYKdGltZV9iYXNlZD0xCnJ1bnRp
bWU9NjAKY3B1c19hbGxvd2VkPTE0Cgpbam9iMDE1XQpmaWxlbmFtZT0vZGV2L252bWUwbjEKaW9l
bmdpbmU9bGliYWlvCnRocmVhZD0xCmdyb3VwX3JlcG9ydGluZz0wCmRpcmVjdD0xCm5vcmFuZG9t
bWFwPTEKcnc9cmFuZHJ3CnJ3bWl4cmVhZD0wCmJzPTRrCmlvZGVwdGg9MTYKdGltZV9iYXNlZD0x
CnJ1bnRpbWU9NjAKY3B1c19hbGxvd2VkPTE1Cg==
--secu_1e1a996326f675e173a89128911a5535_part1--


