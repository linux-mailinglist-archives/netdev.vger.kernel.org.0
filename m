Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBF048BB7F
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 00:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346860AbiAKXhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 18:37:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233873AbiAKXhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 18:37:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC56AC06173F;
        Tue, 11 Jan 2022 15:37:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49C1A615DA;
        Tue, 11 Jan 2022 23:37:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4DEC36AF9;
        Tue, 11 Jan 2022 23:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641944228;
        bh=v20NyJnnrpRCSXRNC/bxgBQIPv65XMpppqdhmj/Hzvs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=s9qNkpwcKPVuanI5Kw+TTgMfk7JJRYxrLKhky2VaBe7JNusoldsDzVbrjJtz5IJls
         Dsap4Rdhc6KW5naVyUP3cl1e1mVMROZxwCoexpiuLfl8u40GZbm3ya0Yw9twDUA7CB
         8CkqCDJpa1VfiCFRLF3GovLW4tn4VdSbg+3mJTu/JPKY8eqLzxK4cO6GbhCwzoZ5pu
         ybvTJ1zkHXn24U3x7EsUMl44HQiT6Nxp9pIRjH15EP6d6GaRUU4QitjRXpw30E+v6Z
         /0XUi3/R0tE6lQvSGunHAc+KbF7DcXE9z9iWN3n3WPB+8oYnVy4gwT7gt7heV3QF15
         MvdeUZUFYqkAQ==
Received: by mail-ed1-f43.google.com with SMTP id 30so2735491edv.3;
        Tue, 11 Jan 2022 15:37:08 -0800 (PST)
X-Gm-Message-State: AOAM531Z/09Wy6LucirRNd3hU+TMoXyXH8YI9q+HwceU+zF07JgQe3sc
        UB2HaVjQr0M4bt7qd+nG8Hjb8INSBhnNBi3Fng==
X-Google-Smtp-Source: ABdhPJw710G1pZDb3HvgWDjTL63fkfcrpRHCZFpw//6sxrytQyY8zszFTXytk0jVWFHu0ZF1BEoxLUB6BT1sM9dzczw=
X-Received: by 2002:a17:906:d184:: with SMTP id c4mr5387166ejz.20.1641944226855;
 Tue, 11 Jan 2022 15:37:06 -0800 (PST)
MIME-Version: 1.0
References: <20211216055328.15953-1-biao.huang@mediatek.com>
 <20211216055328.15953-7-biao.huang@mediatek.com> <1639662782.987227.4004875.nullmailer@robh.at.kernel.org>
 <be023f9d2fb2a8f947bd0075e8732ba07cfd7b89.camel@mediatek.com>
In-Reply-To: <be023f9d2fb2a8f947bd0075e8732ba07cfd7b89.camel@mediatek.com>
From:   Rob Herring <robh@kernel.org>
Date:   Tue, 11 Jan 2022 17:36:55 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLo7z-KWtwFx+Kng2aQuCpQwJaO6mHnyBzmCKCJDK5n+Q@mail.gmail.com>
Message-ID: <CAL_JsqLo7z-KWtwFx+Kng2aQuCpQwJaO6mHnyBzmCKCJDK5n+Q@mail.gmail.com>
Subject: Re: [PATCH net-next v10 6/6] net: dt-bindings: dwmac: add support for mt8195
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     srv_heupstream <srv_heupstream@mediatek.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        David Miller <davem@davemloft.net>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        netdev <netdev@vger.kernel.org>, dkirjanov@suse.de,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        devicetree@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 8:06 PM Biao Huang <biao.huang@mediatek.com> wrote:
>
> Dear Rob,
>   Thanks for your comments~
>
>   For mt8195, the eth device node will look like:
>   eth: ethernet@11021000 {
>     compatible = "mediatek,mt8195-gmac", "snps,dwmac-5.10a";
>     ...
>     clock-names = "axi",
>                   "apb",
>                   "mac_cg",
>                   "mac_main",
>                   "ptp_ref",
>                   "rmii_internal";
>     clocks = <&pericfg_ao CLK_PERI_AO_ETHERNET>,
>              <&pericfg_ao CLK_PERI_AO_ETHERNET_BUS>,
>              <&pericfg_ao CLK_PERI_AO_ETHERNET_MAC>,
>              <&topckgen CLK_TOP_SNPS_ETH_250M>,
>              <&topckgen CLK_TOP_SNPS_ETH_62P4M_PTP>,
>              <&topckgen CLK_TOP_SNPS_ETH_50M_RMII>;
>     ...
>   }
>
> 1. "rmii_internal" is a special clock only required for
>    RMII phy interface, dwmac-mediatek.c will enable clocks
>    invoking clk_bulk_prepare_enable(xx, 6) for RMII,
>    and clk_bulk_prepare_enable(xx, 5) for other phy interfaces.
>    so, mt2712/mt8195 all put "rmii_internal" clock to the
>    end of clock list to simplify clock handling.
>
>    If I put mac_cg as described above, a if condition is required
> for clocks description in dt-binding, just like what I do in v7 send:
>   - if:
>       properties:
>         compatible:
>           contains:
>             enum:
>               - mediatek,mt2712-gmac
>
>     then:
>       properties:
>         clocks:
>           minItems: 5
>           items:
>             - description: AXI clock
>             - description: APB clock
>             - description: MAC Main clock
>             - description: PTP clock
>             - description: RMII reference clock provided by MAC
>
>         clock-names:
>           minItems: 5
>           items:
>             - const: axi
>             - const: apb
>             - const: mac_main
>             - const: ptp_ref
>             - const: rmii_internal
>
>   - if:
>       properties:
>         compatible:
>           contains:
>             enum:
>               - mediatek,mt8195-gmac
>
>     then:
>       properties:
>         clocks:
>           minItems: 6
>           items:
>             - description: AXI clock
>             - description: APB clock
>             - description: MAC clock gate
>             - description: MAC Main clock
>             - description: PTP clock
>             - description: RMII reference clock provided by MAC
>
>    This introduces some duplicated description.
>
> 2. If I put "mac_cg" to the end of clock list,
>    the dt-binding file can be simple just like
>    what we do in this v10 patch(need fix warnings reported by "make
> DT_CHECKER_FLAGS=-m dt_binding_check").
>
>    But for mt8195:
>      the eth node in dts should be modified,

I hope you are defining the binding before you use it... That's not
good practice and not a valid argument.

>      and eth driver clock handling will be complex;

How so?

Rob
