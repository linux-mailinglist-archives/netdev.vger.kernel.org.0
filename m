Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3572CC986
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 23:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbgLBWWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 17:22:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbgLBWWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 17:22:30 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A04C0613D6;
        Wed,  2 Dec 2020 14:21:44 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id m19so398689ejj.11;
        Wed, 02 Dec 2020 14:21:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kxoMo42hDjIYyv/FUmu+6jyKT744GP0kdnUpdiixu/g=;
        b=dUhOuEgBor5X2YaveP8kGwNHZafKvNPiltPqjK+qYLsVechlZ02TOWJF+8RviUyFVB
         9IIN0Q6uRVtf2QosEFjP9Q5WO+XXjNnk7JHJn7Zd+KQYeUAVxXzCvHaoCbTnNf7AfVMZ
         1GJ9M3CrECJUUG7LpqDv01jlJLzxAl91rCRyvO1zk6ZnqgTl7m97mThs1VNJRKR4oG8d
         fJxJ7xTqxFeO87bxmJdK3ixbynstjpGWgYREgGc5e2Y2nusUvBztoZlMpR3tW65ecn4s
         RxEtNWxx0do1qgaaoeVtGTl7LJlfvT5+t3vMzbGnBi5p0bw1+3PR+A3bbPtdif/MxMnV
         TK+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kxoMo42hDjIYyv/FUmu+6jyKT744GP0kdnUpdiixu/g=;
        b=iTsU3tixV/FLvXOD5tfNuj182/sGiNhwcVqRGjYrECU9qPkrC/YOGjHIjJvORE6q6G
         /AQ123EvFNKOJxtPt8fFSVChIXAW0aAjDeU7F7Y6SGpUmLLEGKAhH+1K5FA4tJ81aqn1
         hDRbBUYhepgZPUJ+iFLFF0OrnqhQJS85vXkfxTguyLmX4Y5KBxhvOyQpQK40COZrgF1U
         n/f+MBslBFCigBQ9p8egyzfXe7d/jrMGgCiiGM5jH+TxWzA5/WrgHM3VUepk406yhlYc
         9xm+iWku6bZ21lCcE836GIWhEvolLs8A/aRzq54A4/X8fN6Tor+jePz67oN7LZ72xQW0
         JlNQ==
X-Gm-Message-State: AOAM530B+5zSrufUZC1N6CbwG/4qzYKDuco3JQhd3QvCaNAp0txvhabV
        ARx9G1/0KDpmOyCymFnyjJA=
X-Google-Smtp-Source: ABdhPJzDq8gwam0d0E4QGuJRbfepG+OORXSmqRDTTd2sPN7drKTw2ks1K7iTbay61n/gakVi9Ey1bw==
X-Received: by 2002:a17:906:2e85:: with SMTP id o5mr1833932eji.521.1606947702760;
        Wed, 02 Dec 2020 14:21:42 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id s24sm2448ejb.20.2020.12.02.14.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 14:21:42 -0800 (PST)
Date:   Thu, 3 Dec 2020 00:21:40 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>,
        netdev@vger.kernel.org
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/4] Adding the Sparx5 Serdes driver
Message-ID: <20201202222140.wzdiypc2edviy57n@skbuf>
References: <20201202130438.3330228-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202130438.3330228-1-steen.hegelund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Steen,

