Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF72B656E2
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 14:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbfGKM3x convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 11 Jul 2019 08:29:53 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8942 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726069AbfGKM3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 08:29:53 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6BCTj9d145865
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 08:29:51 -0400
Received: from smtp.notes.na.collabserv.com (smtp.notes.na.collabserv.com [192.155.248.67])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tp54c81v4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 08:29:47 -0400
Received: from localhost
        by smtp.notes.na.collabserv.com with smtp.notes.na.collabserv.com ESMTP
        for <netdev@vger.kernel.org> from <BMT@zurich.ibm.com>;
        Thu, 11 Jul 2019 12:29:29 -0000
Received: from us1a3-smtp07.a3.dal06.isc4sb.com (10.146.103.14)
        by smtp.notes.na.collabserv.com (10.106.227.16) with smtp.notes.na.collabserv.com ESMTP;
        Thu, 11 Jul 2019 12:29:22 -0000
Received: from us1a3-mail162.a3.dal06.isc4sb.com ([10.146.71.4])
          by us1a3-smtp07.a3.dal06.isc4sb.com
          with ESMTP id 2019071112292189-411667 ;
          Thu, 11 Jul 2019 12:29:21 +0000 
In-Reply-To: <20190711115235.GA25821@mellanox.com>
From:   "Bernard Metzler" <BMT@zurich.ibm.com>
To:     "Jason Gunthorpe" <jgg@mellanox.com>
Cc:     "Leon Romanovsky" <leon@kernel.org>,
        "Stephen Rothwell" <sfr@canb.auug.org.au>,
        "Doug Ledford" <dledford@redhat.com>,
        "David Miller" <davem@davemloft.net>,
        "Networking" <netdev@vger.kernel.org>,
        "Linux Next Mailing List" <linux-next@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Date:   Thu, 11 Jul 2019 12:29:21 +0000
MIME-Version: 1.0
Sensitivity: 
Importance: Normal
X-Priority: 3 (Normal)
References: <20190711115235.GA25821@mellanox.com>,<20190710175212.GM2887@mellanox.com>
 <20190709135636.4d36e19f@canb.auug.org.au>
 <20190709064346.GF7034@mtr-leonro.mtl.com>
 <OF360C0EBE.4A489B94-ON00258434.002B10B7-00258434.002C0536@notes.na.collabserv.com>
X-Mailer: IBM iNotes ($HaikuForm 1054) | IBM Domino Build
 SCN1812108_20180501T0841_FP55 May 22, 2019 at 11:09
X-LLNOutbound: False
X-Disclaimed: 20971
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
x-cbid: 19071112-0327-0000-0000-00000BE240E3
X-IBM-SpamModules-Scores: BY=0; FL=0; FP=0; FZ=0; HX=0; KW=0; PH=0;
 SC=0.40962; ST=0; TS=0; UL=0; ISC=; MB=0.000001
X-IBM-SpamModules-Versions: BY=3.00011408; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01230620; UDB=6.00648208; IPR=6.01011897;
 BA=6.00006355; NDR=6.00000001; ZLA=6.00000005; ZF=6.00000009; ZB=6.00000000;
 ZP=6.00000000; ZH=6.00000000; ZU=6.00000002; MB=3.00027678; XFM=3.00000015;
 UTC=2019-07-11 12:29:27
X-IBM-AV-DETECTION: SAVI=unsuspicious REMOTE=unsuspicious XFE=unused
X-IBM-AV-VERSION: SAVI=2019-07-11 09:18:22 - 6.00010151
x-cbparentid: 19071112-0328-0000-0000-00001750473C
Message-Id: <OF9A485648.9C7A28A3-ON00258434.00449B07-00258434.00449B14@notes.na.collabserv.com>
Subject: Re:  Re: Re: linux-next: build failure after merge of the net-next tree
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-11_02:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-----"Jason Gunthorpe" <jgg@mellanox.com> wrote: -----

>To: "Bernard Metzler" <BMT@zurich.ibm.com>
>From: "Jason Gunthorpe" <jgg@mellanox.com>
>Date: 07/11/2019 01:53PM
>Cc: "Leon Romanovsky" <leon@kernel.org>, "Stephen Rothwell"
><sfr@canb.auug.org.au>, "Doug Ledford" <dledford@redhat.com>, "David
>Miller" <davem@davemloft.net>, "Networking" <netdev@vger.kernel.org>,
>"Linux Next Mailing List" <linux-next@vger.kernel.org>, "Linux Kernel
>Mailing List" <linux-kernel@vger.kernel.org>
>Subject: [EXTERNAL] Re: Re: linux-next: build failure after merge of
>the net-next tree
>
>On Thu, Jul 11, 2019 at 08:00:49AM +0000, Bernard Metzler wrote:
>
>> That listen will not sleep. The socket is just marked
>> listening. 
>
>Eh? siw_listen_address() calls siw_cep_alloc() which does:
>
>	struct siw_cep *cep = kzalloc(sizeof(*cep), GFP_KERNEL);
>
>Which is sleeping. Many other cases too.
>
>Jason
>
>
Ah, true! I was after really deep sleeps like user level
socket accept() calls ;) So you are correct of course.

Thanks!
Bernard

