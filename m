Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC50937157
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 12:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbfFFKLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 06:11:34 -0400
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:52491 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728259AbfFFKLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 06:11:34 -0400
Received: from [192.168.2.10] ([46.9.252.75])
        by smtp-cloud7.xs4all.net with ESMTPA
        id YpMehyF6B3qlsYpMihlo7j; Thu, 06 Jun 2019 12:11:31 +0200
Subject: Re: [PATCH 4/8] drivers: media: i2c: fix warning same module names
To:     Anders Roxell <anders.roxell@linaro.org>, airlied@linux.ie,
        daniel@ffwll.ch, a.hajda@samsung.com, mchehab@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        marex@denx.de, stefan@agner.ch, shawnguo@kernel.org,
        s.hauer@pengutronix.de, b.zolnierkie@samsung.com,
        p.zabel@pengutronix.de, hkallweit1@gmail.com, lee.jones@linaro.org,
        lgirdwood@gmail.com, broonie@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org,
        linux-media@vger.kernel.org
References: <20190606094717.23766-1-anders.roxell@linaro.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <70810da0-817a-0863-d9d4-6410c7f4e9b9@xs4all.nl>
Date:   Thu, 6 Jun 2019 12:11:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190606094717.23766-1-anders.roxell@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfAZS+cd+pLaijzjhBz+L7H/aWoGI2ifiKUOPcY/4i27o0giIMr3P3cOG4Z5ABNIakccyPQPCTGlPttM2yk7ggTF/romUsjuwljGIBX2+ZhDG20ND7r/8
 gknRZ4LBNPThxTQVzqQr1Yrt55RLfx0sTK2sFGx59wp6mIKwHxN8NwNPU44tDw5rN/u9TlqRftHQruCiYSDGyo4pMCZIQWVdLHjEt58b1mj4TYhr27JTsKio
 X5JHx2ulb/iQOmE2otX1p9rQyw8lQtZiuPv2K//3jutLbuar/Cyshhg7TJ/mPjj0ULLDTzsO8wV8ANeHylJf45mtLkzlJlRPUHl1nzn77T5CjW2xbK+VBhUB
 ZJudCQ3gclEI1ar2GUzyapbeBi1lE7ek8F6o8Xmb5L+9yhTs3j+l0SGElJfeIvXxmX/udS2v1b+k3pY5cXfPNOC62xgQFFOPJiXoj3R+frLgGhcgeKa/TJwP
 5XONSsEnk8MmJ3QCjJeW2ijvAOqbJY2QRbf2xR87BeuC8/iUNeFTpq4RHLgnQ5Hwz7gypkVeixXlO6gA8BofxEk4Qswzjh/NqFFNKMDI2DjqF/v18ab6mLfi
 XZZa2Tk6J59h/uj/D52k3qdy9QIOSMTempANKnpX2RWEag/Mfa3ao6IFkYKa9cYyCILqpFfdEGDnr2PDpeycr0/Ksd3tLMTYcu+OAewH6no03/+fEUEayBsP
 vmXkDw0HhUqW4EzmZyJjkBLkkpoi1C16YhEZ63tL6ub41pmMUwgd5QVStJPOh0frAaYLngVtSYmyvkPdPcQf89acuwYrvdmzcOmrJk9QIG686MP7Pqyf4YF/
 DjF8AudR+HHTg27UgtTtot0MZsaGF7cDuKoSg8BGIvExF+bSEIuRUJBDZgjglQGMIZzAtTbRCDILv4oFyZKCtZmrBW7DGgfrXbY0Mtbrn/lfsJdIcdpYZfGs
 zkC7fsS3iB+oYw0fy1qVrhvQ6Z8=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/6/19 11:47 AM, Anders Roxell wrote:
> When building with CONFIG_VIDEO_ADV7511 and CONFIG_DRM_I2C_ADV7511
> enabled as loadable modules, we see the following warning:
> 
> warning: same module names found:
>   drivers/gpu/drm/bridge/adv7511/adv7511.ko
>   drivers/media/i2c/adv7511.ko
> 
> Rework so the names matches the config fragment.
> 
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>

Change it in media, not in drm. The v4l2 adv7511 is rarely used, so it
makes sense to rename that, and not this drm driver.

> ---
> This is only one issue that have been addressed.
> The other issue is that itseems to refer to the same device name in
> i2c_device_id, any guidance how that should be solved?

You should never have both modules loaded. In fact, I think it is a good
idea to disable VIDEO_ADV7511 if DRM_I2C_ADV7511 is set in the Kconfig,
unless TEST_COMPILE is also set.

Regards,

	Hans

> 
> 
> Cheers,
> Anders
> 
>  drivers/gpu/drm/bridge/adv7511/Makefile | 10 +++++-----
>  drivers/media/i2c/Makefile              |  3 ++-
>  2 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/gpu/drm/bridge/adv7511/Makefile b/drivers/gpu/drm/bridge/adv7511/Makefile
> index b46ebeb35fd4..e367426bd73e 100644
> --- a/drivers/gpu/drm/bridge/adv7511/Makefile
> +++ b/drivers/gpu/drm/bridge/adv7511/Makefile
> @@ -1,6 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -adv7511-y := adv7511_drv.o
> -adv7511-$(CONFIG_DRM_I2C_ADV7511_AUDIO) += adv7511_audio.o
> -adv7511-$(CONFIG_DRM_I2C_ADV7511_CEC) += adv7511_cec.o
> -adv7511-$(CONFIG_DRM_I2C_ADV7533) += adv7533.o
> -obj-$(CONFIG_DRM_I2C_ADV7511) += adv7511.o
> +drm-i2c-adv7511-y := adv7511_drv.o
> +drm-i2c-adv7511-$(CONFIG_DRM_I2C_ADV7511_AUDIO) += adv7511_audio.o
> +drm-i2c-adv7511-$(CONFIG_DRM_I2C_ADV7511_CEC) += adv7511_cec.o
> +drm-i2c-adv7511-$(CONFIG_DRM_I2C_ADV7533) += adv7533.o
> +obj-$(CONFIG_DRM_I2C_ADV7511) += drm-i2c-adv7511.o
> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
> index d8ad9dad495d..b71a427a89fd 100644
> --- a/drivers/media/i2c/Makefile
> +++ b/drivers/media/i2c/Makefile
> @@ -35,7 +35,8 @@ obj-$(CONFIG_VIDEO_ADV748X) += adv748x/
>  obj-$(CONFIG_VIDEO_ADV7604) += adv7604.o
>  obj-$(CONFIG_VIDEO_ADV7842) += adv7842.o
>  obj-$(CONFIG_VIDEO_AD9389B) += ad9389b.o
> -obj-$(CONFIG_VIDEO_ADV7511) += adv7511.o
> +obj-$(CONFIG_VIDEO_ADV7511) += video-adv7511.o
> +video-adv7511-objs          := adv7511.o
>  obj-$(CONFIG_VIDEO_VPX3220) += vpx3220.o
>  obj-$(CONFIG_VIDEO_VS6624)  += vs6624.o
>  obj-$(CONFIG_VIDEO_BT819) += bt819.o
> 

