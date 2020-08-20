Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2C124AF45
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 08:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgHTGeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 02:34:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:38658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725778AbgHTGeZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 02:34:25 -0400
Received: from coco.lan (ip5f5ad5a3.dynamic.kabel-deutschland.de [95.90.213.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F6AF2076E;
        Thu, 20 Aug 2020 06:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597905262;
        bh=BfHozWh6kPOwVZnZ5alNRgHDl/8qIGOcbL0zFhOlxr4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f+Tx8ZeGGaMHlAiE9gFg/CKrAKL3lsTdxURn32tRpWkKB/KYx3sDACAmO+S92wdL0
         e2msrlg6vEkzmEAhy55+sRXIFwphAUjD2/CbcfK+qSGveJr6YZuniPlAWlVkJG8pLX
         xPZ+GETDlIXsbMoHo3LJOmrvLBFIWvxcEVUc7ztE=
Date:   Thu, 20 Aug 2020 08:34:11 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     John Stultz <john.stultz@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linuxarm@huawei.com, mauro.chehab@huawei.com,
        Manivannan Sadhasivam <mani@kernel.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Bogdan Togorean <bogdan.togorean@analog.com>,
        Liwei Cai <cailiwei@hisilicon.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Xinliang Liu <xinliang.liu@linaro.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Wanchun Zheng <zhengwanchun@hisilicon.com>,
        driverdevel <devel@driverdev.osuosl.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        Xiubin Zhang <zhangxiubin1@huawei.com>,
        linux-media <linux-media@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Xinwei Kong <kong.kongxinwei@hisilicon.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, Rob Clark <robdclark@chromium.org>,
        Laurentiu Palcu <laurentiu.palcu@nxp.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Liuyao An <anliuyao@huawei.com>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK" 
        <linaro-mm-sig@lists.linaro.org>, Wei Xu <xuwei5@hisilicon.com>,
        Rongrong Zou <zourongrong@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sam Ravnborg <sam@ravnborg.org>,
        Network Development <netdev@vger.kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Chen Feng <puck.chen@hisilicon.com>
Subject: Re: [PATCH 00/49] DRM driver for Hikey 970
Message-ID: <20200820083411.666a4d13@coco.lan>
In-Reply-To: <CALAqxLVRsPKv-xmxQfBFaBa9XOmSfrFj3w9_zyfzNJk8+Kfjug@mail.gmail.com>
References: <cover.1597833138.git.mchehab+huawei@kernel.org>
        <CALAqxLVRsPKv-xmxQfBFaBa9XOmSfrFj3w9_zyfzNJk8+Kfjug@mail.gmail.com>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, 19 Aug 2020 14:13:05 -0700
John Stultz <john.stultz@linaro.org> escreveu:

> On Wed, Aug 19, 2020 at 4:46 AM Mauro Carvalho Chehab
> <mchehab+huawei@kernel.org> wrote:
> > Yet, I'm submitting it via staging due to the following reasons:
> >
> > - It depends on the LDO3 power supply, which is provided by
> >   a regulator driver that it is currently on staging;
> > - Due to legal reasons, I need to preserve the authorship of
> >   each one responsbile for each patch. So, I need to start from
> >   the original patch from Kernel 4.4;
> > - There are still some problems I need to figure out how to solve:
> >    - The adv7535 can't get EDID data. Maybe it is a timing issue,
> >      but it requires more research to be sure about how to solve it;  
> 
> I've seen this on the HiKey960 as well. There is a patch to the
> adv7533 driver I have to add a mdelay that seems to consistently
> resolve the timing problem.  At some point I mentioned it to one of
> the maintainers who seems open to having it added, but it seemed silly
> to submit it until there was a upstream driver that needed such a
> change.  So I think that patch can be submitted as a follow on to this
> (hopefully cleaned up) series.

Yeah, I saw that mdelay() patch on your tree. While it should be cheap
to add a mdelay() or udelay_range() there, I'm not sure if this is just a 
timing issue or if something else is missing. The 4.9 driver does some 
extra setups on adv7535 (see the enclosed patch).

I'm wondering if something from that is missing. Btw, IMHO, one
interesting setting on the downstream code is support for colorbar test.
This was helpful when I was making this driver work upstream, as it
could be useful for someone trying to make some other DRM driver using it.

> 
> >    - The driver only accept resolutions on a defined list, as there's
> >      a known bug that this driver may have troubles with random
> >      resolutions. Probably due to a bug at the pixel clock settings;  
> 
> So, yes, the SoC clks can't generate proper signals for HDMI
> frequencies (apparently it's not an issue for panels). There is a
> fixed set that we can get "close enough" that most monitors will work,
> but its always a bit iffy (some monitors are strict in what they
> take).

There is an extra logic for Kirin 620 that seems to be validating
the frequencies that would be set to the clocks. If they're out of
the range, it would return MODE_BAD. I suspect that something similar
would be needed for Kirin 970 and 960. With that regards, 970 is
different from 960. I actually tried to write a patch for it, but
I guess there are still some things missing on my code, for 970.

This patch:

	https://gitlab.freedesktop.org/mchehab_kernel/hikey-970/-/commit/4614415770b33e27a9f15c7dde20895fb750592f

Splits the part of the code which calculates the clk_Hz from the
part which sets it. So, now, dss_calculate_clock() checks the
pixel clock frequency and adjusts it, if needed. 

I have another patch that were checking if the code modified the
clock_Hz at dss_crtc_mode_fixup(). With that, it would be easy to
return MODE_INVALID if something bad happens. However, such
patch didn't work as I would expect, so I ended dropping it.

> On the kirin driver, we were able to do a calculation to figure out if
> the generated frequency would be close enough:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/gpu/drm/hisilicon/kirin/dw_drm_dsi.c#n615
> 
> I suspect we could do something similar for the hikey960/70, but I've
> not really had time to dig in deeply there.

Yeah, I tried something similar to that. Maybe it will work properly
for Hikey 960, but Hikey 970 has a much more complex code to setup
the pixel clock. On 960, just one clock is set:

	clk_set_rate(ctx->dss_pxl0_clk, clk_Hz);

While, on 970, pxl0 is always set to the same frequency (144 MHz),
at least for pixel clocks up to 255 MHz[1], but the code do some
complex calculus to setup PLL7 registers using the clock frequency. 

[1] pixel clocks above 255 MHz will be rejected anyway, as they'll
return MODE_BAD due to the checks if a mode is valid.

> 
> Personally, I don't see the allow-list as a problematic short term
> solution, and again, not sure its worth pushing to staging for.

Yeah, I guess we can live with that for a while.

> 
> >    - Sometimes (at least with 1080p), it generates LDI underflow
> >      errors, which in turn causes the DRM to stop working. That
> >      happens for example when using gdm on Wayland and
> >      gnome on X11;  
> 
> Interestingly, I've not seen this on HiKey960 (at least with
> Android/Surfaceflinger).

Here, it happens all the time when the monitor returns back from DPMS
suspend. It also happens on some specific cases (X11 x Wayland), 
console mode + startx, etc.

It sounds to me that it occurs when the driver tries to setup a new
resolution. Maybe something needs to be disabled before changing res
(and re-enabled afterwards).

> The original HiKey board does have the
> trouble where at 1080p the screen sometimes comes up horizontally
> offset due to the LDI underflow, but the patches to address it have
> been worse then the problem, so we reverted those.

The "visible" effect on my monitor is that the image disappears, 
and the monitor complains that there's an "Invalid Mode" at the HDMI
signal.

> 
> >    - Probably related to the previous issue, when the monitor
> >      suspends due to DPMS, it doesn't return back to life.
> >  
> 
> I don't believe I see this on HiKey960. But if it's the LDI issue on
> the 970 that may explain it.

Yes, when this happens, I get LDI underflow messages.

> > So, IMO, the best is to keep it on staging for a while, until those
> > remaining bugs gets solved.  
> 
> I'm not sure I see all of these as compelling for pushing it in via
> staging. And I suspect in the process of submitting the patches for
> review folks may find the cause of some of the problems you list here.

Yeah, I hope we can get rid of at least part of those during the
review process ;-)

Yet, I'd like to preserve the history. As the enclosed patch shows,
maybe there are some hidden gems at the previously existing code.

I may also have done something wrong when converting the driver.
So, preserving the history seems to be a good idea to me.

One of the advantages of using staging is that the full history
will be preserved at the incremental code at staging, while the
final patch moving the code out of staging will have all the changes
folded together into a single patch.

That makes easier for people to do a final review on it.

Also, some subsystem maintainers don't like the idea of merging the
entire history on their subsystems.

> Nit: This is a display driver and has little to do with the GPU (other
> then it will eventually live in drivers/gpu/drm/...), so I might
> suggest using more conventional subject prefix,  "drm: hisilicon:"

Ah, OK! I'll change the prefix at the next versions of this series.

Thanks,
Mauro

HACK: Some changes from downstream to adv7511 code

diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511.h b/drivers/gpu/drm/bridge/adv7511/adv7511.h
index a9bb734366ae..1440c08caf42 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511.h
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511.h
@@ -333,6 +333,7 @@ struct adv7511 {
 
 	struct regmap *regmap;
 	struct regmap *regmap_cec;
+	struct regmap *regmap_packet;
 	enum drm_connector_status status;
 	bool powered;
 
diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
index d59b37a2ae23..c9fbcb40f962 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
@@ -325,6 +325,153 @@ static void adv7511_set_link_config(struct adv7511 *adv7511,
 	adv7511->rgb = config->input_colorspace == HDMI_COLORSPACE_RGB;
 }
 
+static void adv7511_dsi_config_tgen(struct adv7511 *adv7511)
+{
+	struct drm_display_mode *mode = &adv7511->curr_mode;
+	unsigned int hsw, hfp, hbp, vsw, vfp, vbp;
+#ifndef TEST_COLORBAR_DISPLAY
+	u8 clock_div_by_lanes[] = { 6, 4, 3 }; /* 2, 3, 4 lanes */
+#endif
+
+	hsw = mode->hsync_end - mode->hsync_start;
+	hfp = mode->hsync_start - mode->hdisplay;
+	hbp = mode->htotal - mode->hsync_end;
+	vsw = mode->vsync_end - mode->vsync_start;
+	vfp = mode->vsync_start - mode->vdisplay;
+	vbp = mode->vtotal - mode->vsync_end;
+
+#ifdef TEST_COLORBAR_DISPLAY
+	/* set pixel clock auto mode */
+	regmap_write(adv7511->regmap_cec, 0x16,
+			0x00);
+#else
+	/* set pixel clock divider mode */
+	regmap_write(adv7511->regmap_cec, 0x16,
+			clock_div_by_lanes[adv7511->num_dsi_lanes - 2] << 3);
+#endif
+
+	/* horizontal porch params */
+	regmap_write(adv7511->regmap_cec, 0x28, mode->htotal >> 4);
+	regmap_write(adv7511->regmap_cec, 0x29, (mode->htotal << 4) & 0xff);
+	regmap_write(adv7511->regmap_cec, 0x2a, hsw >> 4);
+	regmap_write(adv7511->regmap_cec, 0x2b, (hsw << 4) & 0xff);
+	regmap_write(adv7511->regmap_cec, 0x2c, hfp >> 4);
+	regmap_write(adv7511->regmap_cec, 0x2d, (hfp << 4) & 0xff);
+	regmap_write(adv7511->regmap_cec, 0x2e, hbp >> 4);
+	regmap_write(adv7511->regmap_cec, 0x2f, (hbp << 4) & 0xff);
+
+	/* vertical porch params */
+	regmap_write(adv7511->regmap_cec, 0x30, mode->vtotal >> 4);
+	regmap_write(adv7511->regmap_cec, 0x31, (mode->vtotal << 4) & 0xff);
+	regmap_write(adv7511->regmap_cec, 0x32, vsw >> 4);
+	regmap_write(adv7511->regmap_cec, 0x33, (vsw << 4) & 0xff);
+	regmap_write(adv7511->regmap_cec, 0x34, vfp >> 4);
+	regmap_write(adv7511->regmap_cec, 0x35, (vfp << 4) & 0xff);
+	regmap_write(adv7511->regmap_cec, 0x36, vbp >> 4);
+	regmap_write(adv7511->regmap_cec, 0x37, (vbp << 4) & 0xff);
+}
+
+static void hikey970_hack_dpms(struct adv7511 *adv7511)
+{
+
+DRM_ERROR("Calling %s\n", __func__);
+
+	struct mipi_dsi_device *dsi = adv7511->dsi;
+
+	adv7511_dsi_config_tgen(adv7511);
+
+	/* set number of dsi lanes */
+	regmap_write(adv7511->regmap_cec, 0x1c, dsi->lanes << 4);
+
+#ifdef TEST_COLORBAR_DISPLAY
+	/* reset internal timing generator */
+	regmap_write(adv7511->regmap_cec, 0x27, 0xcb);
+	regmap_write(adv7511->regmap_cec, 0x27, 0x8b);
+	regmap_write(adv7511->regmap_cec, 0x27, 0xcb);
+#else
+	/* disable internal timing generator */
+	regmap_write(adv7511->regmap_cec, 0x27, 0x0b);
+#endif
+
+
+	/* enable hdmi */
+	regmap_write(adv7511->regmap_cec, 0x03, 0x89);
+#ifdef TEST_COLORBAR_DISPLAY
+	/*enable test mode */
+	regmap_write(adv7511->regmap_cec, 0x55, 0x80);//display colorbar
+#else
+	/* disable test mode */
+	regmap_write(adv7511->regmap_cec, 0x55, 0x00);
+#endif
+	/* disable test mode */
+	//regmap_write(adv7511->regmap_cec, 0x55, 0x00);
+	/* SPD */
+	{
+		static const unsigned char spd_if[] = {
+			0x83, 0x01, 25, 0x00,
+			'L', 'i', 'n', 'a', 'r', 'o', 0, 0,
+			'9', '6', 'b', 'o', 'a', 'r', 'd', 's',
+			':', 'H', 'i', 'k', 'e', 'y', 0, 0,
+		};
+		int n;
+
+		for (n = 0; n < sizeof(spd_if); n++)
+			regmap_write(adv7511->regmap_packet, n, spd_if[n]);
+
+		/* enable send SPD */
+		regmap_update_bits(adv7511->regmap, 0x40, BIT(6), BIT(6));
+	}
+
+	/* force audio */
+	/* hide Audio infoframe updates */
+	regmap_update_bits(adv7511->regmap, 0x4a, BIT(5), BIT(5));
+
+	/* i2s, internal mclk, mclk-256 */
+	regmap_update_bits(adv7511->regmap, 0x0a, 0x1f, 1);
+	regmap_update_bits(adv7511->regmap, 0x0b, 0xe0, 0);
+	/* enable i2s, use i2s format, sample rate from i2s */
+	regmap_update_bits(adv7511->regmap, 0x0c, 0xc7, BIT(2));
+	/* 16 bit audio */
+	regmap_update_bits(adv7511->regmap, 0x0d, 0xff, 16);
+	/* 16-bit audio */
+	regmap_update_bits(adv7511->regmap, 0x14, 0x0f, 2 << 4);
+	/* 48kHz */
+	regmap_update_bits(adv7511->regmap, 0x15, 0xf0, 2 << 4);
+	/* enable N/CTS, enable Audio sample packets */
+	regmap_update_bits(adv7511->regmap, 0x44, BIT(5), BIT(5));
+	/* N = 6144 */
+	regmap_write(adv7511->regmap, 1, (6144 >> 16) & 0xf);
+	regmap_write(adv7511->regmap, 2, (6144 >> 8) & 0xff);
+	regmap_write(adv7511->regmap, 3, (6144) & 0xff);
+	/* automatic cts */
+	regmap_update_bits(adv7511->regmap, 0x0a, BIT(7), 0);
+	/* enable N/CTS */
+	regmap_update_bits(adv7511->regmap, 0x44, BIT(6), BIT(6));
+	/* not copyrighted */
+	regmap_update_bits(adv7511->regmap, 0x12, BIT(5), BIT(5));
+
+	/* left source */
+	regmap_update_bits(adv7511->regmap, 0x0e, 7 << 3, 0);
+	/* right source */
+	regmap_update_bits(adv7511->regmap, 0x0e, 7 << 0, 1);
+	/* number of channels: sect 4.5.4: set to 0 */
+	regmap_update_bits(adv7511->regmap, 0x73, 7, 1);
+	/* number of channels: sect 4.5.4: set to 0 */
+	regmap_update_bits(adv7511->regmap, 0x73, 0xf0, 1 << 4);
+	/* sample rate: 48kHz */
+	regmap_update_bits(adv7511->regmap, 0x74, 7 << 2, 3 << 2);
+	/* channel allocation reg: sect 4.5.4: set to 0 */
+	regmap_update_bits(adv7511->regmap, 0x76, 0xff, 0);
+	/* enable audio infoframes */
+	regmap_update_bits(adv7511->regmap, 0x44, BIT(3), BIT(3));
+
+	/* AV mute disable */
+	regmap_update_bits(adv7511->regmap, 0x4b, BIT(7) | BIT(6), BIT(7));
+
+	/* use Audio infoframe updated info */
+	regmap_update_bits(adv7511->regmap, 0x4a, BIT(5), 0);
+}
+
 static void __adv7511_power_on(struct adv7511 *adv7511)
 {
 	adv7511->current_edid_segment = -1;
@@ -367,8 +514,10 @@ static void adv7511_power_on(struct adv7511 *adv7511)
 	 */
 	regcache_sync(adv7511->regmap);
 
-	if (adv7511->type == ADV7533 || adv7511->type == ADV7535)
+	if (adv7511->type == ADV7533 || adv7511->type == ADV7535) {
 		adv7533_dsi_power_on(adv7511);
+		hikey970_hack_dpms(adv7511);
+	}
 	adv7511->powered = true;
 }
 
@@ -981,8 +1130,10 @@ static int adv7511_init_regulators(struct adv7511 *adv)
 		adv->supplies[i].supply = supply_names[i];
 
 	ret = devm_regulator_bulk_get(dev, adv->num_supplies, adv->supplies);
-	if (ret)
+	if (ret) {
+		dev_err(dev, "Can't get all regulators\n");
 		return ret;
+	}
 
 	return regulator_bulk_enable(adv->num_supplies, adv->supplies);
 }
@@ -1022,6 +1173,14 @@ static const struct regmap_config adv7511_cec_regmap_config = {
 	.volatile_reg = adv7511_cec_register_volatile,
 };
 
+static const struct regmap_config adv7533_packet_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+
+	.max_register = 0xff,
+	.cache_type = REGCACHE_RBTREE,
+};
+
 static int adv7511_init_cec_regmap(struct adv7511 *adv)
 {
 	int ret;
@@ -1045,6 +1204,14 @@ static int adv7511_init_cec_regmap(struct adv7511 *adv)
 			goto err;
 	}
 
+	adv->regmap_packet = devm_regmap_init_i2c(adv->i2c_packet,
+						      &adv7533_packet_regmap_config);
+	if (IS_ERR(adv->regmap_packet)) {
+		ret = PTR_ERR(adv->regmap_packet);
+		goto err;
+	}
+
+
 	return 0;
 err:
 	i2c_unregister_device(adv->i2c_cec);
@@ -1168,8 +1335,8 @@ static int adv7511_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 		return ret;
 
 	ret = adv7511_init_regulators(adv7511);
-	if (ret != -EPROBE_DEFER) {
-		dev_err(dev, "failed to init regulators\n");
+	if (ret && ret != -EPROBE_DEFER) {
+		dev_err(dev, "failed to init regulators: %d\n", ret);
 		return ret;
 	}
 


