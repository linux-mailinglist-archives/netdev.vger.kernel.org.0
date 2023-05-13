Return-Path: <netdev+bounces-2350-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0A1770160B
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 12:12:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA5351C20EAD
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 10:12:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A68CE1868;
	Sat, 13 May 2023 10:12:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8821846
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 10:12:00 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276CE1989;
	Sat, 13 May 2023 03:11:59 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AD49B2244D;
	Sat, 13 May 2023 10:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1683972717; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cSfp+2Xls3qr1gY7ds9zwXAoQlCLbbksQ7i/+fxkSoA=;
	b=U/h7XltHW4DV8TEZYRaU4YFBxlG48bIB1dBhJcmiTcl3dcAliMZcblOsMIjKKQ+A1uIcNs
	i0VYWLjcsvf3QE8CNHeBXHFoUElmqN4uwXJqf5zsoyDcFx9s9uYRmjenJgzORP6K614gJk
	6xIjSlYOm7AINS0vcbb8JjKUNnG6a94=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 33F0D1343E;
	Sat, 13 May 2023 10:11:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id XBfFCm1iX2StFAAAMHmgww
	(envelope-from <jgross@suse.com>); Sat, 13 May 2023 10:11:57 +0000
Message-ID: <9929cbe4-b39f-d93c-a68b-0907f442e3f5@suse.com>
Date: Sat, 13 May 2023 12:11:56 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH 1/3] MAINTAINERS: Update maintainers for paravirt-ops
Content-Language: en-US
To: "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>, bp@suse.de,
 tglx@linutronix.de, kuba@kernel.org, davem@davemloft.net,
 richardcochran@gmail.com
Cc: sdeep@vmware.com, amakhalov@vmware.com, akaher@vmware.com,
 vsirnapalli@vmware.com, pv-drivers@vmware.com,
 virtualization@lists.linux-foundation.org, x86@kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230512164958.575174-1-srivatsa@csail.mit.edu>
From: Juergen Gross <jgross@suse.com>
In-Reply-To: <20230512164958.575174-1-srivatsa@csail.mit.edu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------gr1TJBX10xUsAAYc1jI0aa8g"
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------gr1TJBX10xUsAAYc1jI0aa8g
Content-Type: multipart/mixed; boundary="------------QV6g03q6BO9x5GtcOKuHP5vR";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>, bp@suse.de,
 tglx@linutronix.de, kuba@kernel.org, davem@davemloft.net,
 richardcochran@gmail.com
Cc: sdeep@vmware.com, amakhalov@vmware.com, akaher@vmware.com,
 vsirnapalli@vmware.com, pv-drivers@vmware.com,
 virtualization@lists.linux-foundation.org, x86@kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <9929cbe4-b39f-d93c-a68b-0907f442e3f5@suse.com>
Subject: Re: [PATCH 1/3] MAINTAINERS: Update maintainers for paravirt-ops
References: <20230512164958.575174-1-srivatsa@csail.mit.edu>
In-Reply-To: <20230512164958.575174-1-srivatsa@csail.mit.edu>

--------------QV6g03q6BO9x5GtcOKuHP5vR
Content-Type: multipart/mixed; boundary="------------NqNlg21qQydtfdNH0NhWomd1"

--------------NqNlg21qQydtfdNH0NhWomd1
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTIuMDUuMjMgMTg6NDksIFNyaXZhdHNhIFMuIEJoYXQgd3JvdGU6DQo+IEZyb206ICJT
cml2YXRzYSBTLiBCaGF0IChWTXdhcmUpIiA8c3JpdmF0c2FAY3NhaWwubWl0LmVkdT4NCj4g
DQo+IEkgaGF2ZSBkZWNpZGVkIHRvIGNoYW5nZSBlbXBsb3llcnMgYW5kIEknbSBub3Qgc3Vy
ZSBpZiBJJ2xsIGJlIGFibGUgdG8NCj4gc3BlbmQgYXMgbXVjaCB0aW1lIG9uIHRoZSBwYXJh
dmlydC1vcHMgc3Vic3lzdGVtIGdvaW5nIGZvcndhcmQuIFNvLCBJDQo+IHdvdWxkIGxpa2Ug
dG8gcmVtb3ZlIG15c2VsZiBmcm9tIHRoZSBtYWludGFpbmVyIHJvbGUgZm9yIHBhcmF2aXJ0
LW9wcy4NCj4gDQo+IFJlbW92ZSBTcml2YXRzYSBmcm9tIHRoZSBtYWludGFpbmVycyBlbnRy
eSBhbmQgYWRkIEFqYXkgS2FoZXIgYXMgYW4NCj4gYWRkaXRpb25hbCByZXZpZXdlciBmb3Ig
cGFyYXZpcnQtb3BzLiBBbHNvLCBhZGQgYW4gZW50cnkgdG8gQ1JFRElUUw0KPiBmb3IgU3Jp
dmF0c2EuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBTcml2YXRzYSBTLiBCaGF0IChWTXdhcmUp
IDxzcml2YXRzYUBjc2FpbC5taXQuZWR1Pg0KPiBBY2tlZC1ieTogQWxleGV5IE1ha2hhbG92
IDxhbWFraGFsb3ZAdm13YXJlLmNvbT4NCj4gQWNrZWQtYnk6IEFqYXkgS2FoZXIgPGFrYWhl
ckB2bXdhcmUuY29tPg0KDQpBY2tlZC1ieTogSnVlcmdlbiBHcm9zcyA8amdyb3NzQHN1c2Uu
Y29tPg0KDQoNCkp1ZXJnZW4NCg0K
--------------NqNlg21qQydtfdNH0NhWomd1
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------NqNlg21qQydtfdNH0NhWomd1--

--------------QV6g03q6BO9x5GtcOKuHP5vR--

--------------gr1TJBX10xUsAAYc1jI0aa8g
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmRfYmwFAwAAAAAACgkQsN6d1ii/Ey+D
Ggf/ex4s/Z90KedHZeWJ4xk7rBGR3MR0y+IRDnmOEpTS8RTlaXN7IFfZFS2dZwNPKJOdTb3HlvzA
z6YE4MzdNVJ6ezVLrIz6Aq3yPOy+pbOq4jY9wNsOgQFQJUDW2IuSWNasKE8FQhKs4LmMOxEYUqCl
LvQtSolI9jQyDKseDYZz/km14p0Y09hjzyXI5ZwZLJHeQgZw9ZC0Ocxqfp9oB4+N/Ts+4SqO5/xS
ep6sKqlfkDwjt4UcihZKNTaOqvaFY1IVusexeBXHdfoOrYXZ5/Fa6IQHlli3iigVmf+MirRcxIGo
KYNZ8jcWXLV0yD0mxhAO/EKFvzfmBPhJvd0XPuXcQQ==
=7vAh
-----END PGP SIGNATURE-----

--------------gr1TJBX10xUsAAYc1jI0aa8g--