On Wed, Dec 02, 2020 at 02:04:34PM +0100, Steen Hegelund wrote:
> Adding the Sparx5 Serdes driver
>
> This series of patches provides the serdes driver for the Microchip Sparx5
> ethernet switch.
>
> The serdes driver supports the 10G and 25G serdes instances available in the
> Sparx5.
>
> The Sparx5 serdes support several interface modes with several speeds and also
> allows the client to change the mode and the speed according to changing in the
> environment such as changing cables from DAC to fiber.
>
> The serdes driver is to be used by the Sparx5 switchdev driver that
> will follow in subsequent series.
>
> History:
> --------
> v6 -> v7:
>     This series changes the way the IO targets are provided to the driver.
>     Now only one IO range is available in the DT, and the driver has a table
>     to map its targets (as their order is still not sequential), thus reducing
>     the DT needed information and binding requirements.
>     The register access macros have been converted to functions.
>
>     - Bindings:
>       - reg prop: minItems set to 1
>       - reg-names prop: removed
>     - Driver
>       - Use one IO range and map targets via this.
>       - Change register access macros to use functions.
>       - Provided a new header files with reg access functions.
>     - Device tree
>       - Provide only one IO range
>
> v5 -> v6:
>      Series error: This had the same content as v5
>
> v4 -> v5:
>     - Bindings:
>       - Removed .yaml from compatible string
>       - reg prop: removed description and added minItems
>       - reg-names prop: removed description and added const name list and minItems
>       - #phy-cells prop: removed description and added maxItems
>     - Configuration interface
>       - Removed include of linux/phy.h
>       - Added include of linux/types.h
>     - Driver
>        - Added include of linux/phy.h
>
> v3 -> v4:
>     - Add a reg-names item to the binding description
>     - Add a clocks item to the binding description
>     - Removed the clock parameter from the configuration interface
>     - Use the clock dt node to get the coreclock, and using that when
>       doing the actual serdes configuration
>     - Added a clocks entry with a system clock reference to the serdes node in
>       the device tree
>
> v2 -> v3:
>     - Sorted the Kconfig sourced folders
>     - Sorted the Makefile included folders
>     - Changed the configuration interface documentation to use kernel style
>
> v1 -> v2: Fixed kernel test robot warnings
>     - Made these structures static:
>       - media_presets_25g
>       - mode_presets_25g
>       - media_presets_10g
>       - mode_presets_10g
>     - Removed these duplicate initializations:
>       - sparx5_sd25g28_params.cfg_rx_reserve_15_8
>       - sparx5_sd25g28_params.cfg_pi_en
>       - sparx5_sd25g28_params.cfg_cdrck_en
>       - sparx5_sd10g28_params.cfg_cdrck_en
>
> Lars Povlsen (2):
>   dt-bindings: phy: Add sparx5-serdes bindings
>   arm64: dts: sparx5: Add Sparx5 serdes driver node
>
> Steen Hegelund (2):
>   phy: Add ethernet serdes configuration option
>   phy: Add Sparx5 ethernet serdes PHY driver
>
>  .../bindings/phy/microchip,sparx5-serdes.yaml |  100 +
>  arch/arm64/boot/dts/microchip/sparx5.dtsi     |    8 +
>  drivers/phy/Kconfig                           |    3 +-
>  drivers/phy/Makefile                          |    1 +
>  drivers/phy/microchip/Kconfig                 |   12 +
>  drivers/phy/microchip/Makefile                |    6 +
>  drivers/phy/microchip/sparx5_serdes.c         | 2434 +++++++++++++++
>  drivers/phy/microchip/sparx5_serdes.h         |  129 +
>  drivers/phy/microchip/sparx5_serdes_regs.h    | 2695 +++++++++++++++++
>  include/linux/phy/phy-ethernet-serdes.h       |   30 +
>  include/linux/phy/phy.h                       |    4 +
>  11 files changed, 5421 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/phy/microchip,sparx5-serdes.yaml
>  create mode 100644 drivers/phy/microchip/Kconfig
>  create mode 100644 drivers/phy/microchip/Makefile
>  create mode 100644 drivers/phy/microchip/sparx5_serdes.c
>  create mode 100644 drivers/phy/microchip/sparx5_serdes.h
>  create mode 100644 drivers/phy/microchip/sparx5_serdes_regs.h
>  create mode 100644 include/linux/phy/phy-ethernet-serdes.h
>
> --
> 2.29.2

I think this series is interesting enough that you can at least cc the
networking mailing list when sending these? Did that for you now.
