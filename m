Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB3CB24A519
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 19:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgHSRkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 13:40:43 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54770 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgHSRkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 13:40:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07JHbmTo002866;
        Wed, 19 Aug 2020 17:40:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=aJ0lUCXdyfNTjXmXrU81lxUeJv9n2ZYKi+LgxXWycLA=;
 b=CRMBno42IJuj0Pw4iHyQyTMY6lXlIdlwZTIddMrwfcyCMOVlHCIf4hYIk5LtNJADCN0r
 /QZSOmLvEWDzldoN1zl2DTkRo65AbTz3PL44YyrxpTJgmhTdrYEFrJfCC02IKuHJJs9G
 x9gIoh2SRobBO/Tih1akw5nPr7EZ6Z9/eDxcQMaeOb6f99THBPJPDbJCGQVjEF+K33Ix
 dA9iWdZeSX6RmNM0rpX5eFh8HkO5nG9paqMvGmqV3YbYtpMPXmj/4NEfu+CU4u7aBmxw
 uKJ8aP/+pGrjGAa71q0/hPh3QbP0ZiWxQFlRKrBnOrV0NzhUhW/nr2n94ps8JMczsH0q SA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 32x7nmkyja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 19 Aug 2020 17:40:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07JHcISp107375;
        Wed, 19 Aug 2020 17:40:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 32xsftruej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Aug 2020 17:40:09 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07JHe4Me015033;
        Wed, 19 Aug 2020 17:40:04 GMT
Received: from anon-dhcp-152.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Aug 2020 10:40:04 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH net-next] SUNRPC: remove duplicate include
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <20200819024943.26850-1-wanghai38@huawei.com>
Date:   Wed, 19 Aug 2020 13:40:01 -0400
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Bruce Fields <bfields@fieldses.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <EFE54752-7DA7-465C-908B-F46B89DC3C2A@oracle.com>
References: <20200819024943.26850-1-wanghai38@huawei.com>
To:     Wang Hai <wanghai38@huawei.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9718 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9718 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008190145
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 18, 2020, at 10:49 PM, Wang Hai <wanghai38@huawei.com> wrote:
> 
> Remove linux/sunrpc/auth_gss.h which is included more than once
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>

I've reviewed and compile-tested this, so no objection from me.

Since this duplicate was introduced in nfsd-5.9, I can take this
for an nfsd-5.9-rc pull, if there are no other objections.


> ---
> net/sunrpc/auth_gss/trace.c | 1 -
> 1 file changed, 1 deletion(-)
> 
> diff --git a/net/sunrpc/auth_gss/trace.c b/net/sunrpc/auth_gss/trace.c
> index d26036a57443..76685abba60f 100644
> --- a/net/sunrpc/auth_gss/trace.c
> +++ b/net/sunrpc/auth_gss/trace.c
> @@ -9,7 +9,6 @@
> #include <linux/sunrpc/svc_xprt.h>
> #include <linux/sunrpc/auth_gss.h>
> #include <linux/sunrpc/gss_err.h>
> -#include <linux/sunrpc/auth_gss.h>
> 
> #define CREATE_TRACE_POINTS
> #include <trace/events/rpcgss.h>
> -- 
> 2.17.1
> 

--
Chuck Lever



