Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94EF221E7A3
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 07:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgGNFlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 01:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgGNFlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 01:41:44 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED3FC061755;
        Mon, 13 Jul 2020 22:41:44 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id j20so7104860pfe.5;
        Mon, 13 Jul 2020 22:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5vY1n+N/VQ+6xLkxPzwANaxUQVVSv14sE1Bo22nwo+8=;
        b=d4pjqhm9RHROhmxjFHCDV5yLw6T0kj3qhWLPRo406IDG5azkucuSPO3ZDF/L4txM8Y
         GtIq7DDawqq9+eCzdNsDa/KjzDAYKycDf35LtXOnMPPB1Ls5cQM6ggiogc8YoKNmNIex
         0/JT6yFHLvH3wel8MBq0vLV5EONcwVwOPwtipkupNJP08JRB8EzyJrXYIrDexcPUV96N
         anzrTf7FolMbrktBP0qcialz3tze2/h5PZlP5JJ+GmTKfXhzExsTR82txdvJroVdqxD2
         3+JSge3Lrq2+V24h+wfUDIzQihxObwDVBC3ysQJwLwrmTrLCIXSG+zB33mqleLsKhjF7
         ffSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5vY1n+N/VQ+6xLkxPzwANaxUQVVSv14sE1Bo22nwo+8=;
        b=fN3el8ueypoyV+p0YhFbpMtArC2Sn1CB/NcYr775Clsh3S5+CU1rjG0AVwFzD+eG2N
         FsPG/Z6ZZ3u8uESnRHT6s6R0sxcR3HImxFOGm7rw2ZuXItJ0cHyibasTjcs88FF5ELUG
         /TeBj2pvUGP3Y6Di8MF+H4gbCTWhpWOgrQ0lmTihWdgXfpv33vhvDZ3qijiQZ8OISfzj
         CNf+yQv498NRtuD0xnaFu9gTcHSV0uL7sKX0u//SOJ1sR0QYCEosWd0O6FvInPQTbg36
         ge42x6MPRczY+k8sJy+NO9wGe3xZPkkVBOWYvOE9udEDXlXPVbKce2MzrMF2e224HaQq
         X9gQ==
X-Gm-Message-State: AOAM530jkc7v4GlFEM2QinUMmajV8hXW8JXWI5Iym3yBnATFqSgiPl2h
        0uTWdBo5KHUPzb6sZqNbTc8=
X-Google-Smtp-Source: ABdhPJzyetHHZwcsu3ySYi6T0RyV+znuILAhavOnyxSfyl5RmIoJptvZEUpziE0tgNLhzIyOorCpqg==
X-Received: by 2002:a62:8608:: with SMTP id x8mr2790289pfd.96.1594705303844;
        Mon, 13 Jul 2020 22:41:43 -0700 (PDT)
Received: from f3 (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id z13sm15469334pfq.220.2020.07.13.22.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 22:41:42 -0700 (PDT)
Date:   Tue, 14 Jul 2020 14:41:37 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Suraj Upadhyay <usuraj35@gmail.com>
Cc:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] staging: qlge: qlge_main: Simplify while statements.
Message-ID: <20200714054137.GA49448@f3>
References: <cover.1594642213.git.usuraj35@gmail.com>
 <1bb472c5595d832221fd142dddb68907feeeecbe.1594642213.git.usuraj35@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
In-Reply-To: <1bb472c5595d832221fd142dddb68907feeeecbe.1594642213.git.usuraj35@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2020-07-13 17:50 +0530, Suraj Upadhyay wrote:
> Simplify while loops into more readable and simple for loops.
>=20
> Signed-off-by: Suraj Upadhyay <usuraj35@gmail.com>
> ---
[...]
> @@ -1824,7 +1821,7 @@ static struct sk_buff *ql_build_rx_skb(struct ql_ad=
apter *qdev,
>  			sbq_desc->p.skb =3D NULL;
>  			skb_reserve(skb, NET_IP_ALIGN);
>  		}
> -		do {
> +		for (; length > 0; length -=3D size, i++) {
>  			lbq_desc =3D ql_get_curr_lchunk(qdev, rx_ring);
>  			size =3D min(length, qdev->lbq_buf_size);
> =20
> @@ -1839,7 +1836,7 @@ static struct sk_buff *ql_build_rx_skb(struct ql_ad=
apter *qdev,
>  			skb->truesize +=3D size;
>  			length -=3D size;
>  			i++;
> -		} while (length > 0);
> +		}

Looks like length and i modification should be removed from here. But in
this instance, maybe the original was better anyways.

Agreed with Dan. At least some of those loops can be converted to "count
up" loops for a more familiar appearance.

--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEkvpDtefvZykbqQVOaJBbS33YWS0FAl8NRY0ACgkQaJBbS33Y
WS0Z3g//WcVnTN4TKXOSsgeRlWHyX3urQyWEoECrDPEHYUOMJw+KG+lDtZdJOEqa
imuRQ79vr+x5wb806yuriU7kWYoH8AtS/7tEXubU3nHMZtw6IiVQiyMvA/pCFUDr
8Z9lfVyNfIxiJqYSNigLEx0P3Psd8UYvbj09XYa5M6YlL77M2QU97RWgwPSwp7Eb
NottP8d9Y1TYk34o/tDHPqt1UBWxVi438/ulKkbfrGr7vKsBN65F/sE5Xpa4kGaY
eZx/ruVcekeso6UbWEHqk+foSK4RXr2C/ES0AXVvaJwxXnthE8lABye7EbZMDrPi
QAyd3AWdQbWq0ScymyhUHZB0VUtQWD8nEEs/k3XA/M3CDLrsVwv1KDekECDvwcHv
3r/Sj+XCo3jZ1Pc1f5KYSDsHRRUV83QMI0uiovUnEOuf8kGKe4jx0CFVv66bwsxb
eeAhk7aHWS9f95Ij9HHmWxuSsh/KVoH6F8NwQNwhYVRXGv4ytxYqsRNkZEN7DlNW
OGkcAySETR302XjTL/HbLZVVi8hzu/CTmF+YpBbzpc7JHY43cWHID19CS6F3yjS6
tOe4t5JLEVHure0wZy39cew8lGP9urN4/sbQ2qFHZOksmAVXaX0kE/5uwxnPsnEh
8+xHL8sBm3j6jBQI9RiCQHZ8UcvKxEue1ZL2NK/i504aYOjkQG4=
=huGq
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--
