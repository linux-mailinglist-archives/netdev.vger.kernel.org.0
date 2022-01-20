Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC2A494C50
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 11:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbiATK5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 05:57:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiATK5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 05:57:05 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F123AC061574;
        Thu, 20 Jan 2022 02:57:04 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id c24so24592761edy.4;
        Thu, 20 Jan 2022 02:57:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VJFSujY0gawm0vuS1B+3onnPwXQ2aVqz3AH1Ci+gepI=;
        b=H4/nz/vo+kTO/K3uRtiAAeZz3SGXVBo6YrTUQ+W7Ycvfez1rGht/zH9RmQP+HGdFVo
         PnPybtNQi65V3jbC6OUUkg0QCQGp1ESHk1FiyBpqZnbsNCXh+d537X9sBIdC3X5SK4OP
         aoKsZ8v/+4WDjUPIiGXHYsMqOrZHiI28+oBNcbduAjTz8iaG91Fb+v03qy7ZZIzVlLHC
         cwjjuRyc1pANbTp2GCyJTe2zmO5dmbTDwqqLU+/pcUkp4v/9wqCyrgi3VTHQ7eF5iSxM
         Dw63NjJxMZRWEjyGRa5kWakrI4w1Nixt3l4CGBIMqEYa8fQgncrQoeikSbKMFxufKjto
         0boA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VJFSujY0gawm0vuS1B+3onnPwXQ2aVqz3AH1Ci+gepI=;
        b=bu3G0KOm4o0ScV1wq8T9q7rEoCc6FNxFFvoLt51PmE6pIoYeOISKSOBeC07nkskbvm
         JzgiIoSaKAcPsNMHMqSFL2OjO+kWCG9XeKtFNk7TvfkzMh8F1bPBaIVaOHwZ2w3kZGEA
         fGb3QuWz05xE8lrQeo9I/uhrn18Wur2cb8lKMNRyMnBTpQX8U8af9PBOnQfxw0QjGz0k
         ZvqtDpoktEmjwVW2nR/oTXfiUdNpWvRC/HdCYDxbl2O+kSMtgpgZF4QjYWUSzn1GJmBJ
         /jhqNPIbg9EEFEanYQBvOKKCaC+EzlSdy1b31cQUGCBBXkZpTVVMPx2EtwXsPlaf+pI5
         C+/g==
X-Gm-Message-State: AOAM533Qi6+i8RAx7epgByEGRqKmactAV7XiF3RBCUv/dqmvNwuWopgd
        9t6f4bglCTTI6916KDJawwXSGTRjnn2Bs2tvCTI=
X-Google-Smtp-Source: ABdhPJy3XM0de+IEVOkIlJ0EiHVt6il1s31sj3OZSQPpdqexZ1vW8TAK6qllKAhg9nSYkjHK1td5+VScKb3gWzGNMgM=
X-Received: by 2002:a05:6402:35d3:: with SMTP id z19mr20345363edc.29.1642676223381;
 Thu, 20 Jan 2022 02:57:03 -0800 (PST)
MIME-Version: 1.0
References: <20220117142919.207370-1-marcan@marcan.st> <20220117142919.207370-9-marcan@marcan.st>
In-Reply-To: <20220117142919.207370-9-marcan@marcan.st>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 20 Jan 2022 12:55:21 +0200
Message-ID: <CAHp75Vd1VJhwTey=8FmmX=UaTCFnWzVjf0Y4Ctq=eLyVqi7_ig@mail.gmail.com>
Subject: Re: [PATCH v3 8/9] brcmfmac: fwil: Constify iovar name arguments
To:     Hector Martin <marcan@marcan.st>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        SHA-cyfmac-dev-list@infineon.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 17, 2022 at 4:31 PM Hector Martin <marcan@marcan.st> wrote:
>
> Make all the iovar name arguments const char * instead of just char *.

