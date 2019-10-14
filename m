Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D524D6798
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 18:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388205AbfJNQoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 12:44:39 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:59674 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727038AbfJNQoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 12:44:39 -0400
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 56577137532;
        Mon, 14 Oct 2019 09:44:30 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 56577137532
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1571071470;
        bh=mI8UfAcc7WMDcyJ67/lSgJIl6uccJ/9yZfF+RyqVkWU=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=cM8fqyXXNrLtPKiXXOlcU3/Ur5Ihq1c/MRBUc72MqriTxMjkiU0d+zoIXWzvaJDYR
         iqwv85gAgZ7HkDpj7QxhjP8Jm2/pEcza0HK/WstnNFGUv7aurbiIkJeBcFU6HIJADy
         6NeToJ6VmZaDlzb3VlKmrDvfD7HP7EFEgKEYwsuE=
Subject: Re: IPv6 addr and route is gone after adding port to vrf (5.2.0+)
To:     David Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>
References: <c55619f8-c565-d611-0261-c64fa7590274@candelatech.com>
 <2a53ff58-9d5d-ac22-dd23-b4225682c944@gmail.com>
 <ca625841-6de8-addb-9b85-8da90715868c@candelatech.com>
 <e3f2990e-d3d0-e615-8230-dcfe76451c15@gmail.com>
 <3cd9b1a7-bf87-8bd2-84f4-503f300e847b@candelatech.com>
 <b236a2b6-a959-34cf-4d15-142a7b594ab0@gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <ac69c921-66d1-b381-d79b-e723567c9228@candelatech.com>
Date:   Mon, 14 Oct 2019 09:44:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <b236a2b6-a959-34cf-4d15-142a7b594ab0@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11/19 1:35 PM, David Ahern wrote:
> On 10/11/19 7:57 AM, Ben Greear wrote:
>>> The down-up cycling is done on purpose - to clear out neigh entries and
>>> routes associated with the device under the old VRF. All entries must be
>>> created with the device in the new VRF.
>>
>> I believe I found another thing to be aware of relating to this.
>>
>> My logic has been to do supplicant, then do DHCP, and only when DHCP
>> responds do I set up the networking for the wifi station.
>>
>> It is at this time that I would be creating a VRF (or using routing rules
>> if not using VRF).
>>
>> But, when I add the station to the newly created vrf, then it bounces it,
>> and that causes supplicant to have to re-associate  (I think, lots of
>> moving
>> pieces, so I could be missing something).
>>
>> Any chance you could just clear the neighbor entries and routes w/out
>> bouncing
>> the interface?
> 
> yes, it is annoying. I have been meaning to fix that, but never found
> the motivation to do it. If you have the time, it would be worth
> avoiding the overhead.

I changed my code so that it adds to the vrf first, so I too am lacking
motivation and time to dig into the kernel at the moment.  I'll let you know
if I find time to work on it.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

