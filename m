Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCFD324BA6
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 09:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235396AbhBYIBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 03:01:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233996AbhBYIBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 03:01:30 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9BD4C06174A;
        Thu, 25 Feb 2021 00:00:49 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id u187so1927825wmg.4;
        Thu, 25 Feb 2021 00:00:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ta3OzSEGe0pGlQa1/6wh2mwdIsBwlShcPy03EcAAeAY=;
        b=VXXSoEL1t70kSem0mjxSbGWP2l6WCl0JVg+qcf3LKgJc8uCjkp92ZqltT/hwL8kLsP
         53gmcOnplQ9dzznSZZr0dAHENJQkRzP4pHwsxvLOhfHNekpRVEiUWPnqtoMeMeKJ06So
         FYBtR1gH7+ZNaiHa8A1hG8cL1knnt62JS28c828hQ+pK0OjLwu4Fw9C1K7SdjueGyYV3
         G197nX5N4lB5g2oie7ym9TaaK3fWGmFJTPH2psNFo0qBqbepuiEq0dQmTusrkVPiIg67
         ABQ+kxVMU1OA++tHQ3Hbx6FJFyk8tYPN6hYxQxa5z+/xcA6dSBgJgrrCUts0ziy+w+zE
         YfBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ta3OzSEGe0pGlQa1/6wh2mwdIsBwlShcPy03EcAAeAY=;
        b=aCdavDbZauTrffyqfQRUbJSFoqhKTPw/jSS06qH8Ir9l38rYwXol0YySPiLVb+1k5s
         e0MN/7X7Yu/sh87t4WFjrYzIaJxpuEBZRcSsG1O/0Uux0I/bFFU/6iSZn0TFe2mGpxQG
         x2rM8zZ9dC5E/27HIgLB696LBixULOWLtXQXGOeIXx/QmeE9KZTXEwnEQYmcjLo9rIL9
         g3eD/+cm2SYANGYeGmvHAAyzCQHGHeo6qDrphuMOMPzfvCtghs9Edz0uVEdoaerW4hvW
         QkDWwj9X0CZFYDC5C0vX9nhOQRLZPUMSdimrtD/gaCmb14oDoCCT8ucdYon84OLe9SsG
         y2PA==
X-Gm-Message-State: AOAM530SJozV90GHOx0zigwtRQJY8OibvRTIAfmw254wEVeXLlr2dJZi
        jTU/myncXKEO/+q4t9fzaaI=
X-Google-Smtp-Source: ABdhPJx6GyXM8A7kx8tYW9O+qz2cM9BODx6C5yY8gS1kwSuwaBZ4InciA2vUTVFHQlnGjzE0OC2WAg==
X-Received: by 2002:a05:600c:4e8a:: with SMTP id f10mr1945621wmq.15.1614240048633;
        Thu, 25 Feb 2021 00:00:48 -0800 (PST)
Received: from gmail.com (82-209-154-112.cust.bredband2.com. [82.209.154.112])
        by smtp.gmail.com with ESMTPSA id o3sm764567wmq.46.2021.02.25.00.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 00:00:48 -0800 (PST)
Date:   Thu, 25 Feb 2021 09:02:46 +0100
From:   Marcus Folkesson <marcus.folkesson@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Ajay.Kathat@microchip.com, Claudiu.Beznea@microchip.com,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wilc1000: write value to WILC_INTR2_ENABLE register
Message-ID: <YDdZpjoa8rODL0px@gmail.com>
References: <20210224163706.519658-1-marcus.folkesson@gmail.com>
 <87pn0pfmb4.fsf@codeaurora.org>
 <1b8270b5-047e-568e-8546-732bac6f9b0f@microchip.com>
 <87lfbcfwt1.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ofArnjgXtp6/xcZ6"
