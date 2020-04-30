Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCB81C01CB
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgD3QLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:11:00 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48824 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbgD3QLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 12:11:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UG9P7i018332;
        Thu, 30 Apr 2020 16:10:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=cGBuAWcMSJuK2HC9O6Fm+m3T13l5AKHSgVbckXcZcws=;
 b=X+Sn+ll5H98DPvH7VO7oG3aYaZVmj8JKTknXpDbnFeO3k0GpQkGIg4cqwL7XrTCEt9Vt
 xa8JggswfIUaz2bVM7OZBz1mVTDARGX/fwas8lZMZIYHcvXapo7WCNp3XQgFeM3EqCbP
 7gw4vmHzHnlKoeUggE18jdHpc6WTkofF+g7AI4BJdz3DZPNOaqIQn4L05ctekAtou3rx
 PqvngvS78QAY0vAfrTRWJZmXi1poDS0Hhl9+gzzJnogYDWnuBBGcW1v/Nc04T5n7ab9o
 2pSe1VhnH37+jTnJvYc1gkXp4w6Jsp7GDCjGvd7kFqljOhIcK1SmYbvnwmrPl/KW/CJe cg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30p01p2y1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 16:10:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UG8RaZ075430;
        Thu, 30 Apr 2020 16:08:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 30qtkwpg1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 30 Apr 2020 16:08:53 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03UG8qd9077324;
        Thu, 30 Apr 2020 16:08:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 30qtkwpg1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 16:08:52 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03UG8oep011597;
        Thu, 30 Apr 2020 16:08:51 GMT
Received: from [10.159.147.146] (/10.159.147.146)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 09:08:50 -0700
Subject: Re: [PATCH 24/37] docs: networking: convert rds.txt to ReST
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
References: <cover.1588261997.git.mchehab+huawei@kernel.org>
 <6c2adf3f895bea317c2f69cb14e2cf0eb203ac64.1588261997.git.mchehab+huawei@kernel.org>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <871049f9-9d40-8fcd-f525-d30facd757d4@oracle.com>
Date:   Thu, 30 Apr 2020 09:08:49 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <6c2adf3f895bea317c2f69cb14e2cf0eb203ac64.1588261997.git.mchehab+huawei@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 clxscore=1011
 phishscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300128
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/30/20 9:04 AM, Mauro Carvalho Chehab wrote:
> - add SPDX header;
> - add a document title;
> - mark code blocks and literals as such;
> - mark tables as such;
> - mark lists as such;
> - adjust identation, whitespaces and blank lines where needed;
> - add to networking/index.rst.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
