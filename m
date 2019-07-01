Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4CEB5BC36
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 14:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbfGAM6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 08:58:08 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:37869 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfGAM6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 08:58:07 -0400
Received: by mail-ed1-f68.google.com with SMTP id w13so23422548eds.4;
        Mon, 01 Jul 2019 05:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=v0fCKQ2i33aj1RCSVIG+EEExzNxptE/jC85JPv26GyI=;
        b=hb2i0hfLnid1g2N5nBjMlDsQYJkKngCirK8lL72HwZK/OEesQFVO0uFbi1Rfj4hlvx
         2go31kB6h5L9z07i/Yuh0j7s79Ll47dPhRzB6iGOaR97C8hsHo8GzAZDKPBXIlcNe5cm
         M1LnQRpNyvUCFVDqgMHWGXgXhg6f9ALnBy1SxXiQwylw2aEjTk1USL3CVHejzA/sKdyE
         xvvaJmBLcDchXq/D5Q5CH5v/dTPE7UpX8Gy3ojXWg/neHCkm1QV+v36SlmTbalu5z547
         bQ2Qqmz/fQLydjVF0l7p2lu0FqsoCnb2DtYgE3U8gu+mV//N4jhw+Jqul/BxP62Rxvoo
         W5TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=v0fCKQ2i33aj1RCSVIG+EEExzNxptE/jC85JPv26GyI=;
        b=LqOVqcdzdHR0moQPnFwcQo2QXuKmZ9U4D402ojCcnKye5iOWzTPE2+Rq/LTdsGycqd
         wToqVKUiOWaQouHgmMnBkk+r7qHJBdKVVc6X6kGmJrWec2ZIQC3lIsWjTPP2pODtaI0g
         +W+B5VniSIjGjN6jWKe/Ko+kwbJsdAexGtkG2WRaMJhCrGetyWBgK3L47sEPfk7ujvcA
         Lc1ABtNQ+oOv/0r6zM4ShcfbwwDNH5Mx6z71N31QAGMMRp7HEAZm2RbL2uaZ+CvMqs+x
         rtJYmL8BQ6+J6PpJJgIaIYy4l57cojhhS+cQDuixtK3OoMEt4OjQ/ZXGiGuwWri5QxoE
         QoGQ==
X-Gm-Message-State: APjAAAX1+JgCgQ0rnhxhjBYFhyYsmJ/DWmH+RKviybSWzjSXr62zZS2V
        kI0bGl9z6n+r1hTzJA8VNTODGX2vIkSnQ4cpgNA=
X-Google-Smtp-Source: APXvYqzFW9cWNNNvSjbaP18Gs9ax+rHWm6yiVTe96G+UNUhNWl77EHZ91bFnIdtKEaqmhOcxrFDZA3hEs8z08eho578=
X-Received: by 2002:a17:906:2acf:: with SMTP id m15mr22871580eje.31.1561985885975;
 Mon, 01 Jul 2019 05:58:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190629122419.19026-1-opensource@vdorst.com> <CA+FuTSdr8HCRJTE8pEVxsga3N-xx-fEAxzKAAyPFWH6doVRHbQ@mail.gmail.com>
 <20190701124447.Horde.RNUh-fSQf6XMauvPaGIYpKj@www.vdorst.com>
In-Reply-To: <20190701124447.Horde.RNUh-fSQf6XMauvPaGIYpKj@www.vdorst.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 1 Jul 2019 08:57:29 -0400
Message-ID: <CAF=yD-+6FqkWOhGk0vXKA5q5EEx8WEhXCfqq7SnJ3MqA=JB2qA@mail.gmail.com>
Subject: Re: [PATCH] net: ethernet: mediatek: Fix overlapping capability bits.
To:     =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>
Cc:     sean.wang@mediatek.com, Florian Fainelli <f.fainelli@gmail.com>,
        linux@armlinux.org.uk, David Miller <davem@davemloft.net>,
        matthias.bgg@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        frank-w@public-files.de,
        Network Development <netdev@vger.kernel.org>,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 1, 2019 at 8:44 AM Ren=C3=A9 van Dorst <opensource@vdorst.com> =
