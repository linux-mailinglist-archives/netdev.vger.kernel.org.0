Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A13B14FF753
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 15:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbiDMNDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 09:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbiDMNDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 09:03:38 -0400
Received: from fx308.security-mail.net (smtpout30.security-mail.net [85.31.212.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86DF25DE65
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 06:01:16 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by fx308.security-mail.net (Postfix) with ESMTP id E8DB04C1F61
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 15:01:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kalrayinc.com;
        s=sec-sig-email; t=1649854875;
        bh=C5jb2gUVw2lbnJ56y7ZrVUjzaArCHYGx57W7dS7Hv+4=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject;
        b=GV3XvF6ydR7xQiYgfhTryH5vxuAfqZwqilyBs8reF9oNjxjuml4nyLuQrEhRayNgC
         jDxmDWUp4TCe1on/cWrP1681lhxqZDKv1iQ6yq9Vr2B6/YBQunI/VWh+2uKRgpliZu
         VMf+WVVplhKAUbfCBS9IQadm0jFp0x4scjF8iLBw=
Received: from fx308 (localhost [127.0.0.1]) by fx308.security-mail.net
 (Postfix) with ESMTP id 28A594C1F25; Wed, 13 Apr 2022 15:01:14 +0200 (CEST)
Received: from zimbra2.kalray.eu (unknown [217.181.231.53]) by
 fx308.security-mail.net (Postfix) with ESMTPS id A6C0D4C1F13; Wed, 13 Apr
 2022 15:01:13 +0200 (CEST)
Received: from zimbra2.kalray.eu (localhost [127.0.0.1]) by
 zimbra2.kalray.eu (Postfix) with ESMTPS id 86BFB27E045B; Wed, 13 Apr 2022
 15:01:13 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1]) by zimbra2.kalray.eu
 (Postfix) with ESMTP id 6DFE927E045F; Wed, 13 Apr 2022 15:01:13 +0200 (CEST)
Received: from zimbra2.kalray.eu ([127.0.0.1]) by localhost
 (zimbra2.kalray.eu [127.0.0.1]) (amavisd-new, port 10026) with ESMTP id
 vFb-Qz3XzAZQ; Wed, 13 Apr 2022 15:01:13 +0200 (CEST)
Received: from zimbra2.kalray.eu (localhost [127.0.0.1]) by
 zimbra2.kalray.eu (Postfix) with ESMTP id 5A2DB27E045B; Wed, 13 Apr 2022
 15:01:13 +0200 (CEST)
X-Virus-Scanned: E-securemail, by Secumail
Secumail-id: <1537a.6256c999.a597c.0>
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra2.kalray.eu 6DFE927E045F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kalrayinc.com;
 s=4F334102-7B72-11EB-A74E-42D0B9747555; t=1649854873;
 bh=KWf5SOiFzubpbIftkSOPjofJAUh180tzPTZYKncwPsM=;
 h=Date:From:To:Message-ID:MIME-Version;
 b=f3gyHDvmqGaJM6aXWIZsawfSWUSitV2nnP438aJMCOgotaMizDPqz1t7hhx0vKanB
 nnb3zsQCSJQ5WSKGkrRAUuagX4nfbK1aall3ADT2FA96P2KZfPKCz7vsNWUoZKpyjI
 I27kww4uXA8xc9GtMd7+r8i7CXvhutJ+vtCf7YwVJ3T6YJXsZ5KVLC6uRq7wUoTew6
 rZnIJrCkF4uKYgGDAz0ytyWBPwS+YbFw+icyBDzDhKl24/yBYrUkBLlcrUvEn5JSLL
 mTUKosFWNnWMZ5a+KYN5SaiJQ1YVlkfYgOPQOKi/co68lu+pdsHDVOuokrb4zS+ve7
 bZydPf8HdmL0w==
