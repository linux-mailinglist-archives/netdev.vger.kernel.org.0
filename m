Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E07512F8C2
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 14:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbgACN0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 08:26:20 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:55906 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727494AbgACN0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 08:26:19 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 003D9WTL115180;
        Fri, 3 Jan 2020 13:26:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=faABLOu71+lODjbDQ6nSu1CaZn+sv8YumvLotaVUVnA=;
 b=BhiVQH4g84d24jC3klev0mn4m73nwgF8LFrOYh+pTsj2mUEut/jdp/u32znkTuXzCn2o
 RbV8g23Hw1Exi/UNTIen2TjLfVqMTQTauC2NpnAGrllhyhMzaosJrMr85TA9kttY/uVo
 a9K/5KHSYJPu/NKCqCP/eiPN3oe3U0qZ0f3cziClWBjJGuTRyHHKEtcDZQjMoeW6D5us
 kd78GWrKK+Opz6KhnzUNlbi1a0M82f0y7m7++G86Y1qym6jq+QwwsTxeGO+rii6WUVZ2
 +NwpYJuqhkd1rVMtUQD53JUCIS7Skr2wb0Ivf2Dl/3CC3QSj4u+mGl6eZT/ZrcFegtNi AQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2x5y0pv988-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 13:26:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 003DE650163778;
        Fri, 3 Jan 2020 13:26:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2xa5fga7m8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 13:26:12 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 003DQBYs004754;
        Fri, 3 Jan 2020 13:26:11 GMT
Received: from kadam (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Jan 2020 05:26:10 -0800
Date:   Fri, 3 Jan 2020 16:25:49 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Amrita Patole <longlivelinux@yahoo.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        GR-Linux-NIC-Dev@marvell.com, manishc@marvell.com,
        Amrita Patole <amritapatole@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fixing coding style. Signed-off-by:
 amritapatole@gmail.com
Message-ID: <20200103132506.GK3911@kadam>
References: <20200102072929.21636-1-longlivelinux.ref@yahoo.com>
 <20200102072929.21636-1-longlivelinux@yahoo.com>
 <20200102111653.GB3961630@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200102111653.GB3961630@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=825
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001030126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=886 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001030126
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 02, 2020 at 12:16:53PM +0100, Greg KH wrote:
> On Thu, Jan 02, 2020 at 12:59:29PM +0530, Amrita Patole wrote:
> > From: Amrita Patole <amritapatole@gmail.com>
> > 
> > ---
> >  drivers/staging/qlge/qlge_mpi.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/staging/qlge/qlge_mpi.c b/drivers/staging/qlge/qlge_mpi.c
> > index 9e422bbbb6ab..f63db2c79fac 100644
> > --- a/drivers/staging/qlge/qlge_mpi.c
> > +++ b/drivers/staging/qlge/qlge_mpi.c
> > @@ -136,7 +136,8 @@ static int ql_get_mb_sts(struct ql_adapter *qdev, struct mbox_params *mbcp)
> >  		    ql_read_mpi_reg(qdev, qdev->mailbox_out + i,
> >  				     &mbcp->mbox_out[i]);
> >  		if (status) {
> > -			netif_err(qdev, drv, qdev->ndev, "Failed mailbox read.\n");
> > +			netif_err(qdev, drv, qdev->ndev,
> > +                                  "Failed mailbox read. \n");


			netif_err(qdev, drv, qdev->ndev,
                                  "Failed mailbox read. \n");
				  "Failed mailbox read. \n");


I'm pretty sure this will introduce a couplee new checkpatch warnings...
It should be indented:
[tab][tab][tab][tab][space][space]"Failed mailbox read.\n");

No space after the period, please.

regards,
dan carpenter

