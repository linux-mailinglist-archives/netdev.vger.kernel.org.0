Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4DDA673DE9
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 16:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbjASPtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 10:49:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbjASPtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 10:49:07 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A258F88751;
        Thu, 19 Jan 2023 07:48:05 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id m15so1871889wms.4;
        Thu, 19 Jan 2023 07:48:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5BVr6mIazdcuHgC9Yw32j7h0b9MJPFiHJ/zEDO1CP/g=;
        b=Mx7NT9JjCyxSTQCNnr6td95iE8MljkCOsrHaXIh+E+e6xNRoeUpVlBOvqRB1OD1kNj
         6Drsc7NtWGj2bOR7+N48FFX7AxzHgkCgytZ0K7VeZfPDXQwZ95dUkPmoEh6+BhE9ZzWw
         bNTq3fpMddM7he9MvWGTAasSYMHTE5Sz4aLdOTqAH0b1X/MHAzIRnnyC5Y92AVkG8FVH
         SSHcttnGddR0a2H8dM9jRo/Zzf4WGK95ur4tCT5xZrK5pEi2Z30MbdFEMNBZW+4F4xr4
         rR2aTyzYVZFLHn7NfsdiLn7U1tyzuDtXdzN+we3CAcsdYbhwnkLhSjNJbvC8+9gp7POO
         5UOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5BVr6mIazdcuHgC9Yw32j7h0b9MJPFiHJ/zEDO1CP/g=;
        b=qjL/5Im5qrj/EMwnerBtKhwD93ku8lO+sNzVz2X0X9b3sX+dtk5SHB8Fz8uyC+r8U3
         ndZCJyL965qEh+x3J+x90d6TNaeNnL/36n92XUuYlJPwYp17NrcUsZxiddpj9dnKtPU2
         D/sKoI7xVfYiICMzIws4zHVuU4AdpmeCryV2NhHctCQvVqQd0qdxdQqrwe5NIqmIHaRf
         ebyfpyGYsr0FbrWvfaBnDPkzj75VsUFRfXn3/O2m1g3XWOH+eBo8pQ71cVG6C4UAFTIo
         iU8l5/kMxTs0fSzr/fvfpR0P6C5tQRNDm3qJWgpfL5sC1BflYuPQja/LP9UNb2awN074
         M97A==
X-Gm-Message-State: AFqh2ko9vs2p+KLbvLsdQBBbnJlyBcNJQ0B6w3D+8hwngaWcjF4c7Dhv
        qBzw0MjSnr5oQM8JaKX1GU0=
X-Google-Smtp-Source: AMrXdXtHjBkw5++5mVwss7z1lXJnfF+vj4w8+kT7WLPkt7UUlFzSpBC4Q/dcmvC2A//LcgxjzcMqew==
X-Received: by 2002:a05:600c:1d8e:b0:3d9:f9ef:3d23 with SMTP id p14-20020a05600c1d8e00b003d9f9ef3d23mr11067914wms.23.1674143282951;
        Thu, 19 Jan 2023 07:48:02 -0800 (PST)
Received: from [192.168.2.177] ([207.188.167.132])
        by smtp.gmail.com with ESMTPSA id c2-20020a05600c0a4200b003daf6e3bc2fsm7168674wmq.1.2023.01.19.07.48.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jan 2023 07:48:02 -0800 (PST)
Message-ID: <3a43e4ea-d8bc-fc80-6ae1-702539765e0e@gmail.com>
Date:   Thu, 19 Jan 2023 16:48:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v5 16/19] clk: mediatek: Add MT8188 vppsys1 clock support
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
 <20230119124848.26364-17-Garmin.Chang@mediatek.com>
From:   Matthias Brugger <matthias.bgg@gmail.com>
In-Reply-To: <20230119124848.26364-17-Garmin.Chang@mediatek.com>
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
> Add MT8188 vppsys1 clock controller which provides clock gate
> controller for Video Processor Pipe.
> 
> Signed-off-by: Garmin.Chang <Garmin.Chang@mediatek.com>

Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>

