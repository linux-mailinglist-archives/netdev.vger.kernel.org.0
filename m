Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B64A5671A
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 12:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfFZKps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 06:45:48 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45890 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbfFZKps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 06:45:48 -0400
Received: by mail-wr1-f67.google.com with SMTP id f9so2122140wre.12;
        Wed, 26 Jun 2019 03:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QxtLAShEbD51lRsaOr630GQ/4Jpu40qq0Z+oYEM5QLg=;
        b=fMmm1VghHWVoTVYcTg8cG8fk+pKeHAdWXUHyFEdpKEAQlKcHL0Ywi2ZFX/Mxi5P/Ci
         JhCZOICqwHP5lJvF2UAgy0DxJlBlmSG3GsKI82A+4/78IuBboS3M2rIq4WPohdZ7JymJ
         GksphPANUGNyjdas6yQf2QLzVuS5SC7SiTT+PngLi3sp7QOuUoSut6zJ9ZOkEO63gLSN
         /g+nevJDVqKPpVtpPDBvIk7x4hap7a5YOi42TzeP+koPjFf5WoF/I80T8XqVXhFdGrfN
         nRpnWmlgyEe6AimGRax+1YNxiLj5ooXhhjWz4658w0di6aI0ZvRVBw9MwxxnclfWbocF
         elhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QxtLAShEbD51lRsaOr630GQ/4Jpu40qq0Z+oYEM5QLg=;
        b=E+EL/O+t8o7FXLt45pkqWvAql5PG2lLDTfzobv+iz8hxrMboJ0Cw9oQccK6S8RPmsv
         rVlJHQZEba1aNxndpmGUeUN/hB7m/vwa9wCumOMX7ZMVcgNOsZlV5a62qlRsi3JQjrFO
         ybNluhoDu5x0LCcTLXZv0vtjgLpnVj5rg+P+G2P6FJqMOqeDZNVbwEH1QlQisrW/CiUt
         LNrZ/LzZ1CCrFv+1hohVA23P1WQ5s+XRUR7Uic6PpcrzPlwQkMMId/85cPYS+EwnLtF0
         7+QXL9T3gkCWxMRXKtoM+1J3PCVyIzR/iXsZAnNzYVhJf7UIOXlD9x+rnUl1EThRBh2q
         6+gQ==
X-Gm-Message-State: APjAAAXLDvqt7mZaB2Cf7bBeJAqJA0Jp7P6NpTWdbvL1vdbWecAIW3Ml
        BeI8wKP2efNFRTRc/LzlcM0=
X-Google-Smtp-Source: APXvYqzxvqAmve1oLrsN7iKAcXfGdn2YvmW8IeoDqjcL6qsR1HKP/T3bln0ccAkT/rMIL7rsREfqkQ==
X-Received: by 2002:adf:de8e:: with SMTP id w14mr3346670wrl.130.1561545945743;
        Wed, 26 Jun 2019 03:45:45 -0700 (PDT)
Received: from localhost (p2E5BEF36.dip0.t-ipconnect.de. [46.91.239.54])
        by smtp.gmail.com with ESMTPSA id o126sm2049711wmo.1.2019.06.26.03.45.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 03:45:45 -0700 (PDT)
Date:   Wed, 26 Jun 2019 12:45:44 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 2/2] net: stmmac: Fix crash observed if PHY does not
 support EEE
Message-ID: <20190626104544.GI6362@ulmo>
References: <20190626102322.18821-1-jonathanh@nvidia.com>
 <20190626102322.18821-2-jonathanh@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sl5MdczEF/OU2Miu"
Content-Disposition: inline
In-Reply-To: <20190626102322.18821-2-jonathanh@nvidia.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--sl5MdczEF/OU2Miu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 26, 2019 at 11:23:22AM +0100, Jon Hunter wrote:
> If the PHY does not support EEE mode, then a crash is observed when the
> ethernet interface is enabled. The crash occurs, because if the PHY does
> not support EEE, then although the EEE timer is never configured, it is
> still marked as enabled and so the stmmac ethernet driver is still
> trying to update the timer by calling mod_timer(). This triggers a BUG()
> in the mod_timer() because we are trying to update a timer when there is
> no callback function set because timer_setup() was never called for this
> timer.
>=20
> The problem is caused because we return true from the function
> stmmac_eee_init(), marking the EEE timer as enabled, even when we have
> not configured the EEE timer. Fix this by ensuring that we return false
> if the PHY does not support EEE and hence, 'eee_active' is not set.
>=20
> Fixes: 74371272f97f ("net: stmmac: Convert to phylink and remove phylib l=
ogic")
> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)

Thanks for hunting this down!

Tested-by: Thierry Reding <treding@nvidia.com>

--sl5MdczEF/OU2Miu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl0TTNgACgkQ3SOs138+
s6HZQBAAqWrK8d1EPvTwnqLtgKJ5oN+frh+R6yXy+OT9WPSZ3GbCBHmwIf7EXKgP
q4SHLahpmzfSayIS1hoN2hpKOz2T2irwKkE+NcElJqw1e/8sfEQmQjS+CD0TX4m7
CSM8nmu60kh7DWfvERzJZHdBO9lgNY8ib8zCcp/fNeVJRCySW+Pu0c8jjiRDhDbA
DJwKwvWiYNmZS2ycgsKyUNDprThYf7v7SznwWtEETGjCuRIkEFyLAFvEZGi6NEFh
dGUA30V3dyIMfw3QyR2Ixmna61NxWIDpeUHjw0O8GjL4dNv8GPnP+ViKIedxsEdq
3NQTHprz21iu2P8KgLkH6E7vKOzvoncmHaR/L+QXqwnTTLCFyt0XlaQvjPwGw7jV
etePMuaq+8DyRr5oo48V7T4ErBzTWXhWXttOSdy6J8BqNAYhtjjJgYcjmghnxUev
evjssMoZc05oJjenN/l/UvFuvEQofKpWPv3ls68sHjKgOQgp4RL+D194FX/cX+0s
R0rdH9x2Wji7PPEscCIIOVcdRxlNi8JOwDPjrJCmjmlmbWM5uh70khn7Psp5n6Cf
qn4nSdPBfMFT5oD59vxND6MYrvzGpMsmzuiGuhXAEu6a5Xe1xi1DaB4/yTJkxSnh
xofb5RhdAb7fEGbF5LmiO5WRVZk1y2svLc6HUeTIhxASonYM24M=
=Z0mB
-----END PGP SIGNATURE-----

--sl5MdczEF/OU2Miu--
