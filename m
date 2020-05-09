Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9061D1CC08C
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 12:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbgEIKvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 06:51:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37226 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726913AbgEIKve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 06:51:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049ApJRr145599;
        Sat, 9 May 2020 10:51:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=iClix6iGeS3i7GMym7ParF65KME/peMHzJR8tma/hLI=;
 b=eoKwoirT7d97vHXNY0d79Xf+vc2xS/XOL5Nm5qzDr1F7Gkv4RouwaNrTL30JH3X6xm7F
 wdFK6+KjedbbKbDAe5LtbOlAQa6HSn0GtRKmWWgLuMjoxTlU1buVR7V3cXgcgnWE5XqS
 N1trN7xLysIls+br53a9HEAOwLvi74ZTQB+5yBM4TP2aT1A2MJP/CVikM/maVyvHuLWG
 vDLYH62s/hCIgQ37Bf6e4BRVS1kluwbeOxfJLGM2XgAL+PXq1qWcOJyeLWcboHp5JEBM
 Av75rUgD0uhM6rsJRm9gsTif9sUKhafOV+XNv2Vk48BpcNJSBaNAAVwrTSYkktrTGGjr mQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30wn5mgm6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 10:51:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049AXgcN112427;
        Sat, 9 May 2020 10:51:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30wmb0xdw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 10:51:27 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 049ApQo3021103;
        Sat, 9 May 2020 10:51:26 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 May 2020 03:51:26 -0700
Date:   Sat, 9 May 2020 13:51:20 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cnic: remove redundant assignment to variable ret
Message-ID: <20200509105120.GH9365@kadam>
References: <20200508224026.483746-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508224026.483746-1-colin.king@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9615 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090098
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9615 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 clxscore=1015 malwarescore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090099
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 08, 2020 at 11:40:26PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable ret is being assigned with a value that is never read,
> the assignment is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

We used to return negative error codes until commit 23021c21055f ("cnic:
Improve error recovery on bnx2x devices").

To be honest, I like the deliberate "ret = 0;" because this code will
trigger a static checker warning about wrong error codes.  Also it looks
wrong to human reviewers.  We should probably add a comment:

	/* Deliberately returning success */
	return 0;

regards,
dan carpenter

