Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 240DD1BE257
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 17:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgD2PQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 11:16:14 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24334 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726526AbgD2PQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 11:16:14 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03TF6Q5g018437;
        Wed, 29 Apr 2020 11:16:00 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mh9pwtq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 11:16:00 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03TFBWDb012661;
        Wed, 29 Apr 2020 15:15:58 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 30mcu51w2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 15:15:58 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03TFFucC64159790
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Apr 2020 15:15:56 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E70AEA4079;
        Wed, 29 Apr 2020 15:15:55 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7DE61A4069;
        Wed, 29 Apr 2020 15:15:55 +0000 (GMT)
Received: from [9.145.35.37] (unknown [9.145.35.37])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 Apr 2020 15:15:55 +0000 (GMT)
Subject: Re: [PATCH net-next] net/smc: remove unused inline function
 smc_curs_read
To:     YueHaibing <yuehaibing@huawei.com>, ubraun@linux.ibm.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200429132623.48608-1-yuehaibing@huawei.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
Message-ID: <039d6d59-5dd5-c89a-c174-72f4de3d0098@linux.ibm.com>
Date:   Wed, 29 Apr 2020 17:15:55 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200429132623.48608-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_07:2020-04-29,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 bulkscore=0
 spamscore=0 malwarescore=0 adultscore=0 suspectscore=0 mlxlogscore=843
 impostorscore=0 lowpriorityscore=0 mlxscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290122
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/04/2020 15:26, YueHaibing wrote:
> commit bac6de7b6370 ("net/smc: eliminate cursor read and write calls")
> left behind this.
> 

Thanks, good catch. Your patch will be part of our next patch submission.

Regards, Karsten


> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  net/smc/smc_cdc.h | 17 -----------------
>  1 file changed, 17 deletions(-)
> 
> diff --git a/net/smc/smc_cdc.h b/net/smc/smc_cdc.h
> index 861dc24c588c..5a19e5e2280e 100644
> --- a/net/smc/smc_cdc.h
> +++ b/net/smc/smc_cdc.h
> @@ -97,23 +97,6 @@ static inline void smc_curs_add(int size, union smc_host_cursor *curs,
>  	}
>  }
>  
> -/* SMC cursors are 8 bytes long and require atomic reading and writing */
> -static inline u64 smc_curs_read(union smc_host_cursor *curs,
> -				struct smc_connection *conn)
> -{
> -#ifndef KERNEL_HAS_ATOMIC64
> -	unsigned long flags;
> -	u64 ret;
> -
> -	spin_lock_irqsave(&conn->acurs_lock, flags);
> -	ret = curs->acurs;
> -	spin_unlock_irqrestore(&conn->acurs_lock, flags);
> -	return ret;
> -#else
> -	return atomic64_read(&curs->acurs);
> -#endif
> -}
> -
>  /* Copy cursor src into tgt */
>  static inline void smc_curs_copy(union smc_host_cursor *tgt,
>  				 union smc_host_cursor *src,
> 
