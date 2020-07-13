Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 028F721D5A2
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 14:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729650AbgGMMQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 08:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbgGMMQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 08:16:34 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DDCEC061755;
        Mon, 13 Jul 2020 05:16:34 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id b92so6158197pjc.4;
        Mon, 13 Jul 2020 05:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lLOk7rW4/byxbGdkeQSwDePJbFv55lWDJWAbGgIeO8I=;
        b=E08jUUD9Guyz5JlCO5wNfxTPFIyn/hzpAYddrVpcRIPdARH3MJ79H0G9rkb+jcKutN
         dqpK/KKV+hXC1EbeA4uw6qCjoI+nBirFUDDUyyfm/Si2zu1a0nYGG+zGGUaJeXY5IFSW
         3aaf6LpCIMPPlT4mOm87cgnGrzRbqZhXm14eVy7oe+cdYuiwwH79ibQNth7115eGwV0O
         KW9Ap0Wa4mGkKrldpWqKAvvrXVUsqkfzNaDqn/PUQDj8U9IvVzmWDsQQKaR8gDIXEtPF
         bxkyNnyUePp9e+cjycLDZ59UW7vsx7XGiVRvQ7nEo3pSuyIU6x9T7VmGYXiXQNQmBPYC
         Iemg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lLOk7rW4/byxbGdkeQSwDePJbFv55lWDJWAbGgIeO8I=;
        b=aejy5MGUlw5xvm520vlmi/oSVOeWAZIKiKqygJzLCavAVBgd++zhHyPdGF4B+RrxZ5
         jDmBVLBjazA9Wyz4HYxUaODOg2xXRBLLmiMUUM8yyFFiOhax+WXhkuAH0nqde0DkQC9O
         yz/t1JpyKwWQWidkbMQwWnMSzYetvmTqDDgQ7vv24YgHnwdEi2k/DqflfCFmRRNsgKvF
         pmO2+g9XN5pTmbKBrbJYvPFx4PSEHhZ6Gn+qobVqVexSTWtBRCspcPdKK2pTXdN1uDnf
         NbBp7gmomVVVxc5w2UH8Kf05epXmOBeNhbS4nZxqQdKIk0lm54mCdPvSWyVwbrEz0BAh
         gI8A==
X-Gm-Message-State: AOAM533VERXFPqYRo5KGzVSSLE6v2WPYgsSTiAZDDIoMW1Z93E6VKq5k
        aebPZ75VtD3t1LuhBI2DZTGrJzOBEA8Odw==
X-Google-Smtp-Source: ABdhPJxNO1ea46TfHeaFd7sxGBVN42EIq2/b736PE7owHtr4DVTpsXBHt8g8O7bkhcVKZgrNPP2ISQ==
X-Received: by 2002:a17:902:243:: with SMTP id 61mr13222662plc.29.1594642594128;
        Mon, 13 Jul 2020 05:16:34 -0700 (PDT)
Received: from blackclown ([103.88.82.220])
        by smtp.gmail.com with ESMTPSA id k100sm14960073pjb.57.2020.07.13.05.16.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 13 Jul 2020 05:16:33 -0700 (PDT)
Date:   Mon, 13 Jul 2020 17:46:21 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] staging: qlge: qlge_dbg: Simplify while statements
Message-ID: <79e35c695a80168639c073137a80804da3362301.1594642213.git.usuraj35@gmail.com>
References: <cover.1594642213.git.usuraj35@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <cover.1594642213.git.usuraj35@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Simplify while loops into more readable and simple for loops.

Signed-off-by: Suraj Upadhyay <usuraj35@gmail.com>
---
 drivers/staging/qlge/qlge_dbg.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_db=
g.c
index 32fbd30a6a2e..985a6c341294 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -42,9 +42,9 @@ static int ql_wait_other_func_reg_rdy(struct ql_adapter *=
qdev, u32 reg,
 				      u32 bit, u32 err_bit)
 {
 	u32 temp;
-	int count =3D 10;
+	int count;
=20
-	while (count) {
+	for (count =3D 10; count; count--) {
 		temp =3D ql_read_other_func_reg(qdev, reg);
=20
 		/* check for errors */
@@ -53,7 +53,6 @@ static int ql_wait_other_func_reg_rdy(struct ql_adapter *=
qdev, u32 reg,
 		else if (temp & bit)
 			return 0;
 		mdelay(10);
-		count--;
 	}
 	return -1;
 }
--=20
2.17.1


--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8MUJQACgkQ+gRsbIfe
745D1w//XhdUHMBxnx+36FHOhbFo/mXsfM9kHZmUBYmQKRdsquDqK0Rv+go3p6qf
L1i6E+6oLh/r7ZL0u3wXbNx1KsorCNsBmncK53AxzpzXag8Atu4rtwGiYVJvcaYU
rH3/PqoMWRj2yPhMWDZUuZf1IqDaubGAd4MtR5DMhCpI94qp9DDJ+m4N71ys4NAl
B3EK6lZ5AIim5FFk09CdCi1BgvZna1BxngQS1xa3HnCoLf9GRm570E3xJ/1jTCOE
5wYEkaKbfE+3Yn+MgkeBTos2CLw1Fv2lCLQm3FyKoCr2TxZfWSIjVL6/xZBXA9d5
7hwsuJOSl/gRsE5hw4dLNxnzvcDSo4zsWDb6HA4akwaL6CZGr2KnuJOVU+Fxuu1M
ZqUgBga5D0dFbkJEGZi96KWLWjWrsbo20gmnmHwsYtdOc2YkDLQQ4eKoJfV3nBsV
lSWCo2k9lncMvbRrl1N3Frbx81oQYTe690X7N6lU+60fasMy/pIhZC9Gr+A/yu8R
AGwOKyg9rLhdr5iPnFXmQiKBnfypePnXEohAFKuSDDIbwsGbuz4kQcIVK0XG373R
K+VKPI1Z6HuZpCFJruQYAgsXsu/GUFBznuvq36+Gk3d39jlVv/fe0CiSxVcwbl5I
V/XpFnTUN1FqEYFExL4K9XvJcCn7Zola4dBZu0eev2cM/AQUqB4=
=p1SM
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
