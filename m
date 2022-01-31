Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125804A4E9B
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 19:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343591AbiAaSjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 13:39:32 -0500
Received: from smtpout30.security-mail.net ([85.31.212.36]:27136 "EHLO
        fx301.security-mail.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S234175AbiAaSj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 13:39:28 -0500
Received: from localhost (localhost [127.0.0.1])
        by fx301.security-mail.net (Postfix) with ESMTP id 6475B24BD2E2
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 19:39:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kalrayinc.com;
        s=sec-sig-email; t=1643654359;
        bh=4n1VaqPm0hmp50/qOB9i9hX5jFADZxUYF3Q24W5yMps=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject;
        b=U2PRELOjIivw90KrAoHo3Hvrb/isUp/D8RiVVE73bakqmUjEk2xALsJRzgdH4/tL3
         1v9vpwVBG4stwya3nBsizhwsGh8kSBQLyoW0k5Z8M53mPd+ddJEHnYEPWLCk4EEkzH
         ykrr8XDNjRcvgST5K43lYJhM6Pcx0YUe/n9AmaVQ=
Received: from fx301 (localhost [127.0.0.1]) by fx301.security-mail.net
 (Postfix) with ESMTP id 180EC24BD2B3; Mon, 31 Jan 2022 19:39:19 +0100 (CET)
Received: from zimbra2.kalray.eu (unknown [217.181.231.53]) by
 fx301.security-mail.net (Postfix) with ESMTPS id A9A9E24BD2BC; Mon, 31 Jan
 2022 19:39:18 +0100 (CET)
Received: from zimbra2.kalray.eu (localhost [127.0.0.1]) by
 zimbra2.kalray.eu (Postfix) with ESMTPS id 59CBD27E03FF; Mon, 31 Jan 2022
 19:39:18 +0100 (CET)
Received: from localhost (localhost [127.0.0.1]) by zimbra2.kalray.eu
 (Postfix) with ESMTP id 4174627E0401; Mon, 31 Jan 2022 19:39:18 +0100 (CET)
Received: from zimbra2.kalray.eu ([127.0.0.1]) by localhost
 (zimbra2.kalray.eu [127.0.0.1]) (amavisd-new, port 10026) with ESMTP id
 rt4lRT81Cv4E; Mon, 31 Jan 2022 19:39:18 +0100 (CET)
Received: from zimbra2.kalray.eu (localhost [127.0.0.1]) by
 zimbra2.kalray.eu (Postfix) with ESMTP id 2DF2E27E03FF; Mon, 31 Jan 2022
 19:39:18 +0100 (CET)
X-Virus-Scanned: E-securemail, by Secumail
Secumail-id: <13469.61f82cd6.79391.0>
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra2.kalray.eu 4174627E0401
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kalrayinc.com;
 s=4F334102-7B72-11EB-A74E-42D0B9747555; t=1643654358;
 bh=TIHxcdvic37w9ZtxsGJx1mEp5nVlzpapNslgAZPg2zE=;
 h=Date:From:To:Message-ID:MIME-Version;
 b=L7Xcy13QzyR7r8ITOhBhJzJzcDOCzUvwf4rSaxuHm9BlL+QlnDbD9hJQ3qJgKwgvw
 N0fl6YqHHhTXM5jpYCFX9FkBq10+l91ROVAI1/84EhjCUFx2ONR1BrIBv+djIDy57z
 VB7KkZTEQROvft4V2Jm3BvKeS4CoXux3/ylaivY9QsfD92qpFYDUUlYsqo/eBCBpk/
 wB+yaregPuZsncJI4j1dlpn/mL3QWfAjMb+ci4TXnISq2nAzKqwabplUJjcyTEy8SA
 i8VJm0pqOtQOxkrco5ul5EPzpfoFj/wYRdwh7dIURlx09sc3eeJRT0e/6Lmq6XqGg1
 9L1AyPpiHG2pg==
Date:   Mon, 31 Jan 2022 19:39:18 +0100 (CET)
From:   Vincent Ray <vray@kalrayinc.com>
To:     linyunsheng <linyunsheng@huawei.com>
Cc:     vladimir oltean <vladimir.oltean@nxp.com>, kuba <kuba@kernel.org>,
        Samuel Jones <sjones@kalrayinc.com>,
        netdev <netdev@vger.kernel.org>, davem <davem@davemloft.net>
Message-ID: <1849185292.2088953.1643654358058.JavaMail.zimbra@kalray.eu>
In-Reply-To: <5e814066-29b1-1968-f5e6-4e30067430b4@huawei.com>
References: <1862202329.1457162.1643113633513.JavaMail.zimbra@kalray.eu>
 <698739062.1462023.1643115337201.JavaMail.zimbra@kalray.eu>
 <1c53c5c0-4e77-723b-4260-de83e8f8e40c@huawei.com>
 <851805746.1848130.1643360285530.JavaMail.zimbra@kalray.eu>
 <175564338.1860581.1643363976935.JavaMail.zimbra@kalray.eu>
 <5e814066-29b1-1968-f5e6-4e30067430b4@huawei.com>
Subject: Re: packet stuck in qdisc
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.40.202]
X-Mailer: Zimbra 9.0.0_GA_4126 (ZimbraWebClient - FF96
 (Linux)/9.0.0_GA_4126)
