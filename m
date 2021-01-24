Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A96301E0C
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 19:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbhAXSKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 13:10:44 -0500
Received: from outbound-relay4.guardedhost.com ([216.239.133.204]:39525 "EHLO
        outbound-relay4.guardedhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725911AbhAXSKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 13:10:43 -0500
Received: from mail.guardedhost.com (tev-mx5.omnis.com [216.239.133.152])
        by outbound-relay1.guardedhost.com (Postfix) with ESMTP id 4DP1HY38XGz4x77Y;
        Sun, 24 Jan 2021 18:10:01 +0000 (GMT)
Received: from Alans-MacBook-Pro.local (unknown [45.86.203.226])
        (Authenticated sender: alanp@snowmoose.com)
        by mail.guardedhost.com (Postfix) with ESMTPSA id 4DP1HW428tz30My;
        Sun, 24 Jan 2021 18:09:59 +0000 (GMT)
Subject: [PATCH v2] rdma.8: Add basic description for users unfamiliar with
 rdma
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     netdev@vger.kernel.org
References: <eb358848-49a8-1a8e-3919-c07b6aa3d21d@snowmoose.com>
 <20201223081918.GF3128@unreal>
 <7e80d241-d33c-8bb2-08a5-cdc11f2a3e80@snowmoose.com>
 <20210124063126.GD4742@unreal>
From:   Alan Perry <alanp@snowmoose.com>
Organization: Snowmoose Software
Message-ID: <297f2af6-d85e-1adb-51b9-aa9bf17c99b8@snowmoose.com>
Date:   Sun, 24 Jan 2021 10:09:55 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210124063126.GD4742@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Authentication-Results: mail.guardedhost.com;auth=pass
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse-Id: 6021D58E-5E6F-11EB-8B4A-DF4409F149D9
X-Virus-Scanned: clamav-milter 0.102.2 at tev-mx5.omnis.com
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Add a description section with basic info about the rdma command for users
unfamiliar with it.

Signed-off-by: Alan Perry <alanp@snowmoose.com>
---
   man/man8/rdma.8 | 9 ++++++++-
   1 file changed, 8 insertion(+), 1 deletion(-)
diff --git a/man/man8/rdma.8 b/man/man8/rdma.8
index c9e5d50d..66ef9902 100644
--- a/man/man8/rdma.8
+++ b/man/man8/rdma.8
@@ -1,4 +1,4 @@
-.TH RDMA 8 "28 Mar 2017" "iproute2" "Linux"
+.TH RDMA 8 "24 Jan 2021" "iproute2" "Linux"
  .SH NAME
  rdma \- RDMA tool
  .SH SYNOPSIS
@@ -29,6 +29,13 @@ rdma \- RDMA tool
  \fB\-j\fR[\fIson\fR] }
  \fB\-p\fR[\fIretty\fR] }

+.SH DESCRIPTION
+.B rdma
+is a tool for querying and setting the configuration for RDMA-capable
+devices. Remote direct memory access (RDMA) is the ability of accessing
+(reading, writing) memory on a remote machine without interrupting the
+processing of the CPU(s) on that system.
+
  .SH OPTIONS

  .TP

On 1/23/21 10:31 PM, Leon Romanovsky wrote:
> On Thu, Jan 21, 2021 at 01:32:42PM -0800, Alan Perry wrote:
>>
>> On 12/23/20 12:19 AM, Leon Romanovsky wrote:
>>> On Tue, Dec 22, 2020 at 08:47:51PM -0800, Alan Perry wrote:
>>>> Add a description section with basic info about the rdma command for users
>>>> unfamiliar with it.
>>>>
>>>> Signed-off-by: Alan Perry <alanp@snowmoose.com>
>>>> ---
>>>>    man/man8/rdma.8 | 6 +++++-
>>>>    1 file changed, 5 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/man/man8/rdma.8 b/man/man8/rdma.8
>>>> index c9e5d50d..d68d0cf6 100644
>>>> --- a/man/man8/rdma.8
>>>> +++ b/man/man8/rdma.8
>>>> @@ -1,4 +1,4 @@
>>>> -.TH RDMA 8 "28 Mar 2017" "iproute2" "Linux"
>>>> +.TH RDMA 8 "22 Dec 2020" "iproute2" "Linux"
>>>>    .SH NAME
>>>>    rdma \- RDMA tool
>>>>    .SH SYNOPSIS
>>>> @@ -29,6 +29,10 @@ rdma \- RDMA tool
>>>>    \fB\-j\fR[\fIson\fR] }
>>>>    \fB\-p\fR[\fIretty\fR] }
>>>>
>>>> +.SH DESCRIPTION
>>>> +.B rdma
>>>> +is a tool for querying and setting the configuration for RDMA, direct
>>>> memory access between the memory of two computers without use of the
>>>> operating system on either computer.
>>>> +
>>> Thanks, it is too close to the Wikipedia description that can be written
>>> slightly differently (without "two computers"), what about the following
>>> description from Mellanox site?
>>>
>>> "is a tool for querying and setting the configuration for RDMA-capable
>>> devices. Remote direct memory access (RDMA) is the ability of accessing
>>> (read, write) memory on a remote machine without interrupting the processing
>>> of the CPU(s) on that system."
>>>
>>> Thanks,
>>> Acked-by: Leon Romanovsky <leonro@nvidia.com>
>>>
>> I noticed that the rdma man page has not been changed. I am unfamiliar with
>> the process. Should I have submitted an updated patch with the alternate
>> wording after this exchange?
> Yes, please.
>
> Thanks
>
>> alan
