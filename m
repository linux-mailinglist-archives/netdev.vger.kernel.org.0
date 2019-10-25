Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 097EEE4872
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 12:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409382AbfJYKTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 06:19:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49120 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389949AbfJYKTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 06:19:21 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9PA3Z9C190156;
        Fri, 25 Oct 2019 10:19:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Rk1YAxjxd6vBBuEKlpKWUiB6Af/3+SYZJkqaDV7EP5Y=;
 b=qKEQFie++BBeMkZQcWG6GiTD+QuTbscvYjwUBYRBnZLZzD9zClUArCehfbeceEnOcySq
 yJyGDE+OdDbd7U+k5B50C0Q6k5ji6O65ZtUMFD++bqho0HAok+i+jqp3HTP63Ux7pKDF
 xgm/digkj2Fw+OnRQPGFt/ZOxks/MTtxdZu6+yraV4p+9OV410TI654pOIXKLtwA6Ib9
 F3jbZyVSF+3OmwArpWzp1xJrx+hm+IqOcAdvjoqc5yC95EqB9gY/Cbe86Mej55kfzcdF
 Xqy4wdEBnMnid4yrr35PyKHD+F+2aFl1f1v8vb7BmZtflPKPh/N3QrlTFDd7tYL5jczR Xg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2vqswu25ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 10:19:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9P9vCNx010931;
        Fri, 25 Oct 2019 10:19:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2vu0fra5ne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 10:19:13 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9PAJD6u001476;
        Fri, 25 Oct 2019 10:19:13 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 25 Oct 2019 03:19:12 -0700
Date:   Fri, 25 Oct 2019 13:19:05 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Samuil Ivanov <samuil.ivanovbg@gmail.com>
Cc:     gregkh@linuxfoundation.org, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, devel@driverdev.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Staging: qlge: Rename prefix of a function to qlge
Message-ID: <20191025101705.GM24678@kadam>
References: <20191024212941.28149-1-samuil.ivanovbg@gmail.com>
 <20191024212941.28149-2-samuil.ivanovbg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024212941.28149-2-samuil.ivanovbg@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=707
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910250093
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=787 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910250094
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 12:29:39AM +0300, Samuil Ivanov wrote:
> diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
> index 6ec7e3ce3863..e9f1363c5bf2 100644
> --- a/drivers/staging/qlge/qlge.h
> +++ b/drivers/staging/qlge/qlge.h
> @@ -2262,7 +2262,7 @@ int ql_write_mpi_reg(struct ql_adapter *qdev, u32 reg, u32 data);
>  int ql_unpause_mpi_risc(struct ql_adapter *qdev);
>  int ql_pause_mpi_risc(struct ql_adapter *qdev);
>  int ql_hard_reset_mpi_risc(struct ql_adapter *qdev);
> -int ql_soft_reset_mpi_risc(struct ql_adapter *qdev);
> +int qlge_soft_reset_mpi_risc(struct ql_adapter *qdev);

The patch series doesn't change all the functions so now it's hodge
podge.

>  int ql_dump_risc_ram_area(struct ql_adapter *qdev, void *buf, u32 ram_addr,
>  			  int word_count);
>  int ql_core_dump(struct ql_adapter *qdev, struct ql_mpi_coredump *mpi_coredump);
> diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
> index 019b7e6a1b7a..df5344e113ca 100644
> --- a/drivers/staging/qlge/qlge_dbg.c
> +++ b/drivers/staging/qlge/qlge_dbg.c
> @@ -1312,7 +1312,7 @@ void ql_get_dump(struct ql_adapter *qdev, void *buff)
>  
>  	if (!test_bit(QL_FRC_COREDUMP, &qdev->flags)) {
>  		if (!ql_core_dump(qdev, buff))
> -			ql_soft_reset_mpi_risc(qdev);
> +			qlge_soft_reset_mpi_risc(qdev);
>  		else
>  			netif_err(qdev, drv, qdev->ndev, "coredump failed!\n");
>  	} else {
> diff --git a/drivers/staging/qlge/qlge_mpi.c b/drivers/staging/qlge/qlge_mpi.c
> index 9e422bbbb6ab..efe893935929 100644
> --- a/drivers/staging/qlge/qlge_mpi.c
> +++ b/drivers/staging/qlge/qlge_mpi.c
> @@ -88,9 +88,10 @@ int ql_write_mpi_reg(struct ql_adapter *qdev, u32 reg, u32 data)
>  	return status;
>  }
>  
> -int ql_soft_reset_mpi_risc(struct ql_adapter *qdev)
> +int qlge_soft_reset_mpi_risc(struct ql_adapter *qdev)
>  {
>  	int status;
> +
>  	status = ql_write_mpi_reg(qdev, 0x00001010, 1);

This white space change is unrelated.

>  	return status;
>  }

regards,
dan carpenter

