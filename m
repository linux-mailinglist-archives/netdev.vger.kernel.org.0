Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB28435E92
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 12:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbhJUKHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 06:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbhJUKHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 06:07:43 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B649C06161C;
        Thu, 21 Oct 2021 03:05:27 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id e12so203150wra.4;
        Thu, 21 Oct 2021 03:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=tah8PDEbclsQOol1LU6jCoydc+LBYkt5+WcFgMuEGco=;
        b=Vd43G0EevL9Axeu4tTjQpvoqvWxqEl5iA3KmQ8dVma853RLgsiBV0RBzea9nk5szSC
         xlO1bodDlPo4ux1eYifEZpKK+/Dj28sfPbQIgDmlli2Ukhk+Cl5cdmgrAP/UxZDzqIkf
         XZlaI1Q7mw3b7QXQIGdv9pflfG/KNfrt2/03bYbxOjzQdPQ5M5wyBvCNEQpPgZ2Qai1J
         edvf5qT7n8gfeHlGW2VeVly1GG95htlGCgn52iZbNNfZidGkQ/07NoUIjIErApY90CPs
         AfrRPMOIc6gpEd+oMN4VW9dEUWHq559ayop1Wvc4wqoh4f2Zyh7lz2M0Uyqwe2T1EZC2
         6P8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=tah8PDEbclsQOol1LU6jCoydc+LBYkt5+WcFgMuEGco=;
        b=y7hBRrbbgxKFvdeCAGTaV7oPXcTkpxjH1VgQJaU9RywrsX3kKX2Kr1CeYqOZG8AZ//
         d6FF1ezIKFzIKYtQtut7hM8ViVpw/OY6VOfKggykkodTaVeWZCcmiykhJS6Ms7PjFq77
         9Vdo6jbzdQUM2alhxolqb8slDm4HTQX2ctGLNqPVt+3zRbAbRwwt+d9OYZxtjbIFFr4O
         0lUL3pthkNA2SR9eyMa19DPP3OuVuh3UgT9JwNrt4yHU1sQK6h2C16bgoksVEYivKLaz
         ZonR4L0/E3ziH9cFNhNTY7NxT39zE5oJogPqJI5mF4Zpa6nlYDHm4/v45kNospcl41PW
         5/tA==
X-Gm-Message-State: AOAM533vIY+aDgkYc3BB+PGS/hW59yItGIM9tdPhhVqeELifubfFqh1s
        9XtyKyUXETIxIAkyQntajWUSCoii6F4=
X-Google-Smtp-Source: ABdhPJxBV9t4mhIlwRqaHBdNJSgo5NV0aV9A58F7MotUkLTDMf6k7ebOAU1Nlkz7TAocmTUCuHkCqw==
X-Received: by 2002:a05:6000:1449:: with SMTP id v9mr5844584wrx.433.1634810726116;
        Thu, 21 Oct 2021 03:05:26 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id b9sm361485wrp.77.2021.10.21.03.05.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 21 Oct 2021 03:05:25 -0700 (PDT)
Date:   Thu, 21 Oct 2021 11:05:23 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Erik Ekman <erik@kryo.se>
Cc:     Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sfc: Export fibre-specific supported link modes
Message-ID: <20211021100523.4i6xntouyiuhcl3q@gmail.com>
Mail-Followup-To: Erik Ekman <erik@kryo.se>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211019211333.19494-1-erik@kryo.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211019211333.19494-1-erik@kryo.se>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 19, 2021 at 11:13:32PM +0200, Erik Ekman wrote:
> The 1/10GbaseT modes were set up for cards with SFP+ cages in
> 3497ed8c852a5 ("sfc: report supported link speeds on SFP connections").
> 10GbaseT was likely used since no 10G fibre mode existed.
> 
> The missing fibre modes for 1/10G were added to ethtool.h in 5711a9822144
> ("net: ethtool: add support for 1000BaseX and missing 10G link modes")
> shortly thereafter.
> 
> The user guide available at https://support-nic.xilinx.com/wp/drivers
> lists support for the following cable and transceiver types in section 2.9:
> - QSFP28 100G Direct Attach Cables
> - QSFP28 100G SR Optical Transceivers (with SR4 modules listed)
> - SFP28 25G Direct Attach Cables
> - SFP28 25G SR Optical Transceivers
> - QSFP+ 40G Direct Attach Cables
> - QSFP+ 40G Active Optical Cables
> - QSFP+ 40G SR4 Optical Transceivers
> - QSFP+ to SFP+ Breakout Direct Attach Cables
> - QSFP+ to SFP+ Breakout Active Optical Cables
> - SFP+ 10G Direct Attach Cables
> - SFP+ 10G SR Optical Transceivers
> - SFP+ 10G LR Optical Transceivers
> - SFP 1000BASE‐T Transceivers
> - 1G Optical Transceivers
> (From user guide issue 28. Issue 16 which also includes older cards like
> SFN5xxx/SFN6xxx has matching lists for 1/10/40G transceiver types.)
> 
> Regarding SFP+ 10GBASE‐T transceivers the latest guide says:
> "Solarflare adapters do not support 10GBASE‐T transceiver modules."

