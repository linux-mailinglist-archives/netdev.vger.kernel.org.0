Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2717944A83F
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 09:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244004AbhKIIXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 03:23:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239953AbhKIIXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 03:23:42 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B0AC061764;
        Tue,  9 Nov 2021 00:20:57 -0800 (PST)
From:   Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636446055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XB/jnYZ0uAToeYDc7Y7hi585Z8EzRcsq8mXeI7xQiTE=;
        b=xLh65Aosy0wl+keM6T5b2UegXmKcoboE5B+wmF8R7inWqAc1nCgGHHEUrufdnempYhnM/5
        X5p0xVaec+ULF5b5q/X2i/gzDXbZ5XOT5Hqh41KoTYln9KerxDb5oTSr3Uy3VUETQyK0yh
        VlAeLPlF+Hd/Fv1OGqB2qS5EYqOz8aXGFRcp2JnVVTRNL+Jw7vCyDXtZ8KJ321joa21j6Q
        svJS/GZszig+ZI0GXN4NMKsoipn0jhgXpVvgcpyJI0nojXn6P13N/UMRJJtB3i0pppTFBh
        dWsUABHSK1Ar5+fDlUPU915/j7YKFvNhY8uRfZxRhN07H3rqtxMQjVbSBB4AKg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636446055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XB/jnYZ0uAToeYDc7Y7hi585Z8EzRcsq8mXeI7xQiTE=;
        b=b2/KdFGJzTuZQm1oEiRtYg5xGPVDKtF4nRMqhODSq10mZ15j1APcTZ/rxCeq+Go+Plie2Q
        InEqAb+8v7hwY9Bg==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Yannick Vignon <yannick.vignon@nxp.com>
Subject: Re: [PATCH net] net: stmmac: allow a tc-taprio base-time of zero
In-Reply-To: <20211108202854.1740995-1-vladimir.oltean@nxp.com>
References: <20211108202854.1740995-1-vladimir.oltean@nxp.com>
Date:   Tue, 09 Nov 2021 09:20:53 +0100
Message-ID: <87bl2t3fkq.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi Vladimir,

On Mon Nov 08 2021, Vladimir Oltean wrote:
> Commit fe28c53ed71d ("net: stmmac: fix taprio configuration when
> base_time is in the past") allowed some base time values in the past,
> but apparently not all, the base-time value of 0 (Jan 1st 1970) is still
> explicitly denied by the driver.
>
> Remove the bogus check.
>
> Fixes: b60189e0392f ("net: stmmac: Integrate EST with TAPRIO scheduler API")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

I've experienced the same problem and wanted to send a patch for
it. Thanks!

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJSBAEBCgA8FiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmGKL2UeHGt1cnQua2Fu
emVuYmFjaEBsaW51dHJvbml4LmRlAAoJEHkqW4HLmPCm/PoP/27bUDpdMEQXWqTt
MeXl0o1uh6dc4KXB1elbTcoN+eJscsgO4uex5zH6atF6xlEtAjfmigT1APc1imvH
+1wwP1gaDLc7csegFvuKzfDSGfX6sWwsx4Z5rrfhTzv1COU4WMGspg3gFC/vh8Tk
vrUJFvwFv7uq0YLEaqbwMUF0wwKs0wxO4uMSpSjjTzPUAL1dQBQAXzlR8TrFZBn0
WLC4jTmDZhd+9aNtgQYJel9F/mkTAyGn0e9T69ysO1mLv3v0V8OTnvYdVFOZlpc5
voyNTZwxYNR5oaAbHfhDzG37neCjqou/BWTJt3P8BZzUZENT1B6x74OxIpntGaxV
TJ2tvnfFtCb2aikxCUTwBqYZDvufYfXduIYCrwp6ub0LavLMdsJycZhRf7S4Jpp0
rDLFGFd8k4b4x5FeXS6cx7nS8pT8KHwbII92+HEKm9083KlbrS7dxAKgNRSV11k0
2sdUlC2Z3Am4vYC+mtHF/A1neozXymiRiN67upmdnKz04uhokeUsVjQnaJAmZQ+H
gY15SKiujkxUjFhVfw5bG5Fe9Zoh13YQnpOMDpjtGkf7aRYsuksTBQCLgdvgF0Ww
GrHLPbxGhm0UdKnsEYYhB1p5cdaFU0tbjO2Q+F9FYTJETweXtq8wgm/pjkVy2hVH
dw3uQ6RDYBLDCiH5Nt0ZXAMe5kyX
=zNUQ
-----END PGP SIGNATURE-----
--=-=-=--
