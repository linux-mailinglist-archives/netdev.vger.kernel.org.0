Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4AF83355
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 15:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730478AbfHFNw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 09:52:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45816 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbfHFNw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 09:52:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x76DXxiQ085313;
        Tue, 6 Aug 2019 13:52:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=sLQXqKTfAC+DgapIOljC6Hu1hP2ySZexluDwG30necU=;
 b=Y3/5lTgAcSA0tHehdiqZfTT/zElI6h13BR1el/tcfM3XvSzIdBxTUfuYzsKQdv5cR10w
 HPN9S/En9zGsUfiK5q6K3joBnoZqF+agISIJ9PJtKn6DIzvIbegohGn49/Wvxsb9LTEn
 kDCFZkr9HirBEOLGrVgUrBbZj3IBSgn49GxjSyquXuhEUtRhwmL3e8Gke9UgFb2+qhXB
 M//7k5//R6mAdXr75wYmh+GJJ+Q/LvU7znw8NbBcIL7abZ5WrNVFyviM45eoZFegixMC
 SP2MLi8QVEGyu35JbqhQUNHnmn/s8NNRmBoOZC9ASSGL9jgHd8UyQ6kMyefdqth5opVd Xw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2u51ptxcjy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Aug 2019 13:52:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x76DXGId106595;
        Tue, 6 Aug 2019 13:52:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2u75bvh3w9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Aug 2019 13:52:39 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x76DqcuC017738;
        Tue, 6 Aug 2019 13:52:38 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 06 Aug 2019 06:52:37 -0700
Date:   Tue, 6 Aug 2019 16:52:31 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Mao Wenan <maowenan@huawei.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: can: Fix compiling warning
Message-ID: <20190806135231.GJ1974@kadam>
References: <20190802033643.84243-1-maowenan@huawei.com>
 <0050efdb-af9f-49b9-8d83-f574b3d46a2e@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0050efdb-af9f-49b9-8d83-f574b3d46a2e@hartkopp.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9340 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=843
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908060138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9340 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=891 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908060138
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 02, 2019 at 10:10:20AM +0200, Oliver Hartkopp wrote:
> On 02/08/2019 05.36, Mao Wenan wrote:
> > There are two warings in net/can, fix them by setting bcm_sock_no_ioctlcmd
> > and raw_sock_no_ioctlcmd as static.
> > 
> > net/can/bcm.c:1683:5: warning: symbol 'bcm_sock_no_ioctlcmd' was not declared. Should it be static?
> > net/can/raw.c:840:5: warning: symbol 'raw_sock_no_ioctlcmd' was not declared. Should it be static?
> > 
> > Fixes: 473d924d7d46 ("can: fix ioctl function removal")
> > 
> > Signed-off-by: Mao Wenan <maowenan@huawei.com>
> 
> Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
> 
> Thanks Mao!
> 
> Btw. what kind of compiler/make switches are you using so that I can see
> these warnings myself the next time?

These are Sparse warnings, not from GCC.

regards,
dan carpenter

