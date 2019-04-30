Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98AE4EF95
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 06:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbfD3EZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 00:25:43 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50528 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbfD3EZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 00:25:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3U4NsFP157497;
        Tue, 30 Apr 2019 04:25:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Mb9RbwxX8QI4dGkhYSLrdKoKKBHjSFyPMeVIBLchQcY=;
 b=jFYY8Y/8e9/wt4ZH85LtuN0GVHQHb79s6zGFGMlBeOBnLeZozmQQZyjONSiD1F5An4Uh
 BnnfoIc7w/mIBo2FurAdWEgOS8PIFA3Tu6aAesoedqpZYx983w8/i91q75DDYmrzv57w
 wbYiBfPGzjIaaoxwWCPG5Gd5BTJpYxhMKm7MaOza5zZT4iJVaYNy8BdEzUKNimQtfB8o
 txC2BuIyxdw3TOmcCwPv3zAfPQFedBMLc3VU3hgNaT+XIc56MdAuEpv/j7oxL7jEp+LL
 SRbjbq4dekGRZdARhBfEqPqPgqTWTmBWNpMIXLu3f2mrgCRzWLKL5xJ2E3YvSS9k/Ykd fA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2s5j5txr0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Apr 2019 04:25:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3U4NZeP092158;
        Tue, 30 Apr 2019 04:25:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 2s4yy9aqxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 30 Apr 2019 04:25:25 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x3U4PPnM095590;
        Tue, 30 Apr 2019 04:25:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2s4yy9aqxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Apr 2019 04:25:25 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3U4PNL8006894;
        Tue, 30 Apr 2019 04:25:24 GMT
Received: from santoshs-mbp.lan (/69.181.241.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 29 Apr 2019 21:25:23 -0700
Subject: Re: [PATCH V2] rds: ib: force endiannes annotation
To:     Nicholas Mc Guire <hofrat@osadl.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
References: <1556593977-15828-1-git-send-email-hofrat@osadl.org>
From:   "santosh.shilimkar@oracle.com" <santosh.shilimkar@oracle.com>
Organization: Oracle Corporation
Message-ID: <5ba055e9-5221-bff2-fdd2-d4b837c95ce1@oracle.com>
Date:   Mon, 29 Apr 2019 21:25:15 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1556593977-15828-1-git-send-email-hofrat@osadl.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9242 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=984 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904300028
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/29/19 8:12 PM, Nicholas Mc Guire wrote:
> While the endiannes is being handled correctly as indicated by the comment
> above the offending line - sparse was unhappy with the missing annotation
> as be64_to_cpu() expects a __be64 argument. To mitigate this annotation
> all involved variables are changed to a consistent __le64 and the
>   conversion to uint64_t delayed to the call to rds_cong_map_updated().
> 
> Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
> ---
> 
> Problem located by an experimental coccinelle script to locate
> patters that make sparse unhappy (false positives):
> net/rds/ib_recv.c:827:23: warning: cast to restricted __le64
> 
> V2: Edward Cree <ecree@solarflare.com> rejected the need for using __force
>      here - instead solve the sparse issue by updating all of the involved
>      variables - which results in an identical binary as well without using
>      the __force "solution" to the sparse warning. Thanks !
> 
> Patch was compile-tested with: x86_64_defconfig + INFINIBAND=m, RDS_RDMA=m
> 
> Patch was verified not to change the binary by diffing the
> generated object code before and after applying the patch.
> 
Thanks. I was worried about this macro magic o.w

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>

