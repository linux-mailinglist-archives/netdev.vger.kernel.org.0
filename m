Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFC156717
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 12:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbfFZKpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 06:45:30 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34435 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbfFZKp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 06:45:29 -0400
Received: by mail-wr1-f67.google.com with SMTP id k11so2188852wrl.1;
        Wed, 26 Jun 2019 03:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VzYlELuHWLmeH4BA1vZ96Wr04Fx9TdVtK5+LAe1TDoo=;
        b=YxNdJnYg5o45T2xFRTMgh6IVz9JrQ1IqPtnyb+jZI2xV3F6oxyzMqO57ql40LVDFkF
         mh9z/tE8u6rmRNEkasxKxoc/blmYSh5ws+YmefUYtvMIKUWcLnWOVfcm5tR12QhkhqKC
         mK6GuXCccLXrDeRP5VAQq1ChuHNSE+g9yAoLmdD4uFTRbDkxDjyY0dDivso3ZufFm+RK
         fi4XLOzuFl6zRJuwo0On7W9muSxHiZvPk8kAnLkBEkSpaNKk6F9fCVuXJSfG0a9MIRLy
         P8Js/pYf8yRlSII3Dsa5HVY3yo5fLbRueW5cGVxahtalSjgRRo1VIITniv18UrxW98Eb
         Yepg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VzYlELuHWLmeH4BA1vZ96Wr04Fx9TdVtK5+LAe1TDoo=;
        b=BBnZ+nXAThxwU8IB1jdg3RfV1qQaHTclzXeT0OfglN6jV3vDeQqWsRHlWo6X7lYRPk
         z0o7oIewcX7sLj5+X4/d8Y+4YvNzVeARxxxZd9ojnVP/ztHTmWD8vYpiGlF41QybzRtQ
         CbANBkOzotcetj7AiTo05Kr1gBFwZN3954LLMXwJhzPgTZ4u7Ibb24vpjAHye2kP2GV9
         vPLJvBq+j1PTYQiG+Bc0YJpA+TQFlLer+HZx7A4235ssrCIALdWCWnNYGyesmdaOUHha
         3eMPsk7asXl/CuStPUPfhviBBi9koBRO9NX8Xthlwnj48tk/kPiQMvnzNus35raVPkQj
         352Q==
X-Gm-Message-State: APjAAAWKbGa0BU7C7p+aNYe+/5obfjj9qtbWEeh6MiSmHGLBTVO2Qy/K
        SwvS2RLGkiGtpZdDnphzcvfDsbYNQR0=
X-Google-Smtp-Source: APXvYqzqqpLcrchSB3MEKgFES/AtInHoOSvqEjOeF1kQWjyiXW0QTsJ0T+bgy7SBStUaJozeF1ixTg==
X-Received: by 2002:adf:9003:: with SMTP id h3mr3334720wrh.172.1561545927716;
        Wed, 26 Jun 2019 03:45:27 -0700 (PDT)
Received: from localhost (p2E5BEF36.dip0.t-ipconnect.de. [46.91.239.54])
        by smtp.gmail.com with ESMTPSA id z5sm1646318wma.36.2019.06.26.03.45.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 03:45:27 -0700 (PDT)
Date:   Wed, 26 Jun 2019 12:45:25 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 1/2] net: stmmac: Fix possible deadlock when disabling
 EEE support
Message-ID: <20190626104525.GH6362@ulmo>
References: <20190626102322.18821-1-jonathanh@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="it/zdz3K1bH9Y8/E"
Content-Disposition: inline
In-Reply-To: <20190626102322.18821-1-jonathanh@nvidia.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--it/zdz3K1bH9Y8/E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 26, 2019 at 11:23:21AM +0100, Jon Hunter wrote:
> When stmmac_eee_init() is called to disable EEE support, then the timer
> for EEE support is stopped and we return from the function. Prior to
> stopping the timer, a mutex was acquired but in this case it is never
> released and so could cause a deadlock. Fix this by releasing the mutex
> prior to returning from stmmax_eee_init() when stopping the EEE timer.
>=20
> Fixes: 74371272f97f ("net: stmmac: Convert to phylink and remove phylib l=
ogic")
> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 +
>  1 file changed, 1 insertion(+)

Tested-by: Thierry Reding <treding@nvidia.com>

--it/zdz3K1bH9Y8/E
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl0TTMUACgkQ3SOs138+
s6GggQ//S7aRh+7qKUq7BOqNvXA0odDDLtnvYxmihsOI3CtmAEMzA55QyQT18bCn
rXIv7tzANYDZDpnXJHT7lksGRDGXWzmXB1ehc0isKGNIirBYmPt58jUdN9gI7dlA
kf0ivngQUba49jZ45S4zbg+S2bTVe4Xljqx/Z3IUiyHW7vcs5cNTbOozmD1MgY6D
BrBV+TsgIBgfYOcdP8gFlvYDa9GjQKfTQMNkm+3niSyxZBLbCGm2hyObe2acxOmU
O/mJ1h+2vailfzxqViZxB3+kqf0EIWt2efwaDr75Bmyc9NXvWVYzKr8c2teyOODa
9de95vb61PPZrufuoEjpMgEV5aAtDVQVC/zVwcMJF8o4Qc+v5sBR4erhMjsIVctB
QmgxEVcUdfo6MxOw+sa9qJsCvRsLuAdxflpvro7UBLaOthWSh3SaIf0IgSx+mqpK
1x3jlY/vQZ3vMw/6BoLb+3sgnZNMjh1sSYFKZCNVdDqd6l+q/E/Jw7p/hx8txRN+
uiAGlbe6V8Rib9rtvHsE/oIcWR8eMa7s7hRgudRMKHJUVA9Q6B8BX9OA79hR6QXK
Uw1pLJaSoHlyOxY5uJMGgMRMSsn3LkY+Cgc2COu5ILcNtjtO7HrRpXm/TkFARTow
klV31kVW6VEkXJVSasGzev4TAKU99GEDPqEyDJYWiyeCbhfJgsM=
=VDy+
-----END PGP SIGNATURE-----

--it/zdz3K1bH9Y8/E--
