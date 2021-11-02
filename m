Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 779BD442A36
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 10:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbhKBJTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 05:19:46 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17628 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229778AbhKBJTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 05:19:46 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A28F9Jc005079;
        Tue, 2 Nov 2021 09:17:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=FLd5RSjJr+xZynLCe23tKIMeeec5tHEOiik/P5NvSFU=;
 b=bhgWZlXHJXwNsFAa+JCx/E2RmF6Hfq0+dm57TaWp3BrL4FXX4tLRTrxt99H484HNhYUB
 /9VtypeteqAtnSXyh34FgOM6EcLtbbmbBHLLHJNCJQ3SHWBjwzfASRWqw1tvH/yBnAXt
 HRrlN/XDy8y6qI9kVynLGZI/T7nvCnaUcdD7a2pEDHzXQhVgsjffT8hkcICip+I1/l2/
 OeIk7ez+Qn3k4UWRyY4viMCsKplH2w4MdQHPzEWaBJcdUUYegCYg/dgndMyFZhakRFcv
 TK4JFyMJZALGCuQWRt2mOyJhDEGOeT1ySwo1Q+UDfPv7ueuu8zb6j1POPsJfEktmETWo lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c2p6sx4jy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Nov 2021 09:17:10 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A29FQMK023777;
        Tue, 2 Nov 2021 09:17:09 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c2p6sx4j0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Nov 2021 09:17:09 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A29DQKc029695;
        Tue, 2 Nov 2021 09:17:07 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3c0wp9hhk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Nov 2021 09:17:07 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A29H4wg3867248
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Nov 2021 09:17:04 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5BEE84C040;
        Tue,  2 Nov 2021 09:17:04 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D14684C04E;
        Tue,  2 Nov 2021 09:17:03 +0000 (GMT)
Received: from [9.145.173.195] (unknown [9.145.173.195])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  2 Nov 2021 09:17:03 +0000 (GMT)
Message-ID: <ca2a567b-915e-c4e1-96cf-2c03ff74aad5@linux.ibm.com>
Date:   Tue, 2 Nov 2021 10:17:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH net 1/4] Revert "net/smc: don't wait for send buffer space
 when data was already sent"
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        jacob.qi@linux.alibaba.com, xuanzhuo@linux.alibaba.com,
        guwen@linux.alibaba.com, dust.li@linux.alibaba.com
References: <20211027085208.16048-1-tonylu@linux.alibaba.com>
 <20211027085208.16048-2-tonylu@linux.alibaba.com>
 <9bbd05ac-5fa5-7d7a-fe69-e7e072ccd1ab@linux.ibm.com>
 <20211027080813.238b82ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <06ae0731-0b9b-a70d-6479-de6fe691e25d@linux.ibm.com>
 <20211027084710.1f4a4ff1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <c6396899-cf99-e695-fc90-3e21e95245ed@linux.ibm.com>
 <20211028073827.421a68d7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YX+RaKfBVzFokQON@TonyMac-Alibaba>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <YX+RaKfBVzFokQON@TonyMac-Alibaba>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gdLXfumuGudqut9m5qBjztAK6_wSqbgW
X-Proofpoint-ORIG-GUID: RV9iiQqApjuwfFhtlbFGtbFGeHltl2Tk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-02_06,2021-11-01_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 malwarescore=0 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 impostorscore=0 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111020054
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/11/2021 08:04, Tony Lu wrote:
> On Thu, Oct 28, 2021 at 07:38:27AM -0700, Jakub Kicinski wrote:
>> On Thu, 28 Oct 2021 13:57:55 +0200 Karsten Graul wrote:
>>> So how to deal with all of this? Is it an accepted programming error
>>> when a user space program gets itself into this kind of situation?
>>> Since this problem depends on internal send/recv buffer sizes such a
>>> program might work on one system but not on other systems.
>>
>> It's a gray area so unless someone else has a strong opinion we can
>> leave it as is.
> 
> Things might be different. IMHO, the key point of this problem is to
> implement the "standard" POSIX socket API, or TCP-socket compatible API.
> 
>>> At the end the question might be if either such kind of a 'deadlock'
>>> is acceptable, or if it is okay to have send() return lesser bytes
>>> than requested.
>>
>> Yeah.. the thing is we have better APIs for applications to ask not to
>> block than we do for applications to block. If someone really wants to
>> wait for all data to come out for performance reasons they will
>> struggle to get that behavior. 
> 
> IMO, it is better to do something to unify this behavior. Some
> applications like netperf would be broken, and the people who want to use
> SMC to run basic benchmark, would be confused about this, and its
> compatibility with TCP. Maybe we could:
> 1) correct the behavior of netperf to check the rc as we discussed.
> 2) "copy" the behavior of TCP, and try to compatiable with TCP, though
> it is a gray area.

I have a strong opinion here, so when the question is if the user either
encounters a deadlock or if send() returns lesser bytes than requested,
I prefer the latter behavior.
The second case is much easier to debug for users, they can do something
to handle the problem (loop around send()), and this case can even be detected
using strace. But the deadlock case is nearly not debuggable by users and there
is nothing to prevent it when the workload pattern runs into this situation
(except to not use blocking sends).
