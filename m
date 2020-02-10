Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 884D9157F79
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 17:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbgBJQJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 11:09:33 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48958 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727120AbgBJQJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 11:09:33 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01AG8OH5046802;
        Mon, 10 Feb 2020 16:09:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=Erm+X3P/zfd9sOxaGqkK2Iyf6viT+HO+bh4VgU2zvgY=;
 b=mPrHGXMWlpsN84mIlBz6UUkwZjhI1N/TdstIAZaPrbf/lbSb9sYuy6bHlhHTjrx/6mrv
 Yt1GA+DoZC43f2wWxKQgjZOV8GdmuHSCXoY/u8YBghiHisuLtDwM+W46o7Jb9f3i5mp3
 KwNsjA8YtxyndFc4cxk9XaO2O0A6iecXRuA3VcvbXMf6NVP0qOhKZpBbgkrFutEYqZV2
 t90SATuQuT/XyKLnzw/XmtA+syFyA+NEHg9gxtC7ZND9fSbOFVUUhgJ7CSM8hJ11IeGf
 lw6y403jzSBsWTnaLSnlRoJt8tD2+CBrFXFt1MxMX1mU5Jaw2xSm61aammmn55hh0CrI Vg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2y2k87wgrh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 10 Feb 2020 16:09:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01AG86go117299;
        Mon, 10 Feb 2020 16:09:08 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2y26ht85dg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Feb 2020 16:09:08 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01AG8wvI024202;
        Mon, 10 Feb 2020 16:08:59 GMT
Received: from anon-dhcp-152.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 10 Feb 2020 08:08:58 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH next] xprtrdma: make the symbol
 'xprt_rdma_slot_table_entries' static
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <20200210073927.8769-1-chenwandun@huawei.com>
Date:   Mon, 10 Feb 2020 11:08:57 -0500
Cc:     Bruce Fields <bfields@fieldses.org>,
        trond.myklebust@hammerspace.com,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        davem@davemloft.net, kuba@kernel.org,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <4A340D82-3FDF-415E-9C60-E8A915757C6A@oracle.com>
References: <20200210073927.8769-1-chenwandun@huawei.com>
To:     Chen Wandun <chenwandun@huawei.com>
X-Mailer: Apple Mail (2.3445.104.11)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9527 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002100122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9527 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 impostorscore=0 clxscore=1011 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002100122
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi-

The Fixes: tag seems incorrect to me.


> On Feb 10, 2020, at 2:39 AM, Chen Wandun <chenwandun@huawei.com> =
wrote:
>=20
> Fix the following sparse warning:
> net/sunrpc/xprtrdma/transport.c:71:14: warning: symbol =
'xprt_rdma_slot_table_entries' was not declared. Should it be static?
>=20
> Fixes: 86c4ccd9b92b ("xprtrdma: Eliminate struct =
rpcrdma_create_data_internal")

86c4ccd9b92b correctly makes xprt_rdma_slot_table_entries a
global variable. This later commit (in v5.6-rc1)

7581d90109ca ("xprtrdma: Refactor initialization of =
ep->rep_max_requests")

should have changed xprt_rdma_slot_table_entries back to a static.

I'm not sure what the call is on sparse warnings these days, but
it doesn't seem like this clean up should be backported to stable.=20
Should Fixes: be removed?


> Signed-off-by: Chen Wandun <chenwandun@huawei.com>
> ---
> net/sunrpc/xprtrdma/transport.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/sunrpc/xprtrdma/transport.c =
b/net/sunrpc/xprtrdma/transport.c
> index 3cfeba68ee9a..14c2a852d2a1 100644
> --- a/net/sunrpc/xprtrdma/transport.c
> +++ b/net/sunrpc/xprtrdma/transport.c
> @@ -68,7 +68,7 @@
>  * tunables
>  */
>=20
> -unsigned int xprt_rdma_slot_table_entries =3D RPCRDMA_DEF_SLOT_TABLE;
> +static unsigned int xprt_rdma_slot_table_entries =3D =
RPCRDMA_DEF_SLOT_TABLE;
> unsigned int xprt_rdma_max_inline_read =3D RPCRDMA_DEF_INLINE;
> unsigned int xprt_rdma_max_inline_write =3D RPCRDMA_DEF_INLINE;
> unsigned int xprt_rdma_memreg_strategy		=3D =
RPCRDMA_FRWR;
> --=20
> 2.17.1

--
Chuck Lever



