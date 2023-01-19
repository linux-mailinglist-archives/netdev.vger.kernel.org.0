Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11B7D673DCC
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 16:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbjASPpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 10:45:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbjASPpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 10:45:21 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 262AE82994;
        Thu, 19 Jan 2023 07:45:20 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id m15so1864870wms.4;
        Thu, 19 Jan 2023 07:45:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GfhmevInoPPdsSoVZPqElTk+vDakj/bGy9OM7KK4vFY=;
        b=E39rqQLwK3D6p9YdlVICJk0GrWViLGDbe8QPTtiyi5bK7skh7XXwomMhDmz2YTc+Kn
         1b17UO/hAT2o2J0+n7civf8tGxW37QRSucdB4iL7sal/oOpYj38VpgLApg8dkU26RO50
         D29XFuugKiDo9lfV1xUvC2kHB4BA4tVRIEYqWRuE2tvOBl5ThXJHWpLTyBXJwuWCY3vR
         mPZp72eWTihxlvP6KMF1WJOvpK9Wn0Vvnow7rBuaV9krk/zYtnBGr4Nsrj/QTzw7ht42
         p6mpkmKgovc19xcHi3RyekLGQp27YS28uyVu+j4BeezttRx0yTZU2upLVBxaEdxdcdDV
         qFhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GfhmevInoPPdsSoVZPqElTk+vDakj/bGy9OM7KK4vFY=;
        b=vWaTzeEjmPB5Ex3w6XVuOnI9o5Dy2hK/0QP9uj5AoXi7XPzvEBGcFHokggkNV9AwBa
         jAdAWY2xxcwMxJXA4sYrSbFLv/dfcJjv7T9T3DNCScjh+4FyRRBQYdW6v+y2tbcYxhgm
         ZlazJkCHZ2bYgW6qQWexoSL199l6crxALVKnmx8B7paPNtZJnaHoB+efDzHqp4j20gO3
         5CKjXQ2YTBgEWZ/oql+2gXQ6KomNf3RD6xHVBuNsOtzh1yzykR+10tU6hgy1QbZNCJ8w
         BPOdO2tK/UoRixzEpdU/eaZ9Q/Ey9E9pNQYrKukaNd810AEqUaddAl1GeuqcwHQcN7yq
         2WXA==
X-Gm-Message-State: AFqh2krIpYswdgz7V0dCrVxDzycvgczzfiEUAaN9dRjmTu/joHGxmzXR
        VM0n+nfjNvuW0pOSiGTfrzs=
X-Google-Smtp-Source: AMrXdXvYahyzuUZHHFOfs/uH7guP8gAL3PjmhvYeGyd2NmpPUP+fg/l/r7nvSswL/FpxUOYikB7ozA==
X-Received: by 2002:a05:600c:4395:b0:3c6:f7ff:6f87 with SMTP id e21-20020a05600c439500b003c6f7ff6f87mr10429463wmn.11.1674143118589;
        Thu, 19 Jan 2023 07:45:18 -0800 (PST)
Received: from [192.168.2.177] ([207.188.167.132])
        by smtp.gmail.com with ESMTPSA id o16-20020a05600c379000b003db15b1fb3csm4640551wmr.13.2023.01.19.07.45.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jan 2023 07:45:18 -0800 (PST)
Message-ID: <350f9408-6379-655d-6d91-d125e888dba1@gmail.com>
Date:   Thu, 19 Jan 2023 16:45:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v5 15/19] clk: mediatek: Add MT8188 vppsys0 clock support
Content-Language: en-US
To:     "Garmin.Chang" <Garmin.Chang@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Project_Global_Chrome_Upstream_Group@mediatek.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-clk@vger.kernel.org, netdev@vger.kernel.org
References: <20230119124848.26364-1-Garmin.Chang@mediatek.com>
 <20230119124848.26364-16-Garmin.Chang@mediatek.com>
From:   Matthias Brugger <matthias.bgg@gmail.com>
In-Reply-To: <20230119124848.26364-16-Garmin.Chang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 19/01/2023 13:48, Garmin.Chang wrote:
> Add MT8188 vppsys0 clock controller which provides clock gate
> controller for Video Processor Pipe.
> 
> Signed-off-by: Garmin.Chang <Garmin.Chang@mediatek.com>

Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>

