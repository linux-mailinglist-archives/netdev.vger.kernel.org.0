Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 233AF6333A
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 11:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbfGIJAw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 9 Jul 2019 05:00:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2902 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726031AbfGIJAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 05:00:52 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x698vONJ103193
        for <netdev@vger.kernel.org>; Tue, 9 Jul 2019 05:00:51 -0400
Received: from smtp.notes.na.collabserv.com (smtp.notes.na.collabserv.com [192.155.248.81])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tmptgjt9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 05:00:51 -0400
Received: from localhost
        by smtp.notes.na.collabserv.com with smtp.notes.na.collabserv.com ESMTP
        for <netdev@vger.kernel.org> from <BMT@zurich.ibm.com>;
        Tue, 9 Jul 2019 09:00:49 -0000
Received: from us1a3-smtp03.a3.dal06.isc4sb.com (10.106.154.98)
        by smtp.notes.na.collabserv.com (10.106.227.88) with smtp.notes.na.collabserv.com ESMTP;
        Tue, 9 Jul 2019 09:00:41 -0000
Received: from us1a3-mail162.a3.dal06.isc4sb.com ([10.146.71.4])
          by us1a3-smtp03.a3.dal06.isc4sb.com
          with ESMTP id 2019070909004074-237333 ;
          Tue, 9 Jul 2019 09:00:40 +0000 
In-Reply-To: <20190709064346.GF7034@mtr-leonro.mtl.com>
From:   "Bernard Metzler" <BMT@zurich.ibm.com>
To:     "Leon Romanovsky" <leon@kernel.org>
Cc:     "Stephen Rothwell" <sfr@canb.auug.org.au>,
        "Doug Ledford" <dledford@redhat.com>,
        "Jason Gunthorpe" <jgg@mellanox.com>,
        "David Miller" <davem@davemloft.net>,
        "Networking" <netdev@vger.kernel.org>,
        "Linux Next Mailing List" <linux-next@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Date:   Tue, 9 Jul 2019 09:00:40 +0000
MIME-Version: 1.0
Sensitivity: 
Importance: Normal
X-Priority: 3 (Normal)
References: <20190709064346.GF7034@mtr-leonro.mtl.com>,<20190709135636.4d36e19f@canb.auug.org.au>
X-Mailer: IBM iNotes ($HaikuForm 1054) | IBM Domino Build
 SCN1812108_20180501T0841_FP55 May 22, 2019 at 11:09
X-LLNOutbound: False
X-Disclaimed: 56111
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
x-cbid: 19070909-7093-0000-0000-00000C001049
X-IBM-SpamModules-Scores: BY=0; FL=0; FP=0; FZ=0; HX=0; KW=0; PH=0;
 SC=0.40962; ST=0; TS=0; UL=0; ISC=; MB=0.009927
X-IBM-SpamModules-Versions: BY=3.00011400; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01229610; UDB=6.00647592; IPR=6.01010869;
 BA=6.00006352; NDR=6.00000001; ZLA=6.00000005; ZF=6.00000009; ZB=6.00000000;
 ZP=6.00000000; ZH=6.00000000; ZU=6.00000002; MB=3.00027647; XFM=3.00000015;
 UTC=2019-07-09 09:00:47
X-IBM-AV-DETECTION: SAVI=unsuspicious REMOTE=unsuspicious XFE=unused
X-IBM-AV-VERSION: SAVI=2019-07-09 02:46:09 - 6.00010142
x-cbparentid: 19070909-7094-0000-0000-00008DFF1023
Message-Id: <OF3548A4E6.BB93884C-ON00258432.00308557-00258432.00318024@notes.na.collabserv.com>
Subject: Re:  Re: linux-next: build failure after merge of the net-next tree
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-09_04:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-----"Leon Romanovsky" <leon@kernel.org> wrote: -----

