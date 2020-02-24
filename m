Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCDC16B47F
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 23:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbgBXWrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 17:47:19 -0500
Received: from ozlabs.org ([203.11.71.1]:33421 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgBXWrT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 17:47:19 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48RHJ54KSbz9sPR;
        Tue, 25 Feb 2020 09:47:17 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1582584437;
        bh=vfJOx5tLhhMomws9ueSanwVw/zLkBBGcyCECo+XL7EE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=D1Nb9GkFHHoYso8VO2hzVDarY4ayYPEIaHCSvftsIN4iKcTMmUYfp0icyWhelT3jk
         pVcnGj3FJll26r/gL2IXExj+Saa8NXG0hr505VkNpUbhKWeZnCdV8phwYIRl40bZBv
         FVsMIjDmHFzR57BLiwjHwLwKe8qrDaklaAjFcdT3kMwMDwq018V5Xmsmx1CXcO6UM5
         YYMmv5Q5kdthvVpHVPjjT0FDjsFljLdkGQPb6VZY/hdhxl+gr2cTiS4uCw1pIQyxlI
         Yg3HQDvOSBlL8uuN5ED4TAkyAGo9gK6+Sspsvi5GCbMIosKASiUdBAF3Uq6In8BJXt
         5DDry5CrY/tdQ==
Date:   Tue, 25 Feb 2020 09:47:17 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.varghese@nokia.com,
        willemb@google.com
Subject: Re: linux-next: build warning after merge of the net-next tree
Message-ID: <20200225094717.241cef90@canb.auug.org.au>
In-Reply-To: <20200224.144243.1485587034182183004.davem@davemloft.net>
References: <20200225092736.137df206@canb.auug.org.au>
        <20200224.144243.1485587034182183004.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/7WdfuLsgSNjHxudAQ3i4qO6";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/7WdfuLsgSNjHxudAQ3i4qO6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Mon, 24 Feb 2020 14:42:43 -0800 (PST) David Miller <davem@davemloft.net>=
 wrote:
>
> Sorry, my compiler didn't show this.

Yeah, these ones especially change with compiler version.  I am
currently running gcc v9.2.1 if it matters.

> I've committed the following into net-next, hopefully it does the trick:

Thanks.

--=20
Cheers,
Stephen Rothwell

--Sig_/7WdfuLsgSNjHxudAQ3i4qO6
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl5UUnUACgkQAVBC80lX
0GyJcwf+OpfhwXjW2MtUL3rY/Aup9ojzEyDatjhR7JjeW7LxMavSo/ZJkq9Xctr9
zOHUk9NznLJrg1JA5SXkO/h8nvPzYhB78bOZ79KgkNwepDjc4Ip71z0RpwLFv0x9
Y6jFHlX/Y+LoWSCrUrrc00B0dJKiE4yXcmBfn8Cu2BEGBG3s0KGATTNkmFYxQuha
JhyGgd336Ik48fG1CE967vfjomfKTQSbQEkrzPS+UkY5o9xtzFTXDOjDbaAF3Xcg
L+5NS0if9VXhwlrM+TgkiWW7e2ystAXD37Tf3sGQpHg1FiVCnc91kgDN+Nn2K1oU
o7CPaxN6r9GFRGx/AlCTLkoq3oBuuA==
=vP2X
-----END PGP SIGNATURE-----

--Sig_/7WdfuLsgSNjHxudAQ3i4qO6--
