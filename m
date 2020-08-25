Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2355251EE4
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 20:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgHYSMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 14:12:07 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:34030 "EHLO
        asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbgHYSMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 14:12:05 -0400
Received: from ravnborg.org (unknown [188.228.123.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by asavdk4.altibox.net (Postfix) with ESMTPS id C479B80530;
        Tue, 25 Aug 2020 20:11:36 +0200 (CEST)
Date:   Tue, 25 Aug 2020 20:11:35 +0200
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
Message-ID: <20200825181135.GA222283@ravnborg.org>
References: <cover.1597833138.git.mchehab+huawei@kernel.org>
 <20200819152120.GA106437@ravnborg.org>
 <20200819174027.70b39ee9@coco.lan>
 <20200819173558.GA3733@ravnborg.org>
 <20200821155801.0b820fc6@coco.lan>
 <20200821155505.GA300361@ravnborg.org>
 <20200824180225.1a515b6a@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824180225.1a515b6a@coco.lan>
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=aP3eV41m c=1 sm=1 tr=0
        a=S6zTFyMACwkrwXSdXUNehg==:117 a=S6zTFyMACwkrwXSdXUNehg==:17
        a=kj9zAlcOel0A:10 a=e5mUnYsNAAAA:8 a=i0EeH86SAAAA:8
        a=cE7MSZxB1DXlWWN6Tt4A:9 a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
        a=0wGE8ZiEdEHYA50Q:21 a=aLxmh6KD4dSWZl8C:21 a=lEJGdM5x6DowzKYk:21
        a=CjuIK1q_8ugA:10 a=Vxmtnl_E_bksehYqCbjh:22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mauro

> Before posting the big patch series again, let me send the new
> version folded into a single patch.
> 
> If you'd like to see the entire thing, I'm placing it here:
> 
> 	https://gitlab.freedesktop.org/mchehab_kernel/hikey-970/-/commits/hikey970_v2/

Review 3/3

For next submission then to ease review it would be nice that the patch
is spilt up a little. Maybe something like:
- HW specific stuff in two patches (header fiels with register + setup
  code)
- Display driver files
- DSI driver files
- build stuff (Makefile, Kconfig fragments)
So all splits on file level - which should be easy to do.

This will make it easier for more people to give feedback. It is a bit
much to walk through 4k loc or what the full size is.
And then we can also provide a-b or r-b for fragments so the reviewed
parts can be ignored for later reviews.


For the DSI parts I may be hit by the old "when you have a hammer then
everything looks like a nail syndrome".
In my case the hammer is the bridge interface.

Suggestions:
- Move encoder to display driver
- Move connector creation to display driver (using
  drm_bridge_connector_init())
- Use drm_bridge interface for the DSI driver parts
- Maybe use the HDMI bridge driver as a chained driver - I did not look
  to close on this
- Use the standard bridge interface to find the bridge and drop use of
  the component framework

I hope that some other drm people chime in here.
Either to tell this is non-sense or confirm this is the way to go.

The above does not give any hint how to use the gpio_mux to shift
between the panel and HDMI. This logic needs to be in the display driver
as the bridge driver will only be used for HDMI - as I understand the
code. And I do not know how to do it.

Some details in the following that are not related to the above.

	Sam

> diff --git a/drivers/staging/hikey9xx/gpu/kirin9xx_dw_drm_dsi.c b/drivers/staging/hikey9xx/gpu/kirin9xx_dw_drm_dsi.c
> new file mode 100644
> index 000000000000..a2eed961b7d5
> --- /dev/null
> +++ b/drivers/staging/hikey9xx/gpu/kirin9xx_dw_drm_dsi.c
> @@ -0,0 +1,2126 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * DesignWare MIPI DSI Host Controller v1.02 driver
> + *
> + * Copyright (c) 2016 Linaro Limited.
> + * Copyright (c) 2014-2016 Hisilicon Limited.
> + * Copyright (c) 2014-2020, Huawei Technologies Co., Ltd
> + *
> + * Author:
> + *	<shizongxuan@huawei.com>
> + *	<zhangxiubin@huawei.com>
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
Sort

> +
> +#include <drm/drm_of.h>
> +#include <drm/drm_crtc_helper.h>
> +#include <drm/drm_mipi_dsi.h>
> +#include <drm/drm_encoder.h>
> +#include <drm/drm_device.h>
> +#include <drm/drm_atomic_helper.h>
> +#include <drm/drm_panel.h>
> +#include <drm/drm_probe_helper.h>
Sort

> +
> +#include "kirin9xx_dw_dsi_reg.h"
> +#include "kirin9xx_dpe.h"
> +#include "kirin9xx_drm_drv.h"
> +#include "kirin9xx_drm_dpe_utils.h"
Sort

> +
> +#define PHY_REF_CLK_RATE	19200000
> +#define PHY_REF_CLK_PERIOD_PS	(1000000000 / (PHY_REF_CLK_RATE / 1000))
> +
> +#define encoder_to_dsi(encoder) \
> +	container_of(encoder, struct dw_dsi, encoder)
> +#define host_to_dsi(host) \
> +	container_of(host, struct dw_dsi, host)
> +#define connector_to_dsi(connector) \
> +	container_of(connector, struct dw_dsi, connector)
Move the upcast next to the struct definition.


> +#define DSS_REDUCE(x)	((x) > 0 ? ((x) - 1) : (x))
> +
> +enum dsi_output_client {
> +	OUT_HDMI = 0,
> +	OUT_PANEL,
> +	OUT_MAX
> +};
> +
> +struct mipi_phy_params {
I did not check all fiels but I managed to find at least one unused
field. Cheack and delete what is unused.
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
Some indent gone wrong here?
> +	u32 pll_register_override;		/* 0x1E[0] */
> +	u32 pll_power_down;			/* 0x1E[1] */
> +	u32 rg_band_sel;				/* 0x1E[2] */
> +	u32 rg_phase_gen_en;		/* 0x1E[3] */
> +	u32 reload_sel;				/* 0x1E[4] */
> +	u32 rg_pll_cp_p;				/* 0x1E[7:5] */
> +	u32 rg_pll_refsel;				/* 0x16[1:0] */
> +	u32 rg_pll_cp;				/* 0x16[7:5] */
> +	u32 load_command;
> +
> +	/* for CDPHY */
> +	u32 rg_cphy_div;	/* Q */
> +	u32 rg_div;		/* M 0x4A[7:0] */
> +	u32 rg_pre_div;	/* N 0x49[0] */
> +	u32 rg_320m;		/* 0x48[2] */
> +	u32 rg_2p5g;		/* 0x48[1] */
> +	u32 rg_0p8v;		/* 0x48[0] */
> +	u32 rg_lpf_r;		/* 0x46[5:4] */
> +	u32 rg_cp;			/* 0x46[3:0] */
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
Not used, delete.
> +	struct clk *dss_dphy0_cfg_clk;
> +	struct clk *dss_dphy1_cfg_clk;
Not used, delete.

> +	struct clk *dss_pclk_dsi0_clk;
> +	struct clk *dss_pclk_dsi1_clk;
Not sued, delete.
> +};
> +
> +struct dw_dsi_client {
> +	u32 lanes;
> +	u32 phy_clock; /* in kHz */
> +	enum mipi_dsi_pixel_format format;
> +	unsigned long mode_flags;
> +};
> +
> +struct mipi_panel_info {
Some filed in the following are either not used or in some cases only
read. Clean it up.

Example: clk_t_hs_exit_adjust is assigned 0 and only read.
Looks like stuff to drop.

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
> +	/* uint32_t dsi_pclk_rate; */
> +
> +	u32 hs_wr_to_time;
> +
> +	/* dphy config parameter adjust */
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
> +	/* only for Chicago<3660> use */
> +	u32 rg_vrefsel_vcm_clk_adjust;
> +	u32 rg_vrefsel_vcm_data_adjust;
> +
> +	u32 phy_mode;  /* 0: DPHY, 1:CPHY */
> +	u32 lp11_flag;
> +};
> +
> +struct ldi_panel_info {
Fileds are only partially used.

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
> +
> +struct dw_dsi {
> +	struct drm_encoder encoder;
> +	struct drm_bridge *bridge;
> +	struct drm_panel *panel;
> +	struct mipi_dsi_host host;
> +	struct drm_connector connector; /* connector for panel */
> +	struct drm_display_mode cur_mode;
> +	struct dsi_hw_ctx *ctx;
Would it be possible to embed dsi_hw_ctx?
So everything is allocated in one go.

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
> +
> +struct dsi_data {
> +	struct dw_dsi dsi;
> +	struct dsi_hw_ctx ctx;
> +};
If dsi_hw_ctx is embedded in dw_dsi then this struct can be dropped.
> +
> +struct dsi_phy_range {
> +	u32 min_range_kHz;
> +	u32 max_range_kHz;
> +	u32 pll_vco_750M;
> +	u32 hstx_ckg_sel;
> +};
Not used, delete.
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
Not used, delete.

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
> +		drm_info(dev, "client change to %s\n",
> +			 client == OUT_HDMI ? "HDMI" : "panel");
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
> +	DRM_DEBUG("Expected : lane_clock = %llu M\n", lane_clock);
> +
> +	/************************  PLL parameters config  *********************/
> +	/* chip spec : */
> +	/* If the output data rate is below 320 Mbps, RG_BNAD_SEL should be set to 1. */
> +	/* At this mode a post divider of 1/4 will be applied to VCO. */
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
> +	/* chip spec : */
> +	phy_ctrl->rg_pre_div = n_pll - 1;
> +	phy_ctrl->rg_div = m_pll;
> +	phy_ctrl->rg_0p8v = 0;
> +	phy_ctrl->rg_2p5g = 1;
> +	phy_ctrl->rg_320m = 0;
> +	phy_ctrl->rg_lpf_r = 0;
> +
> +	/* TO DO HSTX select VCM VREF */
> +	phy_ctrl->rg_vrefsel_vcm = 0x5d;
> +
> +	/********************  clock/data lane parameters config  ******************/
> +	accuracy = 10;
> +	ui =  (u32)(10 * 1000000000UL * accuracy / lane_clock);
> +	/* unit of measurement */
> +	unit_tx_byte_clk_hs = 8 * ui;
> +
> +	/* D-PHY Specification : 60ns + 52*UI <= clk_post */
> +	clk_post = 600 * accuracy + 52 * ui + unit_tx_byte_clk_hs + mipi->clk_post_adjust * ui;
> +
> +	/* D-PHY Specification : clk_pre >= 8*UI */
> +	clk_pre = 8 * ui + unit_tx_byte_clk_hs + mipi->clk_pre_adjust * ui;
> +
> +	/* D-PHY Specification : clk_t_hs_exit >= 100ns */
> +	clk_t_hs_exit = 1000 * accuracy + 100 * accuracy + mipi->clk_t_hs_exit_adjust * ui;
> +
> +	/* clocked by TXBYTECLKHS */
> +	clk_pre_delay = 0 + mipi->clk_pre_delay_adjust * ui;
> +
> +	/* D-PHY Specification : clk_t_hs_trial >= 60ns */
> +	/* clocked by TXBYTECLKHS */
> +	clk_t_hs_trial = 600 * accuracy + 3 * unit_tx_byte_clk_hs + mipi->clk_t_hs_trial_adjust * ui;
> +
> +	/* D-PHY Specification : 38ns <= clk_t_hs_prepare <= 95ns */
> +	/* clocked by TXBYTECLKHS */
> +	clk_t_hs_prepare = 660 * accuracy;
> +
> +	/* clocked by TXBYTECLKHS */
> +	data_post_delay = 0 + mipi->data_post_delay_adjust * ui;
> +
> +	/* D-PHY Specification : data_t_hs_trial >= max( n*8*UI, 60ns + n*4*UI ), n = 1 */
> +	/* clocked by TXBYTECLKHS */
> +	data_t_hs_trial = ((600 * accuracy + 4 * ui) >= (8 * ui) ? (600 * accuracy + 4 * ui) : (8 * ui)) +
> +		2 * unit_tx_byte_clk_hs + mipi->data_t_hs_trial_adjust * ui;
> +
> +	/* D-PHY Specification : 40ns + 4*UI <= data_t_hs_prepare <= 85ns + 6*UI */
> +	/* clocked by TXBYTECLKHS */
> +	data_t_hs_prepare = 400 * accuracy + 4 * ui;
> +	/* D-PHY chip spec : clk_t_lpx + clk_t_hs_prepare > 200ns */
> +	/* D-PHY Specification : clk_t_lpx >= 50ns */
> +	/* clocked by TXBYTECLKHS */
> +	clk_t_lpx = (uint32_t)(2000 * accuracy + 10 * accuracy + mipi->clk_t_lpx_adjust * ui - clk_t_hs_prepare);
> +
> +	/* D-PHY Specification : clk_t_hs_zero + clk_t_hs_prepare >= 300 ns */
> +	/* clocked by TXBYTECLKHS */
> +	clk_t_hs_zero = (uint32_t)(3000 * accuracy + 3 * unit_tx_byte_clk_hs + mipi->clk_t_hs_zero_adjust * ui - clk_t_hs_prepare);
> +
> +	/* D-PHY chip spec : data_t_lpx + data_t_hs_prepare > 200ns */
> +	/* D-PHY Specification : data_t_lpx >= 50ns */
> +	/* clocked by TXBYTECLKHS */
> +	data_t_lpx = (uint32_t)(2000 * accuracy + 10 * accuracy + mipi->data_t_lpx_adjust * ui - data_t_hs_prepare);
> +
> +	/* D-PHY Specification : data_t_hs_zero + data_t_hs_prepare >= 145ns + 10*UI */
> +	/* clocked by TXBYTECLKHS */
> +	data_t_hs_zero = (uint32_t)(1450 * accuracy + 10 * ui +
> +		3 * unit_tx_byte_clk_hs + mipi->data_t_hs_zero_adjust * ui - data_t_hs_prepare);
> +
> +	phy_ctrl->clk_pre_delay = DIV_ROUND_UP(clk_pre_delay, unit_tx_byte_clk_hs);
> +	phy_ctrl->clk_t_hs_prepare = DIV_ROUND_UP(clk_t_hs_prepare, unit_tx_byte_clk_hs);
> +	phy_ctrl->clk_t_lpx = DIV_ROUND_UP(clk_t_lpx, unit_tx_byte_clk_hs);
> +	phy_ctrl->clk_t_hs_zero = DIV_ROUND_UP(clk_t_hs_zero, unit_tx_byte_clk_hs);
> +	phy_ctrl->clk_t_hs_trial = DIV_ROUND_UP(clk_t_hs_trial, unit_tx_byte_clk_hs);
> +
> +	phy_ctrl->data_post_delay = DIV_ROUND_UP(data_post_delay, unit_tx_byte_clk_hs);
> +	phy_ctrl->data_t_hs_prepare = DIV_ROUND_UP(data_t_hs_prepare, unit_tx_byte_clk_hs);
> +	phy_ctrl->data_t_lpx = DIV_ROUND_UP(data_t_lpx, unit_tx_byte_clk_hs);
> +	phy_ctrl->data_t_hs_zero = DIV_ROUND_UP(data_t_hs_zero, unit_tx_byte_clk_hs);
> +	phy_ctrl->data_t_hs_trial = DIV_ROUND_UP(data_t_hs_trial, unit_tx_byte_clk_hs);
> +
> +	phy_ctrl->clk_post_delay = phy_ctrl->data_t_hs_trial + DIV_ROUND_UP(clk_post, unit_tx_byte_clk_hs);
> +	phy_ctrl->data_pre_delay = phy_ctrl->clk_pre_delay + 2 + phy_ctrl->clk_t_lpx +
> +		phy_ctrl->clk_t_hs_prepare + phy_ctrl->clk_t_hs_zero + 8 + DIV_ROUND_UP(clk_pre, unit_tx_byte_clk_hs);
> +
> +	phy_ctrl->clk_lane_lp2hs_time = phy_ctrl->clk_pre_delay + phy_ctrl->clk_t_lpx + phy_ctrl->clk_t_hs_prepare +
> +		phy_ctrl->clk_t_hs_zero + 5 + 7;
> +	phy_ctrl->clk_lane_hs2lp_time = phy_ctrl->clk_t_hs_trial + phy_ctrl->clk_post_delay + 8 + 4;
> +	phy_ctrl->data_lane_lp2hs_time = phy_ctrl->data_pre_delay + phy_ctrl->data_t_lpx + phy_ctrl->data_t_hs_prepare +
> +		phy_ctrl->data_t_hs_zero + 5 + 7;
> +	phy_ctrl->data_lane_hs2lp_time = phy_ctrl->data_t_hs_trial + 8 + 5;
> +
> +	phy_ctrl->phy_stop_wait_time = phy_ctrl->clk_post_delay + 4 + phy_ctrl->clk_t_hs_trial +
> +		DIV_ROUND_UP(clk_t_hs_exit, unit_tx_byte_clk_hs) - (phy_ctrl->data_post_delay + 4 + phy_ctrl->data_t_hs_trial) + 3;
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
> +		phy_ctrl->rg_band_sel = 0;	/* 0x1E[2] */
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
> +	/* if set rg_pll_enswc=1, rg_pll_fbd_s can't be 0 */
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
> +	/* FIXME : */
> +	phy_ctrl->rg_pll_cp = 1;		/* 0x16[7:5] */
> +	phy_ctrl->rg_pll_cp_p = 3;		/* 0x1E[7:5] */
> +
> +	/* test_code_0x14 other parameters config */
> +	phy_ctrl->rg_pll_enbwt = 0;	/* 0x14[2] */
> +	phy_ctrl->rg_pll_chp = 0;		/* 0x14[1:0] */
> +
> +	/* test_code_0x16 other parameters config,  0x16[3:2] reserved */
> +	phy_ctrl->rg_pll_lpf_cs = 0;	/* 0x16[4] */
> +	phy_ctrl->rg_pll_refsel = 1;		/* 0x16[1:0] */
> +
> +	/* test_code_0x1E other parameters config */
> +	phy_ctrl->reload_sel = 1;			/* 0x1E[4] */
> +	phy_ctrl->rg_phase_gen_en = 1;	/* 0x1E[3] */
> +	phy_ctrl->pll_power_down = 0;		/* 0x1E[1] */
> +	phy_ctrl->pll_register_override = 1;	/* 0x1E[0] */
> +
> +	/* HSTX select VCM VREF */
> +	phy_ctrl->rg_vrefsel_vcm = 0x55;
> +	if (mipi->rg_vrefsel_vcm_clk_adjust != 0)
> +		phy_ctrl->rg_vrefsel_vcm = (phy_ctrl->rg_vrefsel_vcm & 0x0F) |
> +			((mipi->rg_vrefsel_vcm_clk_adjust & 0x0F) << 4);
> +
> +	if (mipi->rg_vrefsel_vcm_data_adjust != 0)
> +		phy_ctrl->rg_vrefsel_vcm = (phy_ctrl->rg_vrefsel_vcm & 0xF0) |
> +			(mipi->rg_vrefsel_vcm_data_adjust & 0x0F);
> +
> +	/* if reload_sel = 1, need to set load_command */
> +	phy_ctrl->load_command = 0x5A;
> +
> +	/********************  clock/data lane parameters config  ******************/
> +	accuracy = 10;
> +	ui =  10 * 1000000000UL * accuracy / lane_clock;
> +	/* unit of measurement */
> +	unit_tx_byte_clk_hs = 8 * ui;
> +
> +	/* D-PHY Specification : 60ns + 52*UI <= clk_post */
> +	clk_post = 600 * accuracy + 52 * ui + mipi->clk_post_adjust * ui;
> +
> +	/* D-PHY Specification : clk_pre >= 8*UI */
> +	clk_pre = 8 * ui + mipi->clk_pre_adjust * ui;
> +
> +	/* D-PHY Specification : clk_t_hs_exit >= 100ns */
> +	clk_t_hs_exit = 1000 * accuracy + mipi->clk_t_hs_exit_adjust * ui;
> +
> +	/* clocked by TXBYTECLKHS */
> +	clk_pre_delay = 0 + mipi->clk_pre_delay_adjust * ui;
> +
> +	/* D-PHY Specification : clk_t_hs_trial >= 60ns */
> +	/* clocked by TXBYTECLKHS */
> +	clk_t_hs_trial = 600 * accuracy + 3 * unit_tx_byte_clk_hs + mipi->clk_t_hs_trial_adjust * ui;
> +
> +	/* D-PHY Specification : 38ns <= clk_t_hs_prepare <= 95ns */
> +	/* clocked by TXBYTECLKHS */
> +	if (mipi->clk_t_hs_prepare_adjust == 0)
> +		mipi->clk_t_hs_prepare_adjust = 43;
> +
> +	clk_t_hs_prepare = ((380 * accuracy + mipi->clk_t_hs_prepare_adjust * ui) <= (950 * accuracy - 8 * ui)) ?
> +		(380 * accuracy + mipi->clk_t_hs_prepare_adjust * ui) : (950 * accuracy - 8 * ui);
> +
> +	/* clocked by TXBYTECLKHS */
> +	data_post_delay = 0 + mipi->data_post_delay_adjust * ui;
> +
> +	/* D-PHY Specification : data_t_hs_trial >= max( n*8*UI, 60ns + n*4*UI ), n = 1 */
> +	/* clocked by TXBYTECLKHS */
> +	data_t_hs_trial = ((600 * accuracy + 4 * ui) >= (8 * ui) ? (600 * accuracy + 4 * ui) : (8 * ui)) + 8 * ui +
> +		3 * unit_tx_byte_clk_hs + mipi->data_t_hs_trial_adjust * ui;
> +
> +	/* D-PHY Specification : 40ns + 4*UI <= data_t_hs_prepare <= 85ns + 6*UI */
> +	/* clocked by TXBYTECLKHS */
> +	if (mipi->data_t_hs_prepare_adjust == 0)
> +		mipi->data_t_hs_prepare_adjust = 35;
> +
> +	data_t_hs_prepare = ((400  * accuracy + 4 * ui + mipi->data_t_hs_prepare_adjust * ui) <= (850 * accuracy + 6 * ui - 8 * ui)) ?
> +		(400  * accuracy + 4 * ui + mipi->data_t_hs_prepare_adjust * ui) : (850 * accuracy + 6 * ui - 8 * ui);
> +
> +	/* D-PHY chip spec : clk_t_lpx + clk_t_hs_prepare > 200ns */
> +	/* D-PHY Specification : clk_t_lpx >= 50ns */
> +	/* clocked by TXBYTECLKHS */
> +	clk_t_lpx = (((2000 * accuracy - clk_t_hs_prepare) >= 500 * accuracy) ?
> +		((2000 * accuracy - clk_t_hs_prepare)) : (500 * accuracy)) +
> +		mipi->clk_t_lpx_adjust * ui;
> +
> +	/* D-PHY Specification : clk_t_hs_zero + clk_t_hs_prepare >= 300 ns */
> +	/* clocked by TXBYTECLKHS */
> +	clk_t_hs_zero = 3000 * accuracy - clk_t_hs_prepare + 3 * unit_tx_byte_clk_hs + mipi->clk_t_hs_zero_adjust * ui;
> +
> +	/* D-PHY chip spec : data_t_lpx + data_t_hs_prepare > 200ns */
> +	/* D-PHY Specification : data_t_lpx >= 50ns */
> +	/* clocked by TXBYTECLKHS */
> +	data_t_lpx = clk_t_lpx + mipi->data_t_lpx_adjust * ui; /* 2000 * accuracy - data_t_hs_prepare; */
> +
> +	/* D-PHY Specification : data_t_hs_zero + data_t_hs_prepare >= 145ns + 10*UI */
> +	/* clocked by TXBYTECLKHS */
> +	data_t_hs_zero = 1450 * accuracy + 10 * ui - data_t_hs_prepare +
> +		3 * unit_tx_byte_clk_hs + mipi->data_t_hs_zero_adjust * ui;
> +
> +	phy_ctrl->clk_pre_delay = DIV_ROUND_UP(clk_pre_delay, unit_tx_byte_clk_hs);
> +	phy_ctrl->clk_t_hs_prepare = DIV_ROUND_UP(clk_t_hs_prepare, unit_tx_byte_clk_hs);
> +	phy_ctrl->clk_t_lpx = DIV_ROUND_UP(clk_t_lpx, unit_tx_byte_clk_hs);
> +	phy_ctrl->clk_t_hs_zero = DIV_ROUND_UP(clk_t_hs_zero, unit_tx_byte_clk_hs);
> +	phy_ctrl->clk_t_hs_trial = DIV_ROUND_UP(clk_t_hs_trial, unit_tx_byte_clk_hs);
> +
> +	phy_ctrl->data_post_delay = DIV_ROUND_UP(data_post_delay, unit_tx_byte_clk_hs);
> +	phy_ctrl->data_t_hs_prepare = DIV_ROUND_UP(data_t_hs_prepare, unit_tx_byte_clk_hs);
> +	phy_ctrl->data_t_lpx = DIV_ROUND_UP(data_t_lpx, unit_tx_byte_clk_hs);
> +	phy_ctrl->data_t_hs_zero = DIV_ROUND_UP(data_t_hs_zero, unit_tx_byte_clk_hs);
> +	phy_ctrl->data_t_hs_trial = DIV_ROUND_UP(data_t_hs_trial, unit_tx_byte_clk_hs);
> +	phy_ctrl->data_t_ta_go = 4;
> +	phy_ctrl->data_t_ta_get = 5;
> +
> +	clk_pre_delay_reality = phy_ctrl->clk_pre_delay + 2;
> +	clk_t_hs_zero_reality = phy_ctrl->clk_t_hs_zero + 8;
> +	data_t_hs_zero_reality = phy_ctrl->data_t_hs_zero + 4;
> +	data_post_delay_reality = phy_ctrl->data_post_delay + 4;
> +
> +	phy_ctrl->clk_post_delay = phy_ctrl->data_t_hs_trial + DIV_ROUND_UP(clk_post, unit_tx_byte_clk_hs);
> +	phy_ctrl->data_pre_delay = clk_pre_delay_reality + phy_ctrl->clk_t_lpx +
> +		phy_ctrl->clk_t_hs_prepare + clk_t_hs_zero_reality + DIV_ROUND_UP(clk_pre, unit_tx_byte_clk_hs);
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
> +		phy_ctrl->clk_t_hs_trial + DIV_ROUND_UP(clk_t_hs_exit, unit_tx_byte_clk_hs) -
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
> +		/* Lane Transmission Property */
> +		addr = MIPIDSI_PHY_TST_LANE_TRANSMISSION_PROPERTY + (i << 5);
> +		dsi_phy_tst_set(mipi_dsi_base, addr, 0x43);
> +	}
> +
> +	/* pre_delay of clock lane request setting */
> +	dsi_phy_tst_set(mipi_dsi_base, MIPIDSI_PHY_TST_CLK_PRE_DELAY, DSS_REDUCE(dsi->phy.clk_pre_delay));
> +
> +	/* post_delay of clock lane request setting */
> +	dsi_phy_tst_set(mipi_dsi_base, MIPIDSI_PHY_TST_CLK_POST_DELAY, DSS_REDUCE(dsi->phy.clk_post_delay));
> +
> +	/* clock lane timing ctrl - t_lpx */
> +	dsi_phy_tst_set(mipi_dsi_base, MIPIDSI_PHY_TST_CLK_TLPX, DSS_REDUCE(dsi->phy.clk_t_lpx));
> +
> +	/* clock lane timing ctrl - t_hs_prepare */
> +	dsi_phy_tst_set(mipi_dsi_base, MIPIDSI_PHY_TST_CLK_PREPARE, DSS_REDUCE(dsi->phy.clk_t_hs_prepare));
> +
> +	/* clock lane timing ctrl - t_hs_zero */
> +	dsi_phy_tst_set(mipi_dsi_base, MIPIDSI_PHY_TST_CLK_ZERO, DSS_REDUCE(dsi->phy.clk_t_hs_zero));
> +
> +	/* clock lane timing ctrl - t_hs_trial */
> +	dsi_phy_tst_set(mipi_dsi_base, MIPIDSI_PHY_TST_CLK_TRAIL, DSS_REDUCE(dsi->phy.clk_t_hs_trial));
> +
> +	for (i = 0; i <= 4; i++) {
> +		if (lanes == 2 && i == 1) /* init mipi dsi 3 lanes should skip lane3 */
> +			i++;
> +
> +		if (i == 2) /* skip clock lane */
> +			i++;  /* addr: lane0:0x60; lane1:0x80; lane2:0xC0; lane3:0xE0 */
> +
> +		/* data lane pre_delay */
> +		addr = MIPIDSI_PHY_TST_DATA_PRE_DELAY + (i << 5);
> +		dsi_phy_tst_set(mipi_dsi_base, addr, DSS_REDUCE(dsi->phy.data_pre_delay));
> +
> +		/* data lane post_delay */
> +		addr = MIPIDSI_PHY_TST_DATA_POST_DELAY + (i << 5);
> +		dsi_phy_tst_set(mipi_dsi_base, addr, DSS_REDUCE(dsi->phy.data_post_delay));
> +
> +		/* data lane timing ctrl - t_lpx */
> +		addr = MIPIDSI_PHY_TST_DATA_TLPX + (i << 5);
> +		dsi_phy_tst_set(mipi_dsi_base, addr, DSS_REDUCE(dsi->phy.data_t_lpx));
> +
> +		/* data lane timing ctrl - t_hs_prepare */
> +		addr = MIPIDSI_PHY_TST_DATA_PREPARE + (i << 5);
> +		dsi_phy_tst_set(mipi_dsi_base, addr, DSS_REDUCE(dsi->phy.data_t_hs_prepare));
> +
> +		/* data lane timing ctrl - t_hs_zero */
> +		addr = MIPIDSI_PHY_TST_DATA_ZERO + (i << 5);
> +		dsi_phy_tst_set(mipi_dsi_base, addr, DSS_REDUCE(dsi->phy.data_t_hs_zero));
> +
> +		/* data lane timing ctrl - t_hs_trial */
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
> +		/* PLL configuration I */
> +		dsi_phy_tst_set(mipi_dsi_base, 0x0046,
> +				dsi->phy.rg_cp + (dsi->phy.rg_lpf_r << 4));
> +
> +		/* PLL configuration II */
> +		dsi_phy_tst_set(mipi_dsi_base, 0x0048,
> +				dsi->phy.rg_0p8v + (dsi->phy.rg_2p5g << 1) +
> +				(dsi->phy.rg_320m << 2) + (dsi->phy.rg_band_sel << 3));
> +
> +		/* PLL configuration III */
> +		dsi_phy_tst_set(mipi_dsi_base, 0x0049, dsi->phy.rg_pre_div);
> +
> +		/* PLL configuration IV */
> +		dsi_phy_tst_set(mipi_dsi_base, 0x004A, dsi->phy.rg_div);
> +
> +		dsi_phy_tst_set(mipi_dsi_base, 0x004F, 0xf0);
> +		dsi_phy_tst_set(mipi_dsi_base, 0x0050, 0xc0);
> +		dsi_phy_tst_set(mipi_dsi_base, 0x0051, 0x22);
> +
> +		dsi_phy_tst_set(mipi_dsi_base, 0x0053, dsi->phy.rg_vrefsel_vcm);
> +
> +		/* enable BTA */
> +		dsi_phy_tst_set(mipi_dsi_base, 0x0054, 0x03);
> +
> +		/* PLL update control */
> +		dsi_phy_tst_set(mipi_dsi_base, 0x004B, 0x1);
> +
> +		/* set dphy spec parameter */
> +		mipi_config_dphy_spec1v2_parameter(dsi, mipi_dsi_base, id);
> +	} else {
> +		int i = 0;
> +
> +		/* physical configuration PLL I */
> +		dsi_phy_tst_set(mipi_dsi_base, 0x14,
> +				(dsi->phy.rg_pll_fbd_s << 4) + (dsi->phy.rg_pll_enswc << 3) +
> +				(dsi->phy.rg_pll_enbwt << 2) + dsi->phy.rg_pll_chp);
> +
> +		/* physical configuration PLL II, M */
> +		dsi_phy_tst_set(mipi_dsi_base, 0x15, dsi->phy.rg_pll_fbd_p);
> +
> +		/* physical configuration PLL III */
> +		dsi_phy_tst_set(mipi_dsi_base, 0x16,
> +				(dsi->phy.rg_pll_cp << 5) + (dsi->phy.rg_pll_lpf_cs << 4) +
> +				dsi->phy.rg_pll_refsel);
> +
> +		/* physical configuration PLL IV, N */
> +		dsi_phy_tst_set(mipi_dsi_base, 0x17, dsi->phy.rg_pll_pre_p);
> +
> +		/* sets the analog characteristic of V reference in D-PHY TX */
> +		dsi_phy_tst_set(mipi_dsi_base, 0x1D, dsi->phy.rg_vrefsel_vcm);
> +
> +		/* MISC AFE Configuration */
> +		dsi_phy_tst_set(mipi_dsi_base, 0x1E,
> +				(dsi->phy.rg_pll_cp_p << 5) + (dsi->phy.reload_sel << 4) +
> +				(dsi->phy.rg_phase_gen_en << 3) + (dsi->phy.rg_band_sel << 2) +
> +				(dsi->phy.pll_power_down << 1) + dsi->phy.pll_register_override);
> +
> +		/* reload_command */
> +		dsi_phy_tst_set(mipi_dsi_base, 0x1F, dsi->phy.load_command);
> +
> +		/* pre_delay of clock lane request setting */
> +		dsi_phy_tst_set(mipi_dsi_base, 0x20, DSS_REDUCE(dsi->phy.clk_pre_delay));
> +
> +		/* post_delay of clock lane request setting */
> +		dsi_phy_tst_set(mipi_dsi_base, 0x21, DSS_REDUCE(dsi->phy.clk_post_delay));
> +
> +		/* clock lane timing ctrl - t_lpx */
> +		dsi_phy_tst_set(mipi_dsi_base, 0x22, DSS_REDUCE(dsi->phy.clk_t_lpx));
> +
> +		/* clock lane timing ctrl - t_hs_prepare */
> +		dsi_phy_tst_set(mipi_dsi_base, 0x23, DSS_REDUCE(dsi->phy.clk_t_hs_prepare));
> +
> +		/* clock lane timing ctrl - t_hs_zero */
> +		dsi_phy_tst_set(mipi_dsi_base, 0x24, DSS_REDUCE(dsi->phy.clk_t_hs_zero));
> +
> +		/* clock lane timing ctrl - t_hs_trial */
> +		dsi_phy_tst_set(mipi_dsi_base, 0x25, dsi->phy.clk_t_hs_trial);
> +
> +		for (i = 0; i <= lanes; i++) {
> +			/* data lane pre_delay */
> +			tmp = 0x30 + (i << 4);
> +			dsi_phy_tst_set(mipi_dsi_base, tmp, DSS_REDUCE(dsi->phy.data_pre_delay));
> +
> +			/* data lane post_delay */
> +			tmp = 0x31 + (i << 4);
> +			dsi_phy_tst_set(mipi_dsi_base, tmp, DSS_REDUCE(dsi->phy.data_post_delay));
> +
> +			/* data lane timing ctrl - t_lpx */
> +			dsi_phy_tst_set(mipi_dsi_base, tmp, DSS_REDUCE(dsi->phy.data_t_lpx));
> +
> +			/* data lane timing ctrl - t_hs_prepare */
> +			tmp = 0x33 + (i << 4);
> +			dsi_phy_tst_set(mipi_dsi_base, tmp, DSS_REDUCE(dsi->phy.data_t_hs_prepare));
> +
> +			/* data lane timing ctrl - t_hs_zero */
> +			tmp = 0x34 + (i << 4);
> +			dsi_phy_tst_set(mipi_dsi_base, tmp, DSS_REDUCE(dsi->phy.data_t_hs_zero));
> +
> +			/* data lane timing ctrl - t_hs_trial */
> +			tmp = 0x35 + (i << 4);
> +			dsi_phy_tst_set(mipi_dsi_base, tmp, DSS_REDUCE(dsi->phy.data_t_hs_trial));
> +
> +			/* data lane timing ctrl - t_ta_go */
> +			tmp = 0x36 + (i << 4);
> +			dsi_phy_tst_set(mipi_dsi_base, tmp, DSS_REDUCE(dsi->phy.data_t_ta_go));
> +
> +			/* data lane timing ctrl - t_ta_get */
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
Use jiffies + msecs_to_jiffies(xxx) - and drop HZ /2.
Same goes for other similar HZ uses.

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
> +	/*--------------configuring the DPI packet transmission---------------- */
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
> +	/* video mode: low power mode */
> +	set_reg(mipi_dsi_base + MIPIDSI_VID_MODE_CFG_OFFSET, 0x3f, 6, 8);
> +
> +	/* TODO: fix blank display bug when set backlight */
> +	set_reg(mipi_dsi_base + MIPIDSI_DPI_LP_CMD_TIM_OFFSET, 0x4, 8, 16);
> +	/* video mode: send read cmd by lp mode */
> +	set_reg(mipi_dsi_base + MIPIDSI_VID_MODE_CFG_OFFSET, 0x1, 1, 15);
> +
> +	set_reg(mipi_dsi_base + MIPIDSI_VID_PKT_SIZE_OFFSET, rect.w, 14, 0);
> +
> +	/* burst mode */
> +	dsi_set_burst_mode(mipi_dsi_base, dsi->client[id].mode_flags);
> +	/* for dsi read, BTA enable */
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
> +	/* htot = dsi->cur_mode.htotal; */
> +	/* vtot = dsi->cur_mode.vtotal; */
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
> +	hline_time = DIV_ROUND_UP((dsi->ldi.h_pulse_width + dsi->ldi.h_back_porch +
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
> +	/* Define the Vertical line configuration */
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
> +	/* Configure core's phy parameters */
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
> +		/* 16~19bit:pclk_en, pclk_sel, dpipclk_en, dpipclk_sel */
> +		set_reg(mipi_dsi_base + MIPIDSI_CLKMGR_CFG_OFFSET, 0x5, 4, 16);
> +		/* 0:dphy */
> +		set_reg(mipi_dsi_base + KIRIN970_PHY_MODE, 0x0, 1, 0);
> +	}
> +
> +	/* Waking up Core */
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
> +		/* init: wait DPHY 4 data lane stopstate */
> +		pctrl_dphytx_stopcnt = (u64)(dsi->ldi.h_back_porch +
> +			dsi->ldi.h_front_porch + dsi->ldi.h_pulse_width + dsi->cur_mode.hdisplay + 5) *
> +			DEFAULT_PCLK_PCTRL_RATE / (dsi->cur_mode.clock * 1000);
> +		DRM_DEBUG("pctrl_dphytx_stopcnt = %llu\n", pctrl_dphytx_stopcnt);
> +
> +		/* FIXME: */
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
> +	/* dw_dsi_set_mode(dsi, DSI_VIDEO_MODE); */
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
> +	drm_info(drm_dev, "%s:\n", __func__);
> +
> +	/* Link drm_bridge to encoder */
> +	if (!bridge) {
> +		drm_info(drm_dev, "no dsi bridge to attach the encoder\n");
> +		return 0;
> +	}
> +
> +	crtc_mask = drm_of_find_possible_crtcs(drm_dev, dev->of_node);
> +	if (!crtc_mask) {
> +		DRM_ERROR("failed to find crtc mask\n");
> +		return -EINVAL;
> +	}
> +
> +	drm_info(drm_dev, "Initializing CRTC encoder: %d\n",
> +		 crtc_mask);
> +
> +	encoder->possible_crtcs = crtc_mask;
> +	encoder->possible_clones = 0;
> +	ret = drm_encoder_init(drm_dev, encoder, &dw_encoder_funcs,
> +			       DRM_MODE_ENCODER_DSI, NULL);
> +	if (ret) {
> +		drm_info(drm_dev, "failed to init dsi encoder\n");
> +		return ret;
> +	}
> +
> +	drm_encoder_helper_add(encoder, &dw_encoder_helper_funcs);
> +
> +	/* associate the bridge to dsi encoder */
> +	ret = drm_bridge_attach(encoder, bridge, NULL, 0);
> +	if (ret) {
> +		drm_info(drm_dev, "failed to attach external bridge\n");
> +		drm_encoder_cleanup(encoder);
> +	}
> +
> +	return ret;
> +}
All the encoder stuff can, I think, be repalced by the simple encoder.
See how other drivers uses drm_simple_encoder_init()

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
> +	DRM_DEBUG("host attach, client name=[%s], id=%d\n", mdsi->name, id);
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
> +		dev_info(dev, "failed to register dsi host\n");
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
> +	drm_dbg(dev, "Attaching CRTC encoder\n");
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
> +	drm_dbg(dev, "connector init\n");
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
> +
> +	if (ctx->g_dss_version_tag == FB_ACCEL_KIRIN970)
> +		compatible = "hisilicon,kirin970-dsi";
> +	else
> +		compatible = "hisilicon,kirin960-dsi";
> +
> +	np = of_find_compatible_node(NULL, NULL, compatible);
> +	if (!np) {
> +		dev_err(&pdev->dev, "NOT FOUND device node %s!\n", compatible);
> +		return -ENXIO;
> +	}
> +
> +	ctx->base = of_iomap(np, 0);
> +	if (!(ctx->base)) {
> +		dev_err(&pdev->dev, "failed to get dsi base resource.\n");
> +		return -ENXIO;
> +	}
> +
> +	ctx->peri_crg_base = of_iomap(np, 1);
> +	if (!(ctx->peri_crg_base)) {
> +		dev_err(&pdev->dev, "failed to get peri_crg_base resource.\n");
> +		return -ENXIO;
> +	}
> +
> +	if (ctx->g_dss_version_tag == FB_ACCEL_KIRIN970) {
> +		ctx->pctrl_base = of_iomap(np, 2);
> +		if (!(ctx->pctrl_base)) {
> +			dev_err(&pdev->dev,
> +				"failed to get dss pctrl_base resource.\n");
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
> +	DRM_INFO("dsi  cur_client is %d  <0->hdmi;1->panel>\n",
> +		 dsi->cur_client);
> +	/* dis-reset */
> +	/* ip_reset_dis_dsi0, ip_reset_dis_dsi1 */
> +	writel(0x30000000, ctx->peri_crg_base + PERRSTDIS3);
> +
> +	ctx->dss_dphy0_ref_clk = devm_clk_get(&pdev->dev, "clk_txdphy0_ref");
> +	if (IS_ERR(ctx->dss_dphy0_ref_clk)) {
> +		dev_err(&pdev->dev, "failed to get dss_dphy0_ref_clk clock\n");
> +		return PTR_ERR(ctx->dss_dphy0_ref_clk);
> +	}
> +
> +	ret = clk_set_rate(ctx->dss_dphy0_ref_clk, DEFAULT_MIPI_CLK_RATE);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "dss_dphy0_ref_clk clk_set_rate(%lu) failed, error=%d!\n",
> +			  DEFAULT_MIPI_CLK_RATE, ret);
> +		return -EINVAL;
> +	}
> +
> +	DRM_DEBUG("dss_dphy0_ref_clk:[%lu]->[%lu].\n",
> +		  DEFAULT_MIPI_CLK_RATE, clk_get_rate(ctx->dss_dphy0_ref_clk));
> +
> +	ctx->dss_dphy0_cfg_clk = devm_clk_get(&pdev->dev, "clk_txdphy0_cfg");
> +	if (IS_ERR(ctx->dss_dphy0_cfg_clk)) {
> +		dev_err(&pdev->dev, "failed to get dss_dphy0_cfg_clk clock\n");
> +		return PTR_ERR(ctx->dss_dphy0_cfg_clk);
> +	}
> +
> +	ret = clk_set_rate(ctx->dss_dphy0_cfg_clk, DEFAULT_MIPI_CLK_RATE);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "dss_dphy0_cfg_clk clk_set_rate(%lu) failed, error=%d!\n",
> +			  DEFAULT_MIPI_CLK_RATE, ret);
> +		return -EINVAL;
> +	}
> +
> +	DRM_DEBUG("dss_dphy0_cfg_clk:[%lu]->[%lu].\n",
> +		  DEFAULT_MIPI_CLK_RATE, clk_get_rate(ctx->dss_dphy0_cfg_clk));
> +
> +	ctx->dss_pclk_dsi0_clk = devm_clk_get(&pdev->dev, "pclk_dsi0");
> +	if (IS_ERR(ctx->dss_pclk_dsi0_clk)) {
> +		dev_err(&pdev->dev, "failed to get dss_pclk_dsi0_clk clock\n");
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
> +		dev_err(&pdev->dev, "failed to allocate dsi data.\n");
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
> index 000000000000..0e3971ca328c
> --- /dev/null
> +++ b/drivers/staging/hikey9xx/gpu/kirin9xx_dw_dsi_reg.h
> @@ -0,0 +1,142 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (c) 2016 Linaro Limited.
> + * Copyright (c) 2014-2016 Hisilicon Limited.
> + * Copyright (c) 2014-2020, Huawei Technologies Co., Ltd
> + */
> +
> +#ifndef __DW_DSI_REG_H__
> +#define __DW_DSI_REG_H__
> +
> +#define MASK(x)				(BIT(x) - 1)
Not used, delete.

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

Not used I think, so delete if not.

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

