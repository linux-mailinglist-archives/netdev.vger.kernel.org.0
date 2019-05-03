Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 568E2132B9
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 19:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728702AbfECRCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 13:02:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56318 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726724AbfECRCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 13:02:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x43GxPbM141123;
        Fri, 3 May 2019 17:02:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=BncSkmKFfSjgngfBN0eKIEFvp3WAo4qj1izyOTi5oSU=;
 b=Laftfx5AdthWx83pArbwSNaQCp2334pSq8Nd3V+Lf4APplC9cbaTIUg0gREZxZKNfIzt
 xbHhLDOisBrHOFg+HrjZG1jjrScs+5RF2go67GY1u2odxUp4LF83/0LcyAFD62qDvVDn
 SJx57SB5qA0vXf3la01p3Hqx/xygF05KacrwvMo4qqLsr0qkd2Xd7htbwst8ER4NzOn4
 4zkbYsAa0wja5JzjTMTIv3cx/dv8AWQFQxYIGfKNwqI6JTF58bBfHg+61e+jnYcWcQIn
 fqS1V5AnE0lz6R5t2nE39ct+/5UR4Hshk6mh8khKM/UmG+f6g/M5sa2kLAManHrq3pEL RA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2s6xhyr3ts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 May 2019 17:02:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x43H18eQ143976;
        Fri, 3 May 2019 17:02:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 2s6xhhqx69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 03 May 2019 17:02:25 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x43H2PZq147775;
        Fri, 3 May 2019 17:02:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2s6xhhqx61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 May 2019 17:02:25 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x43H2OEZ010679;
        Fri, 3 May 2019 17:02:24 GMT
Received: from [10.209.243.127] (/10.209.243.127)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 May 2019 10:02:24 -0700
Subject: Re: [PATCH] net: rds: fix spelling mistake "syctl" -> "sysctl"
To:     Colin King <colin.king@canonical.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190503121017.5227-1-colin.king@canonical.com>
From:   Santosh Shilimkar <santosh.shilimkar@oracle.com>
Organization: Oracle Corporation
Message-ID: <0fc4a8a5-d275-ef2c-3cbc-5cfa97fe6881@oracle.com>
Date:   Fri, 3 May 2019 10:05:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190503121017.5227-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9245 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=802 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905030109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/3/2019 5:10 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in a pr_warn warning. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
