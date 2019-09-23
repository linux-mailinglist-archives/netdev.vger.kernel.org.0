Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37278BB566
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 15:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408016AbfIWNev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 09:34:51 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:42838 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404581AbfIWNeu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 09:34:50 -0400
Received: by mail-ot1-f65.google.com with SMTP id c10so12066839otd.9;
        Mon, 23 Sep 2019 06:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2NRNT/qm8AbtyX6bm4uZ/GQHYcwpqJ9Os6l2yxnGLhE=;
        b=b2DzTF2BOhkGeYitm3sbUSyDhsdflg0iKZF0VWDo33bqNgftOXXbPT01yqRcQkceHG
         rZ2edpkQAP8t/XQuB7QOvOHQ/XUcJLVr18zr+GPbSQ+3bPHDO9zYQtrZU3TwAjHeyBf6
         Mkk862v2GT5hokib9oE0IKthOiwqSr4ga6BOspmBYs7oLvCavH5XvMlAnwJxMCoue9Y7
         6y7/s8BQ4qetaS3M2c6LXJ17v5W/F++FfDkF+bSGBUDLiC8beElJi//OdmSqg85lcq92
         yKcS3BJMQaO1DXyMO5QBM1etfQ321grLj2YjlCH7SUiJDV4vztg98Xb/TgmYlgpqS9q1
         aOiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2NRNT/qm8AbtyX6bm4uZ/GQHYcwpqJ9Os6l2yxnGLhE=;
        b=VCh3dcDrZrTzFwTPGJIAToxbyk+JN8pz8cifGsuXaKlYKU3puYohBQnvfbeDOAPE4E
         McZ2ZVCIQdc2czhhVSDrHkwNEpmGVZe1TNL4mW8yb21NU4hknxClgmO/eCCMAbKCac0V
         8+XEQGjX1kv9lH4w4ISkP/uQmf5vN28dncvJrsQljJDvnxKZ5655PNazWjdbL7ZifgbO
         2vMpyLYg93GIq6yrufZ9cQfh1qPKFXkBp5ZDs3qcoBtpEYLfZBytje5VOLVMF0C4CydJ
         uYLsXS25uezMhQskOLktVDgVZlo24rg2snUVOUB7ldJLEnMrBFTOt2y1CkTHVNIkDBs+
         e0rg==
X-Gm-Message-State: APjAAAUm9h956yq+WDDHicayOHtmYVoC3PUyHHluW5MTZ2xeSkaPnmxe
        UlaWuBNQCrIPruAUCvMGOfZKgiiLn5ZpnbPymulugQMYovnQZw==
X-Google-Smtp-Source: APXvYqxO3XWPSWwL+e9d4kqs68XLgFOn9a/IPLBkTuqUmJzXIoobr1YJ8g7tefWdo1jhzaITR/cg9iUjme01Re05vy0=
X-Received: by 2002:a9d:7407:: with SMTP id n7mr13868528otk.16.1569245689782;
 Mon, 23 Sep 2019 06:34:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190917065044.GA173797@LGEARND20B15>
In-Reply-To: <20190917065044.GA173797@LGEARND20B15>
From:   Austin Kim <austindh.kim@gmail.com>
Date:   Mon, 23 Sep 2019 22:34:39 +0900
Message-ID: <CADLLry5b1RDjXX8Dbc4ebbZOFFaAd0wc3rDCaD-V9RBwrpNyMA@mail.gmail.com>
Subject: Re: [PATCH] rtlwifi: rtl8723ae: Remove unused 'rtstatus' variable
To:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, Maintainers...
Would you please review above patch if you are available?

Thanks,
Austin Kim

2019=EB=85=84 9=EC=9B=94 17=EC=9D=BC (=ED=99=94) =EC=98=A4=ED=9B=84 3:50, A=
ustin Kim <austindh.kim@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> 'rtstatus' local variable is not used,
> so remove it for clean-up.
>
> Signed-off-by: Austin Kim <austindh.kim@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c b/drive=
rs/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
> index 54a3aec..22441dd 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
> @@ -485,15 +485,12 @@ bool rtl8723e_phy_config_rf_with_headerfile(struct =
ieee80211_hw *hw,
>                                             enum radio_path rfpath)
>  {
>         int i;
> -       bool rtstatus =3D true;
>         u32 *radioa_array_table;
>         u16 radioa_arraylen;
>
>         radioa_arraylen =3D RTL8723ERADIOA_1TARRAYLENGTH;
>         radioa_array_table =3D RTL8723E_RADIOA_1TARRAY;
>
> -       rtstatus =3D true;
> -
>         switch (rfpath) {
>         case RF90_PATH_A:
>                 for (i =3D 0; i < radioa_arraylen; i =3D i + 2) {
> --
> 2.6.2
>
