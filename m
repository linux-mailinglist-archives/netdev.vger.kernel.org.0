Return-Path: <netdev+bounces-8500-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A620A724532
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 16:03:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D51E1C20A83
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 14:03:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8A702DBA2;
	Tue,  6 Jun 2023 14:03:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7B337B71
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 14:03:36 +0000 (UTC)
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A7BA7
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:03:34 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1b04949e5baso54000995ad.0
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 07:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686060214; x=1688652214;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pxRzOmQfhiLx/rKX7zA9kjtyAlksHdNeP9/OEEOsRaM=;
        b=WC85AEtkHDpHaDw38V2dE+2md2D/Ujfv6DvIGV3U6k+5yfpHV9FJACFTCf8AMBvCIY
         s3kn7hqcAOnUCnkdbWjNaRzHpXvllWt6t24iYjIFNQ7cjOPwurREQA//rwh0nU/IdHbq
         tK9HCOq3WmC2UJZ6v+Sg6sTl+Lgs0ZpKRLglCURhX7MtVORjukcfPoRgnmv+z40cU18u
         k6ZPqFkHZRpt8Rb9HauOY6MAwwDnQ7aS7d1r+IFx+G2jzQUxy62unNGB0HlofT3Av2Ab
         amwj7X3C+/W8Mm0d1XEA7VR3pjCFpw/yXtqMcJbak1VPuGkpFrxXxBOj4XoK1MkC2Iih
         7JvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686060214; x=1688652214;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pxRzOmQfhiLx/rKX7zA9kjtyAlksHdNeP9/OEEOsRaM=;
        b=bTugbPATWl9G50rkxQ3qIv5EpYvaOHfkFgjltdTCR84sjWrKLIwmB+cQlgLvpqw6y6
         HpUryyi2xZZzNqLsNwaJ/R00DpOjsVHxh1dtI3tuieVxIXK71BRTFD9nWRXarAWeWY14
         +3pBkCY/5ssDyVCwXplVcT2IK0KQBze2Rbruh+ILruS/MFQrXLtcQU/SvR/Dp9jaRl2q
         ypmOTDwfjxA+uzgMyAOHqTPdCbz/7fXlqdiXWUlpJDRVmlScrozw0pVyfNAsR6lrOdWD
         tlaYqnOyLn9F+23gdxVZ0/rNaXoWP6sphavDitNgr9g29XC4uqsMGUAWwKK657iXngSv
         tz1g==
X-Gm-Message-State: AC+VfDwb2s+Bg1S3dyeipRNUBkMz9iX3oxLEiMq8pbw9Zbbwu1xrySjq
	xN7rxeQxTIzSlEshwCS/HyVczAFbgiU=
X-Google-Smtp-Source: ACHHUZ6sLnTJiDLmX7ZqCH9knPwT+Zd9ilTOQ4URiexHYvUZygLiE5HJajsmmJBuwndTMo4ynEnJKA==
X-Received: by 2002:a17:903:1cf:b0:1b1:9d14:1537 with SMTP id e15-20020a17090301cf00b001b19d141537mr2626577plh.55.1686060213457;
        Tue, 06 Jun 2023 07:03:33 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-93.three.co.id. [180.214.232.93])
        by smtp.gmail.com with ESMTPSA id g16-20020a170902869000b001b02162c86bsm8609910plo.80.2023.06.06.07.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 07:03:32 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 7A9A0106A3A; Tue,  6 Jun 2023 21:03:29 +0700 (WIB)
Date: Tue, 6 Jun 2023 21:03:29 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Turritopsis Dohrnii Teo En Ming <tdtemccnp@gmail.com>,
	netdev@vger.kernel.org
Cc: ceo@teo-en-ming-corp.com
Subject: Re: Fortigate Firewall Setup SOP Draft 13 Mar 2023
Message-ID: <ZH88scHrb1oT_J4E@debian.me>
References: <CAD3upLsLPF3nYdD1HHhqiweXt8zzOLKWpdPwuUKrccc1x33XBQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="jv/YIUkE7koWnWNM"
Content-Disposition: inline
In-Reply-To: <CAD3upLsLPF3nYdD1HHhqiweXt8zzOLKWpdPwuUKrccc1x33XBQ@mail.gmail.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--jv/YIUkE7koWnWNM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 13, 2023 at 09:40:57PM +0800, Turritopsis Dohrnii Teo En Ming w=
rote:
> 01. Register the brand new Fortigate firewall at https://support.fortinet=
=2Ecom

What is the relationship between Fortigate and native Linux firewall
(nftables)?

But hey, looks like LKML isn't the right forum for Fortinet products
(use that above support link instead).

