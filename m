Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C745A6E073B
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 08:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjDMGyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 02:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjDMGyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 02:54:43 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 935AD83D9
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 23:54:40 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-5491fa028adso588274227b3.10
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 23:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681368880; x=1683960880;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nc4lL7JxaxGf+XYCkFM159Jes+f3X5bXuBPCU38sK1A=;
        b=x2EEYKNwns2Pbb+ucqgKdqZDtnOo6wufbG6wB0BNrEeumCTEuZUHPvnqh3lVB8O3Ey
         mTULQ6o6izzJFtYG/CmIBv5nYiEKgr2DyZDnldRzaZh7eVaIWvpgL4Ay6F47ov6oirTX
         AW1qSljM7dA9NwrfrCwhxK/hEgkFIQpwoAhzof9Rf0skU2RkGAAvOJCelN6C/IRrqQMa
         +2zdkUsfddnMir10WHagqmm85rqs9dZYuaKpSJPFW1z0OIkZF6kGUvawuKLRTmrR4c9F
         JnIvdJ8ZZ2tosOjJBCEQdb0d5hu0C+9eJS7hrK3n1bafevOABiyteWNqEmflKeY8hjOO
         ++uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681368880; x=1683960880;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nc4lL7JxaxGf+XYCkFM159Jes+f3X5bXuBPCU38sK1A=;
        b=jOKgIYMFj/dWRpmnf8Dd6AuQYsyuJy+b8O9wuDg8QKHhIXtxGBzK/FHxJLie5NL/UG
         8fT5vYg4Qc38xgR02zfJhtzgbXySHHhwwvCKmLiHCOMgif6HrATX6yHnIl5kBZICBMXw
         yAEMBEbW1iAkBv59veoTHcwSpX0PP8df7QKHhKuHXqJ9eaCcNm5UPfZFCRsHtiBTsUME
         yFdQ7/ctCE0f7c8PjzKEJJDTraQaZVhcZ7jHJbnrC/49MUKqhSo5wBJWWkdNBmsZqTjZ
         x2zOkMi2Z8LE6be0Cp0RedxbQbMq19m9Y8vClA9AUP1A69U1jaglHd9Yz7jUwsV2CCMC
         hkog==
X-Gm-Message-State: AAQBX9d3cnCduGL9pixpx6fp3hvs3WCwlUE/w3tDUyhkaeh3FeAEWFJP
        6p5EuywAD19J+lOIf2B1es6cNc0hLP1vF6ThXOf80Q==
X-Google-Smtp-Source: AKy350ZbBKjG6fi9EeOO5NV/GOSg+h3W9R10VGi1N1iYeqzIYEjsf1O8fdUlo8BjVvNdE8zxrMdbrPdWIcFQ3gf2lg0=
X-Received: by 2002:a81:4307:0:b0:545:f7cc:f30 with SMTP id
 q7-20020a814307000000b00545f7cc0f30mr755616ywa.0.1681368879779; Wed, 12 Apr
 2023 23:54:39 -0700 (PDT)
MIME-Version: 1.0
References: <20230407013118.466441-1-marex@denx.de>
In-Reply-To: <20230407013118.466441-1-marex@denx.de>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Thu, 13 Apr 2023 08:54:03 +0200
Message-ID: <CAPDyKFqMcNxUtJCtP09_APYX2Fefeqzs9-CmsSNVdzN=vPyChQ@mail.gmail.com>
Subject: Re: [PATCH] wifi: brcmfmac: add Cypress 43439 SDIO ids
To:     Marek Vasut <marex@denx.de>
Cc:     linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Arend van Spriel <aspriel@gmail.com>,
        Danny van Heumen <danny@dannyvanheumen.nl>,
        Eric Dumazet <edumazet@google.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Paul Cercueil <paul@crapouillou.net>,
        SHA-cyfmac-dev-list@infineon.com,
        brcm80211-dev-list.pdl@broadcom.com, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 Apr 2023 at 03:31, Marek Vasut <marex@denx.de> wrote:
