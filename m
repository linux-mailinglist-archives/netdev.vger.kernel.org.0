Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37A6311CCD7
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 13:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729094AbfLLMMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 07:12:22 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:40756 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729004AbfLLMMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 07:12:21 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBCC4VL5110310;
        Thu, 12 Dec 2019 12:12:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=DeBTMQ4Ve6kVrzUvuWYJqGCqXWL8BbVSM9l2GRIPWW0=;
 b=fXqTE/BDGCD+Bx19Dn8XOZczsWPTWd81/iVVHmKZbnq524GuNC4sJgDgGIi8QHO9AtEm
 jndeBb9Jl2Wwmi7vDWzAw9sWp34Bm/IkFfeoQfgvV9lJChLqZHjKgAn/DvxRfIBrcZMF
 lh1VDgIvF8RjLTYP1ZLXjvbc2i2CqKaNLrz30vPcbjDglMIsPZJmK+klNTPoPe0K+Tdn
 lWUesfkYdOk2GATI0aDDrBD5aOiL12zGZFzP13rlmqLRU0UwTVhH3W63uKlozUYPfOPK
 TFNOVtXk8TS5CvT3rRhWW4EqGGnVY5Nq8GjKrKm2LvBTxqDz8WUyRfA2WJgGpXfjAXOj 9g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2wr41qjmms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Dec 2019 12:12:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBCC8BBV070476;
        Thu, 12 Dec 2019 12:12:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2wumvxxtbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Dec 2019 12:12:15 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBCCCD5D027919;
        Thu, 12 Dec 2019 12:12:14 GMT
Received: from kadam (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Dec 2019 04:12:13 -0800
Date:   Thu, 12 Dec 2019 15:12:06 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Scott Schafer <schaferjscott@gmail.com>
Cc:     gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        GR-Linux-NIC-Dev@marvell.com, Manish Chopra <manishc@marvell.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 11/23] staging: qlge: Fix CHECK: braces {} should be
 used on all arms of this statement
Message-ID: <20191212121206.GB1895@kadam>
References: <cover.1576086080.git.schaferjscott@gmail.com>
 <0e1fc1a16725094676fdab63d3a24a986309a759.1576086080.git.schaferjscott@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e1fc1a16725094676fdab63d3a24a986309a759.1576086080.git.schaferjscott@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9468 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=965
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912120092
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9468 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912120092
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 12:12:40PM -0600, Scott Schafer wrote:
> @@ -351,8 +352,9 @@ static int ql_aen_lost(struct ql_adapter *qdev, struct mbox_params *mbcp)
>  	mbcp->out_count = 6;
>  
>  	status = ql_get_mb_sts(qdev, mbcp);
> -	if (status)
> +	if (status) {
>  		netif_err(qdev, drv, qdev->ndev, "Lost AEN broken!\n");
> +	}
>  	else {

The close } should be on the same line as the else.

>  		int i;
>  

regards,
dan carpenter
