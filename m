Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 659221F8A3F
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 20:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbgFNS6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 14:58:47 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55666 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbgFNS6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 14:58:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05EIwErC037412;
        Sun, 14 Jun 2020 18:58:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=G8d/aFm0OTCgG9TstynHLheRBA0bCU94tXusK30fNPM=;
 b=dU6PsS0XtzkNFUh/7jz9ShJtj8DxGWIM+S0A04EIT+FMZ2ZZhY07bIlmbbFvTbcc9ub1
 bC5k/YJmhgHNHs1ZcM0Q+dC1XvSn+EnF+SavWMfnv6ius+RbE9aFY9BX/N5tjKhFhJTm
 PSMNDDqKavTSFR/ffeMf+mpyQD0dRVuZtp5l1o+UIMwpap9vQp/w8zLcRqg3tEZigj9h
 iNJKx1j6W9lvp/dwjeoVYO8wV1SZWwAQYHc+v4sBQxocCMXYNCBCQ9Fed31k8U3URFgh
 xXNSGUVoiqr2d3aqlBemzac+CvalsAPEJWigovejGGhbs/OQIeShCpinsCnZfee5X+Fl dg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31na6k1j22-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 14 Jun 2020 18:58:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05EIvsO3154764;
        Sun, 14 Jun 2020 18:58:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31n8jpu60j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 14 Jun 2020 18:58:13 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05EIw0FP021590;
        Sun, 14 Jun 2020 18:58:00 GMT
Received: from anon-dhcp-153.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 14 Jun 2020 11:57:59 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.14\))
Subject: Re: [PATCH] SUNRPC: Add missing asm/cacheflush.h
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <a356625c9aa1b5d711e320c39779e0c713f204cb.1592154127.git.christophe.leroy@csgroup.eu>
Date:   Sun, 14 Jun 2020 14:57:58 -0400
Cc:     Bruce Fields <bfields@fieldses.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <854D2842-6940-42BA-A48C-AE9DB48E6071@oracle.com>
References: <a356625c9aa1b5d711e320c39779e0c713f204cb.1592154127.git.christophe.leroy@csgroup.eu>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
X-Mailer: Apple Mail (2.3445.104.14)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9652 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006140169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9652 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxlogscore=999
 clxscore=1011 suspectscore=0 priorityscore=1501 phishscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 adultscore=0 spamscore=0
 cotscore=-2147483648 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006140169
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christophe -

> On Jun 14, 2020, at 1:07 PM, Christophe Leroy =
<christophe.leroy@csgroup.eu> wrote:
>=20
> Even if that's only a warning, not including asm/cacheflush.h
> leads to svc_flush_bvec() being empty allthough powerpc defines
> ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE.
>=20
>  CC      net/sunrpc/svcsock.o
> net/sunrpc/svcsock.c:227:5: warning: =
"ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE" is not defined [-Wundef]
> #if ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
>     ^
>=20
> Fixes: ca07eda33e01 ("SUNRPC: Refactor svc_recvfrom()")
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> ---
> I detected this on linux-next on June 4th and warned Chuck. Seems like =
it went into mainline anyway.

Thanks for your patch. I've searched my mailbox. It appears I never
received your June 4th e-mail.

Does your patch also address:

   https://marc.info/?l=3Dlinux-kernel&m=3D159194369128024&w=3D2 ?

If so, then

   Reported-by: kernel test robot <lkp@intel.com>

should be added to the patch description.

Ideally, compilation on x86_64 should have thrown the same warning,
but it didn't. Why would the x86_64 build behave differently than
ppc64 or i386?


> net/sunrpc/svcsock.c | 1 +
> 1 file changed, 1 insertion(+)
>=20
> diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
> index 5c4ec9386f81..d9e99cb09aab 100644
> --- a/net/sunrpc/svcsock.c
> +++ b/net/sunrpc/svcsock.c
> @@ -45,6 +45,7 @@
> #include <net/tcp_states.h>
> #include <linux/uaccess.h>
> #include <asm/ioctls.h>
> +#include <asm/cacheflush.h>

Nit: Let's include <linux/highmem.h> in net/sunrpc/svcsock.h instead
of <asm/cacheflush.h> directly.


> #include <linux/sunrpc/types.h>
> #include <linux/sunrpc/clnt.h>
> --=20
> 2.25.0
>=20

--
Chuck Lever



