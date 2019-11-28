Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9611410CFF9
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 00:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbfK1Xf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 18:35:27 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:48486 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbfK1Xf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 18:35:27 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: gtucker)
        with ESMTPSA id 872BE2926DA
Subject: Re: broonie-spi/for-next bisection: boot on beaglebone-black
To:     Hulk Robot <hulkci@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        tomeu.vizoso@collabora.com, broonie@kernel.org,
        khilman@baylibre.com, mgalka@collabora.com,
        enric.balletbo@collabora.com, YueHaibing <yuehaibing@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <5de04b68.1c69fb81.66084.da9a@mx.google.com>
From:   Guillaume Tucker <guillaume.tucker@collabora.com>
Message-ID: <61ce626c-e2d5-0ad5-df19-55e4ce7371a8@collabora.com>
Date:   Thu, 28 Nov 2019 23:35:22 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <5de04b68.1c69fb81.66084.da9a@mx.google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/11/2019 22:34, kernelci.org bot wrote:
> * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
> * This automated bisection report was sent to you on the basis  *
> * that you may be involved with the breaking commit it has      *
> * found.  No manual investigation has been done to verify it,   *
> * and the root cause of the problem may be somewhere else.      *
> *                                                               *
> * If you do send a fix, please include this trailer:            *
> *   Reported-by: "kernelci.org bot" <bot@kernelci.org>          *
> *                                                               *
> * Hope this helps!                                              *
> * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
> 
> broonie-spi/for-next bisection: boot on beaglebone-black
> 
> Summary:
>   Start:      0e6352f543fd Merge remote-tracking branch 'spi/topic/ptp' into spi-next
>   Details:    https://kernelci.org/boot/id/5ddfdaf8a8a8d1882ba1b7a1
>   Plain log:  https://storage.kernelci.org//broonie-spi/for-next/v5.4-rc8-117-g0e6352f543fd/arm/omap2plus_defconfig/gcc-8/lab-baylibre/boot-am335x-boneblack.txt
>   HTML log:   https://storage.kernelci.org//broonie-spi/for-next/v5.4-rc8-117-g0e6352f543fd/arm/omap2plus_defconfig/gcc-8/lab-baylibre/boot-am335x-boneblack.html
>   Result:     1d4639567d97 mdio_bus: Fix PTR_ERR applied after initialization to constant
> 
> Checks:
>   revert:     PASS
>   verify:     PASS
> 
> Parameters:
>   Tree:       broonie-spi
>   URL:        https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git
>   Branch:     for-next
>   Target:     beaglebone-black
>   CPU arch:   arm
>   Lab:        lab-baylibre
>   Compiler:   gcc-8
>   Config:     omap2plus_defconfig
>   Test suite: boot
> 
> Breaking commit found:
> 
> -------------------------------------------------------------------------------
> commit 1d4639567d970de087a893521f7f50a32740b595
> Author: YueHaibing <yuehaibing@huawei.com>
> Date:   Mon Nov 11 15:13:47 2019 +0800
> 
>     mdio_bus: Fix PTR_ERR applied after initialization to constant

Sorry for the noise again, disabling bisections on broonie-spi as
well.  It appears that this patch has spread to many branches but
not the fix for it.  I'll take a closer look at why this happened
and see if we can find a way to avoid it in the future.

Guillaume
