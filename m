Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0D043A4AF
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 22:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234690AbhJYU3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 16:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236160AbhJYU3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 16:29:30 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFF4C061233
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 13:26:57 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id g8so3719905edb.2
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 13:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kryo-se.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rtr9OwUa7jkMkBZzG7jOnPoeoZwSwwFeWYRqbtbwgSQ=;
        b=33pMN6HhC2a748U+UxsvFhxiUVoZwH/JtzV5DTY46+R/EHRFjDZncowkTvCXkWmEaw
         IKKayOjj252QaRwBEQhGNm6j/7WDY1VROUpuySiZsJTlbSH5QvQYo0ddUYKh6RPGpWoM
         arR+RVO6oMm9L3wZJKL8mD26x3GC6DI6Zh7s5qaAA6aJD/IVkRM38IwrH1PJu+KbmyXW
         DA1nKcRfUZtqRrm/kfjcprerwUqHavkSswOQy8HlWXDGKUQLeU9ut9zt1JySOo6T2CsM
         VfW4US+pn2H6/p/9kP7vrR+FNC0ii9qNO8yQJxcOYmLga5zptRbUITL9nEsUYvuuGyNl
         ZIWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rtr9OwUa7jkMkBZzG7jOnPoeoZwSwwFeWYRqbtbwgSQ=;
        b=FKcIqzS1BhrkVLRUj+6NGV06Yyiw1qQkCiCunVj805+TifpZZRhFxq5xYxO10Bbp8e
         t5hSlpNITBpKE3oR6XgFzQLY+CZBH7XrX5XFcvvCCF4IbxABEQ9RQoiOUrgSTnNhrpaF
         BHb2SmfqLA+Ew++dH033EkTRuIgsdPbMl3Pf5b25w17IZeo6+uLztNAn3TpN1EgZhRr5
         BR0WpfU3mnc0aaobcxRDhwiqBSf6GIN7Qcg3FZ3SNj2QM34jTEu4iqAtn48MtthGHpCb
         kaakF4iUc0gr3QfLAXiHGwenaX/z07SMZgFBVf8LAvPYl+t/fKTDUFS6C6LX7WAODhWw
         XRUA==
X-Gm-Message-State: AOAM531H3vTVOBnpGjytMIYclFoDnkQtSlUN6KGjRzZ+zr0vsXHZTrLI
        uXF0OcOOlN+vqg13mQuqL+oj+mcFe/ZdXlAjMzLBAw==
X-Google-Smtp-Source: ABdhPJzY3fziBMfyeS/hxRFuJ6b9UHR0j+AhP+61NZ1Cu2HtoXSWiyu/aepPq5ba0DwIgIPYUa75LcLA477ZZ12v4/I=
X-Received: by 2002:aa7:de12:: with SMTP id h18mr17539631edv.109.1635193616287;
 Mon, 25 Oct 2021 13:26:56 -0700 (PDT)
MIME-Version: 1.0
References: <20211019211333.19494-1-erik@kryo.se>
In-Reply-To: <20211019211333.19494-1-erik@kryo.se>
From:   Erik Ekman <erik@kryo.se>
Date:   Mon, 25 Oct 2021 22:26:45 +0200
Message-ID: <CAGgu=sA9HF03iQar9xa1LRnX8iK1_JYvYif4MD_BQDgb9U0mGQ@mail.gmail.com>
Subject: Re: [PATCH v2] sfc: Export fibre-specific supported link modes
To:     Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Oct 2021 at 23:13, Erik Ekman <erik@kryo.se> wrote:
>
> The 1/10GbaseT modes were set up for cards with SFP+ cages in
> 3497ed8c852a5 ("sfc: report supported link speeds on SFP connections").
> 10GbaseT was likely used since no 10G fibre mode existed.
>
> The missing fibre modes for 1/10G were added to ethtool.h in 5711a9822144
> ("net: ethtool: add support for 1000BaseX and missing 10G link modes")
> shortly thereafter.
>
> The user guide available at https://support-nic.xilinx.com/wp/drivers
> lists support for the following cable and transceiver types in section 2.=
9:
> - QSFP28 100G Direct Attach Cables
> - QSFP28 100G SR Optical Transceivers (with SR4 modules listed)
> - SFP28 25G Direct Attach Cables
> - SFP28 25G SR Optical Transceivers
> - QSFP+ 40G Direct Attach Cables
> - QSFP+ 40G Active Optical Cables
> - QSFP+ 40G SR4 Optical Transceivers
> - QSFP+ to SFP+ Breakout Direct Attach Cables
> - QSFP+ to SFP+ Breakout Active Optical Cables
> - SFP+ 10G Direct Attach Cables
> - SFP+ 10G SR Optical Transceivers
> - SFP+ 10G LR Optical Transceivers
> - SFP 1000BASE=E2=80=90T Transceivers
> - 1G Optical Transceivers
> (From user guide issue 28. Issue 16 which also includes older cards like
> SFN5xxx/SFN6xxx has matching lists for 1/10/40G transceiver types.)
>
> Regarding SFP+ 10GBASE=E2=80=90T transceivers the latest guide says:
> "Solarflare adapters do not support 10GBASE=E2=80=90T transceiver modules=
."
>
> Tested using SFN5122F-R7 (with 2 SFP+ ports). Supported link modes do not=
 change
