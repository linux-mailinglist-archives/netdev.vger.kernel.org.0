Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 569A5DB9A5
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 00:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438303AbfJQWUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 18:20:22 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:42796 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388926AbfJQWUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 18:20:22 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id x9HMKJ8R116627;
        Thu, 17 Oct 2019 17:20:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1571350819;
        bh=x20vPXT9+XMCHtJql6zEw9A90G+Gk8BFplDkCYRkhmY=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=kjxAiJRl0VSDLNOjFtyihmRU+NeKKjTbarV2XEJ46wwcB5elc45J0wxECWUbWvtHd
         EKzE6a8xLtP8WpkXUNZqeLZe1kIzRhIR1YcGc3MJ5LoLwHFXIkfEjlrIb0cdcU6ehg
         P837cFOe8tK+KtzsTVBNbx2ASZF8RmU9se7SNBrg=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x9HMKJaW114874
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Oct 2019 17:20:19 -0500
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Thu, 17
 Oct 2019 17:20:11 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Thu, 17 Oct 2019 17:20:19 -0500
Received: from [158.218.113.14] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id x9HMKG4f091462;
        Thu, 17 Oct 2019 17:20:17 -0500
Subject: Re: taprio testing - Any help?
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <a69550fc-b545-b5de-edd9-25d1e3be5f6b@ti.com>
 <87v9sv3uuf.fsf@linux.intel.com>
 <7fc6c4fd-56ed-246f-86b7-8435a1e58163@ti.com>
 <87r23j3rds.fsf@linux.intel.com>
 <CA+h21hon+QzS7tRytM2duVUvveSRY5BOGXkHtHOdTEwOSBcVAg@mail.gmail.com>
 <45d3e5ed-7ddf-3d1d-9e4e-f555437b06f9@ti.com>
 <871rve5229.fsf@linux.intel.com>
 <f6fb6448-35f0-3071-bda1-7ca5f4e3e11e@ti.com>
 <87zhi01ldy.fsf@linux.intel.com>
 <c4ff605f-d556-2c68-bcfd-65082ec8f73a@ti.com>
 <87bluf182w.fsf@linux.intel.com>
 <945ee4cd-4628-4805-6429-21611bc6e08a@ti.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <e03d01a0-8a70-6764-1c0e-04386d06a6c8@ti.com>
Date:   Thu, 17 Oct 2019 18:26:04 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <945ee4cd-4628-4805-6429-21611bc6e08a@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vinicius,

On 10/17/2019 05:02 PM, Murali Karicheri wrote:
> On 10/17/2019 03:32 PM, Vinicius Costa Gomes wrote:
>> Murali Karicheri <m-karicheri2@ti.com> writes:
>>>
>>> root@am57xx-evm:~# tc qdisc replace dev eth0 parent root handle 100 
>>> taprio \
>>>   >     num_tc 4 \
>>>   >     map 2 3 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
>>>   >     queues 1@0 1@0 1@0 1@0 \
>>>   >     base-time 1564535762845777831 \
>>>   >     sched-entry S 0xC 15000000 \
>>>   >     sched-entry S 0x2 15000000 \
>>>   >     sched-entry S 0x4 15000000 \
>>>   >     sched-entry S 0x8 15000000 \
>>>   >     txtime-delay 300000 \
>>>   >     flags 0x1 \
>>>   >     clockid CLOCK_TAI
>>> RTNETLINK answers: Invalid argument
>>>
>>> Anything wrong with the command syntax?
>>
>> I tried this example here, and it got accepted ok. I am using the
>> current net-next master. The first thing that comes to mind is that
>> perhaps you backported some old version of some of the patches (so it's
>> different than what's upstream now).
> Was on master of kernel.org. Will try net-next master now.
> 
> Murali
>>
>>
>> Cheers,
>> -- 
>> Vinicius
>>
> 
> 
Today I have tried with RT kernel and it looks great. I can see the
frames in the correct order. Here are the complete set of commands
used with RT kernel. Just used taprio, no ETF. I introduced a guard
band in between schedules. Not sure if that is needed. I will try
without it and see if the capture looks the same.

ifconfig eth0 192.168.2.20
ethtool -L eth0 tx 4
tc qdisc replace dev eth0 parent root handle 100 taprio \
     num_tc 4 \
     map 0 0 2 3 1 1 0 0 0 0 0 0 0 0 0 0 \
     queues 1@0 1@1 1@2 1@3 \
     base-time 1564535762845777831 \
     sched-entry S 0x3 30000000 \
     sched-entry S 0x0 10000000 \
     sched-entry S 0x4 30000000 \
     sched-entry S 0x0 10000000 \
     sched-entry S 0x8 30000000 \
     clockid CLOCK_TAI

iptables -t mangle -A POSTROUTING -p udp --dport 10000 -j CLASSIFY 
--set-class 0:0
iptables -t mangle -A POSTROUTING -p udp --dport 20000 -j CLASSIFY 
--set-class 0:2
iptables -t mangle -A POSTROUTING -p udp --dport 30000 -j CLASSIFY 
--set-class 0:3
iperf -c 192.168.2.10 -u -b50M -p 10000 -t20&
iperf -c 192.168.2.10 -u -b50M -p 20000 -t20&
iperf -c 192.168.2.10 -u -b100M -p 30000 -t20&

Thanks for all your help.

Regards,

Murali
