Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958FE1F969D
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 14:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729866AbgFOMeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 08:34:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51412 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728510AbgFOMeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 08:34:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05FCGm58071550;
        Mon, 15 Jun 2020 12:33:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=VfB/lu0AO11ypagGnxWqguiuvq46jiw7VSNH802i9v0=;
 b=FNZgppN31eRIYqIWCPvoie+HIghJzA0839ih/4QuvBoyjpDs9AztSyNaSrH9kJmSo4R3
 mDsBK7H8K84zCpQvrWgZrRW1aTE7+uqqrwALHiY9SZiq70CmcvKFbnL10rZ0DmZI9maG
 LupyZj159TRdmeYlch79GK6N0Dp4hPSCn6Altpb6A3U9FAAiZf2vdl9bMnIgbPN55Q1j
 VcvHLuQWiucK0HKNaq6kAOr+9Vs5kyBM9a6oibgKhDp/8bAf1sIQq4Q4t7DBpH9V4JCR
 mXPQT2RcLo+mY7/F+BHnxzDrnfyzsX1Nf3QxC+gNz5HiHigDEIBUFs51JDrx3k0cgxlZ zQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31p6e7rs53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 15 Jun 2020 12:33:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05FCIuI0188381;
        Mon, 15 Jun 2020 12:33:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 31p6dd6164-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jun 2020 12:33:51 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05FCXfcc027358;
        Mon, 15 Jun 2020 12:33:42 GMT
Received: from anon-dhcp-153.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Jun 2020 05:33:41 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.14\))
Subject: Re: [PATCH v2] SUNRPC: Add missing definition of
 ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <9e9882a2fb57b6f9d98a0a5d8b6bf9cff9fcbd93.1592202173.git.christophe.leroy@csgroup.eu>
Date:   Mon, 15 Jun 2020 08:33:40 -0400
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <733E4CAF-A9E5-491F-B0C7-69CA84E5DFA5@oracle.com>
References: <9e9882a2fb57b6f9d98a0a5d8b6bf9cff9fcbd93.1592202173.git.christophe.leroy@csgroup.eu>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Bruce Fields <bfields@fieldses.org>
X-Mailer: Apple Mail (2.3445.104.14)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9652 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006150100
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9652 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 impostorscore=0 bulkscore=0 clxscore=1015 malwarescore=0 suspectscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0
 cotscore=-2147483648 priorityscore=1501 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006150100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 15, 2020, at 2:25 AM, Christophe Leroy =
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
> Include linux/highmem.h so that asm/cacheflush.h will be included.
>=20
> Reported-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Chuck Lever <chuck.lever@oracle.com>
> Fixes: ca07eda33e01 ("SUNRPC: Refactor svc_recvfrom()")
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>

LGTM.

Acked-by: Chuck Lever <chuck.lever@oracle.com>


> ---
> v2: Use linux/highmem.h instead of asm/cacheflush.sh
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> ---
> net/sunrpc/svcsock.c | 1 +
> 1 file changed, 1 insertion(+)
>=20
> diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
> index 5c4ec9386f81..c537272f9c7e 100644
> --- a/net/sunrpc/svcsock.c
> +++ b/net/sunrpc/svcsock.c
> @@ -44,6 +44,7 @@
> #include <net/tcp.h>
> #include <net/tcp_states.h>
> #include <linux/uaccess.h>
> +#include <linux/highmem.h>
> #include <asm/ioctls.h>
>=20
> #include <linux/sunrpc/types.h>
> --=20
> 2.25.0
>=20

--
Chuck Lever



