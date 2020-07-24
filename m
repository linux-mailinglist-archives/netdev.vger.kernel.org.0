Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A6722BDDC
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 08:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgGXGEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 02:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725898AbgGXGEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 02:04:24 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6F9C0619D3;
        Thu, 23 Jul 2020 23:04:23 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595570661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W/Q7CjsF5YM70HgqJFYJatisrDvgiek54xnQlBFfRBo=;
        b=su8eQhU14kEk8WW8+WP+7/xC/t0xtp1qrhbgMhSA3juVONgmL/mfajkrIvobUXv2HXCnog
        XfcTEPUlRiEZE92+LLi8SaI40c5zr1VkwQZqxOtN+wwDrM2LXQXh/ACrZIGitTChJO3tMm
        asxQhS7+Ti4++aYQ5HJzRRFd8UwTecYEd3XnnBPml/6hYf1TxMATep2kD0jaJMEUTsXdPx
        cUPvGBUT+SAEOaaKB98J7ofxpWkFnBPtvVqisewKep2IyV/7+89IrzjqkHEFHSSCDBPCMD
        h/XaFkmjz96/SHfayPlKfeR4FhM+Uf+ZDbSVBhuxkJPBnf2hkOK5AKSP0AmHmQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595570661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W/Q7CjsF5YM70HgqJFYJatisrDvgiek54xnQlBFfRBo=;
        b=RdSIXFiO0A23nPDNvlCwNrHjPsxLFPxxfYae7AQoKK60LfmrJdmlnQfOxudGxk+Qba5jEC
        P6zN0aXJ6ZPLBfBw==
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v2 0/8] Hirschmann Hellcreek DSA driver
In-Reply-To: <20200723093339.7f2b6e27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200723081714.16005-1-kurt@linutronix.de> <20200723093339.7f2b6e27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Fri, 24 Jul 2020 08:04:10 +0200
Message-ID: <87wo2t30v9.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Thu Jul 23 2020, Jakub Kicinski wrote:
> Appears not to build:
>

Yeah, i know. This patch series depends on two other ones:

 * https://lkml.kernel.org/netdev/20200723074946.14253-1-kurt@linutronix.de/
 * https://lkml.kernel.org/netdev/20200720124939.4359-1-kurt@linutronix.de/

One of them has been merged, the other is being discussed. That series
includes the 'ptp_header' and the corresponding functions. So, for
compile testing you'll have to apply that series as well.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl8aedoACgkQeSpbgcuY
8Ka5lw//Td9+vjtUcPCDvj++bQMYniWhZpj2bLUhDPym+CXfAYNpdazAMS0ByIvY
uePFci2PDJtG/PXhKygBDU8rWx5bKdCNOwD/xwsCThplvIvK7vOH5k/uf6DDhNH/
83d7BUJik9TRoTWcJIdZPUDclZsLGY7FbMdrMkT8GLmMSoHornUSbkryxIFTGP/K
Lx34DEoDBv+c+MF0NISkzd8zWmGu81IT8c4Bc8uCuYKbdvyyNWQcN/sJhHanvcSJ
OI1f+9gyM6N4pRXuXGUJM9X57CsDljDwaS52gAHwb8q64Q41QqyF8b4avZq7oOvY
itEN8jhhkWAa5tnfvAdMHmvck4peEcvBylDheCigD7vH1GR9fQJ89dfpG8rLE720
zLK+3671ZC1xkVnjI9DM3p3ptBFTglLvwqcv/5QxZAoKH/Ap/d/3gMvTVCfL/qsA
dpw7Gfp7ixAUVtTV/v+vjFJFQbyusjUQXpAjKYXyXxHdSiHygNmv9SEljxs2gkHE
HJPxbFs5NBOSaa9yqgjGLg8O2RfRnUA7f9TWp+ZxXIN+NKBZ5efCobr0MJ88mTIk
kLw5suc236isl5VCQ3+HgYD6pToQzD7+njR6EMrwp8xd+lAwsCXZnx716HZPt9hM
xeWj4ZSn4Nlu+IKegVJM0iSP3WBaUmjJsX3yMpWOHvV7pBAXgkQ=
=Lg4Q
-----END PGP SIGNATURE-----
--=-=-=--
