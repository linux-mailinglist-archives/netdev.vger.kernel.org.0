Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B65B0222091
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 12:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbgGPKZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 06:25:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41930 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbgGPKZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 06:25:59 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06GAH1KB151620;
        Thu, 16 Jul 2020 10:25:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Xo6gJCrftzSjjyI8wHnqlZSNmzgC4r1alRAMNSQjrDA=;
 b=ZKOivIHBcnsAGviho7pIIdGRqlzWRZSizzNgERRyF6ELgd5QOkQwOP0Cy7cFU3IR0HJg
 +FY6jR0MrDasitRQ2b3Wjx4qff/XOOIFiStgx/fczQxo0SOa5uISsC7IK3PQvohQX/Iw
 ixKEhZaZrGrAxekFb4ETHoqDkGCdPPMIv2o2n8MCCsFSJQG+SS2/MDyC52NM6kHkBvT/
 HKPArNKm80PbbdNk4ssffv4xgxav1f9L+NFp+0ECyR0pn7M4+vnQYL/1bzA3TQyqM+sJ
 9oNUzLQxQcTs0Qz6VUGkwxPwRYauimONqapkZcf4OJUwLfgzi2YchdGzg+l6/6AvDKKP mg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3275cmggks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 16 Jul 2020 10:25:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06GANhxJ101823;
        Thu, 16 Jul 2020 10:23:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 327qbau878-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jul 2020 10:23:43 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06GANUOJ002499;
        Thu, 16 Jul 2020 10:23:30 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Jul 2020 03:23:29 -0700
Date:   Thu, 16 Jul 2020 13:23:22 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "Zhouxudong (EulerOS)" <zhouxudong8@huawei.com>
Cc:     Suraj Upadhyay <usuraj35@gmail.com>,
        "wensong@linux-vs.org" <wensong@linux-vs.org>,
        "horms@verge.net.au" <horms@verge.net.au>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "lvs-devel@vger.kernel.org" <lvs-devel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "Chenxiang (EulerOS)" <rose.chen@huawei.com>,
        "Zhaowei (EulerOS)" <zhaowei23@huawei.com>
Subject: Re: =?utf-8?B?562U5aSN?= =?utf-8?Q?=3A?= [PATCH v2] ipvs: clean code
 for ip_vs_sync.c
Message-ID: <20200716102321.GC2549@kadam>
References: <1594864671-31512-1-git-send-email-zhouxudong8@huawei.com>
 <20200716024627.GC14742@blackclown>
 <69D1AB391AAC5746B9ECCF192D064D641A7949E1@DGGEMI521-MBX.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69D1AB391AAC5746B9ECCF192D064D641A7949E1@DGGEMI521-MBX.china.huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007160082
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1011 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007160081
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's probably better to start somewhere like drivers/staging for clean
up work.  Networking people are pretty busy with their own things but
staging is happy to take clean up patches.

You need to use a proper legal name (like you would for signing
documents for your From and Signed-off-by.

> > @@ -1444,7 +1444,7 @@ static int bind_mcastif_addr(struct socket *sock, struct net_device *dev)
> >  	sin.sin_addr.s_addr  = addr;
> >  	sin.sin_port         = 0;
> 
> I think you missed this one.
> should be
> -        sin.sin_port         = 0;
> +	 sin.sin_port = 0

That was done deliberately.  Just leave that one as-is, please.

regards,
dan carpenter

