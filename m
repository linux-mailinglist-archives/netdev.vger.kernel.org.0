Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09C53A35DC
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 13:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbfH3Lku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 07:40:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45346 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727522AbfH3Lku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 07:40:50 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7UBde2S126881;
        Fri, 30 Aug 2019 11:40:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=yqSrN+6+KMMDfg+PxkrIofOpt0tSVPRo31ol9j6PTLc=;
 b=IMMKm4hoKJY1YUo0HLPWD4k5YmeYTlJGioCScqyvimEvPfY+uIzilJceMiTxDItxj2zT
 v+XxePSgMNHkjbwwSNfihYH9GDDyyh79fdwI7Q0hYb+OXa3jF+6R5Mm3QYXGCXYdyTlN
 MSScxoPnI8NXvnIioXzHb7ZsPovc9xc5YZe5Wfhq3K5v1UAmV6tyVei90E92VLEzygjE
 5HEttDUnMxPucJf+zRUh8Vhx4XR6o/x/7U9xoGuZ2jYAIUqP0sEj2wcVIlLdiUzlp5NC
 aMk75/bOcfxKnVLrDuWZ97RPj0lLsYvM0eM9hGfdO4MPnj0E9w2Aa0DXy55+1SaIrr9N rw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2uq346r05y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 11:40:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7UBdOMH091066;
        Fri, 30 Aug 2019 11:40:40 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2uphav2vbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 11:40:40 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7UBed7X017667;
        Fri, 30 Aug 2019 11:40:39 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 30 Aug 2019 04:40:38 -0700
Date:   Fri, 30 Aug 2019 14:40:29 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        linux-wimax@intel.com, "David S . Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][V2] wimax/i2400m: remove debug containing bogus
 calculation of index
Message-ID: <20190830114029.GM23584@kadam>
References: <20190830090711.15300-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830090711.15300-1-colin.king@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908300127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908300127
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 30, 2019 at 10:07:11AM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The subtraction of the two pointers is automatically scaled by the
> size of the size of the object the pointers point to, so the division
> by sizeof(*i2400m->barker) is incorrect.  This has been broken since
> day one of the driver and is only debug, so remove the debug completely.
> 
> Also move && in condition to clean up a checkpatch warning.
> 
> Addresses-Coverity: ("Extra sizeof expression")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