> ---
>   drivers/clk/mediatek/Makefile          |   2 +-
>   drivers/clk/mediatek/clk-mt8188-vpp1.c | 138 +++++++++++++++++++++++++
>   2 files changed, 139 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/clk/mediatek/clk-mt8188-vpp1.c
> 
> diff --git a/drivers/clk/mediatek/Makefile b/drivers/clk/mediatek/Makefile
> index 48deecc6b520..37663de293bf 100644
> --- a/drivers/clk/mediatek/Makefile
> +++ b/drivers/clk/mediatek/Makefile
> @@ -88,7 +88,7 @@ obj-$(CONFIG_COMMON_CLK_MT8188) += clk-mt8188-apmixedsys.o clk-mt8188-topckgen.o
>   				   clk-mt8188-cam.o clk-mt8188-ccu.o clk-mt8188-img.o \
>   				   clk-mt8188-ipe.o clk-mt8188-mfg.o clk-mt8188-vdec.o \
>   				   clk-mt8188-vdo0.o clk-mt8188-vdo1.o clk-mt8188-venc.o \
> -				   clk-mt8188-vpp0.o
> +				   clk-mt8188-vpp0.o clk-mt8188-vpp1.o
>   obj-$(CONFIG_COMMON_CLK_MT8192) += clk-mt8192.o
>   obj-$(CONFIG_COMMON_CLK_MT8192_AUDSYS) += clk-mt8192-aud.o
>   obj-$(CONFIG_COMMON_CLK_MT8192_CAMSYS) += clk-mt8192-cam.o
> diff --git a/drivers/clk/mediatek/clk-mt8188-vpp1.c b/drivers/clk/mediatek/clk-mt8188-vpp1.c
> new file mode 100644
> index 000000000000..2bff3a52c93f
> --- /dev/null
> +++ b/drivers/clk/mediatek/clk-mt8188-vpp1.c
> @@ -0,0 +1,138 @@
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
> +static const struct mtk_gate_regs vpp1_0_cg_regs = {
> +	.set_ofs = 0x104,
> +	.clr_ofs = 0x108,
> +	.sta_ofs = 0x100,
> +};
> +
> +static const struct mtk_gate_regs vpp1_1_cg_regs = {
> +	.set_ofs = 0x114,
> +	.clr_ofs = 0x118,
> +	.sta_ofs = 0x110,
> +};
> +
> +#define GATE_VPP1_0(_id, _name, _parent, _shift)			\
> +	GATE_MTK(_id, _name, _parent, &vpp1_0_cg_regs, _shift, &mtk_clk_gate_ops_setclr)
> +
> +#define GATE_VPP1_1(_id, _name, _parent, _shift)			\
> +	GATE_MTK(_id, _name, _parent, &vpp1_1_cg_regs, _shift, &mtk_clk_gate_ops_setclr)
> +
> +static const struct mtk_gate vpp1_clks[] = {
> +	/* VPP1_0 */
> +	GATE_VPP1_0(CLK_VPP1_SVPP1_MDP_OVL, "vpp1_svpp1_mdp_ovl", "top_vpp", 0),
> +	GATE_VPP1_0(CLK_VPP1_SVPP1_MDP_TCC, "vpp1_svpp1_mdp_tcc", "top_vpp", 1),
> +	GATE_VPP1_0(CLK_VPP1_SVPP1_MDP_WROT, "vpp1_svpp1_mdp_wrot", "top_vpp", 2),
> +	GATE_VPP1_0(CLK_VPP1_SVPP1_VPP_PAD, "vpp1_svpp1_vpp_pad", "top_vpp", 3),
> +	GATE_VPP1_0(CLK_VPP1_SVPP2_MDP_WROT, "vpp1_svpp2_mdp_wrot", "top_vpp", 4),
> +	GATE_VPP1_0(CLK_VPP1_SVPP2_VPP_PAD, "vpp1_svpp2_vpp_pad", "top_vpp", 5),
> +	GATE_VPP1_0(CLK_VPP1_SVPP3_MDP_WROT, "vpp1_svpp3_mdp_wrot", "top_vpp", 6),
> +	GATE_VPP1_0(CLK_VPP1_SVPP3_VPP_PAD, "vpp1_svpp3_vpp_pad", "top_vpp", 7),
> +	GATE_VPP1_0(CLK_VPP1_SVPP1_MDP_RDMA, "vpp1_svpp1_mdp_rdma", "top_vpp", 8),
> +	GATE_VPP1_0(CLK_VPP1_SVPP1_MDP_FG, "vpp1_svpp1_mdp_fg", "top_vpp", 9),
> +	GATE_VPP1_0(CLK_VPP1_SVPP2_MDP_RDMA, "vpp1_svpp2_mdp_rdma", "top_vpp", 10),
> +	GATE_VPP1_0(CLK_VPP1_SVPP2_MDP_FG, "vpp1_svpp2_mdp_fg", "top_vpp", 11),
> +	GATE_VPP1_0(CLK_VPP1_SVPP3_MDP_RDMA, "vpp1_svpp3_mdp_rdma", "top_vpp", 12),
> +	GATE_VPP1_0(CLK_VPP1_SVPP3_MDP_FG, "vpp1_svpp3_mdp_fg", "top_vpp", 13),
> +	GATE_VPP1_0(CLK_VPP1_VPP_SPLIT, "vpp1_vpp_split", "top_vpp", 14),
> +	GATE_VPP1_0(CLK_VPP1_SVPP2_VDO0_DL_RELAY, "vpp1_svpp2_vdo0_dl_relay", "top_vpp", 15),
> +	GATE_VPP1_0(CLK_VPP1_SVPP1_MDP_RSZ, "vpp1_svpp1_mdp_rsz", "top_vpp", 16),
> +	GATE_VPP1_0(CLK_VPP1_SVPP1_MDP_TDSHP, "vpp1_svpp1_mdp_tdshp", "top_vpp", 17),
> +	GATE_VPP1_0(CLK_VPP1_SVPP1_MDP_COLOR, "vpp1_svpp1_mdp_color", "top_vpp", 18),
> +	GATE_VPP1_0(CLK_VPP1_SVPP3_VDO1_DL_RELAY, "vpp1_svpp3_vdo1_dl_relay", "top_vpp", 19),
> +	GATE_VPP1_0(CLK_VPP1_SVPP2_MDP_RSZ, "vpp1_svpp2_mdp_rsz", "top_vpp", 20),
> +	GATE_VPP1_0(CLK_VPP1_SVPP2_VPP_MERGE, "vpp1_svpp2_vpp_merge", "top_vpp", 21),
> +	GATE_VPP1_0(CLK_VPP1_SVPP2_MDP_TDSHP, "vpp1_svpp2_mdp_tdshp", "top_vpp", 22),
> +	GATE_VPP1_0(CLK_VPP1_SVPP2_MDP_COLOR, "vpp1_svpp2_mdp_color", "top_vpp", 23),
> +	GATE_VPP1_0(CLK_VPP1_SVPP3_MDP_RSZ, "vpp1_svpp3_mdp_rsz", "top_vpp", 24),
> +	GATE_VPP1_0(CLK_VPP1_SVPP3_VPP_MERGE, "vpp1_svpp3_vpp_merge", "top_vpp", 25),
> +	GATE_VPP1_0(CLK_VPP1_SVPP3_MDP_TDSHP, "vpp1_svpp3_mdp_tdshp", "top_vpp", 26),
> +	GATE_VPP1_0(CLK_VPP1_SVPP3_MDP_COLOR, "vpp1_svpp3_mdp_color", "top_vpp", 27),
> +	GATE_VPP1_0(CLK_VPP1_GALS5, "vpp1_gals5", "top_vpp", 28),
> +	GATE_VPP1_0(CLK_VPP1_GALS6, "vpp1_gals6", "top_vpp", 29),
> +	GATE_VPP1_0(CLK_VPP1_LARB5, "vpp1_larb5", "top_vpp", 30),
> +	GATE_VPP1_0(CLK_VPP1_LARB6, "vpp1_larb6", "top_vpp", 31),
> +	/* VPP1_1 */
> +	GATE_VPP1_1(CLK_VPP1_SVPP1_MDP_HDR, "vpp1_svpp1_mdp_hdr", "top_vpp", 0),
> +	GATE_VPP1_1(CLK_VPP1_SVPP1_MDP_AAL, "vpp1_svpp1_mdp_aal", "top_vpp", 1),
> +	GATE_VPP1_1(CLK_VPP1_SVPP2_MDP_HDR, "vpp1_svpp2_mdp_hdr", "top_vpp", 2),
> +	GATE_VPP1_1(CLK_VPP1_SVPP2_MDP_AAL, "vpp1_svpp2_mdp_aal", "top_vpp", 3),
> +	GATE_VPP1_1(CLK_VPP1_SVPP3_MDP_HDR, "vpp1_svpp3_mdp_hdr", "top_vpp", 4),
> +	GATE_VPP1_1(CLK_VPP1_SVPP3_MDP_AAL, "vpp1_svpp3_mdp_aal", "top_vpp", 5),
> +	GATE_VPP1_1(CLK_VPP1_DISP_MUTEX, "vpp1_disp_mutex", "top_vpp", 7),
> +	GATE_VPP1_1(CLK_VPP1_SVPP2_VDO1_DL_RELAY, "vpp1_svpp2_vdo1_dl_relay", "top_vpp", 8),
> +	GATE_VPP1_1(CLK_VPP1_SVPP3_VDO0_DL_RELAY, "vpp1_svpp3_vdo0_dl_relay", "top_vpp", 9),
> +	GATE_VPP1_1(CLK_VPP1_VPP0_DL_ASYNC, "vpp1_vpp0_dl_async", "top_vpp", 10),
> +	GATE_VPP1_1(CLK_VPP1_VPP0_DL1_RELAY, "vpp1_vpp0_dl1_relay", "top_vpp", 11),
> +	GATE_VPP1_1(CLK_VPP1_LARB5_FAKE_ENG, "vpp1_larb5_fake_eng", "top_vpp", 12),
> +	GATE_VPP1_1(CLK_VPP1_LARB6_FAKE_ENG, "vpp1_larb6_fake_eng", "top_vpp", 13),
> +	GATE_VPP1_1(CLK_VPP1_HDMI_META, "vpp1_hdmi_meta", "top_vpp", 16),
> +	GATE_VPP1_1(CLK_VPP1_VPP_SPLIT_HDMI, "vpp1_vpp_split_hdmi", "top_vpp", 17),
> +	GATE_VPP1_1(CLK_VPP1_DGI_IN, "vpp1_dgi_in", "top_vpp", 18),
> +	GATE_VPP1_1(CLK_VPP1_DGI_OUT, "vpp1_dgi_out", "top_vpp", 19),
> +	GATE_VPP1_1(CLK_VPP1_VPP_SPLIT_DGI, "vpp1_vpp_split_dgi", "top_vpp", 20),
> +	GATE_VPP1_1(CLK_VPP1_DL_CON_OCC, "vpp1_dl_con_occ", "top_vpp", 21),
> +	GATE_VPP1_1(CLK_VPP1_VPP_SPLIT_26M, "vpp1_vpp_split_26m", "top_vpp", 26),
> +};
> +
> +static int clk_mt8188_vpp1_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct device_node *node = dev->parent->of_node;
> +	struct clk_hw_onecell_data *clk_data;
> +	int r;
> +
> +	clk_data = mtk_alloc_clk_data(CLK_VPP1_NR_CLK);
> +	if (!clk_data)
> +		return -ENOMEM;
> +
> +	r = mtk_clk_register_gates(node, vpp1_clks, ARRAY_SIZE(vpp1_clks), clk_data);
> +	if (r)
> +		goto free_vpp1_data;
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
> +	mtk_clk_unregister_gates(vpp1_clks, ARRAY_SIZE(vpp1_clks), clk_data);
> +free_vpp1_data:
> +	mtk_free_clk_data(clk_data);
> +	return r;
> +}
> +
> +static int clk_mt8188_vpp1_remove(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct device_node *node = dev->parent->of_node;
> +	struct clk_hw_onecell_data *clk_data = platform_get_drvdata(pdev);
> +
> +	of_clk_del_provider(node);
> +	mtk_clk_unregister_gates(vpp1_clks, ARRAY_SIZE(vpp1_clks), clk_data);
> +	mtk_free_clk_data(clk_data);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver clk_mt8188_vpp1_drv = {
> +	.probe = clk_mt8188_vpp1_probe,
> +	.remove = clk_mt8188_vpp1_remove,
> +	.driver = {
> +		.name = "clk-mt8188-vpp1",
> +	},
> +};
> +builtin_platform_driver(clk_mt8188_vpp1_drv);
