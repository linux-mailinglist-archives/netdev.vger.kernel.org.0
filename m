Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F067818CE87
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 14:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbgCTNO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 09:14:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51078 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726954AbgCTNO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 09:14:57 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02KDCpNB053601;
        Fri, 20 Mar 2020 13:14:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=mj+mPOx49mvMn5UqX9Oy1oF60e1jGLIQt7Fz9oFtxdI=;
 b=BcRuWoVt1x10gOtlh0xk1020vWBIgssdfvPRrEpVgc9TpKVe9hWRKLVOjIbfNxXcLCnO
 R/W0OspeUvlyU9bW4UU/Ad6FFOe2JFr/FqqLhLdnS50dvnQeFDjRIxCeYQeGytGz6ACW
 Gafvf0MSfb3u1LOfDetfmFIGENNG099xQNNDBq71VAIh7laleIong0FYaRsmxD8Vd78x
 4+fVegwenYoHu8h4Qzs9+uMyBaEoYZk0im63luIxD8xJGEIQzvrpfV0aYhADfk/AppD6
 0mB8Ml2xCwtq1iUipekFp4i6lB5KzBv2BP/uiYCLk1T8n7w3lenxms/6rYhi/v4sW9Lu LQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2yrq7mdgjn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Mar 2020 13:14:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02KDCl4G063762;
        Fri, 20 Mar 2020 13:14:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2ys8ty2pmg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Mar 2020 13:14:39 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02KDEbdh006265;
        Fri, 20 Mar 2020 13:14:38 GMT
Received: from kadam (/41.57.98.10) by default (Oracle Beehive Gateway v4.0)
 with ESMTP ; Fri, 20 Mar 2020 06:14:36 -0700
USER-AGENT: Mutt/1.9.4 (2018-02-28)
MIME-Version: 1.0
Message-ID: <20200320131429.GH4650@kadam>
Date:   Fri, 20 Mar 2020 06:14:29 -0700 (PDT)
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Leon Romanovsky <leonro@mellanox.com>
Cc:     YueHaibing <yuehaibing@huawei.com>,
        Derek Chickles <dchickles@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH net-next] liquidio: remove set but not used variable 's'
References: <20200306023254.61731-1-yuehaibing@huawei.com>
 <20200319120743.28056-1-yuehaibing@huawei.com>
 <20200319121035.GO126814@unreal>
In-Reply-To: <20200319121035.GO126814@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9565 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003200057
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9565 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1011
 malwarescore=0 mlxscore=0 phishscore=0 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003200057
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 19, 2020 at 02:10:35PM +0200, Leon Romanovsky wrote:
> On Thu, Mar 19, 2020 at 12:07:43PM +0000, YueHaibing wrote:
> > Fixes gcc '-Wunused-but-set-variable' warning:
> >
> > drivers/net/ethernet/cavium/liquidio/lio_main.c: In function 'octeon_chip_specific_setup':
> > drivers/net/ethernet/cavium/liquidio/lio_main.c:1378:8: warning:
> >  variable 's' set but not used [-Wunused-but-set-variable]
> >
> > It's not used since commit b6334be64d6f ("net/liquidio: Delete driver version assignment")
> >
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> > ---
> >  drivers/net/ethernet/cavium/liquidio/lio_main.c | 5 -----
> >  1 file changed, 5 deletions(-)
> >
> 
> I'm sorry for missing this warning.
> 

The warning is not enabled by default.

regards,
dan carpenter

