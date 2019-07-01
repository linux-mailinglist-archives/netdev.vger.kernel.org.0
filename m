Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6301C5C42C
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 22:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbfGAUPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 16:15:04 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54400 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbfGAUPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 16:15:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61KDcDS058174;
        Mon, 1 Jul 2019 20:14:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=kngwQIpnoKlukDkYZv2DCm6v1coMkMVylMEl3cmVdr8=;
 b=NJvVmjsaYjrybwu6I0btDKFmFJX8WTsCziZpaTceaQ6ecNZ7l/FDFnffR2Oe6VVUYXU6
 ugvKSjlaTISkv0uNgYAgBAd/APaYIhenOi22PjX0fXU0A0oJoVQX8LC8SuQp0R3QLhAq
 kaRwH8Se56BbMBjEcDdNu9YlUG6U+BxYAc5Of+RjQauqHN3VB3N8Y8t7sMDT3wrd6JkQ
 0UwRFm7zunsmolLXOwi55Nhb+DnuR2PAaC6DVSQaLvCnZRzh3L2md5rooYk6WDzsopJX
 4oMsaDIzqYZ3+ooZioE47tcH+c+Q9J9iMnneP5NXPk/gjYl9vHSIixdtA8WIPRQQSFZU NA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2te5tbfrcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 20:14:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61KD2Vx056574;
        Mon, 1 Jul 2019 20:14:55 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2tebqg4fcd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 20:14:55 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x61KEtw4022862;
        Mon, 1 Jul 2019 20:14:55 GMT
Received: from [10.209.242.148] (/10.209.242.148)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jul 2019 13:14:54 -0700
Subject: Re: [PATCH net-next 5/7] net/rds: Set fr_state only to FRMR_IS_FREE
 if IB_WR_LOCAL_INV had been successful
To:     Gerd Rausch <gerd.rausch@oracle.com>, netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
References: <eb94e6bf-cbde-8cf1-b139-66fc8351f181@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <42f2bf75-f267-7049-57dd-7ccce2ed1337@oracle.com>
Date:   Mon, 1 Jul 2019 13:14:54 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <eb94e6bf-cbde-8cf1-b139-66fc8351f181@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907010234
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907010234
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/1/19 9:40 AM, Gerd Rausch wrote:
> Fix a bug where fr_state first goes to FRMR_IS_STALE, because of a failure
> of operation IB_WR_LOCAL_INV, but then gets set back to "FRMR_IS_FREE"
> uncoditionally, even though the operation failed.
> 
> Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
> ---
>   net/rds/ib_frmr.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/rds/ib_frmr.c b/net/rds/ib_frmr.c
> index 3c953034dca3..a5d8f4128515 100644
> --- a/net/rds/ib_frmr.c
> +++ b/net/rds/ib_frmr.c
> @@ -328,7 +328,8 @@ void rds_ib_mr_cqe_handler(struct rds_ib_connection *ic, struct ib_wc *wc)
>   	}
>   
>   	if (frmr->fr_inv) {
> -		frmr->fr_state = FRMR_IS_FREE;
> +		if (frmr->fr_state == FRMR_IS_INUSE)
> +			frmr->fr_state = FRMR_IS_FREE;
>   		frmr->fr_inv = false;
>   		wake_up(&frmr->fr_inv_done);
>   	}
> 
Looks good to me. Will add this to other fixes.