wrote:
>
> Quoting Willem de Bruijn <willemdebruijn.kernel@gmail.com>:
>
> > On Sat, Jun 29, 2019 at 8:24 AM Ren=C3=A9 van Dorst <opensource@vdorst.=
com> wrote:
> >>
> >> Both MTK_TRGMII_MT7621_CLK and MTK_PATH_BIT are defined as bit 10.
> >>
> >> This causes issues on non-MT7621 devices which has the
> >> MTK_PATH_BIT(MTK_ETH_PATH_GMAC1_RGMII) capability set.
> >> The wrong TRGMII setup code is executed.
> >>
> >> Moving the MTK_PATH_BIT to bit 11 fixes the issue.
> >>
> >> Fixes: 8efaa653a8a5 ("net: ethernet: mediatek: Add MT7621 TRGMII mode
> >> support")
> >> Signed-off-by: Ren=C3=A9 van Dorst <opensource@vdorst.com>
> >
> > This targets net? Please mark networking patches [PATCH net] or [PATCH
> > net-next].
>
> Hi Willem,
>
> Thanks for you input.
>
> This patch was for net-next.
>
> >
> >> ---
> >>  drivers/net/ethernet/mediatek/mtk_eth_soc.h | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> >> b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> >> index 876ce6798709..2cb8a915731c 100644
> >> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> >> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> >> @@ -626,7 +626,7 @@ enum mtk_eth_path {
> >>  #define MTK_TRGMII_MT7621_CLK          BIT(10)
> >>
> >>  /* Supported path present on SoCs */
> >> -#define MTK_PATH_BIT(x)         BIT((x) + 10)
> >>
> >> +#define MTK_PATH_BIT(x)         BIT((x) + 11)
> >>
> >
> > To avoid this happening again, perhaps make the reserved range more exp=
licit?
> >
> > For instance
> >
> > #define MTK_FIXED_BIT_LAST 10
> > #define MTK_TRGMII_MT7621_CLK  BIT(MTK_FIXED_BIT_LAST)
> >
> > #define MTK_PATH_BIT_FIRST  (MTK_FIXED_BIT_LAST + 1)
> > #define MTK_PATH_BIT_LAST (MTK_FIXED_BIT_LAST + 7)
> > #define MTK_MUX_BIT_FIRST (MTK_PATH_BIT_LAST + 1)
> >
> > Though I imagine there are cleaner approaches. Perhaps define all
> > fields as enum instead of just mtk_eth_mux and mtk_eth_path. Then
> > there can be no accidental collision.
>
> You mean in a similar way as done in the ethtool.h [0]?
>
> Use a enum to define the unique bits.
>
> enum mtk_bits {
>         MTK_RGMII_BIT =3D 0,
>         MTK_SGMII_BIT,
>         MTK_TRGMII_BIT,
>         AND SO ON ....
> };
>
> Also move the mtk_eth_mux and mtk_eth_path in to this enum.

That's the key part: they are all part of the same namespace and these
enums are not used anywhere else, so a single enum will avoid
accidentally namespace collisions.

> Then use defines to convert bits to values.
>
> #define MTK_RGMII  BIT(MTK_RGMII_BIT)
> #define MTK_TRGMII BIT(MTK_TRGMII_BIT)
>
> Replace the MTK_PATH_BIT and MTK_PATH_BIT macro with BIT()
>
> Is this what you had in mind?

Great find. Exactly, but I did not find such a clear example.

>
> Greats,
>
> Ren=C3=A9
>
> [0]:
> https://elixir.bootlin.com/linux/latest/source/include/uapi/linux/ethtool=
.h#L1402
>
>
>