> ---
>   drivers/clk/mediatek/Makefile          |   3 +-
>   drivers/clk/mediatek/clk-mt8188-vpp0.c | 143 +++++++++++++++++++++++++
>   2 files changed, 145 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/clk/mediatek/clk-mt8188-vpp0.c
> 
> diff --git a/drivers/clk/mediatek/Makefile b/drivers/clk/mediatek/Makefile
> index 22a3840160fc..48deecc6b520 100644
> --- a/drivers/clk/mediatek/Makefile
> +++ b/drivers/clk/mediatek/Makefile
> @@ -87,7 +87,8 @@ obj-$(CONFIG_COMMON_CLK_MT8188) += clk-mt8188-apmixedsys.o clk-mt8188-topckgen.o
>   				   clk-mt8188-peri_ao.o clk-mt8188-infra_ao.o \
>   				   clk-mt8188-cam.o clk-mt8188-ccu.o clk-mt8188-img.o \
>   				   clk-mt8188-ipe.o clk-mt8188-mfg.o clk-mt8188-vdec.o \
> -				   clk-mt8188-vdo0.o clk-mt8188-vdo1.o clk-mt8188-venc.o
> +				   clk-mt8188-vdo0.o clk-mt8188-vdo1.o clk-mt8188-venc.o \
> +				   clk-mt8188-vpp0.o
>   obj-$(CONFIG_COMMON_CLK_MT8192) += clk-mt8192.o
>   obj-$(CONFIG_COMMON_CLK_MT8192_AUDSYS) += clk-mt8192-aud.o
>   obj-$(CONFIG_COMMON_CLK_MT8192_CAMSYS) += clk-mt8192-cam.o
> diff --git a/drivers/clk/mediatek/clk-mt8188-vpp0.c b/drivers/clk/mediatek/clk-mt8188-vpp0.c
> new file mode 100644
> index 000000000000..e7b46142d653
> --- /dev/null
> +++ b/drivers/clk/mediatek/clk-mt8188-vpp0.c
> @@ -0,0 +1,143 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +//
> +// Copyright (c) 2022 MediaTek Inc.
> +// Author: Garmin Chang <garmin.chang@mediatek.com>
> +
> +#include <linux/clk-provider.h>
> +#include <linux/platform_device.h>
> +#include <dt-bindings/clock/mediatek,mt8188-clk.h>
> +
> +#include "clk-gate.h"
> +#include "clk-mtk.h"
> +
> +static const struct mtk_gate_regs vpp0_0_cg_regs = {
> +	.set_ofs = 0x24,
> +	.clr_ofs = 0x28,
> +	.sta_ofs = 0x20,
> +};
> +
> +static const struct mtk_gate_regs vpp0_1_cg_regs = {
> +	.set_ofs = 0x30,
> +	.clr_ofs = 0x34,
> +	.sta_ofs = 0x2c,
> +};
> +
> +static const struct mtk_gate_regs vpp0_2_cg_regs = {
> +	.set_ofs = 0x3c,
> +	.clr_ofs = 0x40,
> +	.sta_ofs = 0x38,
> +};
> +
> +#define GATE_VPP0_0(_id, _name, _parent, _shift)			\
> +	GATE_MTK(_id, _name, _parent, &vpp0_0_cg_regs, _shift, &mtk_clk_gate_ops_setclr)
> +
> +#define GATE_VPP0_1(_id, _name, _parent, _shift)			\
> +	GATE_MTK(_id, _name, _parent, &vpp0_1_cg_regs, _shift, &mtk_clk_gate_ops_setclr)
> +
> +#define GATE_VPP0_2(_id, _name, _parent, _shift)			\
> +	GATE_MTK(_id, _name, _parent, &vpp0_2_cg_regs, _shift, &mtk_clk_gate_ops_setclr)
> +
> +static const struct mtk_gate vpp0_clks[] = {
> +	/* VPP0_0 */
> +	GATE_VPP0_0(CLK_VPP0_MDP_FG, "vpp0_mdp_fg", "top_vpp", 1),
> +	GATE_VPP0_0(CLK_VPP0_STITCH, "vpp0_stitch", "top_vpp", 2),
> +	GATE_VPP0_0(CLK_VPP0_PADDING, "vpp0_padding", "top_vpp", 7),
> +	GATE_VPP0_0(CLK_VPP0_MDP_TCC, "vpp0_mdp_tcc", "top_vpp", 8),
> +	GATE_VPP0_0(CLK_VPP0_WARP0_ASYNC_TX, "vpp0_warp0_async_tx", "top_vpp", 10),
> +	GATE_VPP0_0(CLK_VPP0_WARP1_ASYNC_TX, "vpp0_warp1_async_tx", "top_vpp", 11),
> +	GATE_VPP0_0(CLK_VPP0_MUTEX, "vpp0_mutex", "top_vpp", 13),
> +	GATE_VPP0_0(CLK_VPP02VPP1_RELAY, "vpp02vpp1_relay", "top_vpp", 14),
> +	GATE_VPP0_0(CLK_VPP0_VPP12VPP0_ASYNC, "vpp0_vpp12vpp0_async", "top_vpp", 15),
> +	GATE_VPP0_0(CLK_VPP0_MMSYSRAM_TOP, "vpp0_mmsysram_top", "top_vpp", 16),
> +	GATE_VPP0_0(CLK_VPP0_MDP_AAL, "vpp0_mdp_aal", "top_vpp", 17),
> +	GATE_VPP0_0(CLK_VPP0_MDP_RSZ, "vpp0_mdp_rsz", "top_vpp", 18),
> +	/* VPP0_1 */
> +	GATE_VPP0_1(CLK_VPP0_SMI_COMMON_MMSRAM, "vpp0_smi_common_mmsram", "top_vpp", 0),
> +	GATE_VPP0_1(CLK_VPP0_GALS_VDO0_LARB0_MMSRAM, "vpp0_gals_vdo0_larb0_mmsram", "top_vpp", 1),
> +	GATE_VPP0_1(CLK_VPP0_GALS_VDO0_LARB1_MMSRAM, "vpp0_gals_vdo0_larb1_mmsram", "top_vpp", 2),
> +	GATE_VPP0_1(CLK_VPP0_GALS_VENCSYS_MMSRAM, "vpp0_gals_vencsys_mmsram", "top_vpp", 3),
> +	GATE_VPP0_1(CLK_VPP0_GALS_VENCSYS_CORE1_MMSRAM,
> +		    "vpp0_gals_vencsys_core1_mmsram", "top_vpp", 4),
> +	GATE_VPP0_1(CLK_VPP0_GALS_INFRA_MMSRAM, "vpp0_gals_infra_mmsram", "top_vpp", 5),
> +	GATE_VPP0_1(CLK_VPP0_GALS_CAMSYS_MMSRAM, "vpp0_gals_camsys_mmsram", "top_vpp", 6),
> +	GATE_VPP0_1(CLK_VPP0_GALS_VPP1_LARB5_MMSRAM, "vpp0_gals_vpp1_larb5_mmsram", "top_vpp", 7),
> +	GATE_VPP0_1(CLK_VPP0_GALS_VPP1_LARB6_MMSRAM, "vpp0_gals_vpp1_larb6_mmsram", "top_vpp", 8),
> +	GATE_VPP0_1(CLK_VPP0_SMI_REORDER_MMSRAM, "vpp0_smi_reorder_mmsram", "top_vpp", 9),
> +	GATE_VPP0_1(CLK_VPP0_SMI_IOMMU, "vpp0_smi_iommu", "top_vpp", 10),
> +	GATE_VPP0_1(CLK_VPP0_GALS_IMGSYS_CAMSYS, "vpp0_gals_imgsys_camsys", "top_vpp", 11),
> +	GATE_VPP0_1(CLK_VPP0_MDP_RDMA, "vpp0_mdp_rdma", "top_vpp", 12),
> +	GATE_VPP0_1(CLK_VPP0_MDP_WROT, "vpp0_mdp_wrot", "top_vpp", 13),
> +	GATE_VPP0_1(CLK_VPP0_GALS_EMI0_EMI1, "vpp0_gals_emi0_emi1", "top_vpp", 16),
> +	GATE_VPP0_1(CLK_VPP0_SMI_SUB_COMMON_REORDER, "vpp0_smi_sub_common_reorder", "top_vpp", 17),
> +	GATE_VPP0_1(CLK_VPP0_SMI_RSI, "vpp0_smi_rsi", "top_vpp", 18),
> +	GATE_VPP0_1(CLK_VPP0_SMI_COMMON_LARB4, "vpp0_smi_common_larb4", "top_vpp", 19),
> +	GATE_VPP0_1(CLK_VPP0_GALS_VDEC_VDEC_CORE1, "vpp0_gals_vdec_vdec_core1", "top_vpp", 20),
> +	GATE_VPP0_1(CLK_VPP0_GALS_VPP1_WPESYS, "vpp0_gals_vpp1_wpesys", "top_vpp", 21),
> +	GATE_VPP0_1(CLK_VPP0_GALS_VDO0_VDO1_VENCSYS_CORE1,
> +		    "vpp0_gals_vdo0_vdo1_vencsys_core1", "top_vpp", 22),
> +	GATE_VPP0_1(CLK_VPP0_FAKE_ENG, "vpp0_fake_eng", "top_vpp", 23),
> +	GATE_VPP0_1(CLK_VPP0_MDP_HDR, "vpp0_mdp_hdr", "top_vpp", 24),
> +	GATE_VPP0_1(CLK_VPP0_MDP_TDSHP, "vpp0_mdp_tdshp", "top_vpp", 25),
> +	GATE_VPP0_1(CLK_VPP0_MDP_COLOR, "vpp0_mdp_color", "top_vpp", 26),
> +	GATE_VPP0_1(CLK_VPP0_MDP_OVL, "vpp0_mdp_ovl", "top_vpp", 27),
> +	GATE_VPP0_1(CLK_VPP0_DSIP_RDMA, "vpp0_dsip_rdma", "top_vpp", 28),
> +	GATE_VPP0_1(CLK_VPP0_DISP_WDMA, "vpp0_disp_wdma", "top_vpp", 29),
> +	GATE_VPP0_1(CLK_VPP0_MDP_HMS, "vpp0_mdp_hms", "top_vpp", 30),
> +	/* VPP0_2 */
> +	GATE_VPP0_2(CLK_VPP0_WARP0_RELAY, "vpp0_warp0_relay", "top_wpe_vpp", 0),
> +	GATE_VPP0_2(CLK_VPP0_WARP0_ASYNC, "vpp0_warp0_async", "top_wpe_vpp", 1),
> +	GATE_VPP0_2(CLK_VPP0_WARP1_RELAY, "vpp0_warp1_relay", "top_wpe_vpp", 2),
> +	GATE_VPP0_2(CLK_VPP0_WARP1_ASYNC, "vpp0_warp1_async", "top_wpe_vpp", 3),
> +};
> +
> +static int clk_mt8188_vpp0_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct device_node *node = dev->parent->of_node;
> +	struct clk_hw_onecell_data *clk_data;
> +	int r;
> +
> +	clk_data = mtk_alloc_clk_data(CLK_VPP0_NR_CLK);
> +	if (!clk_data)
> +		return -ENOMEM;
> +
> +	r = mtk_clk_register_gates(node, vpp0_clks, ARRAY_SIZE(vpp0_clks), clk_data);
> +	if (r)
> +		goto free_vpp0_data;
> +
> +	r = of_clk_add_hw_provider(node, of_clk_hw_onecell_get, clk_data);
> +	if (r)
> +		goto unregister_gates;
> +
> +	platform_set_drvdata(pdev, clk_data);
> +
> +	return r;
> +
> +unregister_gates:
> +	mtk_clk_unregister_gates(vpp0_clks, ARRAY_SIZE(vpp0_clks), clk_data);
> +free_vpp0_data:
> +	mtk_free_clk_data(clk_data);
> +	return r;
> +}
> +
> +static int clk_mt8188_vpp0_remove(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct device_node *node = dev->parent->of_node;
> +	struct clk_hw_onecell_data *clk_data = platform_get_drvdata(pdev);
> +
> +	of_clk_del_provider(node);
> +	mtk_clk_unregister_gates(vpp0_clks, ARRAY_SIZE(vpp0_clks), clk_data);
> +	mtk_free_clk_data(clk_data);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver clk_mt8188_vpp0_drv = {
> +	.probe = clk_mt8188_vpp0_probe,
> +	.remove = clk_mt8188_vpp0_remove,
> +	.driver = {
> +		.name = "clk-mt8188-vpp0",
> +	},
> +};
> +builtin_platform_driver(clk_mt8188_vpp0_drv);
