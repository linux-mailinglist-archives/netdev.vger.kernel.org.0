Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA07324A513
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 19:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgHSRiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 13:38:04 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:52544 "EHLO
        asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbgHSRiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 13:38:03 -0400
Received: from ravnborg.org (unknown [188.228.123.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by asavdk3.altibox.net (Postfix) with ESMTPS id 8716320020;
        Wed, 19 Aug 2020 19:35:59 +0200 (CEST)
Date:   Wed, 19 Aug 2020 19:35:58 +0200
From:   Sam Ravnborg <sam@ravnborg.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Xinliang Liu <xinliang.liu@linaro.org>,
        Wanchun Zheng <zhengwanchun@hisilicon.com>,
        linuxarm@huawei.com, dri-devel <dri-devel@lists.freedesktop.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devel@driverdev.osuosl.org, Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Xiubin Zhang <zhangxiubin1@huawei.com>,
        Wei Xu <xuwei5@hisilicon.com>, David Airlie <airlied@linux.ie>,
        Xinwei Kong <kong.kongxinwei@hisilicon.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Bogdan Togorean <bogdan.togorean@analog.com>,
        Laurentiu Palcu <laurentiu.palcu@nxp.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Liwei Cai <cailiwei@hisilicon.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Chen Feng <puck.chen@hisilicon.com>,
        Alexei Starovoitov <ast@kernel.org>,
        linaro-mm-sig@lists.linaro.org, Rob Herring <robh+dt@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, mauro.chehab@huawei.com,
        Rob Clark <robdclark@chromium.org>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liuyao An <anliuyao@huawei.com>,
        Rongrong Zou <zourongrong@gmail.com>, bpf@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 00/49] DRM driver for Hikey 970
Message-ID: <20200819173558.GA3733@ravnborg.org>
References: <cover.1597833138.git.mchehab+huawei@kernel.org>
 <20200819152120.GA106437@ravnborg.org>
 <20200819174027.70b39ee9@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819174027.70b39ee9@coco.lan>
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=f+hm+t6M c=1 sm=1 tr=0
        a=S6zTFyMACwkrwXSdXUNehg==:117 a=S6zTFyMACwkrwXSdXUNehg==:17
        a=kj9zAlcOel0A:10 a=BTeA3XvPAAAA:8 a=KKAkSRfTAAAA:8 a=i0EeH86SAAAA:8
        a=iNPT1vI0n1Meqt6tcukA:9 a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
        a=hvhfwy42faDvVyaO:21 a=aEH9U3OwnQ1iFVgv:21 a=cbds6oA4Dh3iQn_Q:21
        a=CjuIK1q_8ugA:10 a=tafbbOV3vt1XuEhzTjGK:22 a=cvBusfyB2V15izCimMoJ:22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mauro.

> Sure. I'm enclosing here a diffstat for the driver part (excluding
> DT bindings, as those are already self-contained).
Will have a look, patches are no named "dt-bindings" so I did not see
them in first round.


> The following diff merges patch from:
> 
> 	[PATCH 01/49] staging: hikey9xx: Add hisilicon DRM driver for hikey960/970
> 
> to:
> 
> 	[PATCH 43/49] staging: hikey9xx/gpu: get rid of DRM_HISI_KIRIN970

Thanks.
Here follows a scattered amount of small comments embeeded in the code
below.

Also a few high level comments:

There is too much unused code present - please delete.
I dod not think I spotted it all.

Some style issues - ask checkpatch --strict for help identifying
these.

Needs to be adapted to new bridge handling - see comments.
Move panel stuff to drm_panel (or maybe I got confsed so this was just
bride stuff).

Lots track a few times - so may have confused myself a few times.

Many small comments - but general impression is good.

Happy hacking!

	Sam


> diff --git a/drivers/staging/hikey9xx/gpu/Kconfig b/drivers/staging/hikey9xx/gpu/Kconfig
> new file mode 100644
> index 000000000000..957da13bcf81
> --- /dev/null
> +++ b/drivers/staging/hikey9xx/gpu/Kconfig
> @@ -0,0 +1,22 @@
> +config DRM_HISI_KIRIN9XX
> +	tristate "DRM Support for Hisilicon Kirin9xx series SoCs Platform"
> +	depends on DRM && OF && ARM64
> +	select DRM_KMS_HELPER
> +	select DRM_GEM_CMA_HELPER
> +	select DRM_KMS_CMA_HELPER
> +	select DRM_MIPI_DSI
> +	help
> +	  Choose this option if you have a HiSilicon Kirin960 or Kirin970.
> +	  If M is selected the module will be called kirin9xx-drm.
> +
> +config DRM_HISI_KIRIN970
> +	bool "Enable support for Hisilicon Kirin970"
> +	depends on DRM_MIPI_DSI
Implied by DRM_HISI_KIRIN9XX, so not needed.
> +	depends on DRM_HISI_KIRIN9XX
> +	help
> +	  Choose this option if you have a hisilicon Kirin chipsets(kirin970).
> +
> +config DRM_HISI_KIRIN9XX_DSI
> +	tristate
> +	depends on DRM_HISI_KIRIN9XX
> +	default y
This is essential a copy of DRM_HISI_KIRIN9XX - so no need for this
extra Kconfig variable.

> diff --git a/drivers/staging/hikey9xx/gpu/Makefile b/drivers/staging/hikey9xx/gpu/Makefile
> new file mode 100644
> index 000000000000..9177c3006b14
> --- /dev/null
> +++ b/drivers/staging/hikey9xx/gpu/Makefile
> @@ -0,0 +1,9 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +kirin9xx-drm-y := kirin9xx_drm_drv.o \
> +		  kirin9xx_drm_dss.o \
> +		  kirin9xx_drm_dpe_utils.o \
> +		  kirin970_defs.o kirin960_defs.o \
> +		  kirin9xx_drm_overlay_utils.o
> +
> +obj-$(CONFIG_DRM_HISI_KIRIN9XX) += kirin9xx-drm.o kirin9xx_pwm.o
> +obj-$(CONFIG_DRM_HISI_KIRIN9XX_DSI) += kirin9xx_dw_drm_dsi.o
> diff --git a/drivers/staging/hikey9xx/gpu/kirin960_defs.c b/drivers/staging/hikey9xx/gpu/kirin960_defs.c
> new file mode 100644
> index 000000000000..720f4f80a518
> --- /dev/null
> +++ b/drivers/staging/hikey9xx/gpu/kirin960_defs.c
> @@ -0,0 +1,378 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2008-2011, Hisilicon Tech. Co., Ltd. All rights reserved.
Any newer copyright?

> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
Can we drop the license text when we have SPDX?
Same goes for other files if they mix it.

> +
> +#include <drm/drm_atomic.h>
> +#include <drm/drm_atomic_helper.h>
> +#include <drm/drm_crtc.h>
> +#include <drm/drm_crtc_helper.h>
> +#include <drm/drm_drv.h>
> +#include <drm/drm_fb_cma_helper.h>
> +#include <drm/drm_fourcc.h>
> +#include <drm/drm_gem_cma_helper.h>
> +#include <drm/drm_plane_helper.h>
> +
> +#include "kirin9xx_drm_dpe_utils.h"
> +#include "kirin9xx_drm_drv.h"
> +#include "kirin960_dpe_reg.h"
> +
> +/*
> + * dss_chn_idx
> + * DSS_RCHN_D2 = 0,	DSS_RCHN_D3,	DSS_RCHN_V0,	DSS_RCHN_G0,	DSS_RCHN_V1,
> + * DSS_RCHN_G1,	DSS_RCHN_D0,	DSS_RCHN_D1,	DSS_WCHN_W0,	DSS_WCHN_W1,
> + * DSS_RCHN_V2,   DSS_WCHN_W2,
Do not mix tabs and space for indent.

> + */
> +static const u32 kirin960_g_dss_module_base[DSS_CHN_MAX_DEFINE][MODULE_CHN_MAX] = {
> +	/* D0 */
> +	{
> +	MIF_CH0_OFFSET,
> +	AIF0_CH0_OFFSET,
> +	AIF1_CH0_OFFSET,
> +	MCTL_CTL_MUTEX_RCH0,
> +	DSS_MCTRL_SYS_OFFSET + MCTL_RCH0_FLUSH_EN,
> +	DSS_MCTRL_SYS_OFFSET + MCTL_RCH0_OV_OEN,
> +	DSS_MCTRL_SYS_OFFSET + MCTL_RCH0_STARTY,
> +	DSS_MCTRL_SYS_OFFSET + MCTL_MOD0_DBG,
> +	DSS_RCH_D0_DMA_OFFSET,
> +	DSS_RCH_D0_DFC_OFFSET,
> +	0,
> +	0,
> +	0,
> +	0,
> +	0,
> +	0,
> +	DSS_RCH_D0_CSC_OFFSET,
Indent one more tab. Same applies later.
> +	},
> +
> +static const u32 kirin960_g_dss_module_ovl_base[DSS_MCTL_IDX_MAX][MODULE_OVL_MAX] = {
> +	{DSS_OVL0_OFFSET,
> +	DSS_MCTRL_CTL0_OFFSET},
Add more newlines
> +
> +	{DSS_OVL1_OFFSET,
> +	DSS_MCTRL_CTL1_OFFSET},
> +
> +	{DSS_OVL2_OFFSET,
> +	DSS_MCTRL_CTL2_OFFSET},
> +
> +	{DSS_OVL3_OFFSET,
> +	DSS_MCTRL_CTL3_OFFSET},
> +
> +	{0,
> +	DSS_MCTRL_CTL4_OFFSET},
> +
> +	{0,
> +	DSS_MCTRL_CTL5_OFFSET},
> +};
> +
> +/*SCF_LUT_CHN coef_idx*/
> +static const int kirin960_g_scf_lut_chn_coef_idx[DSS_CHN_MAX_DEFINE] = {
> +	-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
> +};
Spaces after "/*" and before "*/". Applies for many comments.

> +
> +static const u32 kirin960_g_dss_module_cap[DSS_CHN_MAX_DEFINE][MODULE_CAP_MAX] = {
> +	/* D2 */
> +	{0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1},
Compact, looks good and readable.
> +	/* D3 */
> +	{0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1},
> +	/* V0 */
> +	{0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1},
> +	/* G0 */
> +	{0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0},
> +	/* V1 */
> +	{0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1},
> +	/* G1 */
> +	{0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0},
> +	/* D0 */
> +	{0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1},
> +	/* D1 */
> +	{0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1},
> +
> +	/* W0 */
> +	{1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1},
> +	/* W1 */
> +	{1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1},
> +
> +	/* V2 */
> +	{0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1},
> +	/* W2 */
> +	{1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1},
> +};
> +
> +/* number of smrx idx for each channel */
> +static const u32 kirin960_g_dss_chn_sid_num[DSS_CHN_MAX_DEFINE] = {
> +	4, 1, 4, 4, 4, 4, 1, 1, 3, 3, 3, 2
> +};
> +
> +/* start idx of each channel */
> +/* smrx_idx = g_dss_smmu_smrx_idx[chn_idx] + (0 ~ g_dss_chn_sid_num[chn_idx]) */
> +static const u32 kirin960_g_dss_smmu_smrx_idx[DSS_CHN_MAX_DEFINE] = {
> +	0, 4, 5, 9, 13, 17, 21, 22, 26, 29, 23, 32
> +};
> +
> +static const u32 kirin960_g_dss_mif_sid_map[DSS_CHN_MAX] = {
> +	0, 0, 0, 0, 0, 0, 0, 0, 0, 0
> +};
> +
> +void kirin960_dpe_defs(struct dss_hw_ctx *ctx)
> +{
> +	memcpy(&ctx->g_dss_module_base, &kirin960_g_dss_module_base,
> +		sizeof(kirin960_g_dss_module_base));
> +	memcpy(&ctx->g_dss_module_ovl_base, &kirin960_g_dss_module_ovl_base,
> +		sizeof(kirin960_g_dss_module_ovl_base));
> +	memcpy(&ctx->g_scf_lut_chn_coef_idx, &kirin960_g_scf_lut_chn_coef_idx,
> +		sizeof(kirin960_g_scf_lut_chn_coef_idx));
> +	memcpy(&ctx->g_dss_module_cap, &kirin960_g_dss_module_cap,
> +		sizeof(kirin960_g_dss_module_cap));
> +	memcpy(&ctx->g_dss_chn_sid_num, &kirin960_g_dss_chn_sid_num,
> +		sizeof(kirin960_g_dss_chn_sid_num));
> +	memcpy(&ctx->g_dss_smmu_smrx_idx, &kirin960_g_dss_smmu_smrx_idx,
> +		sizeof(kirin960_g_dss_smmu_smrx_idx));
> +
> +	ctx->smmu_offset = DSS_SMMU_OFFSET;
> +	ctx->afbc_header_addr_align = AFBC_HEADER_ADDR_ALIGN;
> +	ctx->dss_mmbuf_clk_rate_power_off = DEFAULT_DSS_MMBUF_CLK_RATE_POWER_OFF;
> +	ctx->rot_mem_ctrl = ROT_MEM_CTRL;
> +	ctx->dither_mem_ctrl = DITHER_MEM_CTRL;
> +	ctx->arsr2p_lb_mem_ctrl = ARSR2P_LB_MEM_CTRL;
> +	ctx->pxl0_clk_rate_power_off = DEFAULT_DSS_PXL0_CLK_RATE_POWER_OFF;
> +}
> diff --git a/drivers/staging/hikey9xx/gpu/kirin960_dpe_reg.h b/drivers/staging/hikey9xx/gpu/kirin960_dpe_reg.h
> new file mode 100644
> index 000000000000..895952762e5c
> --- /dev/null
> +++ b/drivers/staging/hikey9xx/gpu/kirin960_dpe_reg.h
> @@ -0,0 +1,233 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (c) 2016 Linaro Limited.
> + * Copyright (c) 2014-2016 Hisilicon Limited.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#ifndef __KIRIN960_DPE_REG_H__
> +#define __KIRIN960_DPE_REG_H__
> +
> +#include "kirin9xx_dpe.h"
> +
> +#define CRGPERI_PLL0_CLK_RATE	(1600000000UL)
> +#define CRGPERI_PLL2_CLK_RATE	(960000000UL)
> +#define CRGPERI_PLL3_CLK_RATE	(1600000000UL)
> +
> +/*dss clk power off */
> +#define DEFAULT_DSS_PXL0_CLK_RATE_POWER_OFF	(277000000UL)
> +#define DEFAULT_DSS_MMBUF_CLK_RATE_POWER_OFF	(238000000UL)
> +
> +/*****************************************************************************/
> +
> +#define SCPWREN	(0x0D0)
> +#define SCPEREN1 (0x040)
> +#define SCPERDIS1  (0x044)
> +#define SCPERRSTDIS1	(0x090)
> +#define SCISODIS	(0x0C4)
> +
> +/*****************************************************************************/
> +
> +/* MODULE BASE ADDRESS */
> +
> +#define DSS_SMMU_OFFSET	(0x8000)
> +
> +#define DSS_RCH_VG0_POST_CLIP_OFFSET	(0x203A0)
> +
> +#define DSS_RCH_VG1_POST_CLIP_OFFSET	(0x283A0)
> +
> +#define DSS_RCH_VG2_POST_CLIP_OFFSET	(0x303A0)
> +#define DSS_RCH_VG2_AFBCD_OFFSET	(0x30900)
> +
> +#define DSS_RCH_G0_POST_CLIP_OFFSET (0x383A0)
> +
> +#define DSS_RCH_G1_POST_CLIP_OFFSET (0x403A0)
> +
> +#define DSS_RCH_D2_AFBCD_OFFSET	(0x50900)
> +
> +#define DSS_RCH_D3_AFBCD_OFFSET	(0x51900)
> +
> +#define DSS_RCH_D1_AFBCD_OFFSET	(0x53900)
> +
> +#define DSS_WCH0_ROT_OFFSET	(0x5A500)
> +
> +#define DSS_WCH1_ROT_OFFSET	(0x5C500)
> +
> +#define DSS_DPP_DEGAMA_OFFSET	(0x70500)
> +#define DSS_DPP_LCP_OFFSET	(0x70900)
> +#define DSS_DPP_ARSR1P_OFFSET	(0x70A00)
> +#define DSS_DPP_BITEXT0_OFFSET	(0x70B00)
> +#define DSS_DPP_LCP_LUT_OFFSET	(0x73000)
> +#define DSS_DPP_ARSR1P_LUT_OFFSET	(0x7B000)
> +
> +#define DSS_POST_SCF_OFFSET	DSS_DPP_ARSR1P_OFFSET
> +#define DSS_POST_SCF_LUT_OFFSET	DSS_DPP_ARSR1P_LUT_OFFSET
> +
> +/* AIF */
> +#define AIF0_CH0_ADD_OFFSET	(DSS_VBIF0_AIF + 0x04)
> +#define AIF0_CH1_ADD_OFFSET	(DSS_VBIF0_AIF + 0x24)
> +#define AIF0_CH2_ADD_OFFSET	(DSS_VBIF0_AIF + 0x44)
> +#define AIF0_CH3_ADD_OFFSET	(DSS_VBIF0_AIF + 0x64)
> +#define AIF0_CH4_ADD_OFFSET	(DSS_VBIF0_AIF + 0x84)
> +#define AIF0_CH5_ADD_OFFSET	(DSS_VBIF0_AIF + 0xa4)
> +#define AIF0_CH6_ADD_OFFSET	(DSS_VBIF0_AIF + 0xc4)
> +#define AIF0_CH7_ADD_OFFSET	(DSS_VBIF0_AIF + 0xe4)
> +#define AIF0_CH8_ADD_OFFSET	(DSS_VBIF0_AIF + 0x104)
> +#define AIF0_CH9_ADD_OFFSET	(DSS_VBIF0_AIF + 0x124)
> +#define AIF0_CH10_ADD_OFFSET	(DSS_VBIF0_AIF + 0x144)
> +#define AIF0_CH11_ADD_OFFSET	(DSS_VBIF0_AIF + 0x164)
> +#define AIF0_CH12_ADD_OFFSET	(DSS_VBIF0_AIF + 0x184)
> +
> +#define AIF1_CH0_ADD_OFFSET	(DSS_VBIF1_AIF + 0x04)
> +#define AIF1_CH1_ADD_OFFSET	(DSS_VBIF1_AIF + 0x24)
> +#define AIF1_CH2_ADD_OFFSET	(DSS_VBIF1_AIF + 0x44)
> +#define AIF1_CH3_ADD_OFFSET	(DSS_VBIF1_AIF + 0x64)
> +#define AIF1_CH4_ADD_OFFSET	(DSS_VBIF1_AIF + 0x84)
> +#define AIF1_CH5_ADD_OFFSET	(DSS_VBIF1_AIF + 0xa4)
> +#define AIF1_CH6_ADD_OFFSET	(DSS_VBIF1_AIF + 0xc4)
> +#define AIF1_CH7_ADD_OFFSET	(DSS_VBIF1_AIF + 0xe4)
> +#define AIF1_CH8_ADD_OFFSET	(DSS_VBIF1_AIF + 0x104)
> +#define AIF1_CH9_ADD_OFFSET	(DSS_VBIF1_AIF + 0x124)
> +#define AIF1_CH10_ADD_OFFSET	(DSS_VBIF1_AIF + 0x144)
> +#define AIF1_CH11_ADD_OFFSET	(DSS_VBIF1_AIF + 0x164)
> +#define AIF1_CH12_ADD_OFFSET	(DSS_VBIF1_AIF + 0x184)
> +
> +/* DFC */
> +#define DFC_GLB_ALPHA	(0x0008)
> +
> +/* ARSR2P v0 */
> +#define ARSR2P_IHRIGHT		(0x00C)
> +#define ARSR2P_IVTOP		(0x010)
> +#define ARSR2P_IVBOTTOM		(0x014)
> +#define ARSR2P_IHINC		(0x018)
> +#define ARSR2P_IVINC		(0x01C)
> +#define ARSR2P_UV_OFFSET		(0x020)
> +#define ARSR2P_MODE		(0x024)
> +#define ARSR2P_SKIN_THRES_Y		(0x028)
> +#define ARSR2P_SKIN_THRES_U		(0x02C)
> +#define ARSR2P_SKIN_THRES_V		(0x030)
> +#define ARSR2P_SKIN_CFG0		(0x034)
> +#define ARSR2P_SKIN_CFG1		(0x038)
> +#define ARSR2P_SKIN_CFG2		(0x03C)
> +#define ARSR2P_SHOOT_CFG1		(0x040)
> +#define ARSR2P_SHOOT_CFG2		(0x044)
> +#define ARSR2P_SHARP_CFG1		(0x048)
> +#define ARSR2P_SHARP_CFG2		(0x04C)
> +#define ARSR2P_SHARP_CFG3		(0x050)
> +#define ARSR2P_SHARP_CFG4		(0x054)
> +#define ARSR2P_SHARP_CFG5		(0x058)
> +#define ARSR2P_SHARP_CFG6		(0x05C)
> +#define ARSR2P_SHARP_CFG7		(0x060)
> +#define ARSR2P_SHARP_CFG8		(0x064)
> +#define ARSR2P_SHARP_CFG9		(0x068)
> +#define ARSR2P_TEXTURW_ANALYSTS		(0x06C)
> +#define ARSR2P_INTPLSHOOTCTRL		(0x070)
> +#define ARSR2P_DEBUG0		(0x074)
> +#define ARSR2P_DEBUG1		(0x078)
> +#define ARSR2P_DEBUG2		(0x07C)
> +#define ARSR2P_DEBUG3		(0x080)
> +#define ARSR2P_LB_MEM_CTRL		(0x084)
> +#define ARSR2P_IHLEFT1		(0x088)
> +#define ARSR2P_IHRIGHT1		(0x090)
> +#define ARSR2P_IVBOTTOM1		(0x094)
> +
> +/* POST_CLIP  v g */
> +#define POST_CLIP_CTL_HRZ	(0x0010)
> +#define POST_CLIP_CTL_VRZ	(0x0014)
> +#define POST_CLIP_EN	(0x0018)
> +
> +/* CSC */
> +
> +#define CSC_ICG_MODULE	(0x0024)
> +
> +/* DMA BUF */
> +
> +#define AFBCE_HREG_HDR_PTR_LO	(0x908)
> +#define AFBCE_HREG_PLD_PTR_LO	(0x90C)
> +
> +#define ROT_MEM_CTRL		(0x538)
> +#define ROT_SIZE	(0x53C)
> +
> +/* DMA aligned limited:  128bits aligned */
> +
> +#define AFBC_HEADER_ADDR_ALIGN	(64)
> +#define AFBC_HEADER_STRIDE_ALIGN	(64)
> +
> +/* DPP */
> +
> +#define DITHER_PARA (0x000)
> +#define DITHER_CTL (0x004)
> +#define DITHER_MATRIX_PART1 (0x008)
> +#define DITHER_MATRIX_PART0 (0x00C)
> +#define DITHER_ERRDIFF_WEIGHT (0x010)
> +#define DITHER_FRC_01_PART1 (0x014)
> +#define DITHER_FRC_01_PART0 (0x018)
> +#define DITHER_FRC_10_PART1 (0x01C)
> +#define DITHER_FRC_10_PART0 (0x020)
> +#define DITHER_FRC_11_PART1 (0x024)
> +#define DITHER_FRC_11_PART0 (0x028)
> +#define DITHER_MEM_CTRL (0x02C)
> +#define DITHER_DBG0 (0x030)
> +#define DITHER_DBG1 (0x034)
> +#define DITHER_DBG2 (0x038)
> +
> +#define LCP_GMP_BYPASS_EN	(0x030)
> +#define LCP_XCC_BYPASS_EN	(0x034)
> +#define LCP_DEGAMA_EN	(0x038)
> +#define LCP_DEGAMA_MEM_CTRL	(0x03C)
> +#define LCP_GMP_MEM_CTRL	(0x040)
> +
> +#define ARSR1P_IHLEFT		(0x000)
> +#define ARSR1P_IHRIGHT		(0x004)
> +#define ARSR1P_IHLEFT1		(0x008)
> +#define ARSR1P_IHRIGHT1		(0x00C)
> +#define ARSR1P_IVTOP		(0x010)
> +#define ARSR1P_IVBOTTOM		(0x014)
> +#define ARSR1P_UV_OFFSET		(0x018)
> +#define ARSR1P_IHINC		(0x01C)
> +#define ARSR1P_IVINC		(0x020)
> +#define ARSR1P_MODE			(0x024)
> +#define ARSR1P_FORMAT		(0x028)
> +#define ARSR1P_SKIN_THRES_Y		(0x02C)
> +#define ARSR1P_SKIN_THRES_U		(0x030)
> +#define ARSR1P_SKIN_THRES_V		(0x034)
> +#define ARSR1P_SKIN_EXPECTED	(0x038)
> +#define ARSR1P_SKIN_CFG			(0x03C)
> +#define ARSR1P_SHOOT_CFG1		(0x040)
> +#define ARSR1P_SHOOT_CFG2		(0x044)
> +#define ARSR1P_SHARP_CFG1		(0x048)
> +#define ARSR1P_SHARP_CFG2		(0x04C)
> +#define ARSR1P_SHARP_CFG3		(0x050)
> +#define ARSR1P_SHARP_CFG4		(0x054)
> +#define ARSR1P_SHARP_CFG5		(0x058)
> +#define ARSR1P_SHARP_CFG6		(0x05C)
> +#define ARSR1P_SHARP_CFG7		(0x060)
> +#define ARSR1P_SHARP_CFG8		(0x064)
> +#define ARSR1P_SHARP_CFG9		(0x068)
> +#define ARSR1P_SHARP_CFG10		(0x06C)
> +#define ARSR1P_SHARP_CFG11		(0x070)
> +#define ARSR1P_DIFF_CTRL		(0x074)
> +#define ARSR1P_LSC_CFG1		(0x078)
> +#define ARSR1P_LSC_CFG2		(0x07C)
> +#define ARSR1P_LSC_CFG3		(0x080)
> +#define ARSR1P_FORCE_CLK_ON_CFG		(0x084)
> +
> +/* BIT EXT */
> +
> +#define LCP_U_GMP_COEF	(0x0000)
> +
> +#define ARSR1P_LSC_GAIN		(0x084)
> +#define ARSR1P_COEFF_H_Y0	(0x0F0)
> +#define ARSR1P_COEFF_H_Y1	(0x114)
> +#define ARSR1P_COEFF_V_Y0	(0x138)
> +#define ARSR1P_COEFF_V_Y1	(0x15C)
> +#define ARSR1P_COEFF_H_UV0	(0x180)
> +#define ARSR1P_COEFF_H_UV1	(0x1A4)
> +#define ARSR1P_COEFF_V_UV0	(0x1C8)
> +#define ARSR1P_COEFF_V_UV1	(0x1EC)
> +
> +#endif
> diff --git a/drivers/staging/hikey9xx/gpu/kirin970_defs.c b/drivers/staging/hikey9xx/gpu/kirin970_defs.c
> new file mode 100644
> index 000000000000..749e37dbd4c0
> --- /dev/null
> +++ b/drivers/staging/hikey9xx/gpu/kirin970_defs.c
> @@ -0,0 +1,381 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2008-2011, Hisilicon Tech. Co., Ltd. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <drm/drm_atomic.h>
> +#include <drm/drm_atomic_helper.h>
> +#include <drm/drm_crtc.h>
> +#include <drm/drm_crtc_helper.h>
> +#include <drm/drm_drv.h>
> +#include <drm/drm_fb_cma_helper.h>
> +#include <drm/drm_fourcc.h>
> +#include <drm/drm_gem_cma_helper.h>
> +#include <drm/drm_plane_helper.h>
> +
> +#include "kirin9xx_drm_dpe_utils.h"
> +#include "kirin9xx_drm_drv.h"
> +#include "kirin970_dpe_reg.h"
> +
> +static const u32 kirin970_g_dss_module_base[DSS_CHN_MAX_DEFINE][MODULE_CHN_MAX] = {
> +	// D0
Some people dislike the more readable c99 comments.
I do not recall if coding style allows them
Ask checkpatch --strict

> +	{
> +	MIF_CH0_OFFSET,   //MODULE_MIF_CHN
Space after "//"

> +	AIF0_CH0_OFFSET,  //MODULE_AIF0_CHN
> +	AIF1_CH0_OFFSET,  //MODULE_AIF1_CHN
> +	MCTL_CTL_MUTEX_RCH0,  //MODULE_MCTL_CHN_MUTEX
> +	DSS_MCTRL_SYS_OFFSET + MCTL_RCH0_FLUSH_EN,  //MODULE_MCTL_CHN_FLUSH_EN
> +	DSS_MCTRL_SYS_OFFSET + MCTL_RCH0_OV_OEN,  //MODULE_MCTL_CHN_OV_OEN
> +	DSS_MCTRL_SYS_OFFSET + MCTL_RCH0_STARTY,  //MODULE_MCTL_CHN_STARTY
> +	DSS_MCTRL_SYS_OFFSET + MCTL_MOD0_DBG,  //MODULE_MCTL_CHN_MOD_DBG
> +	DSS_RCH_D0_DMA_OFFSET,  //MODULE_DMA
> +	DSS_RCH_D0_DFC_OFFSET,  //MODULE_DFC
> +	0,  //MODULE_SCL
> +	0,  //MODULE_SCL_LUT
> +	0,  //MODULE_ARSR2P
> +	0,  //MODULE_ARSR2P_LUT
> +	0, //MODULE_POST_CLIP_ES
> +	0,  //MODULE_POST_CLIP
> +	0,  //MODULE_PCSC
> +	DSS_RCH_D0_CSC_OFFSET,  //MODULE_CSC
> +	},
> +
> +	// D1
> +	{
> +	MIF_CH1_OFFSET,   //MODULE_MIF_CHN
> +	AIF0_CH1_OFFSET,  //MODULE_AIF0_CHN
> +	AIF1_CH1_OFFSET,  //MODULE_AIF1_CHN
> +	MCTL_CTL_MUTEX_RCH1,  //MODULE_MCTL_CHN_MUTEX
> +	DSS_MCTRL_SYS_OFFSET + MCTL_RCH1_FLUSH_EN,  //MODULE_MCTL_CHN_FLUSH_EN
> +	DSS_MCTRL_SYS_OFFSET + MCTL_RCH1_OV_OEN,  //MODULE_MCTL_CHN_OV_OEN
> +	DSS_MCTRL_SYS_OFFSET + MCTL_RCH1_STARTY,  //MODULE_MCTL_CHN_STARTY
> +	DSS_MCTRL_SYS_OFFSET + MCTL_MOD1_DBG,  //MODULE_MCTL_CHN_MOD_DBG
> +	DSS_RCH_D1_DMA_OFFSET,  //MODULE_DMA
> +	DSS_RCH_D1_DFC_OFFSET,  //MODULE_DFC
> +	0,  //MODULE_SCL
> +	0,  //MODULE_SCL_LUT
> +	0,  //MODULE_ARSR2P
> +	0,  //MODULE_ARSR2P_LUT
> +	0, //MODULE_POST_CLIP_ES
> +	0,  //MODULE_POST_CLIP
> +	0,  //MODULE_PCSC
> +	DSS_RCH_D1_CSC_OFFSET,  //MODULE_CSC
> +	},
> +
> +	// V0
> +	{
> +	MIF_CH2_OFFSET,   //MODULE_MIF_CHN
> +	AIF0_CH2_OFFSET,  //MODULE_AIF0_CHN
> +	AIF1_CH2_OFFSET,  //MODULE_AIF1_CHN
> +	MCTL_CTL_MUTEX_RCH2,  //MODULE_MCTL_CHN_MUTEX
> +	DSS_MCTRL_SYS_OFFSET + MCTL_RCH2_FLUSH_EN,  //MODULE_MCTL_CHN_FLUSH_EN
> +	DSS_MCTRL_SYS_OFFSET + MCTL_RCH2_OV_OEN,  //MODULE_MCTL_CHN_OV_OEN
> +	DSS_MCTRL_SYS_OFFSET + MCTL_RCH2_STARTY,  //MODULE_MCTL_CHN_STARTY
> +	DSS_MCTRL_SYS_OFFSET + MCTL_MOD2_DBG,  //MODULE_MCTL_CHN_MOD_DBG
> +	DSS_RCH_VG0_DMA_OFFSET,  //MODULE_DMA
> +	DSS_RCH_VG0_DFC_OFFSET,  //MODULE_DFC
> +	DSS_RCH_VG0_SCL_OFFSET,  //MODULE_SCL
> +	DSS_RCH_VG0_SCL_LUT_OFFSET,  //MODULE_SCL_LUT
> +	DSS_RCH_VG0_ARSR_OFFSET,  //MODULE_ARSR2P
> +	DSS_RCH_VG0_ARSR_LUT_OFFSET,  //MODULE_ARSR2P_LUT
> +	DSS_RCH_VG0_POST_CLIP_OFFSET_ES,  //MODULE_POST_CLIP_ES
> +	DSS_RCH_VG0_POST_CLIP_OFFSET,  //MODULE_POST_CLIP
> +	DSS_RCH_VG0_PCSC_OFFSET,  //MODULE_PCSC
> +	DSS_RCH_VG0_CSC_OFFSET,  //MODULE_CSC
> +	},
> +
> +	// G0
> +	{
> +	MIF_CH3_OFFSET,   //MODULE_MIF_CHN
> +	AIF0_CH3_OFFSET,  //MODULE_AIF0_CHN
> +	AIF1_CH3_OFFSET,  //MODULE_AIF1_CHN
> +	MCTL_CTL_MUTEX_RCH3,  //MODULE_MCTL_CHN_MUTEX
> +	DSS_MCTRL_SYS_OFFSET + MCTL_RCH3_FLUSH_EN,  //MODULE_MCTL_CHN_FLUSH_EN
> +	DSS_MCTRL_SYS_OFFSET + MCTL_RCH3_OV_OEN,  //MODULE_MCTL_CHN_OV_OEN
> +	DSS_MCTRL_SYS_OFFSET + MCTL_RCH3_STARTY,  //MODULE_MCTL_CHN_STARTY
> +	DSS_MCTRL_SYS_OFFSET + MCTL_MOD3_DBG,  //MODULE_MCTL_CHN_MOD_DBG
> +	DSS_RCH_G0_DMA_OFFSET,  //MODULE_DMA
> +	DSS_RCH_G0_DFC_OFFSET,  //MODULE_DFC
> +	DSS_RCH_G0_SCL_OFFSET,  //MODULE_SCL
> +	0,  //MODULE_SCL_LUT
> +	0,  //MODULE_ARSR2P
> +	0,  //MODULE_ARSR2P_LUT
> +	DSS_RCH_G0_POST_CLIP_OFFSET_ES,  //MODULE_POST_CLIP_ES
> +	DSS_RCH_G0_POST_CLIP_OFFSET,  //MODULE_POST_CLIP
> +	0,  //MODULE_PCSC
> +	DSS_RCH_G0_CSC_OFFSET,  //MODULE_CSC
> +	},
> +
> +	// V1
> +	{
> +	MIF_CH4_OFFSET,   //MODULE_MIF_CHN
> +	AIF0_CH4_OFFSET,  //MODULE_AIF0_CHN
> +	AIF1_CH4_OFFSET,  //MODULE_AIF1_CHN
> +	MCTL_CTL_MUTEX_RCH4,  //MODULE_MCTL_CHN_MUTEX
> +	DSS_MCTRL_SYS_OFFSET + MCTL_RCH4_FLUSH_EN,  //MODULE_MCTL_CHN_FLUSH_EN
> +	DSS_MCTRL_SYS_OFFSET + MCTL_RCH4_OV_OEN,  //MODULE_MCTL_CHN_OV_OEN
> +	DSS_MCTRL_SYS_OFFSET + MCTL_RCH4_STARTY,  //MODULE_MCTL_CHN_STARTY
> +	DSS_MCTRL_SYS_OFFSET + MCTL_MOD4_DBG,  //MODULE_MCTL_CHN_MOD_DBG
> +	DSS_RCH_VG1_DMA_OFFSET,  //MODULE_DMA
> +	DSS_RCH_VG1_DFC_OFFSET,  //MODULE_DFC
> +	DSS_RCH_VG1_SCL_OFFSET,  //MODULE_SCL
> +	DSS_RCH_VG1_SCL_LUT_OFFSET,  //MODULE_SCL_LUT
> +	0,  //MODULE_ARSR2P
> +	0,  //MODULE_ARSR2P_LUT
> +	DSS_RCH_VG1_POST_CLIP_OFFSET_ES,  //MODULE_POST_CLIP_ES
> +	DSS_RCH_VG1_POST_CLIP_OFFSET,  //MODULE_POST_CLIP
> +	0,  //MODULE_PCSC
> +	DSS_RCH_VG1_CSC_OFFSET,  //MODULE_CSC
> +	},
> +
> +	// G1
> +	{
> +	MIF_CH5_OFFSET,   //MODULE_MIF_CHN
> +	AIF0_CH5_OFFSET,  //MODULE_AIF0_CHN
> +	AIF1_CH5_OFFSET,  //MODULE_AIF1_CHN
> +	MCTL_CTL_MUTEX_RCH5,  //MODULE_MCTL_CHN_MUTEX
> +	DSS_MCTRL_SYS_OFFSET + MCTL_RCH5_FLUSH_EN,  //MODULE_MCTL_CHN_FLUSH_EN
> +	DSS_MCTRL_SYS_OFFSET + MCTL_RCH5_OV_OEN,  //MODULE_MCTL_CHN_OV_OEN
> +	DSS_MCTRL_SYS_OFFSET + MCTL_RCH5_STARTY,  //MODULE_MCTL_CHN_STARTY
> +	DSS_MCTRL_SYS_OFFSET + MCTL_MOD5_DBG,  //MODULE_MCTL_CHN_MOD_DBG
> +	DSS_RCH_G1_DMA_OFFSET,  //MODULE_DMA
> +	DSS_RCH_G1_DFC_OFFSET,  //MODULE_DFC
> +	DSS_RCH_G1_SCL_OFFSET,  //MODULE_SCL
> +	0,  //MODULE_SCL_LUT
> +	0,  //MODULE_ARSR2P
> +	0,  //MODULE_ARSR2P_LUT
> +	DSS_RCH_G1_POST_CLIP_OFFSET_ES,  //MODULE_POST_CLIP_ES
> +	DSS_RCH_G1_POST_CLIP_OFFSET,  //MODULE_POST_CLIP
> +	0,  //MODULE_PCSC
> +	DSS_RCH_G1_CSC_OFFSET,  //MODULE_CSC
> +	},
> +
> +	// D2
> +	{
> +	MIF_CH6_OFFSET,   //MODULE_MIF_CHN
> +	AIF0_CH6_OFFSET,  //MODULE_AIF0_CHN
> +	AIF1_CH6_OFFSET,  //MODULE_AIF1_CHN
> +	MCTL_CTL_MUTEX_RCH6,  //MODULE_MCTL_CHN_MUTEX
> +	DSS_MCTRL_SYS_OFFSET + MCTL_RCH6_FLUSH_EN,  //MODULE_MCTL_CHN_FLUSH_EN
> +	DSS_MCTRL_SYS_OFFSET + MCTL_RCH6_OV_OEN,  //MODULE_MCTL_CHN_OV_OEN
> +	DSS_MCTRL_SYS_OFFSET + MCTL_RCH6_STARTY,  //MODULE_MCTL_CHN_STARTY
> +	DSS_MCTRL_SYS_OFFSET + MCTL_MOD6_DBG,  //MODULE_MCTL_CHN_MOD_DBG
> +	DSS_RCH_D2_DMA_OFFSET,  //MODULE_DMA
> +	DSS_RCH_D2_DFC_OFFSET,  //MODULE_DFC
> +	0,  //MODULE_SCL
> +	0,  //MODULE_SCL_LUT
> +	0,  //MODULE_ARSR2P
> +	0,  //MODULE_ARSR2P_LUT
> +	0, //MODULE_POST_CLIP_ES
> +	0,  //MODULE_POST_CLIP
> +	0,  //MODULE_PCSC
> +	DSS_RCH_D2_CSC_OFFSET,  //MODULE_CSC
> +	},
> +
> +	// D3
> +	{
> +	MIF_CH7_OFFSET,   //MODULE_MIF_CHN
> +	AIF0_CH7_OFFSET,  //MODULE_AIF0_CHN
> +	AIF1_CH7_OFFSET,  //MODULE_AIF1_CHN
> +	MCTL_CTL_MUTEX_RCH7,  //MODULE_MCTL_CHN_MUTEX
> +	DSS_MCTRL_SYS_OFFSET + MCTL_RCH7_FLUSH_EN,  //MODULE_MCTL_CHN_FLUSH_EN
> +	DSS_MCTRL_SYS_OFFSET + MCTL_RCH7_OV_OEN,  //MODULE_MCTL_CHN_OV_OEN
> +	DSS_MCTRL_SYS_OFFSET + MCTL_RCH7_STARTY,  //MODULE_MCTL_CHN_STARTY
> +	DSS_MCTRL_SYS_OFFSET + MCTL_MOD7_DBG,  //MODULE_MCTL_CHN_MOD_DBG
> +	DSS_RCH_D3_DMA_OFFSET,  //MODULE_DMA
> +	DSS_RCH_D3_DFC_OFFSET,  //MODULE_DFC
> +	0,  //MODULE_SCL
> +	0,  //MODULE_SCL_LUT
> +	0,  //MODULE_ARSR2P
> +	0,  //MODULE_ARSR2P_LUT
> +	0, //MODULE_POST_CLIP_ES
> +	0,  //MODULE_POST_CLIP
> +	0,  //MODULE_PCSC
> +	DSS_RCH_D3_CSC_OFFSET,  //MODULE_CSC
> +	},
> +
> +	// W0
> +	{
> +	MIF_CH8_OFFSET,   //MODULE_MIF_CHN
> +	AIF0_CH8_OFFSET,  //MODULE_AIF0_CHN
> +	AIF1_CH8_OFFSET,  //MODULE_AIF1_CHN
> +	MCTL_CTL_MUTEX_WCH0,  //MODULE_MCTL_CHN_MUTEX
> +	DSS_MCTRL_SYS_OFFSET + MCTL_WCH0_FLUSH_EN,  //MODULE_MCTL_CHN_FLUSH_EN
> +	DSS_MCTRL_SYS_OFFSET + MCTL_WCH0_OV_IEN,  //MODULE_MCTL_CHN_OV_OEN
> +	0,  //MODULE_MCTL_CHN_STARTY
> +	0,  //MODULE_MCTL_CHN_MOD_DBG
> +	DSS_WCH0_DMA_OFFSET,  //MODULE_DMA
> +	DSS_WCH0_DFC_OFFSET,  //MODULE_DFC
> +	0,  //MODULE_SCL
> +	0,  //MODULE_SCL_LUT
> +	0,  //MODULE_ARSR2P
> +	0,  //MODULE_ARSR2P_LUT
> +	0, //MODULE_POST_CLIP_ES
> +	0,  //MODULE_POST_CLIP
> +	0,  //MODULE_PCSC
> +	DSS_WCH0_CSC_OFFSET,  //MODULE_CSC
> +	},
> +
> +	// W1
> +	{
> +	MIF_CH9_OFFSET,   //MODULE_MIF_CHN
> +	AIF0_CH9_OFFSET,  //MODULE_AIF0_CHN
> +	AIF1_CH9_OFFSET,  //MODULE_AIF1_CHN
> +	MCTL_CTL_MUTEX_WCH1,  //MODULE_MCTL_CHN_MUTEX
> +	DSS_MCTRL_SYS_OFFSET + MCTL_WCH1_FLUSH_EN,  //MODULE_MCTL_CHN_FLUSH_EN
> +	DSS_MCTRL_SYS_OFFSET + MCTL_WCH1_OV_IEN,  //MODULE_MCTL_CHN_OV_OEN
> +	0,  //MODULE_MCTL_CHN_STARTY
> +	0,  //MODULE_MCTL_CHN_MOD_DBG
> +	DSS_WCH1_DMA_OFFSET,  //MODULE_DMA
> +	DSS_WCH1_DFC_OFFSET,  //MODULE_DFC
> +	0,  //MODULE_SCL
> +	0,  //MODULE_SCL_LUT
> +	0,  //MODULE_ARSR2P
> +	0,  //MODULE_ARSR2P_LUT
> +	0, //MODULE_POST_CLIP_ES
> +	0,  //MODULE_POST_CLIP
> +	0,  //MODULE_PCSC
> +	DSS_WCH1_CSC_OFFSET,  //MODULE_CSC
> +	},
> +
> +	// V2
> +	{
> +	MIF_CH10_OFFSET,   //MODULE_MIF_CHN
> +	AIF0_CH11_OFFSET,  //MODULE_AIF0_CHN
> +	AIF1_CH11_OFFSET,  //MODULE_AIF1_CHN
> +	MCTL_CTL_MUTEX_RCH8,  //MODULE_MCTL_CHN_MUTEX
> +	DSS_MCTRL_SYS_OFFSET + MCTL_RCH8_FLUSH_EN,  //MODULE_MCTL_CHN_FLUSH_EN
> +	DSS_MCTRL_SYS_OFFSET + MCTL_RCH8_OV_OEN,  //MODULE_MCTL_CHN_OV_OEN
> +	0,  //MODULE_MCTL_CHN_STARTY
> +	DSS_MCTRL_SYS_OFFSET + MCTL_MOD8_DBG,  //MODULE_MCTL_CHN_MOD_DBG
> +	DSS_RCH_VG2_DMA_OFFSET,  //MODULE_DMA
> +	DSS_RCH_VG2_DFC_OFFSET,  //MODULE_DFC
> +	DSS_RCH_VG2_SCL_OFFSET,  //MODULE_SCL
> +	DSS_RCH_VG2_SCL_LUT_OFFSET,  //MODULE_SCL_LUT
> +	0,  //MODULE_ARSR2P
> +	0,  //MODULE_ARSR2P_LUT
> +	DSS_RCH_VG2_POST_CLIP_OFFSET_ES,  //MODULE_POST_CLIP_ES
> +	DSS_RCH_VG2_POST_CLIP_OFFSET,  //MODULE_POST_CLIP
> +	0,  //MODULE_PCSC
> +	DSS_RCH_VG2_CSC_OFFSET,  //MODULE_CSC
> +	},
> +	// W2
> +	{
> +	MIF_CH11_OFFSET,   //MODULE_MIF_CHN
> +	AIF0_CH12_OFFSET,  //MODULE_AIF0_CHN
> +	AIF1_CH12_OFFSET,  //MODULE_AIF1_CHN
> +	MCTL_CTL_MUTEX_WCH2,  //MODULE_MCTL_CHN_MUTEX
> +	DSS_MCTRL_SYS_OFFSET + MCTL_WCH2_FLUSH_EN,  //MODULE_MCTL_CHN_FLUSH_EN
> +	0,  //MODULE_MCTL_CHN_OV_OEN
> +	0,  //MODULE_MCTL_CHN_STARTY
> +	0,  //MODULE_MCTL_CHN_MOD_DBG
> +	DSS_WCH2_DMA_OFFSET,  //MODULE_DMA
> +	DSS_WCH2_DFC_OFFSET,  //MODULE_DFC
> +	0,  //MODULE_SCL
> +	0,  //MODULE_SCL_LUT
> +	0,  //MODULE_ARSR2P
> +	0,  //MODULE_ARSR2P_LUT
> +	0, //MODULE_POST_CLIP_ES
> +	0,  //MODULE_POST_CLIP
> +	0,  //MODULE_PCSC
> +	DSS_WCH2_CSC_OFFSET,  //MODULE_CSC
> +	},
> +};
> +
> +static const u32 kirin970_g_dss_module_ovl_base[DSS_MCTL_IDX_MAX][MODULE_OVL_MAX] = {
> +	{DSS_OVL0_OFFSET,
> +	DSS_MCTRL_CTL0_OFFSET},
> +
> +	{DSS_OVL1_OFFSET,
> +	DSS_MCTRL_CTL1_OFFSET},
> +
> +	{DSS_OVL2_OFFSET,
> +	DSS_MCTRL_CTL2_OFFSET},
> +
> +	{DSS_OVL3_OFFSET,
> +	DSS_MCTRL_CTL3_OFFSET},
> +
> +	{0,
> +	DSS_MCTRL_CTL4_OFFSET},
> +
> +	{0,
> +	DSS_MCTRL_CTL5_OFFSET},
> +};
> +
> +//SCF_LUT_CHN coef_idx
> +static const int kirin970_g_scf_lut_chn_coef_idx[DSS_CHN_MAX_DEFINE] = {
> +	-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
> +};
> +
> +static const u32 kirin970_g_dss_module_cap[DSS_CHN_MAX_DEFINE][MODULE_CAP_MAX] = {
> +	/* D2 */
> +	{0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1},
> +	/* D3 */
> +	{0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1},
> +	/* V0 */
> +	{0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1},
> +	/* G0 */
> +	{0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0},
> +	/* V1 */
> +	{0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1},
> +	/* G1 */
> +	{0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0},
> +	/* D0 */
> +	{0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1},
> +	/* D1 */
> +	{0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1},
> +
> +	/* W0 */
> +	{1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1},
> +	/* W1 */
> +	{1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1},
> +
> +	/* V2 */
> +	{0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1},
> +	/* W2 */
> +	{1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1},
> +};
> +
> +/* number of smrx idx for each channel */
> +static const u32 kirin970_g_dss_chn_sid_num[DSS_CHN_MAX_DEFINE] = {
> +	4, 1, 4, 4, 4, 4, 1, 1, 3, 4, 3, 3
> +};
> +
> +/* start idx of each channel */
> +/* smrx_idx = g_dss_smmu_smrx_idx[chn_idx] + (0 ~ g_dss_chn_sid_num[chn_idx]) */
> +static const u32 kirin970_g_dss_smmu_smrx_idx[DSS_CHN_MAX_DEFINE] = {
> +	0, 4, 5, 9, 13, 17, 21, 22, 26, 29, 23, 36
> +};
> +
> +void kirin970_dpe_defs(struct dss_hw_ctx *ctx)
> +{
> +	memcpy(&ctx->g_dss_module_base, &kirin970_g_dss_module_base,
> +		sizeof(kirin970_g_dss_module_base));
> +	memcpy(&ctx->g_dss_module_ovl_base, &kirin970_g_dss_module_ovl_base,
> +		sizeof(kirin970_g_dss_module_ovl_base));
> +	memcpy(&ctx->g_scf_lut_chn_coef_idx, &kirin970_g_scf_lut_chn_coef_idx,
> +		sizeof(kirin970_g_scf_lut_chn_coef_idx));
> +	memcpy(&ctx->g_dss_module_cap, &kirin970_g_dss_module_cap,
> +		sizeof(kirin970_g_dss_module_cap));
> +	memcpy(&ctx->g_dss_chn_sid_num, &kirin970_g_dss_chn_sid_num,
> +		sizeof(kirin970_g_dss_chn_sid_num));
> +	memcpy(&ctx->g_dss_smmu_smrx_idx, &kirin970_g_dss_smmu_smrx_idx,
> +		sizeof(kirin970_g_dss_smmu_smrx_idx));
> +
> +	ctx->smmu_offset = DSS_SMMU_OFFSET;
> +	ctx->afbc_header_addr_align = AFBC_HEADER_ADDR_ALIGN;
> +	ctx->dss_mmbuf_clk_rate_power_off = DEFAULT_DSS_MMBUF_CLK_RATE_POWER_OFF;
> +	ctx->rot_mem_ctrl = ROT_MEM_CTRL;
> +	ctx->dither_mem_ctrl = DITHER_MEM_CTRL;
> +	ctx->arsr2p_lb_mem_ctrl = ARSR2P_LB_MEM_CTRL;
> +	ctx->pxl0_clk_rate_power_off = DEFAULT_DSS_PXL0_CLK_RATE_POWER_OFF;
> +}
> diff --git a/drivers/staging/hikey9xx/gpu/kirin970_dpe_reg.h b/drivers/staging/hikey9xx/gpu/kirin970_dpe_reg.h
> new file mode 100644
> index 000000000000..a4e9e0e84eec
> --- /dev/null
> +++ b/drivers/staging/hikey9xx/gpu/kirin970_dpe_reg.h
> @@ -0,0 +1,1188 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (c) 2016 Linaro Limited.
> + * Copyright (c) 2014-2016 Hisilicon Limited.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#ifndef __KIRIN970_DPE_REG_H__
> +#define __KIRIN970_DPE_REG_H__
> +
> +#include "kirin9xx_dpe.h"
> +
> +#define CRGPERI_PLL0_CLK_RATE	(1660000000UL)
> +#define CRGPERI_PLL2_CLK_RATE	(1920000000UL)
> +#define CRGPERI_PLL3_CLK_RATE	(1200000000UL)
> +#define CRGPERI_PLL7_CLK_RATE	(1782000000UL)
> +
> +/*core_clk: 0.65v-300M, 0.75-415M, 0.8-553.33M*/
> +#define DEFAULT_DSS_CORE_CLK_RATE_L3	(554000000UL)
> +#define DEFAULT_DSS_CORE_CLK_RATE_L2	(415000000UL)
> +
> +#define DEFAULT_DSS_CORE_CLK_RATE_ES	(400000000UL)
> +
> +/*pix0_clk: 0.65v-300M, 0.75-415M, 0.8-645M*/
> +#define DEFAULT_DSS_PXL0_CLK_RATE_L3	(645000000UL)
> +#define DEFAULT_DSS_PXL0_CLK_RATE_L2	(415000000UL)
> +#define DEFAULT_DSS_PXL0_CLK_RATE_L1	(300000000UL)
> +
> +/*mmbuf_clk: 0.65v-237.14M, 0.75-332M, 0.8-480M*/
> +#define DEFAULT_DSS_MMBUF_CLK_RATE_L3	(480000000UL)
> +#define DEFAULT_DSS_MMBUF_CLK_RATE_L2	(332000000UL)
> +
> +/*pix1_clk: 0.65v-254.57M, 0.75-415M, 0.8-594M*/
> +#define DEFAULT_DSS_PXL1_CLK_RATE_L3	(594000000UL)
> +#define DEFAULT_DSS_PXL1_CLK_RATE_L2	(415000000UL)
> +#define DEFAULT_DSS_PXL1_CLK_RATE_L1	(255000000UL)
> +
> +/*mdc_dvfs_clk: 0.65v-240M, 0.75-332M, 0.8-553.33M*/
> +#define DEFAULT_MDC_CORE_CLK_RATE_L3	(554000000UL)
> +#define DEFAULT_MDC_CORE_CLK_RATE_L2	(332000000UL)
> +#define DEFAULT_MDC_CORE_CLK_RATE_L1	(240000000UL)
> +
> +/*dss clk power off */
> +#define DEFAULT_DSS_PXL0_CLK_RATE_POWER_OFF	(238000000UL)
> +#define DEFAULT_DSS_MMBUF_CLK_RATE_POWER_OFF	(208000000UL)
> +
> +/*****************************************************************************/
> +
> +#define PEREN4	(0x040)
> +#define PERDIS4	(0x044)
> +#define PERRSTEN0	(0x060)
> +#define PERRSTDIS5	(0x0A0)
> +#define PEREN6	(0x410)
> +#define PERDIS6	(0x414)
> +
> +//SYSCTRL
> +#define SCISODIS	(0x044)
> +#define SCPWREN	(0x060)
> +#define SCPEREN1	(0x170)
> +#define SCPERDIS1	(0x174)
> +#define SCPEREN4	(0x1B0)
> +#define SCPERDIS4	(0x1B4)
> +#define SCPERRSTDIS1	(0x210)
> +
> +//PCTRL
> +#define PERI_CTRL33	(0x088)
> +
> +/*****************************************************************************/
> +
> +
> +/* MODULE BASE ADDRESS */
> +
> +//SMMU
> +#define DSS_SMMU_OFFSET	(0x80000)
> +
> +// RCH_V
> +#define DSS_RCH_VG0_POST_CLIP_OFFSET_ES	(0x203A0)
> +#define DSS_RCH_VG0_POST_CLIP_OFFSET	(0x20480)
> +
> +#define DSS_RCH_VG1_POST_CLIP_OFFSET_ES	(0x283A0)
> +#define DSS_RCH_VG1_POST_CLIP_OFFSET	(0x28480)
> +
> +#define DSS_RCH_VG2_POST_CLIP_OFFSET_ES	(0x303A0)
> +#define DSS_RCH_VG2_POST_CLIP_OFFSET	(0x30480)
> +#define DSS_RCH_VG2_SCL_LUT_OFFSET		(0x31000)   //ES
> +
> +// RCH_G
> +#define DSS_RCH_G0_POST_CLIP_OFFSET_ES		(0x383A0)
> +#define DSS_RCH_G0_POST_CLIP_OFFSET		(0x38480)
> +
> +#define DSS_RCH_G1_POST_CLIP_OFFSET_ES	(0x403A0)
> +#define DSS_RCH_G1_POST_CLIP_OFFSET		(0x40480)
> +
> +// RCH_D
> +
> +// WCH
> +#define DSS_WCH0_BITEXT_OFFSET		(0x5A140)
> +#define DSS_WCH0_DITHER_OFFSET            (0x5A1D0)
> +#define DSS_WCH0_PCSC_OFFSET			(0x5A400)
> +#define DSS_WCH0_ROT_OFFSET			(0x5A530)
> +#define DSS_WCH0_FBCE_CREG_CTRL_GATE (0x5A964)
> +
> +#define DSS_WCH1_BITEXT_OFFSET		(0x5C140)
> +#define DSS_WCH1_DITHER_OFFSET            (0x5C1D0)
> +#define DSS_WCH1_SCL_OFFSET			(0x5C200)
> +#define DSS_WCH1_PCSC_OFFSET			(0x5C400)
> +#define DSS_WCH1_ROT_OFFSET			(0x5C530)
> +#define DSS_WCH1_FBCE_CREG_CTRL_GATE	(0x5C964)
> +
> +// DPP
> +#define DSS_DPP_CLIP_OFFSET	(0x70180)
> +#define DSS_DPP_XCC_OFFSET	(0x70900)
> +#define DSS_DPP_DEGAMMA_OFFSET	(0x70950)
> +#define DSS_DPP_GMP_OFFSET	(0x709A0)
> +#define DSS_DPP_ARSR_POST_OFFSET	(0x70A00)
> +#define DSS_DPP_GMP_LUT_OFFSET	(0x73000)
> +#define DSS_DPP_GAMA_PRE_LUT_OFFSET	(0x75000)
> +#define DSS_DPP_DEGAMMA_LUT_OFFSET	(0x78000)
> +#define DSS_DPP_ARSR_POST_LUT_OFFSET	(0x7B000)
> +
> +//for boston es
> +#define DSS_DPP_LCP_OFFSET_ES	(0x70900)
> +#define DSS_DPP_LCP_LUT_OFFSET_ES	(0x73000)
> +
> +// POST SCF
> +#define DSS_POST_SCF_OFFSET	DSS_DPP_ARSR_POST_OFFSET
> +#define DSS_POST_SCF_LUT_OFFSET	DSS_DPP_ARSR_POST_LUT_OFFSET
> +//POST SCF for ES
> +#define DSS_POST_SCF_LUT_OFFSET_ES	(0x7B000)
> +
> +/* AIF */
> +
> +//(0x0004+0x20*n)
> +#define AIF_CH_HS	(0x0004)
> +//(0x0008+0x20*n)
> +#define AIF_CH_LS	(0x0008)
> +
> +/* SMMU */
> +
> +#define SMMU_SMRx_P	(0x10000)
> +#define SMMU_RLD_EN0_P	(0x101F0)
> +#define SMMU_RLD_EN1_P	(0x101F4)
> +#define SMMU_RLD_EN2_P	(0x101F8)
> +#define SMMU_INTMAS_P	(0x10200)
> +#define SMMU_INTRAW_P	(0x10204)
> +#define SMMU_INTSTAT_P	(0x10208)
> +#define SMMU_INTCLR_P	(0x1020C)
> +#define SMMU_SCR_P		(0x10210)
> +#define SMMU_PCB_SCTRL	(0x10214)
> +#define SMMU_PCB_TTBR	(0x10218)
> +#define SMMU_PCB_TTBCR	(0x1021C)
> +#define SMMU_OFFSET_ADDR_P	(0x10220)
> +
> +/* DFC */
> +#define DFC_GLB_ALPHA01		(0x0008)
> +#define DFC_GLB_ALPHA23		(0x0028)
> +#define DFC_BITEXT_CTL		(0x0040)
> +#define DFC_DITHER_CTL1      (0x00D0)
> +
> +/* SCF */
> +
> +/* MACROS */
> +#define SCF_MIN_INPUT	(16) //SCF min input pix 16x16
> +#define SCF_MIN_OUTPUT	(16) //SCF min output pix 16x16
> +
> +#define SCF_INC_FACTOR	BIT(18) //(262144)
> +
> +/* ARSR2P ES  v0 */
> +#define ARSR2P_INPUT_WIDTH_HEIGHT_ES	(0x000)
> +#define ARSR2P_OUTPUT_WIDTH_HEIGHT_ES	(0x004)
> +#define ARSR2P_IHLEFT_ES	(0x008)
> +#define ARSR2P_IHRIGHT_ES	(0x00C)
> +#define ARSR2P_IVTOP_ES		(0x010)
> +#define ARSR2P_IVBOTTOM_ES	(0x014)
> +#define ARSR2P_IHINC_ES		(0x018)
> +#define ARSR2P_IVINC_ES		(0x01C)
> +#define ARSR2P_UV_OFFSET_ES	(0x020)
> +#define ARSR2P_MODE_ES		(0x024)
> +#define ARSR2P_SKIN_THRES_Y_ES	(0x028)
> +#define ARSR2P_SKIN_THRES_U_ES	(0x02C)
> +#define ARSR2P_SKIN_THRES_V_ES	(0x030)
> +#define ARSR2P_SKIN_CFG0_ES	(0x034)
> +#define ARSR2P_SKIN_CFG1_ES	(0x038)
> +#define ARSR2P_SKIN_CFG2_ES	(0x03C)
> +#define ARSR2P_SHOOT_CFG1_ES	(0x040)
> +#define ARSR2P_SHOOT_CFG2_ES	(0x044)
> +#define ARSR2P_SHARP_CFG1_ES	(0x048)
> +#define ARSR2P_SHARP_CFG2_ES	(0x04C)
> +#define ARSR2P_SHARP_CFG3_ES	(0x050)
> +#define ARSR2P_SHARP_CFG4_ES	(0x054)
> +#define ARSR2P_SHARP_CFG5_ES	(0x058)
> +#define ARSR2P_SHARP_CFG6_ES	(0x05C)
> +#define ARSR2P_SHARP_CFG7_ES	(0x060)
> +#define ARSR2P_SHARP_CFG8_ES	(0x064)
> +#define ARSR2P_SHARP_CFG9_ES	(0x068)
> +#define ARSR2P_TEXTURW_ANALYSTS_ES	(0x06C)
> +#define ARSR2P_INTPLSHOOTCTRL_ES	(0x070)
> +#define ARSR2P_DEBUG0_ES	(0x074)
> +#define ARSR2P_DEBUG1_ES	(0x078)
> +#define ARSR2P_DEBUG2_ES	(0x07C)
> +#define ARSR2P_DEBUG3_ES	(0x080)
> +#define ARSR2P_LB_MEM_CTRL_ES	(0x084)
> +#define ARSR2P_IHLEFT1_ES	(0x088)
> +#define ARSR2P_IHRIGHT1_ES	(0x090)
> +#define ARSR2P_IVBOTTOM1_ES	(0x094)
> +
> +#define ARSR2P_LUT_COEFY_V_OFFSET_ES	(0x0000)
> +#define ARSR2P_LUT_COEFY_H_OFFSET_ES	(0x0100)
> +#define ARSR2P_LUT_COEFA_V_OFFSET_ES	(0x0300)
> +#define ARSR2P_LUT_COEFA_H_OFFSET_ES	(0x0400)
> +#define ARSR2P_LUT_COEFUV_V_OFFSET_ES	(0x0600)
> +#define ARSR2P_LUT_COEFUV_H_OFFSET_ES	(0x0700)
> +
> +/* ARSR2P  v0 */
> +#define ARSR2P_IHLEFT1 (0x00C)
> +#define ARSR2P_IHRIGHT (0x010)
> +#define ARSR2P_IHRIGHT1 (0x014)
> +#define ARSR2P_IVTOP (0x018)
> +#define ARSR2P_IVBOTTOM (0x01C)
> +#define ARSR2P_IVBOTTOM1 (0x020)
> +#define ARSR2P_IHINC (0x024)
> +#define ARSR2P_IVINC (0x028)
> +#define ARSR2P_OFFSET (0x02C)
> +#define ARSR2P_MODE (0x030)
> +#define ARSR2P_SKIN_THRES_Y (0x034)
> +#define ARSR2P_SKIN_THRES_U (0x038)
> +#define ARSR2P_SKIN_THRES_V (0x03C)
> +#define ARSR2P_SKIN_CFG0 (0x040)
> +#define ARSR2P_SKIN_CFG1 (0x044)
> +#define ARSR2P_SKIN_CFG2 (0x048)
> +#define ARSR2P_SHOOT_CFG1 (0x04C)
> +#define ARSR2P_SHOOT_CFG2 (0x050)
> +#define ARSR2P_SHOOT_CFG3 (0x054)
> +#define ARSR2P_SHARP_CFG1 (0x080)
> +#define ARSR2P_SHARP_CFG2 (0x084)
> +#define ARSR2P_SHARP_CFG3 (0x088)
> +#define ARSR2P_SHARP_CFG4 (0x08C)
> +#define ARSR2P_SHARP_CFG5 (0x090)
> +#define ARSR2P_SHARP_CFG6 (0x094)
> +#define ARSR2P_SHARP_CFG7 (0x098)
> +#define ARSR2P_SHARP_CFG8 (0x09C)
> +#define ARSR2P_SHARP_CFG9 (0x0A0)
> +#define ARSR2P_SHARP_CFG10 (0x0A4)
> +#define ARSR2P_SHARP_CFG11 (0x0A8)
> +#define ARSR2P_SHARP_CFG12 (0x0AC)
> +#define ARSR2P_TEXTURW_ANALYSTS (0x0D0)
> +#define ARSR2P_INTPLSHOOTCTRL (0x0D4)
> +#define ARSR2P_DEBUG0 (0x0D8)
> +#define ARSR2P_DEBUG1 (0x0DC)
> +#define ARSR2P_DEBUG2 (0x0E0)
> +#define ARSR2P_DEBUG3 (0x0E4)
> +#define ARSR2P_LB_MEM_CTRL (0x0E8)
> +
> +/* POST_CLIP  v g */
> +#define POST_CLIP_CTL_HRZ			(0x0004)
> +#define POST_CLIP_CTL_VRZ			(0x0008)
> +#define POST_CLIP_EN				(0x000C)
> +
> +#define POST_CLIP_DISP_SIZE_ES		(0x0000)
> +#define POST_CLIP_CTL_HRZ_ES		(0x0010)
> +#define POST_CLIP_CTL_VRZ_ES		(0x0014)
> +#define POST_CLIP_EN_ES			(0x0018)
> +
> +/* CSC */
> +#define CSC_ICG_MODULE_ES	(0x0024)
> +#define CSC_P00				(0x0010)
> +#define CSC_P01				(0x0014)
> +#define CSC_P02				(0x0018)
> +#define CSC_P10				(0x001C)
> +#define CSC_P11				(0x0020)
> +#define CSC_P12				(0x0024)
> +#define CSC_P20				(0x0028)
> +#define CSC_P21				(0x002C)
> +#define CSC_P22				(0x0030)
> +#define CSC_ICG_MODULE		(0x0034)
> +
> +//AFBCE
> +#define AFBCE_HREG_HDR_PTR_L0		(0x908)
> +#define AFBCE_HREG_PLD_PTR_L0		(0x90C)
> +
> +//ROT
> +#define ROT_MEM_CTRL_ES		(0x538)
> +#define ROT_SIZE_ES			(0x53C)
> +
> +#define ROT_MEM_CTRL			(0x588)
> +#define ROT_SIZE				(0x58C)
> +#define ROT_422_MODE			(0x590)
> +
> +//REG_DEFAULT
> +
> +/* MACROS */
> +
> +/* DMA aligned limited:  128bits aligned */
> +
> +//16Bytes
> +//32BPP:1024, 16BPP 512
> +
> +#define AFBC_HEADER_ADDR_ALIGN	(16)
> +#define AFBC_HEADER_STRIDE_ALIGN	(16)
> +
> +//16Pixels
> +
> +#define MMBUF_BASE	(0x40) //(0xea800000)
> +#define MMBUF_BLOCK0_LINE_NUM	(8)
> +#define MMBUF_BLOCK0_ROT_LINE_NUM	(64)
> +#define MMBUF_BLOCK1_LINE_NUM	(16)
> +
> +#define HFBC_PIC_WIDTH_MIN	(64)
> +#define HFBC_PIC_WIDTH_ROT_MIN	(16)
> +#define HFBC_PIC_WIDTH_MAX	(512)
> +#define HFBC_PIC_WIDTH_ROT_MAX  (4096)
> +#define HFBC_PIC_HEIGHT_MIN	(8)
> +#define HFBC_PIC_HEIGHT_ROT_MIN	(32)
> +#define HFBC_PIC_HEIGHT_MAX	(8196)
> +#define HFBC_PIC_HEIGHT_ROT_MAX	(2160)
> +#define HFBC_BLOCK0_WIDTH_ALIGN	(64)
> +#define HFBC_BLOCK0_HEIGHT_ALIGN     (8)
> +#define HFBC_BLOCK1_WIDTH_ALIGN	 (32)
> +#define HFBC_BLOCK1_HEIGHT_ALIGN   (16)
> +#define HFBC_HEADER_ADDR_ALIGN	  (4)
> +#define HFBC_HEADER_STRIDE_ALIGN	  (32)
> +#define HFBC_HEADER_STRIDE_BLOCK	  (4)
> +#define HFBC_PAYLOAD0_ALIGN_8BIT       (512)
> +#define HFBC_PAYLOAD1_ALIGN_8BIT       (256)
> +#define HFBC_PAYLOAD_ALIGN_10BIT	(1024)
> +
> +#define HFBCD_BLOCK0_CROP_MAX	(7)
> +#define HFBCD_BLOCK0_ROT_CROP_MAX	(63)
> +#define HFBCD_BLOCK1_CROP_MAX	(15)
> +
> +/* MCTL  SYS */
> +//SECU
> +#define MCTL_RCH0_SECU_GATE		(0x0080)
> +#define MCTL_RCH1_SECU_GATE		(0x0084)
> +#define MCTL_RCH2_SECU_GATE		(0x0088)
> +#define MCTL_RCH3_SECU_GATE		(0x008C)
> +#define MCTL_RCH4_SECU_GATE		(0x0090)
> +#define MCTL_RCH5_SECU_GATE		(0x0094)
> +#define MCTL_RCH6_SECU_GATE		(0x0098)
> +#define MCTL_RCH7_SECU_GATE		(0x009C)
> +#define MCTL_RCH8_SECU_GATE		(0x00A0)
> +#define MCTL_OV2_SECU_GATE		(0x00B0)
> +#define MCTL_OV3_SECU_GATE		(0x00B4)
> +#define MCTL_DSI0_SECU_CFG			(0x00C0)
> +#define MCTL_DSI1_SECU_CFG			(0x00C4)
> +#define MCTL_DP_SECU_GATE			(0x00C8)
> +#define MCTL_DSI_MUX_SECU_GATE	(0x00CC)
> +//FLUSH EN
> +//SW FOR RCH
> +#define MCTL_RCH8_OV_OEN	(0x015C)
> +//SW FOR OV
> +#define MCTL_RCH_OV0_SEL1  (0x0190)
> +#define MCTL_RCH_OV1_SEL1  (0x0194)
> +#define MCTL_RCH_OV2_SEL1  (0x0198)
> +//SW FOR WCH
> +//SW FOR OV2/3 OUTPUT
> +//SW
> +//RCH STARTY
> +#define MCTL_RCH8_STARTY	(0x01E0)
> +//LP
> +
> +//RCH
> +#define MCTL_MOD_DBG_ADD_CH_NUM (2)  // copybit
> +
> +/* SBL */
> +//SBL FOR ES
> +#define SBL_REG_FRMT_MODE_ES                          (0x0000)
> +#define SBL_REG_FRMT_DBUF_CTRL_ES                     (0x0008)
> +#define SBL_REG_FRMT_FRAME_WIDTH_7_TO_0_ES            (0x0010)
> +#define SBL_REG_FRMT_FRAME_WIDTH_15_TO_8_ES           (0x0014)
> +#define SBL_REG_FRMT_FRAME_HEIGHT_7_TO_0_ES           (0x0018)
> +#define SBL_REG_FRMT_FRAME_HEIGHT_15_TO_8_ES          (0x001c)
> +#define SBL_REG_FRMT_ROI_HOR_START_7_TO_0_ES          (0x0080)
> +#define SBL_REG_FRMT_ROI_HOR_START_15_TO_8_ES         (0x0084)
> +#define SBL_REG_FRMT_ROI_HOR_END_7_TO_0_ES            (0x0088)
> +#define SBL_REG_FRMT_ROI_HOR_END_15_TO_8_ES           (0x008c)
> +#define SBL_REG_FRMT_ROI_VER_START_7_TO_0_ES          (0x0090)
> +#define SBL_REG_FRMT_ROI_VER_START_15_TO_8_ES         (0x0094)
> +#define SBL_REG_FRMT_ROI_VER_END_7_TO_0_ES            (0x0098)
> +#define SBL_REG_FRMT_ROI_VER_END_15_TO_8_ES           (0x009c)
> +#define SBL_REG_CALC_CONTROL_0_ES                     (0x0400)
> +#define SBL_REG_CALC_CONTROL_1_ES                     (0x0404)
> +#define SBL_REG_CALC_AMBIENT_LIGHT_7_TO_0_ES          (0x0408)
> +#define SBL_REG_CALC_AMBIENT_LIGHT_15_TO_8_ES         (0x040c)
> +#define SBL_REG_CALC_BACKLIGHT_7_TO_0_ES              (0x0410)
> +#define SBL_REG_CALC_BACKLIGHT_15_TO_8_ES             (0x0414)
> +#define SBL_REG_CALC_ASSERTIVENESS_ES                 (0x0418)
> +#define SBL_REG_CALC_TF_CONTROL_ES                    (0x041c)
> +#define SBL_REG_CALC_STRENGTH_MANUAL_7_TO_0_ES        (0x0420)
> +#define SBL_REG_CALC_STRENGTH_MANUAL_9_TO_8_ES        (0x0424)
> +#define SBL_REG_CALC_GAIN_AA_MANUAL_7_TO_0_ES         (0x0428)
> +#define SBL_REG_CALC_GAIN_AA_MANUAL_11_TO_8_ES        (0x042c)
> +#define SBL_REG_CALC_ROI_FACTOR_IN_7_TO_0_ES          (0x0430)
> +#define SBL_REG_CALC_ROI_FACTOR_IN_15_TO_8_ES         (0x0434)
> +#define SBL_REG_CALC_ROI_FACTOR_OUT_7_TO_0_ES         (0x0438)
> +#define SBL_REG_CALC_ROI_FACTOR_OUT_15_TO_8_ES        (0x043c)
> +#define SBL_REG_CALC_PSR_DELTA_CHANGE_7_TO_0_ES       (0x0448)
> +#define SBL_REG_CALC_PSR_DELTA_CHANGE_15_TO_8_ES      (0x044c)
> +#define SBL_REG_CALC_PSR_DELTA_SETTLE_7_TO_0_ES       (0x0450)
> +#define SBL_REG_CALC_PSR_DELTA_SETTLE_15_TO_8_ES      (0x0454)
> +#define SBL_REG_CALC_AL_SCALE_7_TO_0_ES               (0x0458)
> +#define SBL_REG_CALC_AL_SCALE_15_TO_8_ES              (0x045c)
> +#define SBL_REG_CALC_AL_TF_STEP_SAMPLE_ES             (0x0460)
> +#define SBL_REG_CALC_AL_TF_STEP_WAIT_7_TO_0_ES        (0x0468)
> +#define SBL_REG_CALC_AL_TF_STEP_WAIT_11_TO_8_ES       (0x046c)
> +#define SBL_REG_CALC_AL_TF_STEP_WAITUP_7_TO_0_ES      (0x0470)
> +#define SBL_REG_CALC_AL_TF_STEP_WAITUP_11_TO_8_ES     (0x0474)
> +#define SBL_REG_CALC_AL_TF_STEP_SIZE_7_TO_0_ES        (0x0478)
> +#define SBL_REG_CALC_AL_TF_STEP_SIZE_11_TO_8_ES       (0x047c)
> +#define SBL_REG_CALC_AL_TF_LIMIT_7_TO_0_ES            (0x0480)
> +#define SBL_REG_CALC_AL_TF_LIMIT_15_TO_8_ES           (0x0484)
> +#define SBL_REG_CALC_AL_TF_ALPHA_ES                   (0x0488)
> +#define SBL_REG_CALC_AL_TF_ALPHA_UP_ES                (0x048c)
> +#define SBL_REG_CALC_AL_TF_NOISE_7_TO_0_ES            (0x0490)
> +#define SBL_REG_CALC_AL_TF_NOISE_15_TO_8_ES           (0x0494)
> +#define SBL_REG_CALC_AL_TF_M_INC_7_TO_0_ES            (0x0498)
> +#define SBL_REG_CALC_AL_TF_M_INC_15_TO_8_ES           (0x049c)
> +#define SBL_REG_CALC_AL_TF_K_INC_7_TO_0_ES            (0x04a0)
> +#define SBL_REG_CALC_AL_TF_K_INC_15_TO_8_ES           (0x04a4)
> +#define SBL_REG_CALC_AL_TF_M_DEC_7_TO_0_ES            (0x04a8)
> +#define SBL_REG_CALC_AL_TF_M_DEC_15_TO_8_ES           (0x04ac)
> +#define SBL_REG_CALC_AL_TF_K_DEC_7_TO_0_ES            (0x04b0)
> +#define SBL_REG_CALC_AL_TF_K_DEC_15_TO_8_ES           (0x04b4)
> +#define SBL_REG_CALC_AL_TF_AGGRESSIVENESS_ES          (0x04b8)
> +#define SBL_REG_CALC_AL_RTF_FILTER_A_7_TO_0_ES        (0x04c0)
> +#define SBL_REG_CALC_AL_RTF_FILTER_A_15_TO_8_ES       (0x04c4)
> +#define SBL_REG_CALC_AL_RTF_FILTER_B_7_TO_0_ES        (0x04c8)
> +#define SBL_REG_CALC_AL_RTF_FILTER_B_15_TO_8_ES       (0x04cc)
> +#define SBL_REG_CALC_AL_RTF_FILTER_C_7_TO_0_ES        (0x04d0)
> +#define SBL_REG_CALC_AL_RTF_FILTER_C_15_TO_8_ES       (0x04d4)
> +#define SBL_REG_CALC_AB_AL_KNEE1_7_TO_0_ES            (0x04d8)
> +#define SBL_REG_CALC_AB_AL_KNEE1_15_TO_8_ES           (0x04dc)
> +#define SBL_REG_CALC_AB_AL_KNEE2_7_TO_0_ES            (0x04e0)
> +#define SBL_REG_CALC_AB_AL_KNEE2_15_TO_8_ES           (0x04e4)
> +#define SBL_REG_CALC_AB_BL_KNEE1_7_TO_0_ES            (0x04e8)
> +#define SBL_REG_CALC_AB_BL_KNEE1_15_TO_8_ES           (0x04ec)
> +#define SBL_REG_CALC_AB_BL_KNEE2_7_TO_0_ES            (0x04f0)
> +#define SBL_REG_CALC_AB_BL_KNEE2_15_TO_8_ES           (0x04f4)
> +#define SBL_REG_CALC_BL_PANEL_MAX_7_TO_0_ES           (0x04f8)
> +#define SBL_REG_CALC_BL_PANEL_MAX_15_TO_8_ES          (0x04fc)
> +#define SBL_REG_CALC_BL_OFFSET_7_TO_0_ES              (0x0500)
> +#define SBL_REG_CALC_BL_OFFSET_15_TO_8_ES             (0x0504)
> +#define SBL_REG_CALC_BL_MIN_7_TO_0_ES                 (0x0508)
> +#define SBL_REG_CALC_BL_MIN_15_TO_8_ES                (0x050c)
> +#define SBL_REG_CALC_BL_ATTEN_ALPHA_7_TO_0_ES         (0x0510)
> +#define SBL_REG_CALC_BL_ATTEN_ALPHA_9_TO_8_ES         (0x0514)
> +#define SBL_REG_CALC_SBC1_TF_DEPTH_7_TO_0_ES          (0x0518)
> +#define SBL_REG_CALC_SBC1_TF_DEPTH_15_TO_8_ES         (0x051c)
> +#define SBL_REG_CALC_SBC1_TF_STEP_7_TO_0_ES           (0x0520)
> +#define SBL_REG_CALC_SBC1_TF_STEP_15_TO_8_ES          (0x0524)
> +#define SBL_REG_CALC_SBC1_TF_ASYM_ES                  (0x0528)
> +#define SBL_REG_CALC_SBC1_TF_DEPTH_LOG_7_TO_0_ES      (0x0530)
> +#define SBL_REG_CALC_SBC1_TF_DEPTH_LOG_15_TO_8_ES     (0x0534)
> +#define SBL_REG_CALC_SBC1_TF_STEP_LOG_7_TO_0_ES       (0x0538)
> +#define SBL_REG_CALC_SBC1_TF_STEP_LOG_15_TO_8_ES      (0x053c)
> +#define SBL_REG_CALC_SBC1_TF_ASYM_LOG_ES              (0x0540)
> +#define SBL_REG_CALC_SBC2_TF_DEPTH_7_TO_0_ES          (0x0548)
> +#define SBL_REG_CALC_SBC2_TF_DEPTH_15_TO_8_ES         (0x054c)
> +#define SBL_REG_CALC_SBC2_TF_STEP_7_TO_0_ES           (0x0550)
> +#define SBL_REG_CALC_SBC2_TF_STEP_15_TO_8_ES          (0x0554)
> +#define SBL_REG_CALC_SBC2_TF_ASYM_ES                  (0x0558)
> +#define SBL_REG_CALC_SBC2_TF_DEPTH_LOG_7_TO_0_ES      (0x0560)
> +#define SBL_REG_CALC_SBC2_TF_DEPTH_LOG_15_TO_8_ES     (0x0564)
> +#define SBL_REG_CALC_SBC2_TF_STEP_LOG_7_TO_0_ES       (0x0568)
> +#define SBL_REG_CALC_SBC2_TF_STEP_LOG_15_TO_8_ES      (0x056c)
> +#define SBL_REG_CALC_SBC2_TF_ASYM_LOG_ES              (0x0570)
> +#define SBL_REG_CALC_CALIBRATION_A_7_TO_0_ES          (0x05b8)
> +#define SBL_REG_CALC_CALIBRATION_A_15_TO_8_ES         (0x05bc)
> +#define SBL_REG_CALC_CALIBRATION_B_7_TO_0_ES          (0x05c0)
> +#define SBL_REG_CALC_CALIBRATION_B_15_TO_8_ES         (0x05c4)
> +#define SBL_REG_CALC_CALIBRATION_C_7_TO_0_ES          (0x05c8)
> +#define SBL_REG_CALC_CALIBRATION_C_15_TO_8_ES         (0x05cc)
> +#define SBL_REG_CALC_CALIBRATION_D_7_TO_0_ES          (0x05d0)
> +#define SBL_REG_CALC_CALIBRATION_D_15_TO_8_ES         (0x05d4)
> +#define SBL_REG_CALC_CALIBRATION_E_7_TO_0_ES          (0x05d8)
> +#define SBL_REG_CALC_CALIBRATION_E_15_TO_8_ES         (0x05dc)
> +#define SBL_REG_CALC_BACKLIGHT_SCALE_7_TO_0_ES        (0x05e0)
> +#define SBL_REG_CALC_BACKLIGHT_SCALE_15_TO_8_ES       (0x05e4)
> +#define SBL_REG_CALC_GAIN_AA_TF_DEPTH_7_TO_0_ES       (0x05e8)
> +#define SBL_REG_CALC_GAIN_AA_TF_DEPTH_15_TO_8_ES      (0x05ec)
> +#define SBL_REG_CALC_GAIN_AA_TF_STEP_7_TO_0_ES        (0x05f0)
> +#define SBL_REG_CALC_GAIN_AA_TF_STEP_11_TO_8_ES       (0x05f4)
> +#define SBL_REG_CALC_GAIN_AA_TF_ASYM_ES               (0x05f8)
> +#define SBL_REG_CALC_STRENGTH_LIMIT_7_TO_0_ES         (0x0600)
> +#define SBL_REG_CALC_STRENGTH_LIMIT_9_TO_8_ES         (0x0604)
> +#define SBL_REG_CALC_ICUT_HIST_MIN_ES                 (0x0608)
> +#define SBL_REG_CALC_ICUT_BL_MIN_7_TO_0_ES            (0x0610)
> +#define SBL_REG_CALC_ICUT_BL_MIN_15_TO_8_ES           (0x0614)
> +#define SBL_REG_CALC_GAIN_CA_TF_DEPTH_7_TO_0_ES       (0x0618)
> +#define SBL_REG_CALC_GAIN_CA_TF_DEPTH_15_TO_8_ES      (0x061c)
> +#define SBL_REG_CALC_GAIN_CA_TF_STEP_7_TO_0_ES        (0x0620)
> +#define SBL_REG_CALC_GAIN_CA_TF_STEP_11_TO_8_ES       (0x0624)
> +#define SBL_REG_CALC_GAIN_CA_TF_ASYM_ES               (0x0628)
> +#define SBL_REG_CALC_GAIN_MAX_7_TO_0_ES               (0x0630)
> +#define SBL_REG_CALC_GAIN_MAX_11_TO_8_ES              (0x0634)
> +#define SBL_REG_CALC_GAIN_MIDDLE_7_TO_0_ES            (0x0638)
> +#define SBL_REG_CALC_GAIN_MIDDLE_11_TO_8_ES           (0x063c)
> +#define SBL_REG_CALC_BRIGHTPR_ES                      (0x0640)
> +#define SBL_REG_CALC_BPR_CORRECT_ES                   (0x0648)
> +#define SBL_CALC_BACKLIGHT_OUT_7_TO_0_ES              (0x0650)
> +#define SBL_CALC_BACKLIGHT_OUT_15_TO_8_ES             (0x0654)
> +#define SBL_CALC_STRENGTH_INROI_OUT_7_TO_0_ES         (0x0658)
> +#define SBL_CALC_STRENGTH_INROI_OUT_9_TO_8_ES         (0x065c)
> +#define SBL_CALC_STRENGTH_OUTROI_OUT_7_TO_0_ES        (0x0660)
> +#define SBL_CALC_STRENGTH_OUTROI_OUT_9_TO_8_ES        (0x0664)
> +#define SBL_CALC_DARKENH_OUT_7_TO_0_ES                (0x0668)
> +#define SBL_CALC_DARKENH_OUT_15_TO_8_ES               (0x066c)
> +#define SBL_CALC_BRIGHTPR_OUT_ES                      (0x0670)
> +#define SBL_CALC_STAT_OUT_7_TO_0_ES                   (0x0678)
> +#define SBL_CALC_STAT_OUT_15_TO_8_ES                  (0x067c)
> +#define SBL_REG_CALC_AL_DELTA_SETTLE_7_TO_0_ES        (0x0680)
> +#define SBL_REG_CALC_AL_DELTA_SETTLE_15_TO_8_ES       (0x0684)
> +#define SBL_REG_CALC_BL_DELTA_SETTLE_7_TO_0_ES        (0x0688)
> +#define SBL_REG_CALC_BL_DELTA_SETTLE_15_TO_8_ES       (0x068c)
> +#define SBL_CALC_AL_CALIB_LUT_ADDR_I_ES               (0x06c0)
> +#define SBL_CALC_AL_CALIB_LUT_DATA_W_7_TO_0_ES        (0x06d0)
> +#define SBL_CALC_AL_CALIB_LUT_DATA_W_15_TO_8_ES       (0x06d4)
> +#define SBL_CALC_BL_IN_LUT_ADDR_I_ES                  (0x0700)
> +#define SBL_CALC_BL_IN_LUT_DATA_W_7_TO_0_ES           (0x0710)
> +#define SBL_CALC_BL_IN_LUT_DATA_W_15_TO_8_ES          (0x0714)
> +#define SBL_CALC_BL_OUT_LUT_ADDR_I_ES                 (0x0740)
> +#define SBL_CALC_BL_OUT_LUT_DATA_W_7_TO_0_ES          (0x0750)
> +#define SBL_CALC_BL_OUT_LUT_DATA_W_15_TO_8_ES         (0x0754)
> +#define SBL_CALC_BL_ATTEN_LUT_ADDR_I_ES               (0x0780)
> +#define SBL_CALC_BL_ATTEN_LUT_DATA_W_7_TO_0_ES        (0x0790)
> +#define SBL_CALC_BL_ATTEN_LUT_DATA_W_15_TO_8_ES       (0x0794)
> +#define SBL_CALC_BL_AUTO_LUT_ADDR_I_ES                (0x07c0)
> +#define SBL_CALC_BL_AUTO_LUT_DATA_W_7_TO_0_ES         (0x07d0)
> +#define SBL_CALC_BL_AUTO_LUT_DATA_W_15_TO_8_ES        (0x07d4)
> +#define SBL_CALC_AL_CHANGE_LUT_ADDR_I_ES              (0x0800)
> +#define SBL_CALC_AL_CHANGE_LUT_DATA_W_7_TO_0_ES       (0x0810)
> +#define SBL_CALC_AL_CHANGE_LUT_DATA_W_15_TO_8_ES      (0x0814)
> +#define SBL_REG_CABC_INTENSITY_7_TO_0_ES              (0x0900)
> +#define SBL_REG_CABC_INTENSITY_11_TO_8_ES             (0x0904)
> +#define SBL_REG_CABC_ICUT_SELECT_ES                   (0x0908)
> +#define SBL_REG_CABC_ICUT_MANUAL_ES                   (0x090c)
> +#define SBL_CABC_ICUT_OUT_ES                          (0x0910)
> +#define SBL_REG_CORE1_VC_CONTROL_0_ES                 (0x0c00)
> +#define SBL_REG_CORE1_IRDX_CONTROL_0_ES               (0x0c40)
> +#define SBL_REG_CORE1_IRDX_CONTROL_1_ES               (0x0c44)
> +#define SBL_REG_CORE1_IRDX_VARIANCE_ES                (0x0c4c)
> +#define SBL_REG_CORE1_IRDX_SLOPE_MAX_ES               (0x0c50)
> +#define SBL_REG_CORE1_IRDX_SLOPE_MIN_ES               (0x0c54)
> +#define SBL_REG_CORE1_IRDX_BLACK_LEVEL_7_TO_0_ES      (0x0c58)
> +#define SBL_REG_CORE1_IRDX_BLACK_LEVEL_9_TO_8_ES      (0x0c5c)
> +#define SBL_REG_CORE1_IRDX_WHITE_LEVEL_7_TO_0_ES      (0x0c60)
> +#define SBL_REG_CORE1_IRDX_WHITE_LEVEL_9_TO_8_ES      (0x0c64)
> +#define SBL_REG_CORE1_IRDX_LIMIT_AMPL_ES              (0x0c68)
> +#define SBL_REG_CORE1_IRDX_DITHER_ES                  (0x0c6c)
> +#define SBL_REG_CORE1_IRDX_STRENGTH_INROI_7_TO_0_ES   (0x0c70)
> +#define SBL_REG_CORE1_IRDX_STRENGTH_INROI_9_TO_8_ES   (0x0c74)
> +#define SBL_REG_CORE1_IRDX_STRENGTH_OUTROI_7_TO_0_ES  (0x0c78)
> +#define SBL_REG_CORE1_IRDX_STRENGTH_OUTROI_9_TO_8_ES  (0x0c7c)
> +#define SBL_CORE1_IRDX_ASYMMETRY_LUT_ADDR_I_ES        (0x0c80)
> +#define SBL_CORE1_IRDX_ASYMMETRY_LUT_DATA_W_7_TO_0_ES (0x0c84)
> +#define SBL_CORE1_IRDX_ASYMMETRY_LUT_DATA_W_11_TO_8_ES (0x0c88)
> +#define SBL_CORE1_IRDX_COLOR_LUT_ADDR_I_ES            (0x0cc0)
> +#define SBL_CORE1_IRDX_COLOR_LUT_DATA_W_7_TO_0_ES     (0x0cc4)
> +#define SBL_CORE1_IRDX_COLOR_LUT_DATA_W_11_TO_8_ES    (0x0cc8)
> +#define SBL_REG_CORE1_IRDX_FILTER_CTRL_ES             (0x0d00)
> +#define SBL_REG_CORE1_IRDX_SVARIANCE_ES               (0x0d04)
> +#define SBL_REG_CORE1_IRDX_BRIGHTPR_ES                (0x0d08)
> +#define SBL_REG_CORE1_IRDX_CONTRAST_ES                (0x0d0c)
> +#define SBL_REG_CORE1_IRDX_DARKENH_7_TO_0_ES          (0x0d10)
> +#define SBL_REG_CORE1_IRDX_DARKENH_15_TO_8_ES         (0x0d14)
> +#define SBL_REG_CORE1_DTHR_CONTROL_ES                 (0x0dc0)
> +#define SBL_REG_CORE1_LOGO_TOP_ES                     (0x0dd0)
> +#define SBL_REG_CORE1_LOGO_LEFT_ES                    (0x0dd4)
> +#define SBL_REG_CORE1_CA_D_ARTITHRESH_7_TO_0_ES       (0x0e00)
> +#define SBL_REG_CORE1_CA_D_ARTITHRESH_9_TO_8_ES       (0x0e04)
> +#define SBL_CORE1_CA_STR_ATTEN_7_TO_0_ES              (0x0e10)
> +#define SBL_CORE1_CA_STR_ATTEN_15_TO_8_ES             (0x0e14)
> +#define SBL_CORE1_CA_STR_ATTEN_16_ES                  (0x0e18)
> +#define SBL_REG_CORE1_FRD_D_THRESH_7_TO_0_ES          (0x0e20)
> +#define SBL_REG_CORE1_FRD_D_THRESH_9_TO_8_ES          (0x0e24)
> +#define SBL_REG_CORE1_REG0_7_TO_0_ES                  (0x0e28)
> +#define SBL_REG_CORE1_REG0_15_TO_8_ES                 (0x0e2c)
> +#define SBL_REG_CORE1_REG1_7_TO_0_ES                  (0x0e30)
> +#define SBL_REG_CORE1_REG1_15_TO_8_ES                 (0x0e34)
> +#define SBL_REG_CORE1_REG2_7_TO_0_ES                  (0x0e38)
> +#define SBL_REG_CORE1_REG2_15_TO_8_ES                 (0x0e3c)
> +#define SBL_REG_CORE1_REG3_7_TO_0_ES                  (0x0e40)
> +#define SBL_REG_CORE1_REG3_15_TO_8_ES                 (0x0e44)
> +#define SBL_REG_CORE1_REG4_7_TO_0_ES                  (0x0e48)
> +#define SBL_REG_CORE1_REG4_15_TO_8_ES                 (0x0e4c)
> +#define SBL_REG_CORE1_REG5_7_TO_0_ES                  (0x0e50)
> +#define SBL_REG_CORE1_REG5_15_TO_8_ES                 (0x0e54)
> +#define SBL_CORE1_REG_OUT0_7_TO_0_ES                  (0x0e58)
> +#define SBL_CORE1_REG_OUT0_15_TO_8_ES                 (0x0e5c)
> +#define SBL_CORE1_REG_OUT1_7_TO_0_ES                  (0x0e60)
> +#define SBL_CORE1_REG_OUT1_15_TO_8_ES                 (0x0e64)
> +
> +//SBL for 970
> +#define SBL_REG_FRMT_MODE                                  (0x0000)
> +#define SBL_REG_FRMT_FRAME_DIMEN                           (0x0004)
> +#define SBL_REG_FRMT_HW_VERSION                            (0x0014)
> +#define SBL_REG_FRMT_ROI_HOR                               (0x0020)
> +#define SBL_REG_FRMT_ROI_VER                               (0x0024)
> +#define SBL_REG_CALC_CONTROL                               (0x0100)
> +#define SBL_REG_AL_BL                                      (0x0104)
> +#define SBL_REG_FILTERS_CTRL                               (0x0108)
> +#define SBL_REG_MANUAL                                     (0x010c)
> +#define SBL_REG_CALC_ROI_FACTOR                            (0x0110)
> +#define SBL_REG_CALC_PSR_DELTA                             (0x0114)
> +#define SBL_REG_CALC_AL                                    (0x0118)
> +#define SBL_REG_CALC_AL_TF_STEP_WAIT                       (0x011c)
> +#define SBL_REG_CALC_AL_TF_STEP_SIZE_LIMIT                 (0x0120)
> +#define SBL_REG_CALC_AL_TF_ALPHA                           (0x0124)
> +#define SBL_REG_CALC_AL_TF_NOISE_M_INC                     (0x0128)
> +#define SBL_REG_CALC_AL_TF_K_INC_M_DEC                     (0x012c)
> +#define SBL_REG_CALC_AL_TF_K_DEC_AGGRESSIVENESS            (0x0130)
> +#define SBL_REG_CALC_AL_RTF_FILTER_A_7_TO_0                (0x0134)
> +#define SBL_REG_CALC_AL_RTF_FILTER_C_AB_AL_KNEE1           (0x0138)
> +#define SBL_REG_CALC_AB_AL_KNEE2_AB_BL_KNEE1               (0x013c)
> +#define SBL_REG_CALC_AB_BL_KNEE2_BL_PANEL_MAX              (0x0140)
> +#define SBL_REG_CALC_BL_OFFSET_BL_MIN                      (0x0144)
> +#define SBL_REG_CALC_BL_ATTEN_ALPHA_SBC1_TF_DEPTH          (0x0148)
> +#define SBL_REG_CALC_SBC1_TF_STEP_SBC1_TF_ASYM             (0x014c)
> +#define SBL_REG_CALC_SBC1_TF_DEPTH_LOG_SBC1_TF_STEP_LOG    (0x0150)
> +#define SBL_REG_CALC_SBC1_TF_ASYM_LOG_SBC2_TF_DEPTH        (0x0154)
> +#define SBL_REG_CALC_SBC2_TF_STEP_SBC2_TF_ASYM             (0x0158)
> +#define SBL_REG_CALC_SBC2_TF_DEPTH_LOG_SBC2_TF_STEP_LOG    (0x015c)
> +#define SBL_REG_CALC_SBC2_TF_ASYM_LOG                      (0x0160)
> +#define SBL_REG_CALC_CALIBRATION_A_B                       (0x0170)
> +#define SBL_REG_CALC_CALIBRATION_C_D                       (0x0174)
> +#define SBL_REG_CALC_CALIBRATION_E_BACKLIGHT_SCALE         (0x0178)
> +#define SBL_REG_CALC_GAIN_AA_TF_DEPTH_STEP                 (0x017c)
> +#define SBL_REG_CALC_GAIN_AA_TF_ASYM_STRENGTH_LIMIT        (0x0180)
> +#define SBL_REG_CALC_ICUT_HIST_MIN_ICUT_BL_MIN             (0x0184)
> +#define SBL_REG_CALC_GAIN_CA_TF_DEPTH_GAIN_CA_TF_STEP      (0x0188)
> +#define SBL_REG_CALC_GAIN_CA_TF_ASYM_GAIN_MAX              (0x018c)
> +#define SBL_REG_CALC_GAIN_MIDDLE_CALC_BRIGHTPR             (0x0190)
> +#define SBL_REG_CALC_BPR_CORRECT_CALC_BACKLIGHT_OUT        (0x0194)
> +#define SBL_CALC_STRENGTH_INROI_OUTROI_OUT                 (0x0198)
> +#define SBL_CALC_DARKENH_OUT_CALC_BRIGHTPR_OUT             (0x019c)
> +#define SBL_CALC_STAT_OUT                                  (0x01A0)
> +#define SBL_REG_CALC_BL_DELTA_SETTLE                       (0x01A4)
> +#define SBL_CALC_AL_CALIB_LUT_ADDR_I                       (0x01B0)
> +#define SBL_CALC_AL_CALIB_LUT_DATA_W                       (0x01B4)
> +#define SBL_CALC_BL_IN_LUT_ADDR_I                          (0x01C0)
> +#define SBL_CALC_BL_IN_LUT_DATA_W                          (0x01C4)
> +#define SBL_CALC_BL_OUT_LUT_ADDR_I                         (0x01D0)
> +#define SBL_CALC_BL_OUT_LUT_DATA_W                         (0x01D4)
> +#define SBL_CALC_BL_ATTEN_LUT_ADDR_I                       (0x01E0)
> +#define SBL_CALC_BL_ATTEN_LUT_DATA_W                       (0x01E4)
> +#define SBL_CALC_BL_AUTO_LUT_ADDR_I                        (0x01F0)
> +#define SBL_CALC_BL_AUTO_LUT_DATA_W                        (0x01F4)
> +#define SBL_CALC_AL_CHANGE_LUT_ADDR_I                      (0x0200)
> +#define SBL_CALC_AL_CHANGE_LUT_DATA_W                      (0x0204)
> +#define SBL_REG_CABC_INTENSITY_CABC_ICUT_SELECT            (0x0240)
> +#define SBL_REG_CABC_ICUT_MANUAL_CABC_ICUT_OUT             (0x0244)
> +#define SBL_REG_VC_VC_CONTROL_0                            (0x0300)
> +#define SBL_REG_VC_IRDX_CONTROL                            (0x0308)
> +#define SBL_REG_VC_IRDX_ALPHA_MANUAL_VC_IRDX_BETA_MANUA    (0x030c)
> +#define SBL_REG_VC_IRDX_VARIANCE                           (0x0310)
> +#define SBL_REG_VC_IRDX_SLOPE_MAX_MIN                      (0x0314)
> +#define SBL_REG_VC_IRDX_BLACK_WHITE_LEVEL_7_TO_0           (0x0318)
> +#define SBL_REG_VC_IRDX_LIMIT_AMPL_VC_IRDX_DITHER          (0x031c)
> +#define SBL_REG_VC_IRDX_STRENGTH_INROI_OUTROI              (0x0320)
> +#define SBL_CORE1_IRDX_ASYMMETRY_LUT_ADDR_I                (0x0324)
> +#define SBL_CORE1_IRDX_ASYMMETRY_LUT_DATA_W                (0x0328)
> +#define SBL_CORE1_IRDX_COLOR_LUT_ADDR_I                    (0x0334)
> +#define SBL_CORE1_IRDX_COLOR_LUT_DATA_W                    (0x0338)
> +#define SBL_REG_VC_IRDX_FILTER_CTRL                        (0x0344)
> +#define SBL_REG_VC_IRDX_BRIGHTPR                           (0x0348)
> +#define SBL_REG_VC_IRDX_CONTRAST                           (0x034c)
> +#define SBL_REG_VC_IRDX_DARKENH                            (0x0350)
> +#define SBL_REG_VC_DTHR_CONTROL                            (0x0370)
> +#define SBL_REG_VC_LOGO_TOP_LEFT                           (0x0374)
> +#define SBL_REG_VC_CA_D_ARTITHRESH                         (0x0380)
> +#define SBL_VC_CA_STR_ATTEN                                (0x0384)
> +#define SBL_REG_VC_REG1_REG2                               (0x038c)
> +#define SBL_REG_VC_REG3_REG4                               (0x0390)
> +#define SBL_REG_VC_REG5_REG_OUT0                           (0x0394)
> +#define SBL_VC_REG_OUT1                                    (0x0398)
> +#define SBL_VC_ANTI_FLCKR_CONTROL                          (0x039c)
> +#define SBL_VC_ANTI_FLCKR_RFD_FRD_THR                      (0x03a0)
> +#define SBL_VC_ANTI_FLCKR_SCD_THR_ANTI_FLCKR_FD3_SC_DLY    (0x03a4)
> +#define SBL_VC_ANTI_FLCKR_AL_ANTI_FLCKR_T_DURATION         (0x03a8)
> +#define SBL_VC_ANTI_FLCKR_ALPHA                            (0x03ac)
> +
> +/* DPP */
> +//DPP TOP
> +//#define DPP_ARSR1P_MEM_CTRL	(0x01C)
> +#define DPP_ARSR_POST_MEM_CTRL	(0x01C)
> +//#define DPP_ARSR1P	(0x048)
> +
> +//DITHER
> +#define DITHER_CTL1 (0x000)
> +#define DITHER_CTL0 (0x004)
> +#define DITHER_TRI_THD12_0 (0x008)
> +#define DITHER_TRI_THD12_1 (0x00C)
> +#define DITHER_TRI_THD10 (0x010)
> +#define DITHER_TRI_THD12_UNI_0 (0x014)
> +#define DITHER_TRI_THD12_UNI_1 (0x018)
> +#define DITHER_TRI_THD10_UNI (0x01C)
> +#define DITHER_BAYER_CTL (0x020)
> +#define DITHER_BAYER_ALPHA_THD (0x024)
> +#define DITHER_MATRIX_PART1 (0x028)
> +#define DITHER_MATRIX_PART0 (0x02C)
> +#define DITHER_HIFREQ_REG_INI_CFG_EN (0x030)
> +#define DITHER_HIFREQ_REG_INI0_0 (0x034)
> +#define DITHER_HIFREQ_REG_INI0_1 (0x038)
> +#define DITHER_HIFREQ_REG_INI0_2 (0x03C)
> +#define DITHER_HIFREQ_REG_INI0_3 (0x040)
> +#define DITHER_HIFREQ_REG_INI1_0 (0x044)
> +#define DITHER_HIFREQ_REG_INI1_1 (0x048)
> +#define DITHER_HIFREQ_REG_INI1_2 (0x04C)
> +#define DITHER_HIFREQ_REG_INI1_3 (0x050)
> +#define DITHER_HIFREQ_REG_INI2_0 (0x054)
> +#define DITHER_HIFREQ_REG_INI2_1 (0x058)
> +#define DITHER_HIFREQ_REG_INI2_2 (0x05C)
> +#define DITHER_HIFREQ_REG_INI2_3 (0x060)
> +#define DITHER_HIFREQ_POWER_CTRL (0x064)
> +#define DITHER_HIFREQ_FILT_0 (0x068)
> +#define DITHER_HIFREQ_FILT_1 (0x06C)
> +#define DITHER_HIFREQ_FILT_2 (0x070)
> +#define DITHER_HIFREQ_THD_R0 (0x074)
> +#define DITHER_HIFREQ_THD_R1 (0x078)
> +#define DITHER_HIFREQ_THD_G0 (0x07C)
> +#define DITHER_HIFREQ_THD_G1 (0x080)
> +#define DITHER_HIFREQ_THD_B0 (0x084)
> +#define DITHER_HIFREQ_THD_B1 (0x088)
> +#define DITHER_HIFREQ_DBG0 (0x08C)
> +#define DITHER_HIFREQ_DBG1 (0x090)
> +#define DITHER_HIFREQ_DBG2 (0x094)
> +#define DITHER_ERRDIFF_CTL (0x098)
> +#define DITHER_ERRDIFF_WEIGHT (0x09C)
> +#define DITHER_FRC_CTL (0x0A0)
> +#define DITHER_FRC_01_PART1 (0x0A4)
> +#define DITHER_FRC_01_PART0 (0x0A8)
> +#define DITHER_FRC_10_PART1 (0x0AC)
> +#define DITHER_FRC_10_PART0 (0x0B0)
> +#define DITHER_FRC_11_PART1 (0x0B4)
> +#define DITHER_FRC_11_PART0 (0x0B8)
> +#define DITHER_MEM_CTRL (0x0BC)
> +#define DITHER_DBG0 (0x0C0)
> +#define DITHER_DBG1 (0x0C4)
> +#define DITHER_DBG2 (0x0C8)
> +#define DITHER_CTRL2 (0x0CC)
> +
> +//Dither for ES
> +#define DITHER_PARA_ES (0x000)
> +#define DITHER_CTL_ES (0x004)
> +#define DITHER_MATRIX_PART1_ES (0x008)
> +#define DITHER_MATRIX_PART0_ES (0x00C)
> +#define DITHER_ERRDIFF_WEIGHT_ES (0x010)
> +#define DITHER_FRC_01_PART1_ES (0x014)
> +#define DITHER_FRC_01_PART0_ES (0x018)
> +#define DITHER_FRC_10_PART1_ES (0x01C)
> +#define DITHER_FRC_10_PART0_ES (0x020)
> +#define DITHER_FRC_11_PART1_ES (0x024)
> +#define DITHER_FRC_11_PART0_ES (0x028)
> +#define DITHER_MEM_CTRL_ES (0x02C)
> +#define DITHER_DBG0_ES (0x030)
> +#define DITHER_DBG1_ES (0x034)
> +#define DITHER_DBG2_ES (0x038)
> +
> +//CSC_RGB2YUV_10bits  CSC_YUV2RGB_10bits
> +
> +//GAMA
> +#define GAMA_LUT_SEL (0x008)
> +#define GAMA_DBG0 (0x00C)
> +#define GAMA_DBG1 (0x010)
> +
> +//ACM for ES
> +#define ACM_EN_ES            (0x000)
> +#define ACM_SATA_OFFSET_ES   (0x004)
> +#define ACM_HUESEL_ES        (0x008)
> +#define ACM_CSC_IDC0_ES      (0x00C)
> +#define ACM_CSC_IDC1_ES      (0x010)
> +#define ACM_CSC_IDC2_ES      (0x014)
> +#define ACM_CSC_P00_ES       (0x018)
> +#define ACM_CSC_P01_ES       (0x01C)
> +#define ACM_CSC_P02_ES       (0x020)
> +#define ACM_CSC_P10_ES       (0x024)
> +#define ACM_CSC_P11_ES       (0x028)
> +#define ACM_CSC_P12_ES       (0x02C)
> +#define ACM_CSC_P20_ES       (0x030)
> +#define ACM_CSC_P21_ES       (0x034)
> +#define ACM_CSC_P22_ES       (0x038)
> +#define ACM_CSC_MRREC_ES     (0x03C)
> +#define ACM_R0_H_ES          (0x040)
> +#define ACM_R1_H_ES          (0x044)
> +#define ACM_R2_H_ES          (0x048)
> +#define ACM_R3_H_ES          (0x04C)
> +#define ACM_R4_H_ES          (0x050)
> +#define ACM_R5_H_ES          (0x054)
> +#define ACM_R6_H_ES          (0x058)
> +#define ACM_LUT_DIS0_ES      (0x05C)
> +#define ACM_LUT_DIS1_ES      (0x060)
> +#define ACM_LUT_DIS2_ES      (0x064)
> +#define ACM_LUT_DIS3_ES      (0x068)
> +#define ACM_LUT_DIS4_ES      (0x06C)
> +#define ACM_LUT_DIS5_ES      (0x070)
> +#define ACM_LUT_DIS6_ES      (0x074)
> +#define ACM_LUT_DIS7_ES      (0x078)
> +#define ACM_LUT_PARAM0_ES    (0x07C)
> +#define ACM_LUT_PARAM1_ES    (0x080)
> +#define ACM_LUT_PARAM2_ES    (0x084)
> +#define ACM_LUT_PARAM3_ES    (0x088)
> +#define ACM_LUT_PARAM4_ES    (0x08C)
> +#define ACM_LUT_PARAM5_ES    (0x090)
> +#define ACM_LUT_PARAM6_ES    (0x094)
> +#define ACM_LUT_PARAM7_ES    (0x098)
> +#define ACM_LUT_SEL_ES       (0x09C)
> +#define ACM_MEM_CTRL_ES      (0x0A0)
> +#define ACM_DEBUG_TOP_ES     (0x0A4)
> +#define ACM_DEBUG_CFG_ES     (0x0A8)
> +#define ACM_DEBUG_W_ES       (0x0AC)
> +
> +//ACM
> +#define ACM_HUE_RLH01 (0x040)
> +#define ACM_HUE_RLH23 (0x044)
> +#define ACM_HUE_RLH45 (0x048)
> +#define ACM_HUE_RLH67 (0x04C)
> +#define ACM_HUE_PARAM01 (0x060)
> +#define ACM_HUE_PARAM23 (0x064)
> +#define ACM_HUE_PARAM45 (0x068)
> +#define ACM_HUE_PARAM67 (0x06C)
> +#define ACM_HUE_SMOOTH0 (0x070)
> +#define ACM_HUE_SMOOTH1 (0x074)
> +#define ACM_HUE_SMOOTH2 (0x078)
> +#define ACM_HUE_SMOOTH3 (0x07C)
> +#define ACM_HUE_SMOOTH4 (0x080)
> +#define ACM_HUE_SMOOTH5 (0x084)
> +#define ACM_HUE_SMOOTH6 (0x088)
> +#define ACM_HUE_SMOOTH7 (0x08C)
> +#define ACM_DBG_TOP (0x0A4)
> +#define ACM_DBG_CFG (0x0A8)
> +#define ACM_DBG_W (0x0AC)
> +#define ACM_COLOR_CHOOSE (0x0B0)
> +#define ACM_RGB2YUV_IDC0 (0x0C0)
> +#define ACM_RGB2YUV_IDC1 (0x0C4)
> +#define ACM_RGB2YUV_IDC2 (0x0C8)
> +#define ACM_RGB2YUV_P00 (0x0CC)
> +#define ACM_RGB2YUV_P01 (0x0D0)
> +#define ACM_RGB2YUV_P02 (0x0D4)
> +#define ACM_RGB2YUV_P10 (0x0D8)
> +#define ACM_RGB2YUV_P11 (0x0DC)
> +#define ACM_RGB2YUV_P12 (0x0E0)
> +#define ACM_RGB2YUV_P20 (0x0E4)
> +#define ACM_RGB2YUV_P21 (0x0E8)
> +#define ACM_RGB2YUV_P22 (0x0EC)
> +#define ACM_FACE_CRTL (0x100)
> +#define ACM_FACE_STARTXY (0x104)
> +#define ACM_FACE_SMOOTH_LEN01 (0x108)
> +#define ACM_FACE_SMOOTH_LEN23 (0x10C)
> +#define ACM_FACE_SMOOTH_PARAM0 (0x118)
> +#define ACM_FACE_SMOOTH_PARAM1 (0x11C)
> +#define ACM_FACE_SMOOTH_PARAM2 (0x120)
> +#define ACM_FACE_SMOOTH_PARAM3 (0x124)
> +#define ACM_FACE_SMOOTH_PARAM4 (0x128)
> +#define ACM_FACE_SMOOTH_PARAM5 (0x12C)
> +#define ACM_FACE_SMOOTH_PARAM6 (0x130)
> +#define ACM_FACE_SMOOTH_PARAM7 (0x134)
> +#define ACM_FACE_AREA_SEL (0x138)
> +#define ACM_FACE_SAT_LH (0x13C)
> +#define ACM_FACE_SAT_SMOOTH_LH (0x140)
> +#define ACM_FACE_SAT_SMO_PARAM_LH (0x148)
> +#define ACM_L_CONT_EN (0x160)
> +#define ACM_LC_PARAM01 (0x174)
> +#define ACM_LC_PARAM23 (0x178)
> +#define ACM_LC_PARAM45 (0x17C)
> +#define ACM_LC_PARAM67 (0x180)
> +#define ACM_L_ADJ_CTRL (0x1A0)
> +#define ACM_CAPTURE_CTRL (0x1B0)
> +#define ACM_CAPTURE_IN (0x1B4)
> +#define ACM_CAPTURE_OUT (0x1B8)
> +#define ACM_INK_CTRL (0x1C0)
> +#define ACM_INK_OUT (0x1C4)
> +
> +//ACE FOR ES
> +
> +//LCP
> +#define LCP_GMP_BYPASS_EN_ES	(0x030)
> +#define LCP_XCC_BYPASS_EN_ES	(0x034)
> +#define LCP_DEGAMA_EN_ES	(0x038)
> +#define LCP_DEGAMA_MEM_CTRL_ES	(0x03C)
> +#define LCP_GMP_MEM_CTRL_ES	(0x040)
> +
> +//XCC
> +#define XCC_COEF_00 (0x000)
> +#define XCC_COEF_01 (0x004)
> +#define XCC_COEF_02 (0x008)
> +#define XCC_COEF_03 (0x00C)
> +#define XCC_COEF_10 (0x010)
> +#define XCC_COEF_11 (0x014)
> +#define XCC_COEF_12 (0x018)
> +#define XCC_COEF_13 (0x01C)
> +#define XCC_COEF_20 (0x020)
> +#define XCC_COEF_21 (0x024)
> +#define XCC_COEF_22 (0x028)
> +#define XCC_COEF_23 (0x02C)
> +#define XCC_EN (0x034)
> +
> +//DEGAMMA
> +#define DEGAMA_EN (0x000)
> +#define DEGAMA_MEM_CTRL (0x004)
> +#define DEGAMA_LUT_SEL (0x008)
> +#define DEGAMA_DBG0 (0x00C)
> +#define DEGAMA_DBG1 (0x010)
> +
> +//GMP
> +#define GMP_EN (0x000)
> +#define GMP_MEM_CTRL (0x004)
> +#define GMP_LUT_SEL (0x008)
> +#define GMP_DBG_W0 (0x00C)
> +#define GMP_DBG_R0 (0x010)
> +#define GMP_DBG_R1 (0x014)
> +#define GMP_DBG_R2 (0x018)
> +
> +//ARSR1P ES
> +#define ARSR1P_IHLEFT_ES		(0x000)
> +#define ARSR1P_IHRIGHT_ES          (0x004)
> +#define ARSR1P_IHLEFT1_ES          (0x008)
> +#define ARSR1P_IHRIGHT1_ES         (0x00C)
> +#define ARSR1P_IVTOP_ES            (0x010)
> +#define ARSR1P_IVBOTTOM_ES         (0x014)
> +#define ARSR1P_UV_OFFSET_ES		(0x018)
> +#define ARSR1P_IHINC_ES            (0x01C)
> +#define ARSR1P_IVINC_ES            (0x020)
> +#define ARSR1P_MODE_ES		(0x024)
> +#define ARSR1P_FORMAT_ES           (0x028)
> +#define ARSR1P_SKIN_THRES_Y_ES	(0x02C)
> +#define ARSR1P_SKIN_THRES_U_ES	(0x030)
> +#define ARSR1P_SKIN_THRES_V_ES	(0x034)
> +#define ARSR1P_SKIN_EXPECTED_ES    (0x038)
> +#define ARSR1P_SKIN_CFG_ES		(0x03C)
> +#define ARSR1P_SHOOT_CFG1_ES		(0x040)
> +#define ARSR1P_SHOOT_CFG2_ES		(0x044)
> +#define ARSR1P_SHARP_CFG1_ES		(0x048)
> +#define ARSR1P_SHARP_CFG2_ES		(0x04C)
> +#define ARSR1P_SHARP_CFG3_ES		(0x050)
> +#define ARSR1P_SHARP_CFG4_ES		(0x054)
> +#define ARSR1P_SHARP_CFG5_ES		(0x058)
> +#define ARSR1P_SHARP_CFG6_ES		(0x05C)
> +#define ARSR1P_SHARP_CFG7_ES		(0x060)
> +#define ARSR1P_SHARP_CFG8_ES		(0x064)
> +#define ARSR1P_SHARP_CFG9_ES		(0x068)
> +#define ARSR1P_SHARP_CFG10_ES		(0x06C)
> +#define ARSR1P_SHARP_CFG11_ES		(0x070)
> +#define ARSR1P_DIFF_CTRL_ES		(0x074)
> +#define ARSR1P_LSC_CFG1_ES         (0x078)
> +#define ARSR1P_LSC_CFG2_ES         (0x07C)
> +#define ARSR1P_LSC_CFG3_ES         (0x080)
> +#define ARSR1P_FORCE_CLK_ON_CFG_ES	(0x084)
> +
> +//ARSR1P
> +
> +#define ARSR_POST_IHLEFT (0x000)
> +#define ARSR_POST_IHRIGHT (0x004)
> +#define ARSR_POST_IHLEFT1 (0x008)
> +#define ARSR_POST_IHRIGHT1 (0x00C)
> +#define ARSR_POST_IVTOP (0x010)
> +#define ARSR_POST_IVBOTTOM (0x014)
> +#define ARSR_POST_UV_OFFSET (0x018)
> +#define ARSR_POST_IHINC (0x01C)
> +#define ARSR_POST_IVINC (0x020)
> +#define ARSR_POST_MODE (0x024)
> +#define ARSR_POST_FORMAT (0x028)
> +#define ARSR_POST_SKIN_THRES_Y (0x02C)
> +#define ARSR_POST_SKIN_THRES_U (0x030)
> +#define ARSR_POST_SKIN_THRES_V (0x034)
> +#define ARSR_POST_SKIN_EXPECTED (0x038)
> +#define ARSR_POST_SKIN_CFG (0x03C)
> +#define ARSR_POST_SHOOT_CFG1 (0x040)
> +#define ARSR_POST_SHOOT_CFG2 (0x044)
> +#define ARSR_POST_SHOOT_CFG3 (0x048)
> +#define ARSR_POST_SHARP_CFG1_H (0x04C)
> +#define ARSR_POST_SHARP_CFG1_L (0x050)
> +#define ARSR_POST_SHARP_CFG2_H (0x054)
> +#define ARSR_POST_SHARP_CFG2_L (0x058)
> +#define ARSR_POST_SHARP_CFG3 (0x05C)
> +#define ARSR_POST_SHARP_CFG4 (0x060)
> +#define ARSR_POST_SHARP_CFG5 (0x064)
> +#define ARSR_POST_SHARP_CFG6 (0x068)
> +#define ARSR_POST_SHARP_CFG6_CUT (0x06C)
> +#define ARSR_POST_SHARP_CFG7 (0x070)
> +#define ARSR_POST_SHARP_CFG7_RATIO (0x074)
> +#define ARSR_POST_SHARP_CFG8 (0x078)
> +#define ARSR_POST_SHARP_CFG9 (0x07C)
> +#define ARSR_POST_SHARP_CFG10 (0x080)
> +#define ARSR_POST_SHARP_CFG11 (0x084)
> +#define ARSR_POST_DIFF_CTRL (0x088)
> +#define ARSR_POST_SKIN_SLOP_Y (0x08C)
> +#define ARSR_POST_SKIN_SLOP_U (0x090)
> +#define ARSR_POST_SKIN_SLOP_V (0x094)
> +#define ARSR_POST_FORCE_CLK_ON_CFG (0x098)
> +#define ARSR_POST_DEBUG_RW_0 (0x09C)
> +#define ARSR_POST_DEBUG_RW_1 (0x0A0)
> +#define ARSR_POST_DEBUG_RW_2 (0x0A4)
> +#define ARSR_POST_DEBUG_RO_0 (0x0A8)
> +#define ARSR_POST_DEBUG_RO_1 (0x0AC)
> +#define ARSR_POST_DEBUG_RO_2 (0x0B0)
> +
> +/* BIT EXT */
> +
> +//GAMA PRE LUT
> +#define U_GAMA_PRE_R_COEF	(0x000)
> +#define U_GAMA_PRE_G_COEF	(0x400)
> +#define U_GAMA_PRE_B_COEF	(0x800)
> +#define U_GAMA_PRE_R_LAST_COEF (0x200)
> +#define U_GAMA_PRE_G_LAST_COEF (0x600)
> +#define U_GAMA_PRE_B_LAST_COEF (0xA00)
> +
> +//ACM LUT
> +#define ACM_U_ACM_SATR_FACE_COEF (0x500)
> +#define ACM_U_ACM_LTA_COEF (0x580)
> +#define ACM_U_ACM_LTR0_COEF (0x600)
> +#define ACM_U_ACM_LTR1_COEF (0x640)
> +#define ACM_U_ACM_LTR2_COEF (0x680)
> +#define ACM_U_ACM_LTR3_COEF (0x6C0)
> +#define ACM_U_ACM_LTR4_COEF (0x700)
> +#define ACM_U_ACM_LTR5_COEF (0x740)
> +#define ACM_U_ACM_LTR6_COEF (0x780)
> +#define ACM_U_ACM_LTR7_COEF (0x7C0)
> +#define ACM_U_ACM_LH0_COFF (0x800)
> +#define ACM_U_ACM_LH1_COFF (0x880)
> +#define ACM_U_ACM_LH2_COFF (0x900)
> +#define ACM_U_ACM_LH3_COFF (0x980)
> +#define ACM_U_ACM_LH4_COFF (0xA00)
> +#define ACM_U_ACM_LH5_COFF (0xA80)
> +#define ACM_U_ACM_LH6_COFF (0xB00)
> +#define ACM_U_ACM_LH7_COFF (0xB80)
> +#define ACM_U_ACM_CH0_COFF (0xC00)
> +#define ACM_U_ACM_CH1_COFF (0xC80)
> +#define ACM_U_ACM_CH2_COFF (0xD00)
> +#define ACM_U_ACM_CH3_COFF (0xD80)
> +#define ACM_U_ACM_CH4_COFF (0xE00)
> +#define ACM_U_ACM_CH5_COFF (0xE80)
> +#define ACM_U_ACM_CH6_COFF (0xF00)
> +#define ACM_U_ACM_CH7_COFF (0xF80)
> +
> +//LCP LUT
> +#define GMP_U_GMP_COEF	(0x0000)
> +
> +#define U_DEGAMA_R_COEF	(0x0000)
> +#define U_DEGAMA_G_COEF	(0x0400)
> +#define U_DEGAMA_B_COEF	(0x0800)
> +#define U_DEGAMA_R_LAST_COEF (0x0200)
> +#define U_DEGAMA_G_LAST_COEF (0x0600)
> +#define U_DEGAMA_B_LAST_COEF (0x0A00)
> +
> +//ARSR1P LUT for ES
> +#define ARSR1P_LSC_GAIN_ES		(0x084)  //0xB07C+0x4*range27
> +#define ARSR1P_COEFF_H_Y0_ES	(0x0F0)  //0xB0E8+0x4*range9
> +#define ARSR1P_COEFF_H_Y1_ES	(0x114)  //0xB10C+0x4*range9
> +#define ARSR1P_COEFF_V_Y0_ES	(0x138)  //0xB130+0x4*range9
> +#define ARSR1P_COEFF_V_Y1_ES	(0x15C)  //0xB154+0x4*range9
> +#define ARSR1P_COEFF_H_UV0_ES	(0x180)  //0xB178+0x4*range9
> +#define ARSR1P_COEFF_H_UV1_ES	(0x1A4)  //0xB19C+0x4*range9
> +#define ARSR1P_COEFF_V_UV0_ES	(0x1C8)  //0xB1C0+0x4*range9
> +#define ARSR1P_COEFF_V_UV1_ES	(0x1EC)  //0xB1E4+0x4*range9
> +
> +//ARSR1P LUT
> +#define ARSR_POST_COEFF_H_Y0	(0x0F0)  //0xB0E8+0x4*range9
> +#define ARSR_POST_COEFF_H_Y1	(0x114)  //0xB10C+0x4*range9
> +#define ARSR_POST_COEFF_V_Y0	(0x138)  //0xB130+0x4*range9
> +#define ARSR_POST_COEFF_V_Y1	(0x15C)  //0xB154+0x4*range9
> +#define ARSR_POST_COEFF_H_UV0	(0x180)  //0xB178+0x4*range9
> +#define ARSR_POST_COEFF_H_UV1	(0x1A4)  //0xB19C+0x4*range9
> +#define ARSR_POST_COEFF_V_UV0	(0x1C8)  //0xB1C0+0x4*range9
> +#define ARSR_POST_COEFF_V_UV1	(0x1EC)  //0xB1E4+0x4*range9
> +
> +//DPE
> +#define DPE_INT_STAT (0x0000)
> +#define DPE_INT_UNMASK (0x0004)
> +#define DPE_BYPASS_ACE (0x0008)
> +#define DPE_BYPASS_ACE_STAT (0x000c)
> +#define DPE_UPDATE_LOCAL (0x0010)
> +#define DPE_LOCAL_VALID (0x0014)
> +#define DPE_GAMMA_AB_SHADOW (0x0018)
> +#define DPE_GAMMA_AB_WORK (0x001c)
> +#define DPE_GLOBAL_HIST_AB_SHADOW (0x0020)
> +#define DPE_GLOBAL_HIST_AB_WORK (0x0024)
> +#define DPE_IMAGE_INFO (0x0030)
> +#define DPE_HALF_BLOCK_INFO (0x0034)
> +#define DPE_XYWEIGHT (0x0038)
> +#define DPE_LHIST_SFT (0x003c)
> +#define DPE_ROI_START_POINT (0x0040)
> +#define DPE_ROI_WIDTH_HIGH (0x0044)
> +#define DPE_ROI_MODE_CTRL (0x0048)
> +#define DPE_ROI_HIST_STAT_MODE (0x004c)
> +#define DPE_HUE (0x0050)
> +#define DPE_SATURATION (0x0054)
> +#define DPE_VALUE (0x0058)
> +#define DPE_SKIN_GAIN (0x005c)
> +#define DPE_UP_LOW_TH (0x0060)
> +#define DPE_RGB_BLEND_WEIGHT (0x0064)
> +#define DPE_FNA_STATISTIC (0x0068)
> +#define DPE_UP_CNT (0x0070)
> +#define DPE_LOW_CNT (0x0074)
> +#define DPE_SUM_SATURATION (0x0078)
> +#define DPE_GLOBAL_HIST_LUT_ADDR (0x0080)
> +#define DPE_LHIST_EN (0x0100)
> +#define DPE_LOCAL_HIST_VxHy_2z_2z1 (0x0104)
> +#define DPE_GAMMA_EN (0x0108)
> +#define DPE_GAMMA_W (0x0108)
> +#define DPE_GAMMA_R (0x0110)
> +#define DPE_GAMMA_VxHy_3z2_3z1_3z_W (0x010c)
> +#define DPE_GAMMA_EN_HV_R (0x0110)
> +#define DPE_GAMMA_VxHy_3z2_3z1_3z_R (0x0114)
> +#define DPE_INIT_GAMMA (0x0120)
> +#define DPE_MANUAL_RELOAD (0x0124)
> +#define DPE_RAMCLK_FUNC (0x0128)
> +#define DPE_CLK_GATE (0x012c)
> +#define DPE_GAMMA_RAM_A_CFG_MEM_CTRL (0x0130)
> +#define DPE_GAMMA_RAM_B_CFG_MEM_CTRL (0x0134)
> +#define DPE_LHIST_RAM_CFG_MEM_CTRL (0x0138)
> +#define DPE_GAMMA_RAM_A_CFG_PM_CTRL (0x0140)
> +#define DPE_GAMMA_RAM_B_CFG_PM_CTRL (0x0144)
> +#define DPE_LHIST_RAM_CFG_PM_CTRL (0x0148)
> +#define DPE_SAT_GLOBAL_HIST_LUT_ADDR (0x0180)
> +#define DPE_FNA_EN (0x0200)
> +#define DPE_FNA_ADDR (0x0200)
> +#define DPE_FNA_DATA (0x0204)
> +#define DPE_FNA_VxHy (0x0204)
> +#define DPE_UPDATE_FNA (0x0208)
> +#define DPE_FNA_VALID (0x0210)
> +#define DPE_DB_PIPE_CFG (0x0220)
> +#define DPE_DB_PIPE_EXT_WIDTH (0x0224)
> +#define DPE_DB_PIPE_FULL_IMG_WIDTH (0x0228)
> +#define DPE_ACE_DBG0 (0x0300)
> +#define DPE_ACE_DBG1 (0x0304)
> +#define DPE_ACE_DBG2 (0x0308)
> +#define DPE_BYPASS_NR (0x0400)
> +#define DPE_S3_SOME_BRIGHTNESS01 (0x0410)
> +#define DPE_S3_SOME_BRIGHTNESS23 (0x0414)
> +#define DPE_S3_SOME_BRIGHTNESS4 (0x0418)
> +#define DPE_S3_MIN_MAX_SIGMA (0x0420)
> +#define DPE_S3_GREEN_SIGMA03 (0x0430)
> +#define DPE_S3_GREEN_SIGMA45 (0x0434)
> +#define DPE_S3_RED_SIGMA03 (0x0440)
> +#define DPE_S3_RED_SIGMA45 (0x0444)
> +#define DPE_S3_BLUE_SIGMA03 (0x0450)
> +#define DPE_S3_BLUE_SIGMA45 (0x0454)
> +#define DPE_S3_WHITE_SIGMA03 (0x0460)
> +#define DPE_S3_WHITE_SIGMA45 (0x0464)
> +#define DPE_S3_FILTER_LEVEL (0x0470)
> +#define DPE_S3_SIMILARITY_COEFF (0x0474)
> +#define DPE_S3_V_FILTER_WEIGHT_ADJ (0x0478)
> +#define DPE_S3_HUE (0x0480)
> +#define DPE_S3_SATURATION (0x0484)
> +#define DPE_S3_VALUE (0x0488)
> +#define DPE_S3_SKIN_GAIN (0x048c)
> +#define DPE_NR_RAMCLK_FUNC (0x0490)
> +#define DPE_NR_CLK_GATE (0x0494)
> +#define DPE_NR_RAM_A_CFG_MEM_CTRL (0x0498)
> +#define DPE_NR_RAM_A_CFG_PM_CTRL (0x049c)
> +
> +/* IFBC */
> +
> +/* LDI */
> +#define LDI_DP_DSI_SEL		(0x0080)
> +
> +/* MIPI DSI */
> +
> +#define AUTO_ULPS_MODE	(0x00E0)
> +#define AUTO_ULPS_ENTER_DELAY	(0x00E4)
> +#define AUTO_ULPS_WAKEUP_TIME	(0x00E8)
> +#define AUTO_ULPS_MIN_TIME  (0xF8)
> +#define DSI_MEM_CTRL  (0x0194)
> +#define DSI_PM_CTRL  (0x0198)
> +#define DSI_DEBUG  (0x019C)
> +
> +/* MMBUF */
> +
> +//MEDIA_CRG
> +#define MEDIA_PEREN0	(0x000)
> +#define MEDIA_PERDIS0	(0x004)
> +#define MEDIA_PERDIS1	(0x014)
> +#define MEDIA_PERDIS2	(0x024)
> +#define MEDIA_PERRSTEN0	(0x030)
> +#define MEDIA_PERRSTDIS0	(0x034)
> +#define MEDIA_PERRSTDIS1	(0x040)
> +#define MEDIA_CLKDIV8  (0x080)
> +#define MEDIA_CLKDIV9  (0x084)
> +#define MEDIA_PEREN1	(0x010)
> +#define MEDIA_PEREN2	(0x020)
> +#define PERRSTEN_GENERAL_SEC (0xA00)
> +#define PERRSTDIS_GENERAL_SEC (0xA04)
> +
> +#endif
> diff --git a/drivers/staging/hikey9xx/gpu/kirin9xx_dpe.h b/drivers/staging/hikey9xx/gpu/kirin9xx_dpe.h
> new file mode 100644
> index 000000000000..9139647e9fe5
> --- /dev/null
> +++ b/drivers/staging/hikey9xx/gpu/kirin9xx_dpe.h
> @@ -0,0 +1,2437 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +/*
> + * Copyright (c) 2016 Linaro Limited.
> + * Copyright (c) 2014-2016 Hisilicon Limited.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#ifndef __KIRIN_DPE_H__
> +#define __KIRIN_DPE_H__
> +
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/string.h>
> +#include <linux/platform_device.h>
> +#include <linux/device.h>
> +#include <linux/kernel.h>
> +#include <linux/wait.h>
> +#include <linux/bug.h>
> +#include <linux/iommu.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/regulator/driver.h>
> +#include <linux/regulator/machine.h>
> +
> +#include <drm/drm_plane.h>
> +#include <drm/drm_crtc.h>
> +
> +/* vcc name */
> +#define REGULATOR_PDP_NAME	"ldo3"

Some of the enums I checked are not used.
If their members are used then consider to use the enum
and not just an int.

> +
> +enum dss_chn_idx {
> +	DSS_RCHN_NONE = -1,
> +	DSS_RCHN_D2 = 0,
> +	DSS_RCHN_D3,
> +	DSS_RCHN_V0,
> +	DSS_RCHN_G0,
> +	DSS_RCHN_V1,
> +	DSS_RCHN_G1,
> +	DSS_RCHN_D0,
> +	DSS_RCHN_D1,
> +
> +	DSS_WCHN_W0,
> +	DSS_WCHN_W1,
> +
> +	DSS_CHN_MAX,
> +
> +	DSS_RCHN_V2 = DSS_CHN_MAX,  /*for copybit, only supported in chicago*/
> +	DSS_WCHN_W2,
> +
> +	DSS_COPYBIT_MAX,
> +};
> +
> +struct dss_rect_ltrb {
> +	s32 left;
> +	s32 top;
> +	s32 right;
> +	s32 bottom;
> +};
> +
> +enum {
> +	DSI_1_LANES = 0,
> +	DSI_2_LANES,
> +	DSI_3_LANES,
> +	DSI_4_LANES,
> +};
> +
> +enum dss_ovl_idx {
> +	DSS_OVL0 = 0,
> +	DSS_OVL1,
> +	DSS_OVL2,
> +	DSS_OVL3,
> +	DSS_OVL_IDX_MAX,
> +};
> +
> +enum lcd_orientation {
> +	LCD_LANDSCAPE = 0,
> +	LCD_PORTRAIT,
> +};
> +
> +enum lcd_format {
> +	LCD_RGB888 = 0,
> +	LCD_RGB101010,
> +	LCD_RGB565,
> +};
> +
> +enum lcd_rgb_order {
> +	LCD_RGB = 0,
> +	LCD_BGR,
> +};
> +
> +enum dss_addr {
enum not used
> +	DSS_ADDR_PLANE0 = 0,
> +	DSS_ADDR_PLANE1,
> +	DSS_ADDR_PLANE2,
> +};
> +
> +enum dss_transform {
> +	DSS_TRANSFORM_NOP = 0x0,
> +	DSS_TRANSFORM_FLIP_H = 0x01,
> +	DSS_TRANSFORM_FLIP_V = 0x02,
> +	DSS_TRANSFORM_ROT = 0x04,
> +};
> +
> +enum dss_dfc_format {
enum not used

> +	DFC_PIXEL_FORMAT_RGB_565 = 0,
> +	DFC_PIXEL_FORMAT_XRGB_4444,
> +	DFC_PIXEL_FORMAT_ARGB_4444,
> +	DFC_PIXEL_FORMAT_XRGB_5551,
> +	DFC_PIXEL_FORMAT_ARGB_5551,
> +	DFC_PIXEL_FORMAT_XRGB_8888,
> +	DFC_PIXEL_FORMAT_ARGB_8888,
> +	DFC_PIXEL_FORMAT_BGR_565,
> +	DFC_PIXEL_FORMAT_XBGR_4444,
> +	DFC_PIXEL_FORMAT_ABGR_4444,
> +	DFC_PIXEL_FORMAT_XBGR_5551,
> +	DFC_PIXEL_FORMAT_ABGR_5551,
> +	DFC_PIXEL_FORMAT_XBGR_8888,
> +	DFC_PIXEL_FORMAT_ABGR_8888,
> +
> +	DFC_PIXEL_FORMAT_YUV444,
> +	DFC_PIXEL_FORMAT_YVU444,
> +	DFC_PIXEL_FORMAT_YUYV422,
> +	DFC_PIXEL_FORMAT_YVYU422,
> +	DFC_PIXEL_FORMAT_VYUY422,
> +	DFC_PIXEL_FORMAT_UYVY422,
> +};
> +
> +enum dss_dma_format {
enum not used
> +	DMA_PIXEL_FORMAT_RGB_565 = 0,
> +	DMA_PIXEL_FORMAT_ARGB_4444,
> +	DMA_PIXEL_FORMAT_XRGB_4444,
> +	DMA_PIXEL_FORMAT_ARGB_5551,
> +	DMA_PIXEL_FORMAT_XRGB_5551,
> +	DMA_PIXEL_FORMAT_ARGB_8888,
> +	DMA_PIXEL_FORMAT_XRGB_8888,
> +
> +	DMA_PIXEL_FORMAT_RESERVED0,
> +
> +	DMA_PIXEL_FORMAT_YUYV_422_Pkg,
> +	DMA_PIXEL_FORMAT_YUV_420_SP_HP,
> +	DMA_PIXEL_FORMAT_YUV_420_P_HP,
> +	DMA_PIXEL_FORMAT_YUV_422_SP_HP,
> +	DMA_PIXEL_FORMAT_YUV_422_P_HP,
> +	DMA_PIXEL_FORMAT_AYUV_4444,
> +};
> +
> +enum dss_buf_format {
> +	DSS_BUF_LINEAR = 0,
> +	DSS_BUF_TILE,
> +};
> +
> +enum dss_blend_mode {
> +	DSS_BLEND_CLEAR = 0,
> +	DSS_BLEND_SRC,
> +	DSS_BLEND_DST,
> +	DSS_BLEND_SRC_OVER_DST,
> +	DSS_BLEND_DST_OVER_SRC,
> +	DSS_BLEND_SRC_IN_DST,
> +	DSS_BLEND_DST_IN_SRC,
> +	DSS_BLEND_SRC_OUT_DST,
> +	DSS_BLEND_DST_OUT_SRC,
> +	DSS_BLEND_SRC_ATOP_DST,
> +	DSS_BLEND_DST_ATOP_SRC,
> +	DSS_BLEND_SRC_XOR_DST,
> +	DSS_BLEND_SRC_ADD_DST,
> +	DSS_BLEND_FIX_OVER,
> +	DSS_BLEND_FIX_PER0,
> +	DSS_BLEND_FIX_PER1,
> +	DSS_BLEND_FIX_PER2,
> +	DSS_BLEND_FIX_PER3,
> +	DSS_BLEND_FIX_PER4,
> +	DSS_BLEND_FIX_PER5,
> +	DSS_BLEND_FIX_PER6,
> +	DSS_BLEND_FIX_PER7,
> +	DSS_BLEND_FIX_PER8,
> +	DSS_BLEND_FIX_PER9,
> +	DSS_BLEND_FIX_PER10,
> +	DSS_BLEND_FIX_PER11,
> +	DSS_BLEND_FIX_PER12,
> +	DSS_BLEND_FIX_PER13,
> +	DSS_BLEND_FIX_PER14,
> +	DSS_BLEND_FIX_PER15,
> +	DSS_BLEND_FIX_PER16,
> +	DSS_BLEND_FIX_PER17,
> +
> +	DSS_BLEND_MAX,
> +};
> +
> +enum dss_chn_cap {
> +	MODULE_CAP_ROT,
> +	MODULE_CAP_SCL,
> +	MODULE_CAP_CSC,
> +	MODULE_CAP_SHARPNESS_1D,
> +	MODULE_CAP_SHARPNESS_2D,
> +	MODULE_CAP_CE,
> +	MODULE_CAP_AFBCD,
> +	MODULE_CAP_AFBCE,
> +	MODULE_CAP_YUV_PLANAR,
> +	MODULE_CAP_YUV_SEMI_PLANAR,
> +	MODULE_CAP_YUV_PACKAGE,
> +	MODULE_CAP_MAX,
> +};
> +
> +enum dss_ovl_module {
> +	MODULE_OVL_BASE,
> +	MODULE_MCTL_BASE,
> +	MODULE_OVL_MAX,
> +};
> +
> +enum dss_axi_idx {
> +	AXI_CHN0 = 0,
> +	AXI_CHN1,
> +	AXI_CHN_MAX,
> +};
> +
> +enum dss_rdma_idx {
> +	DSS_RDMA0 = 0,
> +	DSS_RDMA1,
> +	DSS_RDMA2,
> +	DSS_RDMA3,
> +	DSS_RDMA4,
> +	DSS_RDMA_MAX,
> +};
> +
> +enum dss_chn_module {
> +	MODULE_MIF_CHN,
> +	MODULE_AIF0_CHN,
> +	MODULE_AIF1_CHN,
> +	MODULE_MCTL_CHN_MUTEX,
> +	MODULE_MCTL_CHN_FLUSH_EN,
> +	MODULE_MCTL_CHN_OV_OEN,
> +	MODULE_MCTL_CHN_STARTY,
> +	MODULE_MCTL_CHN_MOD_DBG,
> +	MODULE_DMA,
> +	MODULE_DFC,
> +	MODULE_SCL,
> +	MODULE_SCL_LUT,
> +	MODULE_ARSR2P,
> +	MODULE_ARSR2P_LUT,
> +	MODULE_POST_CLIP,
> +	MODULE_PCSC,
> +	MODULE_CSC,
> +	MODULE_POST_CLIP_ES,	/* Only for Kirin 970 */
> +	MODULE_CHN_MAX,
> +};
> +
> +
> +/*****************************************************************************/
> +
> +#define FB_ACCEL_HI62xx	0x1
> +#define FB_ACCEL_HI363x	0x2
> +#define FB_ACCEL_HI365x	0x4
> +#define FB_ACCEL_HI625x	0x8
> +#define FB_ACCEL_HI366x	0x10
> +#define FB_ACCEL_KIRIN970_ES  0x20
> +#define FB_ACCEL_KIRIN970  0x40
> +#define FB_ACCEL_KIRIN660  0x80
> +#define FB_ACCEL_KIRIN980_ES  0x100
> +#define FB_ACCEL_KIRIN980  0x200
> +#define FB_ACCEL_PLATFORM_TYPE_FPGA     0x10000000   //FPGA
> +#define FB_ACCEL_PLATFORM_TYPE_ASIC     0x20000000   //ASIC
> +
> +/* Kirin 970 specific data from MPI DSI */
> +
> +#define KIRIN970_DSI_MEM_CTRL	(0x0194)
> +#define KIRIN970_PHY_MODE	(0xFC)
> +
> +/******************************************************************************/
> +
> +#define DSS_WCH_MAX  (2)
> +
> +/******************************************************************************/
> +
> +#define DEFAULT_MIPI_CLK_RATE	(192 * 100000L)
> +#define DEFAULT_PCLK_DSI_RATE	(120 * 1000000L)
> +
> +#define DSS_MAX_PXL0_CLK_144M (144000000UL)
> +
> +#define DSS_ADDR  0xE8600000
> +#define DSS_DSI_ADDR	(DSS_ADDR + 0x01000)
> +#define DSS_LDI_ADDR	(DSS_ADDR + 0x7d000)
> +#define PMC_BASE	(0xFFF31000)
> +#define PERI_CRG_BASE	(0xFFF35000)
> +#define SCTRL_BASE	(0xFFF0A000)
> +#define PCTRL_BASE		(0xE8A09000)
> +
> +#define GPIO_LCD_POWER_1V2  (54)
> +#define GPIO_LCD_STANDBY    (67)
> +#define GPIO_LCD_RESETN     (65)
> +#define GPIO_LCD_GATING     (60)
> +#define GPIO_LCD_PCLK_GATING (58)
> +#define GPIO_LCD_REFCLK_GATING (59)
> +#define GPIO_LCD_SPICS         (168)
> +#define GPIO_LCD_DRV_EN        (73)
> +
> +#define GPIO_PG_SEL_A (72)
> +#define GPIO_TX_RX_A (74)
> +#define GPIO_PG_SEL_B (76)
> +#define GPIO_TX_RX_B (78)
> +
> +/******************************************************************************/
> +
> +#define DEFAULT_DSS_CORE_CLK_08V_RATE	(535000000UL)
> +#define DEFAULT_DSS_CORE_CLK_07V_RATE	(400000000UL)
> +#define DEFAULT_DSS_CORE_CLK_RATE_L1	(300000000UL)
> +#define DEFAULT_DSS_MMBUF_CLK_RATE_L1	(238000000UL)
> +
> +#define DEFAULT_PCLK_DSS_RATE	(114000000UL)
> +#define DEFAULT_PCLK_PCTRL_RATE	(80000000UL)
> +#define DSS_MAX_PXL0_CLK_288M (288000000UL)
> +
> +/*dss clk power off */
> +#define DEFAULT_DSS_CORE_CLK_RATE_POWER_OFF	(277000000UL)
> +#define DEFAULT_DSS_PXL1_CLK_RATE_POWER_OFF	(238000000UL)
> +
> +#define MMBUF_SIZE_MAX	(288 * 1024)
> +#define HISI_DSS_CMDLIST_MAX	(16)
> +#define HISI_DSS_CMDLIST_IDXS_MAX (0xFFFF)
> +#define HISI_DSS_COPYBIT_CMDLIST_IDXS	 (0xC000)
> +#define HISI_DSS_DPP_MAX_SUPPORT_BIT (0x7ff)
> +#define HISIFB_DSS_PLATFORM_TYPE  (FB_ACCEL_HI366x | FB_ACCEL_PLATFORM_TYPE_ASIC)
> +
> +#define DSS_MIF_SMMU_SMRX_IDX_STEP (16)
> +#define CRG_PERI_DIS3_DEFAULT_VAL     (0x0002F000)
> +#define SCF_LINE_BUF	(2560)
> +#define DSS_GLB_MODULE_CLK_SEL_DEFAULT_VAL  (0xF0000008)
> +#define DSS_LDI_CLK_SEL_DEFAULT_VAL    (0x00000004)
> +#define DSS_DBUF_MEM_CTRL_DEFAULT_VAL  (0x00000008)
> +#define DSS_SMMU_RLD_EN0_DEFAULT_VAL    (0xffffffff)
> +#define DSS_SMMU_RLD_EN1_DEFAULT_VAL    (0xffffff8f)
> +#define DSS_SMMU_OUTSTANDING_VAL		(0xf)
> +#define DSS_MIF_CTRL2_INVAL_SEL3_STRIDE_MASK		(0xc)
> +#define DSS_AFBCE_ENC_OS_CFG_DEFAULT_VAL			(0x7)
> +#define TUI_SEC_RCH			(DSS_RCHN_V0)
> +#define DSS_CHN_MAX_DEFINE (DSS_COPYBIT_MAX)
> +
> +/* perf stat */
> +#define DSS_DEVMEM_PERF_BASE (0xFDF10000)
> +#define CRG_PERIPH_APB_PERRSTSTAT0_REG (0x68)
> +#define CRG_PERIPH_APB_IP_RST_PERF_STAT_BIT (18)
> +#define PERF_SAMPSTOP_REG (0x10)
> +#define DEVMEM_PERF_SIZE (0x100)
> +
> +/* dp clock used for hdmi */
> +#define DEFAULT_AUXCLK_DPCTRL_RATE	16000000UL
> +#define DEFAULT_ACLK_DPCTRL_RATE_ES	288000000UL
> +#define DEFAULT_ACLK_DPCTRL_RATE_CS	207000000UL
> +#define DEFAULT_MIDIA_PPLL7_CLOCK_FREQ	1782000000UL
> +
> +#define KIRIN970_VCO_MIN_FREQ_OUTPUT         1000000 /*Boston: 1000 * 1000*/
> +#define KIRIN970_SYS_19M2   19200 /*Boston: 19.2f * 1000 */
> +
> +#define MIDIA_PPLL7_CTRL0	0x50c
> +#define MIDIA_PPLL7_CTRL1	0x510
> +
> +#define MIDIA_PPLL7_FREQ_DEVIDER_MASK	GENMASK(25, 2)
> +#define MIDIA_PPLL7_FRAC_MODE_MASK	GENMASK(25, 0)
> +
> +#define ACCESS_REGISTER_FN_MAIN_ID_HDCP           0xc500aa01
> +#define ACCESS_REGISTER_FN_SUB_ID_HDCP_CTRL   (0x55bbccf1)
> +#define ACCESS_REGISTER_FN_SUB_ID_HDCP_INT   (0x55bbccf2)
> +
> +/* DSS Registers */
> +
> +/* MACROS */
> +#define DSS_WIDTH(width)	((width) - 1)
> +#define DSS_HEIGHT(height)	((height) - 1)
> +
> +#define RES_540P	(960 * 540)
> +#define RES_720P	(1280 * 720)
> +#define RES_1080P	(1920 * 1080)
> +#define RES_1200P	(1920 * 1200)
> +#define RES_1440P	(2560 * 1440)
> +#define RES_1600P	(2560 * 1600)
> +#define RES_4K_PHONE	(3840 * 2160)
> +#define RES_4K_PAD	(3840 * 2400)
> +
> +#define DFC_MAX_CLIP_NUM	(31)
> +
> +/* for DFS */
> +/* 1480 * 144bits */
> +#define DFS_TIME	(80)
> +#define DFS_TIME_MIN	(50)
> +#define DFS_TIME_MIN_4K	(10)
> +#define DBUF0_DEPTH	(1408)
> +#define DBUF1_DEPTH	(512)
> +#define DBUF_WIDTH_BIT	(144)
> +
> +#define GET_THD_RQOS_IN(max_depth)	((max_depth) * 10 / 100)
> +#define GET_THD_RQOS_OUT(max_depth)	((max_depth) * 30 / 100)
> +#define GET_THD_WQOS_IN(max_depth)	((max_depth) * 95 / 100)
> +#define GET_THD_WQOS_OUT(max_depth)	((max_depth) * 70 / 100)
> +#define GET_THD_CG_IN(max_depth)	((max_depth) - 1)
> +#define GET_THD_CG_OUT(max_depth)	((max_depth) * 70 / 100)
> +#define GET_FLUX_REQ_IN(max_depth)	((max_depth) * 50 / 100)
> +#define GET_FLUX_REQ_OUT(max_depth)	((max_depth) * 90 / 100)
> +#define GET_THD_OTHER_DFS_CG_HOLD(max_depth)	(0x20)
> +#define GET_THD_OTHER_WR_WAIT(max_depth)	((max_depth) * 90 / 100)
> +
> +#define GET_RDMA_ROT_HQOS_ASSERT_LEV(max_depth)	((max_depth) * 30 / 100)
> +#define GET_RDMA_ROT_HQOS_REMOVE_LEV(max_depth)	((max_depth) * 60 / 100)
> +
> +#define AXI0_MAX_DSS_CHN_THRESHOLD	(3)
> +#define AXI1_MAX_DSS_CHN_THRESHOLD	(3)
> +
> +#define DEFAULT_AXI_CLK_RATE0	(120 * 1000000)
> +#define DEFAULT_AXI_CLK_RATE1	(240 * 1000000)
> +#define DEFAULT_AXI_CLK_RATE2	(360 * 1000000)
> +#define DEFAULT_AXI_CLK_RATE3	(480 * 1000000)
> +#define DEFAULT_AXI_CLK_RATE4	(667 * 1000000)
> +#define DEFAULT_AXI_CLK_RATE5	(800 * 1000000)
> +
> +/*****************************************************************************/
> +
> +#define PEREN0	(0x000)
> +#define PERDIS0	(0x004)
> +#define PEREN2	(0x020)
> +#define PERDIS2	(0x024)
> +#define PERCLKEN2	(0x028)
> +#define PERSTAT2	(0x02C)
> +#define PEREN3	(0x030)
> +#define PERDIS3	(0x034)
> +#define PERCLKEN3	(0x038)
> +#define PERSTAT3	(0x03C)
> +#define PEREN5	(0x050)
> +#define PERDIS5	(0x054)
> +#define PERCLKEN5	(0x058)
> +#define PERSTAT5	(0x05C)
> +#define PERRSTDIS0	(0x064)
> +#define PERRSTEN2	(0x078)
> +#define PERRSTDIS2	(0x07C)
> +#define PERRSTEN3	(0x084)
> +#define PERRSTDIS3	(0x088)
> +#define PERRSTSTAT3 (0x08c)
> +#define PERRSTEN4	(0x090)
> +#define PERRSTDIS4	(0x094)
> +#define PERRSTSTAT4 (0x098)
> +#define CLKDIV3	(0x0B4)
> +#define CLKDIV5	(0x0BC)
> +#define CLKDIV10	(0x0D0)
> +#define CLKDIV18	(0x0F0)
> +#define CLKDIV20	(0x0F8)
> +#define ISOEN	(0x144)
> +#define ISODIS	(0x148)
> +#define ISOSTAT	(0x14c)
> +#define PERPWREN	(0x150)
> +#define PERPWRDIS	(0x154)
> +#define PERPWRSTAT (0x158)
> +#define PERI_AUTODIV8	(0x380)
> +#define PERI_AUTODIV9	(0x384)
> +#define PERI_AUTODIV10	(0x388)
> +
> +#define NOC_POWER_IDLEREQ	(0x380)
> +#define NOC_POWER_IDLEACK	(0x384)
> +#define NOC_POWER_IDLE	(0x388)
> +
> +#define SCPERCLKEN1 (0x048)
> +#define SCCLKDIV2	(0x258)
> +#define SCCLKDIV4	(0x260)
> +
> +#define PERI_CTRL23	(0x060)
> +#define PERI_CTRL29	(0x078)
> +#define PERI_CTRL30	(0x07C)
> +#define PERI_CTRL32	(0x084)
> +#define PERI_STAT0	(0x094)
> +#define PERI_STAT1	(0x098)
> +#define PERI_STAT16	(0x0D4)
> +
> +#define PCTRL_DPHYTX_ULPSEXIT1	BIT(4)
> +#define PCTRL_DPHYTX_ULPSEXIT0	BIT(3)
> +
> +#define PCTRL_DPHYTX_CTRL1	BIT(1)
> +#define PCTRL_DPHYTX_CTRL0	BIT(0)
> +
> +/*****************************************************************************/
> +
> +#define BIT_DSS_GLB_INTS	BIT(30)
> +#define BIT_MMU_IRPT_S	BIT(29)
> +#define BIT_MMU_IRPT_NS	BIT(28)
> +#define BIT_DBG_MCTL_INTS	BIT(27)
> +#define BIT_DBG_WCH1_INTS	BIT(26)
> +#define BIT_DBG_WCH0_INTS	BIT(25)
> +#define BIT_DBG_RCH7_INTS	BIT(24)
> +#define BIT_DBG_RCH6_INTS	BIT(23)
> +#define BIT_DBG_RCH5_INTS	BIT(22)
> +#define BIT_DBG_RCH4_INTS	BIT(21)
> +#define BIT_DBG_RCH3_INTS	BIT(20)
> +#define BIT_DBG_RCH2_INTS	BIT(19)
> +#define BIT_DBG_RCH1_INTS	BIT(18)
> +#define BIT_DBG_RCH0_INTS	BIT(17)
> +#define BIT_ITF0_INTS	BIT(16)
> +#define BIT_DPP_INTS	BIT(15)
> +#define BIT_CMDLIST13	BIT(14)
> +#define BIT_CMDLIST12	BIT(13)
> +#define BIT_CMDLIST11	BIT(12)
> +#define BIT_CMDLIST10	BIT(11)
> +#define BIT_CMDLIST9	BIT(10)
> +#define BIT_CMDLIST8	BIT(9)
> +#define BIT_CMDLIST7	BIT(8)
> +#define BIT_CMDLIST6	BIT(7)
> +#define BIT_CMDLIST5	BIT(6)
> +#define BIT_CMDLIST4	BIT(5)
> +#define BIT_CMDLIST3	BIT(4)
> +#define BIT_CMDLIST2	BIT(3)
> +#define BIT_CMDLIST1	BIT(2)
> +#define BIT_CMDLIST0	BIT(1)
> +
> +#define BIT_SDP_DSS_GLB_INTS	BIT(29)
> +#define BIT_SDP_MMU_IRPT_S	BIT(28)
> +#define BIT_SDP_MMU_IRPT_NS	BIT(27)
> +#define BIT_SDP_DBG_MCTL_INTS	BIT(26)
> +#define BIT_SDP_DBG_WCH1_INTS	BIT(25)
> +#define BIT_SDP_DBG_WCH0_INTS	BIT(24)
> +#define BIT_SDP_DBG_RCH7_INTS	BIT(23)
> +#define BIT_SDP_DBG_RCH6_INTS	BIT(22)
> +#define BIT_SDP_DBG_RCH5_INTS	BIT(21)
> +#define BIT_SDP_DBG_RCH4_INTS	BIT(20)
> +#define BIT_SDP_DBG_RCH3_INTS	BIT(19)
> +#define BIT_SDP_DBG_RCH2_INTS	BIT(18)
> +#define BIT_SDP_DBG_RCH1_INTS	BIT(17)
> +#define BIT_SDP_DBG_RCH0_INTS	BIT(16)
> +#define BIT_SDP_ITF1_INTS	BIT(15)
> +#define BIT_SDP_CMDLIST13	BIT(14)
> +#define BIT_SDP_CMDLIST12	BIT(13)
> +#define BIT_SDP_CMDLIST11	BIT(12)
> +#define BIT_SDP_CMDLIST10	BIT(11)
> +#define BIT_SDP_CMDLIST9	BIT(10)
> +#define BIT_SDP_CMDLIST8	BIT(9)
> +#define BIT_SDP_CMDLIST7	BIT(8)
> +#define BIT_SDP_CMDLIST6	BIT(7)
> +#define BIT_SDP_CMDLIST5	BIT(6)
> +#define BIT_SDP_CMDLIST4	BIT(5)
> +#define BIT_SDP_CMDLIST3	BIT(4)
> +#define BIT_SDP_SDP_CMDLIST2	BIT(3)
> +#define BIT_SDP_CMDLIST1	BIT(2)
> +#define BIT_SDP_CMDLIST0	BIT(1)
> +#define BIT_SDP_RCH_CE_INTS	BIT(0)
> +
> +#define BIT_OFF_DSS_GLB_INTS	BIT(31)
> +#define BIT_OFF_MMU_IRPT_S	BIT(30)
> +#define BIT_OFF_MMU_IRPT_NS	BIT(29)
> +#define BIT_OFF_DBG_MCTL_INTS	BIT(28)
> +#define BIT_OFF_DBG_WCH1_INTS	BIT(27)
> +#define BIT_OFF_DBG_WCH0_INTS	BIT(26)
> +#define BIT_OFF_DBG_RCH7_INTS	BIT(25)
> +#define BIT_OFF_DBG_RCH6_INTS	BIT(24)
> +#define BIT_OFF_DBG_RCH5_INTS	BIT(23)
> +#define BIT_OFF_DBG_RCH4_INTS	BIT(22)
> +#define BIT_OFF_DBG_RCH3_INTS	BIT(21)
> +#define BIT_OFF_DBG_RCH2_INTS	BIT(20)
> +#define BIT_OFF_DBG_RCH1_INTS	BIT(19)
> +#define BIT_OFF_DBG_RCH0_INTS	BIT(18)
> +#define BIT_OFF_WCH1_INTS	BIT(17)
> +#define BIT_OFF_WCH0_INTS	BIT(16)
> +#define BIT_OFF_WCH0_WCH1_FRM_END_INT	BIT(15)
> +#define BIT_OFF_CMDLIST13	BIT(14)
> +#define BIT_OFF_CMDLIST12	BIT(13)
> +#define BIT_OFF_CMDLIST11	BIT(12)
> +#define BIT_OFF_CMDLIST10	BIT(11)
> +#define BIT_OFF_CMDLIST9	BIT(10)
> +#define BIT_OFF_CMDLIST8	BIT(9)
> +#define BIT_OFF_CMDLIST7	BIT(8)
> +#define BIT_OFF_CMDLIST6	BIT(7)
> +#define BIT_OFF_CMDLIST5	BIT(6)
> +#define BIT_OFF_CMDLIST4	BIT(5)
> +#define BIT_OFF_CMDLIST3	BIT(4)
> +#define BIT_OFF_CMDLIST2	BIT(3)
> +#define BIT_OFF_CMDLIST1	BIT(2)
> +#define BIT_OFF_CMDLIST0	BIT(1)
> +#define BIT_OFF_RCH_CE_INTS	BIT(0)
> +
> +#define BIT_OFF_CAM_DBG_WCH2_INTS	BIT(4)
> +#define BIT_OFF_CAM_DBG_RCH8_INTS	BIT(3)
> +#define BIT_OFF_CAM_WCH2_FRMEND_INTS  BIT(2)
> +#define BIT_OFF_CAM_CMDLIST15_INTS	BIT(1)
> +#define BIT_OFF_CAM_CMDLIST14_INTS	BIT(0)
> +
> +#define BIT_VACTIVE_CNT	BIT(14)
> +#define BIT_DSI_TE_TRI	BIT(13)
> +#define BIT_LCD_TE0_PIN	BIT(12)
> +#define BIT_LCD_TE1_PIN	BIT(11)
> +#define BIT_VACTIVE1_END	BIT(10)
> +#define BIT_VACTIVE1_START	BIT(9)
> +#define BIT_VACTIVE0_END	BIT(8)
> +#define BIT_VACTIVE0_START	BIT(7)
> +#define BIT_VFRONTPORCH	BIT(6)
> +#define BIT_VBACKPORCH	BIT(5)
> +#define BIT_VSYNC	BIT(4)
> +#define BIT_VFRONTPORCH_END	BIT(3)
> +#define BIT_LDI_UNFLOW	BIT(2)
> +#define BIT_FRM_END	BIT(1)
> +#define BIT_FRM_START	BIT(0)
> +
> +#define BIT_CTL_FLUSH_EN	BIT(21)
> +#define BIT_SCF_FLUSH_EN	BIT(19)
> +#define BIT_DPP0_FLUSH_EN	BIT(18)
> +#define BIT_DBUF1_FLUSH_EN	BIT(17)
> +#define BIT_DBUF0_FLUSH_EN	BIT(16)
> +#define BIT_OV3_FLUSH_EN	BIT(15)
> +#define BIT_OV2_FLUSH_EN	BIT(14)
> +#define BIT_OV1_FLUSH_EN	BIT(13)
> +#define BIT_OV0_FLUSH_EN	BIT(12)
> +#define BIT_WB1_FLUSH_EN	BIT(11)
> +#define BIT_WB0_FLUSH_EN	BIT(10)
> +#define BIT_DMA3_FLUSH_EN	BIT(9)
> +#define BIT_DMA2_FLUSH_EN	BIT(8)
> +#define BIT_DMA1_FLUSH_EN	BIT(7)
> +#define BIT_DMA0_FLUSH_EN	BIT(6)
> +#define BIT_RGB1_FLUSH_EN	BIT(4)
> +#define BIT_RGB0_FLUSH_EN	BIT(3)
> +#define BIT_VIG1_FLUSH_EN	BIT(1)
> +#define BIT_VIG0_FLUSH_EN	BIT(0)
> +
> +#define BIT_BUS_DBG_INT	BIT(5)
> +#define BIT_CRC_SUM_INT	BIT(4)
> +#define BIT_CRC_ITF1_INT	BIT(3)
> +#define BIT_CRC_ITF0_INT	BIT(2)
> +#define BIT_CRC_OV1_INT	BIT(1)
> +#define BIT_CRC_OV0_INT	BIT(0)
> +
> +#define BIT_SBL_SEND_FRAME_OUT	BIT(19)
> +#define BIT_SBL_STOP_FRAME_OUT	BIT(18)
> +#define BIT_SBL_BACKLIGHT_OUT	BIT(17)
> +#define BIT_SBL_DARKENH_OUT		BIT(16)
> +#define BIT_SBL_BRIGHTPTR_OUT	BIT(15)
> +#define BIT_STRENGTH_INROI_OUT	BIT(14)
> +#define BIT_STRENGTH_OUTROI_OUT	BIT(13)
> +#define BIT_DONE_OUT			BIT(12)
> +#define BIT_PPROC_DONE_OUT		BIT(11)
> +
> +#define BIT_HIACE_IND	BIT(8)
> +#define BIT_STRENGTH_INTP	BIT(7)
> +#define BIT_BACKLIGHT_INTP	BIT(6)
> +#define BIT_CE_END_IND	BIT(5)
> +#define BIT_CE_CANCEL_IND	BIT(4)
> +#define BIT_CE_LUT1_RW_COLLIDE_IND	BIT(3)
> +#define BIT_CE_LUT0_RW_COLLIDE_IND	BIT(2)
> +#define BIT_CE_HIST1_RW_COLLIDE_IND	BIT(1)
> +#define BIT_CE_HIST0_RW_COLLIDE_IND	BIT(0)
> +
> +/* MODULE BASE ADDRESS */
> +
> +#define DSS_MIPI_DSI0_OFFSET	(0x00001000)
> +#define DSS_MIPI_DSI1_OFFSET	(0x00001400)
> +
> +#define DSS_GLB0_OFFSET	(0x12000)
> +
> +#define DSS_DBG_OFFSET	(0x11000)
> +
> +#define DSS_CMDLIST_OFFSET	(0x2000)
> +
> +#define DSS_VBIF0_AIF	(0x7000)
> +#define DSS_VBIF1_AIF	(0x9000)
> +
> +#define DSS_MIF_OFFSET	(0xA000)
> +
> +#define DSS_MCTRL_SYS_OFFSET	(0x10000)
> +
> +#define DSS_MCTRL_CTL0_OFFSET	(0x10800)
> +#define DSS_MCTRL_CTL1_OFFSET	(0x10900)
> +#define DSS_MCTRL_CTL2_OFFSET	(0x10A00)
> +#define DSS_MCTRL_CTL3_OFFSET	(0x10B00)
> +#define DSS_MCTRL_CTL4_OFFSET	(0x10C00)
> +#define DSS_MCTRL_CTL5_OFFSET	(0x10D00)
> +
> +#define DSS_RCH_VG0_DMA_OFFSET	(0x20000)
> +#define DSS_RCH_VG0_DFC_OFFSET (0x20100)
> +#define DSS_RCH_VG0_SCL_OFFSET	(0x20200)
> +#define DSS_RCH_VG0_ARSR_OFFSET	(0x20300)
> +#define DSS_RCH_VG0_PCSC_OFFSET	(0x20400)
> +#define DSS_RCH_VG0_CSC_OFFSET	(0x20500)
> +#define DSS_RCH_VG0_DEBUG_OFFSET	(0x20600)
> +#define DSS_RCH_VG0_VPP_OFFSET	(0x20700)
> +#define DSS_RCH_VG0_DMA_BUF_OFFSET	(0x20800)
> +#define DSS_RCH_VG0_AFBCD_OFFSET	(0x20900)
> +#define DSS_RCH_VG0_REG_DEFAULT_OFFSET	(0x20A00)
> +#define DSS_RCH_VG0_SCL_LUT_OFFSET	(0x21000)
> +#define DSS_RCH_VG0_ARSR_LUT_OFFSET	(0x25000)
> +
> +#define DSS_RCH_VG1_DMA_OFFSET	(0x28000)
> +#define DSS_RCH_VG1_DFC_OFFSET (0x28100)
> +#define DSS_RCH_VG1_SCL_OFFSET	(0x28200)
> +#define DSS_RCH_VG1_CSC_OFFSET	(0x28500)
> +#define DSS_RCH_VG1_DEBUG_OFFSET	(0x28600)
> +#define DSS_RCH_VG1_VPP_OFFSET	(0x28700)
> +#define DSS_RCH_VG1_DMA_BUF_OFFSET	(0x28800)
> +#define DSS_RCH_VG1_AFBCD_OFFSET	(0x28900)
> +#define DSS_RCH_VG1_REG_DEFAULT_OFFSET	(0x28A00)
> +#define DSS_RCH_VG1_SCL_LUT_OFFSET	(0x29000)
> +
> +#define DSS_RCH_VG2_DMA_OFFSET	(0x30000)
> +#define DSS_RCH_VG2_DFC_OFFSET (0x30100)
> +#define DSS_RCH_VG2_SCL_OFFSET	(0x30200)
> +#define DSS_RCH_VG2_CSC_OFFSET	(0x30500)
> +#define DSS_RCH_VG2_DEBUG_OFFSET	(0x30600)
> +#define DSS_RCH_VG2_VPP_OFFSET	(0x30700)
> +#define DSS_RCH_VG2_DMA_BUF_OFFSET	(0x30800)
> +#define DSS_RCH_VG2_REG_DEFAULT_OFFSET	(0x30A00)
> +#define DSS_RCH_VG2_SCL_LUT_OFFSET	(0x31000)
> +
> +#define DSS_RCH_G0_DMA_OFFSET	(0x38000)
> +#define DSS_RCH_G0_DFC_OFFSET	(0x38100)
> +#define DSS_RCH_G0_SCL_OFFSET	(0x38200)
> +#define DSS_RCH_G0_CSC_OFFSET (0x38500)
> +#define DSS_RCH_G0_DEBUG_OFFSET (0x38600)
> +#define DSS_RCH_G0_DMA_BUF_OFFSET (0x38800)
> +#define DSS_RCH_G0_AFBCD_OFFSET (0x38900)
> +#define DSS_RCH_G0_REG_DEFAULT_OFFSET (0x38A00)
> +
> +#define DSS_RCH_G1_DMA_OFFSET	(0x40000)
> +#define DSS_RCH_G1_DFC_OFFSET	(0x40100)
> +#define DSS_RCH_G1_SCL_OFFSET	(0x40200)
> +#define DSS_RCH_G1_CSC_OFFSET (0x40500)
> +#define DSS_RCH_G1_DEBUG_OFFSET (0x40600)
> +#define DSS_RCH_G1_DMA_BUF_OFFSET (0x40800)
> +#define DSS_RCH_G1_AFBCD_OFFSET (0x40900)
> +#define DSS_RCH_G1_REG_DEFAULT_OFFSET (0x40A00)
> +
> +#define DSS_RCH_D2_DMA_OFFSET	(0x50000)
> +#define DSS_RCH_D2_DFC_OFFSET	(0x50100)
> +#define DSS_RCH_D2_CSC_OFFSET	(0x50500)
> +#define DSS_RCH_D2_DEBUG_OFFSET	(0x50600)
> +#define DSS_RCH_D2_DMA_BUF_OFFSET	(0x50800)
> +
> +#define DSS_RCH_D3_DMA_OFFSET	(0x51000)
> +#define DSS_RCH_D3_DFC_OFFSET	(0x51100)
> +#define DSS_RCH_D3_CSC_OFFSET	(0x51500)
> +#define DSS_RCH_D3_DEBUG_OFFSET	(0x51600)
> +#define DSS_RCH_D3_DMA_BUF_OFFSET	(0x51800)
> +
> +#define DSS_RCH_D0_DMA_OFFSET	(0x52000)
> +#define DSS_RCH_D0_DFC_OFFSET	(0x52100)
> +#define DSS_RCH_D0_CSC_OFFSET	(0x52500)
> +#define DSS_RCH_D0_DEBUG_OFFSET	(0x52600)
> +#define DSS_RCH_D0_DMA_BUF_OFFSET	(0x52800)
> +#define DSS_RCH_D0_AFBCD_OFFSET	(0x52900)
> +
> +#define DSS_RCH_D1_DMA_OFFSET	(0x53000)
> +#define DSS_RCH_D1_DFC_OFFSET	(0x53100)
> +#define DSS_RCH_D1_CSC_OFFSET	(0x53500)
> +#define DSS_RCH_D1_DEBUG_OFFSET	(0x53600)
> +#define DSS_RCH_D1_DMA_BUF_OFFSET	(0x53800)
> +
> +#define DSS_WCH0_DMA_OFFSET	(0x5A000)
> +#define DSS_WCH0_DFC_OFFSET	(0x5A100)
> +#define DSS_WCH0_CSC_OFFSET	(0x5A500)
> +#define DSS_WCH0_DEBUG_OFFSET	(0x5A600)
> +#define DSS_WCH0_DMA_BUFFER_OFFSET	(0x5A800)
> +#define DSS_WCH0_AFBCE_OFFSET	(0x5A900)
> +
> +#define DSS_WCH1_DMA_OFFSET	(0x5C000)
> +#define DSS_WCH1_DFC_OFFSET	(0x5C100)
> +#define DSS_WCH1_CSC_OFFSET	(0x5C500)
> +#define DSS_WCH1_DEBUG_OFFSET	(0x5C600)
> +#define DSS_WCH1_DMA_BUFFER_OFFSET	(0x5C800)
> +#define DSS_WCH1_AFBCE_OFFSET	(0x5C900)
> +
> +#define DSS_WCH2_DMA_OFFSET	(0x5E000)
> +#define DSS_WCH2_DFC_OFFSET	(0x5E100)
> +#define DSS_WCH2_CSC_OFFSET	(0x5E500)
> +#define DSS_WCH2_ROT_OFFSET	(0x5E500)
> +#define DSS_WCH2_DEBUG_OFFSET	(0x5E600)
> +#define DSS_WCH2_DMA_BUFFER_OFFSET	(0x5E800)
> +#define DSS_WCH2_AFBCE_OFFSET	(0x5E900)
> +
> +#define DSS_OVL0_OFFSET	(0x60000)
> +#define DSS_OVL1_OFFSET	(0x60400)
> +#define DSS_OVL2_OFFSET	(0x60800)
> +#define DSS_OVL3_OFFSET	(0x60C00)
> +
> +#define DSS_DBUF0_OFFSET	(0x6D000)
> +#define DSS_DBUF1_OFFSET	(0x6E000)
> +
> +#define DSS_HI_ACE_OFFSET	(0x6F000)
> +
> +#define DSS_DPP_OFFSET	(0x70000)
> +#define DSS_TOP_OFFSET	(0x70000)
> +#define DSS_DPP_COLORBAR_OFFSET	(0x70100)
> +#define DSS_DPP_DITHER_OFFSET	(0x70200)
> +#define DSS_DPP_CSC_RGB2YUV10B_OFFSET	(0x70300)
> +#define DSS_DPP_CSC_YUV2RGB10B_OFFSET	(0x70400)
> +#define DSS_DPP_GAMA_OFFSET	(0x70600)
> +#define DSS_DPP_ACM_OFFSET	(0x70700)
> +#define DSS_DPP_ACE_OFFSET	(0x70800)
> +#define DSS_DPP_GAMA_LUT_OFFSET	(0x71000)
> +#define DSS_DPP_ACM_LUT_OFFSET	(0x72000)
> +#define DSS_DPP_ACE_LUT_OFFSET	(0x79000)
> +
> +#define DSS_DPP_SBL_OFFSET	(0x7C000)
> +#define DSS_LDI0_OFFSET	(0x7D000)
> +#define DSS_IFBC_OFFSET	(0x7D800)
> +#define DSS_DSC_OFFSET	(0x7DC00)
> +#define DSS_LDI1_OFFSET	(0x7E000)
> +
> +/* GLB */
> +#define GLB_DSS_TAG	 (DSS_GLB0_OFFSET + 0x0000)
> +
> +#define GLB_APB_CTL	 (DSS_GLB0_OFFSET + 0x0004)
> +
> +#define GLB_DSS_AXI_RST_EN	(DSS_GLB0_OFFSET + 0x0118)
> +#define GLB_DSS_APB_RST_EN	(DSS_GLB0_OFFSET + 0x011C)
> +#define GLB_DSS_CORE_RST_EN	(DSS_GLB0_OFFSET + 0x0120)
> +#define GLB_PXL0_DIV2_RST_EN	(DSS_GLB0_OFFSET + 0x0124)
> +#define GLB_PXL0_DIV4_RST_EN	(DSS_GLB0_OFFSET + 0x0128)
> +#define GLB_PXL0_RST_EN	(DSS_GLB0_OFFSET + 0x012C)
> +#define GLB_PXL0_DSI_RST_EN	(DSS_GLB0_OFFSET + 0x0130)
> +#define GLB_DSS_PXL1_RST_EN	(DSS_GLB0_OFFSET + 0x0134)
> +#define GLB_MM_AXI_CLK_RST_EN	(DSS_GLB0_OFFSET + 0x0138)
> +#define GLB_AFBCD0_IP_RST_EN	(DSS_GLB0_OFFSET + 0x0140)
> +#define GLB_AFBCD1_IP_RST_EN	(DSS_GLB0_OFFSET + 0x0144)
> +#define GLB_AFBCD2_IP_RST_EN	(DSS_GLB0_OFFSET + 0x0148)
> +#define GLB_AFBCD3_IP_RST_EN	(DSS_GLB0_OFFSET + 0x014C)
> +#define GLB_AFBCD4_IP_RST_EN	(DSS_GLB0_OFFSET + 0x0150)
> +#define GLB_AFBCD5_IP_RST_EN	(DSS_GLB0_OFFSET + 0x0154)
> +#define GLB_AFBCD6_IP_RST_EN	(DSS_GLB0_OFFSET + 0x0158)
> +#define GLB_AFBCD7_IP_RST_EN	(DSS_GLB0_OFFSET + 0x015C)
> +#define GLB_AFBCE0_IP_RST_EN	(DSS_GLB0_OFFSET + 0x0160)
> +#define GLB_AFBCE1_IP_RST_EN	(DSS_GLB0_OFFSET + 0x0164)
> +
> +#define GLB_MCU_PDP_INTS	(DSS_GLB0_OFFSET + 0x20C)
> +#define GLB_MCU_PDP_INT_MSK	(DSS_GLB0_OFFSET + 0x210)
> +#define GLB_MCU_SDP_INTS	(DSS_GLB0_OFFSET + 0x214)
> +#define GLB_MCU_SDP_INT_MSK	(DSS_GLB0_OFFSET + 0x218)
> +#define GLB_MCU_OFF_INTS	(DSS_GLB0_OFFSET + 0x21C)
> +#define GLB_MCU_OFF_INT_MSK	(DSS_GLB0_OFFSET + 0x220)
> +#define GLB_MCU_OFF_CAM_INTS	(DSS_GLB0_OFFSET + 0x2B4)
> +#define GLB_MCU_OFF_CAM_INT_MSK	(DSS_GLB0_OFFSET + 0x2B8)
> +#define GLB_CPU_PDP_INTS	(DSS_GLB0_OFFSET + 0x224)
> +#define GLB_CPU_PDP_INT_MSK	(DSS_GLB0_OFFSET + 0x228)
> +#define GLB_CPU_SDP_INTS	(DSS_GLB0_OFFSET + 0x22C)
> +#define GLB_CPU_SDP_INT_MSK	(DSS_GLB0_OFFSET + 0x230)
> +#define GLB_CPU_OFF_INTS	(DSS_GLB0_OFFSET + 0x234)
> +#define GLB_CPU_OFF_INT_MSK	(DSS_GLB0_OFFSET + 0x238)
> +#define GLB_CPU_OFF_CAM_INTS	(DSS_GLB0_OFFSET + 0x2AC)
> +#define GLB_CPU_OFF_CAM_INT_MSK	(DSS_GLB0_OFFSET + 0x2B0)
> +
> +#define GLB_MODULE_CLK_SEL	(DSS_GLB0_OFFSET + 0x0300)
> +#define GLB_MODULE_CLK_EN	(DSS_GLB0_OFFSET + 0x0304)
> +
> +#define GLB_GLB0_DBG_SEL	(DSS_GLB0_OFFSET + 0x310)
> +#define GLB_GLB1_DBG_SEL	(DSS_GLB0_OFFSET + 0x314)
> +#define GLB_DBG_IRQ_CPU	(DSS_GLB0_OFFSET + 0x320)
> +#define GLB_DBG_IRQ_MCU	(DSS_GLB0_OFFSET + 0x324)
> +
> +#define GLB_TP_SEL	(DSS_GLB0_OFFSET + 0x0400)
> +#define GLB_CRC_DBG_LDI0	(DSS_GLB0_OFFSET + 0x0404)
> +#define GLB_CRC_DBG_LDI1	(DSS_GLB0_OFFSET + 0x0408)
> +#define GLB_CRC_LDI0_EN	(DSS_GLB0_OFFSET + 0x040C)
> +#define GLB_CRC_LDI0_FRM	(DSS_GLB0_OFFSET + 0x0410)
> +#define GLB_CRC_LDI1_EN	(DSS_GLB0_OFFSET + 0x0414)
> +#define GLB_CRC_LDI1_FRM	(DSS_GLB0_OFFSET + 0x0418)
> +
> +#define GLB_DSS_MEM_CTRL	(DSS_GLB0_OFFSET + 0x0600)
> +#define GLB_DSS_PM_CTRL	(DSS_GLB0_OFFSET + 0x0604)
> +
> +/* DBG */
> +#define DBG_CRC_DBG_OV0	(0x0000)
> +#define DBG_CRC_DBG_OV1	(0x0004)
> +#define DBG_CRC_DBG_SUM	(0x0008)
> +#define DBG_CRC_OV0_EN	(0x000C)
> +#define DBG_DSS_GLB_DBG_O	(0x0010)
> +#define DBG_DSS_GLB_DBG_I	(0x0014)
> +#define DBG_CRC_OV0_FRM	(0x0018)
> +#define DBG_CRC_OV1_EN	(0x001C)
> +#define DBG_CRC_OV1_FRM	(0x0020)
> +#define DBG_CRC_SUM_EN	(0x0024)
> +#define DBG_CRC_SUM_FRM	(0x0028)
> +
> +#define DBG_MCTL_INTS	(0x023C)
> +#define DBG_MCTL_INT_MSK	(0x0240)
> +#define DBG_WCH0_INTS	(0x0244)
> +#define DBG_WCH0_INT_MSK	(0x0248)
> +#define DBG_WCH1_INTS	(0x024C)
> +#define DBG_WCH1_INT_MSK	(0x0250)
> +#define DBG_RCH0_INTS	(0x0254)
> +#define DBG_RCH0_INT_MSK	(0x0258)
> +#define DBG_RCH1_INTS	(0x025C)
> +#define DBG_RCH1_INT_MSK	(0x0260)
> +#define DBG_RCH2_INTS	(0x0264)
> +#define DBG_RCH2_INT_MSK	(0x0268)
> +#define DBG_RCH3_INTS	(0x026C)
> +#define DBG_RCH3_INT_MSK	(0x0270)
> +#define DBG_RCH4_INTS	(0x0274)
> +#define DBG_RCH4_INT_MSK	(0x0278)
> +#define DBG_RCH5_INTS	(0x027C)
> +#define DBG_RCH5_INT_MSK	(0x0280)
> +#define DBG_RCH6_INTS	(0x0284)
> +#define DBG_RCH6_INT_MSK	(0x0288)
> +#define DBG_RCH7_INTS	(0x028C)
> +#define DBG_RCH7_INT_MSK	(0x0290)
> +#define DBG_DSS_GLB_INTS	(0x0294)
> +#define DBG_DSS_GLB_INT_MSK	(0x0298)
> +#define DBG_WCH2_INTS	(0x029C)
> +#define DBG_WCH2_INT_MSK	(0x02A0)
> +#define DBG_RCH8_INTS	(0x02A4)
> +#define DBG_RCH8_INT_MSK	(0x02A8)
> +
> +/* CMDLIST */
> +
> +#define CMDLIST_CH0_PENDING_CLR	(0x0000)
> +#define CMDLIST_CH0_CTRL	(0x0004)
> +#define CMDLIST_CH0_STATUS	(0x0008)
> +#define CMDLIST_CH0_STAAD	(0x000C)
> +#define CMDLIST_CH0_CURAD	(0x0010)
> +#define CMDLIST_CH0_INTE	(0x0014)
> +#define CMDLIST_CH0_INTC	(0x0018)
> +#define CMDLIST_CH0_INTS	(0x001C)
> +#define CMDLIST_CH0_SCENE	(0x0020)
> +#define CMDLIST_CH0_DBG	(0x0028)
> +
> +#define CMDLIST_DBG	(0x0700)
> +#define CMDLIST_BUF_DBG_EN	(0x0704)
> +#define CMDLIST_BUF_DBG_CNT_CLR	(0x0708)
> +#define CMDLIST_BUF_DBG_CNT	(0x070C)
> +#define CMDLIST_TIMEOUT_TH	(0x0710)
> +#define CMDLIST_START	(0x0714)
> +#define CMDLIST_ADDR_MASK_EN	(0x0718)
> +#define CMDLIST_ADDR_MASK_DIS	(0x071C)
> +#define CMDLIST_ADDR_MASK_STATUS	(0x0720)
> +#define CMDLIST_TASK_CONTINUE	(0x0724)
> +#define CMDLIST_TASK_STATUS	(0x0728)
> +#define CMDLIST_CTRL	(0x072C)
> +#define CMDLIST_SECU	(0x0730)
> +#define CMDLIST_INTS	(0x0734)
> +#define CMDLIST_SWRST	(0x0738)
> +#define CMD_MEM_CTRL	(0x073C)
> +#define CMD_CLK_SEL		(0x0740)
> +#define CMD_CLK_EN	(0x0744)
> +
> +#define HISI_DSS_MIN_ROT_AFBCE_BLOCK_SIZE (256)
> +#define HISI_DSS_MAX_ROT_AFBCE_BLOCK_SIZE (480)
> +
> +#define BIT_CMDLIST_CH_TASKDONE_INTS	    BIT(7)
> +#define BIT_CMDLIST_CH_TIMEOUT_INTS	    BIT(6)
> +#define BIT_CMDLIST_CH_BADCMD_INTS	    BIT(5)
> +#define BIT_CMDLIST_CH_START_INTS	           BIT(4)
> +#define BIT_CMDLIST_CH_PENDING_INTS	    BIT(3)
> +#define BIT_CMDLIST_CH_AXIERR_INTS	    BIT(2)
> +#define BIT_CMDLIST_CH_ALLDONE_INTS	    BIT(1)
> +#define BIT_CMDLIST_CH_ONEDONE_INTS	    BIT(0)
> +
> +#define BIT_CMDLIST_CH15_INTS	BIT(15)
> +#define BIT_CMDLIST_CH14_INTS	BIT(14)
> +#define BIT_CMDLIST_CH13_INTS	BIT(13)
> +#define BIT_CMDLIST_CH12_INTS	BIT(12)
> +#define BIT_CMDLIST_CH11_INTS	BIT(11)
> +#define BIT_CMDLIST_CH10_INTS	BIT(10)
> +#define BIT_CMDLIST_CH9_INTS	BIT(9)
> +#define BIT_CMDLIST_CH8_INTS	BIT(8)
> +#define BIT_CMDLIST_CH7_INTS	BIT(7)
> +#define BIT_CMDLIST_CH6_INTS	BIT(6)
> +#define BIT_CMDLIST_CH5_INTS	BIT(5)
> +#define BIT_CMDLIST_CH4_INTS	BIT(4)
> +#define BIT_CMDLIST_CH3_INTS	BIT(3)
> +#define BIT_CMDLIST_CH2_INTS	BIT(2)
> +#define BIT_CMDLIST_CH1_INTS	BIT(1)
> +#define BIT_CMDLIST_CH0_INTS	BIT(0)
> +
> +/* AIF */
> +#define AIF0_CH0_OFFSET	(DSS_VBIF0_AIF + 0x00)
> +#define AIF0_CH1_OFFSET	(DSS_VBIF0_AIF + 0x20)
> +#define AIF0_CH2_OFFSET	(DSS_VBIF0_AIF + 0x40)
> +#define AIF0_CH3_OFFSET	(DSS_VBIF0_AIF + 0x60)
> +#define AIF0_CH4_OFFSET	(DSS_VBIF0_AIF + 0x80)
> +#define AIF0_CH5_OFFSET	(DSS_VBIF0_AIF + 0xA0)
> +#define AIF0_CH6_OFFSET	(DSS_VBIF0_AIF + 0xC0)
> +#define AIF0_CH7_OFFSET	(DSS_VBIF0_AIF + 0xE0)
> +#define AIF0_CH8_OFFSET	(DSS_VBIF0_AIF + 0x100)
> +#define AIF0_CH9_OFFSET	(DSS_VBIF0_AIF + 0x120)
> +#define AIF0_CH10_OFFSET	(DSS_VBIF0_AIF + 0x140)
> +#define AIF0_CH11_OFFSET	(DSS_VBIF0_AIF + 0x160)
> +#define AIF0_CH12_OFFSET	(DSS_VBIF0_AIF + 0x180)
> +
> +#define AIF1_CH0_OFFSET	(DSS_VBIF1_AIF + 0x00)
> +#define AIF1_CH1_OFFSET	(DSS_VBIF1_AIF + 0x20)
> +#define AIF1_CH2_OFFSET	(DSS_VBIF1_AIF + 0x40)
> +#define AIF1_CH3_OFFSET	(DSS_VBIF1_AIF + 0x60)
> +#define AIF1_CH4_OFFSET	(DSS_VBIF1_AIF + 0x80)
> +#define AIF1_CH5_OFFSET	(DSS_VBIF1_AIF + 0xA0)
> +#define AIF1_CH6_OFFSET	(DSS_VBIF1_AIF + 0xC0)
> +#define AIF1_CH7_OFFSET	(DSS_VBIF1_AIF + 0xE0)
> +#define AIF1_CH8_OFFSET	(DSS_VBIF1_AIF + 0x100)
> +#define AIF1_CH9_OFFSET	(DSS_VBIF1_AIF + 0x120)
> +#define AIF1_CH10_OFFSET	(DSS_VBIF1_AIF + 0x140)
> +#define AIF1_CH11_OFFSET	(DSS_VBIF1_AIF + 0x160)
> +#define AIF1_CH12_OFFSET	(DSS_VBIF1_AIF + 0x180)
> +
> +/* aif dmax */
> +
> +#define AIF_CH_CTL	(0x0000)
> +
> +#define AIF_CH_CTL_ADD (0x0004)
> +
> +/* aif common */
> +#define AXI0_RID_MSK0	(0x0800)
> +#define AXI0_RID_MSK1	(0x0804)
> +#define AXI0_WID_MSK	(0x0808)
> +#define AXI0_R_QOS_MAP	(0x080c)
> +#define AXI1_RID_MSK0	(0x0810)
> +#define AXI1_RID_MSK1	(0x0814)
> +#define AXI1_WID_MSK	(0x0818)
> +#define AXI1_R_QOS_MAP	(0x081c)
> +#define AIF_CLK_SEL0	(0x0820)
> +#define AIF_CLK_SEL1	(0x0824)
> +#define AIF_CLK_EN0	(0x0828)
> +#define AIF_CLK_EN1	(0x082c)
> +#define MONITOR_CTRL	(0x0830)
> +#define MONITOR_TIMER_INI	(0x0834)
> +#define DEBUG_BUF_BASE	(0x0838)
> +#define DEBUG_CTRL	(0x083C)
> +#define AIF_SHADOW_READ	(0x0840)
> +#define AIF_MEM_CTRL	(0x0844)
> +#define AIF_MONITOR_EN	(0x0848)
> +#define AIF_MONITOR_CTRL	(0x084C)
> +#define AIF_MONITOR_SAMPLE_MUN	(0x0850)
> +#define AIF_MONITOR_SAMPLE_TIME	(0x0854)
> +#define AIF_MONITOR_SAMPLE_FLOW	(0x0858)
> +
> +/* aif debug */
> +#define AIF_MONITOR_READ_DATA	(0x0880)
> +#define AIF_MONITOR_WRITE_DATA	(0x0884)
> +#define AIF_MONITOR_WINDOW_CYCLE	(0x0888)
> +#define AIF_MONITOR_WBURST_CNT	(0x088C)
> +#define AIF_MONITOR_MIN_WR_CYCLE	(0x0890)
> +#define AIF_MONITOR_MAX_WR_CYCLE	(0x0894)
> +#define AIF_MONITOR_AVR_WR_CYCLE	(0x0898)
> +#define AIF_MONITOR_MIN_WRW_CYCLE	(0x089C)
> +#define AIF_MONITOR_MAX_WRW_CYCLE	(0x08A0)
> +#define AIF_MONITOR_AVR_WRW_CYCLE	(0x08A4)
> +#define AIF_MONITOR_RBURST_CNT	(0x08A8)
> +#define AIF_MONITOR_MIN_RD_CYCLE	(0x08AC)
> +#define AIF_MONITOR_MAX_RD_CYCLE	(0x08B0)
> +#define AIF_MONITOR_AVR_RD_CYCLE	(0x08B4)
> +#define AIF_MONITOR_MIN_RDW_CYCLE	(0x08B8)
> +#define AIF_MONITOR_MAX_RDW_CYCLE	(0x08BC)
> +#define AIF_MONITOR_AVR_RDW_CYCLE	(0x08C0)
> +#define AIF_CH_STAT_0	(0x08C4)
> +#define AIF_CH_STAT_1	(0x08C8)
> +
> +#define AIF_MODULE_CLK_SEL	(0x0A04)
> +#define AIF_MODULE_CLK_EN	(0x0A08)
> +
> +/* MIF */
> +
> +/*
> + * stretch blt, linear/tile, rotation, pixel format
> + * 0 0 000
> + */
> +enum dss_mmu_tlb_tag_org {
> +	MMU_TLB_TAG_ORG_0x0 = 0x0,
> +	MMU_TLB_TAG_ORG_0x1 = 0x1,
> +	MMU_TLB_TAG_ORG_0x2 = 0x2,
> +	MMU_TLB_TAG_ORG_0x3 = 0x3,
> +	MMU_TLB_TAG_ORG_0x4 = 0x4,
> +	MMU_TLB_TAG_ORG_0x7 = 0x7,
> +
> +	MMU_TLB_TAG_ORG_0x8 = 0x8,
> +	MMU_TLB_TAG_ORG_0x9 = 0x9,
> +	MMU_TLB_TAG_ORG_0xA = 0xA,
> +	MMU_TLB_TAG_ORG_0xB = 0xB,
> +	MMU_TLB_TAG_ORG_0xC = 0xC,
> +	MMU_TLB_TAG_ORG_0xF = 0xF,
> +
> +	MMU_TLB_TAG_ORG_0x10 = 0x10,
> +	MMU_TLB_TAG_ORG_0x11 = 0x11,
> +	MMU_TLB_TAG_ORG_0x12 = 0x12,
> +	MMU_TLB_TAG_ORG_0x13 = 0x13,
> +	MMU_TLB_TAG_ORG_0x14 = 0x14,
> +	MMU_TLB_TAG_ORG_0x17 = 0x17,
> +
> +	MMU_TLB_TAG_ORG_0x18 = 0x18,
> +	MMU_TLB_TAG_ORG_0x19 = 0x19,
> +	MMU_TLB_TAG_ORG_0x1A = 0x1A,
> +	MMU_TLB_TAG_ORG_0x1B = 0x1B,
> +	MMU_TLB_TAG_ORG_0x1C = 0x1C,
> +	MMU_TLB_TAG_ORG_0x1F = 0x1F,
> +};
> +
> +#define MIF_ENABLE	(0x0000)
> +#define MIF_MEM_CTRL	(0x0004)
> +
> +#define MIF_CTRL0	(0x000)
> +#define MIF_CTRL1	(0x004)
> +#define MIF_CTRL2	(0x008)
> +#define MIF_CTRL3	(0x00C)
> +#define MIF_CTRL4	(0x010)
> +#define MIF_CTRL5	(0x014)
> +#define REG_DEFAULT (0x0500)
> +#define MIF_SHADOW_READ	(0x0504)
> +#define MIF_CLK_CTL	(0x0508)
> +
> +#define MIF_STAT0	(0x0600)
> +
> +#define MIF_STAT1	(0x0604)
> +
> +#define MIF_STAT2	(0x0608)
> +
> +#define MIF_CTRL_OFFSET	(0x20)
> +#define MIF_CH0_OFFSET	(DSS_MIF_OFFSET + MIF_CTRL_OFFSET * 1)
> +#define MIF_CH1_OFFSET	(DSS_MIF_OFFSET + MIF_CTRL_OFFSET * 2)
> +#define MIF_CH2_OFFSET	(DSS_MIF_OFFSET + MIF_CTRL_OFFSET * 3)
> +#define MIF_CH3_OFFSET	(DSS_MIF_OFFSET + MIF_CTRL_OFFSET * 4)
> +#define MIF_CH4_OFFSET	(DSS_MIF_OFFSET + MIF_CTRL_OFFSET * 5)
> +#define MIF_CH5_OFFSET	(DSS_MIF_OFFSET + MIF_CTRL_OFFSET * 6)
> +#define MIF_CH6_OFFSET	(DSS_MIF_OFFSET + MIF_CTRL_OFFSET * 7)
> +#define MIF_CH7_OFFSET	(DSS_MIF_OFFSET + MIF_CTRL_OFFSET * 8)
> +#define MIF_CH8_OFFSET	(DSS_MIF_OFFSET + MIF_CTRL_OFFSET * 9)
> +#define MIF_CH9_OFFSET	(DSS_MIF_OFFSET + MIF_CTRL_OFFSET * 10)
> +#define MIF_CH10_OFFSET	(DSS_MIF_OFFSET + MIF_CTRL_OFFSET * 11)
> +#define MIF_CH11_OFFSET	(DSS_MIF_OFFSET + MIF_CTRL_OFFSET * 12)
> +#define MIF_CTRL_NUM	(12)
> +
> +#define LITTLE_LAYER_BUF_SIZE	(256 * 1024)
> +#define MIF_STRIDE_UNIT (4 * 1024)
> +
> +/* SMMU */
> +#define SMMU_SCR	(0x0000)
> +#define SMMU_MEMCTRL	(0x0004)
> +#define SMMU_LP_CTRL	(0x0008)
> +#define SMMU_PRESS_REMAP	(0x000C)
> +#define SMMU_INTMASK_NS	(0x0010)
> +#define SMMU_INTRAW_NS	(0x0014)
> +#define SMMU_INTSTAT_NS	(0x0018)
> +#define SMMU_INTCLR_NS	(0x001C)
> +
> +#define SMMU_SMRx_NS	(0x0020)
> +#define SMMU_RLD_EN0_NS	(0x01F0)
> +#define SMMU_RLD_EN1_NS	(0x01F4)
> +#define SMMU_RLD_EN2_NS	(0x01F8)
> +#define SMMU_CB_SCTRL	(0x0200)
> +#define SMMU_CB_TTBR0	(0x0204)
> +#define SMMU_CB_TTBR1	(0x0208)
> +#define SMMU_CB_TTBCR	(0x020C)
> +#define SMMU_OFFSET_ADDR_NS	(0x0210)
> +#define SMMU_SCACHEI_ALL	(0x0214)
> +#define SMMU_SCACHEI_L1	(0x0218)
> +#define SMMU_SCACHEI_L2L3	(0x021C)
> +#define SMMU_FAMA_CTRL0	(0x0220)
> +#define SMMU_FAMA_CTRL1	(0x0224)
> +#define SMMU_ADDR_MSB	(0x0300)
> +#define SMMU_ERR_RDADDR	(0x0304)
> +#define SMMU_ERR_WRADDR	(0x0308)
> +#define SMMU_FAULT_ADDR_TCU (0x0310)
> +#define SMMU_FAULT_ID_TCU	(0x0314)
> +
> +#define SMMU_FAULT_ADDR_TBUx	(0x0320)
> +#define SMMU_FAULT_ID_TBUx	(0x0324)
> +#define SMMU_FAULT_INFOx	(0x0328)
> +#define SMMU_DBGRPTR_TLB	(0x0380)
> +#define SMMU_DBGRDATA_TLB	(0x0380)
> +#define SMMU_DBGRDATA0_CACHE	(0x038C)
> +#define SMMU_DBGRDATA1_CACHE	(0x0390)
> +#define SMMU_DBGAXI_CTRL	(0x0394)
> +#define SMMU_OVA_ADDR	(0x0398)
> +#define SMMU_OPA_ADDR	(0x039C)
> +#define SMMU_OVA_CTRL	(0x03A0)
> +#define SMMU_OPREF_ADDR	(0x03A4)
> +#define SMMU_OPREF_CTRL	(0x03A8)
> +#define SMMU_OPREF_CNT	(0x03AC)
> +
> +#define SMMU_SMRx_S	(0x0500)
> +#define SMMU_RLD_EN0_S	(0x06F0)
> +#define SMMU_RLD_EN1_S	(0x06F4)
> +#define SMMU_RLD_EN2_S	(0x06F8)
> +#define SMMU_INTMAS_S	(0x0700)
> +#define SMMU_INTRAW_S	(0x0704)
> +#define SMMU_INTSTAT_S	(0x0708)
> +#define SMMU_INTCLR_S	(0x070C)
> +#define SMMU_SCR_S	(0x0710)
> +#define SMMU_SCB_SCTRL	(0x0714)
> +#define SMMU_SCB_TTBR	(0x0718)
> +#define SMMU_SCB_TTBCR	(0x071C)
> +#define SMMU_OFFSET_ADDR_S	(0x0720)
> +
> +#define SMMU_SID_NUM	(64)
> +
> +/* RDMA */
> +
> +#define DMA_OFT_X0	(0x0000)
> +#define DMA_OFT_Y0	(0x0004)
> +#define DMA_OFT_X1	(0x0008)
> +#define DMA_OFT_Y1	(0x000C)
> +#define DMA_MASK0	(0x0010)
> +#define DMA_MASK1	(0x0014)
> +#define DMA_STRETCH_SIZE_VRT	(0x0018)
> +#define DMA_CTRL	(0x001C)
> +#define DMA_TILE_SCRAM	(0x0020)
> +
> +#define DMA_PULSE	(0x0028)
> +#define DMA_CORE_GT	(0x002C)
> +#define RWCH_CFG0	(0x0030)
> +
> +#define WDMA_DMA_SW_MASK_EN	(0x004C)
> +#define WDMA_DMA_START_MASK0	(0x0050)
> +#define WDMA_DMA_END_MASK0	(0x0054)
> +#define WDMA_DMA_START_MASK1	(0x0058)
> +#define WDMA_DMA_END_MASK1	(0x005C)
> +
> +#define DMA_DATA_ADDR0	(0x0060)
> +#define DMA_STRIDE0	(0x0064)
> +#define DMA_STRETCH_STRIDE0	(0x0068)
> +#define DMA_DATA_NUM0	(0x006C)
> +
> +#define DMA_TEST0	(0x0070)
> +#define DMA_TEST1	(0x0074)
> +#define DMA_TEST3	(0x0078)
> +#define DMA_TEST4	(0x007C)
> +#define DMA_STATUS_Y	(0x0080)
> +
> +#define DMA_DATA_ADDR1	(0x0084)
> +#define DMA_STRIDE1	(0x0088)
> +#define DMA_STRETCH_STRIDE1	(0x008C)
> +#define DMA_DATA_NUM1	(0x0090)
> +
> +#define DMA_TEST0_U	(0x0094)
> +#define DMA_TEST1_U	(0x0098)
> +#define DMA_TEST3_U	(0x009C)
> +#define DMA_TEST4_U	(0x00A0)
> +#define DMA_STATUS_U	(0x00A4)
> +
> +#define DMA_DATA_ADDR2	(0x00A8)
> +#define DMA_STRIDE2	(0x00AC)
> +#define DMA_STRETCH_STRIDE2	(0x00B0)
> +#define DMA_DATA_NUM2	(0x00B4)
> +
> +#define DMA_TEST0_V	(0x00B8)
> +#define DMA_TEST1_V	(0x00BC)
> +#define DMA_TEST3_V	(0x00C0)
> +#define DMA_TEST4_V	(0x00C4)
> +#define DMA_STATUS_V	(0x00C8)
> +
> +#define CH_RD_SHADOW	(0x00D0)
> +#define CH_CTL	(0x00D4)
> +#define CH_SECU_EN	(0x00D8)
> +#define CH_SW_END_REQ	(0x00DC)
> +#define CH_CLK_SEL	(0x00E0)
> +#define CH_CLK_EN	(0x00E4)
> +
> +/* DFC */
> +#define DFC_DISP_SIZE	(0x0000)
> +#define DFC_PIX_IN_NUM	(0x0004)
> +#define DFC_DISP_FMT	(0x000C)
> +#define DFC_CLIP_CTL_HRZ	(0x0010)
> +#define DFC_CLIP_CTL_VRZ	(0x0014)
> +#define DFC_CTL_CLIP_EN	(0x0018)
> +#define DFC_ICG_MODULE	(0x001C)
> +#define DFC_DITHER_ENABLE	(0x0020)
> +#define DFC_PADDING_CTL	(0x0024)
> +
> +#define DSS_SCF_H0_Y_COEF_OFFSET	(0x0000)
> +#define DSS_SCF_Y_COEF_OFFSET	(0x2000)
> +#define DSS_SCF_UV_COEF_OFFSET	(0x2800)
> +
> +#define SCF_EN_HSCL_STR	(0x0000)
> +#define SCF_EN_VSCL_STR	(0x0004)
> +#define SCF_H_V_ORDER	(0x0008)
> +#define SCF_SCF_CORE_GT	(0x000C)
> +#define SCF_INPUT_WIDTH_HEIGHT	(0x0010)
> +#define SCF_OUTPUT_WIDTH_HEIGHT	(0x0014)
> +#define SCF_COEF_MEM_CTRL  (0x0018)
> +#define SCF_EN_HSCL	(0x001C)
> +#define SCF_EN_VSCL	(0x0020)
> +#define SCF_ACC_HSCL	(0x0024)
> +#define SCF_ACC_HSCL1	(0x0028)
> +#define SCF_INC_HSCL	(0x0034)
> +#define SCF_ACC_VSCL	(0x0038)
> +#define SCF_ACC_VSCL1	(0x003C)
> +#define SCF_INC_VSCL	(0x0048)
> +#define SCF_EN_NONLINEAR	(0x004C)
> +#define SCF_EN_MMP	(0x007C)
> +#define SCF_DB_H0	(0x0080)
> +#define SCF_DB_H1	(0x0084)
> +#define SCF_DB_V0	(0x0088)
> +#define SCF_DB_V1	(0x008C)
> +#define SCF_LB_MEM_CTRL	(0x0090)
> +#define SCF_RD_SHADOW	(0x00F0)
> +#define SCF_CLK_SEL	(0x00F8)
> +#define SCF_CLK_EN	(0x00FC)
> +#define WCH_SCF_COEF_MEM_CTRL (0x0218)
> +#define WCH_SCF_LB_MEM_CTRL	(0x290)
> +
> +/* MACROS */
> +#define SCF_MIN_INPUT	(16)
> +#define SCF_MIN_OUTPUT	(16)
> +
> +/* SCF */
> +
> +enum scl_coef_lut_idx {
> +	SCL_COEF_NONE_IDX = -1,
> +	SCL_COEF_YUV_IDX = 0,
> +	SCL_COEF_RGB_IDX = 1,
> +	SCL_COEF_IDX_MAX = 2,
> +};
> +
> +/* Threshold for SCF Stretch and SCF filter */
> +#define RDMA_STRETCH_THRESHOLD	(2)
> +#define SCF_INC_FACTOR	BIT(18)
> +#define SCF_UPSCALE_MAX	(60)
> +#define SCF_DOWNSCALE_MAX	  (60)
> +#define SCF_EDGE_FACTOR (3)
> +#define ARSR2P_INC_FACTOR (65536)
> +
> +/* ARSR2P v0 */
> +#define ARSR2P_INPUT_WIDTH_HEIGHT		(0x000)
> +#define ARSR2P_OUTPUT_WIDTH_HEIGHT		(0x004)
> +#define ARSR2P_IHLEFT		(0x008)
> +
> +#define ARSR2P_LUT_COEFY_V_OFFSET (0x0000)
> +#define ARSR2P_LUT_COEFY_H_OFFSET (0x0100)
> +#define ARSR2P_LUT_COEFA_V_OFFSET (0x0300)
> +#define ARSR2P_LUT_COEFA_H_OFFSET (0x0400)
> +#define ARSR2P_LUT_COEFUV_V_OFFSET (0x0600)
> +#define ARSR2P_LUT_COEFUV_H_OFFSET (0x0700)
> +
> +/* POST_CLIP  v g */
> +#define POST_CLIP_DISP_SIZE	(0x0000)
> +
> +/* PCSC v */
> +#define PCSC_IDC0	(0x0000)
> +#define PCSC_IDC2	(0x0004)
> +#define PCSC_ODC0	(0x0008)
> +#define PCSC_ODC2	(0x000C)
> +#define PCSC_P0	(0x0010)
> +#define PCSC_P1	(0x0014)
> +#define PCSC_P2	(0x0018)
> +#define PCSC_P3	(0x001C)
> +#define PCSC_P4	(0x0020)
> +#define PCSC_ICG_MODULE	(0x0024)
> +#define PCSC_MPREC	(0x0028)
> +
> +/* CSC */
> +
> +#define CSC_IDC0	(0x0000)
> +#define CSC_IDC2	(0x0004)
> +#define CSC_ODC0	(0x0008)
> +#define CSC_ODC2	(0x000C)
> +#define CSC_P0	(0x0010)
> +#define CSC_P1	(0x0014)
> +#define CSC_P2	(0x0018)
> +#define CSC_P3	(0x001C)
> +#define CSC_P4	(0x0020)
> +#define CSC_MPREC	(0x0028)
> +
> +#define CH_DEBUG_SEL (0x600)
> +
> +/* VPP */
> +#define VPP_CTRL (0x700)
> +#define VPP_MEM_CTRL (0x704)
> +
> +/* DMA BUF */
> +#define DMA_BUF_CTRL	(0x800)
> +#define DMA_BUF_SIZE  (0x850)
> +#define DMA_BUF_MEM_CTRL	(0x854)
> +#define DMA_BUF_DBG0 (0x0838)
> +#define DMA_BUF_DBG1 (0x083c)
> +
> +#define AFBCD_HREG_HDR_PTR_LO	(0x900)
> +#define AFBCD_HREG_PIC_WIDTH	(0x904)
> +#define AFBCD_HREG_PIC_HEIGHT	(0x90C)
> +#define AFBCD_HREG_FORMAT	(0x910)
> +#define AFBCD_CTL		(0x914)
> +#define AFBCD_STR	(0x918)
> +#define AFBCD_LINE_CROP	(0x91C)
> +#define AFBCD_INPUT_HEADER_STRIDE	(0x920)
> +#define AFBCD_PAYLOAD_STRIDE	(0x924)
> +#define AFBCD_MM_BASE_0	(0x928)
> +#define AFBCD_AFBCD_PAYLOAD_POINTER	(0x930)
> +#define AFBCD_HEIGHT_BF_STR	(0x934)
> +#define AFBCD_OS_CFG	(0x938)
> +#define AFBCD_MEM_CTRL	(0x93C)
> +#define AFBCD_SCRAMBLE_MODE	(0x940)
> +#define AFBCD_HEADER_POINTER_OFFSET	(0x944)
> +#define AFBCD_MONITOR_REG1_OFFSET	(0x948)
> +#define AFBCD_MONITOR_REG2_OFFSET	(0x94C)
> +#define AFBCD_MONITOR_REG3_OFFSET	(0x950)
> +#define AFBCD_DEBUG_REG0_OFFSET	(0x954)
> +#define AFBCD_CREG_FBCD_CTRL_MODE	(0x960)
> +#define AFBCD_HREG_HDR_PTR_L1		(0x964)
> +#define AFBCD_HREG_PLD_PTR_L1		(0x968)
> +#define AFBCD_HEADER_SRTIDE_1		(0x96C)
> +#define AFBCD_PAYLOAD_SRTIDE_1		(0x970)
> +#define AFBCD_HREG_HDR_PTR_L1		(0x964)
> +#define AFBCD_HREG_PLD_PTR_L1		(0x968)
> +#define AFBCD_HEADER_SRTIDE_1		(0x96C)
> +#define AFBCD_PAYLOAD_SRTIDE_1		(0x970)
> +#define AFBCD_BLOCK_TYPE				(0x974)
> +#define AFBCD_MM_BASE_1				(0x978)
> +#define AFBCD_MM_BASE_2				(0x97C)
> +#define AFBCD_MM_BASE_3				(0x980)
> +#define HFBCD_MEM_CTRL				(0x984)
> +#define HFBCD_MEM_CTRL_1				(0x988)
> +
> +#define AFBCE_HREG_PIC_BLKS	(0x900)
> +#define AFBCE_HREG_FORMAT	(0x904)
> +#define AFBCE_PICTURE_SIZE	(0x910)
> +#define AFBCE_CTL	(0x914)
> +#define AFBCE_HEADER_SRTIDE	(0x918)
> +#define AFBCE_PAYLOAD_STRIDE	(0x91C)
> +#define AFBCE_ENC_OS_CFG	(0x920)
> +#define AFBCE_MEM_CTRL	(0x924)
> +#define AFBCE_QOS_CFG	(0x928)
> +#define AFBCE_THRESHOLD	(0x92C)
> +#define AFBCE_SCRAMBLE_MODE	(0x930)
> +#define AFBCE_HEADER_POINTER_OFFSET	(0x934)
> +#define AFBCE_CREG_FBCE_CTRL_MODE	(0x950)
> +#define AFBCE_HREG_HDR_PTR_L1		(0x954)
> +#define AFBCE_HREG_PLD_PTR_L1		(0x958)
> +#define AFBCE_HEADER_SRTIDE_1			(0x95C)
> +#define AFBCE_PAYLOAD_SRTIDE_1		(0x960)
> +#define AFBCE_MEM_CTRL_1				(0x968)
> +#define FBCD_CREG_FBCD_CTRL_GATE		(0x98C)
> +
> +#define ROT_FIRST_LNS	(0x530)
> +#define ROT_STATE	(0x534)
> +#define ROT_CPU_CTL0	(0x540)
> +#define ROT_CPU_START0	(0x544)
> +#define ROT_CPU_ADDR0	(0x548)
> +#define ROT_CPU_RDATA0	(0x54C)
> +#define ROT_CPU_RDATA1	(0x550)
> +#define ROT_CPU_WDATA0	(0x554)
> +#define ROT_CPU_WDATA1	(0x558)
> +#define ROT_CPU_CTL1	(0x55C)
> +#define ROT_CPU_START1	(0x560)
> +#define ROT_CPU_ADDR1	(0x564)
> +#define ROT_CPU_RDATA2	(0x568)
> +#define ROT_CPU_RDATA3	(0x56C)
> +#define ROT_CPU_WDATA2	(0x570)
> +#define ROT_CPU_WDATA3	(0x574)
> +
> +#define CH_REG_DEFAULT (0x0A00)
> +
> +/* MACROS */
> +#define MIN_INTERLEAVE	(7)
> +#define MAX_TILE_SURPORT_NUM	(6)
> +
> +/* DMA aligned limited:  128bits aligned */
> +#define DMA_ALIGN_BYTES	(128 / BITS_PER_BYTE)
> +#define DMA_ADDR_ALIGN	(128 / BITS_PER_BYTE)
> +#define DMA_STRIDE_ALIGN	(128 / BITS_PER_BYTE)
> +
> +#define TILE_DMA_ADDR_ALIGN	(256 * 1024)
> +
> +#define DMA_IN_WIDTH_MAX	(2048)
> +#define DMA_IN_HEIGHT_MAX	(8192)
> +
> +#define AFBC_PIC_WIDTH_MIN	(16)
> +#define AFBC_PIC_WIDTH_MAX	(8192)
> +#define AFBC_PIC_HEIGHT_MIN	(16)
> +#define AFBC_PIC_HEIGHT_MAX	(4096)
> +
> +#define AFBCD_TOP_CROP_MAX	(15)
> +#define AFBCD_BOTTOM_CROP_MAX	(15)
> +
> +#define AFBC_HEADER_STRIDE_BLOCK	(16)
> +
> +#define AFBC_PAYLOAD_STRIDE_BLOCK	(1024)
> +
> +#define AFBC_SUPER_GRAPH_HEADER_ADDR_ALIGN	(128)
> +
> +#define AFBC_PAYLOAD_ADDR_ALIGN_32	(1024)
> +#define AFBC_PAYLOAD_STRIDE_ALIGN_32	(1024)
> +#define AFBC_PAYLOAD_ADDR_ALIGN_16	(512)
> +#define AFBC_PAYLOAD_STRIDE_ALIGN_16	(512)
> +
> +#define AFBC_BLOCK_ALIGN	(16)
> +
> +#define AFBCE_IN_WIDTH_MAX	(512)
> +#define WROT_IN_WIDTH_MAX	(512)
> +
> +#define MMBUF_BASE	(0x40)
> +#define MMBUF_LINE_NUM	(8)
> +#define MMBUF_ADDR_ALIGN	(64)
> +
> +enum DSS_AFBC_HALF_BLOCK_MODE {
> +	AFBC_HALF_BLOCK_UPPER_LOWER_ALL = 0,
> +	AFBC_HALF_BLOCK_LOWER_UPPER_ALL,
> +	AFBC_HALF_BLOCK_UPPER_ONLY,
> +	AFBC_HALF_BLOCK_LOWER_ONLY,
> +};
> +
> +/* MCTL  MUTEX0 1 2 3 4 5 */
> +#define MCTL_CTL_EN	(0x0000)
> +#define MCTL_CTL_MUTEX	(0x0004)
> +#define MCTL_CTL_MUTEX_STATUS	(0x0008)
> +#define MCTL_CTL_MUTEX_ITF	(0x000C)
> +#define MCTL_CTL_MUTEX_DBUF	(0x0010)
> +#define MCTL_CTL_MUTEX_SCF	(0x0014)
> +#define MCTL_CTL_MUTEX_OV	(0x0018)
> +#define MCTL_CTL_MUTEX_WCH0	(0x0020)
> +#define MCTL_CTL_MUTEX_WCH1	(0x0024)
> +#define MCTL_CTL_MUTEX_WCH2	(0x0028)
> +#define MCTL_CTL_MUTEX_RCH8	(0x002C)
> +#define MCTL_CTL_MUTEX_RCH0	(0x0030)
> +#define MCTL_CTL_MUTEX_RCH1	(0x0034)
> +#define MCTL_CTL_MUTEX_RCH2	(0x0038)
> +#define MCTL_CTL_MUTEX_RCH3	(0x003C)
> +#define MCTL_CTL_MUTEX_RCH4	(0x0040)
> +#define MCTL_CTL_MUTEX_RCH5	(0x0044)
> +#define MCTL_CTL_MUTEX_RCH6	(0x0048)
> +#define MCTL_CTL_MUTEX_RCH7	(0x004C)
> +#define MCTL_CTL_TOP	(0x0050)
> +#define MCTL_CTL_FLUSH_STATUS	(0x0054)
> +#define MCTL_CTL_CLEAR	(0x0058)
> +#define MCTL_CTL_CACK_TOUT	(0x0060)
> +#define MCTL_CTL_MUTEX_TOUT	(0x0064)
> +#define MCTL_CTL_STATUS	(0x0068)
> +#define MCTL_CTL_INTEN	(0x006C)
> +#define MCTL_CTL_SW_ST	(0x0070)
> +#define MCTL_CTL_ST_SEL	(0x0074)
> +#define MCTL_CTL_END_SEL	(0x0078)
> +#define MCTL_CTL_CLK_SEL	(0x0080)
> +#define MCTL_CTL_CLK_EN	(0x0084)
> +#define MCTL_CTL_DBG	(0x00E0)
> +
> +/* MCTL  SYS */
> +
> +enum dss_mctl_idx {
> +	DSS_MCTL0 = 0,
> +	DSS_MCTL1,
> +	DSS_MCTL2,
> +	DSS_MCTL3,
> +	DSS_MCTL4,
> +	DSS_MCTL5,
> +	DSS_MCTL_IDX_MAX,
> +};
> +
> +#define MCTL_CTL_SECU_CFG	(0x0000)
> +#define MCTL_PAY_SECU_FLUSH_EN  (0x0018)
> +#define MCTL_CTL_SECU_GATE0	(0x0080)
> +#define MCTL_CTL_SECU_GATE1	(0x0084)
> +#define MCTL_CTL_SECU_GATE2	(0x0088)
> +#define MCTL_DSI0_SECU_CFG_EN	(0x00A0)
> +#define MCTL_DSI1_SECU_CFG_EN	(0x00A4)
> +
> +#define MCTL_RCH0_FLUSH_EN	(0x0100)
> +#define MCTL_RCH1_FLUSH_EN	(0x0104)
> +#define MCTL_RCH2_FLUSH_EN	(0x0108)
> +#define MCTL_RCH3_FLUSH_EN	(0x010C)
> +#define MCTL_RCH4_FLUSH_EN	(0x0110)
> +#define MCTL_RCH5_FLUSH_EN	(0x0114)
> +#define MCTL_RCH6_FLUSH_EN	(0x0118)
> +#define MCTL_RCH7_FLUSH_EN	(0x011C)
> +#define MCTL_WCH0_FLUSH_EN	(0x0120)
> +#define MCTL_WCH1_FLUSH_EN	(0x0124)
> +#define MCTL_OV0_FLUSH_EN	(0x0128)
> +#define MCTL_OV1_FLUSH_EN	(0x012C)
> +#define MCTL_OV2_FLUSH_EN	(0x0130)
> +#define MCTL_OV3_FLUSH_EN	(0x0134)
> +#define MCTL_RCH8_FLUSH_EN	(0x0138)
> +#define MCTL_WCH2_FLUSH_EN	(0x013C)
> +
> +#define MCTL_RCH0_OV_OEN	(0x0160)
> +#define MCTL_RCH1_OV_OEN	(0x0164)
> +#define MCTL_RCH2_OV_OEN	(0x0168)
> +#define MCTL_RCH3_OV_OEN	(0x016C)
> +#define MCTL_RCH4_OV_OEN	(0x0170)
> +#define MCTL_RCH5_OV_OEN	(0x0174)
> +#define MCTL_RCH6_OV_OEN	(0x0178)
> +#define MCTL_RCH7_OV_OEN	(0x017C)
> +
> +#define MCTL_RCH_OV0_SEL	(0x0180)
> +#define MCTL_RCH_OV1_SEL	(0x0184)
> +#define MCTL_RCH_OV2_SEL	(0x0188)
> +#define MCTL_RCH_OV3_SEL	(0x018C)
> +
> +#define MCTL_WCH0_OV_IEN   (0x01A0)
> +#define MCTL_WCH1_OV_IEN   (0x01A4)
> +
> +#define MCTL_WCH_OV2_SEL   (0x01A8)
> +#define MCTL_WCH_OV3_SEL   (0x01AC)
> +
> +#define MCTL_WB_ENC_SEL	(0x01B0)
> +#define MCTL_DSI_MUX_SEL	(0x01B4)
> +
> +#define MCTL_RCH0_STARTY	(0x01C0)
> +#define MCTL_RCH1_STARTY	(0x01C4)
> +#define MCTL_RCH2_STARTY	(0x01C8)
> +#define MCTL_RCH3_STARTY	(0x01CC)
> +#define MCTL_RCH4_STARTY	(0x01D0)
> +#define MCTL_RCH5_STARTY	(0x01D4)
> +#define MCTL_RCH6_STARTY	(0x01D8)
> +#define MCTL_RCH7_STARTY	(0x01DC)
> +
> +#define MCTL_MCTL_CLK_SEL	(0x01F0)
> +#define MCTL_MCTL_CLK_EN	(0x01F4)
> +#define MCTL_MOD_CLK_SEL	(0x01F8)
> +#define MCTL_MOD_CLK_EN	(0x01FC)
> +
> +#define MCTL_MOD0_DBG	(0x0200)
> +#define MCTL_MOD1_DBG	(0x0204)
> +#define MCTL_MOD2_DBG	(0x0208)
> +#define MCTL_MOD3_DBG	(0x020C)
> +#define MCTL_MOD4_DBG	(0x0210)
> +#define MCTL_MOD5_DBG	(0x0214)
> +#define MCTL_MOD6_DBG	(0x0218)
> +#define MCTL_MOD7_DBG	(0x021C)
> +#define MCTL_MOD8_DBG	(0x0220)
> +#define MCTL_MOD9_DBG	(0x0224)
> +#define MCTL_MOD10_DBG	(0x0228)
> +#define MCTL_MOD11_DBG	(0x022C)
> +#define MCTL_MOD12_DBG	(0x0230)
> +#define MCTL_MOD13_DBG	(0x0234)
> +#define MCTL_MOD14_DBG	(0x0238)
> +#define MCTL_MOD15_DBG	(0x023C)
> +#define MCTL_MOD16_DBG	(0x0240)
> +#define MCTL_MOD17_DBG	(0x0244)
> +#define MCTL_MOD18_DBG	(0x0248)
> +#define MCTL_MOD19_DBG	(0x024C)
> +#define MCTL_MOD20_DBG	(0x0250)
> +#define MCTL_MOD0_STATUS	(0x0280)
> +#define MCTL_MOD1_STATUS	(0x0284)
> +#define MCTL_MOD2_STATUS	(0x0288)
> +#define MCTL_MOD3_STATUS	(0x028C)
> +#define MCTL_MOD4_STATUS	(0x0290)
> +#define MCTL_MOD5_STATUS	(0x0294)
> +#define MCTL_MOD6_STATUS	(0x0298)
> +#define MCTL_MOD7_STATUS	(0x029C)
> +#define MCTL_MOD8_STATUS	(0x02A0)
> +#define MCTL_MOD9_STATUS	(0x02A4)
> +#define MCTL_MOD10_STATUS	(0x02A8)
> +#define MCTL_MOD11_STATUS	(0x02AC)
> +#define MCTL_MOD12_STATUS	(0x02B0)
> +#define MCTL_MOD13_STATUS	(0x02B4)
> +#define MCTL_MOD14_STATUS	(0x02B8)
> +#define MCTL_MOD15_STATUS	(0x02BC)
> +#define MCTL_MOD16_STATUS	(0x02C0)
> +#define MCTL_MOD17_STATUS	(0x02C4)
> +#define MCTL_MOD18_STATUS	(0x02C8)
> +#define MCTL_MOD19_STATUS	(0x02CC)
> +#define MCTL_MOD20_STATUS	(0x02D0)
> +#define MCTL_SW_DBG	(0x0300)
> +#define MCTL_SW0_STATUS0	(0x0304)
> +#define MCTL_SW0_STATUS1	(0x0308)
> +#define MCTL_SW0_STATUS2	(0x030C)
> +#define MCTL_SW0_STATUS3	(0x0310)
> +#define MCTL_SW0_STATUS4	(0x0314)
> +#define MCTL_SW0_STATUS5	(0x0318)
> +#define MCTL_SW0_STATUS6	(0x031C)
> +#define MCTL_SW0_STATUS7	(0x0320)
> +#define MCTL_SW1_STATUS	(0x0324)
> +
> +#define MCTL_MOD_DBG_CH_NUM (10)
> +#define MCTL_MOD_DBG_OV_NUM (4)
> +#define MCTL_MOD_DBG_DBUF_NUM (2)
> +#define MCTL_MOD_DBG_SCF_NUM (1)
> +#define MCTL_MOD_DBG_ITF_NUM (2)
> +#define MCTL_MOD_DBG_ADD_CH_NUM (2)
> +
> +/* OVL */
> +#define OVL_SIZE	(0x0000)
> +#define OVL_BG_COLOR	(0x4)
> +#define OVL_DST_STARTPOS	(0x8)
> +#define OVL_DST_ENDPOS	(0xC)
> +#define OVL_GCFG	(0x10)
> +#define OVL_LAYER0_POS	(0x14)
> +#define OVL_LAYER0_SIZE	(0x18)
> +#define OVL_LAYER0_SRCLOKEY	(0x1C)
> +#define OVL_LAYER0_SRCHIKEY	(0x20)
> +#define OVL_LAYER0_DSTLOKEY	(0x24)
> +#define OVL_LAYER0_DSTHIKEY	(0x28)
> +#define OVL_LAYER0_PATTERN	(0x2C)
> +#define OVL_LAYER0_ALPHA	(0x30)
> +#define OVL_LAYER0_CFG	(0x34)
> +#define OVL_LAYER0_INFO_ALPHA	(0x40)
> +#define OVL_LAYER0_INFO_SRCCOLOR	(0x44)
> +#define OVL_LAYER1_POS	(0x50)
> +#define OVL_LAYER1_SIZE	(0x54)
> +#define OVL_LAYER1_SRCLOKEY	(0x58)
> +#define OVL_LAYER1_SRCHIKEY	(0x5C)
> +#define OVL_LAYER1_DSTLOKEY	(0x60)
> +#define OVL_LAYER1_DSTHIKEY	(0x64)
> +#define OVL_LAYER1_PATTERN	(0x68)
> +#define OVL_LAYER1_ALPHA	(0x6C)
> +#define OVL_LAYER1_CFG	(0x70)
> +#define OVL_LAYER1_INFO_ALPHA	(0x7C)
> +#define OVL_LAYER1_INFO_SRCCOLOR	(0x80)
> +#define OVL_LAYER2_POS	(0x8C)
> +#define OVL_LAYER2_SIZE	(0x90)
> +#define OVL_LAYER2_SRCLOKEY	(0x94)
> +#define OVL_LAYER2_SRCHIKEY	(0x98)
> +#define OVL_LAYER2_DSTLOKEY	(0x9C)
> +#define OVL_LAYER2_DSTHIKEY	(0xA0)
> +#define OVL_LAYER2_PATTERN	(0xA4)
> +#define OVL_LAYER2_ALPHA	(0xA8)
> +#define OVL_LAYER2_CFG	(0xAC)
> +#define OVL_LAYER2_INFO_ALPHA	(0xB8)
> +#define OVL_LAYER2_INFO_SRCCOLOR	(0xBC)
> +#define OVL_LAYER3_POS	(0xC8)
> +#define OVL_LAYER3_SIZE	(0xCC)
> +#define OVL_LAYER3_SRCLOKEY	(0xD0)
> +#define OVL_LAYER3_SRCHIKEY	(0xD4)
> +#define OVL_LAYER3_DSTLOKEY	(0xD8)
> +#define OVL_LAYER3_DSTHIKEY	(0xDC)
> +#define OVL_LAYER3_PATTERN	(0xE0)
> +#define OVL_LAYER3_ALPHA	(0xE4)
> +#define OVL_LAYER3_CFG	(0xE8)
> +#define OVL_LAYER3_INFO_ALPHA	(0xF4)
> +#define OVL_LAYER3_INFO_SRCCOLOR	(0xF8)
> +#define OVL_LAYER4_POS	(0x104)
> +#define OVL_LAYER4_SIZE	(0x108)
> +#define OVL_LAYER4_SRCLOKEY	(0x10C)
> +#define OVL_LAYER4_SRCHIKEY	(0x110)
> +#define OVL_LAYER4_DSTLOKEY	(0x114)
> +#define OVL_LAYER4_DSTHIKEY	(0x118)
> +#define OVL_LAYER4_PATTERN	(0x11C)
> +#define OVL_LAYER4_ALPHA	(0x120)
> +#define OVL_LAYER4_CFG	(0x124)
> +#define OVL_LAYER4_INFO_ALPHA	(0x130)
> +#define OVL_LAYER4_INFO_SRCCOLOR	(0x134)
> +#define OVL_LAYER5_POS	(0x140)
> +#define OVL_LAYER5_SIZE	(0x144)
> +#define OVL_LAYER5_SRCLOKEY	(0x148)
> +#define OVL_LAYER5_SRCHIKEY	(0x14C)
> +#define OVL_LAYER5_DSTLOKEY	(0x150)
> +#define OVL_LAYER5_DSTHIKEY	(0x154)
> +#define OVL_LAYER5_PATTERN	(0x158)
> +#define OVL_LAYER5_ALPHA	(0x15C)
> +#define OVL_LAYER5_CFG	(0x160)
> +#define OVL_LAYER5_INFO_ALPHA	(0x16C)
> +#define OVL_LAYER5_INFO_SRCCOLOR	(0x170)
> +#define OVL_LAYER6_POS	(0x14)
> +#define OVL_LAYER6_SIZE	(0x18)
> +#define OVL_LAYER6_SRCLOKEY	(0x1C)
> +#define OVL_LAYER6_SRCHIKEY	(0x20)
> +#define OVL_LAYER6_DSTLOKEY	(0x24)
> +#define OVL_LAYER6_DSTHIKEY	(0x28)
> +#define OVL_LAYER6_PATTERN	(0x2C)
> +#define OVL_LAYER6_ALPHA	(0x30)
> +#define OVL_LAYER6_CFG	(0x34)
> +#define OVL_LAYER6_INFO_ALPHA	(0x40)
> +#define OVL_LAYER6_INFO_SRCCOLOR	(0x44)
> +#define OVL_LAYER7_POS	(0x50)
> +#define OVL_LAYER7_SIZE	(0x54)
> +#define OVL_LAYER7_SRCLOKEY	(0x58)
> +#define OVL_LAYER7_SRCHIKEY	(0x5C)
> +#define OVL_LAYER7_DSTLOKEY	(0x60)
> +#define OVL_LAYER7_DSTHIKEY	(0x64)
> +#define OVL_LAYER7_PATTERN	(0x68)
> +#define OVL_LAYER7_ALPHA	(0x6C)
> +#define OVL_LAYER7_CFG	(0x70)
> +#define OVL_LAYER7_INFO_ALPHA	(0x7C)
> +#define OVL_LAYER7_INFO_SRCCOLOR	(0x80)
> +#define OVL_LAYER0_ST_INFO	(0x48)
> +#define OVL_LAYER1_ST_INFO	(0x84)
> +#define OVL_LAYER2_ST_INFO	(0xC0)
> +#define OVL_LAYER3_ST_INFO	(0xFC)
> +#define OVL_LAYER4_ST_INFO	(0x138)
> +#define OVL_LAYER5_ST_INFO	(0x174)
> +#define OVL_LAYER6_ST_INFO	(0x48)
> +#define OVL_LAYER7_ST_INFO	(0x84)
> +#define OVL_LAYER0_IST_INFO	(0x4C)
> +#define OVL_LAYER1_IST_INFO	(0x88)
> +#define OVL_LAYER2_IST_INFO	(0xC4)
> +#define OVL_LAYER3_IST_INFO	(0x100)
> +#define OVL_LAYER4_IST_INFO	(0x13C)
> +#define OVL_LAYER5_IST_INFO	(0x178)
> +#define OVL_LAYER6_IST_INFO	(0x4C)
> +#define OVL_LAYER7_IST_INFO	(0x88)
> +#define OVL_LAYER0_PSPOS	(0x38)
> +#define OVL_LAYER0_PEPOS	(0x3C)
> +#define OVL_LAYER1_PSPOS	(0x74)
> +#define OVL_LAYER1_PEPOS	(0x78)
> +#define OVL_LAYER2_PSPOS	(0xB0)
> +#define OVL_LAYER2_PEPOS	(0xB4)
> +#define OVL_LAYER3_PSPOS	(0xEC)
> +#define OVL_LAYER3_PEPOS	(0xF0)
> +#define OVL_LAYER4_PSPOS	(0x128)
> +#define OVL_LAYER4_PEPOS	(0x12C)
> +#define OVL_LAYER5_PSPOS	(0x164)
> +#define OVL_LAYER5_PEPOS	(0x168)
> +#define OVL_LAYER6_PSPOS	(0x38)
> +#define OVL_LAYER6_PEPOS	(0x3C)
> +#define OVL_LAYER7_PSPOS	(0x74)
> +#define OVL_LAYER7_PEPOS	(0x78)
> +
> +#define OVL6_BASE_ST_INFO	(0x17C)
> +#define OVL6_BASE_IST_INFO	(0x180)
> +#define OVL6_GATE_CTRL	(0x184)
> +#define OVL6_RD_SHADOW_SEL	(0x188)
> +#define OVL6_OV_CLK_SEL	(0x18C)
> +#define OVL6_OV_CLK_EN	(0x190)
> +#define OVL6_BLOCK_SIZE	(0x1A0)
> +#define OVL6_BLOCK_DBG	(0x1A4)
> +#define OVL6_REG_DEFAULT (0x1A8)
> +
> +#define OVL2_BASE_ST_INFO	(0x8C)
> +#define OVL2_BASE_IST_INFO	(0x90)
> +#define OVL2_GATE_CTRL	(0x94)
> +#define OVL2_OV_RD_SHADOW_SEL	(0x98)
> +#define OVL2_OV_CLK_SEL	(0x9C)
> +#define OVL2_OV_CLK_EN	(0xA0)
> +#define OVL2_BLOCK_SIZE	(0xB0)
> +#define OVL2_BLOCK_DBG	(0xB4)
> +#define OVL2_REG_DEFAULT	(0xB8)
> +
> +/* LAYER0_CFG */
> +#define BIT_OVL_LAYER_SRC_CFG	BIT(8)
> +#define BIT_OVL_LAYER_ENABLE	BIT(0)
> +
> +/* LAYER0_INFO_ALPHA */
> +#define BIT_OVL_LAYER_SRCALPHA_FLAG	BIT(3)
> +#define BIT_OVL_LAYER_DSTALPHA_FLAG	BIT(2)
> +
> +/* LAYER0_INFO_SRCCOLOR */
> +#define BIT_OVL_LAYER_SRCCOLOR_FLAG	BIT(0)
> +
> +#define OVL_6LAYER_NUM		(6)
> +#define OVL_2LAYER_NUM		(2)
> +
> +/* OVL */
> +#define OV_SIZE						(0x000)
> +#define OV_BG_COLOR_RGB			(0x004)
> +#define OV_BG_COLOR_A				(0x008)
> +#define OV_DST_STARTPOS			(0x00C)
> +#define OV_DST_ENDPOS				(0x010)
> +#define OV_GCFG					(0x014)
> +#define OV_LAYER0_POS				(0x030)
> +#define OV_LAYER0_SIZE				(0x034)
> +#define OV_LAYER0_SRCLOKEY		(0x038)
> +#define OV_LAYER0_SRCHIKEY		(0x03C)
> +#define OV_LAYER0_DSTLOKEY		(0x040)
> +#define OV_LAYER0_DSTHIKEY		(0x044)
> +#define OV_LAYER0_PATTERN_RGB	(0x048)
> +#define OV_LAYER0_PATTERN_A		(0x04C)
> +#define OV_LAYER0_ALPHA_MODE		(0x050)
> +#define OV_LAYER0_ALPHA_A			(0x054)
> +#define OV_LAYER0_CFG				(0x058)
> +#define OV_LAYER0_PSPOS			(0x05C)
> +#define OV_LAYER0_PEPOS			(0x060)
> +#define OV_LAYER0_INFO_ALPHA		(0x064)
> +#define OV_LAYER0_INFO_SRCCOLOR	(0x068)
> +#define OV_LAYER0_DBG_INFO		(0x06C)
> +#define OV8_BASE_DBG_INFO			(0x340)
> +#define OV8_RD_SHADOW_SEL			(0x344)
> +#define OV8_CLK_SEL					(0x348)
> +#define OV8_CLK_EN					(0x34C)
> +#define OV8_BLOCK_SIZE				(0x350)
> +#define OV8_BLOCK_DBG				(0x354)
> +#define OV8_REG_DEFAULT			(0x358)
> +#define OV2_BASE_DBG_INFO			(0x200)
> +#define OV2_RD_SHADOW_SEL			(0x204)
> +#define OV2_CLK_SEL					(0x208)
> +#define OV2_CLK_EN					(0x20C)
> +#define OV2_BLOCK_SIZE				(0x210)
> +#define OV2_BLOCK_DBG				(0x214)
> +#define OV2_REG_DEFAULT			(0x218)
> +
> +#define OV_8LAYER_NUM				(8)
> +
> +/* DBUF */
> +#define DBUF_FRM_SIZE	(0x0000)
> +#define DBUF_FRM_HSIZE	(0x0004)
> +#define DBUF_SRAM_VALID_NUM	(0x0008)
> +#define DBUF_WBE_EN	(0x000C)
> +#define DBUF_THD_FILL_LEV0	(0x0010)
> +#define DBUF_DFS_FILL_LEV1	(0x0014)
> +#define DBUF_THD_RQOS	(0x0018)
> +#define DBUF_THD_WQOS	(0x001C)
> +#define DBUF_THD_CG	(0x0020)
> +#define DBUF_THD_OTHER	(0x0024)
> +#define DBUF_FILL_LEV0_CNT	(0x0028)
> +#define DBUF_FILL_LEV1_CNT	(0x002C)
> +#define DBUF_FILL_LEV2_CNT	(0x0030)
> +#define DBUF_FILL_LEV3_CNT	(0x0034)
> +#define DBUF_FILL_LEV4_CNT	(0x0038)
> +#define DBUF_ONLINE_FILL_LEVEL	(0x003C)
> +#define DBUF_WB_FILL_LEVEL	(0x0040)
> +#define DBUF_DFS_STATUS	(0x0044)
> +#define DBUF_THD_FLUX_REQ_BEF	(0x0048)
> +#define DBUF_DFS_LP_CTRL	(0x004C)
> +#define DBUF_RD_SHADOW_SEL	(0x0050)
> +#define DBUF_MEM_CTRL (0x0054)
> +#define DBUF_PM_CTRL (0x0058)
> +#define DBUF_CLK_SEL (0x005C)
> +#define DBUF_CLK_EN (0x0060)
> +#define DBUF_THD_FLUX_REQ_AFT (0x0064)
> +#define DBUF_THD_DFS_OK (0x0068)
> +#define DBUF_FLUX_REQ_CTRL (0x006C)
> +#define DBUF_REG_DEFAULT  (0x00A4)
> +#define DBUF_DFS_RAM_MANAGE  (0x00A8)
> +#define DBUF_DFS_DATA_FILL_OUT  (0x00AC)
> +
> +/* DPP */
> +#define DPP_RD_SHADOW_SEL	(0x000)
> +#define DPP_DEFAULT	(0x004)
> +#define DPP_ID	(0x008)
> +#define DPP_IMG_SIZE_BEF_SR	(0x00C)
> +#define DPP_IMG_SIZE_AFT_SR	(0x010)
> +#define DPP_SBL	(0x014)
> +#define DPP_SBL_MEM_CTRL	(0x018)
> +#define DPP_ARSR1P_MEM_CTRL	(0x01C)
> +#define DPP_CLK_SEL	(0x020)
> +#define DPP_CLK_EN	(0x024)
> +#define DPP_DBG1_CNT	(0x028)
> +#define DPP_DBG2_CNT	(0x02C)
> +#define DPP_DBG1	(0x030)
> +#define DPP_DBG2	(0x034)
> +#define DPP_DBG3	(0x038)
> +#define DPP_DBG4	(0x03C)
> +#define DPP_INTS	(0x040)
> +#define DPP_INT_MSK	(0x044)
> +#define DPP_ARSR1P	(0x048)
> +#define DPP_DBG_CNT  DPP_DBG1_CNT
> +
> +#define DPP_CLRBAR_CTRL (0x100)
> +#define DPP_CLRBAR_1ST_CLR (0x104)
> +#define DPP_CLRBAR_2ND_CLR (0x108)
> +#define DPP_CLRBAR_3RD_CLR (0x10C)
> +
> +#define DPP_CLIP_TOP (0x180)
> +#define DPP_CLIP_BOTTOM (0x184)
> +#define DPP_CLIP_LEFT (0x188)
> +#define DPP_CLIP_RIGHT (0x18C)
> +#define DPP_CLIP_EN (0x190)
> +#define DPP_CLIP_DBG (0x194)
> +
> +#define CSC10B_IDC0	(0x000)
> +#define CSC10B_IDC1	(0x004)
> +#define CSC10B_IDC2	(0x008)
> +#define CSC10B_ODC0	(0x00C)
> +#define CSC10B_ODC1	(0x010)
> +#define CSC10B_ODC2	(0x014)
> +#define CSC10B_P00	(0x018)
> +#define CSC10B_P01	(0x01C)
> +#define CSC10B_P02	(0x020)
> +#define CSC10B_P10	(0x024)
> +#define CSC10B_P11	(0x028)
> +#define CSC10B_P12	(0x02C)
> +#define CSC10B_P20	(0x030)
> +#define CSC10B_P21	(0x034)
> +#define CSC10B_P22	(0x038)
> +#define CSC10B_MODULE_EN	(0x03C)
> +#define CSC10B_MPREC	(0x040)
> +
> +#define GAMA_EN	(0x000)
> +#define GAMA_MEM_CTRL	(0x004)
> +
> +#define ACM_EN	(0x000)
> +#define ACM_SATA_OFFSET	(0x004)
> +#define ACM_HUESEL	(0x008)
> +#define ACM_CSC_IDC0	(0x00C)
> +#define ACM_CSC_IDC1	(0x010)
> +#define ACM_CSC_IDC2	(0x014)
> +#define ACM_CSC_P00	(0x018)
> +#define ACM_CSC_P01	(0x01C)
> +#define ACM_CSC_P02	(0x020)
> +#define ACM_CSC_P10	(0x024)
> +#define ACM_CSC_P11	(0x028)
> +#define ACM_CSC_P12	(0x02C)
> +#define ACM_CSC_P20	(0x030)
> +#define ACM_CSC_P21	(0x034)
> +#define ACM_CSC_P22	(0x038)
> +#define ACM_CSC_MRREC	(0x03C)
> +#define ACM_R0_H	(0x040)
> +#define ACM_R1_H	(0x044)
> +#define ACM_R2_H	(0x048)
> +#define ACM_R3_H	(0x04C)
> +#define ACM_R4_H	(0x050)
> +#define ACM_R5_H	(0x054)
> +#define ACM_R6_H	(0x058)
> +#define ACM_LUT_DIS0	(0x05C)
> +#define ACM_LUT_DIS1	(0x060)
> +#define ACM_LUT_DIS2	(0x064)
> +#define ACM_LUT_DIS3	(0x068)
> +#define ACM_LUT_DIS4	(0x06C)
> +#define ACM_LUT_DIS5	(0x070)
> +#define ACM_LUT_DIS6	(0x074)
> +#define ACM_LUT_DIS7	(0x078)
> +#define ACM_LUT_PARAM0	(0x07C)
> +#define ACM_LUT_PARAM1	(0x080)
> +#define ACM_LUT_PARAM2	(0x084)
> +#define ACM_LUT_PARAM3	(0x088)
> +#define ACM_LUT_PARAM4	(0x08C)
> +#define ACM_LUT_PARAM5	(0x090)
> +#define ACM_LUT_PARAM6	(0x094)
> +#define ACM_LUT_PARAM7	(0x098)
> +#define ACM_LUT_SEL	(0x09C)
> +#define ACM_MEM_CTRL	(0x0A0)
> +#define ACM_DEBUG_TOP	(0x0A4)
> +#define ACM_DEBUG_CFG	(0x0A8)
> +#define ACM_DEBUG_W	(0x0AC)
> +
> +#define ACE_EN	(0x000)
> +#define ACE_SKIN_CFG	(0x004)
> +#define ACE_LUT_SEL	(0x008)
> +#define ACE_HIST_IND	(0x00C)
> +#define ACE_ACTIVE	(0x010)
> +#define ACE_DBG	(0x014)
> +#define ACE_MEM_CTRL	(0x018)
> +#define ACE_IN_SEL	(0x01C)
> +#define ACE_R2Y	(0x020)
> +#define ACE_G2Y	(0x024)
> +#define ACE_B2Y	(0x028)
> +#define ACE_Y_OFFSET	(0x02C)
> +#define ACE_Y_CEN	(0x030)
> +#define ACE_U_CEN	(0x034)
> +#define ACE_V_CEN	(0x038)
> +#define ACE_Y_EXT	(0x03C)
> +#define ACE_U_EXT	(0x040)
> +#define ACE_V_EXT	(0x044)
> +#define ACE_Y_ATTENU	(0x048)
> +#define ACE_U_ATTENU	(0x04C)
> +#define ACE_V_ATTENU	(0x050)
> +#define ACE_ROTA	(0x054)
> +#define ACE_ROTB	(0x058)
> +#define ACE_Y_CORE	(0x05C)
> +#define ACE_U_CORE	(0x060)
> +#define ACE_V_CORE	(0x064)
> +
> +#define LCP_XCC_COEF_00	(0x000)
> +#define LCP_XCC_COEF_01	(0x004)
> +#define LCP_XCC_COEF_02	(0x008)
> +#define LCP_XCC_COEF_03	(0x00C)
> +#define LCP_XCC_COEF_10	(0x010)
> +#define LCP_XCC_COEF_11	(0x014)
> +#define LCP_XCC_COEF_12	(0x018)
> +#define LCP_XCC_COEF_13	(0x01C)
> +#define LCP_XCC_COEF_20	(0x020)
> +#define LCP_XCC_COEF_21	(0x024)
> +#define LCP_XCC_COEF_22	(0x028)
> +#define LCP_XCC_COEF_23	(0x02C)
> +
> +#define ARSR1P_INC_FACTOR (65536)
> +
> +/* BIT EXT */
> +#define BIT_EXT0_CTL (0x000)
> +
> +#define U_GAMA_R_COEF	(0x000)
> +#define U_GAMA_G_COEF	(0x400)
> +#define U_GAMA_B_COEF	(0x800)
> +#define U_GAMA_R_LAST_COEF (0x200)
> +#define U_GAMA_G_LAST_COEF (0x600)
> +#define U_GAMA_B_LAST_COEF (0xA00)
> +
> +#define ACM_U_H_COEF	(0x000)
> +#define ACM_U_SATA_COEF	(0x200)
> +#define ACM_U_SATR0_COEF	(0x300)
> +#define ACM_U_SATR1_COEF	(0x340)
> +#define ACM_U_SATR2_COEF	(0x380)
> +#define ACM_U_SATR3_COEF	(0x3C0)
> +#define ACM_U_SATR4_COEF	(0x400)
> +#define ACM_U_SATR5_COEF	(0x440)
> +#define ACM_U_SATR6_COEF	(0x480)
> +#define ACM_U_SATR7_COEF	(0x4C0)
> +
> +#define LCP_U_DEGAMA_R_COEF	(0x5000)
> +#define LCP_U_DEGAMA_G_COEF	(0x5400)
> +#define LCP_U_DEGAMA_B_COEF	(0x5800)
> +#define LCP_U_DEGAMA_R_LAST_COEF (0x5200)
> +#define LCP_U_DEGAMA_G_LAST_COEF (0x5600)
> +#define LCP_U_DEGAMA_B_LAST_COEF (0x5A00)
> +
> +#define ACE_HIST0	(0x000)
> +#define ACE_HIST1	(0x400)
> +#define ACE_LUT0	(0x800)
> +#define ACE_LUT1	(0xA00)
> +
> +#define HIACE_INT_STAT (0x0000)
> +#define HIACE_INT_UNMASK (0x0004)
> +#define HIACE_BYPASS_ACE (0x0008)
> +#define HIACE_BYPASS_ACE_STAT (0x000c)
> +#define HIACE_UPDATE_LOCAL (0x0010)
> +#define HIACE_LOCAL_VALID (0x0014)
> +#define HIACE_GAMMA_AB_SHADOW (0x0018)
> +#define HIACE_GAMMA_AB_WORK (0x001c)
> +#define HIACE_GLOBAL_HIST_AB_SHADOW (0x0020)
> +#define HIACE_GLOBAL_HIST_AB_WORK (0x0024)
> +#define HIACE_IMAGE_INFO (0x0030)
> +#define HIACE_HALF_BLOCK_H_W (0x0034)
> +#define HIACE_XYWEIGHT (0x0038)
> +#define HIACE_LHIST_SFT (0x003c)
> +#define HIACE_HUE (0x0050)
> +#define HIACE_SATURATION (0x0054)
> +#define HIACE_VALUE (0x0058)
> +#define HIACE_SKIN_GAIN (0x005c)
> +#define HIACE_UP_LOW_TH (0x0060)
> +#define HIACE_UP_CNT (0x0070)
> +#define HIACE_LOW_CNT (0x0074)
> +#define HIACE_GLOBAL_HIST_LUT_ADDR (0x0080)
> +#define HIACE_LHIST_EN (0x0100)
> +#define HIACE_LOCAL_HIST_VxHy_2z_2z1 (0x0104)
> +#define HIACE_GAMMA_EN (0x0108)
> +#define HIACE_GAMMA_VxHy_3z2_3z1_3z_W (0x010c)
> +#define HIACE_GAMMA_EN_HV_R (0x0110)
> +#define HIACE_GAMMA_VxHy_3z2_3z1_3z_R (0x0114)
> +#define HIACE_INIT_GAMMA (0x0120)
> +#define HIACE_MANUAL_RELOAD (0x0124)
> +#define HIACE_RAMCLK_FUNC (0x0128)
> +#define HIACE_CLK_GATE (0x012c)
> +#define HIACE_GAMMA_RAM_A_CFG_MEM_CTRL (0x0130)
> +#define HIACE_GAMMA_RAM_B_CFG_MEM_CTRL (0x0134)
> +#define HIACE_LHIST_RAM_CFG_MEM_CTRL (0x0138)
> +#define HIACE_GAMMA_RAM_A_CFG_PM_CTRL (0x0140)
> +#define HIACE_GAMMA_RAM_B_CFG_PM_CTRL (0x0144)
> +#define HIACE_LHIST_RAM_CFG_PM_CTRL (0x0148)
> +
> +/* IFBC */
> +#define IFBC_SIZE	(0x0000)
> +#define IFBC_CTRL	(0x0004)
> +#define IFBC_HIMAX_CTRL0	(0x0008)
> +#define IFBC_HIMAX_CTRL1	(0x000C)
> +#define IFBC_HIMAX_CTRL2	(0x0010)
> +#define IFBC_HIMAX_CTRL3	(0x0014)
> +#define IFBC_EN	(0x0018)
> +#define IFBC_MEM_CTRL	(0x001C)
> +#define IFBC_INSERT	(0x0020)
> +#define IFBC_HIMAX_TEST_MODE	(0x0024)
> +#define IFBC_CORE_GT	(0x0028)
> +#define IFBC_PM_CTRL	(0x002C)
> +#define IFBC_RD_SHADOW	(0x0030)
> +#define IFBC_ORISE_CTL	(0x0034)
> +#define IFBC_ORSISE_DEBUG0	(0x0038)
> +#define IFBC_ORSISE_DEBUG1	(0x003C)
> +#define IFBC_RSP_COMP_TEST	(0x0040)
> +#define IFBC_CLK_SEL	(0x044)
> +#define IFBC_CLK_EN	(0x048)
> +#define IFBC_PAD	(0x004C)
> +#define IFBC_REG_DEFAULT	(0x0050)
> +
> +/* DSC */
> +#define DSC_VERSION	(0x0000)
> +#define DSC_PPS_IDENTIFIER	(0x0004)
> +#define DSC_EN	(0x0008)
> +#define DSC_CTRL	(0x000C)
> +#define DSC_PIC_SIZE	(0x0010)
> +#define DSC_SLICE_SIZE	(0x0014)
> +#define DSC_CHUNK_SIZE	(0x0018)
> +#define DSC_INITIAL_DELAY	(0x001C)
> +#define DSC_RC_PARAM0	(0x0020)
> +#define DSC_RC_PARAM1	(0x0024)
> +#define DSC_RC_PARAM2	(0x0028)
> +#define DSC_RC_PARAM3	(0x002C)
> +#define DSC_FLATNESS_QP_TH	(0x0030)
> +#define DSC_RC_PARAM4	(0x0034)
> +#define DSC_RC_PARAM5	(0x0038)
> +#define DSC_RC_BUF_THRESH0	(0x003C)
> +#define DSC_RC_BUF_THRESH1	(0x0040)
> +#define DSC_RC_BUF_THRESH2	(0x0044)
> +#define DSC_RC_BUF_THRESH3	(0x0048)
> +#define DSC_RC_RANGE_PARAM0	(0x004C)
> +#define DSC_RC_RANGE_PARAM1	(0x0050)
> +#define DSC_RC_RANGE_PARAM2	(0x0054)
> +#define DSC_RC_RANGE_PARAM3	(0x0058)
> +#define DSC_RC_RANGE_PARAM4	(0x005C)
> +#define DSC_RC_RANGE_PARAM5	(0x0060)
> +#define DSC_RC_RANGE_PARAM6	(0x0064)
> +#define DSC_RC_RANGE_PARAM7	(0x0068)
> +#define DSC_ADJUSTMENT_BITS	(0x006C)
> +#define DSC_BITS_PER_GRP	(0x0070)
> +#define DSC_MULTI_SLICE_CTL	(0x0074)
> +#define DSC_OUT_CTRL	(0x0078)
> +#define DSC_CLK_SEL	(0x007C)
> +#define DSC_CLK_EN	(0x0080)
> +#define DSC_MEM_CTRL	(0x0084)
> +#define DSC_ST_DATAIN	(0x0088)
> +#define DSC_ST_DATAOUT	(0x008C)
> +#define DSC0_ST_SLC_POS	(0x0090)
> +#define DSC1_ST_SLC_POS	(0x0094)
> +#define DSC0_ST_PIC_POS	(0x0098)
> +#define DSC1_ST_PIC_POS	(0x009C)
> +#define DSC0_ST_FIFO	(0x00A0)
> +#define DSC1_ST_FIFO	(0x00A4)
> +#define DSC0_ST_LINEBUF	(0x00A8)
> +#define DSC1_ST_LINEBUF	(0x00AC)
> +#define DSC_ST_ITFC	(0x00B0)
> +#define DSC_RD_SHADOW_SEL	(0x00B4)
> +#define DSC_REG_DEFAULT	(0x00B8)
> +
> +/* LDI */
> +#define LDI_DPI0_HRZ_CTRL0	(0x0000)
> +#define LDI_DPI0_HRZ_CTRL1	(0x0004)
> +#define LDI_DPI0_HRZ_CTRL2	(0x0008)
> +#define LDI_VRT_CTRL0	(0x000C)
> +#define LDI_VRT_CTRL1	(0x0010)
> +#define LDI_VRT_CTRL2	(0x0014)
> +#define LDI_PLR_CTRL	(0x0018)
> +#define LDI_SH_MASK_INT	(0x001C)
> +#define LDI_3D_CTRL	(0x0020)
> +#define LDI_CTRL	(0x0024)
> +#define LDI_WORK_MODE	(0x0028)
> +#define LDI_DE_SPACE_LOW	(0x002C)
> +#define LDI_DSI_CMD_MOD_CTRL	(0x0030)
> +#define LDI_DSI_TE_CTRL	(0x0034)
> +#define LDI_DSI_TE_HS_NUM	(0x0038)
> +#define LDI_DSI_TE_HS_WD	(0x003C)
> +#define LDI_DSI_TE_VS_WD	(0x0040)
> +#define LDI_FRM_MSK	(0x0044)
> +#define LDI_FRM_MSK_UP	(0x0048)
> +#define LDI_VINACT_MSK_LEN	(0x0050)
> +#define LDI_VSTATE	(0x0054)
> +#define LDI_DPI0_HSTATE	(0x0058)
> +#define LDI_DPI1_HSTATE	(0x005C)
> +#define LDI_CMD_EVENT_SEL	(0x0060)
> +#define LDI_SRAM_LP_CTRL	(0x0064)
> +#define LDI_ITF_RD_SHADOW	(0x006C)
> +#define LDI_DPI1_HRZ_CTRL0	(0x00F0)
> +#define LDI_DPI1_HRZ_CTRL1	(0x00F4)
> +#define LDI_DPI1_HRZ_CTRL2	(0x00F8)
> +#define LDI_OVERLAP_SIZE	(0x00FC)
> +#define LDI_MEM_CTRL	(0x0100)
> +#define LDI_PM_CTRL	(0x0104)
> +#define LDI_CLK_SEL	(0x0108)
> +#define LDI_CLK_EN	(0x010C)
> +#define LDI_IF_BYPASS	(0x0110)
> +#define LDI_FRM_VALID_DBG (0x0118)
> +/* LDI GLB*/
> +#define LDI_PXL0_DIV2_GT_EN (0x0210)
> +#define LDI_PXL0_DIV4_GT_EN (0x0214)
> +#define LDI_PXL0_GT_EN (0x0218)
> +#define LDI_PXL0_DSI_GT_EN (0x021C)
> +#define LDI_PXL0_DIVXCFG (0x0220)
> +#define LDI_DSI1_CLK_SEL (0x0224)
> +#define LDI_VESA_CLK_SEL (0x0228)
> +/* DSI1 RST*/
> +#define LDI_DSI1_RST_SEL (0x0238)
> +/* LDI INTERRUPT*/
> +#define LDI_MCU_ITF_INTS (0x0240)
> +#define LDI_MCU_ITF_INT_MSK (0x0244)
> +#define LDI_CPU_ITF_INTS (0x0248)
> +#define LDI_CPU_ITF_INT_MSK (0x024C)
> +/* LDI MODULE CLOCK GATING*/
> +#define LDI_MODULE_CLK_SEL (0x0258)
> +#define LDI_MODULE_CLK_EN (0x025C)
> +
> +/* MIPI DSI */
> +#define MIPIDSI_VERSION_OFFSET	(0x0000)
> +#define MIPIDSI_PWR_UP_OFFSET	(0x0004)
> +#define MIPIDSI_CLKMGR_CFG_OFFSET	(0x0008)
> +#define MIPIDSI_DPI_VCID_OFFSET	(0x000c)
> +#define MIPIDSI_DPI_COLOR_CODING_OFFSET	(0x0010)
> +#define MIPIDSI_DPI_CFG_POL_OFFSET	(0x0014)
> +#define MIPIDSI_DPI_LP_CMD_TIM_OFFSET	(0x0018)
> +#define MIPIDSI_PCKHDL_CFG_OFFSET	(0x002c)
> +#define MIPIDSI_GEN_VCID_OFFSET	(0x0030)
> +#define MIPIDSI_MODE_CFG_OFFSET	(0x0034)
> +#define MIPIDSI_VID_MODE_CFG_OFFSET	(0x0038)
> +#define MIPIDSI_VID_PKT_SIZE_OFFSET	(0x003c)
> +#define MIPIDSI_VID_NUM_CHUNKS_OFFSET	(0x0040)
> +#define MIPIDSI_VID_NULL_SIZE_OFFSET	(0x0044)
> +#define MIPIDSI_VID_HSA_TIME_OFFSET	(0x0048)
> +#define MIPIDSI_VID_HBP_TIME_OFFSET	(0x004c)
> +#define MIPIDSI_VID_HLINE_TIME_OFFSET	(0x0050)
> +#define MIPIDSI_VID_VSA_LINES_OFFSET	(0x0054)
> +#define MIPIDSI_VID_VBP_LINES_OFFSET	(0x0058)
> +#define MIPIDSI_VID_VFP_LINES_OFFSET	(0x005c)
> +#define MIPIDSI_VID_VACTIVE_LINES_OFFSET	(0x0060)
> +#define MIPIDSI_EDPI_CMD_SIZE_OFFSET	(0x0064)
> +#define MIPIDSI_CMD_MODE_CFG_OFFSET	(0x0068)
> +#define MIPIDSI_GEN_HDR_OFFSET	(0x006c)
> +#define MIPIDSI_GEN_PLD_DATA_OFFSET	(0x0070)
> +#define MIPIDSI_CMD_PKT_STATUS_OFFSET	(0x0074)
> +#define MIPIDSI_TO_CNT_CFG_OFFSET	(0x0078)
> +#define MIPIDSI_HS_RD_TO_CNT_OFFSET	(0x007C)
> +#define MIPIDSI_LP_RD_TO_CNT_OFFSET	(0x0080)
> +#define MIPIDSI_HS_WR_TO_CNT_OFFSET	(0x0084)
> +#define MIPIDSI_LP_WR_TO_CNT_OFFSET	(0x0088)
> +#define MIPIDSI_BTA_TO_CNT_OFFSET	(0x008C)
> +#define MIPIDSI_SDF_3D_OFFSET	(0x0090)
> +#define MIPIDSI_LPCLK_CTRL_OFFSET	(0x0094)
> +#define MIPIDSI_DSC_PARAMETER_OFFSET	(0x00f0)
> +#define MIPIDSI_PHY_TMR_RD_CFG_OFFSET	(0x00f4)
> +#define MIPIDSI_PHY_TMR_LPCLK_CFG_OFFSET	(0x0098)
> +#define MIPIDSI_PHY_TMR_CFG_OFFSET	(0x009c)
> +#define MIPIDSI_PHY_RSTZ_OFFSET	(0x00a0)
> +#define MIPIDSI_PHY_IF_CFG_OFFSET	(0x00a4)
> +#define MIPIDSI_PHY_ULPS_CTRL_OFFSET	(0x00a8)
> +#define MIPIDSI_PHY_TX_TRIGGERS_OFFSET	(0x00ac)
> +#define MIPIDSI_PHY_STATUS_OFFSET	(0x00b0)
> +#define MIPIDSI_PHY_TST_CTRL0_OFFSET	(0x00b4)
> +#define MIPIDSI_PHY_TST_CTRL1_OFFSET	(0x00b8)
> +#define MIPIDSI_PHY_TST_CLK_PRE_DELAY (0x00B0)
> +#define MIPIDSI_PHY_TST_CLK_POST_DELAY (0x00B1)
> +#define MIPIDSI_PHY_TST_CLK_TLPX (0x00B2)
> +#define MIPIDSI_PHY_TST_CLK_PREPARE (0x00B3)
> +#define MIPIDSI_PHY_TST_CLK_ZERO (0x00B4)
> +#define MIPIDSI_PHY_TST_CLK_TRAIL (0x00B5)
> +#define MIPIDSI_PHY_TST_DATA_PRE_DELAY (0x0070)
> +#define MIPIDSI_PHY_TST_DATA_POST_DELAY (0x0071)
> +#define MIPIDSI_PHY_TST_DATA_TLPX (0x0072)
> +#define MIPIDSI_PHY_TST_DATA_PREPARE (0x0073)
> +#define MIPIDSI_PHY_TST_DATA_ZERO (0x0074)
> +#define MIPIDSI_PHY_TST_DATA_TRAIL (0x0075)
> +#define MIPIDSI_PHY_TST_LANE_TRANSMISSION_PROPERTY (0x0077)
> +#define MIPIDSI_INT_ST0_OFFSET	(0x00bc)
> +#define MIPIDSI_INT_ST1_OFFSET	(0x00c0)
> +#define MIPIDSI_INT_MSK0_OFFSET	(0x00c4)
> +#define MIPIDSI_INT_MSK1_OFFSET	(0x00c8)
> +#define INT_FORCE0	(0x00D8)
> +#define INT_FORCE1	(0x00DC)
> +#define VID_SHADOW_CTRL	(0x0100)
> +#define DPI_VCID_ACT	(0x010C)
> +#define DPI_COLOR_CODING_ACT	(0x0110)
> +#define DPI_LP_CMD_TIM_ACT	(0x0118)
> +#define VID_MODE_CFG_ACT	(0x0138)
> +#define VID_PKT_SIZE_ACT	(0x013C)
> +#define VID_NUM_CHUNKS_ACT	(0x0140)
> +#define VID_NULL_SIZE_ACT	(0x0144)
> +#define VID_HSA_TIME_ACT	(0x0148)
> +#define VID_HBP_TIME_ACT	(0x014C)
> +#define VID_HLINE_TIME_ACT	(0x0150)
> +#define VID_VSA_LINES_ACT	(0x0154)
> +#define VID_VBP_LINES_ACT	(0x0158)
> +#define VID_VFP_LINES_ACT	(0x015C)
> +#define VID_VACTIVE_LINES_ACT	(0x0160)
> +#define SDF_3D_ACT	(0x0190)
> +
> +/* MMBUF */
> +#define SMC_LOCK	(0x0000)
> +#define SMC_MEM_LP	(0x0004)
> +#define SMC_GCLK_CS	(0x000C)
> +#define SMC_QOS_BACKDOOR	(0x0010)
> +#define SMC_DFX_WCMD_CNT_1ST	(0x0014)
> +#define SMC_DFX_WCMD_CNT_2ND	(0x0018)
> +#define SMC_DFX_WCMD_CNT_3RD	(0x001C)
> +#define SMC_DFX_WCMD_CNT_4TH	(0x0020)
> +#define SMC_DFX_RCMD_CNT_1ST	(0x0024)
> +#define SMC_DFX_RCMD_CNT_2ND	(0x0028)
> +#define SMC_DFX_RCMD_CNT_3RD	(0x002C)
> +#define SMC_DFX_RCMD_CNT_4TH	(0x0030)
> +#define SMC_CS_IDLE	(0x0034)
> +#define SMC_DFX_BFIFO_CNT0	(0x0038)
> +#define SMC_DFX_RDFIFO_CNT1	(0x003C)
> +#define SMC_SP_SRAM_STATE0	(0x0040)
> +#define SMC_SP_SRAM_STATE1	(0x0044)
> +
> +#define MIPI_DPHY_NUM	(2)
> +
> +struct mipi_ifbc_division {
> +	u32 xres_div;
> +	u32 yres_div;
> +	u32 comp_mode;
> +	u32 pxl0_div2_gt_en;
> +	u32 pxl0_div4_gt_en;
> +	u32 pxl0_divxcfg;
> +	u32 pxl0_dsi_gt_en;
> +};
> +
> +/* MMBUF */
> +
> +/* IFBC compress mode */
> +enum IFBC_TYPE {
> +	IFBC_TYPE_NONE = 0,
> +	IFBC_TYPE_ORISE2X,
> +	IFBC_TYPE_ORISE3X,
> +	IFBC_TYPE_HIMAX2X,
> +	IFBC_TYPE_RSP2X,
> +	IFBC_TYPE_RSP3X,
> +	IFBC_TYPE_VESA2X_SINGLE,
> +	IFBC_TYPE_VESA3X_SINGLE,
> +	IFBC_TYPE_VESA2X_DUAL,
> +	IFBC_TYPE_VESA3X_DUAL,
> +	IFBC_TYPE_VESA3_75X_DUAL,
> +
> +	IFBC_TYPE_MAX
> +};
> +
> +/* IFBC compress mode */
> +enum IFBC_COMP_MODE {
> +	IFBC_COMP_MODE_0 = 0,
> +	IFBC_COMP_MODE_1,
> +	IFBC_COMP_MODE_2,
> +	IFBC_COMP_MODE_3,
> +	IFBC_COMP_MODE_4,
> +	IFBC_COMP_MODE_5,
> +	IFBC_COMP_MODE_6,
> +};
> +
> +/* xres_div */
> +enum XRES_DIV {
> +	XRES_DIV_1 = 1,
> +	XRES_DIV_2,
> +	XRES_DIV_3,
> +	XRES_DIV_4,
> +	XRES_DIV_5,
> +	XRES_DIV_6,
> +};
> +
> +/* yres_div */
> +enum YRES_DIV {
> +	YRES_DIV_1 = 1,
> +	YRES_DIV_2,
> +	YRES_DIV_3,
> +	YRES_DIV_4,
> +	YRES_DIV_5,
> +	YRES_DIV_6,
> +};
> +
> +/* pxl0_divxcfg */
> +enum PXL0_DIVCFG {
> +	PXL0_DIVCFG_0 = 0,
> +	PXL0_DIVCFG_1,
> +	PXL0_DIVCFG_2,
> +	PXL0_DIVCFG_3,
> +	PXL0_DIVCFG_4,
> +	PXL0_DIVCFG_5,
> +	PXL0_DIVCFG_6,
> +	PXL0_DIVCFG_7,
> +};
> +
> +/* pxl0_div2_gt_en */
> +enum PXL0_DIV2_GT_EN {
> +	PXL0_DIV2_GT_EN_CLOSE = 0,
> +	PXL0_DIV2_GT_EN_OPEN,
> +};
> +
> +/* pxl0_div4_gt_en */
> +enum PXL0_DIV4_GT_EN {
> +	PXL0_DIV4_GT_EN_CLOSE = 0,
> +	PXL0_DIV4_GT_EN_OPEN,
> +};
> +
> +/* pxl0_dsi_gt_en */
> +enum PXL0_DSI_GT_EN {
> +	PXL0_DSI_GT_EN_0 = 0,
> +	PXL0_DSI_GT_EN_1,
> +	PXL0_DSI_GT_EN_2,
> +	PXL0_DSI_GT_EN_3,
> +};
> +
> +/*****************************************************************************/
> +
> +#ifndef ALIGN_DOWN
> +#define ALIGN_DOWN(val, al)  ((val) & ~((al) - 1))
> +#endif
> +
> +#ifndef ALIGN_UP
> +#define ALIGN_UP(val, al)    (((val) + ((al) - 1)) & ~((al) - 1))
> +#endif
There are generic macros for these - drop the local copies.

> +
> +#define to_dss_crtc(crtc) container_of(crtc, struct dss_crtc, base)
> +#define to_dss_plane(plane) container_of(plane, struct dss_plane, base)
> +
> +#endif
> diff --git a/drivers/staging/hikey9xx/gpu/kirin9xx_drm_dpe_utils.c b/drivers/staging/hikey9xx/gpu/kirin9xx_drm_dpe_utils.c
> new file mode 100644
> index 000000000000..82a0edb95953
> --- /dev/null
> +++ b/drivers/staging/hikey9xx/gpu/kirin9xx_drm_dpe_utils.c
> @@ -0,0 +1,1178 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2013-2014, Hisilicon Tech. Co., Ltd. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
> + * GNU General Public License for more details.
> + *
> + */
> +#include <drm/drm_drv.h>
> +#include <drm/drm_mipi_dsi.h>
> +
> +#include "kirin9xx_drm_dpe_utils.h"
> +#include "kirin9xx_dpe.h"
> +
> +DEFINE_SEMAPHORE(hisi_fb_dss_regulator_sem);
static?

> +
> +struct mipi_ifbc_division g_mipi_ifbc_division[MIPI_DPHY_NUM][IFBC_TYPE_MAX] = {
> +	/*single mipi*/
> +	{
> +			/*none*/
> +		{
> +			XRES_DIV_1, YRES_DIV_1, IFBC_COMP_MODE_0, PXL0_DIV2_GT_EN_CLOSE,
> +			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_0, PXL0_DSI_GT_EN_1
> +		}, {
> +			/*orise2x*/
> +			XRES_DIV_2, YRES_DIV_1, IFBC_COMP_MODE_0, PXL0_DIV2_GT_EN_OPEN,
> +			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_1, PXL0_DSI_GT_EN_3
> +		}, {
> +			/*orise3x*/
> +			XRES_DIV_3, YRES_DIV_1, IFBC_COMP_MODE_1, PXL0_DIV2_GT_EN_OPEN,
> +			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_2, PXL0_DSI_GT_EN_3
> +		}, {
> +			/*himax2x*/
> +			XRES_DIV_2, YRES_DIV_1, IFBC_COMP_MODE_2, PXL0_DIV2_GT_EN_OPEN,
> +			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_1, PXL0_DSI_GT_EN_3
> +		}, {
> +			/*rsp2x*/
> +			XRES_DIV_2, YRES_DIV_1, IFBC_COMP_MODE_3, PXL0_DIV2_GT_EN_CLOSE,
> +			PXL0_DIV4_GT_EN_OPEN, PXL0_DIVCFG_1, PXL0_DSI_GT_EN_3
> +		}, {
> +			/*
> +			 * rsp3x
> +			 * NOTE: in reality: xres_div = 1.5, yres_div = 2,
> +			 * amended in "mipi_ifbc_get_rect" function
> +			 */
> +			XRES_DIV_3, YRES_DIV_1, IFBC_COMP_MODE_4, PXL0_DIV2_GT_EN_CLOSE,
> +			PXL0_DIV4_GT_EN_OPEN, PXL0_DIVCFG_2, PXL0_DSI_GT_EN_3
> +		}, {
> +			/*vesa2x_1pipe*/
> +			XRES_DIV_2, YRES_DIV_1, IFBC_COMP_MODE_5, PXL0_DIV2_GT_EN_CLOSE,
> +			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_1, PXL0_DSI_GT_EN_3
> +		}, {
> +			/*vesa3x_1pipe*/
> +			XRES_DIV_3, YRES_DIV_1, IFBC_COMP_MODE_5, PXL0_DIV2_GT_EN_CLOSE,
> +			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_2, PXL0_DSI_GT_EN_3
> +		}, {
> +			/*vesa2x_2pipe*/
> +			XRES_DIV_2, YRES_DIV_1, IFBC_COMP_MODE_6, PXL0_DIV2_GT_EN_OPEN,
> +			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_1, PXL0_DSI_GT_EN_3
> +		}, {
> +			/*vesa3x_2pipe*/
> +			XRES_DIV_3, YRES_DIV_1, IFBC_COMP_MODE_6, PXL0_DIV2_GT_EN_OPEN,
> +			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_2, PXL0_DSI_GT_EN_3
> +		}
> +
> +	/*dual mipi*/
> +	}, {
> +		{
> +			/*none*/
> +			XRES_DIV_2, YRES_DIV_1, IFBC_COMP_MODE_0, PXL0_DIV2_GT_EN_CLOSE,
> +			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_1, PXL0_DSI_GT_EN_3
> +		}, {
> +			/*orise2x*/
> +			XRES_DIV_4, YRES_DIV_1, IFBC_COMP_MODE_0, PXL0_DIV2_GT_EN_OPEN,
> +			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_3, PXL0_DSI_GT_EN_3
> +		}, {
> +			/*orise3x*/
> +			XRES_DIV_6, YRES_DIV_1, IFBC_COMP_MODE_1, PXL0_DIV2_GT_EN_OPEN,
> +			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_5, PXL0_DSI_GT_EN_3
> +		}, {
> +			/*himax2x*/
> +			XRES_DIV_4, YRES_DIV_1, IFBC_COMP_MODE_2, PXL0_DIV2_GT_EN_OPEN,
> +			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_3, PXL0_DSI_GT_EN_3
> +		}, {
> +			/*rsp2x*/
> +			XRES_DIV_4, YRES_DIV_1, IFBC_COMP_MODE_3, PXL0_DIV2_GT_EN_CLOSE,
> +			PXL0_DIV4_GT_EN_OPEN, PXL0_DIVCFG_3, PXL0_DSI_GT_EN_3
> +		}, {
> +			/*rsp3x*/
> +			XRES_DIV_3, YRES_DIV_2, IFBC_COMP_MODE_4, PXL0_DIV2_GT_EN_CLOSE,
> +			PXL0_DIV4_GT_EN_OPEN, PXL0_DIVCFG_5, PXL0_DSI_GT_EN_3
> +		}, {
> +			/*vesa2x_1pipe*/
> +			XRES_DIV_4, YRES_DIV_1, IFBC_COMP_MODE_5, PXL0_DIV2_GT_EN_CLOSE,
> +			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_3, PXL0_DSI_GT_EN_3
> +		}, {
> +			/*vesa3x_1pipe*/
> +			XRES_DIV_6, YRES_DIV_1, IFBC_COMP_MODE_5, PXL0_DIV2_GT_EN_CLOSE,
> +			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_5, PXL0_DSI_GT_EN_3
> +		}, {
> +			/*vesa2x_2pipe*/
> +			XRES_DIV_4, YRES_DIV_1, IFBC_COMP_MODE_6, PXL0_DIV2_GT_EN_OPEN,
> +			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_3, PXL0_DSI_GT_EN_3
> +		}, {
> +			/*vesa3x_2pipe*/
> +			XRES_DIV_6, YRES_DIV_1, IFBC_COMP_MODE_6, PXL0_DIV2_GT_EN_OPEN,
> +			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_5, 3
> +		}
> +	}
> +};
> +
> +u32 set_bits32(u32 old_val, uint32_t val, uint8_t bw, uint8_t bs)
> +{
> +	u32 mask = (1UL << bw) - 1UL;
> +	u32 tmp = 0;
> +
> +	tmp = old_val;
> +	tmp &= ~(mask << bs);
> +
> +	return (tmp | ((val & mask) << bs));
> +}
> +
> +static int mipi_ifbc_get_rect(struct dss_rect *rect)
> +{
> +	u32 ifbc_type;
> +	u32 mipi_idx;
> +	u32 xres_div;
> +	u32 yres_div;
> +
> +	ifbc_type = IFBC_TYPE_NONE;
> +	mipi_idx = 0;
> +
> +	xres_div = g_mipi_ifbc_division[mipi_idx][ifbc_type].xres_div;
> +	yres_div = g_mipi_ifbc_division[mipi_idx][ifbc_type].yres_div;
> +
> +	if ((rect->w % xres_div) > 0)
> +		DRM_ERROR("xres(%d) is not division_h(%d) pixel aligned!\n", rect->w, xres_div);
> +
> +	if ((rect->h % yres_div) > 0)
> +		DRM_ERROR("yres(%d) is not division_v(%d) pixel aligned!\n", rect->h, yres_div);
> +
> +	/*
> +	 * NOTE: rsp3x && single_mipi CMD mode amended xres_div = 1.5,
> +	 *  yres_div = 2,
> +	 * VIDEO mode amended xres_div = 3, yres_div = 1
> +	 */
> +	rect->w /= xres_div;
> +	rect->h /= yres_div;
> +
> +	return 0;
> +}
> +
> +static void init_ldi_pxl_div(struct dss_crtc *acrtc)
> +{
> +	struct dss_hw_ctx *ctx;
> +	char __iomem *ldi_base;
> +	struct drm_display_mode *mode;
> +	struct drm_display_mode *adj_mode;
> +
> +	u32 ifbc_type = 0;
> +	u32 mipi_idx = 0;
> +	u32 pxl0_div2_gt_en = 0;
> +	u32 pxl0_div4_gt_en = 0;
> +	u32 pxl0_divxcfg = 0;
> +	u32 pxl0_dsi_gt_en = 0;
> +
> +	ctx = acrtc->ctx;
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL!\n");
> +		return;
> +	}
drm_device is available via dss_crtc - so use drm_* based logging.
Goes for everywhere where drm_device can be obtained and DRM_ is used
for logging.


> +
> +	mode = &acrtc->base.state->mode;
> +	adj_mode = &acrtc->base.state->adjusted_mode;
> +
> +	ldi_base = ctx->base + DSS_LDI0_OFFSET;
> +
> +	ifbc_type = IFBC_TYPE_NONE;
> +	mipi_idx = 0;
> +
> +	pxl0_div2_gt_en = g_mipi_ifbc_division[mipi_idx][ifbc_type].pxl0_div2_gt_en;
> +	pxl0_div4_gt_en = g_mipi_ifbc_division[mipi_idx][ifbc_type].pxl0_div4_gt_en;
> +	pxl0_divxcfg = g_mipi_ifbc_division[mipi_idx][ifbc_type].pxl0_divxcfg;
> +	pxl0_dsi_gt_en = g_mipi_ifbc_division[mipi_idx][ifbc_type].pxl0_dsi_gt_en;
> +
> +	set_reg(ldi_base + LDI_PXL0_DIV2_GT_EN, pxl0_div2_gt_en, 1, 0);
> +	set_reg(ldi_base + LDI_PXL0_DIV4_GT_EN, pxl0_div4_gt_en, 1, 0);
> +	set_reg(ldi_base + LDI_PXL0_GT_EN, 0x1, 1, 0);
> +	set_reg(ldi_base + LDI_PXL0_DSI_GT_EN, pxl0_dsi_gt_en, 2, 0);
> +	set_reg(ldi_base + LDI_PXL0_DIVXCFG, pxl0_divxcfg, 3, 0);
> +}
> +
> +void init_other(struct dss_crtc *acrtc)
> +{
> +	struct dss_hw_ctx *ctx;
> +	char __iomem *dss_base;
> +
> +	ctx = acrtc->ctx;
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL!\n");
> +		return;
> +	}
> +
> +	dss_base = ctx->base;
> +
> +	/**
> +	 * VESA_CLK_SEL is set to 0 for initial,
> +	 * 1 is needed only by vesa dual pipe compress
> +	 */
> +	set_reg(dss_base + DSS_LDI0_OFFSET + LDI_VESA_CLK_SEL, 0, 1, 0);
> +}
> +
> +void init_ldi(struct dss_crtc *acrtc)
> +{
> +	struct dss_hw_ctx *ctx;
> +	char __iomem *ldi_base;
> +	struct drm_display_mode *mode;
> +	struct drm_display_mode *adj_mode;
> +
> +	struct dss_rect rect = {0, 0, 0, 0};
> +	u32 hfp, hbp, hsw, vfp, vbp, vsw;
> +	u32 vsync_plr = 0;
> +	u32 hsync_plr = 0;
> +	u32 pixelclk_plr = 0;
> +	u32 data_en_plr = 0;
> +
> +	ctx = acrtc->ctx;
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL!\n");
> +		return;
> +	}
> +
> +	mode = &acrtc->base.state->mode;
> +	adj_mode = &acrtc->base.state->adjusted_mode;
> +
> +	hfp = mode->hsync_start - mode->hdisplay;
> +	hbp = mode->htotal - mode->hsync_end;
> +	hsw = mode->hsync_end - mode->hsync_start;
> +	vfp = mode->vsync_start - mode->vdisplay;
> +	vbp = mode->vtotal - mode->vsync_end;
> +	vsw = mode->vsync_end - mode->vsync_start;
> +
> +	ldi_base = ctx->base + DSS_LDI0_OFFSET;
> +
> +	rect.x = 0;
> +	rect.y = 0;
> +	rect.w = mode->hdisplay;
> +	rect.h = mode->vdisplay;
> +	mipi_ifbc_get_rect(&rect);
> +
> +	init_ldi_pxl_div(acrtc);
> +
> +	writel(hfp | ((hbp + DSS_WIDTH(hsw)) << 16),
> +	       ldi_base + LDI_DPI0_HRZ_CTRL0);
> +	writel(0, ldi_base + LDI_DPI0_HRZ_CTRL1);
> +	writel(DSS_WIDTH(rect.w), ldi_base + LDI_DPI0_HRZ_CTRL2);
> +	writel(vfp | (vbp << 16), ldi_base + LDI_VRT_CTRL0);
> +	writel(DSS_HEIGHT(vsw), ldi_base + LDI_VRT_CTRL1);
> +	writel(DSS_HEIGHT(rect.h), ldi_base + LDI_VRT_CTRL2);
> +
> +	writel(vsync_plr | (hsync_plr << 1) | (pixelclk_plr << 2) | (data_en_plr << 3),
> +	       ldi_base + LDI_PLR_CTRL);
> +
> +	/* bpp*/
> +	set_reg(ldi_base + LDI_CTRL, acrtc->out_format, 2, 3);
> +	/* bgr*/
> +	set_reg(ldi_base + LDI_CTRL, acrtc->bgr_fmt, 1, 13);
> +
> +	/* for ddr pmqos*/
> +	writel(vfp, ldi_base + LDI_VINACT_MSK_LEN);
> +
> +	/*cmd event sel*/
> +	writel(0x1, ldi_base + LDI_CMD_EVENT_SEL);
> +
> +	/* for 1Hz LCD and mipi command LCD*/
> +	set_reg(ldi_base + LDI_DSI_CMD_MOD_CTRL, 0x1, 1, 1);
> +
> +	/*ldi_data_gate(ctx, true);*/
> +
> +	/* normal*/
> +	set_reg(ldi_base + LDI_WORK_MODE, 0x1, 1, 0);
> +
> +	/* ldi disable*/
> +	set_reg(ldi_base + LDI_CTRL, 0x0, 1, 0);
> +}
> +
> +void deinit_ldi(struct dss_crtc *acrtc)
> +{
> +	struct dss_hw_ctx *ctx;
> +	char __iomem *ldi_base;
> +
> +	ctx = acrtc->ctx;
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL!\n");
> +		return;
> +	}
> +
> +	ldi_base = ctx->base + DSS_LDI0_OFFSET;
> +
> +	/* ldi disable*/
> +	set_reg(ldi_base + LDI_CTRL, 0, 1, 0);
> +}
> +
> +void init_dbuf(struct dss_crtc *acrtc)
> +{
> +	struct dss_hw_ctx *ctx;
> +	struct drm_display_mode *mode;
> +	struct drm_display_mode *adj_mode;
> +	char __iomem *dbuf_base;
> +
> +	int sram_valid_num = 0;
> +	int sram_max_mem_depth = 0;
> +	int sram_min_support_depth = 0;
> +
> +	u32 thd_rqos_in = 0;
> +	u32 thd_rqos_out = 0;
> +	u32 thd_wqos_in = 0;
> +	u32 thd_wqos_out = 0;
> +	u32 thd_cg_in = 0;
> +	u32 thd_cg_out = 0;
> +	u32 thd_wr_wait = 0;
> +	u32 thd_cg_hold = 0;
> +	u32 thd_flux_req_befdfs_in = 0;
> +	u32 thd_flux_req_befdfs_out = 0;
> +	u32 thd_flux_req_aftdfs_in = 0;
> +	u32 thd_flux_req_aftdfs_out = 0;
> +	u32 thd_dfs_ok = 0;
> +	u32 dfs_ok_mask = 0;
> +	u32 thd_flux_req_sw_en = 1;
> +	u32 hfp, hbp, hsw, vfp, vbp, vsw;
> +
> +	int dfs_time = 0;
> +	int dfs_time_min = 0;
> +	int depth = 0;
> +	int dfs_ram = 0;
> +
> +	ctx = acrtc->ctx;
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL!\n");
> +		return;
> +	}
> +
> +	mode = &acrtc->base.state->mode;
> +	adj_mode = &acrtc->base.state->adjusted_mode;
> +
> +	hfp = mode->hsync_start - mode->hdisplay;
> +	hbp = mode->htotal - mode->hsync_end;
> +	hsw = mode->hsync_end - mode->hsync_start;
> +	vfp = mode->vsync_start - mode->vdisplay;
> +	vbp = mode->vtotal - mode->vsync_end;
> +	vsw = mode->vsync_end - mode->vsync_start;
> +
> +	dbuf_base = ctx->base + DSS_DBUF0_OFFSET;
> +
> +	if (mode->hdisplay * mode->vdisplay >= RES_4K_PHONE) {
> +		dfs_time_min = DFS_TIME_MIN_4K;
> +		dfs_ram = 0x0;
> +	} else {
> +		dfs_time_min = DFS_TIME_MIN;
> +		dfs_ram = 0xF00;
> +	}
> +
> +	dfs_time = DFS_TIME;
> +	depth = DBUF0_DEPTH;
> +
> +	DRM_DEBUG("dfs_time=%d,\n"
> +		"adj_mode->clock=%d\n"
> +		"hsw=%d\n"
> +		"hbp=%d\n"
> +		"hfp=%d\n"
> +		"htotal=%d\n"
> +		"vfp = %d\n"
> +		"vbp = %d\n"
> +		"vsw = %d\n"
> +		"vtotal=%d\n"
> +		"mode->hdisplay=%d\n"
> +		"mode->vdisplay=%d\n",
> +		dfs_time,
> +		adj_mode->clock,
> +		hsw,
> +		hbp,
> +		hfp,
> +		mode->htotal,
> +		vfp,
> +		vbp,
> +		vsw,
> +		mode->vtotal,
> +		mode->hdisplay,
> +		mode->vdisplay);
> +
> +	/*
> +	 * int K = 0;
> +	 * int Tp = 1000000  / adj_mode->clock;
> +	 * K = (hsw + hbp + mode->hdisplay +
> +	 *	hfp) / mode->hdisplay;
> +	 * thd_cg_out = dfs_time / (Tp * K * 6);
> +	 */
> +	thd_cg_out = (dfs_time * adj_mode->clock * 1000UL * mode->hdisplay) /
> +		(((hsw + hbp + hfp) + mode->hdisplay) * 6 * 1000000UL);
> +
> +	sram_valid_num = thd_cg_out / depth;
> +	thd_cg_in = (sram_valid_num + 1) * depth - 1;
> +
> +	sram_max_mem_depth = (sram_valid_num + 1) * depth;
> +
> +	thd_rqos_in = thd_cg_out * 85 / 100;
> +	thd_rqos_out = thd_cg_out;
> +	thd_flux_req_befdfs_in = GET_FLUX_REQ_IN(sram_max_mem_depth);
> +	thd_flux_req_befdfs_out = GET_FLUX_REQ_OUT(sram_max_mem_depth);
> +
> +	sram_min_support_depth = dfs_time_min * mode->hdisplay / (1000000 / 60 / (mode->vdisplay +
> +		vbp + vfp + vsw) * (DBUF_WIDTH_BIT / 3 / BITS_PER_BYTE));
> +
> +	/*thd_flux_req_aftdfs_in   =[(sram_valid_num+1)*depth - 50*HSIZE/((1000000/60/(VSIZE+VFP+VBP+VSW))*6)]/3*/
> +	thd_flux_req_aftdfs_in = (sram_max_mem_depth - sram_min_support_depth) / 3;
> +	/*thd_flux_req_aftdfs_out  =  2*[(sram_valid_num+1)* depth - 50*HSIZE/((1000000/60/(VSIZE+VFP+VBP+VSW))*6)]/3*/
> +	thd_flux_req_aftdfs_out = 2 * (sram_max_mem_depth - sram_min_support_depth) / 3;
> +
> +	thd_dfs_ok = thd_flux_req_befdfs_in;
> +
> +	DRM_DEBUG("hdisplay=%d\n"
> +		"vdisplay=%d\n"
> +		"sram_valid_num=%d,\n"
> +		"thd_rqos_in=0x%x\n"
> +		"thd_rqos_out=0x%x\n"
> +		"thd_cg_in=0x%x\n"
> +		"thd_cg_out=0x%x\n"
> +		"thd_flux_req_befdfs_in=0x%x\n"
> +		"thd_flux_req_befdfs_out=0x%x\n"
> +		"thd_flux_req_aftdfs_in=0x%x\n"
> +		"thd_flux_req_aftdfs_out=0x%x\n"
> +		"thd_dfs_ok=0x%x\n",
> +		mode->hdisplay,
> +		mode->vdisplay,
> +		sram_valid_num,
> +		thd_rqos_in,
> +		thd_rqos_out,
> +		thd_cg_in,
> +		thd_cg_out,
> +		thd_flux_req_befdfs_in,
> +		thd_flux_req_befdfs_out,
> +		thd_flux_req_aftdfs_in,
> +		thd_flux_req_aftdfs_out,
> +		thd_dfs_ok);
> +
> +	writel(mode->hdisplay * mode->vdisplay, dbuf_base + DBUF_FRM_SIZE);
> +	writel(DSS_WIDTH(mode->hdisplay), dbuf_base + DBUF_FRM_HSIZE);
> +	writel(sram_valid_num, dbuf_base + DBUF_SRAM_VALID_NUM);
> +
> +	writel((thd_rqos_out << 16) | thd_rqos_in, dbuf_base + DBUF_THD_RQOS);
> +	writel((thd_wqos_out << 16) | thd_wqos_in, dbuf_base + DBUF_THD_WQOS);
> +	writel((thd_cg_out << 16) | thd_cg_in, dbuf_base + DBUF_THD_CG);
> +	writel((thd_cg_hold << 16) | thd_wr_wait, dbuf_base + DBUF_THD_OTHER);
> +	writel((thd_flux_req_befdfs_out << 16) | thd_flux_req_befdfs_in,
> +               dbuf_base + DBUF_THD_FLUX_REQ_BEF);
> +	writel((thd_flux_req_aftdfs_out << 16) | thd_flux_req_aftdfs_in,
> +               dbuf_base + DBUF_THD_FLUX_REQ_AFT);
> +	writel(thd_dfs_ok, dbuf_base + DBUF_THD_DFS_OK);
> +	writel((dfs_ok_mask << 1) | thd_flux_req_sw_en,
> +               dbuf_base + DBUF_FLUX_REQ_CTRL);
> +
> +	writel(0x1, dbuf_base + DBUF_DFS_LP_CTRL);
> +	if (ctx->g_dss_version_tag == FB_ACCEL_KIRIN970)
> +		writel(dfs_ram, dbuf_base + DBUF_DFS_RAM_MANAGE);
> +}
> +
> +void init_dpp(struct dss_crtc *acrtc)
> +{
> +	struct dss_hw_ctx *ctx;
> +	struct drm_display_mode *mode;
> +	struct drm_display_mode *adj_mode;
> +	char __iomem *dpp_base;
> +	char __iomem *mctl_sys_base;
> +
> +	ctx = acrtc->ctx;
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL!\n");
> +		return;
> +	}
> +
> +	mode = &acrtc->base.state->mode;
> +	adj_mode = &acrtc->base.state->adjusted_mode;
> +
> +	dpp_base = ctx->base + DSS_DPP_OFFSET;
> +	mctl_sys_base = ctx->base + DSS_MCTRL_SYS_OFFSET;
> +
> +	writel((DSS_HEIGHT(mode->vdisplay) << 16) | DSS_WIDTH(mode->hdisplay),
> +	       dpp_base + DPP_IMG_SIZE_BEF_SR);
> +	writel((DSS_HEIGHT(mode->vdisplay) << 16) | DSS_WIDTH(mode->hdisplay),
> +	       dpp_base + DPP_IMG_SIZE_AFT_SR);
> +}
> +
> +void enable_ldi(struct dss_crtc *acrtc)
> +{
> +	struct dss_hw_ctx *ctx;
> +	char __iomem *ldi_base;
> +
> +	ctx = acrtc->ctx;
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL!\n");
> +		return;
> +	}
> +
> +	ldi_base = ctx->base + DSS_LDI0_OFFSET;
> +
> +	/* ldi enable */
> +	set_reg(ldi_base + LDI_CTRL, 0x1, 1, 0);
> +}
> +
> +void disable_ldi(struct dss_crtc *acrtc)
> +{
> +	struct dss_hw_ctx *ctx;
> +	char __iomem *ldi_base;
> +
> +	ctx = acrtc->ctx;
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL!\n");
> +		return;
> +	}
> +
> +	ldi_base = ctx->base + DSS_LDI0_OFFSET;
> +
> +	/* ldi disable */
> +	set_reg(ldi_base + LDI_CTRL, 0x0, 1, 0);
> +}
> +
> +void dpe_interrupt_clear(struct dss_crtc *acrtc)
> +{
> +	struct dss_hw_ctx *ctx;
> +	char __iomem *dss_base;
> +	u32 clear;
> +
> +	ctx = acrtc->ctx;
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL!\n");
> +		return;
> +	}
> +
> +	dss_base = ctx->base;
> +
> +	clear = ~0;
> +	writel(clear, dss_base + GLB_CPU_PDP_INTS);
> +	writel(clear, dss_base + DSS_LDI0_OFFSET + LDI_CPU_ITF_INTS);
> +	writel(clear, dss_base + DSS_DPP_OFFSET + DPP_INTS);
> +
> +	writel(clear, dss_base + DSS_DBG_OFFSET + DBG_MCTL_INTS);
> +	writel(clear, dss_base + DSS_DBG_OFFSET + DBG_WCH0_INTS);
> +	writel(clear, dss_base + DSS_DBG_OFFSET + DBG_WCH1_INTS);
> +	writel(clear, dss_base + DSS_DBG_OFFSET + DBG_RCH0_INTS);
> +	writel(clear, dss_base + DSS_DBG_OFFSET + DBG_RCH1_INTS);
> +	writel(clear, dss_base + DSS_DBG_OFFSET + DBG_RCH2_INTS);
> +	writel(clear, dss_base + DSS_DBG_OFFSET + DBG_RCH3_INTS);
> +	writel(clear, dss_base + DSS_DBG_OFFSET + DBG_RCH4_INTS);
> +	writel(clear, dss_base + DSS_DBG_OFFSET + DBG_RCH5_INTS);
> +	writel(clear, dss_base + DSS_DBG_OFFSET + DBG_RCH6_INTS);
> +	writel(clear, dss_base + DSS_DBG_OFFSET + DBG_RCH7_INTS);
> +	writel(clear, dss_base + DSS_DBG_OFFSET + DBG_DSS_GLB_INTS);
> +}
> +
> +void dpe_interrupt_unmask(struct dss_crtc *acrtc)
> +{
> +	struct dss_hw_ctx *ctx;
> +	char __iomem *dss_base;
> +	u32 unmask;
> +
> +	ctx = acrtc->ctx;
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL!\n");
> +		return;
> +	}
> +
> +	dss_base = ctx->base;
> +
> +	unmask = ~0;
> +	unmask &= ~(BIT_ITF0_INTS | BIT_MMU_IRPT_NS);
> +	writel(unmask, dss_base + GLB_CPU_PDP_INT_MSK);
> +
> +	unmask = ~0;
> +	unmask &= ~(BIT_VSYNC | BIT_VACTIVE0_END | BIT_LDI_UNFLOW);
> +
> +	writel(unmask, dss_base + DSS_LDI0_OFFSET + LDI_CPU_ITF_INT_MSK);
> +}
> +
> +void dpe_interrupt_mask(struct dss_crtc *acrtc)
> +{
> +	struct dss_hw_ctx *ctx;
> +	char __iomem *dss_base;
> +	u32 mask;
> +
> +	ctx = acrtc->ctx;
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL!\n");
> +		return;
> +	}
> +
> +	dss_base = ctx->base;
> +
> +	mask = ~0;
> +	writel(mask, dss_base + GLB_CPU_PDP_INT_MSK);
> +	writel(mask, dss_base + DSS_LDI0_OFFSET + LDI_CPU_ITF_INT_MSK);
> +	writel(mask, dss_base + DSS_DPP_OFFSET + DPP_INT_MSK);
> +	writel(mask, dss_base + DSS_DBG_OFFSET + DBG_DSS_GLB_INT_MSK);
> +	writel(mask, dss_base + DSS_DBG_OFFSET + DBG_MCTL_INT_MSK);
> +	writel(mask, dss_base + DSS_DBG_OFFSET + DBG_WCH0_INT_MSK);
> +	writel(mask, dss_base + DSS_DBG_OFFSET + DBG_WCH1_INT_MSK);
> +	writel(mask, dss_base + DSS_DBG_OFFSET + DBG_RCH0_INT_MSK);
> +	writel(mask, dss_base + DSS_DBG_OFFSET + DBG_RCH1_INT_MSK);
> +	writel(mask, dss_base + DSS_DBG_OFFSET + DBG_RCH2_INT_MSK);
> +	writel(mask, dss_base + DSS_DBG_OFFSET + DBG_RCH3_INT_MSK);
> +	writel(mask, dss_base + DSS_DBG_OFFSET + DBG_RCH4_INT_MSK);
> +	writel(mask, dss_base + DSS_DBG_OFFSET + DBG_RCH5_INT_MSK);
> +	writel(mask, dss_base + DSS_DBG_OFFSET + DBG_RCH6_INT_MSK);
> +	writel(mask, dss_base + DSS_DBG_OFFSET + DBG_RCH7_INT_MSK);
> +}
> +
> +int dpe_init(struct dss_crtc *acrtc)
> +{
> +	struct drm_display_mode *mode;
> +	struct drm_display_mode *adj_mode;
> +
> +	mode = &acrtc->base.state->mode;
> +	adj_mode = &acrtc->base.state->adjusted_mode;
> +
> +	init_dbuf(acrtc);
> +	init_dpp(acrtc);
> +	init_other(acrtc);
> +	init_ldi(acrtc);
> +
> +	hisifb_dss_on(acrtc->ctx);
> +	hisi_dss_mctl_on(acrtc->ctx);
> +
> +	hisi_dss_mctl_mutex_lock(acrtc->ctx);
> +
> +	hisi_dss_ovl_base_config(acrtc->ctx, mode->hdisplay, mode->vdisplay);
> +
> +	hisi_dss_mctl_mutex_unlock(acrtc->ctx);
> +
> +	enable_ldi(acrtc);
> +
> +	mdelay(60);
> +
> +	return 0;
> +}
> +
> +int dpe_deinit(struct dss_crtc *acrtc)
> +{
> +	deinit_ldi(acrtc);
> +
> +	return 0;
> +}
> +
> +void dpe_check_itf_status(struct dss_crtc *acrtc)
> +{
> +	struct dss_hw_ctx *ctx;
> +	char __iomem *mctl_sys_base = NULL;
> +	int tmp = 0;
> +	int delay_count = 0;
> +	bool is_timeout = true;
> +	int itf_idx = 0;
> +
> +	ctx = acrtc->ctx;
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL!\n");
> +		return;
> +	}
> +
> +	itf_idx = 0;
> +	mctl_sys_base =  ctx->base + DSS_MCTRL_SYS_OFFSET;
> +
> +	while (1) {
> +		tmp = readl(mctl_sys_base + MCTL_MOD17_STATUS + itf_idx * 0x4);
> +		if (((tmp & 0x10) == 0x10) || delay_count > 100) {
> +			is_timeout = (delay_count > 100) ? true : false;
> +			delay_count = 0;
> +			break;
> +		}
> +		mdelay(1);
> +		++delay_count;
> +	}
> +
> +	if (is_timeout)
> +		DRM_DEBUG_DRIVER("mctl_itf%d not in idle status,ints=0x%x !\n", itf_idx, tmp);
> +}
> +
> +void dss_inner_clk_pdp_disable(struct dss_hw_ctx *ctx)
> +{
> +}
> +
> +void dss_inner_clk_pdp_enable(struct dss_hw_ctx *ctx)
> +{
> +	char __iomem *dss_base;
> +
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL!\n");
> +		return;
> +	}
> +	dss_base = ctx->base;
> +
> +	writel(0x00000088, dss_base + DSS_IFBC_OFFSET + IFBC_MEM_CTRL);
> +	writel(0x00000888, dss_base + DSS_DSC_OFFSET + DSC_MEM_CTRL);
> +	writel(0x00000008, dss_base + DSS_LDI0_OFFSET + LDI_MEM_CTRL);
> +	writel(0x00000008, dss_base + DSS_DBUF0_OFFSET + DBUF_MEM_CTRL);
> +	writel(0x00000008, dss_base + DSS_DPP_DITHER_OFFSET + ctx->dither_mem_ctrl);
> +}
> +
> +void dss_inner_clk_common_enable(struct dss_hw_ctx *ctx)
> +{
> +	char __iomem *dss_base;
> +
> +	if (!ctx) {
> +		DRM_ERROR("NULL Pointer!\n");
> +		return;
> +	}
> +
> +	dss_base = ctx->base;
> +
> +	/*core/axi/mmbuf*/
> +	writel(0x00000008, dss_base + DSS_CMDLIST_OFFSET + CMD_MEM_CTRL);  /*cmd mem*/
> +
> +	writel(0x00000088,
> +	       dss_base + DSS_RCH_VG0_SCL_OFFSET + SCF_COEF_MEM_CTRL);/*rch_v0 ,scf mem*/
> +	writel(0x00000008,
> +	       dss_base + DSS_RCH_VG0_SCL_OFFSET + SCF_LB_MEM_CTRL);/*rch_v0 ,scf mem*/
> +	writel(0x00000008,
> +	       dss_base + DSS_RCH_VG0_ARSR_OFFSET + ctx->arsr2p_lb_mem_ctrl);/*rch_v0 ,arsr2p mem*/
> +	writel(0x00000008, dss_base + DSS_RCH_VG0_DMA_OFFSET + VPP_MEM_CTRL);/*rch_v0 ,vpp mem*/
> +	writel(0x00000008,
> +	       dss_base + DSS_RCH_VG0_DMA_OFFSET + DMA_BUF_MEM_CTRL);/*rch_v0 ,dma_buf mem*/
> +	writel(0x00008888, dss_base + DSS_RCH_VG0_DMA_OFFSET + AFBCD_MEM_CTRL);/*rch_v0 ,afbcd mem*/
> +
> +	writel(0x00000088,
> +	       dss_base + DSS_RCH_VG1_SCL_OFFSET + SCF_COEF_MEM_CTRL);/*rch_v1 ,scf mem*/
> +	writel(0x00000008,
> +	       dss_base + DSS_RCH_VG1_SCL_OFFSET + SCF_LB_MEM_CTRL);/*rch_v1 ,scf mem*/
> +	writel(0x00000008,
> +	       dss_base + DSS_RCH_VG1_DMA_OFFSET + DMA_BUF_MEM_CTRL);/*rch_v1 ,dma_buf mem*/
> +	writel(0x00008888, dss_base + DSS_RCH_VG1_DMA_OFFSET + AFBCD_MEM_CTRL);/*rch_v1 ,afbcd mem*/
> +
> +	if (ctx->g_dss_version_tag == FB_ACCEL_KIRIN970) {
> +		writel(0x88888888,
> +		       dss_base + DSS_RCH_VG0_DMA_OFFSET + HFBCD_MEM_CTRL);
> +		writel(0x00000888,
> +		       dss_base + DSS_RCH_VG0_DMA_OFFSET + HFBCD_MEM_CTRL_1);
> +		writel(0x88888888,
> +		       dss_base + DSS_RCH_VG1_DMA_OFFSET + HFBCD_MEM_CTRL);
> +		writel(0x00000888,
> +		       dss_base + DSS_RCH_VG1_DMA_OFFSET + HFBCD_MEM_CTRL_1);
> +	} else {
> +		writel(0x00000088,
> +		       dss_base + DSS_RCH_VG2_SCL_OFFSET + SCF_COEF_MEM_CTRL);/*rch_v2 ,scf mem*/
> +		writel(0x00000008,
> +		       dss_base + DSS_RCH_VG2_SCL_OFFSET + SCF_LB_MEM_CTRL);/*rch_v2 ,scf mem*/
> +	}
> +
> +	writel(0x00000008,
> +	       dss_base + DSS_RCH_VG2_DMA_OFFSET + DMA_BUF_MEM_CTRL);/*rch_v2 ,dma_buf mem*/
> +
> +	writel(0x00000088,
> +	       dss_base + DSS_RCH_G0_SCL_OFFSET + SCF_COEF_MEM_CTRL);/*rch_g0 ,scf mem*/
> +	writel(0x0000008, dss_base + DSS_RCH_G0_SCL_OFFSET + SCF_LB_MEM_CTRL);/*rch_g0 ,scf mem*/
> +	writel(0x00000008,
> +	       dss_base + DSS_RCH_G0_DMA_OFFSET + DMA_BUF_MEM_CTRL);/*rch_g0 ,dma_buf mem*/
> +	writel(0x00008888, dss_base + DSS_RCH_G0_DMA_OFFSET + AFBCD_MEM_CTRL);/*rch_g0 ,afbcd mem*/
> +
> +	writel(0x00000088,
> +	       dss_base + DSS_RCH_G1_SCL_OFFSET + SCF_COEF_MEM_CTRL);/*rch_g1 ,scf mem*/
> +	writel(0x0000008, dss_base + DSS_RCH_G1_SCL_OFFSET + SCF_LB_MEM_CTRL);/*rch_g1 ,scf mem*/
> +	writel(0x00000008,
> +	       dss_base + DSS_RCH_G1_DMA_OFFSET + DMA_BUF_MEM_CTRL);/*rch_g1 ,dma_buf mem*/
> +	writel(0x00008888, dss_base + DSS_RCH_G1_DMA_OFFSET + AFBCD_MEM_CTRL);/*rch_g1 ,afbcd mem*/
> +
> +	writel(0x00000008,
> +	       dss_base + DSS_RCH_D0_DMA_OFFSET + DMA_BUF_MEM_CTRL);/*rch_d0 ,dma_buf mem*/
> +	writel(0x00008888, dss_base + DSS_RCH_D0_DMA_OFFSET + AFBCD_MEM_CTRL);/*rch_d0 ,afbcd mem*/
> +	writel(0x00000008,
> +	       dss_base + DSS_RCH_D1_DMA_OFFSET + DMA_BUF_MEM_CTRL);/*rch_d1 ,dma_buf mem*/
> +	writel(0x00000008,
> +	       dss_base + DSS_RCH_D2_DMA_OFFSET + DMA_BUF_MEM_CTRL);/*rch_d2 ,dma_buf mem*/
> +	writel(0x00000008,
> +	       dss_base + DSS_RCH_D3_DMA_OFFSET + DMA_BUF_MEM_CTRL);/*rch_d3 ,dma_buf mem*/
> +
> +	writel(0x00000008, dss_base + DSS_WCH0_DMA_OFFSET + DMA_BUF_MEM_CTRL);/*wch0 DMA/AFBCE mem*/
> +	writel(0x00000888, dss_base + DSS_WCH0_DMA_OFFSET + AFBCE_MEM_CTRL);/*wch0 DMA/AFBCE mem*/
> +	writel(0x00000008, dss_base + DSS_WCH0_DMA_OFFSET + ctx->rot_mem_ctrl);/*wch0 rot mem*/
> +	writel(0x00000008, dss_base + DSS_WCH1_DMA_OFFSET + DMA_BUF_MEM_CTRL);/*wch1 DMA/AFBCE mem*/
> +	writel(0x00000888, dss_base + DSS_WCH1_DMA_OFFSET + AFBCE_MEM_CTRL);/*wch1 DMA/AFBCE mem*/
> +	writel(0x00000008, dss_base + DSS_WCH1_DMA_OFFSET + ctx->rot_mem_ctrl);/*wch1 rot mem*/
> +	if (ctx->g_dss_version_tag == FB_ACCEL_KIRIN970) {
> +		writel(0x00000088,
> +		       dss_base + DSS_WCH1_DMA_OFFSET + WCH_SCF_COEF_MEM_CTRL);
> +		writel(0x00000008,
> +		       dss_base + DSS_WCH1_DMA_OFFSET + WCH_SCF_LB_MEM_CTRL);
> +		writel(0x02605550, dss_base + GLB_DSS_MEM_CTRL);
> +	} else {
> +		writel(0x00000008,
> +		       dss_base + DSS_WCH2_DMA_OFFSET + DMA_BUF_MEM_CTRL);/*wch2 DMA/AFBCE mem*/
> +		writel(0x00000008,
> +		       dss_base + DSS_WCH2_DMA_OFFSET + ctx->rot_mem_ctrl);/*wch2 rot mem*/
> +		//outp32(dss_base + DSS_WCH2_DMA_OFFSET + DMA_BUF_MEM_CTRL, 0x00000008);
> +		//outp32(dss_base + DSS_WCH2_DMA_OFFSET + DMA_BUF_MEM_CTRL, 0x00000008);
> +	}
> +}
> +
> +int dpe_irq_enable(struct dss_crtc *acrtc)
> +{
> +	struct dss_hw_ctx *ctx;
> +
> +	ctx = acrtc->ctx;
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL!\n");
> +		return -1;
> +	}
> +
> +	if (ctx->irq)
> +		enable_irq(ctx->irq);
> +
> +	return 0;
> +}
> +
> +int dpe_irq_disable(struct dss_crtc *acrtc)
> +{
> +	struct dss_hw_ctx *ctx;
> +
> +	ctx = acrtc->ctx;
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL!\n");
> +		return -1;
> +	}
> +
> +	if (ctx->irq)
> +		disable_irq(ctx->irq);
> +
> +	/*disable_irq_nosync(ctx->irq);*/
> +
> +	return 0;
> +}
> +
> +int dpe_common_clk_enable(struct dss_hw_ctx *ctx)
> +{
> +	int ret = 0;
> +	struct clk *clk_tmp = NULL;
> +
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL point!\n");
> +		return -EINVAL;
> +	}
> +
> +	clk_tmp = ctx->dss_mmbuf_clk;
> +	if (clk_tmp) {
> +		ret = clk_prepare(clk_tmp);
> +		if (ret) {
> +			DRM_ERROR(" dss_mmbuf_clk clk_prepare failed, error=%d!\n", ret);
> +			return -EINVAL;
> +		}
> +
> +		ret = clk_enable(clk_tmp);
> +		if (ret) {
> +			DRM_ERROR(" dss_mmbuf_clk clk_enable failed, error=%d!\n", ret);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	clk_tmp = ctx->dss_axi_clk;
> +	if (clk_tmp) {
> +		ret = clk_prepare(clk_tmp);
> +		if (ret) {
> +			DRM_ERROR(" dss_axi_clk clk_prepare failed, error=%d!\n", ret);
> +			return -EINVAL;
> +		}
> +
> +		ret = clk_enable(clk_tmp);
> +		if (ret) {
> +			DRM_ERROR(" dss_axi_clk clk_enable failed, error=%d!\n", ret);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	clk_tmp = ctx->dss_pclk_dss_clk;
> +	if (clk_tmp) {
> +		ret = clk_prepare(clk_tmp);
> +		if (ret) {
> +			DRM_ERROR(" dss_pclk_dss_clk clk_prepare failed, error=%d!\n", ret);
> +			return -EINVAL;
> +		}
> +
> +		ret = clk_enable(clk_tmp);
> +		if (ret) {
> +			DRM_ERROR(" dss_pclk_dss_clk clk_enable failed, error=%d!\n", ret);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +int dpe_common_clk_disable(struct dss_hw_ctx *ctx)
> +{
> +	struct clk *clk_tmp = NULL;
> +
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL point!\n");
> +		return -EINVAL;
> +	}
> +
> +	clk_tmp = ctx->dss_pclk_dss_clk;
> +	if (clk_tmp) {
> +		clk_disable(clk_tmp);
> +		clk_unprepare(clk_tmp);
> +	}
> +
> +	clk_tmp = ctx->dss_axi_clk;
> +	if (clk_tmp) {
> +		clk_disable(clk_tmp);
> +		clk_unprepare(clk_tmp);
> +	}
> +
> +	clk_tmp = ctx->dss_mmbuf_clk;
> +	if (clk_tmp) {
> +		clk_disable(clk_tmp);
> +		clk_unprepare(clk_tmp);
> +	}
> +
> +	return 0;
> +}
> +
> +int dpe_inner_clk_enable(struct dss_hw_ctx *ctx)
> +{
> +	int ret = 0;
> +	struct clk *clk_tmp = NULL;
> +
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL point!\n");
> +		return -EINVAL;
> +	}
> +
> +	clk_tmp = ctx->dss_pri_clk;
> +	if (clk_tmp) {
> +		ret = clk_prepare(clk_tmp);
> +		if (ret) {
> +			DRM_ERROR(" dss_pri_clk clk_prepare failed, error=%d!\n", ret);
> +			return -EINVAL;
> +		}
> +
> +		ret = clk_enable(clk_tmp);
> +		if (ret) {
> +			DRM_ERROR(" dss_pri_clk clk_enable failed, error=%d!\n", ret);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	clk_tmp = ctx->dss_pxl0_clk;
> +	if (clk_tmp) {
> +		ret = clk_prepare(clk_tmp);
> +		if (ret) {
> +			DRM_ERROR(" dss_pxl0_clk clk_prepare failed, error=%d!\n", ret);
> +			return -EINVAL;
> +		}
> +
> +		ret = clk_enable(clk_tmp);
> +		if (ret) {
> +			DRM_ERROR(" dss_pxl0_clk clk_enable failed, error=%d!\n", ret);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +int dpe_inner_clk_disable(struct dss_hw_ctx *ctx)
> +{
> +	struct clk *clk_tmp = NULL;
> +
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL point!\n");
> +		return -EINVAL;
> +	}
> +
> +	clk_tmp = ctx->dss_pxl0_clk;
> +	if (clk_tmp) {
> +		clk_disable(clk_tmp);
> +		clk_unprepare(clk_tmp);
> +	}
> +
> +	clk_tmp = ctx->dss_pri_clk;
> +	if (clk_tmp) {
> +		clk_disable(clk_tmp);
> +		clk_unprepare(clk_tmp);
> +	}
> +
> +	return 0;
> +}
> +
> +int dpe_regulator_enable(struct dss_hw_ctx *ctx)
> +{
> +	int ret = 0;
> +
> +	DRM_INFO("enabling DPE regulator\n");
> +	if (!ctx) {
> +		DRM_ERROR("NULL ptr.\n");
> +		return -EINVAL;
> +	}
> +
> +	ret = regulator_enable(ctx->dpe_regulator);
> +	if (ret) {
> +		DRM_ERROR(" dpe regulator_enable failed, error=%d!\n", ret);
> +		return -EINVAL;
> +	}
> +
> +	DRM_INFO("-.\n");
> +
> +	return ret;
> +}
> +
> +int dpe_regulator_disable(struct dss_hw_ctx *ctx)
> +{
> +	int ret = 0;
> +
> +	if (!ctx) {
> +		DRM_ERROR("NULL ptr.\n");
> +		return -EINVAL;
> +	}
> +
> +	if (ctx->g_dss_version_tag == FB_ACCEL_KIRIN970) {
> +		dpe_set_pixel_clk_rate_on_pll0(ctx);
> +		dpe_set_common_clk_rate_on_pll0(ctx);
> +	}
> +
> +	ret = regulator_disable(ctx->dpe_regulator);
> +	if (ret != 0) {
> +		DRM_ERROR("dpe regulator_disable failed, error=%d!\n", ret);
> +		return -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
> +int mediacrg_regulator_enable(struct dss_hw_ctx *ctx)
> +{
> +	int ret = 0;
> +
> +	if (!ctx) {
> +		DRM_ERROR("NULL ptr.\n");
> +		return -EINVAL;
> +	}
> +
> +	//ret = regulator_enable(ctx->mediacrg_regulator);
> +	if (ret)
> +		DRM_ERROR("mediacrg regulator_enable failed, error=%d!\n", ret);
> +
> +	return ret;
> +}
> +
> +int mediacrg_regulator_disable(struct dss_hw_ctx *ctx)
> +{
> +	int ret = 0;
> +
> +	if (!ctx) {
> +		DRM_ERROR("NULL ptr.\n");
> +		return -EINVAL;
> +	}
> +
> +	//ret = regulator_disable(ctx->mediacrg_regulator);
> +	if (ret != 0) {
> +		DRM_ERROR("mediacrg regulator_disable failed, error=%d!\n", ret);
> +		return -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
> +int dpe_set_clk_rate(struct dss_hw_ctx *ctx)
> +{
> +	u64 clk_rate;
> +	int ret = 0;
> +
> +	if (!ctx) {
> +		DRM_ERROR("NULL Pointer!\n");
> +		return -EINVAL;
> +	}
> +
> +	clk_rate = DEFAULT_DSS_CORE_CLK_RATE_L1;
> +	ret = clk_set_rate(ctx->dss_pri_clk, DEFAULT_DSS_CORE_CLK_RATE_L1);
> +	if (ret < 0) {
> +		DRM_ERROR("dss_pri_clk clk_set_rate failed, error=%d!\n", ret);
> +		return -EINVAL;
> +	}
> +	DRM_INFO("dss_pri_clk:[%llu]->[%llu].\n",
> +		 clk_rate, (uint64_t)clk_get_rate(ctx->dss_pri_clk));
> +
> +#if 0 /* it will be set on dss_ldi_set_mode func */
> +	ret = clk_set_rate(ctx->dss_pxl0_clk, pinfo->pxl_clk_rate);
> +	if (ret < 0) {
> +		DRM_ERROR("fb%d dss_pxl0_clk clk_set_rate(%llu) failed, error=%d!\n",
> +			  ctx->index, pinfo->pxl_clk_rate, ret);
> +		if (g_fpga_flag == 0)
> +			return -EINVAL;
> +	}
> +
> +	DRM_INFO("dss_pxl0_clk:[%llu]->[%llu].\n",
> +		 pinfo->pxl_clk_rate, (uint64_t)clk_get_rate(ctx->dss_pxl0_clk));
> +#endif
> +
> +	clk_rate = DEFAULT_DSS_MMBUF_CLK_RATE_L1;
> +	ret = clk_set_rate(ctx->dss_mmbuf_clk, DEFAULT_DSS_MMBUF_CLK_RATE_L1);
> +	if (ret < 0) {
> +		DRM_ERROR("dss_mmbuf clk_set_rate failed, error=%d!\n", ret);
> +		return -EINVAL;
> +	}
> +
> +	DRM_INFO("dss_mmbuf_clk:[%llu]->[%llu].\n",
> +		 clk_rate, (uint64_t)clk_get_rate(ctx->dss_mmbuf_clk));
> +
> +	return ret;
> +}
> +
> +int dpe_set_pixel_clk_rate_on_pll0(struct dss_hw_ctx *ctx)
> +{
> +	int ret;
> +	u64 clk_rate;
> +
> +	DRM_INFO("+.\n");
> +	if (!ctx) {
> +		DRM_ERROR("NULL Pointer!\n");
> +		return -EINVAL;
> +	}
> +
> +	clk_rate = ctx->pxl0_clk_rate_power_off;
> +	ret = clk_set_rate(ctx->dss_pxl0_clk, clk_rate);
> +	if (ret < 0) {
> +		DRM_ERROR("dss_pxl0_clk clk_set_rate(%llu) failed, error=%d!\n",
> +			  clk_rate, ret);
> +		return -EINVAL;
> +	}
> +	DRM_INFO("dss_pxl0_clk:[%llu]->[%llu].\n",
> +		 clk_rate, (uint64_t)clk_get_rate(ctx->dss_pxl0_clk));
> +
> +	return ret;
> +}
> +
> +int dpe_set_common_clk_rate_on_pll0(struct dss_hw_ctx *ctx)
> +{
> +	int ret;
> +	u64 clk_rate;
> +
> +	DRM_INFO("+.\n");
> +	if (!ctx) {
> +		DRM_ERROR("NULL Pointer!\n");
> +		return -EINVAL;
> +	}
> +
> +	clk_rate = ctx->dss_mmbuf_clk_rate_power_off;
> +	ret = clk_set_rate(ctx->dss_mmbuf_clk, clk_rate);
> +	if (ret < 0) {
> +		DRM_ERROR("dss_mmbuf clk_set_rate(%llu) failed, error=%d!\n",
> +			  clk_rate, ret);
> +		return -EINVAL;
> +	}
> +	DRM_INFO("dss_mmbuf_clk:[%llu]->[%llu].\n",
> +		 clk_rate, (uint64_t)clk_get_rate(ctx->dss_mmbuf_clk));
> +
> +	clk_rate = DEFAULT_DSS_CORE_CLK_RATE_POWER_OFF;
> +	ret = clk_set_rate(ctx->dss_pri_clk, clk_rate);
> +	if (ret < 0) {
> +		DRM_ERROR("dss_pri_clk clk_set_rate(%llu) failed, error=%d!\n",
> +			  clk_rate, ret);
> +		return -EINVAL;
> +	}
> +	DRM_INFO("dss_pri_clk:[%llu]->[%llu].\n",
> +		 clk_rate, (uint64_t)clk_get_rate(ctx->dss_pri_clk));
> +
> +	return ret;
> +}
> diff --git a/drivers/staging/hikey9xx/gpu/kirin9xx_drm_dpe_utils.h b/drivers/staging/hikey9xx/gpu/kirin9xx_drm_dpe_utils.h
> new file mode 100644
> index 000000000000..444ddc148416
> --- /dev/null
> +++ b/drivers/staging/hikey9xx/gpu/kirin9xx_drm_dpe_utils.h
> @@ -0,0 +1,286 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (c) 2013-2014, Hisilicon Tech. Co., Ltd. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#ifndef KIRIN_DRM_DPE_UTILS_H
> +#define KIRIN_DRM_DPE_UTILS_H
> +
> +#include <linux/kernel.h>
> +
> +#include <drm/drm_plane.h>
> +#include <drm/drm_crtc.h>
> +
> +#include "kirin9xx_drm_drv.h"
> +#include "kirin9xx_dpe.h"
> +
> +enum dss_channel {
> +	DSS_CH1 = 0,	/* channel 1 for primary plane */
> +	DSS_CH_NUM
> +};
> +
> +#define PRIMARY_CH	DSS_CH1 /* primary plane */
> +
> +enum hisi_fb_pixel_format {
> +	HISI_FB_PIXEL_FORMAT_RGB_565 = 0,
> +	HISI_FB_PIXEL_FORMAT_RGBX_4444,
> +	HISI_FB_PIXEL_FORMAT_RGBA_4444,
> +	HISI_FB_PIXEL_FORMAT_RGBX_5551,
> +	HISI_FB_PIXEL_FORMAT_RGBA_5551,
> +	HISI_FB_PIXEL_FORMAT_RGBX_8888,
> +	HISI_FB_PIXEL_FORMAT_RGBA_8888,
> +
> +	HISI_FB_PIXEL_FORMAT_BGR_565,
> +	HISI_FB_PIXEL_FORMAT_BGRX_4444,
> +	HISI_FB_PIXEL_FORMAT_BGRA_4444,
> +	HISI_FB_PIXEL_FORMAT_BGRX_5551,
> +	HISI_FB_PIXEL_FORMAT_BGRA_5551,
> +	HISI_FB_PIXEL_FORMAT_BGRX_8888,
> +	HISI_FB_PIXEL_FORMAT_BGRA_8888,
> +
> +	HISI_FB_PIXEL_FORMAT_YUV_422_I,
> +
> +	/* YUV Semi-planar */
> +	HISI_FB_PIXEL_FORMAT_YCbCr_422_SP,	/* NV16 */
> +	HISI_FB_PIXEL_FORMAT_YCrCb_422_SP,
> +	HISI_FB_PIXEL_FORMAT_YCbCr_420_SP,
> +	HISI_FB_PIXEL_FORMAT_YCrCb_420_SP,	/* NV21 */
> +
> +	/* YUV Planar */
> +	HISI_FB_PIXEL_FORMAT_YCbCr_422_P,
> +	HISI_FB_PIXEL_FORMAT_YCrCb_422_P,
> +	HISI_FB_PIXEL_FORMAT_YCbCr_420_P,
> +	HISI_FB_PIXEL_FORMAT_YCrCb_420_P,	/* HISI_FB_PIXEL_FORMAT_YV12 */
> +
> +	/* YUV Package */
> +	HISI_FB_PIXEL_FORMAT_YUYV_422_Pkg,
> +	HISI_FB_PIXEL_FORMAT_UYVY_422_Pkg,
> +	HISI_FB_PIXEL_FORMAT_YVYU_422_Pkg,
> +	HISI_FB_PIXEL_FORMAT_VYUY_422_Pkg,
> +	HISI_FB_PIXEL_FORMAT_MAX,
> +
> +	HISI_FB_PIXEL_FORMAT_UNSUPPORT = 800
> +};
> +
> +struct dss_hw_ctx {
> +	void __iomem *base;
> +	struct regmap *noc_regmap;
> +	struct reset_control *reset;
> +	u32 g_dss_version_tag;
> +
> +	void __iomem *noc_dss_base;
> +	void __iomem *peri_crg_base;
> +	void __iomem *pmc_base;
> +	void __iomem *sctrl_base;
> +	void __iomem *media_crg_base;
> +	void __iomem *pctrl_base;
> +	void __iomem *mmbuf_crg_base;
> +	void __iomem *pmctrl_base;
> +
> +	struct clk *dss_axi_clk;
> +	struct clk *dss_pclk_dss_clk;
> +	struct clk *dss_pri_clk;
> +	struct clk *dss_pxl0_clk;
> +	struct clk *dss_pxl1_clk;
> +	struct clk *dss_mmbuf_clk;
> +	struct clk *dss_pclk_mmbuf_clk;
> +
> +	struct dss_clk_rate *dss_clk;
> +
> +	struct regulator *dpe_regulator;
> +	struct regulator *mmbuf_regulator;
> +	struct regulator *mediacrg_regulator;
> +
> +	bool power_on;
> +	int irq;
> +
> +	wait_queue_head_t vactive0_end_wq;
> +	u32 vactive0_end_flag;
> +	ktime_t vsync_timestamp;
> +	ktime_t vsync_timestamp_prev;
> +
> +	struct iommu_domain *mmu_domain;
> +	char __iomem *screen_base;
> +	unsigned long smem_start;
> +	unsigned long screen_size;
> +
> +	/* Version-specific data */
> +	u32 g_dss_module_base[DSS_CHN_MAX_DEFINE][MODULE_CHN_MAX];
> +	u32 g_dss_module_ovl_base[DSS_MCTL_IDX_MAX][MODULE_OVL_MAX];
> +	int g_scf_lut_chn_coef_idx[DSS_CHN_MAX_DEFINE];
> +	u32 g_dss_module_cap[DSS_CHN_MAX_DEFINE][MODULE_CAP_MAX];
> +	u32 g_dss_chn_sid_num[DSS_CHN_MAX_DEFINE];
> +	u32 g_dss_smmu_smrx_idx[DSS_CHN_MAX_DEFINE];
> +	u32 smmu_offset;
> +	u32 afbc_header_addr_align;
> +	u32 dss_mmbuf_clk_rate_power_off;
> +	u32 rot_mem_ctrl;
> +	u32 dither_mem_ctrl;
> +	u32 arsr2p_lb_mem_ctrl;
> +	u32 pxl0_clk_rate_power_off;
> +};
> +
> +void kirin960_dpe_defs(struct dss_hw_ctx *ctx);
> +void kirin970_dpe_defs(struct dss_hw_ctx *ctx);
> +
> +struct dss_clk_rate {
> +	u64 dss_pri_clk_rate;
> +	u64 dss_pclk_dss_rate;
> +	u64 dss_pclk_pctrl_rate;
> +	u64 dss_mmbuf_rate;
> +	u32 dss_voltage_value; //0:0.7v, 2:0.8v
> +	u32 reserved;
> +};
> +
> +struct dss_crtc {
> +	struct drm_crtc base;
> +	struct dss_hw_ctx *ctx;
> +	bool enable;
> +	u32 out_format;
> +	u32 bgr_fmt;
> +};
> +
> +struct dss_plane {
> +	struct drm_plane base;
> +	/*void *ctx;*/
Delete as it is not used.

> +	void *acrtc;
> +	u8 ch; /* channel */
> +};
> +
> +struct dss_data {
> +	struct dss_crtc acrtc;
> +	struct dss_plane aplane[DSS_CH_NUM];
> +	struct dss_hw_ctx ctx;
> +};
> +
> +/* ade-format info: */
> +struct dss_format {
> +	u32 pixel_format;
> +	enum hisi_fb_pixel_format dss_format;
> +};
> +
> +struct dss_img {
> +	u32 format;
> +	u32 width;
> +	u32 height;
> +	u32 bpp;		/* bytes per pixel */
> +	u32 buf_size;
> +	u32 stride;
> +	u32 stride_plane1;
> +	u32 stride_plane2;
> +	u64 phy_addr;
> +	u64 vir_addr;
> +	u32 offset_plane1;
> +	u32 offset_plane2;
> +
> +	u64 afbc_header_addr;
> +	u64 afbc_payload_addr;
> +	u32 afbc_header_stride;
> +	u32 afbc_payload_stride;
> +	u32 afbc_scramble_mode;
> +	u32 mmbuf_base;
> +	u32 mmbuf_size;
> +
> +	u32 mmu_enable;
> +	u32 csc_mode;
> +	u32 secure_mode;
> +	s32 shared_fd;
> +	u32 reserved0;
> +};
> +
> +struct dss_rect {
> +	s32 x;
> +	s32 y;
> +	s32 w;
> +	s32 h;
> +};
> +
> +struct drm_dss_layer {
> +	struct dss_img img;
> +	struct dss_rect src_rect;
> +	struct dss_rect src_rect_mask;
> +	struct dss_rect dst_rect;
> +	u32 transform;
> +	s32 blending;
> +	u32 glb_alpha;
> +	u32 color;		/* background color or dim color */
> +	s32 layer_idx;
> +	s32 chn_idx;
> +	u32 need_cap;
> +	s32 acquire_fence;
> +};
> +
> +static inline void set_reg(char __iomem *addr, uint32_t val, uint8_t bw,
> +			   uint8_t bs)
> +{
> +	u32 mask = (1UL << bw) - 1UL;
> +	u32 tmp = 0;
> +
> +	tmp = readl(addr);
> +	tmp &= ~(mask << bs);
> +
> +	writel(tmp | ((val & mask) << bs), addr);
> +}
> +
> +u32 set_bits32(u32 old_val, uint32_t val, uint8_t bw, uint8_t bs);
> +
> +void init_dbuf(struct dss_crtc *acrtc);
> +void init_dpp(struct dss_crtc *acrtc);
> +void init_other(struct dss_crtc *acrtc);
> +void init_ldi(struct dss_crtc *acrtc);
> +
> +void deinit_ldi(struct dss_crtc *acrtc);
> +void enable_ldi(struct dss_crtc *acrtc);
> +void disable_ldi(struct dss_crtc *acrtc);
> +
> +void dss_inner_clk_pdp_enable(struct dss_hw_ctx *ctx);
> +void dss_inner_clk_pdp_disable(struct dss_hw_ctx *ctx);
> +void dss_inner_clk_common_enable(struct dss_hw_ctx *ctx);
> +void dss_inner_clk_common_disable(struct dss_hw_ctx *ctx);
> +void dpe_interrupt_clear(struct dss_crtc *acrtc);
> +void dpe_interrupt_unmask(struct dss_crtc *acrtc);
> +void dpe_interrupt_mask(struct dss_crtc *acrtc);
> +int dpe_common_clk_enable(struct dss_hw_ctx *ctx);
> +int dpe_common_clk_disable(struct dss_hw_ctx *ctx);
> +int dpe_inner_clk_enable(struct dss_hw_ctx *ctx);
> +int dpe_inner_clk_disable(struct dss_hw_ctx *ctx);
> +int dpe_regulator_enable(struct dss_hw_ctx *ctx);
> +int dpe_regulator_disable(struct dss_hw_ctx *ctx);
> +int mediacrg_regulator_enable(struct dss_hw_ctx *ctx);
> +int mediacrg_regulator_disable(struct dss_hw_ctx *ctx);
> +int dpe_set_clk_rate(struct dss_hw_ctx *ctx);
> +
> +int dpe_irq_enable(struct dss_crtc *acrtc);
> +int dpe_irq_disable(struct dss_crtc *acrtc);
> +
> +int dpe_init(struct dss_crtc *acrtc);
> +int dpe_deinit(struct dss_crtc *acrtc);
> +void dpe_check_itf_status(struct dss_crtc *acrtc);
> +int dpe_set_clk_rate_on_pll0(struct dss_hw_ctx *ctx);
> +int dpe_set_common_clk_rate_on_pll0(struct dss_hw_ctx *ctx);
> +int dpe_set_pixel_clk_rate_on_pll0(struct dss_hw_ctx *ctx);
> +
> +void hisifb_dss_on(struct dss_hw_ctx *ctx);
> +void hisi_dss_mctl_on(struct dss_hw_ctx *ctx);
> +
> +void hisi_dss_unflow_handler(struct dss_hw_ctx *ctx, bool unmask);
> +int hisi_dss_mctl_mutex_lock(struct dss_hw_ctx *ctx);
> +int hisi_dss_mctl_mutex_unlock(struct dss_hw_ctx *ctx);
> +int hisi_dss_ovl_base_config(struct dss_hw_ctx *ctx, u32 xres, u32 yres);
> +
> +void hisi_fb_pan_display(struct drm_plane *plane);
> +void hisi_dss_online_play(struct kirin_fbdev *fbdev, struct drm_plane *plane, struct drm_dss_layer *layer);
> +
> +u32 dss_get_format(u32 pixel_format);
> +
> +#endif
> diff --git a/drivers/staging/hikey9xx/gpu/kirin9xx_drm_drv.c b/drivers/staging/hikey9xx/gpu/kirin9xx_drm_drv.c
> new file mode 100644
> index 000000000000..18fec5a1b59d
> --- /dev/null
> +++ b/drivers/staging/hikey9xx/gpu/kirin9xx_drm_drv.c
> @@ -0,0 +1,368 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Hisilicon Kirin SoCs drm master driver
> + *
> + * Copyright (c) 2016 Linaro Limited.
> + * Copyright (c) 2014-2016 Hisilicon Limited.
> + *
> + * Author:
> + *	<cailiwei@hisilicon.com>
> + *	<zhengwanchun@hisilicon.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/of_platform.h>
> +#include <linux/component.h>
> +#include <linux/of_graph.h>
> +
> +#include <drm/drm_atomic_helper.h>
> +#include <drm/drm_crtc_helper.h>
> +#include <drm/drm_drv.h>
> +#include <drm/drm_fb_helper.h>
> +#include <drm/drm_fb_cma_helper.h>
> +#include <drm/drm_gem_cma_helper.h>
> +#include <drm/drm_gem_framebuffer_helper.h>
> +#include <drm/drm_of.h>
> +#include <drm/drm_probe_helper.h>
> +#include <drm/drm_vblank.h>
> +
> +#include "kirin9xx_drm_drv.h"
> +
> +static int kirin_drm_kms_cleanup(struct drm_device *dev)
> +{
> +	struct kirin_drm_private *priv = dev->dev_private;
Use of drm_device.dev_private is deprecated.
Use subclassing and upcasting.

See gpu/drm/drm_drv.c for a small example how to do it
(look for a big comment with code).

> +	static struct kirin_dc_ops const *dc_ops;
> +
> +	if (priv->fbdev)
> +		priv->fbdev = NULL;
> +
> +	dc_ops = of_device_get_match_data(dev->dev);
> +
> +	drm_kms_helper_poll_fini(dev);
> +	dc_ops->cleanup(dev);
> +	drm_mode_config_cleanup(dev);
> +	devm_kfree(dev->dev, priv);
> +	dev->dev_private = NULL;
> +
> +	return 0;
> +}
> +
> +static void kirin_fbdev_output_poll_changed(struct drm_device *dev)
> +{
> +	struct kirin_drm_private *priv = dev->dev_private;
> +
> +	dsi_set_output_client(dev);
> +
> +	drm_fb_helper_hotplug_event(priv->fbdev);
> +}
> +
> +static const struct drm_mode_config_funcs kirin_drm_mode_config_funcs = {
> +	.fb_create = drm_gem_fb_create,
> +	.output_poll_changed = kirin_fbdev_output_poll_changed,
> +	.atomic_check = drm_atomic_helper_check,
> +	.atomic_commit = drm_atomic_helper_commit,
> +};
> +
> +static void kirin_drm_mode_config_init(struct drm_device *dev)
> +{
> +	dev->mode_config.min_width = 0;
> +	dev->mode_config.min_height = 0;
> +
> +	dev->mode_config.max_width = 2048;
> +	dev->mode_config.max_height = 2048;
preferred_depth?
If specified it will be used by fbdev emulation

> +	dev->mode_config.funcs = &kirin_drm_mode_config_funcs;
> +}
> +
> +static int kirin_drm_kms_init(struct drm_device *dev)
> +{
> +	struct kirin_drm_private *priv = dev->dev_private;
> +	static struct kirin_dc_ops const *dc_ops;
> +	int ret;
> +
> +	priv = devm_kzalloc(dev->dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	dev->dev_private = priv;
> +	dev_set_drvdata(dev->dev, dev);
> +
> +	/* dev->mode_config initialization */
> +	drm_mode_config_init(dev);
drmm_mode_config_init() or something like that.
There is a device managed variant that should be used.

> +	kirin_drm_mode_config_init(dev);
> +
> +	/* display controller init */
> +	dc_ops = of_device_get_match_data(dev->dev);
> +	ret = dc_ops->init(dev);
> +	if (ret)
> +		goto err_mode_config_cleanup;
> +
> +	/* bind and init sub drivers */
> +	ret = component_bind_all(dev->dev, dev);
> +	if (ret) {
> +		DRM_ERROR("failed to bind all component.\n");
> +		goto err_dc_cleanup;
> +	}
> +
> +	/* vblank init */
> +	ret = drm_vblank_init(dev, dev->mode_config.num_crtc);
> +	if (ret) {
> +		DRM_ERROR("failed to initialize vblank.\n");
> +		goto err_unbind_all;
> +	}
> +	/* with irq_enabled = true, we can use the vblank feature. */
> +	dev->irq_enabled = true;
> +
> +	/* reset all the states of crtc/plane/encoder/connector */
> +	drm_mode_config_reset(dev);
> +
> +	/* init kms poll for handling hpd */
> +	drm_kms_helper_poll_init(dev);
> +
> +	return 0;
> +
> +err_unbind_all:
> +	component_unbind_all(dev->dev, dev);
> +err_dc_cleanup:
> +	dc_ops->cleanup(dev);
> +err_mode_config_cleanup:
> +	drm_mode_config_cleanup(dev);
> +	devm_kfree(dev->dev, priv);
> +	dev->dev_private = NULL;

In general look for the drmm_* variants to use in the init functions.
There should be no need to deallocate in errro cases.

> +
> +	return ret;
> +}
> +
> +DEFINE_DRM_GEM_CMA_FOPS(kirin_drm_fops);
> +
> +static int kirin_gem_cma_dumb_create(struct drm_file *file,
> +				     struct drm_device *dev,
> +				     struct drm_mode_create_dumb *args)
> +{
> +	return drm_gem_cma_dumb_create_internal(file, dev, args);
> +}
> +
> +static int kirin_drm_connectors_register(struct drm_device *dev)
> +{
> +	struct drm_connector_list_iter conn_iter;
> +	struct drm_connector *failed_connector;
> +	struct drm_connector *connector;
> +	int ret;
> +
> +	mutex_lock(&dev->mode_config.mutex);
> +	drm_connector_list_iter_begin(dev, &conn_iter);
> +	drm_for_each_connector_iter(connector, &conn_iter) {
> +		ret = drm_connector_register(connector);
> +		if (ret) {
> +			failed_connector = connector;
> +			goto err;
> +		}
> +	}
> +	mutex_unlock(&dev->mode_config.mutex);
> +
> +	return 0;
> +
> +err:
> +	drm_connector_list_iter_begin(dev, &conn_iter);
> +	drm_for_each_connector_iter(connector, &conn_iter) {
> +		if (failed_connector == connector)
> +			break;
> +		drm_connector_unregister(connector);
> +	}
> +	mutex_unlock(&dev->mode_config.mutex);
> +
> +	return ret;
> +}
> +
> +static struct drm_driver kirin_drm_driver = {
> +	.driver_features	= DRIVER_GEM | DRIVER_MODESET |
> +				  DRIVER_ATOMIC | DRIVER_RENDER,
> +	.fops				= &kirin_drm_fops,
> +
> +	.gem_free_object	= drm_gem_cma_free_object,
> +	.gem_vm_ops		= &drm_gem_cma_vm_ops,
> +	.dumb_create		= kirin_gem_cma_dumb_create,
> +
> +	.prime_handle_to_fd	= drm_gem_prime_handle_to_fd,
> +	.prime_fd_to_handle	= drm_gem_prime_fd_to_handle,
> +	.gem_prime_export	= drm_gem_prime_export,
> +	.gem_prime_import	= drm_gem_prime_import,
> +	.gem_prime_get_sg_table = drm_gem_cma_prime_get_sg_table,
> +	.gem_prime_import_sg_table = drm_gem_cma_prime_import_sg_table,
> +	.gem_prime_vmap		= drm_gem_cma_prime_vmap,
> +	.gem_prime_vunmap	= drm_gem_cma_prime_vunmap,
> +	.gem_prime_mmap		= drm_gem_cma_prime_mmap,
> +
> +	.name			= "kirin9xx",
> +	.desc			= "Hisilicon Kirin9xx SoCs' DRM Driver",
> +	.date			= "20170309",
> +	.major			= 1,
> +	.minor			= 0,
> +};
This can use one of the helpers - see how other drivers
uses a macro that define all the common helper functions,
so they end up with a very slimm definition here.

Note - could be much worse, you just need to catch up on recent
improvements.

> +
> +static int compare_of(struct device *dev, void *data)
> +{
> +	return dev->of_node == data;
> +}
> +
> +static int kirin_drm_bind(struct device *dev)
> +{
> +	struct drm_driver *driver = &kirin_drm_driver;
> +	struct drm_device *drm_dev;
> +	struct kirin_drm_private *priv;
> +	int ret;
> +
> +	drm_dev = drm_dev_alloc(driver, dev);
> +	if (!drm_dev)
> +		return -ENOMEM;
> +
> +	ret = kirin_drm_kms_init(drm_dev);
> +	if (ret)
> +		goto err_drm_dev_unref;
> +
> +	ret = drm_dev_register(drm_dev, 0);
There is better ways to do this. See drm_drv.c for the code example.

> +	if (ret)
> +		goto err_kms_cleanup;
> +
> +	drm_fbdev_generic_setup(drm_dev, 32);
Pass 0 and use mode_config.preferred_depth.

> +	priv = drm_dev->dev_private;
Drop this as dev_private should not be referenced anywhere.

> +
> +	/* connectors should be registered after drm device register */
> +	ret = kirin_drm_connectors_register(drm_dev);
> +	if (ret)
> +		goto err_drm_dev_unregister;
> +
> +	DRM_INFO("Initialized %s %d.%d.%d %s on minor %d\n",
> +		 driver->name, driver->major, driver->minor, driver->patchlevel,
> +		 driver->date, drm_dev->primary->index);
Already printed by the core - drop.

> +
> +	return 0;
> +
> +err_drm_dev_unregister:
> +	drm_dev_unregister(drm_dev);
> +err_kms_cleanup:
> +	kirin_drm_kms_cleanup(drm_dev);
> +err_drm_dev_unref:
> +	drm_dev_put(drm_dev);
> +
> +	return ret;
> +}
> +
> +static void kirin_drm_unbind(struct device *dev)
> +{
> +	struct drm_device *drm_dev = dev_get_drvdata(dev);
> +
> +	drm_dev_unregister(drm_dev);
> +	kirin_drm_kms_cleanup(drm_dev);
> +	drm_dev_put(drm_dev);
> +}
> +
> +static const struct component_master_ops kirin_drm_ops = {
> +	.bind = kirin_drm_bind,
> +	.unbind = kirin_drm_unbind,
> +};
> +
> +static int kirin_drm_platform_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct device_node *np = dev->of_node;
> +	struct component_match *match = NULL;
> +	struct device_node *remote;
> +	static struct kirin_dc_ops const *dc_ops;
> +	int ret;
> +
> +	dc_ops = of_device_get_match_data(dev);
> +	if (!dc_ops) {
> +		DRM_ERROR("failed to get dt id data\n");
> +		return -EINVAL;
> +	}
> +
> +	DRM_INFO("the device node is %s\n", np->name);
> +	remote = of_graph_get_remote_node(np, 0, 0);
> +	if (!remote)
> +		return -ENODEV;
> +
> +	DRM_INFO("the device remote node is %s\n", remote->name);
> +
> +	drm_of_component_match_add(dev, &match, compare_of, remote);
> +	of_node_put(remote);
> +
> +	if (ret)
> +		DRM_ERROR("cma device init failed!");
> +	return component_master_add_with_match(dev, &kirin_drm_ops, match);
> +}
> +
> +static int kirin_drm_platform_remove(struct platform_device *pdev)
> +{
> +	static struct kirin_dc_ops const *dc_ops;
> +
> +	dc_ops = of_device_get_match_data(&pdev->dev);
> +	component_master_del(&pdev->dev, &kirin_drm_ops);
> +	return 0;
> +}
> +
> +static int kirin_drm_platform_suspend(struct platform_device *pdev, pm_message_t state)
> +{
> +	static struct kirin_dc_ops const *dc_ops;
> +	struct device *dev = &pdev->dev;
> +
> +	dc_ops = of_device_get_match_data(dev);
> +
> +	DRM_INFO("+. pdev->name is %s, m_message is %d\n", pdev->name, state.event);
> +	if (!dc_ops) {
> +		DRM_ERROR("dc_ops is NULL\n");
> +		return -EINVAL;
> +	}
> +	dc_ops->suspend(pdev, state);
> +
> +	return 0;
> +}
> +
> +static int kirin_drm_platform_resume(struct platform_device *pdev)
> +{
> +	static struct kirin_dc_ops const *dc_ops;
> +	struct device *dev = &pdev->dev;
> +
> +	dc_ops = of_device_get_match_data(dev);
> +
> +	if (!dc_ops) {
> +		DRM_ERROR("dc_ops is NULL\n");
> +		return -EINVAL;
> +	}
> +	dc_ops->resume(pdev);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id kirin_drm_dt_ids[] = {
> +	{ .compatible = "hisilicon,kirin960-dpe",
> +	  .data = &kirin960_dss_dc_ops,
> +	},
> +	{ .compatible = "hisilicon,kirin970-dpe",
> +	  .data = &kirin970_dss_dc_ops,
> +	},
> +	{ /* end node */ },
> +};
> +MODULE_DEVICE_TABLE(of, kirin_drm_dt_ids);
> +
> +static struct platform_driver kirin_drm_platform_driver = {
> +	.probe = kirin_drm_platform_probe,
> +	.remove = kirin_drm_platform_remove,
> +	.suspend = kirin_drm_platform_suspend,
> +	.resume = kirin_drm_platform_resume,
> +	.driver = {
> +		.name = "kirin9xx-drm",
> +		.of_match_table = kirin_drm_dt_ids,
> +	},
> +};
> +
> +module_platform_driver(kirin_drm_platform_driver);
> +
> +MODULE_AUTHOR("cailiwei <cailiwei@hisilicon.com>");
> +MODULE_AUTHOR("zhengwanchun <zhengwanchun@hisilicon.com>");
> +MODULE_DESCRIPTION("hisilicon Kirin SoCs' DRM master driver");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/staging/hikey9xx/gpu/kirin9xx_drm_drv.h b/drivers/staging/hikey9xx/gpu/kirin9xx_drm_drv.h
> new file mode 100644
> index 000000000000..fb33d5826ef8
> --- /dev/null
> +++ b/drivers/staging/hikey9xx/gpu/kirin9xx_drm_drv.h
> @@ -0,0 +1,57 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (c) 2016 Linaro Limited.
> + * Copyright (c) 2014-2016 Hisilicon Limited.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#ifndef __KIRIN_DRM_DRV_H__
> +#define __KIRIN_DRM_DRV_H__
> +
> +#include <drm/drm_crtc.h>
> +#include <drm/drm_drv.h>
> +#include <drm/drm_fb_cma_helper.h>
> +#include <drm/drm_fb_helper.h>
> +#include <drm/drm_print.h>
> +
> +#include <linux/iommu.h>
> +
> +#define MAX_CRTC	2
> +
> +/* display controller init/cleanup ops */
> +struct kirin_dc_ops {
> +	int (*init)(struct drm_device *dev);
> +	void (*cleanup)(struct drm_device *dev);
> +	int (*suspend)(struct platform_device *pdev, pm_message_t state);
> +	int (*resume)(struct platform_device *pdev);
> +};
This indirections is not needed - or at least almost not needed.
cleanup, suspend, resume are always the same - so call them direct.
Consider a better way to hande the init function the only difference is
the FB_ACCEL_KIRIN970 value.


> +
> +struct kirin_drm_private {
> +	struct drm_fb_helper *fbdev;
> +	struct drm_crtc *crtc[MAX_CRTC];
> +};
> +
> +struct kirin_fbdev {
> +	struct drm_fb_helper fb_helper;
> +	struct drm_framebuffer *fb;

> +
> +	struct ion_client *ion_client;
> +	struct ion_handle *ion_handle;
> +	void *screen_base;
> +	unsigned long smem_start;
> +	unsigned long screen_size;
> +	int shared_fd;
This are all no longer used and can all be dropped.
See what other drivers do - so things can be simplified.

> +};

> +
> +extern const struct kirin_dc_ops kirin960_dss_dc_ops;
> +extern const struct kirin_dc_ops kirin970_dss_dc_ops;
> +void dsi_set_output_client(struct drm_device *dev);
> +
> +struct drm_framebuffer *kirin_framebuffer_init(struct drm_device *dev,
> +					       struct drm_mode_fb_cmd2 *mode_cmd);
Not used.

> +
> +#endif /* __KIRIN_DRM_DRV_H__ */
> diff --git a/drivers/staging/hikey9xx/gpu/kirin9xx_drm_dss.c b/drivers/staging/hikey9xx/gpu/kirin9xx_drm_dss.c
> new file mode 100644
> index 000000000000..e3a1f85bdbd2
> --- /dev/null
> +++ b/drivers/staging/hikey9xx/gpu/kirin9xx_drm_dss.c
> @@ -0,0 +1,1063 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Hisilicon Hi6220 SoC ADE(Advanced Display Engine)'s crtc&plane driver
> + *
> + * Copyright (c) 2016 Linaro Limited.
> + * Copyright (c) 2014-2016 Hisilicon Limited.
> + *
> + * Author:
> + *	Xinliang Liu <z.liuxinliang@hisilicon.com>
> + *	Xinliang Liu <xinliang.liu@linaro.org>
> + *	Xinwei Kong <kong.kongxinwei@hisilicon.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/bitops.h>
> +#include <linux/clk.h>
> +#include <video/display_timing.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/regmap.h>
> +#include <linux/reset.h>
> +#include <linux/of_address.h>
> +#include <linux/of.h>
> +#include <linux/of_irq.h>
> +
> +#include <drm/drm_atomic.h>
> +#include <drm/drm_atomic_helper.h>
> +#include <drm/drm_crtc.h>
> +#include <drm/drm_crtc_helper.h>
> +#include <drm/drm_drv.h>
> +#include <drm/drm_fb_cma_helper.h>
> +#include <drm/drm_fourcc.h>
> +#include <drm/drm_gem_cma_helper.h>
> +#include <drm/drm_plane_helper.h>
> +#include <drm/drm_vblank.h>
> +#include <drm/drm_modeset_helper_vtables.h>
> +
> +#include "kirin9xx_drm_drv.h"
> +#include "kirin9xx_drm_dpe_utils.h"
> +#include "kirin9xx_dpe.h"
> +
> +//#define DSS_POWER_UP_ON_UEFI
> +
> +#define DSS_DEBUG	0
> +
> +static const struct dss_format dss_formats[] = {
> +	/* 16bpp RGB: */
> +	{ DRM_FORMAT_RGB565, HISI_FB_PIXEL_FORMAT_RGB_565 },
> +	{ DRM_FORMAT_BGR565, HISI_FB_PIXEL_FORMAT_BGR_565 },
> +	/* 32bpp [A]RGB: */
> +	{ DRM_FORMAT_XRGB8888, HISI_FB_PIXEL_FORMAT_RGBX_8888 },
> +	{ DRM_FORMAT_XBGR8888, HISI_FB_PIXEL_FORMAT_BGRX_8888 },
> +	{ DRM_FORMAT_RGBA8888, HISI_FB_PIXEL_FORMAT_RGBA_8888 },
> +	{ DRM_FORMAT_BGRA8888, HISI_FB_PIXEL_FORMAT_BGRA_8888 },
> +	/*{ DRM_FORMAT_ARGB8888,  },*/
> +	/*{ DRM_FORMAT_ABGR8888,  },*/
> +};
> +
> +static const u32 channel_formats1[] = {
> +	DRM_FORMAT_RGB565, DRM_FORMAT_BGR565,
> +	DRM_FORMAT_XRGB8888, DRM_FORMAT_XBGR8888,
> +	DRM_FORMAT_RGBA8888, DRM_FORMAT_BGRA8888
> +};
Add newlines.

> +
> +u32 dss_get_channel_formats(u8 ch, const u32 **formats)
> +{
> +	switch (ch) {
> +	case DSS_CH1:
> +		*formats = channel_formats1;
> +		return ARRAY_SIZE(channel_formats1);
> +	default:
> +		DRM_ERROR("no this channel %d\n", ch);
> +		*formats = NULL;
> +		return 0;
> +	}
> +}
> +
> +/* convert from fourcc format to dss format */
> +u32 dss_get_format(u32 pixel_format)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(dss_formats); i++)
> +		if (dss_formats[i].pixel_format == pixel_format)
> +			return dss_formats[i].dss_format;
> +
> +	/* not found */
> +	DRM_ERROR("Not found pixel format!!fourcc_format= %d\n",
> +		  pixel_format);
> +	return HISI_FB_PIXEL_FORMAT_UNSUPPORT;
> +}
> +
> +/*******************************************************************************
> + **
> + */
> +
> +int hdmi_ceil(u64 a, uint64_t b)
> +{
> +	if (b == 0)
> +		return -1;
> +
> +	if (a % b != 0)
> +		return a / b + 1;
> +	else
> +		return a / b;
> +}
Looks like a generic function. Can a generic function be used here?

> +
> +int hdmi_pxl_ppll7_init(struct dss_hw_ctx *ctx, u64 pixel_clock)
> +{
> +	u64 vco_min_freq_output = KIRIN970_VCO_MIN_FREQ_OUTPUT;
> +	u64 refdiv, fbdiv, frac, postdiv1 = 0, postdiv2 = 0;
> +	u64 dss_pxl0_clk = 7 * 144000000UL;
> +	u64 sys_clock_fref = KIRIN970_SYS_19M2;
> +	u64 ppll7_freq_divider;
> +	u64 vco_freq_output;
> +	u64 frac_range = 0x1000000;/*2^24*/
> +	u64 pixel_clock_ori;
> +	u64 pixel_clock_cur;
> +	u32 ppll7ctrl0;
> +	u32 ppll7ctrl1;
> +	u32 ppll7ctrl0_val;
> +	u32 ppll7ctrl1_val;
> +	int ceil_temp;
> +	int i, ret;
> +	const int freq_divider_list[22] = {
> +		1,  2,  3,  4,  5,  6,  7,  8,
> +		9, 10, 12, 14, 15, 16, 20, 21,
> +		24, 25, 30, 36, 42, 49
> +	};
> +	const int postdiv1_list[22] = {
> +		1, 2, 3, 4, 5, 6, 7, 4, 3, 5,
> +		4, 7, 5, 4, 5, 7, 6, 5, 6, 6,
> +		7, 7
> +	};
> +	const int postdiv2_list[22] = {
> +		1, 1, 1, 1, 1, 1, 1, 2, 3, 2,
> +		3, 2, 3, 4, 4, 3, 4, 5, 5, 6,
> +		6, 7
> +	};
> +
> +	if (!pixel_clock) {
> +		DRM_ERROR("Pixel clock can't be zero!\n");
> +		return -EINVAL;
> +	}
> +
> +	pixel_clock_ori = pixel_clock;
> +	pixel_clock_cur = pixel_clock_ori;
> +
> +	if (pixel_clock_ori <= 255000000) {
> +		pixel_clock_cur *= 7;
> +		dss_pxl0_clk /= 7;
> +	} else if (pixel_clock_ori <= 415000000) {
> +		pixel_clock_cur *= 5;
> +		dss_pxl0_clk /= 5;
> +	} else if (pixel_clock_ori <= 594000000) {
> +		pixel_clock_cur *= 3;
> +		dss_pxl0_clk /= 3;
> +	} else {
> +		DRM_ERROR("Clock not supported!\n");
> +		return -EINVAL;
> +	}
> +
> +	pixel_clock_cur = pixel_clock_cur / 1000;
> +	ceil_temp = hdmi_ceil(vco_min_freq_output, pixel_clock_cur);
> +
> +	if (ceil_temp < 0) {
> +		DRM_ERROR("pixel_clock_cur can't be zero!\n");
> +		return -EINVAL;
> +	}
> +
> +	ppll7_freq_divider = (u64)ceil_temp;
> +
> +	for (i = 0; i < ARRAY_SIZE(freq_divider_list); i++) {
> +		if (freq_divider_list[i] >= ppll7_freq_divider) {
> +			ppll7_freq_divider = freq_divider_list[i];
> +			postdiv1 = postdiv1_list[i];
> +			postdiv2 = postdiv2_list[i];
> +			break;
> +		}
> +	}
> +
> +	if (i == ARRAY_SIZE(freq_divider_list)) {
> +		DRM_ERROR("Can't find a valid setting for PLL7!\n");
> +		return -EINVAL;
> +	}
> +
> +	vco_freq_output = ppll7_freq_divider * pixel_clock_cur;
> +	if (!vco_freq_output) {
> +		DRM_ERROR("Can't find a valid setting for VCO_FREQ!\n");
> +		return -EINVAL;
> +	}
> +
> +	ceil_temp = hdmi_ceil(400000, vco_freq_output);
> +	if (ceil_temp < 0) {
> +		DRM_ERROR("Can't find a valid setting for PLL7!\n");
> +		return -EINVAL;
> +	}
> +
> +	refdiv = ((vco_freq_output * ceil_temp) >= 494000) ? 1 : 2;
> +	fbdiv = (vco_freq_output * ceil_temp) * refdiv / sys_clock_fref;
> +
> +	frac = (u64)(ceil_temp * vco_freq_output - sys_clock_fref / refdiv * fbdiv) * refdiv * frac_range;
> +	frac = (u64)frac / sys_clock_fref;
> +
> +	ppll7ctrl0 = readl(ctx->pmctrl_base + MIDIA_PPLL7_CTRL0);
> +	ppll7ctrl0 &= ~MIDIA_PPLL7_FREQ_DEVIDER_MASK;
> +
> +	ppll7ctrl0_val = 0x0;
> +	ppll7ctrl0_val |= (u32)(postdiv2 << 23 | postdiv1 << 20 | fbdiv << 8 | refdiv << 2);
> +	ppll7ctrl0_val &= MIDIA_PPLL7_FREQ_DEVIDER_MASK;
> +	ppll7ctrl0 |= ppll7ctrl0_val;
> +
> +	writel(ppll7ctrl0, ctx->pmctrl_base + MIDIA_PPLL7_CTRL0);
> +
> +	ppll7ctrl1 = readl(ctx->pmctrl_base + MIDIA_PPLL7_CTRL1);
> +	ppll7ctrl1 &= ~MIDIA_PPLL7_FRAC_MODE_MASK;
> +
> +	ppll7ctrl1_val = 0x0;
> +	ppll7ctrl1_val |= (u32)(1 << 25 | 0 << 24 | frac);
> +	ppll7ctrl1_val &= MIDIA_PPLL7_FRAC_MODE_MASK;
> +	ppll7ctrl1 |= ppll7ctrl1_val;
> +
> +	writel(ppll7ctrl1, ctx->pmctrl_base + MIDIA_PPLL7_CTRL1);
> +
> +	DRM_INFO("PLL7 set to (0x%0x, 0x%0x)\n", ppll7ctrl0, ppll7ctrl1);
> +
> +	ret = clk_set_rate(ctx->dss_pxl0_clk, dss_pxl0_clk);
> +	if (ret < 0)
> +		DRM_ERROR("%s: clk_set_rate(dss_pxl0_clk, %llu) failed: %d!\n",
> +			  __func__, dss_pxl0_clk, ret);
> +	else
> +		DRM_INFO("dss_pxl0_clk:[%llu]->[%lu].\n",
> +			 dss_pxl0_clk, clk_get_rate(ctx->dss_pxl0_clk));
> +
> +	return ret;
> +}
> +
> +static u64 dss_calculate_clock(struct dss_crtc *acrtc,
> +			       const struct drm_display_mode *mode)
> +{
> +	u64 clk_Hz;
> +
> +	if (acrtc->ctx->g_dss_version_tag == FB_ACCEL_KIRIN970) {
> +		if (mode->clock == 148500)
> +			clk_Hz = 144000 * 1000UL;
> +		else if (mode->clock == 83496)
> +			clk_Hz = 84000 * 1000UL;
> +		else if (mode->clock == 74440)
> +			clk_Hz = 72000 * 1000UL;
> +		else if (mode->clock == 74250)
> +			clk_Hz = 72000 * 1000UL;
> +		else
> +			clk_Hz = mode->clock * 1000UL;
> +
> +		/* Adjust pixel clock for compatibility with 10.1 inch special displays. */
> +		if (mode->clock == 148500 && mode->width_mm == 532 && mode->height_mm == 299)
> +			clk_Hz = 152000 * 1000UL;
> +	} else {
> +		if (mode->clock == 148500)
> +			clk_Hz = 144000 * 1000UL;
> +		else if (mode->clock == 83496)
> +			clk_Hz = 80000 * 1000UL;
> +		else if (mode->clock == 74440)
> +			clk_Hz = 72000 * 1000UL;
> +		else if (mode->clock == 74250)
> +			clk_Hz = 72000 * 1000UL;
> +		else
> +			clk_Hz = mode->clock * 1000UL;
> +	}
> +
> +	return clk_Hz;
> +}
> +
> +static void dss_ldi_set_mode(struct dss_crtc *acrtc)
> +{
> +	struct drm_display_mode *adj_mode = &acrtc->base.state->adjusted_mode;
> +	struct drm_display_mode *mode = &acrtc->base.state->mode;
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +	u32 clock = mode->clock;
> +	u64 clk_Hz;
> +	int ret;
> +
> +	clk_Hz = dss_calculate_clock(acrtc, mode);
> +
> +	DRM_INFO("Requested clock %u kHz, setting to %llu kHz\n",
> +		 clock, clk_Hz / 1000);
> +
> +	if (acrtc->ctx->g_dss_version_tag == FB_ACCEL_KIRIN970) {
> +		ret = hdmi_pxl_ppll7_init(ctx, clk_Hz);
> +	} else {
> +		ret = clk_set_rate(ctx->dss_pxl0_clk, clk_Hz);
> +		if (!ret) {
> +			clk_Hz = clk_get_rate(ctx->dss_pxl0_clk);
> +			DRM_INFO("dss_pxl0_clk:[%llu]->[%lu].\n",
> +				 clk_Hz, clk_get_rate(ctx->dss_pxl0_clk));
> +		}
> +	}
> +
> +	if (ret)
> +		DRM_ERROR("failed to set pixel clock\n");
> +	else
> +		adj_mode->clock = clk_Hz / 1000;
> +
> +	dpe_init(acrtc);
> +}
> +
> +static int dss_power_up(struct dss_crtc *acrtc)
> +{
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +	int ret = 0;
> +
> +	if (ctx->g_dss_version_tag == FB_ACCEL_KIRIN970) {
> +		mediacrg_regulator_enable(ctx);
> +		dpe_common_clk_enable(ctx);
> +		dpe_inner_clk_enable(ctx);
> +#ifndef DSS_POWER_UP_ON_UEFI
> +		dpe_regulator_enable(ctx);
> +#endif
This takes focus - can the ifdef be dropped?

> +		dpe_set_clk_rate(ctx);
> +	} else {
> +		ret = clk_prepare_enable(ctx->dss_pxl0_clk);
> +		if (ret) {
> +			DRM_ERROR("failed to enable dss_pxl0_clk (%d)\n", ret);
> +			return ret;
> +		}
> +
> +		ret = clk_prepare_enable(ctx->dss_pri_clk);
> +		if (ret) {
> +			DRM_ERROR("failed to enable dss_pri_clk (%d)\n", ret);
> +			return ret;
> +		}
> +
> +		ret = clk_prepare_enable(ctx->dss_pclk_dss_clk);
> +		if (ret) {
> +			DRM_ERROR("failed to enable dss_pclk_dss_clk (%d)\n", ret);
> +			return ret;
> +		}
> +
> +		ret = clk_prepare_enable(ctx->dss_axi_clk);
> +		if (ret) {
> +			DRM_ERROR("failed to enable dss_axi_clk (%d)\n", ret);
> +			return ret;
> +		}
> +
> +		ret = clk_prepare_enable(ctx->dss_mmbuf_clk);
> +		if (ret) {
> +			DRM_ERROR("failed to enable dss_mmbuf_clk (%d)\n", ret);
> +			return ret;
> +		}
> +	}
> +
> +	dss_inner_clk_common_enable(ctx);
> +	dss_inner_clk_pdp_enable(ctx);
> +
> +	dpe_interrupt_mask(acrtc);
> +	dpe_interrupt_clear(acrtc);
> +	dpe_irq_enable(acrtc);
> +	dpe_interrupt_unmask(acrtc);
> +
> +	ctx->power_on = true;
> +
> +	return ret;
> +}
> +
> +static void dss_power_down(struct dss_crtc *acrtc)
> +{
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +
> +	dpe_interrupt_mask(acrtc);
> +	dpe_irq_disable(acrtc);
> +	dpe_deinit(acrtc);
> +
> +	//FIXME:
??

> +	dpe_check_itf_status(acrtc);
> +	dss_inner_clk_pdp_disable(ctx);
> +
> +	if (ctx->g_dss_version_tag & FB_ACCEL_KIRIN970) {
> +		dpe_regulator_disable(ctx);
> +		dpe_inner_clk_disable(ctx);
> +		dpe_common_clk_disable(ctx);
> +		mediacrg_regulator_disable(ctx);
> +	} else {
> +		dpe_regulator_disable(ctx);
> +		dpe_inner_clk_disable(ctx);
> +		dpe_common_clk_disable(ctx);
> +	}
> +
> +	ctx->power_on = false;
> +}
> +
> +static int dss_enable_vblank(struct drm_crtc *crtc)
> +{
> +	struct dss_crtc *acrtc = to_dss_crtc(crtc);
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +
> +	DRM_INFO("%s\n", __func__);
> +	if (!ctx->power_on) {
> +		DRM_INFO("Enabling vblank\n");
> +		(void)dss_power_up(acrtc);
> +	}
> +
> +	return 0;
> +}
> +
> +static void dss_disable_vblank(struct drm_crtc *crtc)
> +{
> +	struct dss_crtc *acrtc = to_dss_crtc(crtc);
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +
> +	DRM_INFO("%s\n", __func__);
> +	if (!ctx->power_on) {
> +		DRM_ERROR("power is down! vblank disable fail\n");
> +		return;
> +	}
> +}
> +
> +static irqreturn_t dss_irq_handler(int irq, void *data)
> +{
> +	struct dss_crtc *acrtc = data;
> +	struct drm_crtc *crtc = &acrtc->base;
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +	void __iomem *dss_base = ctx->base;
> +
> +	u32 isr_s1 = 0;
> +	u32 isr_s2 = 0;
> +	u32 mask = 0;
> +
> +	isr_s1 = readl(dss_base + GLB_CPU_PDP_INTS);
> +	isr_s2 = readl(dss_base + DSS_LDI0_OFFSET + LDI_CPU_ITF_INTS);
> +	DRM_INFO_ONCE("isr_s1 = 0x%x!\n", isr_s1);
> +	DRM_INFO_ONCE("isr_s2 = 0x%x!\n", isr_s2);
> +
> +	writel(isr_s2, dss_base + DSS_LDI0_OFFSET + LDI_CPU_ITF_INTS);
> +	writel(isr_s1, dss_base + GLB_CPU_PDP_INTS);
> +
> +	isr_s1 &= ~(readl(dss_base + GLB_CPU_PDP_INT_MSK));
> +	isr_s2 &= ~(readl(dss_base + DSS_LDI0_OFFSET + LDI_CPU_ITF_INT_MSK));
> +
> +	if (isr_s2 & BIT_VACTIVE0_END) {
> +		ctx->vactive0_end_flag++;
> +		wake_up_interruptible_all(&ctx->vactive0_end_wq);
> +	}
> +
> +	if (isr_s2 & BIT_VSYNC) {
> +		ctx->vsync_timestamp = ktime_get();
> +		drm_crtc_handle_vblank(crtc);
> +	}
> +
> +	if (isr_s2 & BIT_LDI_UNFLOW) {
> +		mask = readl(dss_base + DSS_LDI0_OFFSET + LDI_CPU_ITF_INT_MSK);
> +		mask |= BIT_LDI_UNFLOW;
> +		writel(mask, dss_base + DSS_LDI0_OFFSET + LDI_CPU_ITF_INT_MSK);
> +
> +		DRM_ERROR("ldi underflow!\n");
> +	}
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static bool dss_crtc_mode_fixup(struct drm_crtc *crtc,
> +				const struct drm_display_mode *mode,
> +				struct drm_display_mode *adj_mode)
> +{
> +	struct dss_crtc *acrtc = to_dss_crtc(crtc);
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +	u64 clk_Hz;
> +
> +	/* Check if clock is too high */
> +	if (mode->clock > 594000)
> +		return false;
> +	/*
> +	 * FIXME: the code should, instead, do some calculus instead of
> +	 * hardcoding the modes. Clearly, there's something missing at
> +	 * dss_calculate_clock()
> +	 */
> +
> +#if 0
> +	/*
> +	 * HACK: reports at Hikey 970 mailing lists with the downstream
> +	 * Official Linaro 4.9 driver seem to indicate that some monitor
> +	 * modes aren't properly set. There, this hack was added.
> +	 *
> +	 * On my monitors, this wasn't needed, but better to keep this
> +	 * code here, together with this notice, just in case.
> +	 */
> +	if ((mode->hdisplay    == 1920 && mode->vdisplay == 1080 && mode->clock == 148500)
> +	    || (mode->hdisplay == 1920 && mode->vdisplay == 1080 && mode->clock == 148352)
> +	    || (mode->hdisplay == 1920 && mode->vdisplay == 1080 && mode->clock ==  80192)
> +	    || (mode->hdisplay == 1920 && mode->vdisplay == 1080 && mode->clock ==  74250)
> +	    || (mode->hdisplay == 1920 && mode->vdisplay == 1080 && mode->clock ==  61855)
> +	    || (mode->hdisplay == 1680 && mode->vdisplay == 1050 && mode->clock == 147116)
> +	    || (mode->hdisplay == 1680 && mode->vdisplay == 1050 && mode->clock == 146250)
> +	    || (mode->hdisplay == 1680 && mode->vdisplay == 1050 && mode->clock == 144589)
> +	    || (mode->hdisplay == 1600 && mode->vdisplay == 1200 && mode->clock == 160961)
> +	    || (mode->hdisplay == 1600 && mode->vdisplay == 900  && mode->clock == 118963)
> +	    || (mode->hdisplay == 1440 && mode->vdisplay == 900  && mode->clock == 126991)
> +	    || (mode->hdisplay == 1280 && mode->vdisplay == 1024 && mode->clock == 128946)
> +	    || (mode->hdisplay == 1280 && mode->vdisplay == 1024 && mode->clock ==  98619)
> +	    || (mode->hdisplay == 1280 && mode->vdisplay == 960  && mode->clock == 102081)
> +	    || (mode->hdisplay == 1280 && mode->vdisplay == 800  && mode->clock ==  83496)
> +	    || (mode->hdisplay == 1280 && mode->vdisplay == 720  && mode->clock ==  74440)
> +	    || (mode->hdisplay == 1280 && mode->vdisplay == 720  && mode->clock ==  74250)
> +	    || (mode->hdisplay == 1024 && mode->vdisplay == 768  && mode->clock ==  78800)
> +	    || (mode->hdisplay == 1024 && mode->vdisplay == 768  && mode->clock ==  75000)
> +	    || (mode->hdisplay == 1024 && mode->vdisplay == 768  && mode->clock ==  81833)
> +	    || (mode->hdisplay == 800  && mode->vdisplay == 600  && mode->clock ==  48907)
> +	    || (mode->hdisplay == 800  && mode->vdisplay == 600  && mode->clock ==  40000)
> +	    || (mode->hdisplay == 800  && mode->vdisplay == 480  && mode->clock ==  32000)
> +	   )
> +#endif
> +	{
> +		clk_Hz = dss_calculate_clock(acrtc, mode);
> +
> +		/*
> +		 * On Kirin970, PXL0 clock is set to a const value,
> +		 * independently of the pixel clock.
> +		 */
> +		if (acrtc->ctx->g_dss_version_tag != FB_ACCEL_KIRIN970)
> +			clk_Hz = clk_round_rate(ctx->dss_pxl0_clk, mode->clock * 1000);
> +
> +		adj_mode->clock = clk_Hz / 1000;
> +
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +static void dss_crtc_enable(struct drm_crtc *crtc,
> +			    struct drm_crtc_state *old_state)
> +{
> +	struct dss_crtc *acrtc = to_dss_crtc(crtc);
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +	int ret;
> +
> +	if (acrtc->enable)
> +		return;
> +
> +	if (!ctx->power_on) {
> +		ret = dss_power_up(acrtc);
> +		if (ret)
> +			return;
> +	}
> +
> +	acrtc->enable = true;
> +	drm_crtc_vblank_on(crtc);
> +}
> +
> +static void dss_crtc_disable(struct drm_crtc *crtc,
> +			     struct drm_crtc_state *old_state)
> +{
> +	struct dss_crtc *acrtc = to_dss_crtc(crtc);
> +
> +	if (!acrtc->enable)
> +		return;
> +
> +	dss_power_down(acrtc);
> +	acrtc->enable = false;
> +	drm_crtc_vblank_off(crtc);
> +}
> +
> +static void dss_crtc_mode_set_nofb(struct drm_crtc *crtc)
> +{
> +	struct dss_crtc *acrtc = to_dss_crtc(crtc);
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +
> +	if (!ctx->power_on)
> +		(void)dss_power_up(acrtc);
> +	dss_ldi_set_mode(acrtc);
> +}
> +
> +static void dss_crtc_atomic_begin(struct drm_crtc *crtc,
> +				  struct drm_crtc_state *old_state)
> +{
> +	struct dss_crtc *acrtc = to_dss_crtc(crtc);
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +
> +	if (!ctx->power_on)
> +		(void)dss_power_up(acrtc);
> +}
> +
> +static void dss_crtc_atomic_flush(struct drm_crtc *crtc,
> +				  struct drm_crtc_state *old_state)
> +
> +{
> +	struct drm_pending_vblank_event *event = crtc->state->event;
> +
> +	if (event) {
> +		crtc->state->event = NULL;
> +
> +		spin_lock_irq(&crtc->dev->event_lock);
> +		if (drm_crtc_vblank_get(crtc) == 0)
> +			drm_crtc_arm_vblank_event(crtc, event);
> +		else
> +			drm_crtc_send_vblank_event(crtc, event);
> +		spin_unlock_irq(&crtc->dev->event_lock);
> +	}
> +}
> +
> +static const struct drm_crtc_helper_funcs dss_crtc_helper_funcs = {
> +	.mode_fixup	= dss_crtc_mode_fixup,
> +	.atomic_enable	= dss_crtc_enable,
> +	.atomic_disable	= dss_crtc_disable,
> +	.mode_set_nofb	= dss_crtc_mode_set_nofb,
> +	.atomic_begin	= dss_crtc_atomic_begin,
> +	.atomic_flush	= dss_crtc_atomic_flush,
> +};
> +
> +static const struct drm_crtc_funcs dss_crtc_funcs = {
> +	.destroy	= drm_crtc_cleanup,
> +	.set_config	= drm_atomic_helper_set_config,
> +	.page_flip	= drm_atomic_helper_page_flip,
> +	.reset		= drm_atomic_helper_crtc_reset,
> +	.atomic_duplicate_state	= drm_atomic_helper_crtc_duplicate_state,
> +	.atomic_destroy_state	= drm_atomic_helper_crtc_destroy_state,
> +	.enable_vblank = dss_enable_vblank,
> +	.disable_vblank = dss_disable_vblank,
> +};
> +
> +static int dss_crtc_init(struct drm_device *dev, struct drm_crtc *crtc,
> +			 struct drm_plane *plane)
> +{
> +	struct kirin_drm_private *priv = dev->dev_private;
> +	struct device_node *port;
> +	int ret;
> +
> +	/* set crtc port so that
> +	 * drm_of_find_possible_crtcs call works
> +	 */
> +	port = of_get_child_by_name(dev->dev->of_node, "port");
> +	if (!port) {
> +		DRM_ERROR("no port node found in %s\n",
> +			  dev->dev->of_node->full_name);
> +		return -EINVAL;
> +	}
> +	of_node_put(port);
> +	crtc->port = port;
> +
> +	ret = drm_crtc_init_with_planes(dev, crtc, plane, NULL,
> +					&dss_crtc_funcs, NULL);
> +	if (ret) {
> +		DRM_ERROR("failed to init crtc.\n");
> +		return ret;
> +	}
> +
> +	drm_crtc_helper_add(crtc, &dss_crtc_helper_funcs);
> +	priv->crtc[drm_crtc_index(crtc)] = crtc;
> +
> +	return 0;
> +}
> +
> +static int dss_plane_atomic_check(struct drm_plane *plane,
> +				  struct drm_plane_state *state)
> +{
> +	struct drm_framebuffer *fb = state->fb;
> +	struct drm_crtc *crtc = state->crtc;
> +	struct drm_crtc_state *crtc_state;
> +	u32 src_x = state->src_x >> 16;
> +	u32 src_y = state->src_y >> 16;
> +	u32 src_w = state->src_w >> 16;
> +	u32 src_h = state->src_h >> 16;
> +	int crtc_x = state->crtc_x;
> +	int crtc_y = state->crtc_y;
> +	u32 crtc_w = state->crtc_w;
> +	u32 crtc_h = state->crtc_h;
> +	u32 fmt;
> +
> +	if (!crtc || !fb)
> +		return 0;
> +
> +	fmt = dss_get_format(fb->format->format);
> +	if (fmt == HISI_FB_PIXEL_FORMAT_UNSUPPORT)
> +		return -EINVAL;
> +
> +	crtc_state = drm_atomic_get_crtc_state(state->state, crtc);
> +	if (IS_ERR(crtc_state))
> +		return PTR_ERR(crtc_state);
> +
> +	if (src_w != crtc_w || src_h != crtc_h) {
> +		DRM_ERROR("Scale not support!!!\n");
> +		return -EINVAL;
> +	}
> +
> +	if (src_x + src_w > fb->width ||
> +	    src_y + src_h > fb->height)
> +		return -EINVAL;
> +
> +	if (crtc_x < 0 || crtc_y < 0)
> +		return -EINVAL;
> +
> +	if (crtc_x + crtc_w > crtc_state->adjusted_mode.hdisplay ||
> +	    crtc_y + crtc_h > crtc_state->adjusted_mode.vdisplay)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static void dss_plane_atomic_update(struct drm_plane *plane,
> +				    struct drm_plane_state *old_state)
> +{
> +	hisi_fb_pan_display(plane);
> +}
> +
> +static void dss_plane_atomic_disable(struct drm_plane *plane,
> +				     struct drm_plane_state *old_state)
> +{
> +	// FIXME: Maybe this?
> +#if 0
> +	struct dss_plane *aplane = to_dss_plane(plane);
> +	struct dss_crtc *acrtc = aplane->acrtc;
> +
> +	disable_ldi(acrtc);
> +	hisifb_mctl_sw_clr(acrtc);
> +#endif
> +}
> +
> +static const struct drm_plane_helper_funcs dss_plane_helper_funcs = {
> +	.atomic_check = dss_plane_atomic_check,
> +	.atomic_update = dss_plane_atomic_update,
> +	.atomic_disable = dss_plane_atomic_disable,
> +};
> +
> +static struct drm_plane_funcs dss_plane_funcs = {
> +	.update_plane	= drm_atomic_helper_update_plane,
> +	.disable_plane	= drm_atomic_helper_disable_plane,
> +	.destroy = drm_plane_cleanup,
> +	.reset = drm_atomic_helper_plane_reset,
> +	.atomic_duplicate_state = drm_atomic_helper_plane_duplicate_state,
> +	.atomic_destroy_state = drm_atomic_helper_plane_destroy_state,
> +};
> +
> +static int dss_plane_init(struct drm_device *dev, struct dss_plane *aplane,
> +			  enum drm_plane_type type)
> +{
> +	const u32 *fmts;
> +	u32 fmts_cnt;
> +	int ret = 0;
> +
> +	/* get properties */
> +	fmts_cnt = dss_get_channel_formats(aplane->ch, &fmts);
> +	if (ret)
> +		return ret;
> +
> +	ret = drm_universal_plane_init(dev, &aplane->base, 1, &dss_plane_funcs,
> +				       fmts, fmts_cnt, NULL,
> +				       type, NULL);
> +	if (ret) {
> +		DRM_ERROR("fail to init plane, ch=%d\n", aplane->ch);
> +		return ret;
> +	}
> +
> +	drm_plane_helper_add(&aplane->base, &dss_plane_helper_funcs);
> +
> +	return 0;
> +}
> +
> +static int dss_enable_iommu(struct platform_device *pdev, struct dss_hw_ctx *ctx)
> +{
> +#if 0
> +/*
> + * FIXME:
> + *
> + * Right now, the IOMMU support is actually disabled. See the caller of
> + * hisi_dss_smmu_config(). Yet, if we end enabling it, this should be
> + * ported to use io-pgtable directly.
> + */
> +	struct device *dev = NULL;
> +
> +	dev = &pdev->dev;
> +
> +	/* create iommu domain */
> +	ctx->mmu_domain = iommu_domain_alloc(dev->bus);
> +	if (!ctx->mmu_domain) {
> +		pr_err("iommu_domain_alloc failed!\n");
> +		return -EINVAL;
> +	}
> +
> +	iommu_attach_device(ctx->mmu_domain, dev);
> +#endif
> +	return 0;
> +}
> +
> +static int dss_dts_parse(struct platform_device *pdev, struct dss_hw_ctx *ctx)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct device_node *np = NULL;
> +	const char *compatible;
> +	int ret = 0;
> +
> +	if (ctx->g_dss_version_tag == FB_ACCEL_KIRIN970)
> +		compatible = "hisilicon,kirin970-dpe";
> +	else
> +		compatible = "hisilicon,hi3660-dpe";
> +
> +	np = of_find_compatible_node(NULL, NULL, compatible);
> +	if (!np) {
> +		DRM_ERROR("NOT FOUND device node %s!\n", compatible);
> +		return -ENXIO;
> +	}
> +
> +	/* Initialize version-specific data */
> +	if (ctx->g_dss_version_tag == FB_ACCEL_HI366x)
> +		kirin960_dpe_defs(ctx);
> +	else
> +		kirin970_dpe_defs(ctx);
> +
> +	ctx->base = of_iomap(np, 0);
> +	if (!(ctx->base)) {
> +		DRM_ERROR("failed to get dss base resource.\n");
> +		return -ENXIO;
> +	}
> +
> +	ctx->peri_crg_base  = of_iomap(np, 1);
> +	if (!(ctx->peri_crg_base)) {
> +		DRM_ERROR("failed to get dss peri_crg_base resource.\n");
> +		return -ENXIO;
> +	}
> +
> +	ctx->sctrl_base  = of_iomap(np, 2);
> +	if (!(ctx->sctrl_base)) {
> +		DRM_ERROR("failed to get dss sctrl_base resource.\n");
> +		return -ENXIO;
> +	}
> +
> +	if (ctx->g_dss_version_tag == FB_ACCEL_KIRIN970) {
> +		ctx->pctrl_base = of_iomap(np, 3);
> +		if (!(ctx->pctrl_base)) {
> +			DRM_ERROR("failed to get dss pctrl_base resource.\n");
> +			return -ENXIO;
> +		}
> +	} else {
> +		ctx->pmc_base = of_iomap(np, 3);
> +		if (!(ctx->pmc_base)) {
> +			DRM_ERROR("failed to get dss pmc_base resource.\n");
> +			return -ENXIO;
> +		}
> +	}
> +
> +	ctx->noc_dss_base = of_iomap(np, 4);
> +	if (!(ctx->noc_dss_base)) {
> +		DRM_ERROR("failed to get noc_dss_base resource.\n");
> +		return -ENXIO;
> +	}
> +
> +	if (ctx->g_dss_version_tag == FB_ACCEL_KIRIN970) {
> +		ctx->pmctrl_base = of_iomap(np, 5);
> +		if (!(ctx->pmctrl_base)) {
> +			DRM_ERROR("failed to get dss pmctrl_base resource.\n");
> +			return -ENXIO;
> +		}
> +
> +		ctx->media_crg_base = of_iomap(np, 6);
> +		if (!(ctx->media_crg_base)) {
> +			DRM_ERROR("failed to get dss media_crg_base resource.\n");
> +			return -ENXIO;
> +		}
> +	}
> +
> +	/* get irq no */
> +	ctx->irq = irq_of_parse_and_map(np, 0);
> +	if (ctx->irq <= 0) {
> +		DRM_ERROR("failed to get irq_pdp resource.\n");
> +		return -ENXIO;
> +	}
> +
> +	DRM_INFO("dss irq = %d.\n", ctx->irq);
> +
> +	if (ctx->g_dss_version_tag == FB_ACCEL_KIRIN970) {
> +		ctx->dpe_regulator = devm_regulator_get(dev, REGULATOR_PDP_NAME);
> +		if (!ctx->dpe_regulator) {
> +			DRM_ERROR("failed to get dpe_regulator resource! ret=%d.\n", ret);
> +			return -ENXIO;
> +		}
> +	}
> +
> +	ctx->dss_mmbuf_clk = devm_clk_get(dev, "clk_dss_axi_mm");
> +	if (!ctx->dss_mmbuf_clk) {
> +		DRM_ERROR("failed to parse dss_mmbuf_clk\n");
> +		return -ENODEV;
> +	}
> +
> +	ctx->dss_axi_clk = devm_clk_get(dev, "aclk_dss");
> +	if (!ctx->dss_axi_clk) {
> +		DRM_ERROR("failed to parse dss_axi_clk\n");
> +		return -ENODEV;
> +	}
> +
> +	ctx->dss_pclk_dss_clk = devm_clk_get(dev, "pclk_dss");
> +	if (!ctx->dss_pclk_dss_clk) {
> +		DRM_ERROR("failed to parse dss_pclk_dss_clk\n");
> +		return -ENODEV;
> +	}
> +
> +	ctx->dss_pri_clk = devm_clk_get(dev, "clk_edc0");
> +	if (!ctx->dss_pri_clk) {
> +		DRM_ERROR("failed to parse dss_pri_clk\n");
> +	return -ENODEV;
> +	}
> +
> +	if (ctx->g_dss_version_tag != FB_ACCEL_KIRIN970) {
> +		ret = clk_set_rate(ctx->dss_pri_clk, DEFAULT_DSS_CORE_CLK_07V_RATE);
> +		if (ret < 0) {
> +			DRM_ERROR("dss_pri_clk clk_set_rate(%lu) failed, error=%d!\n",
> +				  DEFAULT_DSS_CORE_CLK_07V_RATE, ret);
> +			return -EINVAL;
> +		}
> +
> +		DRM_INFO("dss_pri_clk:[%lu]->[%llu].\n",
> +			 DEFAULT_DSS_CORE_CLK_07V_RATE, (uint64_t)clk_get_rate(ctx->dss_pri_clk));
> +	}
> +
> +	ctx->dss_pxl0_clk = devm_clk_get(dev, "clk_ldi0");
> +	if (!ctx->dss_pxl0_clk) {
> +		DRM_ERROR("failed to parse dss_pxl0_clk\n");
> +		return -ENODEV;
> +	}
> +
> +	if (ctx->g_dss_version_tag != FB_ACCEL_KIRIN970) {
> +		ret = clk_set_rate(ctx->dss_pxl0_clk, DSS_MAX_PXL0_CLK_144M);
> +		if (ret < 0) {
> +			DRM_ERROR("dss_pxl0_clk clk_set_rate(%lu) failed, error=%d!\n",
> +				  DSS_MAX_PXL0_CLK_144M, ret);
> +			return -EINVAL;
> +		}
> +
> +		DRM_INFO("dss_pxl0_clk:[%lu]->[%llu].\n",
> +			 DSS_MAX_PXL0_CLK_144M, (uint64_t)clk_get_rate(ctx->dss_pxl0_clk));
> +	}
> +
> +	/* enable IOMMU */
> +	dss_enable_iommu(pdev, ctx);
> +
I had expected some of these could fail with a PROBE_DEFER.
Consider to use the newly introduced dev_probe_err()


> +	return 0;
> +}
> +
> +static int dss_drm_init(struct drm_device *dev, u32 g_dss_version_tag)
> +{
> +	struct platform_device *pdev = to_platform_device(dev->dev);
> +	struct dss_data *dss;
> +	struct dss_hw_ctx *ctx;
> +	struct dss_crtc *acrtc;
> +	struct dss_plane *aplane;
> +	enum drm_plane_type type;
> +	int ret;
> +	int i;
> +
> +	dss = devm_kzalloc(dev->dev, sizeof(*dss), GFP_KERNEL);
> +	if (!dss) {
> +		DRM_ERROR("failed to alloc dss_data\n");
> +		return -ENOMEM;
> +	}
> +	platform_set_drvdata(pdev, dss);
> +
> +	ctx = &dss->ctx;
> +	acrtc = &dss->acrtc;
> +	acrtc->ctx = ctx;
> +	acrtc->out_format = LCD_RGB888;
> +	acrtc->bgr_fmt = LCD_RGB;
> +	ctx->g_dss_version_tag = g_dss_version_tag;
> +
> +	ret = dss_dts_parse(pdev, ctx);
> +	if (ret)
> +		return ret;
> +
> +	ctx->screen_base = 0;
> +	ctx->screen_size = 0;
> +	ctx->smem_start = 0;
> +
> +	ctx->vactive0_end_flag = 0;
> +	init_waitqueue_head(&ctx->vactive0_end_wq);
> +
> +	/*
> +	 * plane init
> +	 * TODO: Now only support primary plane, overlay planes
> +	 * need to do.
> +	 */
> +	for (i = 0; i < DSS_CH_NUM; i++) {
> +		aplane = &dss->aplane[i];
> +		aplane->ch = i;
> +		/*aplane->ctx = ctx;*/
> +		aplane->acrtc = acrtc;
> +		type = i == PRIMARY_CH ? DRM_PLANE_TYPE_PRIMARY :
> +			DRM_PLANE_TYPE_OVERLAY;
> +
> +		ret = dss_plane_init(dev, aplane, type);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	/* crtc init */
> +	ret = dss_crtc_init(dev, &acrtc->base, &dss->aplane[PRIMARY_CH].base);
> +	if (ret)
> +		return ret;
> +
> +	/* vblank irq init */
> +	ret = devm_request_irq(dev->dev, ctx->irq, dss_irq_handler,
> +			       IRQF_SHARED, dev->driver->name, acrtc);
> +	if (ret) {
> +		DRM_ERROR("fail to  devm_request_irq, ret=%d!", ret);
> +		return ret;
> +	}
> +
> +	disable_irq(ctx->irq);
> +
> +	return 0;
> +}
> +
> +static void dss_drm_cleanup(struct drm_device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev->dev);
> +	struct dss_data *dss = platform_get_drvdata(pdev);
> +	struct drm_crtc *crtc = &dss->acrtc.base;
> +
> +	drm_crtc_cleanup(crtc);
> +}
> +
> +static int  dss_drm_suspend(struct platform_device *pdev, pm_message_t state)
> +{
> +	struct dss_data *dss = platform_get_drvdata(pdev);
> +	struct drm_crtc *crtc = &dss->acrtc.base;
> +
> +	dss_crtc_disable(crtc, NULL);
> +
> +	return 0;
> +}
There is a suspend (and resume) helper - can it be used?

> +
> +static int  dss_drm_resume(struct platform_device *pdev)
> +{
> +	struct dss_data *dss = platform_get_drvdata(pdev);
> +	struct drm_crtc *crtc = &dss->acrtc.base;
> +
> +	dss_crtc_mode_set_nofb(crtc);
> +	dss_crtc_enable(crtc, NULL);
> +
> +	return 0;
> +}
> +
> +static int kirin960_dss_drm_init(struct drm_device *dev)
> +{
> +	return dss_drm_init(dev, FB_ACCEL_HI366x);
> +}
> +
> +const struct kirin_dc_ops kirin960_dss_dc_ops = {
> +	.init = kirin960_dss_drm_init,
> +	.cleanup = dss_drm_cleanup,
> +	.suspend = dss_drm_suspend,
> +	.resume = dss_drm_resume,
> +};
> +
> +static int kirin970_dss_drm_init(struct drm_device *dev)
> +{
> +	return dss_drm_init(dev, FB_ACCEL_KIRIN970);
> +}
> +
> +const struct kirin_dc_ops kirin970_dss_dc_ops = {
> +	.init = kirin970_dss_drm_init,
> +	.cleanup = dss_drm_cleanup,
> +	.suspend = dss_drm_suspend,
> +	.resume = dss_drm_resume,
> +};
> diff --git a/drivers/staging/hikey9xx/gpu/kirin9xx_drm_overlay_utils.c b/drivers/staging/hikey9xx/gpu/kirin9xx_drm_overlay_utils.c
> new file mode 100644
> index 000000000000..5ac7f4b31d99
> --- /dev/null
> +++ b/drivers/staging/hikey9xx/gpu/kirin9xx_drm_overlay_utils.c
> @@ -0,0 +1,1005 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2008-2011, Hisilicon Tech. Co., Ltd. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <drm/drm_atomic.h>
> +#include <drm/drm_atomic_helper.h>
> +#include <drm/drm_crtc.h>
> +#include <drm/drm_crtc_helper.h>
> +#include <drm/drm_drv.h>
> +#include <drm/drm_fb_cma_helper.h>
> +#include <drm/drm_fourcc.h>
> +#include <drm/drm_gem_cma_helper.h>
> +#include <drm/drm_plane_helper.h>
> +
> +#include "kirin9xx_drm_dpe_utils.h"
> +#include "kirin9xx_drm_drv.h"
> +#include "kirin9xx_dpe.h"
> +
> +static const int mid_array[DSS_CHN_MAX_DEFINE] = {
> +	0xb, 0xa, 0x9, 0x8, 0x7, 0x6, 0x5, 0x4, 0x2, 0x1, 0x3, 0x0
> +};
> +
> +static int hisi_pixel_format_hal2dma(int format)
> +{
> +	int ret = 0;
> +
> +	switch (format) {
> +	case HISI_FB_PIXEL_FORMAT_RGB_565:
> +	case HISI_FB_PIXEL_FORMAT_BGR_565:
> +		ret = DMA_PIXEL_FORMAT_RGB_565;
> +		break;
> +	case HISI_FB_PIXEL_FORMAT_RGBX_4444:
> +	case HISI_FB_PIXEL_FORMAT_BGRX_4444:
> +		ret = DMA_PIXEL_FORMAT_XRGB_4444;
> +		break;
> +	case HISI_FB_PIXEL_FORMAT_RGBA_4444:
> +	case HISI_FB_PIXEL_FORMAT_BGRA_4444:
> +		ret = DMA_PIXEL_FORMAT_ARGB_4444;
> +		break;
> +	case HISI_FB_PIXEL_FORMAT_RGBX_5551:
> +	case HISI_FB_PIXEL_FORMAT_BGRX_5551:
> +		ret = DMA_PIXEL_FORMAT_XRGB_5551;
> +		break;
> +	case HISI_FB_PIXEL_FORMAT_RGBA_5551:
> +	case HISI_FB_PIXEL_FORMAT_BGRA_5551:
> +		ret = DMA_PIXEL_FORMAT_ARGB_5551;
> +		break;
> +
> +	case HISI_FB_PIXEL_FORMAT_RGBX_8888:
> +	case HISI_FB_PIXEL_FORMAT_BGRX_8888:
> +		ret = DMA_PIXEL_FORMAT_XRGB_8888;
> +		break;
> +	case HISI_FB_PIXEL_FORMAT_RGBA_8888:
> +	case HISI_FB_PIXEL_FORMAT_BGRA_8888:
> +		ret = DMA_PIXEL_FORMAT_ARGB_8888;
> +		break;
> +
> +	case HISI_FB_PIXEL_FORMAT_YUV_422_I:
> +	case HISI_FB_PIXEL_FORMAT_YUYV_422_Pkg:
> +	case HISI_FB_PIXEL_FORMAT_YVYU_422_Pkg:
> +	case HISI_FB_PIXEL_FORMAT_UYVY_422_Pkg:
> +	case HISI_FB_PIXEL_FORMAT_VYUY_422_Pkg:
> +		ret = DMA_PIXEL_FORMAT_YUYV_422_Pkg;
> +		break;
> +
> +	case HISI_FB_PIXEL_FORMAT_YCbCr_422_P:
> +	case HISI_FB_PIXEL_FORMAT_YCrCb_422_P:
> +		ret = DMA_PIXEL_FORMAT_YUV_422_P_HP;
> +		break;
> +	case HISI_FB_PIXEL_FORMAT_YCbCr_420_P:
> +	case HISI_FB_PIXEL_FORMAT_YCrCb_420_P:
> +		ret = DMA_PIXEL_FORMAT_YUV_420_P_HP;
> +		break;
> +
> +	case HISI_FB_PIXEL_FORMAT_YCbCr_422_SP:
> +	case HISI_FB_PIXEL_FORMAT_YCrCb_422_SP:
> +		ret = DMA_PIXEL_FORMAT_YUV_422_SP_HP;
> +		break;
> +	case HISI_FB_PIXEL_FORMAT_YCbCr_420_SP:
> +	case HISI_FB_PIXEL_FORMAT_YCrCb_420_SP:
> +		ret = DMA_PIXEL_FORMAT_YUV_420_SP_HP;
> +		break;
> +
> +	default:
> +		DRM_ERROR("not support format(%d)!\n", format);
> +		ret = -1;
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static int hisi_pixel_format_hal2dfc(int format)
> +{
> +	int ret = 0;
> +
> +	switch (format) {
> +	case HISI_FB_PIXEL_FORMAT_RGB_565:
> +		ret = DFC_PIXEL_FORMAT_RGB_565;
> +		break;
> +	case HISI_FB_PIXEL_FORMAT_RGBX_4444:
> +		ret = DFC_PIXEL_FORMAT_XBGR_4444;
> +		break;
> +	case HISI_FB_PIXEL_FORMAT_RGBA_4444:
> +		ret = DFC_PIXEL_FORMAT_ABGR_4444;
> +		break;
> +	case HISI_FB_PIXEL_FORMAT_RGBX_5551:
> +		ret = DFC_PIXEL_FORMAT_XBGR_5551;
> +		break;
> +	case HISI_FB_PIXEL_FORMAT_RGBA_5551:
> +		ret = DFC_PIXEL_FORMAT_ABGR_5551;
> +		break;
> +	case HISI_FB_PIXEL_FORMAT_RGBX_8888:
> +		ret = DFC_PIXEL_FORMAT_XBGR_8888;
> +		break;
> +	case HISI_FB_PIXEL_FORMAT_RGBA_8888:
> +		ret = DFC_PIXEL_FORMAT_ABGR_8888;
> +		break;
> +
> +	case HISI_FB_PIXEL_FORMAT_BGR_565:
> +		ret = DFC_PIXEL_FORMAT_BGR_565;
> +		break;
> +	case HISI_FB_PIXEL_FORMAT_BGRX_4444:
> +		ret = DFC_PIXEL_FORMAT_XRGB_4444;
> +		break;
> +	case HISI_FB_PIXEL_FORMAT_BGRA_4444:
> +		ret = DFC_PIXEL_FORMAT_ARGB_4444;
> +		break;
> +	case HISI_FB_PIXEL_FORMAT_BGRX_5551:
> +		ret = DFC_PIXEL_FORMAT_XRGB_5551;
> +		break;
> +	case HISI_FB_PIXEL_FORMAT_BGRA_5551:
> +		ret = DFC_PIXEL_FORMAT_ARGB_5551;
> +		break;
> +	case HISI_FB_PIXEL_FORMAT_BGRX_8888:
> +		ret = DFC_PIXEL_FORMAT_XRGB_8888;
> +		break;
> +	case HISI_FB_PIXEL_FORMAT_BGRA_8888:
> +		ret = DFC_PIXEL_FORMAT_ARGB_8888;
> +		break;
> +
> +	case HISI_FB_PIXEL_FORMAT_YUV_422_I:
> +	case HISI_FB_PIXEL_FORMAT_YUYV_422_Pkg:
> +		ret = DFC_PIXEL_FORMAT_YUYV422;
> +		break;
> +	case HISI_FB_PIXEL_FORMAT_YVYU_422_Pkg:
> +		ret = DFC_PIXEL_FORMAT_YVYU422;
> +		break;
> +	case HISI_FB_PIXEL_FORMAT_UYVY_422_Pkg:
> +		ret = DFC_PIXEL_FORMAT_UYVY422;
> +		break;
> +	case HISI_FB_PIXEL_FORMAT_VYUY_422_Pkg:
> +		ret = DFC_PIXEL_FORMAT_VYUY422;
> +		break;
> +
> +	case HISI_FB_PIXEL_FORMAT_YCbCr_422_SP:
> +		ret = DFC_PIXEL_FORMAT_YUYV422;
> +		break;
> +	case HISI_FB_PIXEL_FORMAT_YCrCb_422_SP:
> +		ret = DFC_PIXEL_FORMAT_YVYU422;
> +		break;
> +	case HISI_FB_PIXEL_FORMAT_YCbCr_420_SP:
> +		ret = DFC_PIXEL_FORMAT_YUYV422;
> +		break;
> +	case HISI_FB_PIXEL_FORMAT_YCrCb_420_SP:
> +		ret = DFC_PIXEL_FORMAT_YVYU422;
> +		break;
> +
> +	case HISI_FB_PIXEL_FORMAT_YCbCr_422_P:
> +	case HISI_FB_PIXEL_FORMAT_YCbCr_420_P:
> +		ret = DFC_PIXEL_FORMAT_YUYV422;
> +		break;
> +	case HISI_FB_PIXEL_FORMAT_YCrCb_422_P:
> +	case HISI_FB_PIXEL_FORMAT_YCrCb_420_P:
> +		ret = DFC_PIXEL_FORMAT_YVYU422;
> +		break;
> +
> +	default:
> +		DRM_ERROR("not support format(%d)!\n", format);
> +		ret = -1;
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static int hisi_dss_aif_ch_config(struct dss_hw_ctx *ctx, int chn_idx)
> +{
> +	void __iomem *aif0_ch_base;
> +	int mid = 0;
> +
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL!\n");
> +		return -1;
> +	}
> +
> +	mid = mid_array[chn_idx];
> +	aif0_ch_base = ctx->base + ctx->g_dss_module_base[chn_idx][MODULE_AIF0_CHN];
> +
> +	set_reg(aif0_ch_base, 0x0, 1, 0);
> +	set_reg(aif0_ch_base, (uint32_t)mid, 4, 4);
> +
> +	return 0;
> +}
> +
> +static int hisi_dss_smmu_config(struct dss_hw_ctx *ctx, int chn_idx, bool mmu_enable)
> +{
> +	void __iomem *smmu_base;
> +	u32 idx = 0, i = 0;
> +
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL!\n");
> +		return -1;
> +	}
> +
> +	smmu_base = ctx->base + ctx->smmu_offset;
> +
> +	for (i = 0; i < ctx->g_dss_chn_sid_num[chn_idx]; i++) {
> +		idx = ctx->g_dss_smmu_smrx_idx[chn_idx] + i;
> +		if (!mmu_enable) {
> +			set_reg(smmu_base + SMMU_SMRx_NS + idx * 0x4, 1, 32, 0);
> +		} else {
> +			//set_reg(smmu_base + SMMU_SMRx_NS + idx * 0x4, 0x70, 32, 0);
> +			set_reg(smmu_base + SMMU_SMRx_NS + idx * 0x4, 0x1C, 32, 0);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int hisi_dss_mif_config(struct dss_hw_ctx *ctx, int chn_idx, bool mmu_enable)
> +{
> +	void __iomem *mif_base;
> +	void __iomem *mif_ch_base;
> +
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL!\n");
> +		return -1;
> +	}
> +
> +	mif_base = ctx->base + DSS_MIF_OFFSET;
> +	mif_ch_base = ctx->base +
> +		ctx->g_dss_module_base[chn_idx][MODULE_MIF_CHN];
> +
> +	if (!mmu_enable)
> +		set_reg(mif_ch_base + MIF_CTRL1, 0x1, 1, 5);
> +	else
> +		set_reg(mif_ch_base + MIF_CTRL1, 0x00080000, 32, 0);
> +
> +	return 0;
> +}
> +
> +int hisi_dss_mctl_mutex_lock(struct dss_hw_ctx *ctx)
> +{
> +	void __iomem *mctl_base;
> +
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL!\n");
> +		return -1;
> +	}
> +
> +	mctl_base = ctx->base +
> +		ctx->g_dss_module_ovl_base[DSS_OVL0][MODULE_MCTL_BASE];
> +
> +	set_reg(mctl_base + MCTL_CTL_MUTEX, 0x1, 1, 0);
> +
> +	return 0;
> +}
> +
> +int hisi_dss_mctl_mutex_unlock(struct dss_hw_ctx *ctx)
> +{
> +	void __iomem *mctl_base;
> +
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL!\n");
> +		return -1;
> +	}
> +
> +	mctl_base = ctx->base +
> +		ctx->g_dss_module_ovl_base[DSS_OVL0][MODULE_MCTL_BASE];
> +
> +	set_reg(mctl_base + MCTL_CTL_MUTEX, 0x0, 1, 0);
> +
> +	return 0;
> +}
> +
> +static int hisi_dss_mctl_ov_config(struct dss_hw_ctx *ctx, int chn_idx)
> +{
> +	void __iomem *mctl_base;
> +	u32 mctl_rch_offset = 0;
> +
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL!\n");
> +		return -1;
> +	}
> +
> +	mctl_rch_offset = (uint32_t)(MCTL_CTL_MUTEX_RCH0 + chn_idx * 0x4);
> +
> +	mctl_base = ctx->base +
> +		ctx->g_dss_module_ovl_base[DSS_OVL0][MODULE_MCTL_BASE];
> +
> +	set_reg(mctl_base + MCTL_CTL_EN, 0x1, 32, 0);
> +	set_reg(mctl_base + MCTL_CTL_TOP, 0x2, 32, 0); /*auto mode*/
> +	set_reg(mctl_base + MCTL_CTL_DBG, 0xB13A00, 32, 0);
> +
> +	set_reg(mctl_base + mctl_rch_offset, 0x1, 32, 0);
> +	set_reg(mctl_base + MCTL_CTL_MUTEX_ITF, 0x1, 2, 0);
> +	set_reg(mctl_base + MCTL_CTL_MUTEX_DBUF, 0x1, 2, 0);
> +	set_reg(mctl_base + MCTL_CTL_MUTEX_OV, 1 << DSS_OVL0, 4, 0);
> +
> +	return 0;
> +}
> +
> +static int hisi_dss_mctl_sys_config(struct dss_hw_ctx *ctx, int chn_idx)
> +{
> +	void __iomem *mctl_sys_base;
> +
> +	u32 layer_idx = 0;
> +	u32 mctl_rch_ov_oen_offset = 0;
> +	u32 mctl_rch_flush_en_offset = 0;
> +
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL!\n");
> +		return -1;
> +	}
> +
> +	mctl_sys_base = ctx->base + DSS_MCTRL_SYS_OFFSET;
> +	mctl_rch_ov_oen_offset = MCTL_RCH0_OV_OEN + chn_idx * 0x4;
> +	mctl_rch_flush_en_offset = MCTL_RCH0_FLUSH_EN + chn_idx * 0x4;
> +
> +	set_reg(mctl_sys_base + mctl_rch_ov_oen_offset,
> +		((1 << (layer_idx + 1)) | (0x100 << DSS_OVL0)), 32, 0);
> +
> +	if (ctx->g_dss_version_tag == FB_ACCEL_KIRIN970)
> +		set_reg(mctl_sys_base + MCTL_RCH_OV0_SEL, 0xe, 4, 0);
> +	else
> +		set_reg(mctl_sys_base + MCTL_RCH_OV0_SEL, 0x8, 4, 0);
> +
> +	set_reg(mctl_sys_base + MCTL_RCH_OV0_SEL, chn_idx, 4, (layer_idx + 1) * 4);
> +
> +	set_reg(mctl_sys_base + MCTL_OV0_FLUSH_EN, 0xd, 4, 0);
> +	set_reg(mctl_sys_base + mctl_rch_flush_en_offset, 0x1, 32, 0);
> +
> +	return 0;
> +}
> +
> +static int hisi_dss_rdma_config(struct dss_hw_ctx *ctx,
> +				const struct dss_rect_ltrb *rect, u32 display_addr, u32 hal_format,
> +	u32 bpp, int chn_idx, bool afbcd, bool mmu_enable)
> +{
> +	void __iomem *rdma_base;
> +
> +	u32 aligned_pixel = 0;
> +	u32 rdma_oft_x0 = 0;
> +	u32 rdma_oft_y0 = 0;
> +	u32 rdma_oft_x1 = 0;
> +	u32 rdma_oft_y1 = 0;
> +	u32 rdma_stride = 0;
> +	u32 rdma_bpp = 0;
> +	u32 rdma_format = 0;
> +	u32 stretch_size_vrt = 0;
> +
> +	u32 stride_align = 0;
> +	u32 mm_base_0 = 0;
> +	u32 mm_base_1 = 0;
> +
> +	u32 afbcd_header_addr = 0;
> +	u32 afbcd_header_stride = 0;
> +	u32 afbcd_payload_addr = 0;
> +	u32 afbcd_payload_stride = 0;
> +
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL!\n");
> +		return -1;
> +	}
> +
> +	if (bpp == 4)
> +		rdma_bpp = 0x5;
> +	else if (bpp == 2)
> +		rdma_bpp = 0x0;
> +	else
> +		rdma_bpp = 0x0;
> +
> +	rdma_base = ctx->base +
> +		ctx->g_dss_module_base[chn_idx][MODULE_DMA];
> +
> +	aligned_pixel = DMA_ALIGN_BYTES / bpp;
> +	rdma_oft_x0 = rect->left / aligned_pixel;
> +	rdma_oft_y0 = rect->top;
> +	rdma_oft_x1 = rect->right / aligned_pixel;
> +	rdma_oft_y1 = rect->bottom;
> +
> +	rdma_format = hisi_pixel_format_hal2dma(hal_format);
> +	if (rdma_format < 0) {
> +		DRM_ERROR("layer format(%d) not support !\n", hal_format);
> +		return -EINVAL;
> +	}
> +
> +	if (afbcd) {
> +		mm_base_0 = 0;
> +		mm_base_1 = mm_base_0 + rect->right * bpp * MMBUF_LINE_NUM;
> +		mm_base_0 = ALIGN_UP(mm_base_0, MMBUF_ADDR_ALIGN);
> +		mm_base_1 = ALIGN_UP(mm_base_1, MMBUF_ADDR_ALIGN);
> +
> +		if ((((rect->right - rect->left) + 1) & (ctx->afbc_header_addr_align - 1)) ||
> +		    (((rect->bottom - rect->top) + 1) & (AFBC_BLOCK_ALIGN - 1))) {
> +			DRM_ERROR("img width(%d) is not %d bytes aligned, or img heigh(%d) is not %d bytes aligned!\n",
> +				  ((rect->right - rect->left) + 1), ctx->afbc_header_addr_align,
> +				  ((rect->bottom - rect->top) + 1), AFBC_BLOCK_ALIGN);
> +		}
> +
> +		if ((mm_base_0 & (MMBUF_ADDR_ALIGN - 1)) || (mm_base_1 & (MMBUF_ADDR_ALIGN - 1))) {
> +			DRM_ERROR("mm_base_0(0x%x) is not %d bytes aligned, or mm_base_1(0x%x) is not %d bytes aligned!\n",
> +				  mm_base_0, MMBUF_ADDR_ALIGN,
> +				  mm_base_1, MMBUF_ADDR_ALIGN);
> +		}
> +		/*header*/
> +		afbcd_header_stride = (((rect->right - rect->left) + 1) / AFBC_BLOCK_ALIGN) * AFBC_HEADER_STRIDE_BLOCK;
> +		afbcd_header_addr = (uint32_t)(unsigned long)display_addr;
> +
> +		/*payload*/
> +		if (bpp == 4)
> +			stride_align = AFBC_PAYLOAD_STRIDE_ALIGN_32;
> +		else if (bpp == 2)
> +			stride_align = AFBC_PAYLOAD_STRIDE_ALIGN_16;
> +		else
> +			DRM_ERROR("bpp(%d) not supported!\n", bpp);
> +
> +		afbcd_payload_stride = (((rect->right - rect->left) + 1) / AFBC_BLOCK_ALIGN) * stride_align;
> +
> +		afbcd_payload_addr = afbcd_header_addr + ALIGN_UP(16 * (((rect->right - rect->left) + 1) / 16) *
> +				(((rect->bottom - rect->top) + 1) / 16), 1024);
> +		afbcd_payload_addr = afbcd_payload_addr +
> +			(rect->top / AFBC_BLOCK_ALIGN) * afbcd_payload_stride +
> +			(rect->left / AFBC_BLOCK_ALIGN) * stride_align;
> +
> +		set_reg(rdma_base + CH_REG_DEFAULT, 0x1, 32, 0);
> +		set_reg(rdma_base + CH_REG_DEFAULT, 0x0, 32, 0);
> +		set_reg(rdma_base + DMA_OFT_X0, rdma_oft_x0, 12, 0);
> +		set_reg(rdma_base + DMA_OFT_Y0, rdma_oft_y0, 16, 0);
> +		set_reg(rdma_base + DMA_OFT_X1, rdma_oft_x1, 12, 0);
> +		set_reg(rdma_base + DMA_OFT_Y1, rdma_oft_y1, 16, 0);
> +		set_reg(rdma_base + DMA_STRETCH_SIZE_VRT, (rect->bottom - rect->top), 13, 0);
> +		set_reg(rdma_base + DMA_CTRL, rdma_format, 5, 3);
> +		set_reg(rdma_base + DMA_CTRL, (mmu_enable ? 0x1 : 0x0), 1, 8);
> +
> +		set_reg(rdma_base + AFBCD_HREG_PIC_WIDTH, (rect->right - rect->left), 16, 0);
> +		set_reg(rdma_base + AFBCD_HREG_PIC_HEIGHT, (rect->bottom - rect->top), 16, 0);
> +		set_reg(rdma_base + AFBCD_CTL, AFBC_HALF_BLOCK_UPPER_LOWER_ALL, 2, 6);
> +		set_reg(rdma_base + AFBCD_HREG_HDR_PTR_LO, afbcd_header_addr, 32, 0);
> +		set_reg(rdma_base + AFBCD_INPUT_HEADER_STRIDE, afbcd_header_stride, 14, 0);
> +		set_reg(rdma_base + AFBCD_PAYLOAD_STRIDE, afbcd_payload_stride, 20, 0);
> +		set_reg(rdma_base + AFBCD_MM_BASE_0, mm_base_0, 32, 0);
> +		set_reg(rdma_base + AFBCD_HREG_FORMAT, 0x1, 1, 21);
> +		set_reg(rdma_base + AFBCD_SCRAMBLE_MODE, 0x0, 32, 0);
> +		set_reg(rdma_base + AFBCD_AFBCD_PAYLOAD_POINTER, afbcd_payload_addr, 32, 0);
> +		set_reg(rdma_base + AFBCD_HEIGHT_BF_STR, (rect->bottom - rect->top), 16, 0);
> +
> +		set_reg(rdma_base + CH_CTL, 0xf005, 32, 0);
> +	} else {
> +		stretch_size_vrt = rdma_oft_y1 - rdma_oft_y0;
> +		rdma_stride = ((rect->right - rect->left) + 1) * bpp / DMA_ALIGN_BYTES;
> +
> +		set_reg(rdma_base + CH_REG_DEFAULT, 0x1, 32, 0);
> +		set_reg(rdma_base + CH_REG_DEFAULT, 0x0, 32, 0);
> +
> +		set_reg(rdma_base + DMA_OFT_X0, rdma_oft_x0, 12, 0);
> +		set_reg(rdma_base + DMA_OFT_Y0, rdma_oft_y0, 16, 0);
> +		set_reg(rdma_base + DMA_OFT_X1, rdma_oft_x1, 12, 0);
> +		set_reg(rdma_base + DMA_OFT_Y1, rdma_oft_y1, 16, 0);
> +		//set_reg(rdma_base + DMA_CTRL, rdma_format, 5, 3);
> +		//set_reg(rdma_base + DMA_CTRL, (mmu_enable ? 0x1 : 0x0), 1, 8);
> +		set_reg(rdma_base + DMA_CTRL, 0x130, 32, 0);
> +		//set_reg(rdma_base + DMA_CTRL, (mmu_enable ? 0x1 : 0x0), 1, 8);
> +		set_reg(rdma_base + DMA_STRETCH_SIZE_VRT, stretch_size_vrt, 32, 0);
> +		set_reg(rdma_base + DMA_DATA_ADDR0, display_addr, 32, 0);
> +		set_reg(rdma_base + DMA_STRIDE0, rdma_stride, 13, 0);
> +
> +		set_reg(rdma_base + CH_CTL, 0x1, 1, 0);
> +	}
> +
> +	return 0;
> +}
> +
> +static int hisi_dss_rdfc_config(struct dss_hw_ctx *ctx,
> +				const struct dss_rect_ltrb *rect,
> +				u32 hal_format, u32 bpp, int chn_idx)
> +{
> +	void __iomem *rdfc_base;
> +
> +	u32 dfc_pix_in_num = 0;
> +	u32 size_hrz = 0;
> +	u32 size_vrt = 0;
> +	u32 dfc_fmt = 0;
> +
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL!\n");
> +		return -1;
> +	}
> +
> +	rdfc_base = ctx->base +
> +		ctx->g_dss_module_base[chn_idx][MODULE_DFC];
> +
> +	dfc_pix_in_num = (bpp <= 2) ? 0x1 : 0x0;
> +	size_hrz = rect->right - rect->left;
> +	size_vrt = rect->bottom - rect->top;
> +
> +	dfc_fmt = hisi_pixel_format_hal2dfc(hal_format);
> +	if (dfc_fmt < 0) {
> +		DRM_ERROR("layer format (%d) not support !\n", hal_format);
> +		return -EINVAL;
> +	}
> +
> +	set_reg(rdfc_base + DFC_DISP_SIZE, (size_vrt | (size_hrz << 16)), 29, 0);
> +	set_reg(rdfc_base + DFC_PIX_IN_NUM, dfc_pix_in_num, 1, 0);
> +	//set_reg(rdfc_base + DFC_DISP_FMT, (bpp <= 2) ? 0x0 : 0x6, 5, 1);
> +	set_reg(rdfc_base + DFC_DISP_FMT, dfc_fmt, 5, 1);
> +	set_reg(rdfc_base + DFC_CTL_CLIP_EN, 0x1, 1, 0);
> +	set_reg(rdfc_base + DFC_ICG_MODULE, 0x1, 1, 0);
> +
> +	return 0;
> +}
> +
> +int hisi_dss_ovl_base_config(struct dss_hw_ctx *ctx, u32 xres, u32 yres)
> +{
> +	void __iomem *mctl_sys_base;
> +	void __iomem *mctl_base;
> +	void __iomem *ovl0_base;
> +
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL!\n");
> +		return -1;
> +	}
> +
> +	mctl_sys_base = ctx->base + DSS_MCTRL_SYS_OFFSET;
> +	mctl_base = ctx->base +
> +		ctx->g_dss_module_ovl_base[DSS_OVL0][MODULE_MCTL_BASE];
> +	ovl0_base = ctx->base +
> +		ctx->g_dss_module_ovl_base[DSS_OVL0][MODULE_OVL_BASE];
> +
> +	if (ctx->g_dss_version_tag == FB_ACCEL_KIRIN970) {
> +		set_reg(ovl0_base + OV8_REG_DEFAULT, 0x1, 32, 0);
> +		set_reg(ovl0_base + OV8_REG_DEFAULT, 0x0, 32, 0);
> +		set_reg(ovl0_base + OVL_SIZE, (xres - 1) |
> +			((yres - 1) << 16), 32, 0);
> +
> +		set_reg(ovl0_base + OV_BG_COLOR_RGB, 0x00000000, 32, 0);
> +		set_reg(ovl0_base + OV_BG_COLOR_A, 0x00000000, 32, 0);
> +		set_reg(ovl0_base + OV_DST_STARTPOS, 0x0, 32, 0);
> +		set_reg(ovl0_base + OV_DST_ENDPOS, (xres - 1) |
> +			((yres - 1) << 16), 32, 0);
> +		set_reg(ovl0_base + OV_GCFG, 0x10001, 32, 0);
> +		set_reg(mctl_sys_base + MCTL_RCH_OV0_SEL, 0xE, 4, 0);
> +	} else {
> +		set_reg(ovl0_base + OVL6_REG_DEFAULT, 0x1, 32, 0);
> +		set_reg(ovl0_base + OVL6_REG_DEFAULT, 0x0, 32, 0);
> +		set_reg(ovl0_base + OVL_SIZE, (xres - 1) | ((yres - 1) << 16), 32, 0);
> +		set_reg(ovl0_base + OVL_BG_COLOR, 0xFF000000, 32, 0);
> +		set_reg(ovl0_base + OVL_DST_STARTPOS, 0x0, 32, 0);
> +		set_reg(ovl0_base + OVL_DST_ENDPOS, (xres - 1) | ((yres - 1) << 16), 32, 0);
> +		set_reg(ovl0_base + OVL_GCFG, 0x10001, 32, 0);
> +		set_reg(mctl_sys_base + MCTL_RCH_OV0_SEL, 0x8, 4, 0);
> +	}
> +
> +	set_reg(mctl_base + MCTL_CTL_MUTEX_ITF, 0x1, 32, 0);
> +	set_reg(mctl_base + MCTL_CTL_MUTEX_DBUF, 0x1, 2, 0);
> +	set_reg(mctl_base + MCTL_CTL_MUTEX_OV, 1 << DSS_OVL0, 4, 0);
> +	set_reg(mctl_sys_base + MCTL_OV0_FLUSH_EN, 0xd, 4, 0);
> +
> +	return 0;
> +}
> +
> +static int hisi_dss_ovl_config(struct dss_hw_ctx *ctx,
> +			       const struct dss_rect_ltrb *rect, u32 xres, u32 yres)
> +{
> +	void __iomem *ovl0_base;
> +
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL!\n");
> +		return -1;
> +	}
> +
> +	ovl0_base = ctx->base +
> +		ctx->g_dss_module_ovl_base[DSS_OVL0][MODULE_OVL_BASE];
> +
> +	if (ctx->g_dss_version_tag == FB_ACCEL_KIRIN970) {
> +		set_reg(ovl0_base + OV8_REG_DEFAULT, 0x1, 32, 0);
> +		set_reg(ovl0_base + OV8_REG_DEFAULT, 0x0, 32, 0);
> +		set_reg(ovl0_base + OVL_SIZE, (xres - 1) |
> +			((yres - 1) << 16), 32, 0);
> +		set_reg(ovl0_base + OV_BG_COLOR_RGB, 0x3FF00000, 32, 0);
> +		set_reg(ovl0_base + OV_BG_COLOR_A, 0x3ff, 32, 0);
> +
> +		set_reg(ovl0_base + OV_DST_STARTPOS, 0x0, 32, 0);
> +		set_reg(ovl0_base + OV_DST_ENDPOS, (xres - 1) |
> +			((yres - 1) << 16), 32, 0);
> +		set_reg(ovl0_base + OV_GCFG, 0x10001, 32, 0);
> +		set_reg(ovl0_base + OV_LAYER0_POS, (rect->left) |
> +			((rect->top) << 16), 32, 0);
> +		set_reg(ovl0_base + OV_LAYER0_SIZE, (rect->right) |
> +			((rect->bottom) << 16), 32, 0);
> +		set_reg(ovl0_base + OV_LAYER0_ALPHA_MODE, 0x1004000, 32, 0);///NEED CHECK??
> +		//set_reg(ovl0_base + OV_LAYER0_ALPHA_A, 0x3fc03fc, 32, 0);
> +		set_reg(ovl0_base + OV_LAYER0_ALPHA_A, 0x3ff03ff, 32, 0);
> +		set_reg(ovl0_base + OV_LAYER0_CFG, 0x1, 1, 0);
> +	} else {
> +		set_reg(ovl0_base + OVL6_REG_DEFAULT, 0x1, 32, 0);
> +		set_reg(ovl0_base + OVL6_REG_DEFAULT, 0x0, 32, 0);
> +		set_reg(ovl0_base + OVL_SIZE, (xres - 1) |
> +			((yres - 1) << 16), 32, 0);
> +		set_reg(ovl0_base + OVL_BG_COLOR, 0xFFFF0000, 32, 0);
> +		set_reg(ovl0_base + OVL_DST_STARTPOS, 0x0, 32, 0);
> +		set_reg(ovl0_base + OVL_DST_ENDPOS, (xres - 1) |
> +			((yres - 1) << 16), 32, 0);
> +		set_reg(ovl0_base + OVL_GCFG, 0x10001, 32, 0);
> +		set_reg(ovl0_base + OVL_LAYER0_POS, (rect->left) |
> +			((rect->top) << 16), 32, 0);
> +		set_reg(ovl0_base + OVL_LAYER0_SIZE, (rect->right) |
> +			((rect->bottom) << 16), 32, 0);
> +		set_reg(ovl0_base + OVL_LAYER0_ALPHA, 0x00ff40ff, 32, 0);
> +		set_reg(ovl0_base + OVL_LAYER0_CFG, 0x1, 1, 0);
> +	}
> +
> +	return 0;
> +}
> +
> +static void hisi_dss_qos_on(struct dss_hw_ctx *ctx)
> +{
> +	char __iomem *noc_dss_base;
> +
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL!\n");
> +		return;
> +	}
> +
> +	noc_dss_base = ctx->noc_dss_base;
> +
> +	writel(0x2, noc_dss_base + 0xc);
> +	writel(0x2, noc_dss_base + 0x8c);
> +	writel(0x2, noc_dss_base + 0x10c);
> +	writel(0x2, noc_dss_base + 0x18c);
> +}
> +
> +static void hisi_dss_mif_on(struct dss_hw_ctx *ctx)
> +{
> +	char __iomem *dss_base;
> +	char __iomem *mif_base;
> +
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL!\n");
> +		return;
> +	}
> +
> +	dss_base = ctx->base;
> +	mif_base = ctx->base + DSS_MIF_OFFSET;
> +
> +	set_reg(mif_base + MIF_ENABLE, 0x1, 1, 0);
> +	set_reg(dss_base + MIF_CH0_OFFSET + MIF_CTRL0, 0x1, 1, 0);
> +	set_reg(dss_base + MIF_CH1_OFFSET + MIF_CTRL0, 0x1, 1, 0);
> +	set_reg(dss_base + MIF_CH2_OFFSET + MIF_CTRL0, 0x1, 1, 0);
> +	set_reg(dss_base + MIF_CH3_OFFSET + MIF_CTRL0, 0x1, 1, 0);
> +	set_reg(dss_base + MIF_CH4_OFFSET + MIF_CTRL0, 0x1, 1, 0);
> +	set_reg(dss_base + MIF_CH5_OFFSET + MIF_CTRL0, 0x1, 1, 0);
> +	set_reg(dss_base + MIF_CH6_OFFSET + MIF_CTRL0, 0x1, 1, 0);
> +	set_reg(dss_base + MIF_CH7_OFFSET + MIF_CTRL0, 0x1, 1, 0);
> +	set_reg(dss_base + MIF_CH8_OFFSET + MIF_CTRL0, 0x1, 1, 0);
> +	set_reg(dss_base + MIF_CH9_OFFSET + MIF_CTRL0, 0x1, 1, 0);
> +
> +	set_reg(dss_base + MIF_CH10_OFFSET + MIF_CTRL0, 0x1, 1, 0);
> +	set_reg(dss_base + MIF_CH11_OFFSET + MIF_CTRL0, 0x1, 1, 0);
> +}
> +
> +
> +void hisi_dss_smmu_on(struct dss_hw_ctx *ctx)
> +{
> +#if 0
> +/*
> + * FIXME:
> + *
> + * Right now, the IOMMU support is actually disabled. See the caller of
> + * hisi_dss_smmu_config(). Yet, if we end enabling it, this should be
> + * ported to use io-pgtable directly.
> + */
> +	void __iomem *smmu_base;
> +	struct iommu_domain_data *domain_data = NULL;
> +	u32 phy_pgd_base = 0;
> +	u64 fama_phy_pgd_base;
> +
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL!\n");
> +		return;
> +	}
> +
> +	smmu_base = ctx->base + ctx->smmu_offset;
> +
> +	set_reg(smmu_base + SMMU_SCR, 0x0, 1, 0);  /*global bypass cancel*/
> +	set_reg(smmu_base + SMMU_SCR, 0x1, 8, 20); /*ptw_mid*/
> +	set_reg(smmu_base + SMMU_SCR, 0xf, 4, 16); /*pwt_pf*/
> +	set_reg(smmu_base + SMMU_SCR, 0x7, 3, 3);  /*interrupt cachel1 cach3l2 en*/
> +	set_reg(smmu_base + SMMU_LP_CTRL, 0x1, 1, 0);  /*auto_clk_gt_en*/
> +
> +	/*Long Descriptor*/
> +	set_reg(smmu_base + SMMU_CB_TTBCR, 0x1, 1, 0);
> +
> +	set_reg(smmu_base + SMMU_ERR_RDADDR, 0x7FF00000, 32, 0);
> +	set_reg(smmu_base + SMMU_ERR_WRADDR, 0x7FFF0000, 32, 0);
> +
> +	/*disable cmdlist, dbg, reload*/
> +	set_reg(smmu_base + SMMU_RLD_EN0_NS, DSS_SMMU_RLD_EN0_DEFAULT_VAL, 32, 0);
> +	set_reg(smmu_base + SMMU_RLD_EN1_NS, DSS_SMMU_RLD_EN1_DEFAULT_VAL, 32, 0);
> +
> +	/*cmdlist stream bypass*/
> +	set_reg(smmu_base + SMMU_SMRx_NS + 36 * 0x4, 0x1, 32, 0); /*debug stream id*/
> +	set_reg(smmu_base + SMMU_SMRx_NS + 37 * 0x4, 0x1, 32, 0); /*cmd unsec stream id*/
> +	set_reg(smmu_base + SMMU_SMRx_NS + 38 * 0x4, 0x1, 32, 0); /*cmd sec stream id*/
> +
> +	/*TTBR0*/
> +	domain_data = (struct iommu_domain_data *)(ctx->mmu_domain->priv);
> +	fama_phy_pgd_base = domain_data->phy_pgd_base;
> +	phy_pgd_base = (uint32_t)(domain_data->phy_pgd_base);
> +	DRM_DEBUG("fama_phy_pgd_base = %llu, phy_pgd_base =0x%x \n", fama_phy_pgd_base, phy_pgd_base);
> +	set_reg(smmu_base + SMMU_CB_TTBR0, phy_pgd_base, 32, 0);
> +#endif
> +}
> +
> +void hisifb_dss_on(struct dss_hw_ctx *ctx)
> +{
> +	/* dss qos on*/
> +	hisi_dss_qos_on(ctx);
> +	/* mif on*/
> +	hisi_dss_mif_on(ctx);
> +	/* smmu on*/
> +	hisi_dss_smmu_on(ctx);
> +}
> +
> +void hisi_dss_mctl_on(struct dss_hw_ctx *ctx)
> +{
> +	char __iomem *mctl_base = NULL;
> +	char __iomem *mctl_sys_base = NULL;
> +
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL!\n");
> +		return;
> +	}
> +	mctl_base = ctx->base +
> +		ctx->g_dss_module_ovl_base[DSS_MCTL0][MODULE_MCTL_BASE];
> +	mctl_sys_base = ctx->base + DSS_MCTRL_SYS_OFFSET;
> +
> +	set_reg(mctl_base + MCTL_CTL_EN, 0x1, 32, 0);
> +	set_reg(mctl_base + MCTL_CTL_MUTEX_ITF, 0x1, 32, 0);
> +	set_reg(mctl_base + MCTL_CTL_DBG, 0xB13A00, 32, 0);
> +	set_reg(mctl_base + MCTL_CTL_TOP, 0x2, 32, 0);
> +}
> +
> +void hisi_dss_unflow_handler(struct dss_hw_ctx *ctx, bool unmask)
> +{
> +	void __iomem *dss_base;
> +	u32 tmp = 0;
> +
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL!\n");
> +		return;
> +	}
> +
> +	dss_base = ctx->base;
> +
> +	tmp = readl(dss_base + DSS_LDI0_OFFSET + LDI_CPU_ITF_INT_MSK);
> +	if (unmask)
> +		tmp &= ~BIT_LDI_UNFLOW;
> +	else
> +		tmp |= BIT_LDI_UNFLOW;
> +
> +	writel(tmp, dss_base + DSS_LDI0_OFFSET + LDI_CPU_ITF_INT_MSK);
> +}
> +
> +void hisifb_mctl_sw_clr(struct dss_crtc *acrtc)
> +{
> +	char __iomem *mctl_base = NULL;
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +	int mctl_status;
> +	int delay_count = 0;
> +	bool is_timeout;
> +
> +	DRM_INFO("+.\n");
> +	if (!ctx) {
> +		DRM_ERROR("ctx is NULL!\n");
> +		return;
> +	}
> +
> +	mctl_base = ctx->base +
> +		ctx->g_dss_module_ovl_base[DSS_MCTL0][MODULE_MCTL_BASE];
> +
> +	if (mctl_base)
> +		set_reg(mctl_base + MCTL_CTL_CLEAR, 0x1, 1, 0);
> +
> +	while (1) {
> +		mctl_status = readl(mctl_base + MCTL_CTL_STATUS);
> +		if (((mctl_status & 0x10) == 0) || (delay_count > 500)) {
> +			is_timeout = (delay_count > 100) ? true : false;
> +			delay_count = 0;
> +			break;
> +		}
> +
> +		udelay(1);
> +		++delay_count;
> +	}
> +
> +	if (is_timeout)
> +		DRM_ERROR("mctl_status =0x%x !\n", mctl_status);
> +
> +	enable_ldi(acrtc);
> +	DRM_INFO("-.\n");
> +}
> +
> +static int hisi_dss_wait_for_complete(struct dss_crtc *acrtc)
> +{
> +	int ret = 0;
> +	u32 times = 0;
> +	u32 prev_vactive0_end = 0;
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +
> +	prev_vactive0_end = ctx->vactive0_end_flag;
> +
> +REDO:
lower capital labels

> +	ret = wait_event_interruptible_timeout(ctx->vactive0_end_wq,
> +					       (prev_vactive0_end != ctx->vactive0_end_flag),
> +		msecs_to_jiffies(300));
> +	if (ret == -ERESTARTSYS) {
> +		if (times < 50) {
> +			times++;
> +			mdelay(10);
> +			goto REDO;
> +		}
> +	}
> +
> +	if (ret <= 0) {
> +		disable_ldi(acrtc);
> +		hisifb_mctl_sw_clr(acrtc);
> +		DRM_ERROR("wait_for vactive0_end_flag timeout! ret=%d.\n", ret);
> +
> +		ret = -ETIMEDOUT;
> +	} else {
> +		ret = 0;
> +	}
> +
> +	return ret;
> +}
> +
> +void hisi_fb_pan_display(struct drm_plane *plane)
> +{
> +	struct drm_plane_state *state = plane->state;
> +	struct drm_framebuffer *fb = state->fb;
> +	struct drm_display_mode *mode;
> +	struct drm_display_mode *adj_mode;
> +
> +	struct dss_plane *aplane = to_dss_plane(plane);
> +	struct dss_crtc *acrtc = aplane->acrtc;
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +
> +	struct drm_gem_cma_object *obj = drm_fb_cma_get_gem_obj(state->fb, 0);
> +
> +	bool afbcd = false;
> +	bool mmu_enable = false;
> +	struct dss_rect_ltrb rect;
> +	u32 bpp;
> +	u32 stride;
> +	u32 display_addr = 0;
> +	u32 hal_fmt;
> +	int chn_idx = DSS_RCHN_D2;
> +
> +	int crtc_x = state->crtc_x;
> +	int crtc_y = state->crtc_y;
> +	unsigned int crtc_w = state->crtc_w;
> +	unsigned int crtc_h = state->crtc_h;
> +	u32 src_x = state->src_x >> 16;
> +	u32 src_y = state->src_y >> 16;
> +	u32 src_w = state->src_w >> 16;
> +	u32 src_h = state->src_h >> 16;
> +
> +	u32 hfp, hbp, hsw, vfp, vbp, vsw;
> +
> +	mode = &acrtc->base.state->mode;
> +	adj_mode = &acrtc->base.state->adjusted_mode;
> +
> +	bpp = fb->format->cpp[0];
> +	stride = fb->pitches[0];
> +
> +	display_addr = (u32)obj->paddr + src_y * stride;
> +
> +	rect.left = 0;
> +	rect.right = src_w - 1;
> +	rect.top = 0;
> +	rect.bottom = src_h - 1;
> +	hal_fmt = HISI_FB_PIXEL_FORMAT_BGRA_8888;//dss_get_format(fb->pixel_format);
> +
> +	DRM_DEBUG_DRIVER("channel%d: src:(%d,%d, %dx%d) crtc:(%d,%d, %dx%d), rect(%d,%d,%d,%d),fb:%dx%d, pixel_format=%d, stride=%d, paddr=0x%x, bpp=%d.\n",
> +			 chn_idx, src_x, src_y, src_w, src_h,
> +			 crtc_x, crtc_y, crtc_w, crtc_h,
> +			 rect.left, rect.top, rect.right, rect.bottom,
> +			 fb->width, fb->height, hal_fmt,
> +			 stride, display_addr, bpp);
> +
> +	hfp = mode->hsync_start - mode->hdisplay;
> +	hbp = mode->htotal - mode->hsync_end;
> +	hsw = mode->hsync_end - mode->hsync_start;
> +	vfp = mode->vsync_start - mode->vdisplay;
> +	vbp = mode->vtotal - mode->vsync_end;
> +	vsw = mode->vsync_end - mode->vsync_start;
> +
> +	hisi_dss_mctl_mutex_lock(ctx);
> +	hisi_dss_aif_ch_config(ctx, chn_idx);
> +	hisi_dss_mif_config(ctx, chn_idx, mmu_enable);
> +	hisi_dss_smmu_config(ctx, chn_idx, mmu_enable);
> +
> +	hisi_dss_rdma_config(ctx, &rect, display_addr, hal_fmt, bpp, chn_idx, afbcd, mmu_enable);
> +	hisi_dss_rdfc_config(ctx, &rect, hal_fmt, bpp, chn_idx);
> +	hisi_dss_ovl_config(ctx, &rect, mode->hdisplay, mode->vdisplay);
> +
> +	hisi_dss_mctl_ov_config(ctx, chn_idx);
> +	hisi_dss_mctl_sys_config(ctx, chn_idx);
> +	hisi_dss_mctl_mutex_unlock(ctx);
> +	hisi_dss_unflow_handler(ctx, true);
> +
> +	enable_ldi(acrtc);
> +	hisi_dss_wait_for_complete(acrtc);
> +}
> +
> +void hisi_dss_online_play(struct kirin_fbdev *fbdev, struct drm_plane *plane,
> +			  struct drm_dss_layer *layer)
No callers of this function?


> +{
> +	struct drm_plane_state *state = plane->state;
> +	struct drm_display_mode *mode;
> +	struct drm_display_mode *adj_mode;
> +
> +	struct dss_plane *aplane = to_dss_plane(plane);
> +	struct dss_crtc *acrtc = aplane->acrtc;
> +	struct dss_hw_ctx *ctx = acrtc->ctx;
> +
> +	bool afbcd = false;
> +	bool mmu_enable = false;
> +	struct dss_rect_ltrb rect;
> +	u32 bpp;
> +	u32 stride;
> +	u32 display_addr;
> +
> +	int chn_idx = DSS_RCHN_D2;
> +	u32 hal_fmt = 0;
> +	u32 src_w = state->src_w >> 16;
> +	u32 src_h = state->src_h >> 16;
> +
> +	u32 hfp, hbp, hsw, vfp, vbp, vsw;
> +
> +	mode = &acrtc->base.state->mode;
> +	adj_mode = &acrtc->base.state->adjusted_mode;
> +
> +	bpp = layer->img.bpp;
> +	stride = layer->img.stride;
> +
> +	display_addr = layer->img.vir_addr;
> +	hal_fmt = HISI_FB_PIXEL_FORMAT_RGBA_8888;//layer->img.format;
> +
> +	rect.left = 0;
> +	rect.right = src_w - 1;
> +	rect.top = 0;
> +	rect.bottom = src_h - 1;
> +
> +	DRM_DEBUG("channel%d: src:(%dx%d) rect(%d,%d,%d,%d),pixel_format=%d, stride=%d, paddr=0x%x, bpp=%d.\n",
> +		  chn_idx, src_w, src_h,
> +		  rect.left, rect.top, rect.right, rect.bottom,
> +		  hal_fmt, stride, display_addr, bpp);
> +
> +	hfp = mode->hsync_start - mode->hdisplay;
> +	hbp = mode->htotal - mode->hsync_end;
> +	hsw = mode->hsync_end - mode->hsync_start;
> +	vfp = mode->vsync_start - mode->vdisplay;
> +	vbp = mode->vtotal - mode->vsync_end;
> +	vsw = mode->vsync_end - mode->vsync_start;
> +
> +	hisi_dss_mctl_mutex_lock(ctx);
> +	hisi_dss_aif_ch_config(ctx, chn_idx);
> +	hisi_dss_mif_config(ctx, chn_idx, mmu_enable);
> +	hisi_dss_smmu_config(ctx, chn_idx, mmu_enable);
> +
> +	hisi_dss_rdma_config(ctx, &rect, display_addr, hal_fmt, bpp, chn_idx, afbcd, mmu_enable);
> +	hisi_dss_rdfc_config(ctx, &rect, hal_fmt, bpp, chn_idx);
> +	hisi_dss_ovl_config(ctx, &rect, src_w, src_h);
> +
> +	hisi_dss_mctl_ov_config(ctx, chn_idx);
> +	hisi_dss_mctl_sys_config(ctx, chn_idx);
> +	hisi_dss_mctl_mutex_unlock(ctx);
> +	hisi_dss_unflow_handler(ctx, true);
> +
> +	enable_ldi(acrtc);
> +	hisi_dss_wait_for_complete(acrtc);
> +}
> diff --git a/drivers/staging/hikey9xx/gpu/kirin9xx_dw_drm_dsi.c b/drivers/staging/hikey9xx/gpu/kirin9xx_dw_drm_dsi.c
> new file mode 100644
> index 000000000000..49f4b1b9151d
> --- /dev/null
> +++ b/drivers/staging/hikey9xx/gpu/kirin9xx_dw_drm_dsi.c
> @@ -0,0 +1,2132 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * DesignWare MIPI DSI Host Controller v1.02 driver
> + *
> + * Copyright (c) 2016 Linaro Limited.
> + * Copyright (c) 2014-2016 Hisilicon Limited.
> + *
> + * Author:
> + *	<shizongxuan@huawei.com>
> + *	<zhangxiubin@huawei.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/component.h>
> +#include <linux/of_device.h>
> +#include <linux/of_graph.h>
> +#include <linux/iopoll.h>
> +#include <video/mipi_display.h>
> +#include <linux/gpio/consumer.h>
> +#include <linux/of_address.h>
> +
> +#include <drm/drm_of.h>
> +#include <drm/drm_crtc_helper.h>
> +#include <drm/drm_mipi_dsi.h>
> +#include <drm/drm_encoder.h>
> +#include <drm/drm_device.h>
> +#include <drm/drm_atomic_helper.h>
> +#include <drm/drm_panel.h>
> +#include <drm/drm_probe_helper.h>
> +
> +#include "kirin9xx_dw_dsi_reg.h"
> +#include "kirin9xx_dpe.h"
> +#include "kirin9xx_drm_drv.h"
> +#include "kirin9xx_drm_dpe_utils.h"
> +
> +#define ROUND(x, y)		((x) / (y) + \
> +				((x) % (y) * 10 / (y) >= 5 ? 1 : 0))
> +#define ROUND1(x, y)	((x) / (y) + ((x) % (y)  ? 1 : 0))
Use generic macros for this?


> +#define PHY_REF_CLK_RATE	19200000
> +#define PHY_REF_CLK_PERIOD_PS	(1000000000 / (PHY_REF_CLK_RATE / 1000))
> +
> +#define encoder_to_dsi(encoder) \
> +	container_of(encoder, struct dw_dsi, encoder)
> +#define host_to_dsi(host) \
> +	container_of(host, struct dw_dsi, host)
> +#define connector_to_dsi(connector) \
> +	container_of(connector, struct dw_dsi, connector)
> +#define DSS_REDUCE(x)	((x) > 0 ? ((x) - 1) : (x))
Use generic macros for this?
> +
> +enum dsi_output_client {
> +	OUT_HDMI = 0,
> +	OUT_PANEL,
> +	OUT_MAX
> +};
> +
> +struct mipi_phy_params {
> +	u64 lane_byte_clk;
> +	u32 clk_division;
> +
> +	u32 clk_lane_lp2hs_time;
> +	u32 clk_lane_hs2lp_time;
> +	u32 data_lane_lp2hs_time;
> +	u32 data_lane_hs2lp_time;
> +	u32 clk2data_delay;
> +	u32 data2clk_delay;
> +
> +	u32 clk_pre_delay;
> +	u32 clk_post_delay;
> +	u32 clk_t_lpx;
> +	u32 clk_t_hs_prepare;
> +	u32 clk_t_hs_zero;
> +	u32 clk_t_hs_trial;
> +	u32 clk_t_wakeup;
> +	u32 data_pre_delay;
> +	u32 data_post_delay;
> +	u32 data_t_lpx;
> +	u32 data_t_hs_prepare;
> +	u32 data_t_hs_zero;
> +	u32 data_t_hs_trial;
> +	u32 data_t_ta_go;
> +	u32 data_t_ta_get;
> +	u32 data_t_wakeup;
> +
> +	u32 phy_stop_wait_time;
> +
> +	u32 rg_vrefsel_vcm;
> +	u32 rg_hstx_ckg_sel;
> +	u32 rg_pll_fbd_div5f;
> +	u32 rg_pll_fbd_div1f;
> +	u32 rg_pll_fbd_2p;
> +	u32 rg_pll_enbwt;
> +	u32 rg_pll_fbd_p;
> +	u32 rg_pll_fbd_s;
> +	u32 rg_pll_pre_div1p;
> +	u32 rg_pll_pre_p;
> +	u32 rg_pll_vco_750m;
> +	u32 rg_pll_lpf_rs;
> +	u32 rg_pll_lpf_cs;
> +	u32 rg_pll_enswc;
> +	u32 rg_pll_chp;
> +
> +	u32 pll_register_override;		/*0x1E[0]*/
> +	u32 pll_power_down;			/*0x1E[1]*/
> +	u32 rg_band_sel;				/*0x1E[2]*/
> +	u32 rg_phase_gen_en;		/*0x1E[3]*/
> +	u32 reload_sel;				/*0x1E[4]*/
> +	u32 rg_pll_cp_p;				/*0x1E[7:5]*/
> +	u32 rg_pll_refsel;				/*0x16[1:0]*/
> +	u32 rg_pll_cp;				/*0x16[7:5]*/
> +	u32 load_command;
> +
> +	// for CDPHY
> +	u32 rg_cphy_div;	//Q
> +	u32 rg_div;		//M 0x4A[7:0]
> +	u32 rg_pre_div;	//N 0x49[0]
> +	u32 rg_320m;		//0x48[2]
> +	u32 rg_2p5g;		//0x48[1]
> +	u32 rg_0p8v;		//0x48[0]
> +	u32 rg_lpf_r;		//0x46[5:4]
> +	u32 rg_cp;			//0x46[3:0]
> +	u32 t_prepare;
> +	u32 t_lpx;
> +	u32 t_prebegin;
> +	u32 t_post;
> +};
> +
> +struct dsi_hw_ctx {
> +	void __iomem *base;
> +	char __iomem *peri_crg_base;
> +	void __iomem *pctrl_base;
> +
> +	u32 g_dss_version_tag;
> +
> +	struct clk *dss_dphy0_ref_clk;
> +	struct clk *dss_dphy1_ref_clk;
> +	struct clk *dss_dphy0_cfg_clk;
> +	struct clk *dss_dphy1_cfg_clk;
> +	struct clk *dss_pclk_dsi0_clk;
> +	struct clk *dss_pclk_dsi1_clk;
> +};
> +
> +struct dw_dsi_client {
> +	u32 lanes;
> +	u32 phy_clock; /* in kHz */
> +	enum mipi_dsi_pixel_format format;
> +	unsigned long mode_flags;
> +};
> +

Can the panel stuff be moved out and utilise drm_panel?
> +struct mipi_panel_info {
> +	u8 dsi_version;
> +	u8 vc;
> +	u8 lane_nums;
> +	u8 lane_nums_select_support;
> +	u8 color_mode;
> +	u32 dsi_bit_clk; /* clock lane(p/n) */
> +	u32 burst_mode;
> +	u32 max_tx_esc_clk;
> +	u8 non_continue_en;
> +
> +	u32 dsi_bit_clk_val1;
> +	u32 dsi_bit_clk_val2;
> +	u32 dsi_bit_clk_val3;
> +	u32 dsi_bit_clk_val4;
> +	u32 dsi_bit_clk_val5;
> +	u32 dsi_bit_clk_upt;
> +	/*uint32_t dsi_pclk_rate;*/
> +
> +	u32 hs_wr_to_time;
> +
> +	/* dphy config parameter adjust*/
> +	u32 clk_post_adjust;
> +	u32 clk_pre_adjust;
> +	u32 clk_pre_delay_adjust;
> +	u32 clk_t_hs_exit_adjust;
> +	u32 clk_t_hs_trial_adjust;
> +	u32 clk_t_hs_prepare_adjust;
> +	int clk_t_lpx_adjust;
> +	u32 clk_t_hs_zero_adjust;
> +	u32 data_post_delay_adjust;
> +	int data_t_lpx_adjust;
> +	u32 data_t_hs_prepare_adjust;
> +	u32 data_t_hs_zero_adjust;
> +	u32 data_t_hs_trial_adjust;
> +	u32 rg_vrefsel_vcm_adjust;
> +
> +	/*only for Chicago<3660> use*/
> +	u32 rg_vrefsel_vcm_clk_adjust;
> +	u32 rg_vrefsel_vcm_data_adjust;
> +
> +	u32 phy_mode;  //0: DPHY, 1:CPHY
> +	u32 lp11_flag;
> +};
> +
> +struct ldi_panel_info {
> +	u32 h_back_porch;
> +	u32 h_front_porch;
> +	u32 h_pulse_width;
> +
> +	/*
> +	 * note: vbp > 8 if used overlay compose,
> +	 * also lcd vbp > 8 in lcd power on sequence
> +	 */
> +	u32 v_back_porch;
> +	u32 v_front_porch;
> +	u32 v_pulse_width;
> +
> +	u8 hsync_plr;
> +	u8 vsync_plr;
> +	u8 pixelclk_plr;
> +	u8 data_en_plr;
> +
> +	/* for cabc */
> +	u8 dpi0_overlap_size;
> +	u8 dpi1_overlap_size;
> +};
Looks like drm_display_mode + a little more.

> +
> +struct dw_dsi {
> +	struct drm_encoder encoder;
> +	struct drm_bridge *bridge;
> +	struct drm_panel *panel;
> +	struct mipi_dsi_host host;
> +	struct drm_connector connector; /* connector for panel */
> +	struct drm_display_mode cur_mode;
> +	struct dsi_hw_ctx *ctx;
> +	struct mipi_phy_params phy;
> +	struct mipi_panel_info mipi;
> +	struct ldi_panel_info ldi;
> +	u32 lanes;
> +	enum mipi_dsi_pixel_format format;
> +	unsigned long mode_flags;
> +	struct gpio_desc *gpio_mux;
> +	struct dw_dsi_client client[OUT_MAX];
> +	enum dsi_output_client cur_client, attached_client;
> +	bool enable;
> +};
This smells like a bridge driver.
Bridge drivers shall use the bridge panel.
And new bridge drivers shall not create conectors, thats the role of the
display driver.

> +
> +struct dsi_data {
> +	struct dw_dsi dsi;
> +	struct dsi_hw_ctx ctx;
> +};
> +
> +struct dsi_phy_range {
> +	u32 min_range_kHz;
> +	u32 max_range_kHz;
> +	u32 pll_vco_750M;
> +	u32 hstx_ckg_sel;
> +};
> +
> +static const struct dsi_phy_range dphy_range_info[] = {
> +	{   46875,    62500,   1,    7 },
> +	{   62500,    93750,   0,    7 },
> +	{   93750,   125000,   1,    6 },
> +	{  125000,   187500,   0,    6 },
> +	{  187500,   250000,   1,    5 },
> +	{  250000,   375000,   0,    5 },
> +	{  375000,   500000,   1,    4 },
> +	{  500000,   750000,   0,    4 },
> +	{  750000,  1000000,   1,    0 },
> +	{ 1000000,  1500000,   0,    0 }
> +};
> +
> +/*
> + * Except for debug, this is identical to the one defined at
> + * kirin9xx_drm_dpe_utils.h.
> + */
> +
> +void dsi_set_output_client(struct drm_device *dev)
> +{
> +	struct drm_connector_list_iter conn_iter;
> +	struct drm_connector *connector;
> +	enum dsi_output_client client;
> +	struct drm_encoder *encoder;
> +	struct dw_dsi *dsi;
> +
> +	mutex_lock(&dev->mode_config.mutex);
> +
> +	/* find dsi encoder */
> +	drm_for_each_encoder(encoder, dev)
> +		if (encoder->encoder_type == DRM_MODE_ENCODER_DSI)
> +			break;
> +	dsi = encoder_to_dsi(encoder);
> +
> +	/* find HDMI connector */
> +	drm_connector_list_iter_begin(dev, &conn_iter);
> +	drm_for_each_connector_iter(connector, &conn_iter)
> +		if (connector->connector_type == DRM_MODE_CONNECTOR_HDMIA)
> +			break;
> +
> +	/*
> +	 * set the proper dsi output client
> +	 */
> +	client = connector->status == connector_status_connected ?
> +		OUT_HDMI : OUT_PANEL;
> +
> +	if (client != dsi->cur_client) {
> +		gpiod_set_value_cansleep(dsi->gpio_mux, client);
> +		dsi->cur_client = client;
> +
> +		msleep(20);
> +
> +		DRM_INFO("client change to %s\n", client == OUT_HDMI ?
> +				 "HDMI" : "panel");
> +	}
> +
> +	mutex_unlock(&dev->mode_config.mutex);
> +}
> +EXPORT_SYMBOL(dsi_set_output_client);
> +
> +static void kirin970_get_dsi_dphy_ctrl(struct dw_dsi *dsi,
> +				       struct mipi_phy_params *phy_ctrl, u32 id)
> +{
> +	struct mipi_panel_info *mipi = NULL;
> +	struct drm_display_mode *mode = NULL;
> +	u32 dphy_req_kHz;
> +	int bpp;
> +	u32 ui = 0;
> +	u32 m_pll = 0;
> +	u32 n_pll = 0;
> +	u64 lane_clock = 0;
> +	u64 vco_div = 1;
> +	u32 m_n_fract = 0;
> +	u32 m_n_int = 0;
> +
> +	u32 accuracy = 0;
> +	u32 unit_tx_byte_clk_hs = 0;
> +	u32 clk_post = 0;
> +	u32 clk_pre = 0;
> +	u32 clk_t_hs_exit = 0;
> +	u32 clk_pre_delay = 0;
> +	u32 clk_t_hs_prepare = 0;
> +	u32 clk_t_lpx = 0;
> +	u32 clk_t_hs_zero = 0;
> +	u32 clk_t_hs_trial = 0;
> +	u32 data_post_delay = 0;
> +	u32 data_t_hs_prepare = 0;
> +	u32 data_t_hs_zero = 0;
> +	u32 data_t_hs_trial = 0;
> +	u32 data_t_lpx = 0;
> +
> +	WARN_ON(!phy_ctrl);
> +	WARN_ON(!dsi);
> +
> +	mode = &dsi->cur_mode;
> +	mipi = &dsi->mipi;
> +
> +	/*
> +	 * count phy params
> +	 */
> +	bpp = mipi_dsi_pixel_format_to_bpp(dsi->client[id].format);
> +	if (bpp < 0)
> +		return;
> +
> +	if (mode->clock > 80000)
> +		dsi->client[id].lanes = 4;
> +	else
> +		dsi->client[id].lanes = 3;
> +
> +	if (dsi->client[id].phy_clock)
> +		dphy_req_kHz = dsi->client[id].phy_clock;
> +	else
> +		dphy_req_kHz = mode->clock * bpp / dsi->client[id].lanes;
> +
> +	lane_clock = dphy_req_kHz / 1000;
> +	DRM_INFO("Expected : lane_clock = %llu M\n", lane_clock);
> +
> +	/************************  PLL parameters config  *********************/
> +	//chip spec :
> +	//If the output data rate is below 320 Mbps, RG_BNAD_SEL should be set to 1.
> +	//At this mode a post divider of 1/4 will be applied to VCO.
> +	if ((lane_clock >= 320) && (lane_clock <= 2500)) {
> +		phy_ctrl->rg_band_sel = 0;
> +		vco_div = 1;
> +	} else if ((lane_clock >= 80) && (lane_clock < 320)) {
> +		phy_ctrl->rg_band_sel = 1;
> +		vco_div = 4;
> +	} else {
> +		DRM_ERROR("80M <= lane_clock< = 2500M, not support lane_clock = %llu M.\n",
> +			  lane_clock);
> +	}
> +
> +	m_n_int = lane_clock * vco_div * 1000000UL / DEFAULT_MIPI_CLK_RATE;
> +	m_n_fract = ((lane_clock * vco_div * 1000000UL * 1000UL / DEFAULT_MIPI_CLK_RATE) % 1000) * 10 / 1000;
> +
> +	n_pll = 2;
> +
> +	m_pll = (u32)(lane_clock * vco_div * n_pll * 1000000UL / DEFAULT_MIPI_CLK_RATE);
> +
> +	lane_clock = m_pll * (DEFAULT_MIPI_CLK_RATE / n_pll) / vco_div;
> +	if (lane_clock > 750000000)
> +		phy_ctrl->rg_cp = 3;
> +	else if ((lane_clock >= 80000000) && (lane_clock <= 750000000))
> +		phy_ctrl->rg_cp = 1;
> +	else
> +		DRM_ERROR("80M <= lane_clock< = 2500M, not support lane_clock = %llu M.\n",
> +			  lane_clock);
> +
> +	//chip spec :
> +	phy_ctrl->rg_pre_div = n_pll - 1;
> +	phy_ctrl->rg_div = m_pll;
> +	phy_ctrl->rg_0p8v = 0;
> +	phy_ctrl->rg_2p5g = 1;
> +	phy_ctrl->rg_320m = 0;
> +	phy_ctrl->rg_lpf_r = 0;
> +
> +	//TO DO HSTX select VCM VREF
> +	phy_ctrl->rg_vrefsel_vcm = 0x5d;
> +
> +	/********************  clock/data lane parameters config  ******************/
> +	accuracy = 10;
> +	ui =  (u32)(10 * 1000000000UL * accuracy / lane_clock);
> +	//unit of measurement
> +	unit_tx_byte_clk_hs = 8 * ui;
> +
> +	// D-PHY Specification : 60ns + 52*UI <= clk_post
> +	clk_post = 600 * accuracy + 52 * ui + unit_tx_byte_clk_hs + mipi->clk_post_adjust * ui;
> +
> +	// D-PHY Specification : clk_pre >= 8*UI
> +	clk_pre = 8 * ui + unit_tx_byte_clk_hs + mipi->clk_pre_adjust * ui;
> +
> +	// D-PHY Specification : clk_t_hs_exit >= 100ns
> +	clk_t_hs_exit = 1000 * accuracy + 100 * accuracy + mipi->clk_t_hs_exit_adjust * ui;
> +
> +	// clocked by TXBYTECLKHS
> +	clk_pre_delay = 0 + mipi->clk_pre_delay_adjust * ui;
> +
> +	// D-PHY Specification : clk_t_hs_trial >= 60ns
> +	// clocked by TXBYTECLKHS
> +	clk_t_hs_trial = 600 * accuracy + 3 * unit_tx_byte_clk_hs + mipi->clk_t_hs_trial_adjust * ui;
> +
> +	// D-PHY Specification : 38ns <= clk_t_hs_prepare <= 95ns
> +	// clocked by TXBYTECLKHS
> +	clk_t_hs_prepare = 660 * accuracy;
> +
> +	// clocked by TXBYTECLKHS
> +	data_post_delay = 0 + mipi->data_post_delay_adjust * ui;
> +
> +	// D-PHY Specification : data_t_hs_trial >= max( n*8*UI, 60ns + n*4*UI ), n = 1
> +	// clocked by TXBYTECLKHS
> +	data_t_hs_trial = ((600 * accuracy + 4 * ui) >= (8 * ui) ? (600 * accuracy + 4 * ui) : (8 * ui)) +
> +		2 * unit_tx_byte_clk_hs + mipi->data_t_hs_trial_adjust * ui;
> +
> +	// D-PHY Specification : 40ns + 4*UI <= data_t_hs_prepare <= 85ns + 6*UI
> +	// clocked by TXBYTECLKHS
> +	data_t_hs_prepare = 400 * accuracy + 4 * ui;
> +	// D-PHY chip spec : clk_t_lpx + clk_t_hs_prepare > 200ns
> +	// D-PHY Specification : clk_t_lpx >= 50ns
> +	// clocked by TXBYTECLKHS
> +	clk_t_lpx = (uint32_t)(2000 * accuracy + 10 * accuracy + mipi->clk_t_lpx_adjust * ui - clk_t_hs_prepare);
> +
> +	// D-PHY Specification : clk_t_hs_zero + clk_t_hs_prepare >= 300 ns
> +	// clocked by TXBYTECLKHS
> +	clk_t_hs_zero = (uint32_t)(3000 * accuracy + 3 * unit_tx_byte_clk_hs + mipi->clk_t_hs_zero_adjust * ui - clk_t_hs_prepare);
> +
> +	// D-PHY chip spec : data_t_lpx + data_t_hs_prepare > 200ns
> +	// D-PHY Specification : data_t_lpx >= 50ns
> +	// clocked by TXBYTECLKHS
> +	data_t_lpx = (uint32_t)(2000 * accuracy + 10 * accuracy + mipi->data_t_lpx_adjust * ui - data_t_hs_prepare);
> +
> +	// D-PHY Specification : data_t_hs_zero + data_t_hs_prepare >= 145ns + 10*UI
> +	// clocked by TXBYTECLKHS
> +	data_t_hs_zero = (uint32_t)(1450 * accuracy + 10 * ui +
> +		3 * unit_tx_byte_clk_hs + mipi->data_t_hs_zero_adjust * ui - data_t_hs_prepare);
> +
> +	phy_ctrl->clk_pre_delay = ROUND1(clk_pre_delay, unit_tx_byte_clk_hs);
> +	phy_ctrl->clk_t_hs_prepare = ROUND1(clk_t_hs_prepare, unit_tx_byte_clk_hs);
> +	phy_ctrl->clk_t_lpx = ROUND1(clk_t_lpx, unit_tx_byte_clk_hs);
> +	phy_ctrl->clk_t_hs_zero = ROUND1(clk_t_hs_zero, unit_tx_byte_clk_hs);
> +	phy_ctrl->clk_t_hs_trial = ROUND1(clk_t_hs_trial, unit_tx_byte_clk_hs);
> +
> +	phy_ctrl->data_post_delay = ROUND1(data_post_delay, unit_tx_byte_clk_hs);
> +	phy_ctrl->data_t_hs_prepare = ROUND1(data_t_hs_prepare, unit_tx_byte_clk_hs);
> +	phy_ctrl->data_t_lpx = ROUND1(data_t_lpx, unit_tx_byte_clk_hs);
> +	phy_ctrl->data_t_hs_zero = ROUND1(data_t_hs_zero, unit_tx_byte_clk_hs);
> +	phy_ctrl->data_t_hs_trial = ROUND1(data_t_hs_trial, unit_tx_byte_clk_hs);
> +
> +	phy_ctrl->clk_post_delay = phy_ctrl->data_t_hs_trial + ROUND1(clk_post, unit_tx_byte_clk_hs);
> +	phy_ctrl->data_pre_delay = phy_ctrl->clk_pre_delay + 2 + phy_ctrl->clk_t_lpx +
> +		phy_ctrl->clk_t_hs_prepare + phy_ctrl->clk_t_hs_zero + 8 + ROUND1(clk_pre, unit_tx_byte_clk_hs);
> +
> +	phy_ctrl->clk_lane_lp2hs_time = phy_ctrl->clk_pre_delay + phy_ctrl->clk_t_lpx + phy_ctrl->clk_t_hs_prepare +
> +		phy_ctrl->clk_t_hs_zero + 5 + 7;
> +	phy_ctrl->clk_lane_hs2lp_time = phy_ctrl->clk_t_hs_trial + phy_ctrl->clk_post_delay + 8 + 4;
> +	phy_ctrl->data_lane_lp2hs_time = phy_ctrl->data_pre_delay + phy_ctrl->data_t_lpx + phy_ctrl->data_t_hs_prepare +
> +		phy_ctrl->data_t_hs_zero + 5 + 7;
> +	phy_ctrl->data_lane_hs2lp_time = phy_ctrl->data_t_hs_trial + 8 + 5;
> +
> +	phy_ctrl->phy_stop_wait_time = phy_ctrl->clk_post_delay + 4 + phy_ctrl->clk_t_hs_trial +
> +		ROUND1(clk_t_hs_exit, unit_tx_byte_clk_hs) - (phy_ctrl->data_post_delay + 4 + phy_ctrl->data_t_hs_trial) + 3;
> +
> +	phy_ctrl->lane_byte_clk = lane_clock / 8;
> +	phy_ctrl->clk_division = (((phy_ctrl->lane_byte_clk / 2) % mipi->max_tx_esc_clk) > 0) ?
> +		(uint32_t)(phy_ctrl->lane_byte_clk / 2 / mipi->max_tx_esc_clk + 1) :
> +		(uint32_t)(phy_ctrl->lane_byte_clk / 2 / mipi->max_tx_esc_clk);
> +
> +	DRM_DEBUG("DPHY clock_lane and data_lane config :\n"
> +		"lane_clock = %llu, n_pll=%d, m_pll=%d\n"
> +		"rg_cp=%d\n"
> +		"rg_band_sel=%d\n"
> +		"rg_vrefsel_vcm=%d\n"
> +		"clk_pre_delay=%d\n"
> +		"clk_post_delay=%d\n"
> +		"clk_t_hs_prepare=%d\n"
> +		"clk_t_lpx=%d\n"
> +		"clk_t_hs_zero=%d\n"
> +		"clk_t_hs_trial=%d\n"
> +		"data_pre_delay=%d\n"
> +		"data_post_delay=%d\n"
> +		"data_t_hs_prepare=%d\n"
> +		"data_t_lpx=%d\n"
> +		"data_t_hs_zero=%d\n"
> +		"data_t_hs_trial=%d\n"
> +		"clk_lane_lp2hs_time=%d\n"
> +		"clk_lane_hs2lp_time=%d\n"
> +		"data_lane_lp2hs_time=%d\n"
> +		"data_lane_hs2lp_time=%d\n"
> +		"phy_stop_wait_time=%d\n",
> +		lane_clock, n_pll, m_pll,
> +		phy_ctrl->rg_cp,
> +		phy_ctrl->rg_band_sel,
> +		phy_ctrl->rg_vrefsel_vcm,
> +		phy_ctrl->clk_pre_delay,
> +		phy_ctrl->clk_post_delay,
> +		phy_ctrl->clk_t_hs_prepare,
> +		phy_ctrl->clk_t_lpx,
> +		phy_ctrl->clk_t_hs_zero,
> +		phy_ctrl->clk_t_hs_trial,
> +		phy_ctrl->data_pre_delay,
> +		phy_ctrl->data_post_delay,
> +		phy_ctrl->data_t_hs_prepare,
> +		phy_ctrl->data_t_lpx,
> +		phy_ctrl->data_t_hs_zero,
> +		phy_ctrl->data_t_hs_trial,
> +		phy_ctrl->clk_lane_lp2hs_time,
> +		phy_ctrl->clk_lane_hs2lp_time,
> +		phy_ctrl->data_lane_lp2hs_time,
> +		phy_ctrl->data_lane_hs2lp_time,
> +		phy_ctrl->phy_stop_wait_time);
> +}
> +
> +static void kirin960_get_dsi_phy_ctrl(struct dw_dsi *dsi,
> +				      struct mipi_phy_params *phy_ctrl, u32 id)
> +{
> +	struct mipi_panel_info *mipi = NULL;
> +	struct drm_display_mode *mode = NULL;
> +	u32 dphy_req_kHz;
> +	int bpp;
> +	u32 ui = 0;
> +	u32 m_pll = 0;
> +	u32 n_pll = 0;
> +	u32 m_n_fract = 0;
> +	u32 m_n_int = 0;
> +	u64 lane_clock = 0;
> +	u64 vco_div = 1;
> +
> +	u32 accuracy = 0;
> +	u32 unit_tx_byte_clk_hs = 0;
> +	u32 clk_post = 0;
> +	u32 clk_pre = 0;
> +	u32 clk_t_hs_exit = 0;
> +	u32 clk_pre_delay = 0;
> +	u32 clk_t_hs_prepare = 0;
> +	u32 clk_t_lpx = 0;
> +	u32 clk_t_hs_zero = 0;
> +	u32 clk_t_hs_trial = 0;
> +	u32 data_post_delay = 0;
> +	u32 data_t_hs_prepare = 0;
> +	u32 data_t_hs_zero = 0;
> +	u32 data_t_hs_trial = 0;
> +	u32 data_t_lpx = 0;
> +	u32 clk_pre_delay_reality = 0;
> +	u32 clk_t_hs_zero_reality = 0;
> +	u32 clk_post_delay_reality = 0;
> +	u32 data_t_hs_zero_reality = 0;
> +	u32 data_post_delay_reality = 0;
> +	u32 data_pre_delay_reality = 0;
> +
> +	WARN_ON(!phy_ctrl);
> +	WARN_ON(!dsi);
> +
> +	mode = &dsi->cur_mode;
> +	mipi = &dsi->mipi;
> +
> +	/*
> +	 * count phy params
> +	 */
> +	bpp = mipi_dsi_pixel_format_to_bpp(dsi->client[id].format);
> +	if (bpp < 0)
> +		return;
> +
> +	if (mode->clock > 80000)
> +		dsi->client[id].lanes = 4;
> +	else
> +		dsi->client[id].lanes = 3;
> +
> +	if (dsi->client[id].phy_clock)
> +		dphy_req_kHz = dsi->client[id].phy_clock;
> +	else
> +		dphy_req_kHz = mode->clock * bpp / dsi->client[id].lanes;
> +
> +	lane_clock = dphy_req_kHz / 1000;
> +	DRM_INFO("Expected : lane_clock = %llu M\n", lane_clock);
> +
> +	/************************  PLL parameters config  *********************/
> +
> +	/*
> +	 * chip spec :
> +	 *	If the output data rate is below 320 Mbps,
> +	 *	RG_BNAD_SEL should be set to 1.
> +	 *	At this mode a post divider of 1/4 will be applied to VCO.
> +	 */
> +	if ((lane_clock >= 320) && (lane_clock <= 2500)) {
> +		phy_ctrl->rg_band_sel = 0;	/*0x1E[2]*/
> +		vco_div = 1;
> +	} else if ((lane_clock >= 80) && (lane_clock < 320)) {
> +		phy_ctrl->rg_band_sel = 1;
> +		vco_div = 4;
> +	} else {
> +		DRM_ERROR("80M <= lane_clock< = 2500M, not support lane_clock = %llu M\n",
> +			  lane_clock);
> +	}
> +
> +	m_n_int = lane_clock * vco_div * 1000000UL / DEFAULT_MIPI_CLK_RATE;
> +	m_n_fract = ((lane_clock * vco_div * 1000000UL * 1000UL / DEFAULT_MIPI_CLK_RATE) % 1000) * 10 / 1000;
> +
> +	if (m_n_int % 2 == 0) {
> +		if (m_n_fract * 6 >= 50) {
> +			n_pll = 2;
> +			m_pll = (m_n_int + 1) * n_pll;
> +		} else if (m_n_fract * 6 >= 30) {
> +			n_pll = 3;
> +			m_pll = m_n_int * n_pll + 2;
> +		} else {
> +			n_pll = 1;
> +			m_pll = m_n_int * n_pll;
> +		}
> +	} else {
> +		if (m_n_fract * 6 >= 50) {
> +			n_pll = 1;
> +			m_pll = (m_n_int + 1) * n_pll;
> +		} else if (m_n_fract * 6 >= 30) {
> +			n_pll = 1;
> +			m_pll = (m_n_int + 1) * n_pll;
> +		} else if (m_n_fract * 6 >= 10) {
> +			n_pll = 3;
> +			m_pll = m_n_int * n_pll + 1;
> +		} else {
> +			n_pll = 2;
> +			m_pll = m_n_int * n_pll;
> +		}
> +	}
> +
> +	/*if set rg_pll_enswc=1, rg_pll_fbd_s can't be 0*/
> +	if (m_pll <= 8) {
> +		phy_ctrl->rg_pll_fbd_s = 1;
> +		phy_ctrl->rg_pll_enswc = 0;
> +
> +		if (m_pll % 2 == 0) {
> +			phy_ctrl->rg_pll_fbd_p = m_pll / 2;
> +		} else {
> +			if (n_pll == 1) {
> +				n_pll *= 2;
> +				phy_ctrl->rg_pll_fbd_p = (m_pll  * 2) / 2;
> +			} else {
> +				DRM_ERROR("phy m_pll not support!m_pll = %d\n", m_pll);
> +				return;
> +			}
> +		}
> +	} else if (m_pll <= 300) {
> +		if (m_pll % 2 == 0)
> +			phy_ctrl->rg_pll_enswc = 0;
> +		else
> +			phy_ctrl->rg_pll_enswc = 1;
> +
> +		phy_ctrl->rg_pll_fbd_s = 1;
> +		phy_ctrl->rg_pll_fbd_p = m_pll / 2;
> +	} else if (m_pll <= 315) {
> +		phy_ctrl->rg_pll_fbd_p = 150;
> +		phy_ctrl->rg_pll_fbd_s = m_pll - 2 * phy_ctrl->rg_pll_fbd_p;
> +		phy_ctrl->rg_pll_enswc = 1;
> +	} else {
> +		DRM_ERROR("phy m_pll not support!m_pll = %d\n", m_pll);
> +		return;
> +	}
> +
> +	phy_ctrl->rg_pll_pre_p = n_pll;
> +
> +	lane_clock = m_pll * (DEFAULT_MIPI_CLK_RATE / n_pll) / vco_div;
> +	DRM_INFO("Config : lane_clock = %llu\n", lane_clock);
> +
> +	/*FIXME :*/
> +	phy_ctrl->rg_pll_cp = 1;		/*0x16[7:5]*/
> +	phy_ctrl->rg_pll_cp_p = 3;		/*0x1E[7:5]*/
> +
> +	/*test_code_0x14 other parameters config*/
> +	phy_ctrl->rg_pll_enbwt = 0;	/*0x14[2]*/
> +	phy_ctrl->rg_pll_chp = 0;		/*0x14[1:0]*/
> +
> +	/*test_code_0x16 other parameters config,  0x16[3:2] reserved*/
> +	phy_ctrl->rg_pll_lpf_cs = 0;	/*0x16[4]*/
> +	phy_ctrl->rg_pll_refsel = 1;		/*0x16[1:0]*/
> +
> +	/*test_code_0x1E other parameters config*/
> +	phy_ctrl->reload_sel = 1;			/*0x1E[4]*/
> +	phy_ctrl->rg_phase_gen_en = 1;	/*0x1E[3]*/
> +	phy_ctrl->pll_power_down = 0;		/*0x1E[1]*/
> +	phy_ctrl->pll_register_override = 1;	/*0x1E[0]*/
> +
> +	/*HSTX select VCM VREF*/
> +	phy_ctrl->rg_vrefsel_vcm = 0x55;
> +	if (mipi->rg_vrefsel_vcm_clk_adjust != 0)
> +		phy_ctrl->rg_vrefsel_vcm = (phy_ctrl->rg_vrefsel_vcm & 0x0F) |
> +			((mipi->rg_vrefsel_vcm_clk_adjust & 0x0F) << 4);
> +
> +	if (mipi->rg_vrefsel_vcm_data_adjust != 0)
> +		phy_ctrl->rg_vrefsel_vcm = (phy_ctrl->rg_vrefsel_vcm & 0xF0) |
> +			(mipi->rg_vrefsel_vcm_data_adjust & 0x0F);
> +
> +	/*if reload_sel = 1, need to set load_command*/
> +	phy_ctrl->load_command = 0x5A;
> +
> +	/********************  clock/data lane parameters config  ******************/
> +	accuracy = 10;
> +	ui =  10 * 1000000000UL * accuracy / lane_clock;
> +	/*unit of measurement*/
> +	unit_tx_byte_clk_hs = 8 * ui;
> +
> +	/* D-PHY Specification : 60ns + 52*UI <= clk_post*/
> +	clk_post = 600 * accuracy + 52 * ui + mipi->clk_post_adjust * ui;
> +
> +	/* D-PHY Specification : clk_pre >= 8*UI*/
> +	clk_pre = 8 * ui + mipi->clk_pre_adjust * ui;
> +
> +	/* D-PHY Specification : clk_t_hs_exit >= 100ns*/
> +	clk_t_hs_exit = 1000 * accuracy + mipi->clk_t_hs_exit_adjust * ui;
> +
> +	/* clocked by TXBYTECLKHS*/
> +	clk_pre_delay = 0 + mipi->clk_pre_delay_adjust * ui;
> +
> +	/* D-PHY Specification : clk_t_hs_trial >= 60ns*/
> +	/* clocked by TXBYTECLKHS*/
> +	clk_t_hs_trial = 600 * accuracy + 3 * unit_tx_byte_clk_hs + mipi->clk_t_hs_trial_adjust * ui;
> +
> +	/* D-PHY Specification : 38ns <= clk_t_hs_prepare <= 95ns*/
> +	/* clocked by TXBYTECLKHS*/
> +	if (mipi->clk_t_hs_prepare_adjust == 0)
> +		mipi->clk_t_hs_prepare_adjust = 43;
> +
> +	clk_t_hs_prepare = ((380 * accuracy + mipi->clk_t_hs_prepare_adjust * ui) <= (950 * accuracy - 8 * ui)) ?
> +		(380 * accuracy + mipi->clk_t_hs_prepare_adjust * ui) : (950 * accuracy - 8 * ui);
> +
> +	/* clocked by TXBYTECLKHS*/
> +	data_post_delay = 0 + mipi->data_post_delay_adjust * ui;
> +
> +	/* D-PHY Specification : data_t_hs_trial >= max( n*8*UI, 60ns + n*4*UI ), n = 1*/
> +	/* clocked by TXBYTECLKHS*/
> +	data_t_hs_trial = ((600 * accuracy + 4 * ui) >= (8 * ui) ? (600 * accuracy + 4 * ui) : (8 * ui)) + 8 * ui +
> +		3 * unit_tx_byte_clk_hs + mipi->data_t_hs_trial_adjust * ui;
> +
> +	/* D-PHY Specification : 40ns + 4*UI <= data_t_hs_prepare <= 85ns + 6*UI*/
> +	/* clocked by TXBYTECLKHS*/
> +	if (mipi->data_t_hs_prepare_adjust == 0)
> +		mipi->data_t_hs_prepare_adjust = 35;
> +
> +	data_t_hs_prepare = ((400  * accuracy + 4 * ui + mipi->data_t_hs_prepare_adjust * ui) <= (850 * accuracy + 6 * ui - 8 * ui)) ?
> +		(400  * accuracy + 4 * ui + mipi->data_t_hs_prepare_adjust * ui) : (850 * accuracy + 6 * ui - 8 * ui);
> +
> +	/* D-PHY chip spec : clk_t_lpx + clk_t_hs_prepare > 200ns*/
> +	/* D-PHY Specification : clk_t_lpx >= 50ns*/
> +	/* clocked by TXBYTECLKHS*/
> +	clk_t_lpx = (((2000 * accuracy - clk_t_hs_prepare) >= 500 * accuracy) ?
> +		((2000 * accuracy - clk_t_hs_prepare)) : (500 * accuracy)) +
> +		mipi->clk_t_lpx_adjust * ui;
> +
> +	/* D-PHY Specification : clk_t_hs_zero + clk_t_hs_prepare >= 300 ns*/
> +	/* clocked by TXBYTECLKHS*/
> +	clk_t_hs_zero = 3000 * accuracy - clk_t_hs_prepare + 3 * unit_tx_byte_clk_hs + mipi->clk_t_hs_zero_adjust * ui;
> +
> +	/* D-PHY chip spec : data_t_lpx + data_t_hs_prepare > 200ns*/
> +	/* D-PHY Specification : data_t_lpx >= 50ns*/
> +	/* clocked by TXBYTECLKHS*/
> +	data_t_lpx = clk_t_lpx + mipi->data_t_lpx_adjust * ui; /*2000 * accuracy - data_t_hs_prepare;*/
> +
> +	/* D-PHY Specification : data_t_hs_zero + data_t_hs_prepare >= 145ns + 10*UI*/
> +	/* clocked by TXBYTECLKHS*/
> +	data_t_hs_zero = 1450 * accuracy + 10 * ui - data_t_hs_prepare +
> +		3 * unit_tx_byte_clk_hs + mipi->data_t_hs_zero_adjust * ui;
> +
> +	phy_ctrl->clk_pre_delay = ROUND1(clk_pre_delay, unit_tx_byte_clk_hs);
> +	phy_ctrl->clk_t_hs_prepare = ROUND1(clk_t_hs_prepare, unit_tx_byte_clk_hs);
> +	phy_ctrl->clk_t_lpx = ROUND1(clk_t_lpx, unit_tx_byte_clk_hs);
> +	phy_ctrl->clk_t_hs_zero = ROUND1(clk_t_hs_zero, unit_tx_byte_clk_hs);
> +	phy_ctrl->clk_t_hs_trial = ROUND1(clk_t_hs_trial, unit_tx_byte_clk_hs);
> +
> +	phy_ctrl->data_post_delay = ROUND1(data_post_delay, unit_tx_byte_clk_hs);
> +	phy_ctrl->data_t_hs_prepare = ROUND1(data_t_hs_prepare, unit_tx_byte_clk_hs);
> +	phy_ctrl->data_t_lpx = ROUND1(data_t_lpx, unit_tx_byte_clk_hs);
> +	phy_ctrl->data_t_hs_zero = ROUND1(data_t_hs_zero, unit_tx_byte_clk_hs);
> +	phy_ctrl->data_t_hs_trial = ROUND1(data_t_hs_trial, unit_tx_byte_clk_hs);
> +	phy_ctrl->data_t_ta_go = 4;
> +	phy_ctrl->data_t_ta_get = 5;
> +
> +	clk_pre_delay_reality = phy_ctrl->clk_pre_delay + 2;
> +	clk_t_hs_zero_reality = phy_ctrl->clk_t_hs_zero + 8;
> +	data_t_hs_zero_reality = phy_ctrl->data_t_hs_zero + 4;
> +	data_post_delay_reality = phy_ctrl->data_post_delay + 4;
> +
> +	phy_ctrl->clk_post_delay = phy_ctrl->data_t_hs_trial + ROUND1(clk_post, unit_tx_byte_clk_hs);
> +	phy_ctrl->data_pre_delay = clk_pre_delay_reality + phy_ctrl->clk_t_lpx +
> +		phy_ctrl->clk_t_hs_prepare + clk_t_hs_zero_reality + ROUND1(clk_pre, unit_tx_byte_clk_hs);
> +
> +	clk_post_delay_reality = phy_ctrl->clk_post_delay + 4;
> +	data_pre_delay_reality = phy_ctrl->data_pre_delay + 2;
> +
> +	phy_ctrl->clk_lane_lp2hs_time = clk_pre_delay_reality + phy_ctrl->clk_t_lpx +
> +		phy_ctrl->clk_t_hs_prepare + clk_t_hs_zero_reality + 3;
> +	phy_ctrl->clk_lane_hs2lp_time = clk_post_delay_reality + phy_ctrl->clk_t_hs_trial + 3;
> +	phy_ctrl->data_lane_lp2hs_time = data_pre_delay_reality + phy_ctrl->data_t_lpx +
> +		phy_ctrl->data_t_hs_prepare + data_t_hs_zero_reality + 3;
> +	phy_ctrl->data_lane_hs2lp_time = data_post_delay_reality + phy_ctrl->data_t_hs_trial + 3;
> +	phy_ctrl->phy_stop_wait_time = clk_post_delay_reality +
> +		phy_ctrl->clk_t_hs_trial + ROUND1(clk_t_hs_exit, unit_tx_byte_clk_hs) -
> +		(data_post_delay_reality + phy_ctrl->data_t_hs_trial) + 3;
> +
> +	phy_ctrl->lane_byte_clk = lane_clock / 8;
> +	phy_ctrl->clk_division = (((phy_ctrl->lane_byte_clk / 2) % mipi->max_tx_esc_clk) > 0) ?
> +		(phy_ctrl->lane_byte_clk / 2 / mipi->max_tx_esc_clk + 1) :
> +		(phy_ctrl->lane_byte_clk / 2 / mipi->max_tx_esc_clk);
> +
> +	DRM_DEBUG("PHY clock_lane and data_lane config :\n"
> +		"rg_vrefsel_vcm=%u\n"
> +		"clk_pre_delay=%u\n"
> +		"clk_post_delay=%u\n"
> +		"clk_t_hs_prepare=%u\n"
> +		"clk_t_lpx=%u\n"
> +		"clk_t_hs_zero=%u\n"
> +		"clk_t_hs_trial=%u\n"
> +		"data_pre_delay=%u\n"
> +		"data_post_delay=%u\n"
> +		"data_t_hs_prepare=%u\n"
> +		"data_t_lpx=%u\n"
> +		"data_t_hs_zero=%u\n"
> +		"data_t_hs_trial=%u\n"
> +		"data_t_ta_go=%u\n"
> +		"data_t_ta_get=%u\n",
> +		phy_ctrl->rg_vrefsel_vcm,
> +		phy_ctrl->clk_pre_delay,
> +		phy_ctrl->clk_post_delay,
> +		phy_ctrl->clk_t_hs_prepare,
> +		phy_ctrl->clk_t_lpx,
> +		phy_ctrl->clk_t_hs_zero,
> +		phy_ctrl->clk_t_hs_trial,
> +		phy_ctrl->data_pre_delay,
> +		phy_ctrl->data_post_delay,
> +		phy_ctrl->data_t_hs_prepare,
> +		phy_ctrl->data_t_lpx,
> +		phy_ctrl->data_t_hs_zero,
> +		phy_ctrl->data_t_hs_trial,
> +		phy_ctrl->data_t_ta_go,
> +		phy_ctrl->data_t_ta_get);
> +	DRM_DEBUG("clk_lane_lp2hs_time=%u\n"
> +		"clk_lane_hs2lp_time=%u\n"
> +		"data_lane_lp2hs_time=%u\n"
> +		"data_lane_hs2lp_time=%u\n"
> +		"phy_stop_wait_time=%u\n",
> +		phy_ctrl->clk_lane_lp2hs_time,
> +		phy_ctrl->clk_lane_hs2lp_time,
> +		phy_ctrl->data_lane_lp2hs_time,
> +		phy_ctrl->data_lane_hs2lp_time,
> +		phy_ctrl->phy_stop_wait_time);
> +}
> +
> +static void dw_dsi_set_mode(struct dw_dsi *dsi, enum dsi_work_mode mode)
> +{
> +	struct dsi_hw_ctx *ctx = dsi->ctx;
> +	void __iomem *base = ctx->base;
> +
> +	writel(RESET, base + PWR_UP);
> +	writel(mode, base + MODE_CFG);
> +	writel(POWERUP, base + PWR_UP);
> +}
> +
> +static void dsi_set_burst_mode(void __iomem *base, unsigned long burst_flags)
> +{
> +	unsigned long flags;
> +	u32 val;
> +
> +	flags = burst_flags;
> +	flags &= MIPI_DSI_MODE_VIDEO |
> +		 MIPI_DSI_MODE_VIDEO_BURST |
> +		 MIPI_DSI_MODE_VIDEO_SYNC_PULSE;
> +
> +	if (!(flags & MIPI_DSI_MODE_VIDEO)) {
> +		DRM_WARN("MIPI_DSI_MODE_VIDEO was not set! Using DSI_NON_BURST_SYNC_PULSES");
> +		val = DSI_NON_BURST_SYNC_PULSES;
> +	} else if (flags & MIPI_DSI_MODE_VIDEO_BURST) {
> +		val = DSI_BURST_SYNC_PULSES_1;
> +	} else if (flags & MIPI_DSI_MODE_VIDEO_SYNC_PULSE) {
> +		val = DSI_NON_BURST_SYNC_PULSES;
> +	} else {
> +		val = DSI_NON_BURST_SYNC_EVENTS;
> +	}
> +
> +	DRM_INFO("burst_mode = 0x%x (flags: 0x%04lx)", val, burst_flags);
> +	set_reg(base + MIPIDSI_VID_MODE_CFG_OFFSET, val, 2, 0);
> +}
> +
> +/*
> + * dsi phy reg write function
> + */
> +static void dsi_phy_tst_set(void __iomem *base, u32 reg, u32 val)
> +{
> +	u32 reg_write = 0x10000 + reg;
> +
> +	/*
> +	 * latch reg first
> +	 */
> +	writel(reg_write, base + MIPIDSI_PHY_TST_CTRL1_OFFSET);
> +	writel(0x02, base + MIPIDSI_PHY_TST_CTRL0_OFFSET);
> +	writel(0x00, base + MIPIDSI_PHY_TST_CTRL0_OFFSET);
> +
> +	/*
> +	 * then latch value
> +	 */
> +	writel(val, base + MIPIDSI_PHY_TST_CTRL1_OFFSET);
> +	writel(0x02, base + MIPIDSI_PHY_TST_CTRL0_OFFSET);
> +	writel(0x00, base + MIPIDSI_PHY_TST_CTRL0_OFFSET);
> +}
> +
> +static void mipi_config_dphy_spec1v2_parameter(struct dw_dsi *dsi,
> +					       char __iomem *mipi_dsi_base,
> +					       u32 id)
> +{
> +	u32 i;
> +	u32 addr = 0;
> +	u32 lanes;
> +
> +	lanes =  dsi->client[id].lanes - 1;
> +	for (i = 0; i <= (lanes + 1); i++) {
> +		//Lane Transmission Property
> +		addr = MIPIDSI_PHY_TST_LANE_TRANSMISSION_PROPERTY + (i << 5);
> +		dsi_phy_tst_set(mipi_dsi_base, addr, 0x43);
> +	}
> +
> +	//pre_delay of clock lane request setting
> +	dsi_phy_tst_set(mipi_dsi_base, MIPIDSI_PHY_TST_CLK_PRE_DELAY, DSS_REDUCE(dsi->phy.clk_pre_delay));
> +
> +	//post_delay of clock lane request setting
> +	dsi_phy_tst_set(mipi_dsi_base, MIPIDSI_PHY_TST_CLK_POST_DELAY, DSS_REDUCE(dsi->phy.clk_post_delay));
> +
> +	//clock lane timing ctrl - t_lpx
> +	dsi_phy_tst_set(mipi_dsi_base, MIPIDSI_PHY_TST_CLK_TLPX, DSS_REDUCE(dsi->phy.clk_t_lpx));
> +
> +	//clock lane timing ctrl - t_hs_prepare
> +	dsi_phy_tst_set(mipi_dsi_base, MIPIDSI_PHY_TST_CLK_PREPARE, DSS_REDUCE(dsi->phy.clk_t_hs_prepare));
> +
> +	//clock lane timing ctrl - t_hs_zero
> +	dsi_phy_tst_set(mipi_dsi_base, MIPIDSI_PHY_TST_CLK_ZERO, DSS_REDUCE(dsi->phy.clk_t_hs_zero));
> +
> +	//clock lane timing ctrl - t_hs_trial
> +	dsi_phy_tst_set(mipi_dsi_base, MIPIDSI_PHY_TST_CLK_TRAIL, DSS_REDUCE(dsi->phy.clk_t_hs_trial));
> +
> +	for (i = 0; i <= 4; i++) {
> +		if (lanes == 2 && i == 1) /*init mipi dsi 3 lanes should skip lane3*/
> +			i++;
> +
> +		if (i == 2) /* skip clock lane*/
> +			i++;  //addr: lane0:0x60; lane1:0x80; lane2:0xC0; lane3:0xE0
> +
> +		//data lane pre_delay
> +		addr = MIPIDSI_PHY_TST_DATA_PRE_DELAY + (i << 5);
> +		dsi_phy_tst_set(mipi_dsi_base, addr, DSS_REDUCE(dsi->phy.data_pre_delay));
> +
> +		//data lane post_delay
> +		addr = MIPIDSI_PHY_TST_DATA_POST_DELAY + (i << 5);
> +		dsi_phy_tst_set(mipi_dsi_base, addr, DSS_REDUCE(dsi->phy.data_post_delay));
> +
> +		//data lane timing ctrl - t_lpx
> +		addr = MIPIDSI_PHY_TST_DATA_TLPX + (i << 5);
> +		dsi_phy_tst_set(mipi_dsi_base, addr, DSS_REDUCE(dsi->phy.data_t_lpx));
> +
> +		//data lane timing ctrl - t_hs_prepare
> +		addr = MIPIDSI_PHY_TST_DATA_PREPARE + (i << 5);
> +		dsi_phy_tst_set(mipi_dsi_base, addr, DSS_REDUCE(dsi->phy.data_t_hs_prepare));
> +
> +		//data lane timing ctrl - t_hs_zero
> +		addr = MIPIDSI_PHY_TST_DATA_ZERO + (i << 5);
> +		dsi_phy_tst_set(mipi_dsi_base, addr, DSS_REDUCE(dsi->phy.data_t_hs_zero));
> +
> +		//data lane timing ctrl - t_hs_trial
> +		addr = MIPIDSI_PHY_TST_DATA_TRAIL + (i << 5);
> +		dsi_phy_tst_set(mipi_dsi_base, addr, DSS_REDUCE(dsi->phy.data_t_hs_trial));
> +
> +		DRM_DEBUG("DPHY spec1v2 config :\n"
> +			"addr=0x%x\n"
> +			"clk_pre_delay=%u\n"
> +			"clk_t_hs_trial=%u\n"
> +			"data_t_hs_zero=%u\n"
> +			"data_t_lpx=%u\n"
> +			"data_t_hs_prepare=%u\n",
> +			addr,
> +			dsi->phy.clk_pre_delay,
> +			dsi->phy.clk_t_hs_trial,
> +			dsi->phy.data_t_hs_zero,
> +			dsi->phy.data_t_lpx,
> +			dsi->phy.data_t_hs_prepare);
> +	}
> +}
> +
> +static void dsi_mipi_init(struct dw_dsi *dsi, char __iomem *mipi_dsi_base,
> +			  u32 id)
> +{
> +	struct dsi_hw_ctx *ctx = dsi->ctx;
> +	u32 hline_time = 0;
> +	u32 hsa_time = 0;
> +	u32 hbp_time = 0;
> +	u64 pixel_clk = 0;
> +	unsigned long dw_jiffies = 0;
> +	u32 tmp = 0;
> +	bool is_ready = false;
> +	struct mipi_panel_info *mipi = NULL;
> +	struct dss_rect rect;
> +	u32 cmp_stopstate_val = 0;
> +	u32 lanes;
> +
> +	WARN_ON(!dsi);
> +	WARN_ON(!mipi_dsi_base);
> +
> +	DRM_INFO("%s: id=%d\n", __func__, id);
> +
> +	mipi = &dsi->mipi;
> +
> +	if (mipi->max_tx_esc_clk == 0) {
> +		DRM_INFO("max_tx_esc_clk is invalid!");
> +		mipi->max_tx_esc_clk = DEFAULT_MAX_TX_ESC_CLK;
> +	}
> +
> +	memset(&dsi->phy, 0, sizeof(struct mipi_phy_params));
> +
> +	if (ctx->g_dss_version_tag == FB_ACCEL_KIRIN970)
> +		kirin970_get_dsi_dphy_ctrl(dsi, &dsi->phy, id);
> +	else
> +		kirin960_get_dsi_phy_ctrl(dsi, &dsi->phy, id);
> +
> +	rect.x = 0;
> +	rect.y = 0;
> +	rect.w = dsi->cur_mode.hdisplay;
> +	rect.h = dsi->cur_mode.vdisplay;
> +	lanes = dsi->client[id].lanes - 1;
> +	/***************Configure the DPHY start**************/
> +
> +	set_reg(mipi_dsi_base + MIPIDSI_PHY_IF_CFG_OFFSET, lanes, 2, 0);
> +	set_reg(mipi_dsi_base + MIPIDSI_CLKMGR_CFG_OFFSET, dsi->phy.clk_division, 8, 0);
> +	set_reg(mipi_dsi_base + MIPIDSI_CLKMGR_CFG_OFFSET, dsi->phy.clk_division, 8, 8);
> +
> +	writel(0x00000000, mipi_dsi_base + MIPIDSI_PHY_RSTZ_OFFSET);
> +
> +	writel(0x00000000, mipi_dsi_base + MIPIDSI_PHY_TST_CTRL0_OFFSET);
> +	writel(0x00000001, mipi_dsi_base + MIPIDSI_PHY_TST_CTRL0_OFFSET);
> +	writel(0x00000000, mipi_dsi_base + MIPIDSI_PHY_TST_CTRL0_OFFSET);
> +
> +	if (ctx->g_dss_version_tag == FB_ACCEL_KIRIN970) {
> +		dsi_phy_tst_set(mipi_dsi_base, 0x0042, 0x21);
> +		//PLL configuration I
> +		dsi_phy_tst_set(mipi_dsi_base, 0x0046,
> +				dsi->phy.rg_cp + (dsi->phy.rg_lpf_r << 4));
> +
> +		//PLL configuration II
> +		dsi_phy_tst_set(mipi_dsi_base, 0x0048,
> +				dsi->phy.rg_0p8v + (dsi->phy.rg_2p5g << 1) +
> +				(dsi->phy.rg_320m << 2) + (dsi->phy.rg_band_sel << 3));
> +
> +		//PLL configuration III
> +		dsi_phy_tst_set(mipi_dsi_base, 0x0049, dsi->phy.rg_pre_div);
> +
> +		//PLL configuration IV
> +		dsi_phy_tst_set(mipi_dsi_base, 0x004A, dsi->phy.rg_div);
> +
> +		dsi_phy_tst_set(mipi_dsi_base, 0x004F, 0xf0);
> +		dsi_phy_tst_set(mipi_dsi_base, 0x0050, 0xc0);
> +		dsi_phy_tst_set(mipi_dsi_base, 0x0051, 0x22);
> +
> +		dsi_phy_tst_set(mipi_dsi_base, 0x0053, dsi->phy.rg_vrefsel_vcm);
> +
> +		/*enable BTA*/
> +		dsi_phy_tst_set(mipi_dsi_base, 0x0054, 0x03);
> +
> +		//PLL update control
> +		dsi_phy_tst_set(mipi_dsi_base, 0x004B, 0x1);
> +
> +		//set dphy spec parameter
> +		mipi_config_dphy_spec1v2_parameter(dsi, mipi_dsi_base, id);
> +	} else {
> +		int i = 0;
> +
> +		/* physical configuration PLL I*/
> +		dsi_phy_tst_set(mipi_dsi_base, 0x14,
> +				(dsi->phy.rg_pll_fbd_s << 4) + (dsi->phy.rg_pll_enswc << 3) +
> +				(dsi->phy.rg_pll_enbwt << 2) + dsi->phy.rg_pll_chp);
> +
> +		/* physical configuration PLL II, M*/
> +		dsi_phy_tst_set(mipi_dsi_base, 0x15, dsi->phy.rg_pll_fbd_p);
> +
> +		/* physical configuration PLL III*/
> +		dsi_phy_tst_set(mipi_dsi_base, 0x16,
> +				(dsi->phy.rg_pll_cp << 5) + (dsi->phy.rg_pll_lpf_cs << 4) +
> +				dsi->phy.rg_pll_refsel);
> +
> +		/* physical configuration PLL IV, N*/
> +		dsi_phy_tst_set(mipi_dsi_base, 0x17, dsi->phy.rg_pll_pre_p);
> +
> +		/* sets the analog characteristic of V reference in D-PHY TX*/
> +		dsi_phy_tst_set(mipi_dsi_base, 0x1D, dsi->phy.rg_vrefsel_vcm);
> +
> +		/* MISC AFE Configuration*/
> +		dsi_phy_tst_set(mipi_dsi_base, 0x1E,
> +				(dsi->phy.rg_pll_cp_p << 5) + (dsi->phy.reload_sel << 4) +
> +				(dsi->phy.rg_phase_gen_en << 3) + (dsi->phy.rg_band_sel << 2) +
> +				(dsi->phy.pll_power_down << 1) + dsi->phy.pll_register_override);
> +
> +		/*reload_command*/
> +		dsi_phy_tst_set(mipi_dsi_base, 0x1F, dsi->phy.load_command);
> +
> +		/* pre_delay of clock lane request setting*/
> +		dsi_phy_tst_set(mipi_dsi_base, 0x20, DSS_REDUCE(dsi->phy.clk_pre_delay));
> +
> +		/* post_delay of clock lane request setting*/
> +		dsi_phy_tst_set(mipi_dsi_base, 0x21, DSS_REDUCE(dsi->phy.clk_post_delay));
> +
> +		/* clock lane timing ctrl - t_lpx*/
> +		dsi_phy_tst_set(mipi_dsi_base, 0x22, DSS_REDUCE(dsi->phy.clk_t_lpx));
> +
> +		/* clock lane timing ctrl - t_hs_prepare*/
> +		dsi_phy_tst_set(mipi_dsi_base, 0x23, DSS_REDUCE(dsi->phy.clk_t_hs_prepare));
> +
> +		/* clock lane timing ctrl - t_hs_zero*/
> +		dsi_phy_tst_set(mipi_dsi_base, 0x24, DSS_REDUCE(dsi->phy.clk_t_hs_zero));
> +
> +		/* clock lane timing ctrl - t_hs_trial*/
> +		dsi_phy_tst_set(mipi_dsi_base, 0x25, dsi->phy.clk_t_hs_trial);
> +
> +		for (i = 0; i <= lanes; i++) {
> +			/* data lane pre_delay*/
> +			tmp = 0x30 + (i << 4);
> +			dsi_phy_tst_set(mipi_dsi_base, tmp, DSS_REDUCE(dsi->phy.data_pre_delay));
> +
> +			/*data lane post_delay*/
> +			tmp = 0x31 + (i << 4);
> +			dsi_phy_tst_set(mipi_dsi_base, tmp, DSS_REDUCE(dsi->phy.data_post_delay));
> +
> +			/* data lane timing ctrl - t_lpx*/
> +			dsi_phy_tst_set(mipi_dsi_base, tmp, DSS_REDUCE(dsi->phy.data_t_lpx));
> +
> +			/* data lane timing ctrl - t_hs_prepare*/
> +			tmp = 0x33 + (i << 4);
> +			dsi_phy_tst_set(mipi_dsi_base, tmp, DSS_REDUCE(dsi->phy.data_t_hs_prepare));
> +
> +			/* data lane timing ctrl - t_hs_zero*/
> +			tmp = 0x34 + (i << 4);
> +			dsi_phy_tst_set(mipi_dsi_base, tmp, DSS_REDUCE(dsi->phy.data_t_hs_zero));
> +
> +			/* data lane timing ctrl - t_hs_trial*/
> +			tmp = 0x35 + (i << 4);
> +			dsi_phy_tst_set(mipi_dsi_base, tmp, DSS_REDUCE(dsi->phy.data_t_hs_trial));
> +
> +			/* data lane timing ctrl - t_ta_go*/
> +			tmp = 0x36 + (i << 4);
> +			dsi_phy_tst_set(mipi_dsi_base, tmp, DSS_REDUCE(dsi->phy.data_t_ta_go));
> +
> +			/* data lane timing ctrl - t_ta_get*/
> +			tmp = 0x37 + (i << 4);
> +			dsi_phy_tst_set(mipi_dsi_base, tmp, DSS_REDUCE(dsi->phy.data_t_ta_get));
> +		}
> +	}
> +
> +	writel(0x00000007, mipi_dsi_base + MIPIDSI_PHY_RSTZ_OFFSET);
> +
> +	is_ready = false;
> +	dw_jiffies = jiffies + HZ / 2;
> +	do {
> +		tmp = readl(mipi_dsi_base + MIPIDSI_PHY_STATUS_OFFSET);
> +		if ((tmp & 0x00000001) == 0x00000001) {
> +			is_ready = true;
> +			break;
> +		}
> +	} while (time_after(dw_jiffies, jiffies));
> +
> +	if (!is_ready) {
> +		DRM_INFO("phylock is not ready!MIPIDSI_PHY_STATUS_OFFSET=0x%x.\n",
> +			 tmp);
> +	}
> +
> +	if (lanes >= DSI_4_LANES)
> +		cmp_stopstate_val = (BIT(4) | BIT(7) | BIT(9) | BIT(11));
> +	else if (lanes >= DSI_3_LANES)
> +		cmp_stopstate_val = (BIT(4) | BIT(7) | BIT(9));
> +	else if (lanes >= DSI_2_LANES)
> +		cmp_stopstate_val = (BIT(4) | BIT(7));
> +	else
> +		cmp_stopstate_val = (BIT(4));
> +
> +	is_ready = false;
> +	dw_jiffies = jiffies + HZ / 2;
> +	do {
> +		tmp = readl(mipi_dsi_base + MIPIDSI_PHY_STATUS_OFFSET);
> +		if ((tmp & cmp_stopstate_val) == cmp_stopstate_val) {
> +			is_ready = true;
> +			break;
> +		}
> +	} while (time_after(dw_jiffies, jiffies));
> +
> +	if (!is_ready) {
> +		DRM_INFO("phystopstateclklane is not ready! MIPIDSI_PHY_STATUS_OFFSET=0x%x.\n",
> +			 tmp);
> +	}
> +
> +	/*************************Configure the DPHY end*************************/
> +
> +	/* phy_stop_wait_time */
> +	set_reg(mipi_dsi_base + MIPIDSI_PHY_IF_CFG_OFFSET, dsi->phy.phy_stop_wait_time, 8, 8);
> +
> +	/*--------------configuring the DPI packet transmission----------------*/
> +
> +	/*
> +	 * 2. Configure the DPI Interface:
> +	 * This defines how the DPI interface interacts with the controller.
> +	 */
> +	set_reg(mipi_dsi_base + MIPIDSI_DPI_VCID_OFFSET, mipi->vc, 2, 0);
> +	set_reg(mipi_dsi_base + MIPIDSI_DPI_COLOR_CODING_OFFSET, mipi->color_mode, 4, 0);
> +
> +	set_reg(mipi_dsi_base + MIPIDSI_DPI_CFG_POL_OFFSET, dsi->ldi.data_en_plr, 1, 0);
> +	set_reg(mipi_dsi_base + MIPIDSI_DPI_CFG_POL_OFFSET, dsi->ldi.vsync_plr, 1, 1);
> +	set_reg(mipi_dsi_base + MIPIDSI_DPI_CFG_POL_OFFSET, dsi->ldi.hsync_plr, 1, 2);
> +	set_reg(mipi_dsi_base + MIPIDSI_DPI_CFG_POL_OFFSET, 0x0, 1, 3);
> +	set_reg(mipi_dsi_base + MIPIDSI_DPI_CFG_POL_OFFSET, 0x0, 1, 4);
> +
> +	/*
> +	 * 3. Select the Video Transmission Mode:
> +	 * This defines how the processor requires the video line to be
> +	 * transported through the DSI link.
> +	 */
> +	/* video mode: low power mode*/
> +	set_reg(mipi_dsi_base + MIPIDSI_VID_MODE_CFG_OFFSET, 0x3f, 6, 8);
> +	/* set_reg(mipi_dsi_base + MIPIDSI_VID_MODE_CFG_OFFSET, 0x0, 1, 14); */
> +
> +	/* TODO: fix blank display bug when set backlight*/
> +	set_reg(mipi_dsi_base + MIPIDSI_DPI_LP_CMD_TIM_OFFSET, 0x4, 8, 16);
> +	/* video mode: send read cmd by lp mode*/
> +	set_reg(mipi_dsi_base + MIPIDSI_VID_MODE_CFG_OFFSET, 0x1, 1, 15);
> +
> +	set_reg(mipi_dsi_base + MIPIDSI_VID_PKT_SIZE_OFFSET, rect.w, 14, 0);
> +
> +	/* burst mode*/
> +	dsi_set_burst_mode(mipi_dsi_base, dsi->client[id].mode_flags);
> +	/* for dsi read, BTA enable*/
> +	set_reg(mipi_dsi_base + MIPIDSI_PCKHDL_CFG_OFFSET, 0x1, 1, 2);
> +
> +	/*
> +	 * 4. Define the DPI Horizontal timing configuration:
> +	 *
> +	 * Hsa_time = HSA*(PCLK period/Clk Lane Byte Period);
> +	 * Hbp_time = HBP*(PCLK period/Clk Lane Byte Period);
> +	 * Hline_time = (HSA+HBP+HACT+HFP)*(PCLK period/Clk Lane Byte Period);
> +	 */
> +	pixel_clk = dsi->cur_mode.clock * 1000;
> +	/*htot = dsi->cur_mode.htotal;*/
> +	/*vtot = dsi->cur_mode.vtotal;*/
> +	dsi->ldi.h_front_porch = dsi->cur_mode.hsync_start - dsi->cur_mode.hdisplay;
> +	dsi->ldi.h_back_porch = dsi->cur_mode.htotal - dsi->cur_mode.hsync_end;
> +	dsi->ldi.h_pulse_width = dsi->cur_mode.hsync_end - dsi->cur_mode.hsync_start;
> +	dsi->ldi.v_front_porch = dsi->cur_mode.vsync_start - dsi->cur_mode.vdisplay;
> +	dsi->ldi.v_back_porch = dsi->cur_mode.vtotal - dsi->cur_mode.vsync_end;
> +	dsi->ldi.v_pulse_width = dsi->cur_mode.vsync_end - dsi->cur_mode.vsync_start;
> +	if (dsi->ldi.v_pulse_width > 15) {
> +		DRM_DEBUG_DRIVER("vsw exceeded 15\n");
> +		dsi->ldi.v_pulse_width = 15;
> +	}
> +	hsa_time = dsi->ldi.h_pulse_width * dsi->phy.lane_byte_clk / pixel_clk;
> +	hbp_time = dsi->ldi.h_back_porch * dsi->phy.lane_byte_clk / pixel_clk;
> +	hline_time = ROUND1((dsi->ldi.h_pulse_width + dsi->ldi.h_back_porch +
> +		rect.w + dsi->ldi.h_front_porch) * dsi->phy.lane_byte_clk, pixel_clk);
> +
> +	DRM_INFO("hsa_time=%d, hbp_time=%d, hline_time=%d\n",
> +		 hsa_time, hbp_time, hline_time);
> +	DRM_INFO("lane_byte_clk=%llu, pixel_clk=%llu\n",
> +		 dsi->phy.lane_byte_clk, pixel_clk);
> +	set_reg(mipi_dsi_base + MIPIDSI_VID_HSA_TIME_OFFSET, hsa_time, 12, 0);
> +	set_reg(mipi_dsi_base + MIPIDSI_VID_HBP_TIME_OFFSET, hbp_time, 12, 0);
> +	set_reg(mipi_dsi_base + MIPIDSI_VID_HLINE_TIME_OFFSET, hline_time, 15, 0);
> +
> +	/* Define the Vertical line configuration*/
> +	set_reg(mipi_dsi_base + MIPIDSI_VID_VSA_LINES_OFFSET,
> +		dsi->ldi.v_pulse_width, 10, 0);
> +	set_reg(mipi_dsi_base + MIPIDSI_VID_VBP_LINES_OFFSET,
> +		dsi->ldi.v_back_porch, 10, 0);
> +	set_reg(mipi_dsi_base + MIPIDSI_VID_VFP_LINES_OFFSET,
> +		dsi->ldi.v_front_porch, 10, 0);
> +	set_reg(mipi_dsi_base + MIPIDSI_VID_VACTIVE_LINES_OFFSET,
> +		rect.h, 14, 0);
> +	set_reg(mipi_dsi_base + MIPIDSI_TO_CNT_CFG_OFFSET,
> +		0x7FF, 16, 0);
> +
> +	/* Configure core's phy parameters*/
> +	set_reg(mipi_dsi_base + MIPIDSI_PHY_TMR_LPCLK_CFG_OFFSET,
> +		dsi->phy.clk_lane_lp2hs_time, 10, 0);
> +	set_reg(mipi_dsi_base + MIPIDSI_PHY_TMR_LPCLK_CFG_OFFSET,
> +		dsi->phy.clk_lane_hs2lp_time, 10, 16);
> +
> +	set_reg(mipi_dsi_base + MIPIDSI_PHY_TMR_RD_CFG_OFFSET,
> +		0x7FFF, 15, 0);
> +	set_reg(mipi_dsi_base + MIPIDSI_PHY_TMR_CFG_OFFSET,
> +		dsi->phy.data_lane_lp2hs_time, 10, 0);
> +	set_reg(mipi_dsi_base + MIPIDSI_PHY_TMR_CFG_OFFSET,
> +		dsi->phy.data_lane_hs2lp_time, 10, 16);
> +
> +	if (ctx->g_dss_version_tag == FB_ACCEL_KIRIN970)  {
> +		//16~19bit:pclk_en, pclk_sel, dpipclk_en, dpipclk_sel
> +		set_reg(mipi_dsi_base + MIPIDSI_CLKMGR_CFG_OFFSET, 0x5, 4, 16);
> +		//0:dphy
> +		set_reg(mipi_dsi_base + KIRIN970_PHY_MODE, 0x0, 1, 0);
> +	}
> +
> +	/* Waking up Core*/
> +	set_reg(mipi_dsi_base + MIPIDSI_PWR_UP_OFFSET, 0x1, 1, 0);
> +}
> +
> +static void dsi_encoder_disable(struct drm_encoder *encoder)
> +{
> +	struct dw_dsi *dsi = encoder_to_dsi(encoder);
> +	struct dsi_hw_ctx *ctx = dsi->ctx;
> +	void __iomem *base = ctx->base;
> +
> +	if (!dsi->enable)
> +		return;
> +
> +	dw_dsi_set_mode(dsi, DSI_COMMAND_MODE);
> +	/* turn off panel's backlight */
> +	if (dsi->panel && drm_panel_disable(dsi->panel))
> +		DRM_ERROR("failed to disable panel\n");
> +
> +	/* turn off panel */
> +	if (dsi->panel && drm_panel_unprepare(dsi->panel))
> +		DRM_ERROR("failed to unprepare panel\n");
> +
> +	writel(0, base + PWR_UP);
> +	writel(0, base + LPCLK_CTRL);
> +	writel(0, base + PHY_RSTZ);
> +	clk_disable_unprepare(ctx->dss_dphy0_ref_clk);
> +	clk_disable_unprepare(ctx->dss_dphy0_cfg_clk);
> +	clk_disable_unprepare(ctx->dss_pclk_dsi0_clk);
> +
> +	dsi->enable = false;
> +}
> +
> +static int mipi_dsi_on_sub1(struct dw_dsi *dsi, char __iomem *mipi_dsi_base,
> +			    u32 id)
> +{
> +	struct dsi_hw_ctx *ctx = dsi->ctx;
> +
> +	WARN_ON(!mipi_dsi_base);
> +
> +	/* mipi init */
> +	dsi_mipi_init(dsi, mipi_dsi_base, id);
> +
> +	/* dsi memory init */
> +	if (ctx->g_dss_version_tag == FB_ACCEL_KIRIN970)
> +		writel(0x02600008, mipi_dsi_base + KIRIN970_DSI_MEM_CTRL);
> +
> +	/* switch to cmd mode */
> +	set_reg(mipi_dsi_base + MIPIDSI_MODE_CFG_OFFSET, 0x1, 1, 0);
> +	/* cmd mode: low power mode */
> +	set_reg(mipi_dsi_base + MIPIDSI_CMD_MODE_CFG_OFFSET, 0x7f, 7, 8);
> +	set_reg(mipi_dsi_base + MIPIDSI_CMD_MODE_CFG_OFFSET, 0xf, 4, 16);
> +	set_reg(mipi_dsi_base + MIPIDSI_CMD_MODE_CFG_OFFSET, 0x1, 1, 24);
> +	/* disable generate High Speed clock */
> +	/* delete? */
> +	set_reg(mipi_dsi_base + MIPIDSI_LPCLK_CTRL_OFFSET, 0x0, 1, 0);
> +
> +	return 0;
> +}
> +
> +static int mipi_dsi_on_sub2(struct dw_dsi *dsi, char __iomem *mipi_dsi_base)
> +{
> +	struct dsi_hw_ctx *ctx = dsi->ctx;
> +
> +	u64 pctrl_dphytx_stopcnt = 0;
> +
> +	WARN_ON(!mipi_dsi_base);
> +
> +	/* switch to video mode */
> +	set_reg(mipi_dsi_base + MIPIDSI_MODE_CFG_OFFSET, 0x0, 1, 0);
> +
> +	/* enable EOTP TX */
> +	set_reg(mipi_dsi_base + MIPIDSI_PCKHDL_CFG_OFFSET, 0x1, 1, 0);
> +
> +	/* enable generate High Speed clock, continue clock */
> +	set_reg(mipi_dsi_base + MIPIDSI_LPCLK_CTRL_OFFSET, 0x1, 2, 0);
> +
> +	if (ctx->g_dss_version_tag == FB_ACCEL_KIRIN970) {
> +		// init: wait DPHY 4 data lane stopstate
> +		pctrl_dphytx_stopcnt = (u64)(dsi->ldi.h_back_porch +
> +			dsi->ldi.h_front_porch + dsi->ldi.h_pulse_width + dsi->cur_mode.hdisplay + 5) *
> +			DEFAULT_PCLK_PCTRL_RATE / (dsi->cur_mode.clock * 1000);
> +		DRM_DEBUG("pctrl_dphytx_stopcnt = %llu\n", pctrl_dphytx_stopcnt);
> +
> +		//FIXME:
> +		writel((u32)pctrl_dphytx_stopcnt, dsi->ctx->pctrl_base + PERI_CTRL29);
> +	}
> +
> +	return 0;
> +}
> +
> +static void dsi_encoder_enable(struct drm_encoder *encoder)
> +{
> +	struct dw_dsi *dsi = encoder_to_dsi(encoder);
> +	struct dsi_hw_ctx *ctx = dsi->ctx;
> +	int ret;
> +
> +	if (dsi->enable)
> +		return;
> +
> +	ret = clk_prepare_enable(ctx->dss_dphy0_ref_clk);
> +	if (ret) {
> +		DRM_ERROR("fail to enable dss_dphy0_ref_clk: %d\n", ret);
> +		return;
> +	}
> +
> +	ret = clk_prepare_enable(ctx->dss_dphy0_cfg_clk);
> +	if (ret) {
> +		DRM_ERROR("fail to enable dss_dphy0_cfg_clk: %d\n", ret);
> +		return;
> +	}
> +
> +	ret = clk_prepare_enable(ctx->dss_pclk_dsi0_clk);
> +	if (ret) {
> +		DRM_ERROR("fail to enable dss_pclk_dsi0_clk: %d\n", ret);
> +		return;
> +	}
> +
> +	mipi_dsi_on_sub1(dsi, ctx->base, dsi->attached_client);
> +
> +	mipi_dsi_on_sub2(dsi, ctx->base);
> +
> +	/* turn on panel */
> +	if (dsi->panel && drm_panel_prepare(dsi->panel))
> +		DRM_ERROR("failed to prepare panel\n");
> +
> +	/*dw_dsi_set_mode(dsi, DSI_VIDEO_MODE);*/
> +
> +	/* turn on panel's back light */
> +	if (dsi->panel && drm_panel_enable(dsi->panel))
> +		DRM_ERROR("failed to enable panel\n");
> +
> +	dsi->enable = true;
> +}
> +
> +static enum drm_mode_status dsi_encoder_mode_valid(struct drm_encoder *encoder,
> +						   const struct drm_display_mode *mode)
> +
> +{
> +	const struct drm_crtc_helper_funcs *crtc_funcs;
> +	struct drm_display_mode adj_mode;
> +	int clock = mode->clock;
> +	struct drm_crtc *crtc;
> +
> +	drm_for_each_crtc(crtc, encoder->dev) {
> +		drm_mode_copy(&adj_mode, mode);
> +
> +		crtc_funcs = crtc->helper_private;
> +		if (crtc_funcs && crtc_funcs->mode_fixup) {
> +			if (!crtc_funcs->mode_fixup(crtc, mode, &adj_mode)) {
> +				DRM_INFO("Discarded mode: %ix%i@%i, clock: %i (adjusted to %i)",
> +					 mode->hdisplay, mode->vdisplay,
> +					 drm_mode_vrefresh(mode),
> +					 mode->clock, clock);
> +
> +				return MODE_BAD;
> +			}
> +			clock = adj_mode.clock;
> +		}
> +	}
> +
> +	DRM_INFO("Valid mode: %ix%i@%i, clock %i (adjusted to %i)",
> +		 mode->hdisplay, mode->vdisplay, drm_mode_vrefresh(mode),
> +		 mode->clock, clock);
> +
> +	return MODE_OK;
> +}
> +
> +static void dsi_encoder_mode_set(struct drm_encoder *encoder,
> +				 struct drm_display_mode *mode,
> +				 struct drm_display_mode *adj_mode)
> +{
> +	struct dw_dsi *dsi = encoder_to_dsi(encoder);
> +
> +	drm_mode_copy(&dsi->cur_mode, adj_mode);
> +}
> +
> +static int dsi_encoder_atomic_check(struct drm_encoder *encoder,
> +				    struct drm_crtc_state *crtc_state,
> +				    struct drm_connector_state *conn_state)
> +{
> +	/* do nothing */
> +	return 0;
> +}
> +
> +static const struct drm_encoder_helper_funcs dw_encoder_helper_funcs = {
> +	.atomic_check	= dsi_encoder_atomic_check,
> +	.mode_valid	= dsi_encoder_mode_valid,
> +	.mode_set	= dsi_encoder_mode_set,
> +	.enable		= dsi_encoder_enable,
> +	.disable	= dsi_encoder_disable
> +};
> +
> +static const struct drm_encoder_funcs dw_encoder_funcs = {
> +	.destroy = drm_encoder_cleanup,
> +};
> +
> +static int dw_drm_encoder_init(struct device *dev,
> +			       struct drm_device *drm_dev,
> +			       struct drm_encoder *encoder,
> +			       struct drm_bridge *bridge)
> +{
> +	int ret;
> +	u32 crtc_mask;
> +
> +	dev_info(dev, "%s:\n", __func__);
> +
> +	/* Link drm_bridge to encoder */
> +	if (!bridge) {
> +		DRM_INFO("no dsi bridge to attach the encoder\n");
> +		return 0;
> +	}
> +
> +	crtc_mask = drm_of_find_possible_crtcs(drm_dev, dev->of_node);
> +	if (!crtc_mask) {
> +		DRM_ERROR("failed to find crtc mask\n");
> +		return -EINVAL;
> +	}
> +
> +	dev_info(dev, "Initializing CRTC encoder: %d\n",
> +		 crtc_mask);
> +
> +	encoder->possible_crtcs = crtc_mask;
> +	encoder->possible_clones = 0;
> +	ret = drm_encoder_init(drm_dev, encoder, &dw_encoder_funcs,
> +			       DRM_MODE_ENCODER_DSI, NULL);
> +	if (ret) {
> +		DRM_ERROR("failed to init dsi encoder\n");
> +		return ret;
> +	}
> +
> +	drm_encoder_helper_add(encoder, &dw_encoder_helper_funcs);
> +
> +	/* associate the bridge to dsi encoder */
> +	ret = drm_bridge_attach(encoder, bridge, NULL, 0);
The bridge should be attached with the falg that tell the bridge NOT to
create a connector.

The display driver shall created the connector.

Please see how other drivers do this (but most driver uses the old
pattern so so look for drm_bridge_attach() with the flag argument.


> +	if (ret) {
> +		DRM_ERROR("failed to attach external bridge\n");
> +		drm_encoder_cleanup(encoder);
> +	}
> +
> +	return ret;
> +}
> +
> +static int dsi_host_attach(struct mipi_dsi_host *host,
> +			   struct mipi_dsi_device *mdsi)
> +{
> +	struct dw_dsi *dsi = host_to_dsi(host);
> +	u32 id = mdsi->channel >= 1 ? OUT_PANEL : OUT_HDMI;
> +
> +	if (mdsi->lanes < 1 || mdsi->lanes > 4) {
> +		DRM_ERROR("dsi device params invalid\n");
> +		return -EINVAL;
> +	}
> +
> +	dsi->client[id].lanes = mdsi->lanes;
> +	dsi->client[id].format = mdsi->format;
> +	dsi->client[id].mode_flags = mdsi->mode_flags;
> +	dsi->client[id].phy_clock = 0;
> +
> +	dsi->attached_client = id;
> +
> +	DRM_INFO("host attach, client name=[%s], id=%d\n", mdsi->name, id);
> +
> +	return 0;
> +}
> +
> +static int dsi_host_detach(struct mipi_dsi_host *host,
> +			   struct mipi_dsi_device *mdsi)
> +{
> +	/* do nothing */
> +	return 0;
> +}
> +
> +static int dsi_gen_pkt_hdr_write(void __iomem *base, u32 val)
> +{
> +	u32 status;
> +	int ret;
> +
> +	ret = readx_poll_timeout(readl, base + CMD_PKT_STATUS, status,
> +				 !(status & GEN_CMD_FULL), 1000,
> +				 CMD_PKT_STATUS_TIMEOUT_US);
> +	if (ret < 0) {
> +		DRM_ERROR("failed to get available command FIFO\n");
> +		return ret;
> +	}
> +
> +	writel(val, base + GEN_HDR);
> +
> +	ret = readx_poll_timeout(readl, base + CMD_PKT_STATUS, status,
> +				 status & (GEN_CMD_EMPTY | GEN_PLD_W_EMPTY),
> +				 1000, CMD_PKT_STATUS_TIMEOUT_US);
> +	if (ret < 0) {
> +		DRM_ERROR("failed to write command FIFO\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int dsi_dcs_short_write(void __iomem *base,
> +			       const struct mipi_dsi_msg *msg)
> +{
> +	const u16 *tx_buf = msg->tx_buf;
> +	u32 val = GEN_HDATA(*tx_buf) | GEN_HTYPE(msg->type);
> +
> +	if (msg->tx_len > 2) {
> +		DRM_ERROR("too long tx buf length %zu for short write\n",
> +			  msg->tx_len);
> +		return -EINVAL;
> +	}
> +
> +	return dsi_gen_pkt_hdr_write(base, val);
> +}
> +
> +static int dsi_dcs_long_write(void __iomem *base,
> +			      const struct mipi_dsi_msg *msg)
> +{
> +	const u32 *tx_buf = msg->tx_buf;
> +	int len = msg->tx_len, pld_data_bytes = sizeof(*tx_buf), ret;
> +	u32 val = GEN_HDATA(msg->tx_len) | GEN_HTYPE(msg->type);
> +	u32 remainder = 0;
> +	u32 status;
> +
> +	if (msg->tx_len < 3) {
> +		DRM_ERROR("wrong tx buf length %zu for long write\n",
> +			  msg->tx_len);
> +		return -EINVAL;
> +	}
> +
> +	while (DIV_ROUND_UP(len, pld_data_bytes)) {
> +		if (len < pld_data_bytes) {
> +			memcpy(&remainder, tx_buf, len);
> +			writel(remainder, base + GEN_PLD_DATA);
> +			len = 0;
> +		} else {
> +			writel(*tx_buf, base + GEN_PLD_DATA);
> +			tx_buf++;
> +			len -= pld_data_bytes;
> +		}
> +
> +		ret = readx_poll_timeout(readl, base + CMD_PKT_STATUS,
> +					 status, !(status & GEN_PLD_W_FULL), 1000,
> +					 CMD_PKT_STATUS_TIMEOUT_US);
> +		if (ret < 0) {
> +			DRM_ERROR("failed to get available write payload FIFO\n");
> +			return ret;
> +		}
> +	}
> +
> +	return dsi_gen_pkt_hdr_write(base, val);
> +}
> +
> +static ssize_t dsi_host_transfer(struct mipi_dsi_host *host,
> +				 const struct mipi_dsi_msg *msg)
> +{
> +	struct dw_dsi *dsi = host_to_dsi(host);
> +	struct dsi_hw_ctx *ctx = dsi->ctx;
> +	void __iomem *base = ctx->base;
> +	int ret;
> +
> +	switch (msg->type) {
> +	case MIPI_DSI_DCS_SHORT_WRITE:
> +	case MIPI_DSI_DCS_SHORT_WRITE_PARAM:
> +	case MIPI_DSI_SET_MAXIMUM_RETURN_PACKET_SIZE:
> +		ret = dsi_dcs_short_write(base, msg);
> +		break;
> +	case MIPI_DSI_DCS_LONG_WRITE:
> +		ret = dsi_dcs_long_write(base, msg);
> +		break;
> +	default:
> +		DRM_ERROR("unsupported message type\n");
> +		ret = -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
> +static const struct mipi_dsi_host_ops dsi_host_ops = {
> +	.attach = dsi_host_attach,
> +	.detach = dsi_host_detach,
> +	.transfer = dsi_host_transfer,
> +};
> +
> +static int dsi_host_init(struct device *dev, struct dw_dsi *dsi)
> +{
> +	struct mipi_dsi_host *host = &dsi->host;
> +	struct mipi_panel_info *mipi = &dsi->mipi;
> +	int ret;
> +
> +	host->dev = dev;
> +	host->ops = &dsi_host_ops;
> +
> +	mipi->max_tx_esc_clk = 10 * 1000000UL;
> +	mipi->vc = 0;
> +	mipi->color_mode = DSI_24BITS_1;
> +	mipi->clk_post_adjust = 120;
> +	mipi->clk_pre_adjust = 0;
> +	mipi->clk_t_hs_prepare_adjust = 0;
> +	mipi->clk_t_lpx_adjust = 0;
> +	mipi->clk_t_hs_trial_adjust = 0;
> +	mipi->clk_t_hs_exit_adjust = 0;
> +	mipi->clk_t_hs_zero_adjust = 0;
> +
> +	dsi->ldi.data_en_plr = 0;
> +	dsi->ldi.vsync_plr = 0;
> +	dsi->ldi.hsync_plr = 0;
> +
> +	ret = mipi_dsi_host_register(host);
> +	if (ret) {
> +		DRM_ERROR("failed to register dsi host\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int dsi_connector_get_modes(struct drm_connector *connector)
> +{
> +	struct dw_dsi *dsi = connector_to_dsi(connector);
> +
> +	return drm_panel_get_modes(dsi->panel, connector);
> +}
> +
> +static enum drm_mode_status
> +dsi_connector_mode_valid(struct drm_connector *connector,
> +			 struct drm_display_mode *mode)
> +{
> +	enum drm_mode_status mode_status = MODE_OK;
> +
> +	return mode_status;
> +}
> +
> +static struct drm_encoder *
> +dsi_connector_best_encoder(struct drm_connector *connector)
> +{
> +	struct dw_dsi *dsi = connector_to_dsi(connector);
> +
> +	return &dsi->encoder;
> +}
> +
> +static const struct drm_connector_helper_funcs dsi_connector_helper_funcs = {
> +	.get_modes = dsi_connector_get_modes,
> +	.mode_valid = dsi_connector_mode_valid,
> +	.best_encoder = dsi_connector_best_encoder,
> +};
> +
> +static enum drm_connector_status
> +dsi_connector_detect(struct drm_connector *connector, bool force)
> +{
> +	struct dw_dsi *dsi = connector_to_dsi(connector);
> +	enum drm_connector_status status;
> +
> +	status = dsi->cur_client == OUT_PANEL ?	connector_status_connected :
> +		connector_status_disconnected;
> +
> +	return status;
> +}
> +
> +static void dsi_connector_destroy(struct drm_connector *connector)
> +{
> +	drm_connector_unregister(connector);
> +	drm_connector_cleanup(connector);
> +}
> +
> +static struct drm_connector_funcs dsi_atomic_connector_funcs = {
> +	.fill_modes = drm_helper_probe_single_connector_modes,
> +	.detect = dsi_connector_detect,
> +	.destroy = dsi_connector_destroy,
> +	.reset = drm_atomic_helper_connector_reset,
> +	.atomic_duplicate_state = drm_atomic_helper_connector_duplicate_state,
> +	.atomic_destroy_state = drm_atomic_helper_connector_destroy_state,
> +};
> +
> +static int dsi_connector_init(struct drm_device *dev, struct dw_dsi *dsi)
> +{
> +	struct drm_encoder *encoder = &dsi->encoder;
> +	struct drm_connector *connector = &dsi->connector;
> +	int ret;
> +
> +	connector->polled = DRM_CONNECTOR_POLL_HPD;
> +	drm_connector_helper_add(connector,
> +				 &dsi_connector_helper_funcs);
> +
> +	ret = drm_connector_init(dev, &dsi->connector,
> +				 &dsi_atomic_connector_funcs,
> +				 DRM_MODE_CONNECTOR_DSI);
> +	if (ret)
> +		return ret;
> +
> +	dev_info(dev->dev, "Attaching CRTC encoder\n");
> +	ret = drm_connector_attach_encoder(connector, encoder);
> +	if (ret)
> +		return ret;
> +
> +	ret = drm_panel_attach(dsi->panel, connector);
> +	if (ret)
> +		return ret;
> +
> +	drm_connector_register(&dsi->connector);
> +
> +	DRM_INFO("connector init\n");
> +	return 0;
> +}
> +
> +static int dsi_bind(struct device *dev, struct device *master, void *data)
> +{
> +	struct dsi_data *ddata = dev_get_drvdata(dev);
> +	struct dw_dsi *dsi = &ddata->dsi;
> +	struct drm_device *drm_dev = data;
> +	int ret;
> +
> +	DRM_INFO("dsi_bind\n");
> +
> +	ret = dw_drm_encoder_init(dev, drm_dev, &dsi->encoder,
> +				  dsi->bridge);
> +	if (ret)
> +		return ret;
> +
> +	if (dsi->panel) {
> +		ret = dsi_connector_init(drm_dev, dsi);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static void dsi_unbind(struct device *dev, struct device *master, void *data)
> +{
> +	/* do nothing */
> +}
> +
> +static const struct component_ops dsi_ops = {
> +	.bind	= dsi_bind,
> +	.unbind	= dsi_unbind,
> +};
> +
> +static int dsi_parse_bridge_endpoint(struct dw_dsi *dsi,
> +				     struct device_node *endpoint)
> +{
> +	struct device_node *bridge_node;
> +	struct drm_bridge *bridge;
> +
> +	bridge_node = of_graph_get_remote_port_parent(endpoint);
> +	if (!bridge_node) {
> +		DRM_ERROR("no valid bridge node\n");
> +		return -ENODEV;
> +	}
> +	of_node_put(bridge_node);
> +
> +	bridge = of_drm_find_bridge(bridge_node);
> +	if (!bridge) {
> +		DRM_INFO("wait for external HDMI bridge driver.\n");
> +		return -EPROBE_DEFER;
> +	}
> +	dsi->bridge = bridge;
> +
> +	return 0;
> +}
> +
> +static int dsi_parse_panel_endpoint(struct dw_dsi *dsi,
> +				    struct device_node *endpoint)
> +{
> +	struct device_node *panel_node;
> +	struct drm_panel *panel;
> +
> +	panel_node = of_graph_get_remote_port_parent(endpoint);
> +	if (!panel_node) {
> +		DRM_ERROR("no valid panel node\n");
> +		return -ENODEV;
> +	}
> +	of_node_put(panel_node);
> +
> +	panel = of_drm_find_panel(panel_node);
> +	if (!panel) {
> +		DRM_DEBUG_DRIVER("skip this panel endpoint.\n");
> +		return 0;
> +	}
> +	dsi->panel = panel;
> +
> +	return 0;
> +}
> +
> +static int dsi_parse_endpoint(struct dw_dsi *dsi,
> +			      struct device_node *np,
> +			      enum dsi_output_client client)
> +{
> +	struct device_node *ep_node;
> +	struct of_endpoint ep;
> +	int ret = 0;
> +
> +	if (client == OUT_MAX)
> +		return -EINVAL;
> +
> +	for_each_endpoint_of_node(np, ep_node) {
> +		ret = of_graph_parse_endpoint(ep_node, &ep);
> +		if (ret) {
> +			of_node_put(ep_node);
> +			return ret;
> +		}
> +
> +		/* skip dsi input port, port == 0 is input port */
> +		if (ep.port == 0)
> +			continue;
> +
> +		/* parse bridge endpoint */
> +		if (client == OUT_HDMI) {
> +			if (ep.id == 0) {
> +				ret = dsi_parse_bridge_endpoint(dsi, ep_node);
> +				if (dsi->bridge)
> +					break;
> +			}
> +		} else { /* parse panel endpoint */
> +			if (ep.id > 0) {
> +				ret = dsi_parse_panel_endpoint(dsi, ep_node);
> +				if (dsi->panel)
> +					break;
> +			}
> +		}
> +
> +		if (ret) {
> +			of_node_put(ep_node);
> +			return ret;
> +		}
> +	}
> +
> +	if (!dsi->bridge && !dsi->panel) {
> +		DRM_ERROR("at least one bridge or panel node is required\n");
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +
> +static int dsi_parse_dt(struct platform_device *pdev, struct dw_dsi *dsi)
> +{
> +	struct dsi_hw_ctx *ctx = dsi->ctx;
> +	const char *compatible;
> +	int ret = 0;
> +	struct device_node *np = NULL;
> +	if (ctx->g_dss_version_tag == FB_ACCEL_KIRIN970)
> +		compatible = "hisilicon,kirin970-dsi";
> +	else
> +		compatible = "hisilicon,kirin960-dsi";
> +
> +	np = of_find_compatible_node(NULL, NULL, compatible);
> +	if (!np) {
> +		DRM_ERROR("NOT FOUND device node %s!\n", compatible);
> +		return -ENXIO;
> +	}
> +
> +	ctx->base = of_iomap(np, 0);
> +	if (!(ctx->base)) {
> +		DRM_ERROR("failed to get dsi base resource.\n");
> +		return -ENXIO;
> +	}
> +
> +	ctx->peri_crg_base = of_iomap(np, 1);
> +	if (!(ctx->peri_crg_base)) {
> +		DRM_ERROR("failed to get peri_crg_base resource.\n");
> +		return -ENXIO;
> +	}
> +
> +	if (ctx->g_dss_version_tag == FB_ACCEL_KIRIN970) {
> +		ctx->pctrl_base = of_iomap(np, 2);
> +		if (!(ctx->pctrl_base)) {
> +			DRM_ERROR("failed to get dss pctrl_base resource.\n");
> +			return -ENXIO;
> +		}
> +	}
> +
> +	dsi->gpio_mux = devm_gpiod_get(&pdev->dev, "mux", GPIOD_OUT_HIGH);
> +	if (IS_ERR(dsi->gpio_mux))
> +		return PTR_ERR(dsi->gpio_mux);
> +
> +	/* set dsi default output to panel */
> +	dsi->cur_client = OUT_PANEL;
> +	dsi->attached_client = dsi->cur_client;
> +
> +	DRM_INFO("dsi  cur_client is %d  <0->hdmi;1->panel>\n", dsi->cur_client);
> +	/*dis-reset*/
> +	/*ip_reset_dis_dsi0, ip_reset_dis_dsi1*/
> +	writel(0x30000000, ctx->peri_crg_base + PERRSTDIS3);
> +
> +	ctx->dss_dphy0_ref_clk = devm_clk_get(&pdev->dev, "clk_txdphy0_ref");
> +	if (IS_ERR(ctx->dss_dphy0_ref_clk)) {
> +		DRM_ERROR("failed to get dss_dphy0_ref_clk clock\n");
> +		return PTR_ERR(ctx->dss_dphy0_ref_clk);
> +	}
> +
> +	ret = clk_set_rate(ctx->dss_dphy0_ref_clk, DEFAULT_MIPI_CLK_RATE);
> +	if (ret < 0) {
> +		DRM_ERROR("dss_dphy0_ref_clk clk_set_rate(%lu) failed, error=%d!\n",
> +			  DEFAULT_MIPI_CLK_RATE, ret);
> +		return -EINVAL;
> +	}
> +
> +	DRM_DEBUG("dss_dphy0_ref_clk:[%lu]->[%lu].\n",
> +		  DEFAULT_MIPI_CLK_RATE, clk_get_rate(ctx->dss_dphy0_ref_clk));
> +
> +	ctx->dss_dphy0_cfg_clk = devm_clk_get(&pdev->dev, "clk_txdphy0_cfg");
> +	if (IS_ERR(ctx->dss_dphy0_cfg_clk)) {
> +		DRM_ERROR("failed to get dss_dphy0_cfg_clk clock\n");
> +		return PTR_ERR(ctx->dss_dphy0_cfg_clk);
> +	}
> +
> +	ret = clk_set_rate(ctx->dss_dphy0_cfg_clk, DEFAULT_MIPI_CLK_RATE);
> +	if (ret < 0) {
> +		DRM_ERROR("dss_dphy0_cfg_clk clk_set_rate(%lu) failed, error=%d!\n",
> +			  DEFAULT_MIPI_CLK_RATE, ret);
> +		return -EINVAL;
> +	}
> +
> +	DRM_DEBUG("dss_dphy0_cfg_clk:[%lu]->[%lu].\n",
> +		  DEFAULT_MIPI_CLK_RATE, clk_get_rate(ctx->dss_dphy0_cfg_clk));
> +
> +	ctx->dss_pclk_dsi0_clk = devm_clk_get(&pdev->dev, "pclk_dsi0");
> +	if (IS_ERR(ctx->dss_pclk_dsi0_clk)) {
> +		DRM_ERROR("failed to get dss_pclk_dsi0_clk clock\n");
> +		return PTR_ERR(ctx->dss_pclk_dsi0_clk);
> +	}
> +
> +	return 0;
> +}
> +
> +static int dsi_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct device *dev = &pdev->dev;
> +	struct dsi_data *data;
> +	struct dw_dsi *dsi;
> +	struct dsi_hw_ctx *ctx;
> +	int ret;
> +
> +	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
> +	if (!data) {
> +		DRM_ERROR("failed to allocate dsi data.\n");
> +		return -ENOMEM;
> +	}
> +	dsi = &data->dsi;
> +	ctx = &data->ctx;
> +	dsi->ctx = ctx;
> +
> +	ctx->g_dss_version_tag = (long)of_device_get_match_data(dev);
> +
> +	/* parse HDMI bridge endpoint */
> +	ret = dsi_parse_endpoint(dsi, np, OUT_HDMI);
> +	if (ret)
> +		return ret;
> +
> +	ret = dsi_host_init(dev, dsi);
> +	if (ret)
> +		return ret;
> +
> +	/* parse panel endpoint */
> +	ret = dsi_parse_endpoint(dsi, np, OUT_PANEL);
> +	if (ret)
> +		goto err_host_unregister;
> +
> +	ret = dsi_parse_dt(pdev, dsi);
> +	if (ret)
> +		goto err_host_unregister;
> +
> +	platform_set_drvdata(pdev, data);
> +
> +	ret = component_add(dev, &dsi_ops);
> +	if (ret)
> +		goto err_host_unregister;
> +
> +	return 0;
> +
> +err_host_unregister:
> +	mipi_dsi_host_unregister(&dsi->host);
> +	return ret;
> +}
> +
> +static int dsi_remove(struct platform_device *pdev)
> +{
> +	component_del(&pdev->dev, &dsi_ops);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id dsi_of_match[] = {
> +	{
> +		.compatible = "hisilicon,kirin960-dsi",
> +		.data = (void *)FB_ACCEL_HI366x
> +	}, {
> +		.compatible = "hisilicon,kirin970-dsi",
> +		.data = (void *)FB_ACCEL_KIRIN970
> +	},
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, dsi_of_match);
> +
> +static struct platform_driver dsi_driver = {
> +	.probe = dsi_probe,
> +	.remove = dsi_remove,
> +	.driver = {
> +		.name = "kirin9xx-dw-dsi",
> +		.of_match_table = dsi_of_match,
> +	},
> +};
> +
> +module_platform_driver(dsi_driver);
> +
> +MODULE_DESCRIPTION("DesignWare MIPI DSI Host Controller v1.02 driver");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/staging/hikey9xx/gpu/kirin9xx_dw_dsi_reg.h b/drivers/staging/hikey9xx/gpu/kirin9xx_dw_dsi_reg.h
> new file mode 100644
> index 000000000000..c22f237a1262
> --- /dev/null
> +++ b/drivers/staging/hikey9xx/gpu/kirin9xx_dw_dsi_reg.h
> @@ -0,0 +1,146 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (c) 2016 Linaro Limited.
> + * Copyright (c) 2014-2016 Hisilicon Limited.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#ifndef __DW_DSI_REG_H__
> +#define __DW_DSI_REG_H__
> +
> +#define MASK(x)				(BIT(x) - 1)
> +#define DEFAULT_MAX_TX_ESC_CLK	(10 * 1000000UL)
> +/*
> + * regs
> + */
> +#define PWR_UP                  0x04  /* Core power-up */
> +#define RESET                   0
> +#define POWERUP                 BIT(0)
> +#define PHY_IF_CFG              0xA4  /* D-PHY interface configuration */
> +#define CLKMGR_CFG              0x08  /* the internal clock dividers */
> +#define PHY_RSTZ                0xA0  /* D-PHY reset control */
> +#define PHY_ENABLECLK           BIT(2)
> +#define PHY_UNRSTZ              BIT(1)
> +#define PHY_UNSHUTDOWNZ         BIT(0)
> +#define PHY_TST_CTRL0           0xB4  /* D-PHY test interface control 0 */
> +#define PHY_TST_CTRL1           0xB8  /* D-PHY test interface control 1 */
> +#define CLK_TLPX                0x10
> +#define CLK_THS_PREPARE         0x11
> +#define CLK_THS_ZERO            0x12
> +#define CLK_THS_TRAIL           0x13
> +#define CLK_TWAKEUP             0x14
> +#define DATA_TLPX(x)            (0x20 + ((x) << 4))
> +#define DATA_THS_PREPARE(x)     (0x21 + ((x) << 4))
> +#define DATA_THS_ZERO(x)        (0x22 + ((x) << 4))
> +#define DATA_THS_TRAIL(x)       (0x23 + ((x) << 4))
> +#define DATA_TTA_GO(x)          (0x24 + ((x) << 4))
> +#define DATA_TTA_GET(x)         (0x25 + ((x) << 4))
> +#define DATA_TWAKEUP(x)         (0x26 + ((x) << 4))
> +#define PHY_CFG_I               0x60
> +#define PHY_CFG_PLL_I           0x63
> +#define PHY_CFG_PLL_II          0x64
> +#define PHY_CFG_PLL_III         0x65
> +#define PHY_CFG_PLL_IV          0x66
> +#define PHY_CFG_PLL_V           0x67
> +#define DPI_COLOR_CODING        0x10  /* DPI color coding */
> +#define DPI_CFG_POL             0x14  /* DPI polarity configuration */
> +#define VID_HSA_TIME            0x48  /* Horizontal Sync Active time */
> +#define VID_HBP_TIME            0x4C  /* Horizontal Back Porch time */
> +#define VID_HLINE_TIME          0x50  /* Line time */
> +#define VID_VSA_LINES           0x54  /* Vertical Sync Active period */
> +#define VID_VBP_LINES           0x58  /* Vertical Back Porch period */
> +#define VID_VFP_LINES           0x5C  /* Vertical Front Porch period */
> +#define VID_VACTIVE_LINES       0x60  /* Vertical resolution */
> +#define VID_PKT_SIZE            0x3C  /* Video packet size */
> +#define VID_MODE_CFG            0x38  /* Video mode configuration */
> +#define GEN_HDR			0x6c
> +#define GEN_HDATA(data)		(((data) & 0xffff) << 8)
> +#define GEN_HDATA_MASK		(0xffff << 8)
> +#define GEN_HTYPE(type)		(((type) & 0xff) << 0)
> +#define GEN_HTYPE_MASK		0xff
> +#define GEN_PLD_DATA		0x70
> +#define CMD_PKT_STATUS		0x74
> +#define GEN_CMD_EMPTY		BIT(0)
> +#define GEN_CMD_FULL		BIT(1)
> +#define GEN_PLD_W_EMPTY		BIT(2)
> +#define GEN_PLD_W_FULL		BIT(3)
> +#define GEN_PLD_R_EMPTY		BIT(4)
> +#define GEN_PLD_R_FULL		BIT(5)
> +#define GEN_RD_CMD_BUSY		BIT(6)
> +#define CMD_MODE_CFG		0x68
> +#define MAX_RD_PKT_SIZE_LP	BIT(24)
> +#define DCS_LW_TX_LP		BIT(19)
> +#define DCS_SR_0P_TX_LP		BIT(18)
> +#define DCS_SW_1P_TX_LP		BIT(17)
> +#define DCS_SW_0P_TX_LP		BIT(16)
> +#define GEN_LW_TX_LP		BIT(14)
> +#define GEN_SR_2P_TX_LP		BIT(13)
> +#define GEN_SR_1P_TX_LP		BIT(12)
> +#define GEN_SR_0P_TX_LP		BIT(11)
> +#define GEN_SW_2P_TX_LP		BIT(10)
> +#define GEN_SW_1P_TX_LP		BIT(9)
> +#define GEN_SW_0P_TX_LP		BIT(8)
> +#define EN_ACK_RQST		BIT(1)
> +#define EN_TEAR_FX		BIT(0)
> +#define CMD_MODE_ALL_LP		(MAX_RD_PKT_SIZE_LP | \
> +				 DCS_LW_TX_LP | \
> +				 DCS_SR_0P_TX_LP | \
> +				 DCS_SW_1P_TX_LP | \
> +				 DCS_SW_0P_TX_LP | \
> +				 GEN_LW_TX_LP | \
> +				 GEN_SR_2P_TX_LP | \
> +				 GEN_SR_1P_TX_LP | \
> +				 GEN_SR_0P_TX_LP | \
> +				 GEN_SW_2P_TX_LP | \
> +				 GEN_SW_1P_TX_LP | \
> +				 GEN_SW_0P_TX_LP)
> +#define PHY_TMR_CFG             0x9C  /* Data lanes timing configuration */
> +#define BTA_TO_CNT              0x8C  /* Response timeout definition */
> +#define PHY_TMR_LPCLK_CFG       0x98  /* clock lane timing configuration */
> +#define CLK_DATA_TMR_CFG        0xCC
> +#define LPCLK_CTRL              0x94  /* Low-power in clock lane */
> +#define PHY_TXREQUESTCLKHS      BIT(0)
> +#define MODE_CFG                0x34  /* Video or Command mode selection */
> +#define PHY_STATUS              0xB0  /* D-PHY PPI status interface */
> +
> +#define	PHY_STOP_WAIT_TIME      0x30
> +#define CMD_PKT_STATUS_TIMEOUT_US	20000
> +
> +/*
> + * regs relevant enum
> + */
> +enum dpi_color_coding {
> +	DSI_24BITS_1 = 5,
> +};
> +
> +enum dsi_video_mode_type {
> +	DSI_NON_BURST_SYNC_PULSES = 0,
> +	DSI_NON_BURST_SYNC_EVENTS,
> +	DSI_BURST_SYNC_PULSES_1,
> +	DSI_BURST_SYNC_PULSES_2
> +};
> +
> +enum dsi_work_mode {
> +	DSI_VIDEO_MODE = 0,
> +	DSI_COMMAND_MODE
> +};
> +
> +/*
> + * Register Write/Read Helper functions
> + */
> +static inline void dw_update_bits(void __iomem *addr, u32 bit_start,
> +				  u32 mask, u32 val)
> +{
> +	u32 tmp, orig;
> +
> +	orig = readl(addr);
> +	tmp = orig & ~(mask << bit_start);
> +	tmp |= (val & mask) << bit_start;
> +	writel(tmp, addr);
> +}
> +
> +#endif /* __DW_DRM_DSI_H__ */
> diff --git a/drivers/staging/hikey9xx/gpu/kirin9xx_fb_panel.h b/drivers/staging/hikey9xx/gpu/kirin9xx_fb_panel.h
> new file mode 100644
> index 000000000000..2ebf4dd9f09e
> --- /dev/null
> +++ b/drivers/staging/hikey9xx/gpu/kirin9xx_fb_panel.h
> @@ -0,0 +1,191 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (c) 2013-2014, Hisilicon Tech. Co., Ltd. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
> + * GNU General Public License for more details.
> + */
> +#ifndef KIRIN_FB_PANEL_H
> +#define KIRIN_FB_PANEL_H
> +
> +/* dts initial */
> +#define DTS_FB_RESOURCE_INIT_READY	BIT(0)
> +#define DTS_PWM_READY	BIT(1)
> +/* #define DTS_BLPWM_READY	BIT(2) */
> +#define DTS_SPI_READY	BIT(3)
> +#define DTS_PANEL_PRIMARY_READY	BIT(4)
> +#define DTS_PANEL_EXTERNAL_READY	BIT(5)
> +#define DTS_PANEL_OFFLINECOMPOSER_READY	BIT(6)
> +#define DTS_PANEL_WRITEBACK_READY	BIT(7)
> +#define DTS_PANEL_MEDIACOMMON_READY	 BIT(8)
> +
> +/* device name */
> +#define DEV_NAME_DSS_DPE		"dss_dpe"
> +#define DEV_NAME_SPI			"spi_dev0"
> +#define DEV_NAME_HDMI			"hdmi"
> +#define DEV_NAME_DP				"dp"
> +#define DEV_NAME_MIPI2RGB		"mipi2rgb"
> +#define DEV_NAME_RGB2MIPI		"rgb2mipi"
> +#define DEV_NAME_MIPIDSI		"mipi_dsi"
> +#define DEV_NAME_FB				"hisi_fb"
> +#define DEV_NAME_PWM			"hisi_pwm"
> +#define DEV_NAME_BLPWM			"hisi_blpwm"
> +#define DEV_NAME_LCD_BKL		"lcd_backlight0"
> +
> +/* vcc name */
> +#define REGULATOR_PDP_NAME	"ldo3"
> +
> +/* irq name */
> +#define IRQ_PDP_NAME	"irq_pdp"
> +#define IRQ_SDP_NAME	"irq_sdp"
> +#define IRQ_ADP_NAME	"irq_adp"
> +#define IRQ_MDC_NAME	"irq_mdc"
> +#define IRQ_DSI0_NAME	"irq_dsi0"
> +#define IRQ_DSI1_NAME	"irq_dsi1"
> +
> +/* dts compatible */
> +#define DTS_COMP_FB_NAME	"hisilicon,hisifb"
> +#define DTS_COMP_PWM_NAME	"hisilicon,hisipwm"
> +#define DTS_COMP_BLPWM_NAME	"hisilicon,hisiblpwm"
> +#define DTS_PATH_LOGO_BUFFER	"/reserved-memory/logo-buffer"
> +
> +/* lcd resource name */
> +#define LCD_BL_TYPE_NAME	"lcd-bl-type"
> +#define FPGA_FLAG_NAME "fpga_flag"
> +#define LCD_DISPLAY_TYPE_NAME	"lcd-display-type"
> +#define LCD_IFBC_TYPE_NAME	"lcd-ifbc-type"
> +
> +/* backlight type */
> +#define BL_SET_BY_NONE	BIT(0)
> +#define BL_SET_BY_PWM	BIT(1)
> +#define BL_SET_BY_BLPWM	BIT(2)
> +#define BL_SET_BY_MIPI	BIT(3)
> +#define BL_SET_BY_SH_BLPWM	BIT(4)
> +
> +/* supported display effect type */
> +#define COMFORM_MODE			BIT(0)
> +#define ACM_COLOR_ENHANCE_MODE	BIT(1)
> +#define IC_COLOR_ENHANCE_MODE	BIT(2)
> +#define CINEMA_MODE				BIT(3)
> +#define VR_MODE                     BIT(4)
> +#define FPS_30_60_SENCE_MODE   BIT(5)
> +#define LED_RG_COLOR_TEMP_MODE	BIT(16)
> +#define GAMMA_MAP    BIT(19)
> +
> +#define LCD_BL_IC_NAME_MAX	(50)
> +
> +#define DEV_DSS_VOLTAGE_ID (20)
> +
> +enum MIPI_LP11_MODE {
> +	MIPI_NORMAL_LP11 = 0,
> +	MIPI_SHORT_LP11 = 1,
> +	MIPI_DISABLE_LP11 = 2,
> +};
> +
> +/* resource desc */
> +struct resource_desc {
> +	u32 flag;
> +	char *name;
> +	u32 *value;
> +};
> +
> +/* dtype for vcc */
> +enum {
> +	DTYPE_VCC_GET,
> +	DTYPE_VCC_PUT,
> +	DTYPE_VCC_ENABLE,
> +	DTYPE_VCC_DISABLE,
> +	DTYPE_VCC_SET_VOLTAGE,
> +};
> +
> +/* vcc desc */
> +struct vcc_desc {
> +	int dtype;
> +	char *id;
> +	struct regulator **regulator;
> +	int min_uV;
> +	int max_uV;
> +	int waittype;
> +	int wait;
> +};
> +
> +/* pinctrl operation */
> +enum {
> +	DTYPE_PINCTRL_GET,
> +	DTYPE_PINCTRL_STATE_GET,
> +	DTYPE_PINCTRL_SET,
> +	DTYPE_PINCTRL_PUT,
> +};
> +
> +/* pinctrl state */
> +enum {
> +	DTYPE_PINCTRL_STATE_DEFAULT,
> +	DTYPE_PINCTRL_STATE_IDLE,
> +};
> +
> +/* pinctrl data */
> +struct pinctrl_data {
> +	struct pinctrl *p;
> +	struct pinctrl_state *pinctrl_def;
> +	struct pinctrl_state *pinctrl_idle;
> +};
> +
> +struct pinctrl_cmd_desc {
> +	int dtype;
> +	struct pinctrl_data *pctrl_data;
> +	int mode;
> +};
> +
> +/* dtype for gpio */
> +enum {
> +	DTYPE_GPIO_REQUEST,
> +	DTYPE_GPIO_FREE,
> +	DTYPE_GPIO_INPUT,
> +	DTYPE_GPIO_OUTPUT,
> +};
> +
> +/* gpio desc */
> +struct gpio_desc {
> +	int dtype;
> +	int waittype;
> +	int wait;
> +	char *label;
> +	u32 *gpio;
> +	int value;
> +};
> +
> +enum bl_control_mode {
> +	REG_ONLY_MODE = 1,
> +	PWM_ONLY_MODE,
> +	MUTI_THEN_RAMP_MODE,
> +	RAMP_THEN_MUTI_MODE,
> +	I2C_ONLY_MODE = 6,
> +	BLPWM_AND_CABC_MODE,
> +	COMMON_IC_MODE = 8,
> +};
> +
> +/*
> + * FUNCTIONS PROTOTYPES
> + */
> +#define MIPI_DPHY_NUM	(2)
> +
> +extern u32 g_dts_resource_ready;
> +
> +int resource_cmds_tx(struct platform_device *pdev,
> +		     struct resource_desc *cmds, int cnt);
> +int vcc_cmds_tx(struct platform_device *pdev, struct vcc_desc *cmds, int cnt);
> +int pinctrl_cmds_tx(struct platform_device *pdev, struct pinctrl_cmd_desc *cmds, int cnt);
> +int gpio_cmds_tx(struct gpio_desc *cmds, int cnt);
> +extern struct spi_device *g_spi_dev;
> +int hisi_pwm_set_backlight(struct backlight_device *bl, uint32_t bl_level);
> +
> +int hisi_pwm_off(void);
> +int hisi_pwm_on(void);
> +
> +#endif /* KIRIN_FB_PANEL_H */
> diff --git a/drivers/staging/hikey9xx/gpu/kirin9xx_pwm.c b/drivers/staging/hikey9xx/gpu/kirin9xx_pwm.c
> new file mode 100644
> index 000000000000..d686664b8627
> --- /dev/null
> +++ b/drivers/staging/hikey9xx/gpu/kirin9xx_pwm.c
> @@ -0,0 +1,404 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2013-2014, Hisilicon Tech. Co., Ltd. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
> + * GNU General Public License for more details.
> + *
> + */
> +#include <drm/drm_drv.h>
> +#include <drm/drm_mipi_dsi.h>
> +
> +#include <linux/clk.h>
> +#include <linux/regmap.h>
> +#include <linux/reset.h>
> +#include <linux/of_address.h>
> +#include <linux/of.h>
> +#include <linux/of_irq.h>
> +#include <linux/pinctrl/consumer.h>
> +
> +#include "kirin9xx_drm_dpe_utils.h"
> +#include "kirin9xx_fb_panel.h"
> +#include "kirin9xx_dw_dsi_reg.h"
> +
> +#include "kirin9xx_dpe.h"
> +
> +/* default pwm clk */
> +#define DEFAULT_PWM_CLK_RATE	(80 * 1000000L)
> +
> +static char __iomem *hisifd_pwm_base;
> +static char __iomem *hisi_peri_crg_base;
> +static struct clk *g_pwm_clk;
> +static struct platform_device *g_pwm_pdev;
> +static int g_pwm_on;
> +
> +static struct pinctrl_data pwmpctrl;
> +
> +static struct pinctrl_cmd_desc pwm_pinctrl_init_cmds[] = {
> +	{DTYPE_PINCTRL_GET, &pwmpctrl, 0},
> +	{DTYPE_PINCTRL_STATE_GET, &pwmpctrl, DTYPE_PINCTRL_STATE_DEFAULT},
> +	{DTYPE_PINCTRL_STATE_GET, &pwmpctrl, DTYPE_PINCTRL_STATE_IDLE},
> +};
> +
> +static struct pinctrl_cmd_desc pwm_pinctrl_normal_cmds[] = {
> +	{DTYPE_PINCTRL_SET, &pwmpctrl, DTYPE_PINCTRL_STATE_DEFAULT},
> +};
> +
> +static struct pinctrl_cmd_desc pwm_pinctrl_lowpower_cmds[] = {
> +	{DTYPE_PINCTRL_SET, &pwmpctrl, DTYPE_PINCTRL_STATE_IDLE},
> +};
> +
> +static struct pinctrl_cmd_desc pwm_pinctrl_finit_cmds[] = {
> +	{DTYPE_PINCTRL_PUT, &pwmpctrl, 0},
> +};
> +
> +#define PWM_LOCK_OFFSET	(0x0000)
> +#define PWM_CTL_OFFSET	(0X0004)
> +#define PWM_CFG_OFFSET	(0x0008)
> +#define PWM_PR0_OFFSET	(0x0100)
> +#define PWM_PR1_OFFSET	(0x0104)
> +#define PWM_C0_MR_OFFSET	(0x0300)
> +#define PWM_C0_MR0_OFFSET	(0x0304)
> +
> +#define PWM_OUT_PRECISION	(800)
> +
> +int pinctrl_cmds_tx(struct platform_device *pdev, struct pinctrl_cmd_desc *cmds, int cnt)
> +{
> +	int ret = 0;
> +
> +	int i = 0;
> +	struct pinctrl_cmd_desc *cm = NULL;
> +
> +	cm = cmds;
> +
> +	for (i = 0; i < cnt; i++) {
> +		if (!cm) {
> +			DRM_ERROR("cm is null! index=%d\n", i);
> +			continue;
> +		}
> +
> +		if (cm->dtype == DTYPE_PINCTRL_GET) {
> +			if (!pdev) {
> +				DRM_ERROR("pdev is NULL");
> +				return -EINVAL;
> +			}
> +			cm->pctrl_data->p = devm_pinctrl_get(&pdev->dev);
> +			if (IS_ERR(cm->pctrl_data->p)) {
> +				ret = -1;
> +				DRM_ERROR("failed to get p, index=%d!\n", i);
> +				goto err;
> +			}
> +		} else if (cm->dtype == DTYPE_PINCTRL_STATE_GET) {
> +			if (cm->mode == DTYPE_PINCTRL_STATE_DEFAULT) {
> +				cm->pctrl_data->pinctrl_def = pinctrl_lookup_state(cm->pctrl_data->p, PINCTRL_STATE_DEFAULT);
> +				if (IS_ERR(cm->pctrl_data->pinctrl_def)) {
> +					ret = -1;
> +					DRM_ERROR("failed to get pinctrl_def, index=%d!\n", i);
> +					goto err;
> +				}
> +			} else if (cm->mode == DTYPE_PINCTRL_STATE_IDLE) {
> +				cm->pctrl_data->pinctrl_idle = pinctrl_lookup_state(cm->pctrl_data->p, PINCTRL_STATE_IDLE);
> +				if (IS_ERR(cm->pctrl_data->pinctrl_idle)) {
> +					ret = -1;
> +					DRM_ERROR("failed to get pinctrl_idle, index=%d!\n", i);
> +					goto err;
> +				}
> +			} else {
> +				ret = -1;
> +				DRM_ERROR("unknown pinctrl type to get!\n");
> +				goto err;
> +			}
> +		} else if (cm->dtype == DTYPE_PINCTRL_SET) {
> +			if (cm->mode == DTYPE_PINCTRL_STATE_DEFAULT) {
> +				if (cm->pctrl_data->p && cm->pctrl_data->pinctrl_def) {
> +					ret = pinctrl_select_state(cm->pctrl_data->p, cm->pctrl_data->pinctrl_def);
> +					if (ret) {
> +						DRM_ERROR("could not set this pin to default state!\n");
> +						ret = -1;
> +						goto err;
> +					}
> +				}
> +			} else if (cm->mode == DTYPE_PINCTRL_STATE_IDLE) {
> +				if (cm->pctrl_data->p && cm->pctrl_data->pinctrl_idle) {
> +					ret = pinctrl_select_state(cm->pctrl_data->p, cm->pctrl_data->pinctrl_idle);
> +					if (ret) {
> +						DRM_ERROR("could not set this pin to idle state!\n");
> +						ret = -1;
> +						goto err;
> +					}
> +				}
> +			} else {
> +				ret = -1;
> +				DRM_ERROR("unknown pinctrl type to set!\n");
> +				goto err;
> +			}
> +		} else if (cm->dtype == DTYPE_PINCTRL_PUT) {
> +			if (cm->pctrl_data->p)
> +				pinctrl_put(cm->pctrl_data->p);
> +		} else {
> +			DRM_ERROR("not supported command type!\n");
> +			ret = -1;
> +			goto err;
> +		}
> +
> +		cm++;
> +	}
> +
> +	return 0;
> +
> +err:
> +	return ret;
> +}

I cannot see any user of this pwm and backlight stuff.
So the best would be to drop it all.
> +
> +int hisi_pwm_set_backlight(struct backlight_device *bl, uint32_t bl_level)
> +{
> +	char __iomem *pwm_base = NULL;
> +	u32 bl_max = bl->props.max_brightness;
> +
> +	pwm_base = hisifd_pwm_base;
> +	if (!pwm_base) {
> +		DRM_ERROR("pwm_base is null!\n");
> +		return -EINVAL;
> +	}
> +
> +	DRM_INFO("bl_level=%d.\n", bl_level);
> +
> +	if (bl_max < 1) {
> +		DRM_ERROR("bl_max(%d) is out of range!!", bl_max);
> +		return -EINVAL;
> +	}
> +
> +	if (bl_level > bl_max)
> +		bl_level = bl_max;
> +
> +	bl_level = (bl_level * PWM_OUT_PRECISION) / bl_max;
> +
> +	writel(0x1acce551, pwm_base + PWM_LOCK_OFFSET);
> +	writel(0x0, pwm_base + PWM_CTL_OFFSET);
> +	writel(0x2, pwm_base + PWM_CFG_OFFSET);
> +	writel(0x1, pwm_base + PWM_PR0_OFFSET);
> +	writel(0x2, pwm_base + PWM_PR1_OFFSET);
> +	writel(0x1, pwm_base + PWM_CTL_OFFSET);
> +	writel((PWM_OUT_PRECISION - 1), pwm_base + PWM_C0_MR_OFFSET);
> +	writel(bl_level, pwm_base + PWM_C0_MR0_OFFSET);
> +
> +	return 0;
> +}
> +
> +int hisi_pwm_on(void)
> +{
> +	struct clk *clk_tmp = NULL;
> +	char __iomem *pwm_base = NULL;
> +	char __iomem *peri_crg_base = NULL;
> +	int ret = 0;
> +
> +	DRM_INFO(" +.\n");
> +
> +	peri_crg_base = hisi_peri_crg_base;
> +	if (!peri_crg_base) {
> +		DRM_ERROR("peri_crg_base is NULL");
> +		return -EINVAL;
> +	}
> +
> +	pwm_base = hisifd_pwm_base;
> +	if (!pwm_base) {
> +		DRM_ERROR("pwm_base is null!\n");
> +		return -EINVAL;
> +	}
> +
> +	if (g_pwm_on == 1)
> +		return 0;
> +
> +	// dis-reset pwm
> +	writel(0x1, peri_crg_base + PERRSTDIS2);
> +
> +	clk_tmp = g_pwm_clk;
> +	if (clk_tmp) {
> +		ret = clk_prepare(clk_tmp);
> +		if (ret) {
> +			DRM_ERROR("dss_pwm_clk clk_prepare failed, error=%d!\n", ret);
> +			return -EINVAL;
> +		}
> +
> +		ret = clk_enable(clk_tmp);
> +		if (ret) {
> +			DRM_ERROR("dss_pwm_clk clk_enable failed, error=%d!\n", ret);
> +			return -EINVAL;
> +		}
> +
> +		DRM_INFO("dss_pwm_clk clk_enable succeeded, ret=%d!\n", ret);
> +	}
> +
> +	ret = pinctrl_cmds_tx(g_pwm_pdev, pwm_pinctrl_normal_cmds,
> +			      ARRAY_SIZE(pwm_pinctrl_normal_cmds));
> +
> +	//if enable PWM, please set IOMG_004 in IOC_AO module
> +	//set IOMG_004: select PWM_OUT0
> +
> +	g_pwm_on = 1;
> +
> +	return ret;
> +}
> +
> +int hisi_pwm_off(void)
> +{
> +	struct clk *clk_tmp = NULL;
> +	char __iomem *pwm_base = NULL;
> +	char __iomem *peri_crg_base = NULL;
> +	int ret = 0;
> +
> +	peri_crg_base = hisi_peri_crg_base;
> +	if (!peri_crg_base) {
> +		DRM_ERROR("peri_crg_base is NULL");
> +		return -EINVAL;
> +	}
> +
> +	pwm_base = hisifd_pwm_base;
> +	if (!pwm_base) {
> +		DRM_ERROR("pwm_base is null!\n");
> +		return -EINVAL;
> +	}
> +
> +	if (g_pwm_on == 0)
> +		return 0;
> +
> +	ret = pinctrl_cmds_tx(g_pwm_pdev, pwm_pinctrl_lowpower_cmds,
> +			      ARRAY_SIZE(pwm_pinctrl_lowpower_cmds));
> +
> +	clk_tmp = g_pwm_clk;
> +	if (clk_tmp) {
> +		clk_disable(clk_tmp);
> +		clk_unprepare(clk_tmp);
> +	}
> +
> +	//reset pwm
> +	writel(0x1, peri_crg_base + PERRSTEN2);
> +
> +	g_pwm_on = 0;
> +
> +	return ret;
> +}
> +
> +static int hisi_pwm_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = NULL;
> +	int ret = 0;
> +
> +	if (!pdev) {
> +		DRM_ERROR("pdev is NULL");
> +		return -EINVAL;
> +	}
> +
> +	g_pwm_pdev = pdev;
> +
> +	np = of_find_compatible_node(NULL, NULL, DTS_COMP_PWM_NAME);
> +	if (!np) {
> +		DRM_ERROR("NOT FOUND device node %s!\n", DTS_COMP_PWM_NAME);
> +		ret = -ENXIO;
> +		goto err_return;
> +	}
> +
> +	/* get pwm reg base */
> +	hisifd_pwm_base = of_iomap(np, 0);
> +	if (!hisifd_pwm_base) {
> +		DRM_ERROR("failed to get pwm_base resource.\n");
> +		return -ENXIO;
> +	}
> +
> +	/* get peri_crg_base */
> +	hisi_peri_crg_base = of_iomap(np, 1);
> +	if (!hisi_peri_crg_base) {
> +		DRM_ERROR("failed to get peri_crg_base resource.\n");
> +		return -ENXIO;
> +	}
> +
> +	/* pwm pinctrl init */
> +	ret = pinctrl_cmds_tx(pdev, pwm_pinctrl_init_cmds,
> +			      ARRAY_SIZE(pwm_pinctrl_init_cmds));
> +	if (ret != 0) {
> +		DRM_ERROR("Init pwm pinctrl failed! ret=%d.\n", ret);
> +		goto err_return;
> +	}
> +
> +	/* get pwm clk resource */
> +	g_pwm_clk = of_clk_get(np, 0);
> +	if (IS_ERR(g_pwm_clk)) {
> +		DRM_ERROR("%s clock not found: %d!\n",
> +			  np->name, (int)PTR_ERR(g_pwm_clk));
> +		ret = -ENXIO;
> +		goto err_return;
> +	}
> +
> +	DRM_INFO("dss_pwm_clk:[%lu]->[%lu].\n",
> +		 DEFAULT_PWM_CLK_RATE, clk_get_rate(g_pwm_clk));
> +
> +	return 0;
> +
> +err_return:
> +	return ret;
> +}
> +
> +static int hisi_pwm_remove(struct platform_device *pdev)
> +{
> +	struct clk *clk_tmp = NULL;
> +	int ret = 0;
> +
> +	ret = pinctrl_cmds_tx(pdev, pwm_pinctrl_finit_cmds,
> +			      ARRAY_SIZE(pwm_pinctrl_finit_cmds));
> +
> +	clk_tmp = g_pwm_clk;
> +	if (clk_tmp) {
> +		clk_put(clk_tmp);
> +		clk_tmp = NULL;
> +	}
> +
> +	return ret;
> +}
> +
> +static const struct of_device_id hisi_pwm_match_table[] = {
> +	{
> +		.compatible = "hisilicon,hisipwm",
> +		.data = NULL,
> +	},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, hisi_pwm_match_table);
> +
> +static struct platform_driver this_driver = {
> +	.probe = hisi_pwm_probe,
> +	.remove = hisi_pwm_remove,
> +	.suspend = NULL,
> +	.resume = NULL,
> +	.shutdown = NULL,
> +	.driver = {
> +		.name = DEV_NAME_PWM,
> +		.owner = THIS_MODULE,
> +		.of_match_table = of_match_ptr(hisi_pwm_match_table),
> +	},
> +};
> +
> +static int __init hisi_pwm_init(void)
> +{
> +	int ret = 0;
> +
> +	ret = platform_driver_register(&this_driver);
> +	if (ret) {
> +		DRM_ERROR("platform_driver_register failed, error=%d!\n", ret);
> +		return ret;
> +	}
> +
> +	return ret;
> +}
> +
> +module_init(hisi_pwm_init);
> +
> +MODULE_AUTHOR("cailiwei <cailiwei@hisilicon.com>");
> +MODULE_AUTHOR("zhangxiubin <zhangxiubin1@huawei.com>");
> +MODULE_DESCRIPTION("hisilicon Kirin SoCs' pwm driver");
> +MODULE_LICENSE("GPL v2");