Makes sense.
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Hector Martin <marcan@marcan.st>
> ---
>  .../broadcom/brcm80211/brcmfmac/fwil.c        | 34 +++++++++----------
>  .../broadcom/brcm80211/brcmfmac/fwil.h        | 28 +++++++--------
>  2 files changed, 31 insertions(+), 31 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
> index d5578ca681bb..72fe8bce6eaf 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
> @@ -192,7 +192,7 @@ brcmf_fil_cmd_int_get(struct brcmf_if *ifp, u32 cmd, u32 *data)
>  }
>
>  static u32
> -brcmf_create_iovar(char *name, const char *data, u32 datalen,
> +brcmf_create_iovar(const char *name, const char *data, u32 datalen,
>                    char *buf, u32 buflen)
>  {
>         u32 len;
> @@ -213,7 +213,7 @@ brcmf_create_iovar(char *name, const char *data, u32 datalen,
>
>
>  s32
> -brcmf_fil_iovar_data_set(struct brcmf_if *ifp, char *name, const void *data,
> +brcmf_fil_iovar_data_set(struct brcmf_if *ifp, const char *name, const void *data,
>                          u32 len)
>  {
>         struct brcmf_pub *drvr = ifp->drvr;
> @@ -241,7 +241,7 @@ brcmf_fil_iovar_data_set(struct brcmf_if *ifp, char *name, const void *data,
>  }
>
>  s32
> -brcmf_fil_iovar_data_get(struct brcmf_if *ifp, char *name, void *data,
> +brcmf_fil_iovar_data_get(struct brcmf_if *ifp, const char *name, void *data,
>                          u32 len)
>  {
>         struct brcmf_pub *drvr = ifp->drvr;
> @@ -272,7 +272,7 @@ brcmf_fil_iovar_data_get(struct brcmf_if *ifp, char *name, void *data,
>  }
>
>  s32
> -brcmf_fil_iovar_int_set(struct brcmf_if *ifp, char *name, u32 data)
> +brcmf_fil_iovar_int_set(struct brcmf_if *ifp, const char *name, u32 data)
>  {
>         __le32 data_le = cpu_to_le32(data);
>
> @@ -280,7 +280,7 @@ brcmf_fil_iovar_int_set(struct brcmf_if *ifp, char *name, u32 data)
>  }
>
>  s32
> -brcmf_fil_iovar_int_get(struct brcmf_if *ifp, char *name, u32 *data)
> +brcmf_fil_iovar_int_get(struct brcmf_if *ifp, const char *name, u32 *data)
>  {
>         __le32 data_le = cpu_to_le32(*data);
>         s32 err;
> @@ -292,7 +292,7 @@ brcmf_fil_iovar_int_get(struct brcmf_if *ifp, char *name, u32 *data)
>  }
>
>  static u32
> -brcmf_create_bsscfg(s32 bsscfgidx, char *name, char *data, u32 datalen,
> +brcmf_create_bsscfg(s32 bsscfgidx, const char *name, char *data, u32 datalen,
>                     char *buf, u32 buflen)
>  {
>         const s8 *prefix = "bsscfg:";
> @@ -337,7 +337,7 @@ brcmf_create_bsscfg(s32 bsscfgidx, char *name, char *data, u32 datalen,
>  }
>
>  s32
> -brcmf_fil_bsscfg_data_set(struct brcmf_if *ifp, char *name,
> +brcmf_fil_bsscfg_data_set(struct brcmf_if *ifp, const char *name,
>                           void *data, u32 len)
>  {
>         struct brcmf_pub *drvr = ifp->drvr;
> @@ -366,7 +366,7 @@ brcmf_fil_bsscfg_data_set(struct brcmf_if *ifp, char *name,
>  }
>
>  s32
> -brcmf_fil_bsscfg_data_get(struct brcmf_if *ifp, char *name,
> +brcmf_fil_bsscfg_data_get(struct brcmf_if *ifp, const char *name,
>                           void *data, u32 len)
>  {
>         struct brcmf_pub *drvr = ifp->drvr;
> @@ -396,7 +396,7 @@ brcmf_fil_bsscfg_data_get(struct brcmf_if *ifp, char *name,
>  }
>
>  s32
> -brcmf_fil_bsscfg_int_set(struct brcmf_if *ifp, char *name, u32 data)
> +brcmf_fil_bsscfg_int_set(struct brcmf_if *ifp, const char *name, u32 data)
>  {
>         __le32 data_le = cpu_to_le32(data);
>
> @@ -405,7 +405,7 @@ brcmf_fil_bsscfg_int_set(struct brcmf_if *ifp, char *name, u32 data)
>  }
>
>  s32
> -brcmf_fil_bsscfg_int_get(struct brcmf_if *ifp, char *name, u32 *data)
> +brcmf_fil_bsscfg_int_get(struct brcmf_if *ifp, const char *name, u32 *data)
>  {
>         __le32 data_le = cpu_to_le32(*data);
>         s32 err;
> @@ -417,7 +417,7 @@ brcmf_fil_bsscfg_int_get(struct brcmf_if *ifp, char *name, u32 *data)
>         return err;
>  }
>
> -static u32 brcmf_create_xtlv(char *name, u16 id, char *data, u32 len,
> +static u32 brcmf_create_xtlv(const char *name, u16 id, char *data, u32 len,
>                              char *buf, u32 buflen)
>  {
>         u32 iolen;
> @@ -438,7 +438,7 @@ static u32 brcmf_create_xtlv(char *name, u16 id, char *data, u32 len,
>         return iolen;
>  }
>
> -s32 brcmf_fil_xtlv_data_set(struct brcmf_if *ifp, char *name, u16 id,
> +s32 brcmf_fil_xtlv_data_set(struct brcmf_if *ifp, const char *name, u16 id,
>                             void *data, u32 len)
>  {
>         struct brcmf_pub *drvr = ifp->drvr;
> @@ -466,7 +466,7 @@ s32 brcmf_fil_xtlv_data_set(struct brcmf_if *ifp, char *name, u16 id,
>         return err;
>  }
>
> -s32 brcmf_fil_xtlv_data_get(struct brcmf_if *ifp, char *name, u16 id,
> +s32 brcmf_fil_xtlv_data_get(struct brcmf_if *ifp, const char *name, u16 id,
>                             void *data, u32 len)
>  {
>         struct brcmf_pub *drvr = ifp->drvr;
> @@ -495,7 +495,7 @@ s32 brcmf_fil_xtlv_data_get(struct brcmf_if *ifp, char *name, u16 id,
>         return err;
>  }
>
> -s32 brcmf_fil_xtlv_int_set(struct brcmf_if *ifp, char *name, u16 id, u32 data)
> +s32 brcmf_fil_xtlv_int_set(struct brcmf_if *ifp, const char *name, u16 id, u32 data)
>  {
>         __le32 data_le = cpu_to_le32(data);
>
> @@ -503,7 +503,7 @@ s32 brcmf_fil_xtlv_int_set(struct brcmf_if *ifp, char *name, u16 id, u32 data)
>                                          sizeof(data_le));
>  }
>
> -s32 brcmf_fil_xtlv_int_get(struct brcmf_if *ifp, char *name, u16 id, u32 *data)
> +s32 brcmf_fil_xtlv_int_get(struct brcmf_if *ifp, const char *name, u16 id, u32 *data)
>  {
>         __le32 data_le = cpu_to_le32(*data);
>         s32 err;
> @@ -514,12 +514,12 @@ s32 brcmf_fil_xtlv_int_get(struct brcmf_if *ifp, char *name, u16 id, u32 *data)
>         return err;
>  }
>
> -s32 brcmf_fil_xtlv_int8_get(struct brcmf_if *ifp, char *name, u16 id, u8 *data)
> +s32 brcmf_fil_xtlv_int8_get(struct brcmf_if *ifp, const char *name, u16 id, u8 *data)
>  {
>         return brcmf_fil_xtlv_data_get(ifp, name, id, data, sizeof(*data));
>  }
>
> -s32 brcmf_fil_xtlv_int16_get(struct brcmf_if *ifp, char *name, u16 id, u16 *data)
> +s32 brcmf_fil_xtlv_int16_get(struct brcmf_if *ifp, const char *name, u16 id, u16 *data)
>  {
>         __le16 data_le = cpu_to_le16(*data);
>         s32 err;
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h
> index cb26f8c59c21..bc693157c4b1 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h
> @@ -84,26 +84,26 @@ s32 brcmf_fil_cmd_data_get(struct brcmf_if *ifp, u32 cmd, void *data, u32 len);
>  s32 brcmf_fil_cmd_int_set(struct brcmf_if *ifp, u32 cmd, u32 data);
>  s32 brcmf_fil_cmd_int_get(struct brcmf_if *ifp, u32 cmd, u32 *data);
>
> -s32 brcmf_fil_iovar_data_set(struct brcmf_if *ifp, char *name, const void *data,
> +s32 brcmf_fil_iovar_data_set(struct brcmf_if *ifp, const char *name, const void *data,
>                              u32 len);
> -s32 brcmf_fil_iovar_data_get(struct brcmf_if *ifp, char *name, void *data,
> +s32 brcmf_fil_iovar_data_get(struct brcmf_if *ifp, const char *name, void *data,
>                              u32 len);
> -s32 brcmf_fil_iovar_int_set(struct brcmf_if *ifp, char *name, u32 data);
> -s32 brcmf_fil_iovar_int_get(struct brcmf_if *ifp, char *name, u32 *data);
> +s32 brcmf_fil_iovar_int_set(struct brcmf_if *ifp, const char *name, u32 data);
> +s32 brcmf_fil_iovar_int_get(struct brcmf_if *ifp, const char *name, u32 *data);
>
> -s32 brcmf_fil_bsscfg_data_set(struct brcmf_if *ifp, char *name, void *data,
> +s32 brcmf_fil_bsscfg_data_set(struct brcmf_if *ifp, const char *name, void *data,
>                               u32 len);
> -s32 brcmf_fil_bsscfg_data_get(struct brcmf_if *ifp, char *name, void *data,
> +s32 brcmf_fil_bsscfg_data_get(struct brcmf_if *ifp, const char *name, void *data,
>                               u32 len);
> -s32 brcmf_fil_bsscfg_int_set(struct brcmf_if *ifp, char *name, u32 data);
> -s32 brcmf_fil_bsscfg_int_get(struct brcmf_if *ifp, char *name, u32 *data);
> -s32 brcmf_fil_xtlv_data_set(struct brcmf_if *ifp, char *name, u16 id,
> +s32 brcmf_fil_bsscfg_int_set(struct brcmf_if *ifp, const char *name, u32 data);
> +s32 brcmf_fil_bsscfg_int_get(struct brcmf_if *ifp, const char *name, u32 *data);
> +s32 brcmf_fil_xtlv_data_set(struct brcmf_if *ifp, const char *name, u16 id,
>                             void *data, u32 len);
> -s32 brcmf_fil_xtlv_data_get(struct brcmf_if *ifp, char *name, u16 id,
> +s32 brcmf_fil_xtlv_data_get(struct brcmf_if *ifp, const char *name, u16 id,
>                             void *data, u32 len);
> -s32 brcmf_fil_xtlv_int_set(struct brcmf_if *ifp, char *name, u16 id, u32 data);
> -s32 brcmf_fil_xtlv_int_get(struct brcmf_if *ifp, char *name, u16 id, u32 *data);
> -s32 brcmf_fil_xtlv_int8_get(struct brcmf_if *ifp, char *name, u16 id, u8 *data);
> -s32 brcmf_fil_xtlv_int16_get(struct brcmf_if *ifp, char *name, u16 id, u16 *data);
> +s32 brcmf_fil_xtlv_int_set(struct brcmf_if *ifp, const char *name, u16 id, u32 data);
> +s32 brcmf_fil_xtlv_int_get(struct brcmf_if *ifp, const char *name, u16 id, u32 *data);
> +s32 brcmf_fil_xtlv_int8_get(struct brcmf_if *ifp, const char *name, u16 id, u8 *data);
> +s32 brcmf_fil_xtlv_int16_get(struct brcmf_if *ifp, const char *name, u16 id, u16 *data);
>
>  #endif /* _fwil_h_ */
> --
> 2.33.0
>


-- 
With Best Regards,
Andy Shevchenko