Content-Disposition: inline
In-Reply-To: <87lfbcfwt1.fsf@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ofArnjgXtp6/xcZ6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Feb 25, 2021 at 09:09:30AM +0200, Kalle Valo wrote:
> <Ajay.Kathat@microchip.com> writes:
>=20
> > On 24/02/21 10:13 pm, Kalle Valo wrote:
> >> EXTERNAL EMAIL: Do not click links or open attachments unless you
> >> know the content is safe
> >>=20
> >> Marcus Folkesson <marcus.folkesson@gmail.com> writes:
> >>=20
> >>> Write the value instead of reading it twice.
> >>>
> >>> Fixes: 5e63a598441a ("staging: wilc1000: added 'wilc_' prefix for fun=
ction in wilc_sdio.c file")
> >>>
> >>> Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
> >>> ---
> >>>  drivers/net/wireless/microchip/wilc1000/sdio.c | 2 +-
> >>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>
> >>> diff --git a/drivers/net/wireless/microchip/wilc1000/sdio.c b/drivers=
/net/wireless/microchip/wilc1000/sdio.c
> >>> index 351ff909ab1c..e14b9fc2c67a 100644
> >>> --- a/drivers/net/wireless/microchip/wilc1000/sdio.c
> >>> +++ b/drivers/net/wireless/microchip/wilc1000/sdio.c
> >>> @@ -947,7 +947,7 @@ static int wilc_sdio_sync_ext(struct wilc *wilc, =
int nint)
> >>>                       for (i =3D 0; (i < 3) && (nint > 0); i++, nint-=
-)
> >>>                               reg |=3D BIT(i);
> >>>
> >>> -                     ret =3D wilc_sdio_read_reg(wilc, WILC_INTR2_ENA=
BLE, &reg);
> >>> +                     ret =3D wilc_sdio_write_reg(wilc, WILC_INTR2_EN=
ABLE, reg);
> >>=20
> >> To me it looks like the bug existed before commit 5e63a598441a:
> >
> >
> > Yes, you are correct. The bug existed from commit c5c77ba18ea6:
> >
> > https://git.kernel.org/linus/c5c77ba18ea6
>=20
> So the fixes tag should be:
>=20
> Fixes: c5c77ba18ea6 ("staging: wilc1000: Add SDIO/SPI 802.11 driver")

You are right.

>=20
> I can change that during commit, ok?

Please do, thanks!

>=20
> --=20
> https://patchwork.kernel.org/project/linux-wireless/list/
>=20
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpa=
tches

Best regards
Marcus Folkesson

--ofArnjgXtp6/xcZ6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEBVGi6LZstU1kwSxliIBOb1ldUjIFAmA3WaEACgkQiIBOb1ld
UjLhEQ//UpMRDqeT7f6q2ck/6okAuqT2Jff7LrRq9oONDcxyePfKcCTa1VhWDA47
jo+3iXMBwuyFQOKWJ7PWUp3EVtPM2A3urcZTGoijfKAXtzE+PEf2yO2eC7Yk3tSx
vA3djsIrQT35w7OnGpnE5PFWDbDBAVS7mK/xSjngdB4f3FWsDg7kDQqO1JWyXyAB
ZtH+HBjEuaZ+xzfCVWfXh5D+UnvIZnTcvABHtTrWpXKhhuYGbov3iIg9h1ZhYNDb
0KW1W8MnXSUNEVbJo6HapxP+IHMoP+GOOOYG3alyR1FqfNr199sQWzKUPX26bvt7
01j8c6+Pk5o6i4/IAkkCTcCtykoAxyGfGlWdefSuKFhXoCnLu61cE8wQLsJd73P+
Emvb8W++oUmtYD960suSr5O9CyG8thVKpDVb/Lc+LVTZU9JMf1HPNmTsyeJFPkYh
dcb6OWEu6YlF8P+Xi5KjGXwuvxrzYRFbmM73DKuzYAiMG163TsSwLx/kLYEfFN95
h/gRAEA0rV3IGdUKkGz0urwl5X+jlkLciPHW4cD7bdFN523JQWRzpjsvB+taTPmR
rlq5i+ECyERA8Daj+DF6Q8TzVllty+Z8cVFs4Rqp1WiXDqm2dnbZa8Hr4NFM1GGc
Kh5TIIEsXmJBdT+/l4rjfq8ZlljapSn1R5SN+PK+H2Iq3TAdcjg=
=HVvU
-----END PGP SIGNATURE-----

--ofArnjgXtp6/xcZ6--
