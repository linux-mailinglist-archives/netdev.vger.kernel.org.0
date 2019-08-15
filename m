Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8139E8F0B9
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 18:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731447AbfHOQij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 12:38:39 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54196 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728348AbfHOQii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 12:38:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7FGYag6007046;
        Thu, 15 Aug 2019 16:38:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=0WCFUo3AR9Tm+mLXAt+TpV1+0IOiB3yIuOuzXyKfhz0=;
 b=P4uNTkvKt44rIhabEsPl7GnVx+oC3f9RMFq3kRZUm3R5AIr1qiPE3ali0qLU2IvTMKrm
 YJ8+GDQU9WwKN2cgEaRzp1G7DzaFdYr7LEcmvCtaW6r1pv2hfE+fXdF6BpwrgL1M+wJM
 cGfDqF5a4dLD8CSFqunAz3HaKHzkT2u4qyoECOEZmvpEh4Pcl+j5UEtMDBKydSk9ZZmK
 GmLxwxoEB7xko+2fLsPE0yBHxT1X75cQdJjZyscqHuX6OwQxXytT1J6FE93+lC8XiTj5
 AQBOqhtuSGr8UbDg0GZnKwEJLEGNePiH2lZIBHYUqfj9dhwN6/v9ZI/qWcAnOawh5/A8 9A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2u9pjqum47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 16:38:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7FGXqXk171679;
        Thu, 15 Aug 2019 16:36:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 2ucpyshau1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Aug 2019 16:36:35 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7FGY509173824;
        Thu, 15 Aug 2019 16:36:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2ucpyshatm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 16:36:35 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7FGaZKe006130;
        Thu, 15 Aug 2019 16:36:35 GMT
Received: from [10.159.249.63] (/10.159.249.63)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 15 Aug 2019 09:36:34 -0700
Subject: Re: [PATCH net-next] net/rds: Add RDS6_INFO_SOCKETS and
 RDS6_INFO_RECV_MESSAGES options
To:     Ka-Cheong Poon <ka-cheong.poon@oracle.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, rds-devel@oss.oracle.com
References: <1565861803-31268-1-git-send-email-ka-cheong.poon@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <977a6d5b-53e4-87ec-8e5c-57646037e298@oracle.com>
Date:   Thu, 15 Aug 2019 09:36:33 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1565861803-31268-1-git-send-email-ka-cheong.poon@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9350 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908150161
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/15/19 2:36 AM, Ka-Cheong Poon wrote:
> Add support of the socket options RDS6_INFO_SOCKETS and
> RDS6_INFO_RECV_MESSAGES which update the RDS_INFO_SOCKETS and
> RDS_INFO_RECV_MESSAGES options respectively.  The old options work
> for IPv4 sockets only.
> 
> Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
> ---
Thanks Ka-Cheong for getting this one out on list.

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
