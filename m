Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8177287557
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 15:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730344AbgJHNmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 09:42:00 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48710 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbgJHNl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 09:41:59 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098DYA7v010515;
        Thu, 8 Oct 2020 13:41:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=jzmATnldS38FX6jEZg2vEDqAzZxWXVdxseVpsaZlnC8=;
 b=OKyaTN/isCszNAy9nplOB7QenruZlYnrbOy7JdxYwW0Xwulz9vAs1G6uN5oiDUCJ5pnk
 vpd1Kkh1qycNPwLLp+/yaBROpDdCOTAlrO4zm5hGqnCJbFbCab3XYtwxbVZBl0aGcXvX
 8t7EgD+GxSlJYCdl48mjFZ4F/ikTgIKTh+2lhsPLmGGRsDWlNWZ6EAb71ZFNluspMtgZ
 4wLCH8FGBd37gwYs45bn+0abSoVAHm+oRYyElqHLQ3oYObcAYfd5EZTpswPgS3t1kdwC
 8QBDFRFyMwraE3qMohpcDsv90F2xQyq3Y9huP4eITv2z4dVn9WWKAu1k02XzLGZ7XVTh OA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33xhxn7nb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 13:41:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098DZMha191619;
        Thu, 8 Oct 2020 13:39:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33y2vr250p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 13:39:48 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 098DdlbO007679;
        Thu, 8 Oct 2020 13:39:47 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Oct 2020 06:39:47 -0700
Date:   Thu, 8 Oct 2020 16:39:40 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     devel@driverdev.osuosl.org,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        open list <linux-kernel@vger.kernel.org>,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v1 2/6] staging: qlge: coredump via devlink health
 reporter
Message-ID: <20201008133940.GC1042@kadam>
References: <20201008115808.91850-1-coiby.xu@gmail.com>
 <20201008115808.91850-3-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201008115808.91850-3-coiby.xu@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010080102
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080102
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 08, 2020 at 07:58:04PM +0800, Coiby Xu wrote:
> -static int
> -qlge_reporter_coredump(struct devlink_health_reporter *reporter,
> -			struct devlink_fmsg *fmsg, void *priv_ctx,
> -			struct netlink_ext_ack *extack)
> +static int fill_seg_(struct devlink_fmsg *fmsg,
> +		    struct mpi_coredump_segment_header *seg_header,
> +		    u32 *reg_data)
>  {
> -	return 0;
> +	int i;
> +	int header_size = sizeof(struct mpi_coredump_segment_header);

Please use the sizeof() directly in the code.  Don't introduce
indirection if you can help it.

> +	int regs_num = (seg_header->seg_size - header_size) / sizeof(u32);
> +	int err;
> +

regards,
dan carpenter
