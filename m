Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 281863AFF8F
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 10:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhFVIsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 04:48:54 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:4666 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229490AbhFVIsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 04:48:53 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15M8gDjK013957;
        Tue, 22 Jun 2021 08:46:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=A3r2KM1U5npDvFVZxZTNcLxjpBA75n/lIxXbDb5XcGM=;
 b=dow6+rpm535alR9p/eAeZiaH8JTZQ/wGLthfsAkjM/Rg+YpFnAwPL7UUOOdpkhMoDrAR
 V8xszi+4+EN8bZVG+x+gyGWn6WeADllasJu810MesCwgjME+UYVgTR83iqmex4AvR8Us
 bRmFoek1ic+B60NkXPrve+74oJ67k4pBp/Om/wQ8REVDaAlaBhRRoHwFfNrOsdE1EJJn
 IVZpcqzgLPMOx1mS3kS6fqp3skzLopZjDY1TMJu1tOBZFA4+qeSZ1/kbQjrAXbW0kEm4
 swRDdO9lD/4Qdd0qBKBpDqJBoDVDpT7rpp1pyEpvUaVk0DtaK0gI9IoSvyf5gi2TXCw3 Bg== 
Received: from oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39acyqbc2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 08:46:22 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15M8kMAu181288;
        Tue, 22 Jun 2021 08:46:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3998d729nw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 08:46:22 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15M8kLWw181263;
        Tue, 22 Jun 2021 08:46:21 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3998d729nk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 08:46:21 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 15M8kK1I009864;
        Tue, 22 Jun 2021 08:46:20 GMT
Received: from kadam (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Jun 2021 01:46:19 -0700
Date:   Tue, 22 Jun 2021 11:46:11 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     linux-staging@lists.linux.dev, netdev@vger.kernel.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:CLANG/LLVM BUILD SUPPORT" 
        <clang-built-linux@googlegroups.com>
Subject: Re: [RFC 17/19] staging: qlge: fix weird line wrapping
Message-ID: <20210622084611.GM1861@kadam>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
 <20210621134902.83587-18-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621134902.83587-18-coiby.xu@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-GUID: rWfi0exMPgDUX5UtGmlftWnwzClz0ePZ
X-Proofpoint-ORIG-GUID: rWfi0exMPgDUX5UtGmlftWnwzClz0ePZ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 21, 2021 at 09:49:00PM +0800, Coiby Xu wrote:
> @@ -524,8 +523,8 @@ static int qlge_set_routing_reg(struct qlge_adapter *qdev, u32 index, u32 mask,
>  		{
>  			value = RT_IDX_DST_DFLT_Q | /* dest */
>  				RT_IDX_TYPE_NICQ | /* type */
> -				(RT_IDX_IP_CSUM_ERR_SLOT <<
> -				RT_IDX_IDX_SHIFT); /* index */
> +			(RT_IDX_IP_CSUM_ERR_SLOT
> +			 << RT_IDX_IDX_SHIFT); /* index */

The original is not great but the new indenting is definitely worse.
It might look nicer with the comments moved in the front?  Why does
RT_IDX_IDX_SHIFT have two IDX strings?

			/* value = dest | type | index; */
			value = RT_IDX_DST_DFLT_Q |
				RT_IDX_TYPE_NICQ  |
				(RT_IDX_IP_CSUM_ERR_SLOT << RT_IDX_IDX_SHIFT);


>  			break;
>  		}
>  	case RT_IDX_TU_CSUM_ERR: /* Pass up TCP/UDP CSUM error frames. */
> @@ -554,7 +553,8 @@ static int qlge_set_routing_reg(struct qlge_adapter *qdev, u32 index, u32 mask,
>  		{
>  			value = RT_IDX_DST_DFLT_Q |	/* dest */
>  			    RT_IDX_TYPE_NICQ |	/* type */
> -			    (RT_IDX_MCAST_MATCH_SLOT << RT_IDX_IDX_SHIFT);/* index */
> +			(RT_IDX_MCAST_MATCH_SLOT
> +			 << RT_IDX_IDX_SHIFT); /* index */

Original is better.

>  			break;
>  		}
>  	case RT_IDX_RSS_MATCH:	/* Pass up matched RSS frames. */
> @@ -648,15 +648,15 @@ static int qlge_read_flash_word(struct qlge_adapter *qdev, int offset, __le32 *d
>  {
>  	int status = 0;
>  	/* wait for reg to come ready */
> -	status = qlge_wait_reg_rdy(qdev,
> -				   FLASH_ADDR, FLASH_ADDR_RDY, FLASH_ADDR_ERR);
> +	status = qlge_wait_reg_rdy(qdev, FLASH_ADDR, FLASH_ADDR_RDY,
> +				   FLASH_ADDR_ERR);
>  	if (status)
>  		goto exit;
>  	/* set up for reg read */
>  	qlge_write32(qdev, FLASH_ADDR, FLASH_ADDR_R | offset);
>  	/* wait for reg to come ready */
> -	status = qlge_wait_reg_rdy(qdev,
> -				   FLASH_ADDR, FLASH_ADDR_RDY, FLASH_ADDR_ERR);
> +	status = qlge_wait_reg_rdy(qdev, FLASH_ADDR, FLASH_ADDR_RDY,
> +				   FLASH_ADDR_ERR);
>  	if (status)
>  		goto exit;
>  	/* This data is stored on flash as an array of
> @@ -792,8 +792,8 @@ static int qlge_write_xgmac_reg(struct qlge_adapter *qdev, u32 reg, u32 data)
>  {
>  	int status;
>  	/* wait for reg to come ready */
> -	status = qlge_wait_reg_rdy(qdev,
> -				   XGMAC_ADDR, XGMAC_ADDR_RDY, XGMAC_ADDR_XME);
> +	status = qlge_wait_reg_rdy(qdev, XGMAC_ADDR, XGMAC_ADDR_RDY,
> +				   XGMAC_ADDR_XME);
>  	if (status)
>  		return status;
>  	/* write the data to the data reg */
> @@ -811,15 +811,15 @@ int qlge_read_xgmac_reg(struct qlge_adapter *qdev, u32 reg, u32 *data)
>  {
>  	int status = 0;
>  	/* wait for reg to come ready */
> -	status = qlge_wait_reg_rdy(qdev,
> -				   XGMAC_ADDR, XGMAC_ADDR_RDY, XGMAC_ADDR_XME);
> +	status = qlge_wait_reg_rdy(qdev, XGMAC_ADDR, XGMAC_ADDR_RDY,
> +				   XGMAC_ADDR_XME);

Need a blank line after the declaration block.

>  	if (status)
>  		goto exit;
>  	/* set up for reg read */
>  	qlge_write32(qdev, XGMAC_ADDR, reg | XGMAC_ADDR_R);
>  	/* wait for reg to come ready */
> -	status = qlge_wait_reg_rdy(qdev,
> -				   XGMAC_ADDR, XGMAC_ADDR_RDY, XGMAC_ADDR_XME);
> +	status = qlge_wait_reg_rdy(qdev, XGMAC_ADDR, XGMAC_ADDR_RDY,
> +				   XGMAC_ADDR_XME);
>  	if (status)
>  		goto exit;
>  	/* get the data */

regards,
dan carpenter
