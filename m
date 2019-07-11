Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0953C652B9
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 10:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbfGKIA7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 11 Jul 2019 04:00:59 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59740 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727709AbfGKIA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 04:00:58 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6B7xq9k067956
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 04:00:58 -0400
Received: from smtp.notes.na.collabserv.com (smtp.notes.na.collabserv.com [158.85.210.114])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tp17d822w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 04:00:57 -0400
Received: from localhost
        by smtp.notes.na.collabserv.com with smtp.notes.na.collabserv.com ESMTP
        for <netdev@vger.kernel.org> from <BMT@zurich.ibm.com>;
        Thu, 11 Jul 2019 08:00:57 -0000
Received: from us1b3-smtp01.a3dr.sjc01.isc4sb.com (10.122.7.174)
        by smtp.notes.na.collabserv.com (10.122.47.58) with smtp.notes.na.collabserv.com ESMTP;
        Thu, 11 Jul 2019 08:00:49 -0000
Received: from us1b3-mail162.a3dr.sjc03.isc4sb.com ([10.160.174.187])
          by us1b3-smtp01.a3dr.sjc01.isc4sb.com
          with ESMTP id 2019071108004955-181834 ;
          Thu, 11 Jul 2019 08:00:49 +0000 
In-Reply-To: <20190710175212.GM2887@mellanox.com>
From:   "Bernard Metzler" <BMT@zurich.ibm.com>
To:     "Jason Gunthorpe" <jgg@mellanox.com>
Cc:     "Leon Romanovsky" <leon@kernel.org>,
        "Stephen Rothwell" <sfr@canb.auug.org.au>,
        "Doug Ledford" <dledford@redhat.com>,
        "David Miller" <davem@davemloft.net>,
        "Networking" <netdev@vger.kernel.org>,
        "Linux Next Mailing List" <linux-next@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Date:   Thu, 11 Jul 2019 08:00:49 +0000
MIME-Version: 1.0
Sensitivity: 
Importance: Normal
X-Priority: 3 (Normal)
References: <20190710175212.GM2887@mellanox.com>,<20190709135636.4d36e19f@canb.auug.org.au>
 <20190709064346.GF7034@mtr-leonro.mtl.com>
X-Mailer: IBM iNotes ($HaikuForm 1054) | IBM Domino Build
 SCN1812108_20180501T0841_FP55 May 22, 2019 at 11:09
X-KeepSent: 360C0EBE:4A489B94-00258434:002B10B7;
 type=4; name=$KeepSent
X-LLNOutbound: False
X-Disclaimed: 35307
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
x-cbid: 19071108-9695-0000-0000-000006B766FA
X-IBM-SpamModules-Scores: BY=0.020306; FL=0; FP=0; FZ=0; HX=0; KW=0; PH=0;
 SC=0.399202; ST=0; TS=0; UL=0; ISC=; MB=0.010234
X-IBM-SpamModules-Versions: BY=3.00011408; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01230531; UDB=6.00648155; IPR=6.01011807;
 BA=6.00006354; NDR=6.00000001; ZLA=6.00000005; ZF=6.00000009; ZB=6.00000000;
 ZP=6.00000000; ZH=6.00000000; ZU=6.00000002; MB=3.00027677; XFM=3.00000015;
 UTC=2019-07-11 08:00:55
X-IBM-AV-DETECTION: SAVI=unsuspicious REMOTE=unsuspicious XFE=unused
X-IBM-AV-VERSION: SAVI=2019-07-11 03:41:51 - 6.00010150
x-cbparentid: 19071108-9696-0000-0000-0000681A9D1B
Message-Id: <OF360C0EBE.4A489B94-ON00258434.002B10B7-00258434.002C0536@notes.na.collabserv.com>
Subject: Re:  Re: linux-next: build failure after merge of the net-next tree
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-11_01:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-----"Jason Gunthorpe" <jgg@mellanox.com> wrote: -----

