Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3667355911
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 18:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345808AbhDFQWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 12:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233438AbhDFQWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 12:22:48 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35797C06174A
        for <netdev@vger.kernel.org>; Tue,  6 Apr 2021 09:22:40 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id il9-20020a17090b1649b0290114bcb0d6c2so9966864pjb.0
        for <netdev@vger.kernel.org>; Tue, 06 Apr 2021 09:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version;
        bh=o3y2nefHADPbzbCCBhJWU/WOIpSYN4ccIUFBk8nJRO0=;
        b=JwMUVno4BVkGOU6XfE5ftQVFha620HZ4UZxSsostE46hBOAc02ItRdCQ6hcoig3MnH
         zAyxLxRP8zbEmdWDKfC+EGtFSy5fCbx2p3/1NvLV6ZP58Vfx4+zQVcqmoCvhXBiStdAr
         pi8LfbWX/ApKX+1aWMMec+xDf87EOuoOrPbFDxy8cQZ5VhcqvE8TEKAGWsIqnQEIJ5Ct
         mZflnlUWXF9F8xV8M0ymFESghPLT7u8z3jDCKASltF2JrnNqfU9zdSuDletXYWMqBc+x
         42jZ9zwCGnwzX077p1ZzTldiQEoHCszM2uMbM19ep0d1ht5W9iyVc8Xr9re2XbC88DlJ
         3ayg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version;
        bh=o3y2nefHADPbzbCCBhJWU/WOIpSYN4ccIUFBk8nJRO0=;
        b=Y0kGNRPJlAib3Z80dS7Wxm4pDzD4RNyt/DzVYqtcAbSSKAmhGR66vbsobdCTFdRx+2
         JuvBYfmUl52WurDXaKz4p0F5MSTMycESathGbc7aauOr59fV8D0IBUdWZ7/uFkzNk13c
         HdVDZiH7a/9mfHfJ8fwaldL91NihbyuL8f73djjSdjPyLIyA5TokDKBdhTXJplgJqFNt
         Ab1Yin2bqzRK3spPwPZBHQWtqkKcSbPTEM1tjou/BR9RuM8kdIYYl2VpvOeahbQmXmVM
         BDYvCzlhAR0gHicJjbZglnz00WTIwrvgTnoIGinfvqku7MK9sJfQUrkCt1MjO5rXeWsN
         iWgQ==
X-Gm-Message-State: AOAM531aYGwHmUP8LDbt38tqSH+EWkWwwkpjm4Kfc4K0c4gmdtkgWKss
        OpARY2NYtDBS5KkZzp/S7B5HtQ==
X-Google-Smtp-Source: ABdhPJx30DI9C7/wp2v4dQGgc/MIrVzN5+rQhofhOlMxAjJAOU4bU58NEioh/BoZzqJoXHfTWXVbMw==
X-Received: by 2002:a17:90a:5898:: with SMTP id j24mr5085660pji.103.1617726159701;
        Tue, 06 Apr 2021 09:22:39 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id v134sm18939998pfc.182.2021.04.06.09.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 09:22:39 -0700 (PDT)
Date:   Tue, 6 Apr 2021 09:22:31 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Alyssa Ross <hi@alyssa.is>
Cc:     netdev@vger.kernel.org
Subject: Re: [iproute2] finding the name of a TAP created with %d
Message-ID: <20210406092231.667138c2@hermes.local>
In-Reply-To: <20210406134240.wwumpnrzfjbttnmd@eve.qyliss.net>
References: <20210406134240.wwumpnrzfjbttnmd@eve.qyliss.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/F22B6NQfOTOjmF7G=3nB=CO";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/F22B6NQfOTOjmF7G=3nB=CO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 6 Apr 2021 13:42:40 +0000
Alyssa Ross <hi@alyssa.is> wrote:

> If I do
>=20
> 	ip tuntap add name tap%d mode tap
>=20
> then a TAP device with a name like "tap0", "tap1", etc. will be created.
> But there's no way for me to find out which name was chosen for the
> device created by that command.

Use a follow on ip link show or look in sysfs.

> Perhaps ip should print the name of tuntap devices after they're
> created?

You can already do that with followon command, or use batch to put two comm=
ands together.


> I'd be interested in sending a patch, but I'd need some guidance on how
> exactly it should work.  Would there be any harm in always printing it?
> Should it be behind a flag?  Or just when the name contains a `%'?

Printing the result would make ip tuntap behave differently, which makes
it unique (snowflakes are bad) and would break users scripts.

--Sig_/F22B6NQfOTOjmF7G=3nB=CO
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEn2/DRbBb5+dmuDyPgKd/YJXN5H4FAmBsiscACgkQgKd/YJXN
5H4sWw/9EIzkYwFs3ep/kvMPQx0bUu2QX3mjSep50+vQsXkza+A+nGWMcWU1ky20
28E26htkaQM0sNlBr44+MyDbyl7mJBHALsY9FtC/dJAbV4siwys6uWKrG6Qy8Cw5
cPtobEccM0cSuHepoqorarkYL8Sp8BRmm2OcFjgur4byqcrmwMMtoSNZIXi2Uicv
PmbZvp8HX6xFoZuVNCxxY9c3r/xMG4vE59gKlbMeQXh5ENhmyxH8lA6pKOIEfEbL
syMeZ4QEE+l6bY4nglO0PVsA53M8tOtxyvW1dWipyX2cEUzL0IXnneLi0oDOPenu
MyYIFn1Mr1NvM6SFWStx80C3g1PnalJPLprZtI+6DVeASyD4yUEda64O4/Q5bXs8
MdKXUJXbakjmUAkl57Wzy5e8/ulMMTg4qDwZN31nyJTrblaAGLOWZ4A/tpG4QxOS
GujP6mn88eWt1R0IhO1wXcKu4OAIwSZvOFwmzX3JNGVW73Hzuzf+QwOeBLpN9Ave
ncG8frrY++QkzyUT4dFYopYI0yLuKQ5DU2qw5NULNpAiy0OGfgsIhzAJsnSBtIQY
YgCH6lLhsXHOqWhKiq4kN8AgXPdZKMQagu2BAmCFVe2zrJCd2RVv6hNYK9t4cpOj
L+klqZYgb0joviklL4L9OZXOmbnEOpVgcV2dQnSfljqeo4M+gn8=
=PpSS
-----END PGP SIGNATURE-----

--Sig_/F22B6NQfOTOjmF7G=3nB=CO--