>=20
> 02. Key in the Contract Registration Code. This is very important.
>=20
> 03. Upgrade firewall firmware to the latest version.
>=20
> 04. Set hostname.
> XXX-FWXX
>=20
> 05. Set regional date/time. Time zone is important.
>=20
> 06. Enable admin disclaimer page.
> config system global
> set pre-login-banner enable
>=20
> 07. Create firewall super-admin accounts.
> a. admin
> b. xx-admin
> c. si-company
> d. abctech
>=20
> 08. Configure WAN1 interface.
> Most business broadband plans are using DHCP.
>=20
> 09. Enable FTM / SNMP / SSH / HTTPS for WAN1 interface.
>=20
> 10. Configure default static route.
>=20
> 11. Configure LAN interface.
> Optional: DHCP Server
>=20
> 12. Set DHCP lease time to 14400.
>=20
> 13. Configure HTTPS port for firewall web admin to 64444.
>=20
> 14. Configure SSL port for VPN to 443.
>=20
> 15. Configure LDAP Server.
>=20
> 16. Create Address Objects.
>=20
> 17. Create Address Groups.
>=20
> 18. Configure firewall policies for LAN to WAN (outgoing internet access).
>=20
> 19. Configure and apply security profiles to above firewall policies.
>=20
> 20. Create Virtual IPs.
>=20
> 21. Create custom services.
>=20
> 22. Create service groups.
>=20
> 23. Create firewall policies for port forwarding (WAN to LAN).
>=20
> 24. Configure other firewall policies.
>=20
> 25. Disable FortiCloud auto-join.
> config system fortiguard
> set auto-join-forticloud disable
> end
>=20
> 26. Configure FTM Push.
> config system ftm-push
> set server-port 4433
> set server x.x.x.x (WAN1 public address)
> set status enable
>=20
> 27. Remove existing firewall/router and connect brand new Fortigate
> firewall to the internet.
>=20
> 28. Configure FortiGuard DDNS.
> xxx-fw.fortiddns.com
>=20
> 29. Configure DNS.
>=20
> 30. Activate FortiToken.
>=20
> 31. Create SSL VPN Group.
>=20
> 32. Create SSL VPN Users (local or LDAP).
>=20
> 33. Configure 2FA for SSL VPN Users.
>=20
> 34. Create SSL-VPN Portals.
>=20
> 35. Configure SSL VPN Settings (split or full tunneling).
>=20
> 36. Configure firewall policies for SSL VPN to LAN.
> Optionally configure firewall policies for SSL VPN to WAN (if full tunnel=
ing).
>=20
> 37. Configure C-NetMOS Network Monitoring Service.
> configure log syslogd setting
> set status enable
> set server "a.b.c.d"
> set mode legacy-reliable
> set port 601
> set facility auth
> end
>=20
> 38. Apply hardening steps (Systems Integrator's Internal Document).
>=20
> 39. Convert SOHO wireless router to access point mode.
>=20
> 40. Configure and apply security profiles (REMINDER).
>=20
> Testing
> =3D=3D=3D=3D=3D=3D=3D
>=20
> 1. Internet access for all users.
>=20
> 2. VPN connection using FortiToken.
>=20
> Documentation
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Firewall documentation for administrator (settings / policies / VPN).
>=20
> User Training
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> A. For Administrator
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> 1. How to access Fortigate firewall URL.
>=20
> 2. How to add/remove/reassign FortiToken.
>=20
> 3. How to add/remove VPN users.
>=20
> 4. How to generate usage report for Government PSG Grant.
>=20
> B. For End User
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> 1. How to connect to VPN.
>=20
> 2. How to use FortiToken.
>=20
> 3. How to connect company laptop to VPN.
>=20
> =3D=3D=3DEOF=3D=3D=3D

As Linus has said, "Talk is cheap. Show me the code." - show me the full
HOWTO (on your blog since LKML isn't the appropriate forum for this kind
of content).

<rant>
	The parallel to this that many orgs by convention only upload quick
	highlights (for sports matches) or trailers (for movies) to
	YouTube and leave the full details to streaming services (which
	are often priced in charm prices). Some third-party users made
	the full resources available for free on YouTube (but with risk
	of copyright wild west).

	Another way: Suppose that I'm a WSJ writer and post my cool
	stories into its website. Anonymous users can only see few posts
	(including mine) per month and then they had to pay some bucks
	to view the rest (think of paywall). A developer here at LKML
	refer to my WSJ story without knowing this fact. Do others have
	to read mine there for the sake of completeness? Many prefer freely
	accessible version instead, so I may have to be forced to release
	my story to my personal site.
</rant>

>=20
>=20
>=20
>=20
> REFERENCES
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> [1] https://pastebin.com/raw/yg0QUcv6
> [2] https://controlc.com/85e667fb

I see both references and these are all the exact copy of your post.

Thanks anyway.

--=20
An old man doll... just what I always wanted! - Clara

--jv/YIUkE7koWnWNM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZH88rgAKCRD2uYlJVVFO
oykOAQDQHa4a1up8ROjr38T9OJulNvrfWTTTqhOx1ERK68bzUwEAq6M7g+ibNV1x
7o2zyOYTXMEwRA68GeF4L5S+lSqpcQI=
=leAd
-----END PGP SIGNATURE-----

--jv/YIUkE7koWnWNM--

