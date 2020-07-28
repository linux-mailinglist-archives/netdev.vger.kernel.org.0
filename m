Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75B92312A8
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 21:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732832AbgG1Tbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 15:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732813AbgG1Tbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 15:31:35 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E2236C0619D2
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 12:31:34 -0700 (PDT)
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id ED10D8AD62;
        Tue, 28 Jul 2020 20:31:32 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595964693; bh=dbMlaK8uIe9xhCRyQE/W+8c0fOIewIKKSWDy/0WCT6U=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Tue,=2028=20Jul=202020=2020:31:32=20+0100|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20Joe=20Perches=20<joe@perches.c
         om>|Cc:=20netdev@vger.kernel.org|Subject:=20Re:=20[PATCH=2017/29]=
         20l2tp:=20avoid=20precidence=20issues=20in=20L2TP_SKB_CB=20macro|M
         essage-ID:=20<20200728193132.GB4582@katalix.com>|References:=20<20
         200721173221.4681-1-tparkin@katalix.com>=0D=0A=20<20200721173221.4
         681-18-tparkin@katalix.com>=0D=0A=20<169fe729db1ba8529d0c071b39d48
         091cc77fba2.camel@perches.com>=0D=0A=20<bd83cd37a477721c0336807ffd
         2044f19f85f1d3.camel@perches.com>|MIME-Version:=201.0|Content-Disp
         osition:=20inline|In-Reply-To:=20<bd83cd37a477721c0336807ffd2044f1
         9f85f1d3.camel@perches.com>;
        b=gRuUZ5FWlC/5jyc0EvRWMO0nLmqlBzPnbaZP+1mdPwxmt/md4A2Sx87J4jfot0k8K
         KMsM+Ts+b3s94cOI+xisplb8Z1e3eCROVZlurdwsu7K+0f26n4apaPWV4SYQbmJv2t
         uAnBMwkxCwXYV9dXo9hI7u8tev8V+wHHQiIZzRkTKOrgqjp+V8uczSvx+9SravPDFY
         5mG/2i1VYDAO9RpJJmlzdLGg1qS4e1cZIAaS8zPG984FGeX4h/KCB3CBM80ZQlo7ES
         YnYwVtOvSNXyRHdCq6iRt+PZ5SPBu42Ht7/019R+FZbezdHouQ0Wd8q7p/dI6JvmGR
         4DRrlpIs8B3qQ==
Date:   Tue, 28 Jul 2020 20:31:32 +0100
From:   Tom Parkin <tparkin@katalix.com>
To:     Joe Perches <joe@perches.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 17/29] l2tp: avoid precidence issues in L2TP_SKB_CB macro
Message-ID: <20200728193132.GB4582@katalix.com>
References: <20200721173221.4681-1-tparkin@katalix.com>
 <20200721173221.4681-18-tparkin@katalix.com>
 <169fe729db1ba8529d0c071b39d48091cc77fba2.camel@perches.com>
 <bd83cd37a477721c0336807ffd2044f19f85f1d3.camel@perches.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="8P1HSweYDcXXzwPJ"
Content-Disposition: inline
In-Reply-To: <bd83cd37a477721c0336807ffd2044f19f85f1d3.camel@perches.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--8P1HSweYDcXXzwPJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Tue, Jul 28, 2020 at 11:08:45 -0700, Joe Perches wrote:
> On Tue, 2020-07-28 at 09:21 -0700, Joe Perches wrote:
> > On Tue, 2020-07-21 at 18:32 +0100, Tom Parkin wrote:
> > > checkpatch warned about the L2TP_SKB_CB macro's use of its argument: =
add
> > > braces to avoid the problem.
> > []
> > > diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> > []
> > > @@ -93,7 +93,7 @@ struct l2tp_skb_cb {
> > >  	unsigned long		expires;
> > >  };
> > > =20
> > > -#define L2TP_SKB_CB(skb)	((struct l2tp_skb_cb *)&skb->cb[sizeof(stru=
ct inet_skb_parm)])
> > > +#define L2TP_SKB_CB(skb)	((struct l2tp_skb_cb *)&(skb)->cb[sizeof(st=
ruct inet_skb_parm)])
> >=20
> > Likely better to use a static inline.
> >=20
> > Something like:
> >=20
> > static inline struct l2tp_skb_cb *L2TP_SKB_SB(struct sk_buff *skb)
> > {
> > 	return &skb->cb[sizeof(struct inet+skb_parm)];
> > }
>=20
> More precisely:
> ---
>  net/l2tp/l2tp_core.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> index e723828e458b..78ad6d8405c4 100644
> --- a/net/l2tp/l2tp_core.c
> +++ b/net/l2tp/l2tp_core.c
> @@ -93,7 +93,10 @@ struct l2tp_skb_cb {
>  	unsigned long		expires;
>  };
> =20
> -#define L2TP_SKB_CB(skb)	((struct l2tp_skb_cb *)&(skb)->cb[sizeof(struct=
 inet_skb_parm)])
> +static inline struct l2tp_skb_cb *L2TP_SKB_CB(struct sk_buff *skb)
> +{
> +	return (struct l2tp_skb_cb *)&skb->cb[sizeof(struct inet_skb_parm)];
> +}
> =20
>  static struct workqueue_struct *l2tp_wq;
> =20
>=20

Thanks Joe.  I can see this is better since we get some type checking
=66rom the compiler for the function argument.

The patchset has been applied already, but I can try to integrate this
change in the future.

--8P1HSweYDcXXzwPJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAl8gfRAACgkQlIwGZQq6
i9C+2Qf/ZnPcwsKj1g/6f6IQBeDZn9eRriULQCuOW5ZvWsKqBmJPmWSMioGIUIpg
otJZ18s74HKcBhQjw1xm5hvzYzCmNXFE+GZyTTla7tofkvL+/wLe8zLUOWZltl0l
Budm93OfWQ7wkD1/E2HBpxicz7TiZZqKO8sxxf8gRrVTA0gMYT/hY2yabjmb6hTN
PW5FLeA1X0ixtLwxSYEoONdSszd1P4a5jOm6tupilzGb8HnBQZtrgXZqIKiRB8Zk
IJFapLgbPy5Qm1cnI/65dLMh5puX2wCmmVURFx3OKAHVTw51Qxb/bNPc7sF/8Dv3
VAhFfbaH8/ZRmM/At1IhaVLlxExmOg==
=igLa
-----END PGP SIGNATURE-----

--8P1HSweYDcXXzwPJ--
