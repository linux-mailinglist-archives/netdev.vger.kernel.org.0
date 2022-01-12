Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06B1148CB58
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 19:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356564AbiALSyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 13:54:14 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:34862 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1356492AbiALSyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 13:54:10 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.64.31])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id BFB901A0077;
        Wed, 12 Jan 2022 18:54:07 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 7AAAB600090;
        Wed, 12 Jan 2022 18:54:07 +0000 (UTC)
Received: from [192.168.1.115] (unknown [98.97.67.209])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 90EFE13C2B0;
        Wed, 12 Jan 2022 10:54:06 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 90EFE13C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1642013646;
        bh=18JHKYoijzKhwxOAHnClxE6HqlN0qZIuv34vN6JbojY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=bNxp25U+COtYMNYuUePxhaB3GzSh3UUEnboY5pblREo/5qWoSv46WkigGI66eh3sJ
         C7LoAJYvL88/yQnF6Vrr51nvFXbPMWcT7FSSTyELNNIyIggjUTKUvrdIVxZCA+pvDH
         F42yY/PULPHGinsxkd0wk8AJrizZD1l9vlcYVxJ4=
Subject: Re: Debugging stuck tcp connection across localhost [snip]
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        netdev <netdev@vger.kernel.org>
References: <38e55776-857d-1b51-3558-d788cf3c1524@candelatech.com>
 <CADVnQyn97m5ybVZ3FdWAw85gOMLAvPSHiR8_NC_nGFyBdRySqQ@mail.gmail.com>
 <b3e53863-e80e-704f-81a2-905f80f3171d@candelatech.com>
 <CADVnQymJaF3HoxoWhTb=D2wuVTpe_fp45tL8g7kaA2jgDe+xcQ@mail.gmail.com>
 <a6ec30f5-9978-f55f-f34f-34485a09db97@candelatech.com>
 <CADVnQym9LTupiVCTWh95qLQWYTkiFAEESv9Htzrgij8UVqSHBQ@mail.gmail.com>
 <b60aab98-a95f-d392-4391-c0d5e2afb2cd@candelatech.com>
 <9330e1c7-f7a2-0f1e-0ede-c9e5353060e3@candelatech.com>
 <0b2b06a8-4c59-2a00-1fbc-b4734a93ad95@gmail.com>
 <c84d0877-43a1-9a52-0046-e26b614a5aa6@candelatech.com>
 <CANn89iL=690zdpCS7g1vpZdZCHsj0O1MrOjGkcg0GPLVhjr4RQ@mail.gmail.com>
 <a7056912-213d-abb9-420d-b7741ae5db8a@candelatech.com>
 <CANn89i+HnhfCKUVxtVhQ1vv74zO1tEwT2yXcCX_OoXf14WGAQg@mail.gmail.com>
 <a503d7b8-b015-289c-1a8a-eb4d5df7fb12@candelatech.com>
 <a31557d8-13da-07e2-7a64-ce07e786f25c@candelatech.com>
 <CANn89iK2iM=fM=EN3v3jfOfHRS4HKzbShLcnHt78U+OjnmeVjg@mail.gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <05ae90a3-4fc4-45aa-c001-fb26334332c4@candelatech.com>
Date:   Wed, 12 Jan 2022 10:54:05 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CANn89iK2iM=fM=EN3v3jfOfHRS4HKzbShLcnHt78U+OjnmeVjg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
X-MDID: 1642013648-zZsS4n31LdoS
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/12/22 10:47 AM, Eric Dumazet wrote:
> On Wed, Jan 12, 2022 at 10:44 AM Ben Greear <greearb@candelatech.com> wrote:
> 
>> Well, I think maybe I found the problem.
>>
>> I looked in the right place at the right time and saw that the kernel was spewing about
>> neigh entries being full.  The defaults are too small for the number of interfaces
>> we are using.  Our script that was supposed to set the thresholds higher had a typo
>> in it that caused it to not actually set the values.
>>
>> When the neigh entries are fully consumed, then even communication across 127.0.0.1
>> fails in somewhat mysterious ways, and I guess this can break existing connections
>> too, not just new connections.
> 
> Nice to hear this is not a TCP bug ;)

For sure...it took me a long time to get brave enough to even suggest it might
be on a public list :)

That said, might be nice to always reserve a neigh entry for localhost
at least...can't be that hard to arp for it!

--Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