Thread-Topic: packet stuck in qdisc
Thread-Index: 8rbbn9s5c9+yLqDUYaRQjqEo7xIgtA==
X-ALTERMIMEV2_out: done
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thanks for giving it a try.
Your attached log contains a lot of chinese characters, which makes it quite difficult to read, could you strip them off ?
I guess it is a fio report though.
Can I ask on which kernel you tried ? And how did you proceed to know if the bug was present or not ?
(as I'm sure you're aware, merely looking at fio reported bandwidths is not enough as the holes can sommetimes be quite small or not appear at all
=> it takes some trials to get them, and in my case I scripted over tcpdump to catch them, computing timestamp differences between pkts of the same connection)

I'll try your patch and let you know.
I suppose it's meant to give me a print in dmesg if a pkt gets stuck ?

Thanks,

V

----- Original Message -----
From: "linyunsheng" <linyunsheng@huawei.com>
To: "Vincent Ray" <vray@kalrayinc.com>
Cc: "vladimir oltean" <vladimir.oltean@nxp.com>, "kuba" <kuba@kernel.org>, "Samuel Jones" <sjones@kalrayinc.com>, "netdev" <netdev@vger.kernel.org>, "davem" <davem@davemloft.net>
Sent: Saturday, January 29, 2022 7:53:59 AM
Subject: Re: packet stuck in qdisc

On 2022/1/28 17:59, Vincent Ray wrote:
> Hmm ... sorry, actually I don't think I've seen this pb on a native host (because mine has an older kernel version and I did not change it), though I suppose it could happen too.
> 

Hi,
  I have tested NVME-over-TCP in a native arm64 host, which does not seems
to have the problem, the test log is in the attachment.

A debug patch in the attachment can be used to catch the packet_stuck_in_
qdisc problem, maybe give it a try.