>To: "Stephen Rothwell" <sfr@canb.auug.org.au>
>From: "Leon Romanovsky" <leon@kernel.org>
>Date: 07/09/2019 08:43AM
>Cc: "Doug Ledford" <dledford@redhat.com>, "Jason Gunthorpe"
><jgg@mellanox.com>, "David Miller" <davem@davemloft.net>,
>"Networking" <netdev@vger.kernel.org>, "Linux Next Mailing List"
><linux-next@vger.kernel.org>, "Linux Kernel Mailing List"
><linux-kernel@vger.kernel.org>, "Bernard Metzler"
><bmt@zurich.ibm.com>
>Subject: [EXTERNAL] Re: linux-next: build failure after merge of the
>net-next tree
>
>On Tue, Jul 09, 2019 at 01:56:36PM +1000, Stephen Rothwell wrote:
>> Hi all,
>>
>> After merging the net-next tree, today's linux-next build (x86_64
>> allmodconfig) failed like this:
>>
>> drivers/infiniband/sw/siw/siw_cm.c: In function
>'siw_create_listen':
>> drivers/infiniband/sw/siw/siw_cm.c:1978:3: error: implicit
>declaration of function 'for_ifa'; did you mean 'fork_idle'?
>[-Werror=implicit-function-declaration]
>>    for_ifa(in_dev)
>>    ^~~~~~~
>>    fork_idle
>> drivers/infiniband/sw/siw/siw_cm.c:1978:18: error: expected ';'
>before '{' token
>>    for_ifa(in_dev)
>>                   ^
>>                   ;
>>    {
>>    ~
>>
>> Caused by commit
>>
>>   6c52fdc244b5 ("rdma/siw: connection management")
>>
>> from the rdma tree.  I don't know why this didn't fail after I
>mereged
>> that tree.
>
>I had the same question, because I have this fix for a couple of days
>already.
>
>From 56c9e15ec670af580daa8c3ffde9503af3042d67 Mon Sep 17 00:00:00
>2001
>From: Leon Romanovsky <leonro@mellanox.com>
>Date: Sun, 7 Jul 2019 10:43:42 +0300
>Subject: [PATCH] Fixup to build SIW issue
>
>Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>---
> drivers/infiniband/sw/siw/siw_cm.c | 5 ++---
> 1 file changed, 2 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/infiniband/sw/siw/siw_cm.c
>b/drivers/infiniband/sw/siw/siw_cm.c
>index 8e618cb7261f..c883bf514341 100644
>--- a/drivers/infiniband/sw/siw/siw_cm.c
>+++ b/drivers/infiniband/sw/siw/siw_cm.c
>@@ -1954,6 +1954,7 @@ static void siw_drop_listeners(struct iw_cm_id
>*id)
> int siw_create_listen(struct iw_cm_id *id, int backlog)
> {
> 	struct net_device *dev = to_siw_dev(id->device)->netdev;
>+	const struct in_ifaddr *ifa;
> 	int rv = 0, listeners = 0;
>
> 	siw_dbg(id->device, "id 0x%p: backlog %d\n", id, backlog);
>@@ -1975,8 +1976,7 @@ int siw_create_listen(struct iw_cm_id *id, int
>backlog)
> 			id, &s_laddr.sin_addr, ntohs(s_laddr.sin_port),
> 			&s_raddr->sin_addr, ntohs(s_raddr->sin_port));
>
>-		for_ifa(in_dev)
>-		{
>+		in_dev_for_each_ifa_rcu(ifa, in_dev) {
> 			if (ipv4_is_zeronet(s_laddr.sin_addr.s_addr) ||
> 			    s_laddr.sin_addr.s_addr == ifa->ifa_address) {
> 				s_laddr.sin_addr.s_addr = ifa->ifa_address;
>@@ -1988,7 +1988,6 @@ int siw_create_listen(struct iw_cm_id *id, int
>backlog)
> 					listeners++;
> 			}
> 		}
>-		endfor_ifa(in_dev);
> 		in_dev_put(in_dev);
> 	} else if (id->local_addr.ss_family == AF_INET6) {
> 		struct inet6_dev *in6_dev = in6_dev_get(dev);
>--
>2.21.0
>
>
>>
>> I have marked that driver as depending on BROKEN for today.
>>
>> --
>> Cheers,
>> Stephen Rothwell
>
>
>
I am very sorry for that issues. Things are moving fast, and I
didn't realize 'for_ifa' recently went away. I agree with Leon,
his patch fixes the issue. So, please, let's apply that one.

Leon, many thanks for providing the fix.

Thanks very much,
Bernard.

