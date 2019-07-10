Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 813126483E
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 16:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbfGJOYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 10:24:10 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49486 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbfGJOYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 10:24:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6AENWWI165347;
        Wed, 10 Jul 2019 14:24:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=3H8RgPo4TLrWwG07Ouzkjn855N2sjWMriqIALw0SuqA=;
 b=o21Ad0OdRE5Yu2bHGTEvqGXbfqPuu1vxu+DBVlBqNmSFdTRcLhj7nrK24xBzVIbr8yE7
 O9M+QDL3FPPDXXoGKtpFEnEjkBnvWGr5gTzXlQJbAE+z7+gQTHKdGS2+JPSAIL6FAlam
 iJGpIf3Gv+MP/72ao5AuNzufcXXc5NYnQMM8tByONDUusvV1HQFfG9IAJX+0xxHyj8Im
 ndqYRucpMSxBWCOUzRzcR64i1SNevgTwgkvc1AYLDLMSJ9u9z03zRoo7AbAsOiXDj7zG
 LC8XISV5kPRn7zNgPg7h+bS+W3l2oUF+RSlxjxHkhVAUPkkQh9QhwrSipU+SbGfPHOkg Xg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2tjkkptfpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 14:24:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6AENGG2175728;
        Wed, 10 Jul 2019 14:24:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2tmmh3jme9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 14:24:05 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6AEO4Mb026360;
        Wed, 10 Jul 2019 14:24:04 GMT
Received: from [10.182.69.170] (/10.182.69.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 10 Jul 2019 07:24:04 -0700
Subject: Re: [net][PATCH 4/5] rds: Return proper "tos" value to user-space
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org, davem@davemloft.net
References: <1562736764-31752-1-git-send-email-santosh.shilimkar@oracle.com>
 <1562736764-31752-5-git-send-email-santosh.shilimkar@oracle.com>
From:   Yanjun Zhu <yanjun.zhu@oracle.com>
Organization: Oracle Corporation
Message-ID: <2f0c5ba9-9b38-f2f1-79c0-f3d6251c2c8a@oracle.com>
Date:   Wed, 10 Jul 2019 22:25:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1562736764-31752-5-git-send-email-santosh.shilimkar@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907100167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907100167
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/7/10 13:32, Santosh Shilimkar wrote:
> From: Gerd Rausch <gerd.rausch@oracle.com>
>
> The proper "tos" value needs to be returned
> to user-space (sockopt RDS_INFO_CONNECTIONS).
>
> Fixes: 3eb450367d08 ("rds: add type of service(tos) infrastructure")
> Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
> Reviewed-by: Zhu Yanjun <yanjun.zhu@oracle.com>

Thanks. I am OK with this.

Zhu Yanjun

> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
> ---
>   net/rds/connection.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index 7ea134f..ed7f213 100644
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c
> @@ -736,6 +736,7 @@ static int rds_conn_info_visitor(struct rds_conn_path *cp, void *buffer)
>   	cinfo->next_rx_seq = cp->cp_next_rx_seq;
>   	cinfo->laddr = conn->c_laddr.s6_addr32[3];
>   	cinfo->faddr = conn->c_faddr.s6_addr32[3];
> +	cinfo->tos = conn->c_tos;
>   	strncpy(cinfo->transport, conn->c_trans->t_name,
>   		sizeof(cinfo->transport));
>   	cinfo->flags = 0;
