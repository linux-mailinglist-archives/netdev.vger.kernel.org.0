Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95EFD1C6D18
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 11:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728930AbgEFJj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 05:39:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31178 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728306AbgEFJj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 05:39:26 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0469WYVX188321;
        Wed, 6 May 2020 05:39:16 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30s1sxwk3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 05:39:15 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 0469Zux2020607;
        Wed, 6 May 2020 09:39:13 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 30s0g5rvx6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 09:39:13 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0469dBwp51052754
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 May 2020 09:39:11 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09ACB42042;
        Wed,  6 May 2020 09:39:11 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F42F4203F;
        Wed,  6 May 2020 09:39:10 +0000 (GMT)
Received: from [9.145.87.216] (unknown [9.145.87.216])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  6 May 2020 09:39:10 +0000 (GMT)
Subject: Re: [PATCH net-next] net/smc: remove set but not used variables
 'del_llc, del_llc_resp'
To:     YueHaibing <yuehaibing@huawei.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20200506065540.171504-1-yuehaibing@huawei.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
Message-ID: <7e36e689-f5b7-0140-cd04-be62dcf08fbc@linux.ibm.com>
Date:   Wed, 6 May 2020 11:39:12 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200506065540.171504-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-06_03:2020-05-04,2020-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 phishscore=0 adultscore=0
 impostorscore=0 mlxlogscore=999 bulkscore=0 clxscore=1011 suspectscore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005060072
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/05/2020 08:55, YueHaibing wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:

Thank you, good catch. Your patch will be part of our next patch submission.

Regards, Karsten

> 
> net/smc/smc_llc.c: In function 'smc_llc_cli_conf_link':
> net/smc/smc_llc.c:753:31: warning:
>  variable 'del_llc' set but not used [-Wunused-but-set-variable]
>   struct smc_llc_msg_del_link *del_llc;
>                                ^
> net/smc/smc_llc.c: In function 'smc_llc_process_srv_delete_link':
> net/smc/smc_llc.c:1311:33: warning:
>  variable 'del_llc_resp' set but not used [-Wunused-but-set-variable]
>     struct smc_llc_msg_del_link *del_llc_resp;
>                                  ^
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  net/smc/smc_llc.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
> index 4cc583678ac7..391237b601fe 100644
> --- a/net/smc/smc_llc.c
> +++ b/net/smc/smc_llc.c
> @@ -750,7 +750,6 @@ static int smc_llc_cli_conf_link(struct smc_link *link,
>  				 enum smc_lgr_type lgr_new_t)
>  {
>  	struct smc_link_group *lgr = link->lgr;
> -	struct smc_llc_msg_del_link *del_llc;
>  	struct smc_llc_qentry *qentry = NULL;
>  	int rc = 0;
>  
> @@ -764,7 +763,6 @@ static int smc_llc_cli_conf_link(struct smc_link *link,
>  	}
>  	if (qentry->msg.raw.hdr.common.type != SMC_LLC_CONFIRM_LINK) {
>  		/* received DELETE_LINK instead */
> -		del_llc = &qentry->msg.delete_link;
>  		qentry->msg.raw.hdr.flags |= SMC_LLC_FLAG_RESP;
>  		smc_llc_send_message(link, &qentry->msg);
>  		smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
> @@ -1308,16 +1306,12 @@ static void smc_llc_process_srv_delete_link(struct smc_link_group *lgr)
>  		 * enqueued DELETE_LINK request (forward it)
>  		 */
>  		if (!smc_llc_send_message(lnk, &qentry->msg)) {
> -			struct smc_llc_msg_del_link *del_llc_resp;
>  			struct smc_llc_qentry *qentry2;
>  
>  			qentry2 = smc_llc_wait(lgr, lnk, SMC_LLC_WAIT_TIME,
>  					       SMC_LLC_DELETE_LINK);
> -			if (!qentry2) {
> -			} else {
> -				del_llc_resp = &qentry2->msg.delete_link;
> +			if (qentry2)
>  				smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
> -			}
>  		}
>  	}
>  	smcr_link_clear(lnk_del, true);
> 
> 
> 

-- 
Karsten

(I'm a dude)
