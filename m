Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEE7F46FC17
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 08:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235681AbhLJH4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 02:56:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235454AbhLJH4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 02:56:31 -0500
X-Greylist: delayed 193 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 09 Dec 2021 23:52:56 PST
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12CCC061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 23:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1639122773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zbggbeIVFXVq1N1T3x23ZrWZqRWaOMq4LLIQcQz7uVQ=;
        b=tQHDr0N4lHgpLkjFYlfjFJ0DjipI+hLPIAKvgeln8rY0KeJ7fEIlcufo/db9KPlUPrCIFT
        jgte41ukD+KrGIVftIi6ttle/ZcD77tOCvODJprwhJCik8CMGOmYAq5hAIpy62YG9W5JOd
        8XSQwKPviRoZTa0UvVyQ+8kDN/LYA0Q=
From:   Sven Eckelmann <sven@narfation.org>
To:     mareklindner@neomailbox.ch, cgel.zte@gmail.com
Cc:     sw@simonwunderlich.de, a@unstable.cc, davem@davemloft.net,
        kuba@kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>
Subject: Re: [PATCH] net/batman-adv:remove unneeded variable
Date:   Fri, 10 Dec 2021 08:52:50 +0100
Message-ID: <2844186.8fJna1iEf4@ripper>
In-Reply-To: <20211210021917.423912-1-chi.minghao@zte.com.cn>
References: <20211210021917.423912-1-chi.minghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2270532.c4uxPF5YdD"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart2270532.c4uxPF5YdD
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
To: mareklindner@neomailbox.ch, cgel.zte@gmail.com
Cc: sw@simonwunderlich.de, a@unstable.cc, davem@davemloft.net, kuba@kernel.org, b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>
Subject: Re: [PATCH] net/batman-adv:remove unneeded variable
Date: Fri, 10 Dec 2021 08:52:50 +0100
Message-ID: <2844186.8fJna1iEf4@ripper>
In-Reply-To: <20211210021917.423912-1-chi.minghao@zte.com.cn>
References: <20211210021917.423912-1-chi.minghao@zte.com.cn>

On Friday, 10 December 2021 03:19:17 CET cgel.zte@gmail.com wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> Return status directly from function called.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cm>

And the Reported-by (robot) using a mail address which is bouncing.

   <zealci@zte.com.cm>: Host or domain name not found. Name service error for
       name=zte.com.cm type=AAAA: Host not found

Please fix this too in your scripts.

Kind regards,
	Sven
--nextPart2270532.c4uxPF5YdD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAmGzB1IACgkQXYcKB8Em
e0YUag/+PA8FzRLW/Uw2ybainV3OPDxuUbSMmbufA1AaODvg4trJjA7xn7Zq2PnE
/8hsnXwHxq99To/o5tHkLF3f8xJSA+PmQtzPda90N4GUtiY+P0eQvtD7gFND82t9
Tl8t9WF208WcfPqH+CH1YzK2YuWB6q2Y8YBzUk1gBfp4jKaiyF/X6Ybz5mqt0zTm
SDISMa1cx1T+kvehH4p9AJ2/OluR7wGUd3Gw5GseMoYzRkV1UOzTuaGAgPhlA4p5
iPbLur4bpfZXYb+D13iUQn+2FRueBs267+0X8C13kU22bIVlDWlUwBomTi6kwPxJ
YZxQ6JOfvbwkTFjnHtet+ioWN9bz1zHE8Gn7f5HE5vrbUg8daduNN+q20bmfiYh0
uOYlaJ/2PoJd+chjcytq7tOcgN53NevhmCE2N/fUzi4yLo+yg3YeFY5GqvL7GPEP
qKa8HZYZxXpH4+HB0AV4wZdW+ngGpN/xnettRTt1ialtntDJjur/PDmjuqbS+X3s
VvNOWvB0MjYRm/ibAYw/rodI/umHV1xYVYD/gDC6K91pQ0k7C68BG7Mm6UkJ2HpW
IIOoN/TctEXLL3PFz1OxxN3QVjOsX2AAXXBYI6H+JnRIJeKGjzptdJPq/WFXWb72
eD6l645BH/1vrhBN+7gq1iumXxFBAEhILF41FlbujbeFnwxdK9E=
=1me2
-----END PGP SIGNATURE-----

--nextPart2270532.c4uxPF5YdD--



