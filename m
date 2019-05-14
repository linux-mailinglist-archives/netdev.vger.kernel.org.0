Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C73D31C79A
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 13:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbfENLPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 07:15:47 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56480 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726680AbfENLPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 07:15:46 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4EBDT1C120280
        for <netdev@vger.kernel.org>; Tue, 14 May 2019 07:15:45 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sftxjc8fy-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 14 May 2019 07:13:36 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <ubraun@linux.ibm.com>;
        Tue, 14 May 2019 12:13:24 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 14 May 2019 12:13:22 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4EBDK8Y42270900
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 May 2019 11:13:20 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB811A4040;
        Tue, 14 May 2019 11:13:20 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 841B6A404D;
        Tue, 14 May 2019 11:13:20 +0000 (GMT)
Received: from oc5311105230.ibm.com (unknown [9.152.224.97])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 May 2019 11:13:20 +0000 (GMT)
Subject: Re: [PATCH] net/smc: Fix error path in smc_init
To:     YueHaibing <yuehaibing@huawei.com>, davem@davemloft.net,
        kgraul@linux.ibm.com, hwippel@linux.ibm.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20190514063921.41088-1-yuehaibing@huawei.com>
From:   Ursula Braun <ubraun@linux.ibm.com>
Openpgp: preference=signencrypt
Date:   Tue, 14 May 2019 13:13:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190514063921.41088-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19051411-0012-0000-0000-0000031B819B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051411-0013-0000-0000-000021541946
Message-Id: <73b00d55-dbab-a4d0-97e9-121ce810f012@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-14_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905140082
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/14/19 8:39 AM, YueHaibing wrote:
> If register_pernet_subsys success in smc_init,
> we should cleanup it in case any other error.
> 

Thanks, looks good. Your patch will be part of our next patch
submission.

Regards, Ursula

> Fixes: 64e28b52c7a6 (net/smc: add pnet table namespace support")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  net/smc/af_smc.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index 6f869ef..7d3207f 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -2019,7 +2019,7 @@ static int __init smc_init(void)
>  
>  	rc = smc_pnet_init();
>  	if (rc)
> -		return rc;
> +		goto out_pernet_subsys;
>  
>  	rc = smc_llc_init();
>  	if (rc) {
> @@ -2070,6 +2070,9 @@ static int __init smc_init(void)
>  	proto_unregister(&smc_proto);
>  out_pnet:
>  	smc_pnet_exit();
> +out_pernet_subsys:
> +	unregister_pernet_subsys(&smc_net_ops);
> +
>  	return rc;
>  }
>  
> 