Date:   Wed, 13 Apr 2022 15:01:13 +0200 (CEST)
From:   Vincent Ray <vray@kalrayinc.com>
To:     linyunsheng <linyunsheng@huawei.com>
Cc:     vladimir oltean <vladimir.oltean@nxp.com>, kuba <kuba@kernel.org>,
        davem <davem@davemloft.net>, Samuel Jones <sjones@kalrayinc.com>,
        netdev <netdev@vger.kernel.org>,
        =?utf-8?b?5pa55Zu954Ks?= <guoju.fgj@alibaba-inc.com>
Message-ID: <1359936158.10849094.1649854873275.JavaMail.zimbra@kalray.eu>
In-Reply-To: <969086798.7658413.1648197914959.JavaMail.zimbra@kalray.eu>
References: <1862202329.1457162.1643113633513.JavaMail.zimbra@kalray.eu>
 <698739062.1462023.1643115337201.JavaMail.zimbra@kalray.eu>
 <1c53c5c0-4e77-723b-4260-de83e8f8e40c@huawei.com>
 <0d6e8178-953a-82c9-329c-241bd311dbf9@huawei.com>
 <969086798.7658413.1648197914959.JavaMail.zimbra@kalray.eu>
Subject: Re: packet stuck in qdisc
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.40.202]
X-Mailer: Zimbra 9.0.0_GA_4126 (ZimbraWebClient - FF99
 (Linux)/9.0.0_GA_4126)
Thread-Topic: packet stuck in qdisc
Thread-Index: DcZRcSeliYiQfqvuboiF+EvMd0YX2ZLImBsm
X-ALTERMIMEV2_out: done
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linyun,

I tried quoju's patch (on 5.15.0)but it did not make any difference, the pb is still there.

I tried applying your debug patch but can't seem to find the right sha1 where to apply it smoothly.
I guess this is because you made it based on a netdev branch, while I've been trying to apply it on various versions of the stable repo.

=> what do you suggest ?
- should I try to apply it "manually" to whatever stable version suits me (e.g. 5.15 or 5.17 why not) ?
- or should I clone a netdev repo and apply it there ? In this case can you please give me the exact sha1 to use ?

Thanks,

V
 

----- Original Message -----
From: "Vincent Ray" <vray@kalrayinc.com>
To: "linyunsheng" <linyunsheng@huawei.com>
Cc: "vladimir oltean" <vladimir.oltean@nxp.com>, "kuba" <kuba@kernel.org>, "davem" <davem@davemloft.net>, "Samuel Jones" <sjones@kalrayinc.com>, "netdev" <netdev@vger.kernel.org>, "方国炬" <guoju.fgj@alibaba-inc.com>
Sent: Friday, March 25, 2022 9:45:14 AM
Subject: Re: packet stuck in qdisc

OK I'll try that, thank you LinYun.

(I'm sorry for the delay in my answers, I haven't been able to try your debug patch yet because I've had other problems with my setup, preventing me from reproducing the issue in the first place, but it should be ok soon)

----- Original Message -----
From: "linyunsheng" <linyunsheng@huawei.com>
To: "Vincent Ray" <vray@kalrayinc.com>, "vladimir oltean" <vladimir.oltean@nxp.com>, "kuba" <kuba@kernel.org>, "davem" <davem@davemloft.net>
Cc: "Samuel Jones" <sjones@kalrayinc.com>, "netdev" <netdev@vger.kernel.org>, "方国炬" <guoju.fgj@alibaba-inc.com>
Sent: Friday, March 25, 2022 7:16:02 AM
Subject: Re: packet stuck in qdisc

On 2022/1/28 10:36, Yunsheng Lin wrote:
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

Hi,
   It seems guoju from alibaba has a similar problem as above.
   And they fixed it by adding a smp_mb() barrier between spin_unlock()
and test_bit() in qdisc_run_end(), please see if it fixes your problem.

> 
>>



To declare a filtering error, please use the following link : https://www.security-mail.net/reporter.php?mid=5ef9.623d5e27.9b9df.0&r=vray%40kalrayinc.com&s=linyunsheng%40huawei.com&o=Re%3A+packet+stuck+in+qdisc&verdict=C&c=7b4f9607053f62d4edea3c79310a8bd5d5e63628




