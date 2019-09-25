Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 309A0BDCD7
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 13:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390223AbfIYLRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 07:17:11 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36825 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727194AbfIYLRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 07:17:11 -0400
Received: by mail-wr1-f66.google.com with SMTP id y19so6355423wrd.3;
        Wed, 25 Sep 2019 04:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ewh2tywkLqZlhEf4dlrOJFegWM6vCxVit4Jp0/Iy6YA=;
        b=EM++OpNnrdeGqv88OBevgij38QBZ6KHgddXUeBxRdEL3eWaz01RGU0LjNUzZMM2Vtv
         7mJ24doe1o6bXHgyoY9pYwdEcOiLyY3Y/93PgYxa7rIlaNaYOFzI51jR9xodShyz0E1c
         RqmmHBNjtXM4Kf9pxv0t54KcVxKTsdxPzVfsqt4f964DaBJto4xbSyZPpVtrKbGT1ERW
         yHwvQpwzZQzin2vmqTg+nCZAk3Iapm+DEW1kmkQmq3QUZTO7Bi5jw9wJJ/R1xPsiZ0s2
         Rbrl+0aQtFJTLiTfhkRq9txAn1KeaElH5q78gPBMtqVXenRZZc77QzpjEaGnfoWsHmXH
         sOGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ewh2tywkLqZlhEf4dlrOJFegWM6vCxVit4Jp0/Iy6YA=;
        b=lCuz/UJ9SxtsOTUZf1McBRNcdJfBJ/EDc7fCml8FaDNaFHx6wS4mKUJZ7Ei6I5HPiH
         kVipYZC2w6BR0D7rq+haiERPtyo1IlFuF52gg+jLKrxeV+Q34tA517jkVhKCxzRiY7TQ
         Bg4M5/aN4gtoIGj29ct1WzY7HNd4JzsjiuFZlPWlS/+OfQJWYW7DwQ3uopXmzWxZvBdI
         SkCKdxMDxjqh9bgofX3yJEJUeZqQYLwHXcanjSe7/A/I8VokLlI7cjL83LveOy29C5z8
         yed6wipWjcKQxDj9KMvl8ODZWEZZukYc0osW5+r1UxyXFsxxzLQlaWtfVOv2pOopiyC1
         y6kQ==
X-Gm-Message-State: APjAAAWvr7iQ2hGj59VHnuajcyp+fkexXnfDKGsTlU8EWwxCDFdHImjk
        bw3U0Ym7CGB3Pgk9uU39IFE=
X-Google-Smtp-Source: APXvYqz7eRgEdTQcIiCa61mj3GswSM+ZXRp5N9JIWY8gQDZhHKKozU/dDQjKXgEvM2jHOEmP5s7seA==
X-Received: by 2002:adf:ef0c:: with SMTP id e12mr6515777wro.81.1569410228498;
        Wed, 25 Sep 2019 04:17:08 -0700 (PDT)
Received: from localhost (p2E5BE2CE.dip0.t-ipconnect.de. [46.91.226.206])
        by smtp.gmail.com with ESMTPSA id d9sm7699365wrf.62.2019.09.25.04.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 04:17:07 -0700 (PDT)
Date:   Wed, 25 Sep 2019 13:17:06 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, f.fainelli@gmail.com, jonathanh@nvidia.com,
        bbiswas@nvidia.com, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v3 0/2] net: stmmac: Enhanced addressing mode for DWMAC
 4.10
Message-ID: <20190925111706.GA762@ulmo>
References: <20190920170036.22610-1-thierry.reding@gmail.com>
 <20190924.214508.1949579574079200671.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <20190924.214508.1949579574079200671.davem@davemloft.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 24, 2019 at 09:45:08PM +0200, David Miller wrote:
> From: Thierry Reding <thierry.reding@gmail.com>
> Date: Fri, 20 Sep 2019 19:00:34 +0200
>=20
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > The DWMAC 4.10 supports the same enhanced addressing mode as later
> > generations. Parse this capability from the hardware feature registers
> > and set the EAME (Enhanced Addressing Mode Enable) bit when necessary.
>=20
> This looks like an enhancement and/or optimization rather than a bug fix.
>=20
> Also, you're now writing to the high 32-bits unconditionally, even when
> it will always be zero because of 32-bit addressing.  That looks like
> a step backwards to me.
>=20
> I'm not applying this.

Sounds like you would prefer v2 of this:

	https://patchwork.ozlabs.org/project/netdev/list/?series=3D129768&state=3D*

While v2 didn't have a cover letter, it did write the upper 32 bits
conditionally.

Do you want to pick that up instead, or do you want me to send out a v4
with the cover letter from v3 and the patches from v2?

Thierry

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl2LTK4ACgkQ3SOs138+
s6HijQ/+Pq/zxEk+Hd2Tte3ohElo3VjxVScgrj1Cr48KuVRw4g6upLfx6LUSSDKb
GPv/gGq8gqiP4AL0F9TJvzntRTpFIMvewGXxbIbppe9J0kO+OkcRGwMV10pBCyjU
i8FGO4kGvg+Nv6Hk41ZlJ4Clzc7BfBYhEQN8azZu+0EshNbGd0IA37Njl9l37fuP
EkRQ2hCxz1v/iPlcxHan4k4+oWEJOdTIkd44VywVvdzY8BJQKFNiGtdEdzBt4d2n
gjFexFnDwsMafjdHYOGVrRnBHmGoaqL+z7uTKdktzXEAExDCBqiZcUUL3pJw5aP5
3gwRRYWxmeGz3B62AAb+s+mBU7QcM4Q7hyQuVHQ9XSwTX6Qvrdu48BN/e0TdR2cz
uGxLlLDYjCVeFuUoQ/xoQkMSES6rxiNVpAJnnv4Gqf70OrXXojQBgnQTDPYllBeW
MzE+DhiLXveadYG0h01UlmFoyuEjlXa2VspByZb5kBZImG3eg3vKumoLKuakB18d
qiyK2B5QZBKj3ywjwtgRRqH2UGdb8lq8unBaR13hFaFz79+F8yUTDKyfLoFf1DsI
qRkiuaL+SD7Uat8v5Be5rNpUg8M6j+CphDKLrU+/5NvgPhdpBMYoctjqqI/V/gGH
aiBW527bCgsbjAvV9HBR5MdrWAspx1H6Cp60ZCEBNWZeoYOQUMQ=
=iMf9
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
