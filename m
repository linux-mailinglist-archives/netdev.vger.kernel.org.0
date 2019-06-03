Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32602326D4
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 05:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbfFCDDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 23:03:20 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:51224 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfFCDDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 23:03:20 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x532rwZk018629;
        Mon, 3 Jun 2019 03:03:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : cc : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=6ylz5I4VHlNveusG0wbyKoE8rzqoR1wJmxiYoM6U6yA=;
 b=SHn27NHI/y4pNhAQCv8LH29upSuVAMEYlDyrTqPTb7lHflcToYcd/FNpvINvZh/yadhl
 Uks5xXxKHg7B5nfPdvxQQl0wO4IyHR1tW0ttoaUk6pJa1tFVfNHpqTXdk93VFmaYlOdn
 vNXuY5DFVDtIlqiUGCp7yiPtlnUd10xnGKGfFylVaIdc9bKUbevskUF4p3ICsuF2LIYa
 D/PyYDOOi7RAnvYgk6KCgUnFLI1r8zTqRC64b/RMRn1LeKZY4qXzYPBgQY4VY7lfpjl9
 JLrNngxSqA+gsBV8X03ijARN5LhwKAWR1UoRXxm800xLQ0onT3vpgXxudQKj2x3iU1WF OA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 2suevd4gkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jun 2019 03:03:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5332o3q085675;
        Mon, 3 Jun 2019 03:03:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 2svbbuwcrk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 03 Jun 2019 03:03:12 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x5333BvH086136;
        Mon, 3 Jun 2019 03:03:11 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2svbbuwcre-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jun 2019 03:03:11 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5333Aoh024863;
        Mon, 3 Jun 2019 03:03:10 GMT
Received: from santoshs-mbp-3.lan (/69.181.241.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 02 Jun 2019 20:03:10 -0700
Subject: Re: [PATCH 1/1] net: rds: add per rds connection cache statistics
To:     Zhu Yanjun <yanjun.zhu@oracle.com>
References: <1559375674-17913-1-git-send-email-yanjun.zhu@oracle.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        rds-devel@oss.oracle.com
From:   "santosh.shilimkar@oracle.com" <santosh.shilimkar@oracle.com>
Organization: Oracle Corporation
Message-ID: <c9164a0b-fb6f-b3ab-1d38-76413e4820b2@oracle.com>
Date:   Sun, 2 Jun 2019 20:03:02 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1559375674-17913-1-git-send-email-yanjun.zhu@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9276 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906030019
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/1/19 12:54 AM, Zhu Yanjun wrote:
> The variable cache_allocs is to indicate how many frags (KiB) are in one
> rds connection frag cache.
> The command "rds-info -Iv" will output the rds connection cache
> statistics as below:
> "
> RDS IB Connections:
>        LocalAddr RemoteAddr Tos SL  LocalDev            RemoteDev
>        1.1.1.14 1.1.1.14   58 255  fe80::2:c903:a:7a31 fe80::2:c903:a:7a31
>        send_wr=256, recv_wr=1024, send_sge=8, rdma_mr_max=4096,
>        rdma_mr_size=257, cache_allocs=12
> "
> This means that there are about 12KiB frag in this rds connection frag
>   cache.
> 
> Tested-by: RDS CI <rdsci_oslo@no.oracle.com>
Please add some valid email id or drop above. Its expected
that with SOB, patches are tested before testing.

> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
> ---
>   include/uapi/linux/rds.h | 2 ++
>   net/rds/ib.c             | 2 ++
>   2 files changed, 4 insertions(+)
> 
> diff --git a/include/uapi/linux/rds.h b/include/uapi/linux/rds.h
> index 5d0f76c..fd6b5f6 100644
> --- a/include/uapi/linux/rds.h
> +++ b/include/uapi/linux/rds.h
> @@ -250,6 +250,7 @@ struct rds_info_rdma_connection {
>   	__u32		rdma_mr_max;
>   	__u32		rdma_mr_size;
>   	__u8		tos;
> +	__u32		cache_allocs;
Some of this header file changes, how is taking care of backward
compatibility with tooling ? This was one of the reason, the
all the fields are not updated.

Regards,
Santosh
