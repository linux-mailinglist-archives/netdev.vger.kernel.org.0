Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8976B4F0039
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 11:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239924AbiDBJyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 05:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239868AbiDBJyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 05:54:24 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCBE4198974;
        Sat,  2 Apr 2022 02:52:32 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id t7so4046290qta.10;
        Sat, 02 Apr 2022 02:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rf+Z8BCmAsoqSh2imF0kTHHsFmoLp9md0M8PNzOORW0=;
        b=FpjP+yDw+rd8QIuPn3pAflciBU8szYdoU9YGdbrT3mDllMK2WthyTvaRMVJyXhWwf+
         NZwiHHwVcxGhm9/fc3iVPMB8CtrcqxkWDayKmli159Hi2vbE5Sp+iUAa56LzExqyFzZF
         fqQxgW51lj//KnlluAqJ4+b4rXSU8yW2d8H5Zm7U31dW435C8NQCmKGkDMHDlwsUUV3Y
         C5+qo4qACTYkiJXZ9BiJ4CeT9LkvkfD3isd1pc5xt1bbzjyUWFlpFOWMZsxxgkFmFCzZ
         Ny2uM5CDI3opmvKuHc+JCX88TYNEZnPHxYsdxQuGCC0bGaD/1ZFT/qzxmlKKzmH5yuHZ
         njnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rf+Z8BCmAsoqSh2imF0kTHHsFmoLp9md0M8PNzOORW0=;
        b=bUbQ/wggRrYIAt0F+B8LXwzQVNgf/nJieRfF6Rm+1cUkOQe/pFhTacsHDX3unTdDHv
         EyedNLZjJlM/0qU/D7xNxMZy9DAmHwerurtG0j2YpbC2xGAyBFxU+hRdN7kBg+iVYo33
         jZJKT4wdevJ3/oQNaO3olfB4kngwGp51Xh/X0f60GEJCgYjZbnCjH+INXv9klT4sD+Op
         LapunoLK0aAKXCCV+J++nTkZyUFUDzOhDjK6lnNlSn1hdtVT/WSaxft0Pmzoe1wkUJT2
         Hr4ck2NziWKtK56T0cpOveb8H9Sl+8cOU4XmjBSUdP9hgm+MY29N4S8cKmStCsAo1+9R
         cLmg==
X-Gm-Message-State: AOAM531BAaz9pcG7g2cXfYu+XdgRbbAqFm76HErXCd3l9hv0xbism4qq
        rSLHsoBLBrpi0h5GgTHSgRek5Bakf1OqaU2AsRX++eC2Fkk=
X-Google-Smtp-Source: ABdhPJzM3PO5vJI14orWCHqDgZL3GwaLuRPCeqgqlwej3gH0Wk3KtPQmkf0ZAisVJGYGwj4tfQH5Nz4ETHT/H2ITgIo=
X-Received: by 2002:a05:622a:4cd:b0:2e1:ec2f:8c22 with SMTP id
 q13-20020a05622a04cd00b002e1ec2f8c22mr11532022qtx.494.1648893152007; Sat, 02
 Apr 2022 02:52:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220401093554.360211-1-robimarko@gmail.com> <87ilrsuab4.fsf@kernel.org>
In-Reply-To: <87ilrsuab4.fsf@kernel.org>
From:   Robert Marko <robimarko@gmail.com>
Date:   Sat, 2 Apr 2022 11:52:21 +0200
Message-ID: <CAOX2RU4pCn8C-HhhuOzyikjk2Ax3VDcjMKh7N6X5HeMN4xLMEg@mail.gmail.com>
Subject: Re: [PATCH] ath11k: select QRTR for AHB as well
To:     Kalle Valo <kvalo@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 1 Apr 2022 at 16:51, Kalle Valo <kvalo@kernel.org> wrote:
>
> Robert Marko <robimarko@gmail.com> writes:
>
> > Currently, ath11k only selects QRTR if ath11k PCI is selected, however
> > AHB support requires QRTR, more precisely QRTR_SMD because it is using
> > QMI as well which in turn uses QRTR.
> >
> > Without QRTR_SMD AHB does not work, so select QRTR in ATH11K and then
> > select QRTR_SMD for ATH11K_AHB and QRTR_MHI for ATH11K_PCI.
> >
> > Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.5.0.1-01208-QCAHKSWPL_SILICONZ-1
> >
> > Signed-off-by: Robert Marko <robimarko@gmail.com>
> > ---
> >  drivers/net/wireless/ath/ath11k/Kconfig | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath11k/Kconfig b/drivers/net/wireless/ath/ath11k/Kconfig
> > index ad5cc6cac05b..b45baad184f6 100644
> > --- a/drivers/net/wireless/ath/ath11k/Kconfig
> > +++ b/drivers/net/wireless/ath/ath11k/Kconfig
> > @@ -5,6 +5,7 @@ config ATH11K
> >       depends on CRYPTO_MICHAEL_MIC
> >       select ATH_COMMON
> >       select QCOM_QMI_HELPERS
> > +     select QRTR
> >       help
> >         This module adds support for Qualcomm Technologies 802.11ax family of
> >         chipsets.
> > @@ -15,6 +16,7 @@ config ATH11K_AHB
> >       tristate "Atheros ath11k AHB support"
> >       depends on ATH11K
> >       depends on REMOTEPROC
> > +     select QRTR_SMD
> >       help
> >         This module adds support for AHB bus
> >
> > @@ -22,7 +24,6 @@ config ATH11K_PCI
> >       tristate "Atheros ath11k PCI support"
> >       depends on ATH11K && PCI
> >       select MHI_BUS
> > -     select QRTR
> >       select QRTR_MHI
> >       help
> >         This module adds support for PCIE bus
>
> I now see a new warning:
>
> WARNING: unmet direct dependencies detected for QRTR_SMD
>   Depends on [n]: NET [=y] && QRTR [=m] && (RPMSG [=n] || COMPILE_TEST [=n] && RPMSG [=n]=n)
>   Selected by [m]:
>   - ATH11K_AHB [=m] && NETDEVICES [=y] && WLAN [=y] && WLAN_VENDOR_ATH [=y] && ATH11K [=m] && REMOTEPROC [=y]

Ahh yeah, since it's SMD then it requires RPMGS which in turn requires
more stuff.
What do you think about making it depend on QRTR_SMD instead, because
without it AHB literally does not work?

Regards,
Robert
>
> --
> https://patchwork.kernel.org/project/linux-wireless/list/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
