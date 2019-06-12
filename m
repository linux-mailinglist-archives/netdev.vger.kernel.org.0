Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD9442C31
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730403AbfFLQ2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:28:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54112 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405745AbfFLQ2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 12:28:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5CGRqKs166693;
        Wed, 12 Jun 2019 16:27:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=BtyrYOTdSrHiTcGtRyqOs74mIFiGcMgAHiAWh896lrs=;
 b=FLdu7JFmRlwrvUWWXB0G/7LpOxiEPR+lCwHv+y9Ay6N9SFKQjiAJPCjb2NDjBLBVEm2e
 FCY0aKnxtJHIEu7DbkKfNKEoO/G7OGAr37IdXvtARJGcgLb7HOj8f09f6ViIHaHQVxFu
 WiMsHL9aW6o58jJhAFIjDIgocW/3m3znxJEVPl2yFNFtyS7mUfrDmb5Y2W9VoFqqFhsb
 ZWBsPD36jJVGJmMQtj9gUNX+Bw7Sb+k4v0RKFRQOQItXH6lIBwEmvxlmF55vEiVgjD8j
 9PUG0PkS7OvBkHoqPY88y6hjgMjTbQeeNbnlFlWbyvlRQvCelYYiRH1K8ig993c6us6M 9w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2t04etvqgs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 16:27:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5CGQurD041984;
        Wed, 12 Jun 2019 16:27:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2t04j012u9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 16:27:58 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5CGRvb4001914;
        Wed, 12 Jun 2019 16:27:57 GMT
Received: from [10.209.242.19] (/10.209.242.19)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 Jun 2019 09:27:57 -0700
Subject: Re: [PATCH] linux-next: DOC: RDS: Fix a typo in rds.txt
To:     Masanari Iida <standby24x7@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <20190612122934.3515-1-standby24x7@gmail.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <b3fae27d-633d-e164-9f59-44eabf74ed7e@oracle.com>
Date:   Wed, 12 Jun 2019 09:27:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190612122934.3515-1-standby24x7@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9286 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906120111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9286 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906120111
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/12/19 5:29 AM, Masanari Iida wrote:
> This patch fixes a spelling typo in rds.txt
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>   Documentation/networking/rds.txt | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/networking/rds.txt b/Documentation/networking/rds.txt
> index 0235ae69af2a..f2a0147c933d 100644
> --- a/Documentation/networking/rds.txt
> +++ b/Documentation/networking/rds.txt
> @@ -389,7 +389,7 @@ Multipath RDS (mprds)
>     a common (to all paths) part, and a per-path struct rds_conn_path. All
>     I/O workqs and reconnect threads are driven from the rds_conn_path.
>     Transports such as TCP that are multipath capable may then set up a
> -  TPC socket per rds_conn_path, and this is managed by the transport via
> +  TCP socket per rds_conn_path, and this is managed by the transport via
>     the transport privatee cp_transport_data pointer.
>   
>     Transports announce themselves as multipath capable by setting the
> 
Thanks !!

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