> 
> ----- Original Message -----
> From: "Vincent Ray" <vray@kalrayinc.com>
> To: "linyunsheng" <linyunsheng@huawei.com>
> Cc: "vladimir oltean" <vladimir.oltean@nxp.com>, "kuba" <kuba@kernel.org>, "Samuel Jones" <sjones@kalrayinc.com>, "netdev" <netdev@vger.kernel.org>, "davem" <davem@davemloft.net>
> Sent: Friday, January 28, 2022 9:58:05 AM
> Subject: Re: packet stuck in qdisc
> 
> Hello,
> 
> It seems the problem can be reproduced easily. Is there some testcase without
> hw dependency, so that I can reproduce the problem myself?
> 
> [VR]
> Well, in my case, I produced it with the setup described below, which does include the Kalray board.
> However, I am quite confident this has nothing to do with the board, not even with any particular Host NIC / cable, so that you can surely reproduce it in a different environment.
> I think you just need to send some NVME-over-TCP traffic to any target able to receive it. In fact I suspect that any TCP traffic will do.
> Attached is the fio test case we are running after doing the following nvme connect :
> nvme connect -n nqn.2014-06.com.kalrayinc:nvme:ecca9057-4b59-5332-8d75-5acdcdd8a88e -t tcp -i 4 -a 10.20.0.1'      
> And then simply
> fio ./fio_jobs_randwr4k_60s.spdk
> 
> 
> Which cpu is used in the testing? It seems the cpu arch's
> memory semantic is importance when handling the rare case.
> 
> [VR] 
> It's x86_64
> FWIW, I've seen the problem happen both on native host and whithin a VM (be vcpu pinned or not, be fio threads pinned or not).
> 
> 
> ----- Original Message -----
> From: "linyunsheng" <linyunsheng@huawei.com>
> To: "Vincent Ray" <vray@kalrayinc.com>, "vladimir oltean" <vladimir.oltean@nxp.com>, "kuba" <kuba@kernel.org>, "davem" <davem@davemloft.ne>
> Cc: "Samuel Jones" <sjones@kalrayinc.com>, "netdev" <netdev@vger.kernel.org>
> Sent: Friday, January 28, 2022 3:36:27 AM
> Subject: Re: packet stuck in qdisc
> 
> On 2022/1/25 20:55, Vincent Ray wrote:
>> Dear kernel maintainers / developers,
>>
>> I work at Kalray where we are developping an NVME-over-TCP target controller board.
>> My setup is as such :
>> - a development workstation running Linux 5.x.y (the host)
>> - sending NVME-TCP traffic to our board, to which it is connected through a Mellanox NIC (Connect-X-5) and a 100G ETH cable
>>
>> While doing performance tests, using simple fio scenarios running over the regular kernel nvme-tcp driver on the host, we noticed important performance variations.
>> After some digging (using tcpdump on the host), we found that there were big "holes" in the tcp traffic sent by the host.
>> The scenario we observed is the following :
>> 1) a TCP segment gets lost (not sent by the host) on a particular TCP connection, leading to a gap in the seq numbers received by the board
>> 2) the board sends dup-acks and/or sacks (if configured) to signal this loss
>> 3) then, sometimes, the host stops emitting on that TCP connection for several seconds (as much as 14s observed)
>> 4) finally the host resumes emission, sending the missing packet
>> 5) then the TCP connection continues correctly with the appropriate throughput
>>
>> Such a scenario can be observed in the attached tcpdump (+ comments).
> 
> Hi,
>     Thanks for reporting the problem.
> 
>>
>> We noticed that this was happening only in recent versions of the kernel, so we dichotomized until we found the culprit commits :
>> we believe that the bug was introduced in qdisc updates for 5.14.rc1 by this set of commits, more precisely the middle one :
>>
>> [2021-06-22] d3e0f57 Yunsheng Lin net: sched: remove qdisc->empty for lockless qdisc
>> [2021-06-22] c4fef01 Yunsheng Lin net: sched: implement TCQ_F_CAN_BYPASS for lockless qdisc    *=> KO*
>> [2021-06-22] dd25296 Yunsheng Lin net: sched: avoid unnecessary seqcount operation for lockless qdisc   *=> still OK*
>>
>> As far as I can tell, the bug is still present in the mainline (at least it was in 5.16-rc4).
>> From what I understand / guess, some optimizations in lockless qdiscs have lead to a race making the qdisc unaware that a packet has been enqueued and is waiting for emission.
>> I suspect that, when this happens with TCP packets "to be retransmitted", the TCP stack will not timeout and try to retransmitt again because it uses skb_still_in_host_queue() to avoid useless re-retransmissions
>> From net/ipv4/ tcp_output.c :
>> //* Thanks to skb fast clones, we can detect if a prior transmit of                                                                                                                                                   /
>> / * a packet is still in a qdisc or driver queue.                                                                                                                                                                     /
>> / * In this case, there is very little point doing a retransmit !                                                                                                                                                     /
>> / */  /
>> I guess this plays a role in making these holes grow up to 14s, and an other layer than TCP might not experience it (?).
>>
>> The interface through which my traffic is going is :
>> eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
>>     link/ether b8:ce:f6:60:c9:97 brd ff:ff:ff:ff:ff:ff
>>     inet 10.20.0.254/24 scope global eth3
>>
>> As you can see, it uses a mq qdisc. I did not try with other qdiscs yet.
>>
>> Finally, if/when troubleshooting this problem in kernels older than 5.14.7, it's a good idea to first cherry-pick this patch :
>> [2021-09-09] ae66447 Keith Busch nvme-tcp: fix io_work priority inversion
>> because it fixes a nvme-tcp bug whose performance impact is itself so big that it "hides" the one we've discovered (bringing itself lots of holes at the nvme-tcp layer ...)
>>
>> On impacted kernels, the "pkt_stuck_in_qdisc" bug shows up in the order of zero to a few occurences per minute per TCP connection.
> 
> It seems the problem can be reproduced easily. Is there some testcase without
> hw dependency, so that I can reproduce the problem myself?
> 
>>
>> I did not really have time to understand it thoroughly, nor am I a network stack expert, so I don't propose any particular patch for it but I'll be happy to help testing fix attempts if it can help.
>> Please feel free to ask any additional information.
> 
> Which cpu is used in the testing? It seems the cpu arch's
> memory semantic is importance when handling the rare case.
> 
> 
>> Best regards,
>>
>>
>> *Vincent Ray*
>> *Senior Architect • Kalray*
>> Phone: +33 6 43 94 87 65
>> _vray@kalrayinc.com_ • _www.kalrayinc.com_ <https://www.kalrayinc.com>
>>
>> Kalray logo <https://www.kalrayinc.com>
>> 	
>> Intelligent Data Processing
>> From Cloud to Edge
>>
>>
>> *Please consider the environment before printing this e-mail.*
>> This message contains information that may be privileged or confidential and is the property of Kalray S.A. It is intended only for the person to whom it is addressed. If you are not the intended recipient, you are not authorized to print, retain, copy, disseminate, distribute, or use this message or any part thereof. If you receive this message in error, please notify the sender immediately and delete all copies of this message.
>>
> 
> 
> To declare a filtering error, please use the following link : https://www.security-mail.net/reporter.php?mid=12154.61f356b5.a06c1.0&r=vray%40kalrayinc.com&s=linyunsheng%40huawei.com&o=Re%3A+packet+stuck+in+qdisc&verdict=C&c=d26dcdd346e4be7ae9b35c1fc91bb6e71c6850cc
> 
> 
> 
> 
> .
> 


To declare a filtering error, please use the following link : https://www.security-mail.net/reporter.php?mid=5ee2.61f4e48d.74be3.0&r=vray%40kalrayinc.com&s=linyunsheng%40huawei.com&o=Re%3A+packet+stuck+in+qdisc&verdict=C&c=d4f5100780ea6759b09ab4ac15ae24cb8575b3e5




