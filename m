Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2720A37162
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 12:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbfFFKNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 06:13:24 -0400
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:59569 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726972AbfFFKNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 06:13:24 -0400
Received: from [192.168.2.10] ([46.9.252.75])
        by smtp-cloud7.xs4all.net with ESMTPA
        id YpOXhyGU13qlsYpOahlotZ; Thu, 06 Jun 2019 12:13:21 +0200
Subject: Re: [PATCH 5/8] drivers: media: coda: fix warning same module names
To:     Anders Roxell <anders.roxell@linaro.org>, mchehab@kernel.org,
        p.zabel@pengutronix.de
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        marex@denx.de, stefan@agner.ch, airlied@linux.ie, daniel@ffwll.ch,
        shawnguo@kernel.org, s.hauer@pengutronix.de,
        b.zolnierkie@samsung.com, a.hajda@samsung.com,
        hkallweit1@gmail.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        broonie@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org,
        linux-media@vger.kernel.org
References: <20190606094722.23816-1-anders.roxell@linaro.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d6b79ee0-07c6-ad81-16b0-8cf929cc214d@xs4all.nl>
Date:   Thu, 6 Jun 2019 12:13:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190606094722.23816-1-anders.roxell@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfF4tKlHxT213q5iKkMxyEhwvsl3wRabWeNLK5xiL8WKLAag63A3TOZyGmKvKw2GQ0WfyjxjXTEd9W8wEzukVk+psIlgFMWLll5pj2JsOATa9DeAuydvZ
 ddjJv6cbw+Yx00MItRjqmMci92xnhEnHpv1M2w59zA1NDNGjmRLSq3cAdtQxlM27/Up8XeGggGd09JeaXKionqZ4Ox8OkYGd75CEkMLwS0I9oFo2oaXlp2qm
 zHxHG7t/dsOA8w/WL8cjzmpNJprbOGialY+uHK0qhAd6ngo3E2+LWOtDMpiv8+29lafVg2h2MXmbJqTrD08YPp+dHbGmMooIEajhJOaXAsTO9DMXSW1DnGgb
 Mi+uPtNhxzXZNVHnKkgZylEAS1Gj9Btw1D2qstbFAGFqawel2DS7gaY7PnQwOyvQDUehTrtumQUrh09usYJrS95kgXOPsOuu9vdTrS9bCu3XLxvP83rFa7K4
 iRkei2i0QauBZ+765x4Q0YbU2MzvUEyEC/yU99imriRBIOT799HstalWgtztqFMWEOMUBGV6QT9McaXUQxxn1zJjzrhgJj6CwFejoRwRWeYKwsW9fgpwBWwy
 NgSZjZuEljrA0R8Der2ECk2NLkklIrPaIzz4+7f45/5Rg3AxiqHLmyd3gj/w7qDJjczZSXQntVVEXmhKhlGVziBa2olD9SYqZW5ea+F4y5ryBoJJXKeRqJdT
 tylLYuM7/v98g46LHLxat4QbrH4tbb0OQ6PVAoOzoPM+fU4eOOTZ318lqx8uL7K4w+bXwy6AyagH24lDBaWhhE6Ak0oPkTiWkzj+zIMgcHnUBVj2qyaZ+tGz
 49QGEH34eopVfAjGrY27QDYRwjAXHkE34k/PrX5pFSdpYBaRZmp7Cy7hsJ65WK3Eqac5SwfaayWzyuqV27vo48JIPhsH5LTGMqwPFbq3mOKKvs5I0+GRKlB3
 Xzk7eNEZqr4/hN04KmzKR9jYfWw=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/6/19 11:47 AM, Anders Roxell wrote:
> When building with CONFIG_VIDEO_CODA and CONFIG_CODA_FS enabled as
> loadable modules, we see the following warning:
> 
> warning: same module names found:
>   fs/coda/coda.ko
>   drivers/media/platform/coda/coda.ko
> 
> Rework so media coda matches the config fragment. Leaving CODA_FS as is
> since thats a well known module.
> 
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
> ---
>  drivers/media/platform/coda/Makefile | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/coda/Makefile b/drivers/media/platform/coda/Makefile
> index 54e9a73a92ab..588e6bf7c190 100644
> --- a/drivers/media/platform/coda/Makefile
> +++ b/drivers/media/platform/coda/Makefile
> @@ -1,6 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  
> -coda-objs := coda-common.o coda-bit.o coda-gdi.o coda-h264.o coda-mpeg2.o coda-mpeg4.o coda-jpeg.o
> +video-coda-objs := coda-common.o coda-bit.o coda-gdi.o coda-h264.o coda-mpeg2.o coda-mpeg4.o coda-jpeg.o
>  
> -obj-$(CONFIG_VIDEO_CODA) += coda.o
> +obj-$(CONFIG_VIDEO_CODA) += video-coda.o

How about imx-coda? video-coda suggests it is part of the video subsystem,
which it isn't.

Regards,

	Hans

>  obj-$(CONFIG_VIDEO_IMX_VDOA) += imx-vdoa.o
> 

