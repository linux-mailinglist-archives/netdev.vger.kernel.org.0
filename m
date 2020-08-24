Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0255124F2B6
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 08:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgHXGtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 02:49:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgHXGtm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 02:49:42 -0400
Received: from coco.lan (unknown [95.90.213.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB28A2067C;
        Mon, 24 Aug 2020 06:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598251781;
        bh=MoR5l415tOqXO7qDvbGK3qkYCXTWIk9BbyxnSBH+NOA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d8Fa9jnF4RxQAHQUfTQiJnd1/Cv3peOrzUsQ+uvrMSfO9dxpXk5FFmL8qQR+62r2d
         /5Z+CzrXnWZx+hAETh664fBPlISrF9QHDL0J3KIvyrE+0W2sam4bZO9CkasBh6uuiy
         Lifm+3q0OlCTMYdbS1UXGwLbhr7/E/XclY5RLP1s=
Date:   Mon, 24 Aug 2020 08:49:30 +0200
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
Message-ID: <20200824084853.10560ed1@coco.lan>
In-Reply-To: <CALAqxLULQvW3UikCHpEzSDnpeYnBy8wDSsWZNbSrmivQTW3_Sg@mail.gmail.com>
References: <cover.1597833138.git.mchehab+huawei@kernel.org>
        <CALAqxLU3bt6fT4nGHZFSnzyQq4xJo2On=c_Oa9ONED9-jhaFgw@mail.gmail.com>
        <CALAqxLW98nVc-=8Q6nx-wRP1z8pzkw1_zNc9M7V3GhnJQqM9rg@mail.gmail.com>
        <CALAqxLULQvW3UikCHpEzSDnpeYnBy8wDSsWZNbSrmivQTW3_Sg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi John,

Em Wed, 19 Aug 2020 20:28:44 -0700
John Stultz <john.stultz@linaro.org> escreveu:


> That said even with the patches I've got on top of your series, I
> still see a few issues:
> 1) I'm seeing red-blue swap with your driver.  I need to dig a bit to
> see what the difference is, I know gralloc has a config option for
> this, and maybe the version of the driver I'm carrying has it wrong?

Maybe it is due to this:

	drivers/staging/hikey9xx/gpu/kirin9xx_drm_overlay_utils.c:      hal_fmt = HISI_FB_PIXEL_FORMAT_BGRA_8888;/* dss_get_format(fb->pixel_format); */

It sounds to me that someone added a hack hardcoding BGRA_8888 over
there.

Btw, I removed the hack, with:


diff --git a/drivers/staging/hikey9xx/gpu/kirin9xx_drm_overlay_utils.c b/drivers/staging/hikey9xx/gpu/kirin9xx_drm_overlay_utils.c
index a68db1a27bbf..ba64aae371e4 100644
--- a/drivers/staging/hikey9xx/gpu/kirin9xx_drm_overlay_utils.c
+++ b/drivers/staging/hikey9xx/gpu/kirin9xx_drm_overlay_utils.c
@@ -857,7 +857,7 @@ void hisi_fb_pan_display(struct drm_plane *plane)
        rect.right = src_w - 1;
        rect.top = 0;
        rect.bottom = src_h - 1;
-       hal_fmt = HISI_FB_PIXEL_FORMAT_BGRA_8888;/* dss_get_format(fb->pixel_format); */
+       hal_fmt = dss_get_format(fb->format->format);
 
        DRM_DEBUG_DRIVER("channel%d: src:(%d,%d, %dx%d) crtc:(%d,%d, %dx%d), rect(%d,%d,%d,%d),fb:%dx%d, pixel_format=%d, stride=%d, paddr=0x%x, bpp=%d.\n",
                         chn_idx, src_x, src_y, src_w, src_h,


And now red and blue are swapped on my HDMI screen too.

I'll compare this part with your version, but I guess the bug is
on this logic.


Thanks,
Mauro
