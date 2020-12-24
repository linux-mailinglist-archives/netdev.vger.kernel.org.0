Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 191F12E24C8
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 07:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgLXGYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 01:24:18 -0500
Received: from outbound-relay4.guardedhost.com ([216.239.133.204]:37027 "EHLO
        outbound-relay4.guardedhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725747AbgLXGYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 01:24:18 -0500
Received: from mail.guardedhost.com (tev-mx4.omnis.com [216.239.133.144])
        by outbound-relay1.guardedhost.com (Postfix) with ESMTP id 4D1g4n1rFCz4x889;
        Thu, 24 Dec 2020 06:23:37 +0000 (GMT)
Received: from Alans-MacBook-Pro.local (c-73-254-147-133.hsd1.wa.comcast.net [73.254.147.133])
        (Authenticated sender: alanp@snowmoose.com)
        by mail.guardedhost.com (Postfix) with ESMTPSA id 4D1g4m20qtz30L6;
        Thu, 24 Dec 2020 06:23:36 +0000 (GMT)
Subject: Re: [PATCH] rdma.8: Add basic description for users unfamiliar with
 rdma
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     netdev@vger.kernel.org
References: <eb358848-49a8-1a8e-3919-c07b6aa3d21d@snowmoose.com>
 <20201223081918.GF3128@unreal>
From:   Alan Perry <alanp@snowmoose.com>
Organization: Snowmoose Software
Message-ID: <ca3df1b2-f347-051b-1c47-3d2b187965a9@snowmoose.com>
Date:   Wed, 23 Dec 2020 22:23:34 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201223081918.GF3128@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Authentication-Results: mail.guardedhost.com;auth=pass
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse-Id: 8E613C28-45B0-11EB-8AB6-EADA428D60A2
X-Virus-Scanned: clamav-milter 0.102.2 at tev-mx4.omnis.com
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/23/20 12:19 AM, Leon Romanovsky wrote:
> On Tue, Dec 22, 2020 at 08:47:51PM -0800, Alan Perry wrote:
>> Add a description section with basic info about the rdma command for users
>> unfamiliar with it.
>>
>> Signed-off-by: Alan Perry <alanp@snowmoose.com>
>> ---
>>   man/man8/rdma.8 | 6 +++++-
>>   1 file changed, 5 insertion(+), 1 deletion(-)
>>
>> diff --git a/man/man8/rdma.8 b/man/man8/rdma.8
>> index c9e5d50d..d68d0cf6 100644
>> --- a/man/man8/rdma.8
>> +++ b/man/man8/rdma.8
>> @@ -1,4 +1,4 @@
>> -.TH RDMA 8 "28 Mar 2017" "iproute2" "Linux"
>> +.TH RDMA 8 "22 Dec 2020" "iproute2" "Linux"
>>   .SH NAME
>>   rdma \- RDMA tool
>>   .SH SYNOPSIS
>> @@ -29,6 +29,10 @@ rdma \- RDMA tool
>>   \fB\-j\fR[\fIson\fR] }
>>   \fB\-p\fR[\fIretty\fR] }
>>
>> +.SH DESCRIPTION
>> +.B rdma
>> +is a tool for querying and setting the configuration for RDMA, direct
>> memory access between the memory of two computers without use of the
>> operating system on either computer.
>> +
> 
> Thanks, it is too close to the Wikipedia description that can be written
> slightly differently (without "two computers"), what about the following
> description from Mellanox site?
> 
> "is a tool for querying and setting the configuration for RDMA-capable
> devices. Remote direct memory access (RDMA) is the ability of accessing
> (read, write) memory on a remote machine without interrupting the processing
> of the CPU(s) on that system."
> 
> Thanks,
> Acked-by: Leon Romanovsky <leonro@nvidia.com>
> 

That change looks good to me.

One other change that I wanted to make, but couldn't figure out how to 
do it without it in a manner wasn't awkward is to make it more clear in 
the rdma.8 man page that the other rdma man pages describe the rdma 
"object" variants. That wasn't immediately clear to me the first couple 
times that I read the rdma.8 page.

alan