This is because all SFN5xxx/SFN6xxx NICs are end-of-life now. We no longer
sell them. Many of them are still finding a 2nd or 3rd life.

> Tested using SFN5122F-R7 (with 2 SFP+ ports). Supported link modes do not change
> depending on module used (tested with 1000BASE-T, 1000BASE-BX10, 10GBASE-LR).
> Before:
> 
> $ ethtool ext
> Settings for ext:
> 	Supported ports: [ FIBRE ]
> 	Supported link modes:   1000baseT/Full
> 	                        10000baseT/Full
> 	Supported pause frame use: Symmetric Receive-only
> 	Supports auto-negotiation: No
> 	Supported FEC modes: Not reported
> 	Advertised link modes:  Not reported
> 	Advertised pause frame use: No
> 	Advertised auto-negotiation: No
> 	Advertised FEC modes: Not reported
> 	Link partner advertised link modes:  Not reported
> 	Link partner advertised pause frame use: No
> 	Link partner advertised auto-negotiation: No
> 	Link partner advertised FEC modes: Not reported
> 	Speed: 1000Mb/s
> 	Duplex: Full
> 	Auto-negotiation: off
> 	Port: FIBRE
> 	PHYAD: 255
> 	Transceiver: internal
>         Current message level: 0x000020f7 (8439)
>                                drv probe link ifdown ifup rx_err tx_err hw
> 	Link detected: yes
> 
> After:
> 
> $ ethtool ext
> Settings for ext:
> 	Supported ports: [ FIBRE ]
> 	Supported link modes:   1000baseT/Full
> 	                        1000baseX/Full
> 	                        10000baseCR/Full
> 	                        10000baseSR/Full
> 	                        10000baseLR/Full
> 	Supported pause frame use: Symmetric Receive-only
> 	Supports auto-negotiation: No
> 	Supported FEC modes: Not reported
> 	Advertised link modes:  Not reported
> 	Advertised pause frame use: No
> 	Advertised auto-negotiation: No
> 	Advertised FEC modes: Not reported
> 	Link partner advertised link modes:  Not reported
> 	Link partner advertised pause frame use: No
> 	Link partner advertised auto-negotiation: No
> 	Link partner advertised FEC modes: Not reported
> 	Speed: 1000Mb/s
> 	Duplex: Full
> 	Auto-negotiation: off
> 	Port: FIBRE
> 	PHYAD: 255
> 	Transceiver: internal
> 	Supports Wake-on: g
> 	Wake-on: d
>         Current message level: 0x000020f7 (8439)
>                                drv probe link ifdown ifup rx_err tx_err hw
> 	Link detected: yes
> 
> Signed-off-by: Erik Ekman <erik@kryo.se>

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> ---
>  drivers/net/ethernet/sfc/mcdi_port_common.c | 37 +++++++++++++++------
>  1 file changed, 26 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/mcdi_port_common.c b/drivers/net/ethernet/sfc/mcdi_port_common.c
> index 4bd3ef8f3384..c4fe3c48ac46 100644
> --- a/drivers/net/ethernet/sfc/mcdi_port_common.c
> +++ b/drivers/net/ethernet/sfc/mcdi_port_common.c
> @@ -132,16 +132,27 @@ void mcdi_to_ethtool_linkset(u32 media, u32 cap, unsigned long *linkset)
>  	case MC_CMD_MEDIA_SFP_PLUS:
>  	case MC_CMD_MEDIA_QSFP_PLUS:
>  		SET_BIT(FIBRE);
> -		if (cap & (1 << MC_CMD_PHY_CAP_1000FDX_LBN))
> +		if (cap & (1 << MC_CMD_PHY_CAP_1000FDX_LBN)) {
>  			SET_BIT(1000baseT_Full);
> -		if (cap & (1 << MC_CMD_PHY_CAP_10000FDX_LBN))
> -			SET_BIT(10000baseT_Full);
> -		if (cap & (1 << MC_CMD_PHY_CAP_40000FDX_LBN))
> +			SET_BIT(1000baseX_Full);
> +		}
> +		if (cap & (1 << MC_CMD_PHY_CAP_10000FDX_LBN)) {
> +			SET_BIT(10000baseCR_Full);
> +			SET_BIT(10000baseLR_Full);
> +			SET_BIT(10000baseSR_Full);
> +		}
> +		if (cap & (1 << MC_CMD_PHY_CAP_40000FDX_LBN)) {
>  			SET_BIT(40000baseCR4_Full);
> -		if (cap & (1 << MC_CMD_PHY_CAP_100000FDX_LBN))
> +			SET_BIT(40000baseSR4_Full);
> +		}
> +		if (cap & (1 << MC_CMD_PHY_CAP_100000FDX_LBN)) {
>  			SET_BIT(100000baseCR4_Full);
> -		if (cap & (1 << MC_CMD_PHY_CAP_25000FDX_LBN))
> +			SET_BIT(100000baseSR4_Full);
> +		}
> +		if (cap & (1 << MC_CMD_PHY_CAP_25000FDX_LBN)) {
>  			SET_BIT(25000baseCR_Full);
> +			SET_BIT(25000baseSR_Full);
> +		}
>  		if (cap & (1 << MC_CMD_PHY_CAP_50000FDX_LBN))
>  			SET_BIT(50000baseCR2_Full);
>  		break;
> @@ -192,15 +203,19 @@ u32 ethtool_linkset_to_mcdi_cap(const unsigned long *linkset)
>  		result |= (1 << MC_CMD_PHY_CAP_100FDX_LBN);
>  	if (TEST_BIT(1000baseT_Half))
>  		result |= (1 << MC_CMD_PHY_CAP_1000HDX_LBN);
> -	if (TEST_BIT(1000baseT_Full) || TEST_BIT(1000baseKX_Full))
> +	if (TEST_BIT(1000baseT_Full) || TEST_BIT(1000baseKX_Full) ||
> +			TEST_BIT(1000baseX_Full))
>  		result |= (1 << MC_CMD_PHY_CAP_1000FDX_LBN);
> -	if (TEST_BIT(10000baseT_Full) || TEST_BIT(10000baseKX4_Full))
> +	if (TEST_BIT(10000baseT_Full) || TEST_BIT(10000baseKX4_Full) ||
> +			TEST_BIT(10000baseCR_Full) || TEST_BIT(10000baseLR_Full) ||
> +			TEST_BIT(10000baseSR_Full))
>  		result |= (1 << MC_CMD_PHY_CAP_10000FDX_LBN);
> -	if (TEST_BIT(40000baseCR4_Full) || TEST_BIT(40000baseKR4_Full))
> +	if (TEST_BIT(40000baseCR4_Full) || TEST_BIT(40000baseKR4_Full) ||
> +			TEST_BIT(40000baseSR4_Full))
>  		result |= (1 << MC_CMD_PHY_CAP_40000FDX_LBN);
> -	if (TEST_BIT(100000baseCR4_Full))
> +	if (TEST_BIT(100000baseCR4_Full) || TEST_BIT(100000baseSR4_Full))
>  		result |= (1 << MC_CMD_PHY_CAP_100000FDX_LBN);
> -	if (TEST_BIT(25000baseCR_Full))
> +	if (TEST_BIT(25000baseCR_Full) || TEST_BIT(25000baseSR_Full))
>  		result |= (1 << MC_CMD_PHY_CAP_25000FDX_LBN);
>  	if (TEST_BIT(50000baseCR2_Full))
>  		result |= (1 << MC_CMD_PHY_CAP_50000FDX_LBN);
> -- 
> 2.31.1