>To: "Leon Romanovsky" <leon@kernel.org>, "Bernard Metzler"
><bmt@zurich.ibm.com>
>From: "Jason Gunthorpe" <jgg@mellanox.com>
>Date: 07/10/2019 07:52PM
>Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, "Doug Ledford"
><dledford@redhat.com>, "David Miller" <davem@davemloft.net>,
>"Networking" <netdev@vger.kernel.org>, "Linux Next Mailing List"
><linux-next@vger.kernel.org>, "Linux Kernel Mailing List"
><linux-kernel@vger.kernel.org>
>Subject: [EXTERNAL] Re: linux-next: build failure after merge of the
>net-next tree
>
>On Tue, Jul 09, 2019 at 09:43:46AM +0300, Leon Romanovsky wrote:
>> On Tue, Jul 09, 2019 at 01:56:36PM +1000, Stephen Rothwell wrote:
>> > Hi all,
>> >
>> > After merging the net-next tree, today's linux-next build (x86_64
>> > allmodconfig) failed like this:
>> >
>> > drivers/infiniband/sw/siw/siw_cm.c: In function
>'siw_create_listen':
>> > drivers/infiniband/sw/siw/siw_cm.c:1978:3: error: implicit
>declaration of function 'for_ifa'; did you mean 'fork_idle'?
>[-Werror=implicit-function-declaration]
>> >    for_ifa(in_dev)
>> >    ^~~~~~~
>> >    fork_idle
>> > drivers/infiniband/sw/siw/siw_cm.c:1978:18: error: expected ';'
>before '{' token
>> >    for_ifa(in_dev)
>> >                   ^
>> >                   ;
>> >    {
>> >    ~
>> >
>> > Caused by commit
>> >
>> >   6c52fdc244b5 ("rdma/siw: connection management")
>> >
>> > from the rdma tree.  I don't know why this didn't fail after I
>mereged
>> > that tree.
>> 
>> I had the same question, because I have this fix for a couple of
>days already.
>> 
>> From 56c9e15ec670af580daa8c3ffde9503af3042d67 Mon Sep 17 00:00:00
>2001
>> From: Leon Romanovsky <leonro@mellanox.com>
>> Date: Sun, 7 Jul 2019 10:43:42 +0300
>> Subject: [PATCH] Fixup to build SIW issue
>> 
>> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>>  drivers/infiniband/sw/siw/siw_cm.c | 5 ++---
>>  1 file changed, 2 insertions(+), 3 deletions(-)
>> 
>> diff --git a/drivers/infiniband/sw/siw/siw_cm.c
>b/drivers/infiniband/sw/siw/siw_cm.c
>> index 8e618cb7261f..c883bf514341 100644
>> +++ b/drivers/infiniband/sw/siw/siw_cm.c
>> @@ -1954,6 +1954,7 @@ static void siw_drop_listeners(struct
>iw_cm_id *id)
>>  int siw_create_listen(struct iw_cm_id *id, int backlog)
>>  {
>>  	struct net_device *dev = to_siw_dev(id->device)->netdev;
>> +	const struct in_ifaddr *ifa;
>>  	int rv = 0, listeners = 0;
>> 
>>  	siw_dbg(id->device, "id 0x%p: backlog %d\n", id, backlog);
>> @@ -1975,8 +1976,7 @@ int siw_create_listen(struct iw_cm_id *id,
>int backlog)
>>  			id, &s_laddr.sin_addr, ntohs(s_laddr.sin_port),
>>  			&s_raddr->sin_addr, ntohs(s_raddr->sin_port));
>> 
>> -		for_ifa(in_dev)
>> -		{
>> +		in_dev_for_each_ifa_rcu(ifa, in_dev) {
>>  			if (ipv4_is_zeronet(s_laddr.sin_addr.s_addr) ||
>
>Hum. There is no rcu lock held here and we can't use RCU anyhow as
>siw_listen_address will sleep.
>
>I think this needs to use rtnl, as below. Bernard, please urgently
>confirm. Thanks
>

Hi Jason,

That listen will not sleep. The socket is just marked
listening. Accepting a new connection is handled asynchronously
by a work handler, kicked by a socket callback
(siw_cm_llp_state_change).

But, I think you are correct, we are missing the
rcu_read_lock/unlock around that iteration. Could we please add
that (see below)?

Thanks very much!
Bernard.

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index c883bf514341..c5c060103993 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -1976,6 +1976,7 @@ int siw_create_listen(struct iw_cm_id *id, int backlog)
                        id, &s_laddr.sin_addr, ntohs(s_laddr.sin_port),
                        &s_raddr->sin_addr, ntohs(s_raddr->sin_port));
 
+               rcu_read_lock();
                in_dev_for_each_ifa_rcu(ifa, in_dev) {
                        if (ipv4_is_zeronet(s_laddr.sin_addr.s_addr) ||
                            s_laddr.sin_addr.s_addr == ifa->ifa_address) {
@@ -1988,6 +1989,7 @@ int siw_create_listen(struct iw_cm_id *id, int backlog)
                                        listeners++;
                        }
                }
+               rcu_read_unlock();
                in_dev_put(in_dev);
        } else if (id->local_addr.ss_family == AF_INET6) {
                struct inet6_dev *in6_dev = in6_dev_get(dev);



>diff --git a/drivers/infiniband/sw/siw/siw_cm.c
>b/drivers/infiniband/sw/siw/siw_cm.c
>index 8e618cb7261f62..ee98e96a5bfaba 100644
>--- a/drivers/infiniband/sw/siw/siw_cm.c
>+++ b/drivers/infiniband/sw/siw/siw_cm.c
>@@ -1965,6 +1965,7 @@ int siw_create_listen(struct iw_cm_id *id, int
>backlog)
> 	 */
> 	if (id->local_addr.ss_family == AF_INET) {
> 		struct in_device *in_dev = in_dev_get(dev);
>+		const struct in_ifaddr *ifa;
> 		struct sockaddr_in s_laddr, *s_raddr;
> 
> 		memcpy(&s_laddr, &id->local_addr, sizeof(s_laddr));
>@@ -1975,8 +1976,8 @@ int siw_create_listen(struct iw_cm_id *id, int
>backlog)
> 			id, &s_laddr.sin_addr, ntohs(s_laddr.sin_port),
> 			&s_raddr->sin_addr, ntohs(s_raddr->sin_port));
> 
>-		for_ifa(in_dev)
>-		{
>+		rtnl_lock();
>+		in_dev_for_each_ifa_rtnl(ifa, in_dev) {
> 			if (ipv4_is_zeronet(s_laddr.sin_addr.s_addr) ||
> 			    s_laddr.sin_addr.s_addr == ifa->ifa_address) {
> 				s_laddr.sin_addr.s_addr = ifa->ifa_address;
>@@ -1988,7 +1989,7 @@ int siw_create_listen(struct iw_cm_id *id, int
>backlog)
> 					listeners++;
> 			}
> 		}
>-		endfor_ifa(in_dev);
>+		rtnl_unlock();
> 		in_dev_put(in_dev);
> 	} else if (id->local_addr.ss_family == AF_INET6) {
> 		struct inet6_dev *in6_dev = in6_dev_get(dev);
>
>

