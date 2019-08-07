Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41DF784A13
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 12:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbfHGKvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 06:51:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59694 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbfHGKvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 06:51:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x77AmwP2126290;
        Wed, 7 Aug 2019 10:50:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=E62+7VTE7UonCrlCnPHNWi4RPE8HkU4TSMt2nyRommM=;
 b=xlFdWUxH2bW6rVoJdPVh8EmDH2mfU1vnFm9PJAVMX1GY1g4vFfaS2bTEvO9EPcxA9Qh9
 LykHvi6D8SLCJCiPlWRB7HTLjRRXHqMqLYzusGmGc8zFybMied62OZBr8n8h0RiiU0HE
 7zTdmCsIddY8AYKUk8c/JzBjZFAIT2DroZKIES13ewnsxyOJLLTwJsjZOOTwYKDwFb6H
 U+LZf2RU4u9REcByD2U1cwKC3QKp8V0f0ZkeXH5iw6VU0iojWSZY8bvczok3ho4l23sz
 ui/KZ0bRAetVvRKcsFqYQNbeJYcEUXkflyZQDMukDaI166KHs0B2ZyEvXytNwFasIJtr oA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2u52wrbhm5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Aug 2019 10:50:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x77Alums162550;
        Wed, 7 Aug 2019 10:50:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2u75bwaw44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Aug 2019 10:50:52 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x77AooQk002351;
        Wed, 7 Aug 2019 10:50:51 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Aug 2019 03:50:50 -0700
Date:   Wed, 7 Aug 2019 13:50:42 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Patrick Bellasi <patrick.bellasi@arm.com>,
        linux-sparse@vger.kernel.org
Cc:     Mao Wenan <maowenan@huawei.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH net-next] net: can: Fix compiling warning
Message-ID: <20190807105042.GK1974@kadam>
References: <20190802033643.84243-1-maowenan@huawei.com>
 <0050efdb-af9f-49b9-8d83-f574b3d46a2e@hartkopp.net>
 <20190806135231.GJ1974@kadam>
 <6e1c5aa0-8ed3-eec3-a34d-867ea8f54e9d@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e1c5aa0-8ed3-eec3-a34d-867ea8f54e9d@hartkopp.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9341 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=969
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908070120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9341 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908070120
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 06, 2019 at 06:41:44PM +0200, Oliver Hartkopp wrote:
> I compiled the code (the original version), but I do not get that "Should it
> be static?" warning:
> 
> user@box:~/net-next$ make C=1
>   CALL    scripts/checksyscalls.sh
>   CALL    scripts/atomic/check-atomics.sh
>   DESCEND  objtool
>   CHK     include/generated/compile.h
>   CHECK   net/can/af_can.c
> ./include/linux/sched.h:609:43: error: bad integer constant expression
> ./include/linux/sched.h:609:73: error: invalid named zero-width bitfield
> `value'
> ./include/linux/sched.h:610:43: error: bad integer constant expression
> ./include/linux/sched.h:610:67: error: invalid named zero-width bitfield
> `bucket_id'
>   CC [M]  net/can/af_can.o

The sched.h errors suppress Sparse warnings so it's broken/useless now.
The code looks like this:

include/linux/sched.h
   613  struct uclamp_se {
   614          unsigned int value              : bits_per(SCHED_CAPACITY_SCALE);
   615          unsigned int bucket_id          : bits_per(UCLAMP_BUCKETS);
   616          unsigned int active             : 1;
   617          unsigned int user_defined       : 1;
   618  };

bits_per() is zero and Sparse doesn't like zero sized bitfields.

regards,
dan carpenter