>
> Add SDIO ids for use with the muRata 1YN (Cypress CYW43439).
> The odd thing about this is that the previous 1YN populated
> on M.2 card for evaluation purposes had BRCM SDIO vendor ID,
> while the chip populated on real hardware has a Cypress one.
> The device ID also differs between the two devices. But they
> are both 43439 otherwise, so add the IDs for both.
>
> ```
> /sys/.../mmc_host/mmc2/mmc2:0001 # cat vendor device
> 0x04b4
> 0xbd3d
> ```
>
> Fixes: be376df724aa3 ("wifi: brcmfmac: add 43439 SDIO ids and initialization")
> Signed-off-by: Marek Vasut <marex@denx.de>

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

Kind regards
Uffe

> ---
> NOTE: Please drop the Fixes tag if this is considered unjustified
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Arend van Spriel <aspriel@gmail.com>
> Cc: Danny van Heumen <danny@dannyvanheumen.nl>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Franky Lin <franky.lin@broadcom.com>
> Cc: Hans de Goede <hdegoede@redhat.com>
> Cc: Hante Meuleman <hante.meuleman@broadcom.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Paul Cercueil <paul@crapouillou.net>
> Cc: SHA-cyfmac-dev-list@infineon.com
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: brcm80211-dev-list.pdl@broadcom.com
> Cc: linux-mmc@vger.kernel.org
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> ---
>  .../net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c    | 9 ++++++++-
>  include/linux/mmc/sdio_ids.h                             | 5 ++++-
>  2 files changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> index 65d4799a56584..ff710b0b5071a 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> @@ -965,6 +965,12 @@ int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev)
>                 .driver_data = BRCMF_FWVENDOR_ ## fw_vend \
>         }
>
> +#define CYW_SDIO_DEVICE(dev_id, fw_vend) \
> +       { \
> +               SDIO_DEVICE(SDIO_VENDOR_ID_CYPRESS, dev_id), \
> +               .driver_data = BRCMF_FWVENDOR_ ## fw_vend \
> +       }
> +
>  /* devices we support, null terminated */
>  static const struct sdio_device_id brcmf_sdmmc_ids[] = {
>         BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43143, WCC),
> @@ -979,6 +985,7 @@ static const struct sdio_device_id brcmf_sdmmc_ids[] = {
>         BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4335_4339, WCC),
>         BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4339, WCC),
>         BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43430, WCC),
> +       BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43439, WCC),
>         BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4345, WCC),
>         BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43455, WCC),
>         BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4354, WCC),
> @@ -986,9 +993,9 @@ static const struct sdio_device_id brcmf_sdmmc_ids[] = {
>         BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4359, WCC),
>         BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_CYPRESS_4373, CYW),
>         BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_CYPRESS_43012, CYW),
> -       BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_CYPRESS_43439, CYW),
>         BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_CYPRESS_43752, CYW),
>         BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_CYPRESS_89359, CYW),
> +       CYW_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_CYPRESS_43439, CYW),
>         { /* end: all zeroes */ }
>  };
>  MODULE_DEVICE_TABLE(sdio, brcmf_sdmmc_ids);
> diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
> index 0e4ef9c5127ad..bf3c95d8eb8af 100644
> --- a/include/linux/mmc/sdio_ids.h
> +++ b/include/linux/mmc/sdio_ids.h
> @@ -74,10 +74,13 @@
>  #define SDIO_DEVICE_ID_BROADCOM_43362          0xa962
>  #define SDIO_DEVICE_ID_BROADCOM_43364          0xa9a4
>  #define SDIO_DEVICE_ID_BROADCOM_43430          0xa9a6
> -#define SDIO_DEVICE_ID_BROADCOM_CYPRESS_43439  0xa9af
> +#define SDIO_DEVICE_ID_BROADCOM_43439          0xa9af
>  #define SDIO_DEVICE_ID_BROADCOM_43455          0xa9bf
>  #define SDIO_DEVICE_ID_BROADCOM_CYPRESS_43752  0xaae8
>
> +#define SDIO_VENDOR_ID_CYPRESS                 0x04b4
> +#define SDIO_DEVICE_ID_BROADCOM_CYPRESS_43439  0xbd3d
> +
>  #define SDIO_VENDOR_ID_MARVELL                 0x02df
>  #define SDIO_DEVICE_ID_MARVELL_LIBERTAS                0x9103
>  #define SDIO_DEVICE_ID_MARVELL_8688_WLAN       0x9104
> --
> 2.39.2
>
