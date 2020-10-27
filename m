Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0DB429C51E
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 19:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1824209AbgJ0SEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 14:04:09 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57676 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756932AbgJ0OSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 10:18:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09REFYLh152692;
        Tue, 27 Oct 2020 14:18:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=nI3m8Y8OcNr/GVLvzRaUSo3wS/gzjtSUTYSe1wHMf7I=;
 b=FiY6WeDkT1tv1bqtXDMVPDMn/ZfLQafK5QYzCeaSQEjmjVkjoWPvrtzF+u0R5wemHtYc
 /tqFB650oaiDzjAbPhkeNM5u68OvWKV7nzwTjWuflPLTPNvwe3FcjxNe13JVtHWwYx3q
 AjwjNmDdk6IDarj64ypIgDzyWUAa8VeW9YqwZsqGjBOdQmV/Qw37YEFQ5LqYZ7jxmEmq
 12R2FVYR3ewbtgDSegc+geLz7MF+IF4XJs1OOh6ipXV0bflV5nHTJZyFJb9Et5f2Ox7n
 0xoSoQPtX96MuDpsf+XqqjIiKnhdmKPeR32sASuG9g5qUs5PzWp4NrGzYv3X4gHPvPEH rA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34cc7kt7rq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 14:18:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09REG2Dc089358;
        Tue, 27 Oct 2020 14:18:38 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34cx5x66pu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 14:18:38 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09REIb8x025107;
        Tue, 27 Oct 2020 14:18:37 GMT
Received: from [10.159.235.220] (/10.159.235.220)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 07:18:37 -0700
Subject: Re: [PATCH 0/2] rds: MR(Memory Region) related patches
To:     santosh.shilimkar@oracle.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rama.nichanamatlu@oracle.com
References: <1603144088-8769-1-git-send-email-manjunath.b.patil@oracle.com>
From:   Manjunath Patil <manjunath.b.patil@oracle.com>
Organization: Oracle Corporation
Message-ID: <dab2480c-64d9-0238-7737-eb0b2738922e@oracle.com>
Date:   Tue, 27 Oct 2020 07:18:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1603144088-8769-1-git-send-email-manjunath.b.patil@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=1 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270090
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=1
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270090
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ping!

On 10/19/2020 2:48 PM, Manjunath Patil wrote:
> This patchset intends to add functionality to track MR usages by RDS
> applications.
>
> Manjunath Patil (2):
>    rds: track memory region (MR) usage in kernel
>    rds: add functionality to print MR related information
>
>   include/uapi/linux/rds.h | 13 ++++++++++++-
>   net/rds/af_rds.c         | 42 ++++++++++++++++++++++++++++++++++++++++
>   net/rds/ib.c             |  1 +
>   net/rds/rdma.c           | 29 ++++++++++++++++++++-------
>   net/rds/rds.h            | 10 +++++++++-
>   5 files changed, 86 insertions(+), 9 deletions(-)
>

