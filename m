Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4639BBAE6
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 20:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440295AbfIWSFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 14:05:53 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:38386 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390851AbfIWSFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 14:05:53 -0400
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Sep 2019 14:05:50 EDT
Received: from sven-edge.localnet (unknown [IPv6:2a00:1ca0:1480:f9fc::4065])
        by dvalin.narfation.org (Postfix) with ESMTPSA id D9AF31FFAB;
        Mon, 23 Sep 2019 17:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1569259611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JUegENmeIHHiT+O9uIIOxc1zWJHPwvIxI2SvuwGf54A=;
        b=dVWTU2YRhbvNTjzU5zWqJuZwGuXdr2Y5i4h8fAIbmfcxuBJK1ZG+fGo/W/YblVDINcKj0n
        B670FTOeqbkbbqdtvLu3HbF2eoleJzXw6Dgnm1/VfifonzNleM7VytHWdyYL6G301L3qIC
        tdTHwh8/l2Z9JQUVmzRFgWWvKZS3wUo=
From:   Sven Eckelmann <sven@narfation.org>
To:     b.a.t.m.a.n@lists.open-mesh.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jiri Kosina <trivial@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-wireless@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        lvs-devel@vger.kernel.org, rds-devel@oss.oracle.com
Subject: Re: [PATCH trivial 1/2] net: Fix Kconfig indentation
Date:   Mon, 23 Sep 2019 19:56:12 +0200
Message-ID: <2354684.0ZvKvX0iQ3@sven-edge>
In-Reply-To: <20190923155243.6997-1-krzk@kernel.org>
References: <20190923155243.6997-1-krzk@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2306317.z6aVZVsvuq"; micalg="pgp-sha512"; protocol="application/pgp-signature"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1569259612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JUegENmeIHHiT+O9uIIOxc1zWJHPwvIxI2SvuwGf54A=;
        b=x1TVkKv99+ozAK7NGhKJppOQTZ3rt6BG5uCQ9jX1Cu6VwaJ1Z9e2XjHeZoi0ylFmE0Qgv2
        uPumTYEhEqN0pwscCMrxg05p8YgwwZxS95AE3BnKHxJCx8DfTCCPdTAyKbC6OzxnJqzLC+
        xMuRoeIhRMuvm0RcjlgRZSLiQKlXzBQ=
ARC-Seal: i=1; s=20121; d=narfation.org; t=1569259612; a=rsa-sha256;
        cv=none;
        b=sC+Bw4VcxyWYjzxCJPweIGNX+Yyrk334W9KKcHzvmcS/hWk8OQo5sJew0irtt83lHu620y
        GR1yOu+K+tFNotiu7Ji8FKdtPcJdPj6tP5KcJpiNcjdVnKzc1GUdEDf7J4u+rCReuDLD9y
        a6G6B/KjsDql8SBNK00XkdLiqUmNeNQ=
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=sven smtp.mailfrom=sven@narfation.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart2306317.z6aVZVsvuq
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Monday, 23 September 2019 17:52:42 CEST Krzysztof Kozlowski wrote:
> --- a/net/batman-adv/Kconfig
> +++ b/net/batman-adv/Kconfig
> @@ -12,11 +12,11 @@ config BATMAN_ADV
>         depends on NET
>         select LIBCRC32C
>         help
> -          B.A.T.M.A.N. (better approach to mobile ad-hoc networking) is
> -          a routing protocol for multi-hop ad-hoc mesh networks. The
> -          networks may be wired or wireless. See
> -          https://www.open-mesh.org/ for more information and user space
> -          tools.
> +         B.A.T.M.A.N. (better approach to mobile ad-hoc networking) is
> +         a routing protocol for multi-hop ad-hoc mesh networks. The
> +         networks may be wired or wireless. See
> +         https://www.open-mesh.org/ for more information and user space
> +         tools.
>  
>  config BATMAN_ADV_BATMAN_V
>         bool "B.A.T.M.A.N. V protocol"

Acked-by: Sven Eckelmann <sven@narfation.org>

Kind regards,
	Sven

--nextPart2306317.z6aVZVsvuq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAl2JBzwACgkQXYcKB8Em
e0YTVg/+PgtfvbyO8UPeEG3nkvaRcMywQsGWWB2nkRfHXA+QnFghJNXsvPHonkd+
QQ1E5I3loiK90VFbdRR8R0o5G57WPTFAivY334UAL1m5qOZT1bMKwI971dT0GCny
a9+BhZEjt729e7WlSOvkT/v7BHo8lxyHH5+x33dxMJF0oSD5UDdH8VZX9PCBTJ1g
4+O3e18WyQdsXFi3G2N75DcT+OhRle2P7T6yfgD0Ro5ViMqeTigsdmw+kpq8x8IK
fyUN3oo5vqFnH3sEEXFshmxAqAVjPjzzoRYTFTupTw8yDOTL2REIgU75HZ0WP2w6
eQ03/+7hKhujukr4V/bwVPMf6WJ1mi9+cz88Op8BkY/UgFgAYJSUhnfeoLo1pK6q
ewEwagQfFibXUqtebAoam3z20Mb7rnrUmQJbUvPLQatL76qUaonJp3yxUMnrOWo+
GmDWR4zgHgwatjOBeGCPBuF3PBMPWe1NBrA0EF7+33gZu6pttf3Z6XLNUWCw3unx
xQCR1dn7VzUA+/FdFZfVoUlGBPeqWzqdyp3Os2ymDHJRp6jZWTd2gX6KvldvWTDR
dU2SmyvoOovNLFWyBd7rC7vud0aWMJUHypD2IlEMCPprnu+m33Lhqx8nrbF/goZL
drH0F1BJDs5jlWehfTwnnaNdqZEuzamWT8GEJAUBj8Iq5R6+35s=
=OS2O
-----END PGP SIGNATURE-----

--nextPart2306317.z6aVZVsvuq--



