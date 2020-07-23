Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3A9322AD04
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 12:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbgGWKyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 06:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbgGWKyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 06:54:23 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE4AC0619DC
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 03:54:23 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595501661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ucYQ37yr4qowI1FdnRoqWDH/etFONX4Ezpyme+d6JPo=;
        b=MJYswWbQZYvBW5Wglin6D8nGB7tYKABtf7N9HNlcKoyNrCfvatBENp4LdS5IzHzrKCD2OJ
        syJm0+mFiyFoN2ui90gNl93fj8nlyicesx43dqdPNRo6PhLw/yNWbNC7NPbhftjFTHflHv
        G1W3I5QqZuIqlOc7AQ7YdH7w04UC0KnFirciTgB7JTp+jM/8fc5X9dq10tKqXF1IBpPDog
        OC0bs2QNI8XwU3kwHHouBm83PDkZhytV1vg+MF5WiVq1z3npXRMoS/xkqzpUWqurOcZJ8u
        9+hI2zf8nvGx5IdDF19FM6htExcdOeAqFYFGgJ6rpjhqxEsZP43FXvY0qOjn6A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595501661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ucYQ37yr4qowI1FdnRoqWDH/etFONX4Ezpyme+d6JPo=;
        b=v4GNYTJwJ7v+bp16Ipkmg/K2853v8eElzzZfWWvmb5iJNIpFsDqXeHqWA6lK8gzdOU5O/f
        LHgbxvAVjPVVIpDQ==
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH v1 1/2] ptp: Add generic ptp v2 header parsing function
In-Reply-To: <20200723074946.14253-2-kurt@linutronix.de>
References: <20200723074946.14253-1-kurt@linutronix.de> <20200723074946.14253-2-kurt@linutronix.de>
Date:   Thu, 23 Jul 2020 12:54:18 +0200
Message-ID: <87a6zq7b8l.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Thu Jul 23 2020, Kurt Kanzenbach wrote:
> +static struct ptp_header *ptp_parse_header(struct sk_buff *skb,
> +					   unsigned int type)
> +{
> +	return NULL;
> +}
>  #endif

That should be static inline ofc.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl8ZbFoACgkQeSpbgcuY
8KYANBAAz8gFakCbFDbC0xggVDV/6WPVQdFeIUuMnJKgdX2ASP3XagYQQF4MTOsL
wn6sasyZh2Tlu7TVa7MnpiMTzSKYIsxauACwPDYkJPL2iTBDUxju40Yz25gHD1Fz
Y503w0vLlMM0ucJvTIKHawsHP9w9fTIfs6xjnsodsz0rVzgc7ZS7TfO01k2GiXl2
BEdctR0/YPlHfrHbRuiMWRg9iN8uo4ULvFkTOI+J3x3HBf6DSON2TDr0+HzkvYC+
yoH07c9tVGR0CeWi7OUmLfpClR9LVCdnQK5965KFPK1tsTGc2i/NXXaP0/zkihcU
lB539SH20SWrG8mMGoqkx35l/wrr4Qnb1G0aII+XxgTbOs8T3EMYoLlIv8JojUFp
wTf+iA8hmHVde++mmomoE+1s2fFaqw8NTi+AATMsvbbeKLq/YXlLAJnZuHoLGqie
EbBS6S5spBlZsUy0zGnBgTuGf0ZxASWZV/MId9P5Ignre5nWY855y3lU2LdxdClG
1tzY/MKZJCOUiKu5vsqxokAi9VG+KT0MX4hQvt4XGMj8ZyixYbzPlPx6VCqk+Rin
gFYz8nb8LK4AOQKqU4JCBb7yk2IroGYNFhVODkZzzCNLG6hwu8ku54HBt9N5Qheg
ZxCAOHcSkX1G0BAKPYx/KbP0CahL8Sp9DIP6dMN6VCy74rTPdwo=
=1Uwa
-----END PGP SIGNATURE-----
--=-=-=--