> depending on module used (tested with 1000BASE-T, 1000BASE-BX10, 10GBASE-=
LR).
> Before:
>
> $ ethtool ext
> Settings for ext:
>         Supported ports: [ FIBRE ]
>         Supported link modes:   1000baseT/Full
>                                 10000baseT/Full
>         Supported pause frame use: Symmetric Receive-only
>         Supports auto-negotiation: No
>         Supported FEC modes: Not reported
>         Advertised link modes:  Not reported
>         Advertised pause frame use: No
>         Advertised auto-negotiation: No
>         Advertised FEC modes: Not reported
>         Link partner advertised link modes:  Not reported
>         Link partner advertised pause frame use: No
>         Link partner advertised auto-negotiation: No
>         Link partner advertised FEC modes: Not reported
>         Speed: 1000Mb/s
>         Duplex: Full
>         Auto-negotiation: off
>         Port: FIBRE
>         PHYAD: 255
>         Transceiver: internal
>         Current message level: 0x000020f7 (8439)
>                                drv probe link ifdown ifup rx_err tx_err h=
w
>         Link detected: yes
>
> After:
>
> $ ethtool ext
> Settings for ext:
>         Supported ports: [ FIBRE ]
>         Supported link modes:   1000baseT/Full
>                                 1000baseX/Full
>                                 10000baseCR/Full
>                                 10000baseSR/Full
>                                 10000baseLR/Full
>         Supported pause frame use: Symmetric Receive-only
>         Supports auto-negotiation: No
>         Supported FEC modes: Not reported
>         Advertised link modes:  Not reported
>         Advertised pause frame use: No
>         Advertised auto-negotiation: No
>         Advertised FEC modes: Not reported
>         Link partner advertised link modes:  Not reported
>         Link partner advertised pause frame use: No
>         Link partner advertised auto-negotiation: No
>         Link partner advertised FEC modes: Not reported
>         Speed: 1000Mb/s
>         Duplex: Full
>         Auto-negotiation: off
>         Port: FIBRE
>         PHYAD: 255
>         Transceiver: internal
>         Supports Wake-on: g
>         Wake-on: d
>         Current message level: 0x000020f7 (8439)
>                                drv probe link ifdown ifup rx_err tx_err h=
w
>         Link detected: yes
>
> Signed-off-by: Erik Ekman <erik@kryo.se>
> ---

