Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3974F43E058
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 13:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbhJ1MAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 08:00:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27338 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230169AbhJ1MAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 08:00:31 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19SBINht010651;
        Thu, 28 Oct 2021 11:58:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=sfexuEA6tHOewABV+WCgUEzquYglKdI07ON4wXqn+hk=;
 b=MHdSBWCed59TP6ANjT9Il/am2uXIq00+WiWNUpPaUUVrXWonPCjtt9W2AgpNTT2aL9pv
 rmLol13DJINF94z2t5yzOOYDyDDxu3OZJBK9APfIa0id7tuAMcffyONisOK0KlTRzQH0
 hAxQ9ZAnBuy+AJ1rQr6kwyeAra5Go++fm2KTc2Wm+bE6m7+BXfwH4i4KSqFvuhXNKG5u
 C2LesCyYTaBhYY7mdM9GwRMwqY2cPwV+j856YZP6gUOn58A7AaKIcboZ4nCUQ+dlz5mG
 PXFFMU/H6FIjt7D5Yy2OYjMGFxKtjvJji3qLRjUdTCf4YgdEoT+X7lGy13HtGB8Af/Rq NQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bytvegqwg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Oct 2021 11:58:00 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19SBhrBY031418;
        Thu, 28 Oct 2021 11:58:00 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bytvegqw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Oct 2021 11:58:00 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19SBvpnr012855;
        Thu, 28 Oct 2021 11:57:58 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3bx4ee8p79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Oct 2021 11:57:57 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19SBpkeH38273402
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Oct 2021 11:51:46 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95B29A404D;
        Thu, 28 Oct 2021 11:57:55 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08AD7A4059;
        Thu, 28 Oct 2021 11:57:55 +0000 (GMT)
Received: from [9.145.20.114] (unknown [9.145.20.114])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 28 Oct 2021 11:57:54 +0000 (GMT)
Message-ID: <c6396899-cf99-e695-fc90-3e21e95245ed@linux.ibm.com>
Date:   Thu, 28 Oct 2021 13:57:55 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH net 1/4] Revert "net/smc: don't wait for send buffer space
 when data was already sent"
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tony Lu <tonylu@linux.alibaba.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, jacob.qi@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com, guwen@linux.alibaba.com,
        dust.li@linux.alibaba.com
References: <20211027085208.16048-1-tonylu@linux.alibaba.com>
 <20211027085208.16048-2-tonylu@linux.alibaba.com>
 <9bbd05ac-5fa5-7d7a-fe69-e7e072ccd1ab@linux.ibm.com>
 <20211027080813.238b82ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <06ae0731-0b9b-a70d-6479-de6fe691e25d@linux.ibm.com>
 <20211027084710.1f4a4ff1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20211027084710.1f4a4ff1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4Y-rkTlvcGbaCs2ENxrbYiilkkjFoKz8
X-Proofpoint-ORIG-GUID: apEeGgL-RpGaj7anGCJuwG6LXpI7cPFd
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-28_01,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 spamscore=0 clxscore=1015 mlxscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110280063
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/10/2021 17:47, Jakub Kicinski wrote:
> On Wed, 27 Oct 2021 17:38:27 +0200 Karsten Graul wrote:
>> What we found out was that applications called sendmsg() with large data
>> buffers using blocking sockets. This led to the described situation, were the
>> solution was to early return to user space even if not all data were sent yet.
>> Userspace applications should not have a problem with the fact that sendmsg()
>> returns a smaller byte count than requested.
>>
>> Reverting this patch would bring back the stalled connection problem.
> 
> I'm not sure. The man page for send says:
> 
>        When the message does not fit into  the  send  buffer  of  the  socket,
>        send()  normally blocks, unless the socket has been placed in nonblock‐
>        ing I/O mode.  In nonblocking mode it would fail with the error  EAGAIN
>        or  EWOULDBLOCK in this case.
> 
> dunno if that's required by POSIX or just a best practice.

I see your point, and I am also not sure about how it should work in reality.

The test case where the connection stalled is that both communication peers try
to send data larger than there is space in the local send buffer plus the remote 
receive buffer. They use blocking sockets, so if the send() call is meant to send
all data as requested then both sides would hang in send() forever/until a timeout.

In our case both sides run a send/recv loop, so allowing send() to return lesser 
bytes then requested resulted in a follow-on recv() call which freed up space in the
buffers, and the processing continues.

There is also some discussion about this topic in this SO thread
    https://stackoverflow.com/questions/19697218/can-send-on-a-tcp-socket-return-0-and-length
which points out that this (send returns smaller length) may happen already, e.g. when there
is an interruption.

So how to deal with all of this? Is it an accepted programming error when a user space 
program gets itself into this kind of situation? Since this problem depends on 
internal send/recv buffer sizes such a program might work on one system but not on 
other systems.

At the end the question might be if either such kind of a 'deadlock' is acceptable, 
or if it is okay to have send() return lesser bytes than requested.
