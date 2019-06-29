Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAF7E5AD26
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 21:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfF2Teh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 15:34:37 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:45597 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbfF2Teg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 15:34:36 -0400
Received: by mail-yw1-f67.google.com with SMTP id m16so6382496ywh.12
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 12:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TrEAkRNd58OxQm438HJ/LWyeqxT458dpIIN9rnAAj1U=;
        b=HFHXV38GwofcAY4vLufShERlXUE5rVUMWzsssyqAnf0TGWxiz1zoetJzFqA0bstvbL
         AU0mOgyXmRgYKWklGPZcp6I3oEkTvzO4rBRpwHqzyG8WuXzhuKX4mizCX9zqbnPS5MOZ
         T2tb0XGFjnhBKrDXR+37mvesIMo8lpJUcL9dUz8C9J9DyYqu+EguGocJFOnGzRIGrJOf
         c0jV99HS4ygDUN07KVog9GTaPnlucLiqO7JkYzfGFh/SCaftOgacj8FofJ/2c1gAn/fI
         wh9SNlrIJtYIpuC9U+pSi8j5OqpG5TaDp3eOICbaZr8rLis5//S33c7cSkvzYykqeZmR
         5PNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TrEAkRNd58OxQm438HJ/LWyeqxT458dpIIN9rnAAj1U=;
        b=oH4LN4N+2kyPQJuL0tsE+rrrw0srDT/BKVan8GFKm9YqINZU0/tVAwFMOlMTA8T+Pb
         HQ8iw1gt7AqpxQDSHJARkauTqe2CAqZ9oOVlT40XKWBYu8hytQTeqly4I4TLyk1Q3BUE
         E1Oc/W+uUtG0mSWltii4isrq/29KmSIV7VxItkeGtslsihJNUDWWEVSD3fnv0Mhr4F5L
         nr9D65FXfqSpQCAWwuJQEE++fECdqNvsf2ssPEiuNCgYmItc2SIA5hmO4FVf/kluOsnd
         y3Gl79L8trtrrGGLYKn9gdau0OOnKwnJPGXSe390uwlXc7zA/5znT1FdmeZCanZkNjXR
         AWgA==
X-Gm-Message-State: APjAAAUu+O8/0bHcinZSDzr7oNcphoHN79jKUAeDJA090zB0sVUZYxGE
        l6P1V67p7xCL+kkffdjxbDk0nHEJ
X-Google-Smtp-Source: APXvYqzpzhOjkXM/LUEiFKVE9XmI99Rn5kW8Dj/S5NFcahU3+TDM0UcxizCuwee2s+dulLB66Y0YrQ==
X-Received: by 2002:a81:a1d7:: with SMTP id y206mr10526529ywg.7.1561836875476;
        Sat, 29 Jun 2019 12:34:35 -0700 (PDT)
Received: from mail-yw1-f41.google.com (mail-yw1-f41.google.com. [209.85.161.41])
        by smtp.gmail.com with ESMTPSA id g189sm1529895ywa.20.2019.06.29.12.34.34
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Jun 2019 12:34:34 -0700 (PDT)
Received: by mail-yw1-f41.google.com with SMTP id u134so6403819ywf.6
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 12:34:34 -0700 (PDT)
X-Received: by 2002:a81:4807:: with SMTP id v7mr8813316ywa.494.1561836873634;
 Sat, 29 Jun 2019 12:34:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190629122419.19026-1-opensource@vdorst.com>
In-Reply-To: <20190629122419.19026-1-opensource@vdorst.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 29 Jun 2019 15:33:57 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdr8HCRJTE8pEVxsga3N-xx-fEAxzKAAyPFWH6doVRHbQ@mail.gmail.com>
Message-ID: <CA+FuTSdr8HCRJTE8pEVxsga3N-xx-fEAxzKAAyPFWH6doVRHbQ@mail.gmail.com>
Subject: Re: [PATCH] net: ethernet: mediatek: Fix overlapping capability bits.
To:     =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>
Cc:     sean.wang@mediatek.com, f.fainelli@gmail.com,
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

On Sat, Jun 29, 2019 at 8:24 AM Ren=C3=A9 van Dorst <opensource@vdorst.com>=
 wrote:
>
> Both MTK_TRGMII_MT7621_CLK and MTK_PATH_BIT are defined as bit 10.
>
> This causes issues on non-MT7621 devices which has the
> MTK_PATH_BIT(MTK_ETH_PATH_GMAC1_RGMII) capability set.
> The wrong TRGMII setup code is executed.
>
> Moving the MTK_PATH_BIT to bit 11 fixes the issue.
>
> Fixes: 8efaa653a8a5 ("net: ethernet: mediatek: Add MT7621 TRGMII mode
> support")
> Signed-off-by: Ren=C3=A9 van Dorst <opensource@vdorst.com>

This targets net? Please mark networking patches [PATCH net] or [PATCH
net-next].

> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/et=
hernet/mediatek/mtk_eth_soc.h
> index 876ce6798709..2cb8a915731c 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> @@ -626,7 +626,7 @@ enum mtk_eth_path {
>  #define MTK_TRGMII_MT7621_CLK          BIT(10)
>
>  /* Supported path present on SoCs */
> -#define MTK_PATH_BIT(x)         BIT((x) + 10)
>
> +#define MTK_PATH_BIT(x)         BIT((x) + 11)
>

To avoid this happening again, perhaps make the reserved range more explici=
t?

For instance

#define MTK_FIXED_BIT_LAST 10
#define MTK_TRGMII_MT7621_CLK  BIT(MTK_FIXED_BIT_LAST)

#define MTK_PATH_BIT_FIRST  (MTK_FIXED_BIT_LAST + 1)
#define MTK_PATH_BIT_LAST (MTK_FIXED_BIT_LAST + 7)
#define MTK_MUX_BIT_FIRST (MTK_PATH_BIT_LAST + 1)

Though I imagine there are cleaner approaches. Perhaps define all
fields as enum instead of just mtk_eth_mux and mtk_eth_path. Then
there can be no accidental collision.
