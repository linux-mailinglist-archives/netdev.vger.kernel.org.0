Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8D751A8F28
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 01:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392146AbgDNXbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 19:31:25 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34736 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731539AbgDNXbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 19:31:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03ENSquX113426;
        Tue, 14 Apr 2020 23:31:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=2jdGuo0zoA7vP3fMlIQC/iywu1V4S/KJEoFbomfY6PU=;
 b=L89khCD1ZvrOxy9mRjBEy9Lj1sxEHNSZmyAb7h/LghXcMWVTEs9h8uodB+GTeY1LNv40
 dHA+E8HCErmAWwjGsDhDHxTOjQPpbQ6IT6PVYQPaW1UtqjW6MXKJiOq86+b/Mf0OYG+7
 EijRILdJD/Wn+lJ66KVYocW1feomGjtFdaP9y+WvViwgFNobBmBcLLIAEsd9DtXg9Ldh
 x1KR2cLIdRP3m67izLeNkjTvexNGAaclWbEdIuc+MkI4bJU4aazBt2tWe3fotSm/FHqZ
 lNE5HJ0kcLgIHavZhb7TBcYzUo3b2yNfnv4a1TRW+Vo8R1Exh62IxmmJ+tJIyPaf4j+h 3Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30dn9cgb7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Apr 2020 23:31:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03ENRxY0101491;
        Tue, 14 Apr 2020 23:29:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 30dn99qtx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Apr 2020 23:29:14 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03ENTDMV104232;
        Tue, 14 Apr 2020 23:29:13 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30dn99qtwh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Apr 2020 23:29:13 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03ENTA2l028627;
        Tue, 14 Apr 2020 23:29:10 GMT
Received: from [10.159.137.253] (/10.159.137.253)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Apr 2020 16:29:10 -0700
Subject: Re: [PATCH] net/rds: Use ERR_PTR for rds_message_alloc_sgs()
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        rds-devel@oss.oracle.com
References: <0-v1-a3e19ba593e0+f5-rds_gcc10%jgg@mellanox.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <6ea2ccf7-6bea-3a00-2fe7-79c09c7cb782@oracle.com>
Date:   Tue, 14 Apr 2020 16:29:09 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <0-v1-a3e19ba593e0+f5-rds_gcc10%jgg@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9591 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 bulkscore=0
 priorityscore=1501 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004140167
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/14/20 4:02 PM, Jason Gunthorpe wrote:
> From: Jason Gunthorpe <jgg@mellanox.com>
> 
> Returning the error code via a 'int *ret' when the function returns a
> pointer is very un-kernely and causes gcc 10's static analysis to choke:
> 
> net/rds/message.c: In function ‘rds_message_map_pages’:
> net/rds/message.c:358:10: warning: ‘ret’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>    358 |   return ERR_PTR(ret);
> 
> Use a typical ERR_PTR return instead.
> 
> Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
> ---
Looks good Jason. Thanks !!

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
