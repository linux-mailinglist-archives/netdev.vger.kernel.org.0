Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60AF439E70
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 20:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233140AbhJYS1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 14:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbhJYS13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 14:27:29 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880E0C061220
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 11:25:05 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id y12so3525350eda.4
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 11:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kryo-se.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=a5QlcGbLUwoR2MnKfG4abvIGn8UPx/Lfcbl0Cd7jJvw=;
        b=v67Gi+20fe1gMeXVC7GoRQnSarW1kpfPJv5xdsK0DmeApaUYbVx4MOLpBqvxjuzMRk
         Gg1Pl2JGBeXg+o/vhllduaD0PUkrzpo8tRGpY+Avaon9GUE7vzXSiSmdccabyaKETArc
         /0Abog58+3y7BuEFfpqvhWKD3AAMp8oDthiKm3sXjQ6kRMGOHnUvYMevx4Cfnxsh/jHw
         o1C7scFlidZWAVr65kEljLIwjkA0sOL06Ztqv2iK7/ea0lqN/GqLSh5VcP9y9KnnlTbo
         YEa10W64TbMt3xnDATknphk5gaxnN9ERLh0SONfKalz72J/eXzT5k6CEe80t363DIEA2
         HLzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=a5QlcGbLUwoR2MnKfG4abvIGn8UPx/Lfcbl0Cd7jJvw=;
        b=X/+wgPLETV/wrHVEFOPmqqIdBBI6bLUa29APLNc/CMmlIXQATdYD3Hhak77BIlc6l4
         l8vnfRJqApGMjgpqlKxA3dv/glib9UcAW+Sge2KBaV8Ni7sIy4SKS7iuiGrH2aDj3HOg
         6+FL/ZbJ8NzuN+gT4Q3Mg265hHwlbj4UQl/ja9h7gBAqVBJGVR6yoTWpmYb+VKO2WT7c
         niRLNfMVTlSH8a3kdL38I0rrVyFKSLnZmdTE6LxZY5l0zFU5p2abU2FnnNu8SR9o86TE
         Eu9NbUjL+9q3lTwQijsowQ6DLKJLLFAjdlk7/vIw90c4sZvriGAUYTOdOZqyVC7+lnMd
         e0jA==
X-Gm-Message-State: AOAM533lZiGlxdfG2ZEAKAE86s4M0MYS5JLfUiSvzqlxrAVNLVolMfSs
        YDsux9IT6BbK+WLfW6K/ZxGwP6m2LxrUZ/o4iiosBA==
X-Google-Smtp-Source: ABdhPJzHAKi1xEMNbKB7FVEhP7Q5bMd9Az+tZ9zVeufwiLYtaTaqqAKhtS4P5Y6iijCC8mZa7YWevnXJUdQh10z/fAo=
X-Received: by 2002:a05:6402:643:: with SMTP id u3mr28816971edx.164.1635186303854;
 Mon, 25 Oct 2021 11:25:03 -0700 (PDT)
MIME-Version: 1.0
References: <20211025165939.1393655-1-sashal@kernel.org> <20211025165939.1393655-15-sashal@kernel.org>
In-Reply-To: <20211025165939.1393655-15-sashal@kernel.org>
From:   Erik Ekman <erik@kryo.se>
Date:   Mon, 25 Oct 2021 20:24:52 +0200
Message-ID: <CAGgu=sCeJNqWaTBUpOZNGeVo+OJp--3W8CP9gmbR9mknR8qN8w@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.14 15/18] sfc: Export fibre-specific supported
 link modes
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, ecree.xilinx@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This needs 041c61488236a5a8 ("sfc: Fix reading non-legacy supported
link modes") from net-next to work for 10G/25G/50G/100G.

Thanks/
Erik

On Mon, 25 Oct 2021 at 19:00, Sasha Levin <sashal@kernel.org> wrote:
>
> From: Erik Ekman <erik@kryo.se>
>
> [ Upstream commit c62041c5baa9ded3bc6fd38d3f724de70683b489 ]
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
> Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
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
> 2.33.0
>
