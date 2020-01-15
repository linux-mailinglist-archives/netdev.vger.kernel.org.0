Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 481AF13CCBB
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 20:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729030AbgAOTCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 14:02:30 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:53796 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728921AbgAOTCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 14:02:30 -0500
Received: from [192.168.1.47] (unknown [50.34.171.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 6124113C362;
        Wed, 15 Jan 2020 11:02:29 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 6124113C362
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1579114949;
        bh=w6vjGXE6QpPKa73RnEVOmKrxKE28MtE07x9axzOYIaI=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=HXhVfXnm1R2rUWPAT66FMRT7MkmvyUG7JfcIZQQdfefPhGmQrziBxHViBTgYV2kJE
         zXyioqUFDqQIpytj1cvKjOZwQAAR0AQpXpQ1Bi5JL2X+lxSNIrXXEJkRs27YUpJ9ZF
         SKLJE/uJHRB20PIrmrfzbG/n8EBWezMjr+1gtS28=
Subject: Re: vrf and multicast is broken in some cases
To:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <e439bcae-7d20-801c-007d-a41e8e9cd5f5@candelatech.com>
 <3906c6fe-e7a7-94c1-9d7d-74050084b56e@gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Message-ID: <dbefe9b1-c846-6cc6-3819-520fd084a447@candelatech.com>
Date:   Wed, 15 Jan 2020 11:02:26 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <3906c6fe-e7a7-94c1-9d7d-74050084b56e@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 01/15/2020 10:45 AM, David Ahern wrote:
> On 1/15/20 10:57 AM, Ben Greear wrote:
>> Hello,
>>
>> We put two different ports into their own VRF, and then tried to run a
>> multicast
>> sender on one and receiver on the other.  The receiver does not receive
>> anything.
>>
>> Is this a known problem?
>>
>> If we do a similar setup with policy based routing rules instead of VRF,
>> then the multicast
>> test works.
>>
>
> It works for OSPF for example. I have lost track of FRR features that
> use it, so you will need to specify more details.
>
> Are the sender / receiver on the same host?

Yes, like eth2 sending to eth3, eth2 is associated with _vrf2, eth3 with _vrf3.

I'll go poking at the code.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
