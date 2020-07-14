Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4B321F39D
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbgGNONY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgGNONY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 10:13:24 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD84C061755;
        Tue, 14 Jul 2020 07:13:24 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id t6so7660796pgq.1;
        Tue, 14 Jul 2020 07:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=2fksY6YSojH74C2xoJiIxrJtolcgZN1cTtaHk2DTTcA=;
        b=OSGsrTb2632Fcb06KxfPBXAvy2ahVjkiHIoalu3EXz8Jh05gZaLw02ZcvXY2CBURWP
         r+TZO/IkW0wMiHZokIySXuHJgYILrL0APiEgO8KKyaULOlKdgKO0jv4cLCVtXpsCI4JD
         PSKFPVGpIv2DsEa7Mob5n/n5JABBfK6IdPuE5Rz2+YCk3n2oKjF9GYuphja6OPB5LZE/
         P86wGOU9PhJfp2QS+SVgtr+2XDrfKbN00XXBKYQsup8/FsSeT5usjsCy6KKwn+oamvwd
         TGBmQowWgbHn1jSb3gizTJsktRHMtP39sPclGqVYfYZm2PMCXx17LatulItzgI48wwaA
         F0cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=2fksY6YSojH74C2xoJiIxrJtolcgZN1cTtaHk2DTTcA=;
        b=teJOlyijqmUu97Rp0qrKfBXa8DTkMxvY0LGHmQFG8f5lsT9kPmJBnk2mwxLLUcXXy5
         /2PU0ie5KHLhdKRMr57efMvCfvrQ3I0o20DkY9I6/q17NeqkTpArhFvs1QCuEvhBBRYp
         uAbeGKJVegZWqchrjV/FPGgKWaad6AJe0rfW7z3ghIXckEXr+EX6/6dHx7Ad7ogPJ8J3
         2IM4qXkmgHoK5iCPfdaCr1h+QECwLFQVn3lmIySIaz+Pg1kg8c8rGyKTeb/wIPq8eqfd
         J6f23X8U8waqAcvkkpUONevsphMkEQpZeZ5YwVdmPhTCtlJi+QWcSXjl2z3oEhyoCzs7
         VZmw==
X-Gm-Message-State: AOAM532ueho9J27i79dAojpgiRYTycbCCAxtDuENPVlT3LqPp8aFaOmy
        BPAj/Brl58CyqE7ljbLg7ldlIdEoBajnrg==
X-Google-Smtp-Source: ABdhPJzSaWl7qUbbV4m+KbTMUpWb70wRXvXlfcWsa+YBJ/N3815XPjGZcCw+oMZE6fVTQWnOHgw5TA==
X-Received: by 2002:a62:1c9:: with SMTP id 192mr4277995pfb.22.1594736003728;
        Tue, 14 Jul 2020 07:13:23 -0700 (PDT)
Received: from blackclown ([103.88.82.145])
        by smtp.gmail.com with ESMTPSA id c14sm17849929pfj.82.2020.07.14.07.13.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Jul 2020 07:13:22 -0700 (PDT)
Date:   Tue, 14 Jul 2020 19:43:09 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] decnet: dn_dev: Remove an unnecessary label.
Message-ID: <20200714141309.GA3184@blackclown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Remove the unnecessary label from dn_dev_ioctl() and make its error
handling simpler to read.

Signed-off-by: Suraj Upadhyay <usuraj35@gmail.com>
---
 net/decnet/dn_dev.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/decnet/dn_dev.c b/net/decnet/dn_dev.c
index 65abcf1b3210..64901bb9f314 100644
--- a/net/decnet/dn_dev.c
+++ b/net/decnet/dn_dev.c
@@ -462,7 +462,9 @@ int dn_dev_ioctl(unsigned int cmd, void __user *arg)
 	switch (cmd) {
 	case SIOCGIFADDR:
 		*((__le16 *)sdn->sdn_nodeaddr) =3D ifa->ifa_local;
-		goto rarok;
+		if (copy_to_user(arg, ifr, DN_IFREQ_SIZE))
+			ret =3D -EFAULT;
+			break;
=20
 	case SIOCSIFADDR:
 		if (!ifa) {
@@ -485,10 +487,6 @@ int dn_dev_ioctl(unsigned int cmd, void __user *arg)
 	rtnl_unlock();
=20
 	return ret;
-rarok:
-	if (copy_to_user(arg, ifr, DN_IFREQ_SIZE))
-		ret =3D -EFAULT;
-	goto done;
 }
=20
 struct net_device *dn_dev_get_default(void)
--=20
2.17.1


--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8NvXQACgkQ+gRsbIfe
744sDA//bLkioTnZkkrrA1VGJtzPqwikbMv98ftgr6GTcZ5/FJcG3ZEq64SeMcY6
pWUhP5fFnIm4tBcaTsio3K9jQ5eLYi5KSZ36kJToxWihHt8lts2GdY9pQHe1IyOU
H/pHNMc6Y5Mqugvzn8mZF0DcoWFjyOAicEUGDHEMBEk4rFP3MS60aad1V3JQ152u
2RJm1rMHc3C8HbGTIA7/vnwNeH7aDmM8Giz7kK0IkeR+3ldRYswCniPKmoJh9Teq
4kdwAlaYcgiorYhG1ad/wwOoqPB5SeCuMHq/tgNl/y+8dr+MoiuHuoq85LS8Hp9t
PlcbjgTyUCde+jHqsWLB60OvVD4OgtHQOlrQEjI9BuTsRoApe/pGnsR7T2aLo+3I
Zv5+6nNImAWqIDvQBDIGyuO/2l+2JtVujZTswYMN/O47dqAs0jRhDWfT4Tgi76pF
gCMJWOqd1bjEqSjPwX158WEsapaEsdZJbT2ohjksF0DPvgj6lT2HXQvzlf8VYYAd
bKo4rHMPDUQKhdIR47QTJhucJjo/lH0kF7Mf9PNtksA/0TULiAptCqv+cVK2wsyJ
7vTqMYvFJow/6Bapjih3QGRaZTPRJ6PKLQNFD9v5qw9sdqEHZ5aPB6TZvV35s31o
ubHYmiZOrpFcxHFKHJzW75I85l5245X2tJB8MaQyNvG53Sb/WjI=
=xSF9
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
