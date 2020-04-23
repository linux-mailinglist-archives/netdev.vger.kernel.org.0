Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D34E1B5E24
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 16:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbgDWOo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 10:44:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42212 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbgDWOo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 10:44:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03NEd3Io089155;
        Thu, 23 Apr 2020 14:43:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=U0l3rZSHeT3B77iPKt/LP/tNMNy58XvjcMskI+WbSbA=;
 b=xLXUAkhhUqCaMMKBL/8CKYV2snocLN1vKd5SmZdd+WfIqb7SGwPjGLCCw9XydX2IcDDZ
 CJ/3IEwHFOn0WRsuHh+qhqCGbnKKm2ajh+D6HE94/lcrvhBZzi9xl+6D9w9Zoax+2uMP
 OkKPdJWoNsaAgqYu8ckooRzLXwXrWJg+HJH4SCDfe5tq/uJhsMaoNbBiLGdQzpAnm2du
 874jQ7qMyVRABNGe26WfHbSI38ncihMzY5oX2nz0BkNLaznc0iCKtgsMXbrkuXAsuabf
 1N9KLXOygH2J526rEnfPAo23t+2p779f8WZMQg344ZMb6LDlBvCy0zDXYBrquesepMYt vg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30k7qe1qcd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Apr 2020 14:43:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03NEcUOi038314;
        Thu, 23 Apr 2020 14:43:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30gb1muep4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Apr 2020 14:43:42 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03NEhbKw031862;
        Thu, 23 Apr 2020 14:43:37 GMT
Received: from anon-dhcp-153.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Apr 2020 07:43:36 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH -next] xprtrdma: Make xprt_rdma_slot_table_entries static
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <1587625802-97494-1-git-send-email-zou_wei@huawei.com>
Date:   Thu, 23 Apr 2020 10:43:34 -0400
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        davem@davemloft.net, kuba@kernel.org,
        Bruce Fields <bfields@fieldses.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <30D769C6-2F48-40C7-BDFC-4CD3398DE852@oracle.com>
References: <1587625802-97494-1-git-send-email-zou_wei@huawei.com>
To:     Zou Wei <zou_wei@huawei.com>
X-Mailer: Apple Mail (2.3445.104.11)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9599 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004230117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9599 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 mlxscore=0 clxscore=1011 malwarescore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004230117
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 23, 2020, at 3:10 AM, Zou Wei <zou_wei@huawei.com> wrote:
>=20
> Fix the following sparse warning:
>=20
> net/sunrpc/xprtrdma/transport.c:71:14: warning: symbol =
'xprt_rdma_slot_table_entries'
> was not declared. Should it be static?
>=20
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zou Wei <zou_wei@huawei.com>

Reviewed-by: Chuck Lever <chuck.lever@oracle.com>

> ---
> net/sunrpc/xprtrdma/transport.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/sunrpc/xprtrdma/transport.c =
b/net/sunrpc/xprtrdma/transport.c
> index 659da37..9f2e8f5 100644
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
> 2.6.2

--
Chuck Lever