Sorry, this patch is on top of net-next 041c61488236a5a8 ("sfc: Fix
reading non-legacy supported link modes").
I expected this one to go to net-next only as well - I should have
been clearer about that.

/Erik

>  drivers/net/ethernet/sfc/mcdi_port_common.c | 37 +++++++++++++++------
>  1 file changed, 26 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/ethernet/sfc/mcdi_port_common.c b/drivers/net/et=
hernet/sfc/mcdi_port_common.c
> index 4bd3ef8f3384..c4fe3c48ac46 100644
> --- a/drivers/net/ethernet/sfc/mcdi_port_common.c
> +++ b/drivers/net/ethernet/sfc/mcdi_port_common.c
> @@ -132,16 +132,27 @@ void mcdi_to_ethtool_linkset(u32 media, u32 cap, un=
signed long *linkset)
>         case MC_CMD_MEDIA_SFP_PLUS:
>         case MC_CMD_MEDIA_QSFP_PLUS:
>                 SET_BIT(FIBRE);
> -               if (cap & (1 << MC_CMD_PHY_CAP_1000FDX_LBN))
> +               if (cap & (1 << MC_CMD_PHY_CAP_1000FDX_LBN)) {
>                         SET_BIT(1000baseT_Full);
> -               if (cap & (1 << MC_CMD_PHY_CAP_10000FDX_LBN))
> -                       SET_BIT(10000baseT_Full);
> -               if (cap & (1 << MC_CMD_PHY_CAP_40000FDX_LBN))
> +                       SET_BIT(1000baseX_Full);
> +               }
> +               if (cap & (1 << MC_CMD_PHY_CAP_10000FDX_LBN)) {
> +                       SET_BIT(10000baseCR_Full);
> +                       SET_BIT(10000baseLR_Full);
> +                       SET_BIT(10000baseSR_Full);
> +               }
> +               if (cap & (1 << MC_CMD_PHY_CAP_40000FDX_LBN)) {
>                         SET_BIT(40000baseCR4_Full);
> -               if (cap & (1 << MC_CMD_PHY_CAP_100000FDX_LBN))
> +                       SET_BIT(40000baseSR4_Full);
> +               }
> +               if (cap & (1 << MC_CMD_PHY_CAP_100000FDX_LBN)) {
>                         SET_BIT(100000baseCR4_Full);
> -               if (cap & (1 << MC_CMD_PHY_CAP_25000FDX_LBN))
> +                       SET_BIT(100000baseSR4_Full);
> +               }
> +               if (cap & (1 << MC_CMD_PHY_CAP_25000FDX_LBN)) {
>                         SET_BIT(25000baseCR_Full);
> +                       SET_BIT(25000baseSR_Full);
> +               }
>                 if (cap & (1 << MC_CMD_PHY_CAP_50000FDX_LBN))
>                         SET_BIT(50000baseCR2_Full);
>                 break;
> @@ -192,15 +203,19 @@ u32 ethtool_linkset_to_mcdi_cap(const unsigned long=
 *linkset)
>                 result |=3D (1 << MC_CMD_PHY_CAP_100FDX_LBN);
>         if (TEST_BIT(1000baseT_Half))
>                 result |=3D (1 << MC_CMD_PHY_CAP_1000HDX_LBN);
> -       if (TEST_BIT(1000baseT_Full) || TEST_BIT(1000baseKX_Full))
> +       if (TEST_BIT(1000baseT_Full) || TEST_BIT(1000baseKX_Full) ||
> +                       TEST_BIT(1000baseX_Full))
>                 result |=3D (1 << MC_CMD_PHY_CAP_1000FDX_LBN);
> -       if (TEST_BIT(10000baseT_Full) || TEST_BIT(10000baseKX4_Full))
> +       if (TEST_BIT(10000baseT_Full) || TEST_BIT(10000baseKX4_Full) ||
> +                       TEST_BIT(10000baseCR_Full) || TEST_BIT(10000baseL=
R_Full) ||
> +                       TEST_BIT(10000baseSR_Full))
>                 result |=3D (1 << MC_CMD_PHY_CAP_10000FDX_LBN);
> -       if (TEST_BIT(40000baseCR4_Full) || TEST_BIT(40000baseKR4_Full))
> +       if (TEST_BIT(40000baseCR4_Full) || TEST_BIT(40000baseKR4_Full) ||
> +                       TEST_BIT(40000baseSR4_Full))
>                 result |=3D (1 << MC_CMD_PHY_CAP_40000FDX_LBN);
> -       if (TEST_BIT(100000baseCR4_Full))
> +       if (TEST_BIT(100000baseCR4_Full) || TEST_BIT(100000baseSR4_Full))
>                 result |=3D (1 << MC_CMD_PHY_CAP_100000FDX_LBN);
> -       if (TEST_BIT(25000baseCR_Full))
> +       if (TEST_BIT(25000baseCR_Full) || TEST_BIT(25000baseSR_Full))
>                 result |=3D (1 << MC_CMD_PHY_CAP_25000FDX_LBN);
>         if (TEST_BIT(50000baseCR2_Full))
>                 result |=3D (1 << MC_CMD_PHY_CAP_50000FDX_LBN);
> --
> 2.31.1
>
