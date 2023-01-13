Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C04668F83
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 08:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239679AbjAMHrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 02:47:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238828AbjAMHqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 02:46:53 -0500
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 233B91B9E6;
        Thu, 12 Jan 2023 23:46:50 -0800 (PST)
Received: from pendragon.ideasonboard.com (85-76-5-15-nat.elisa-mobile.fi [85.76.5.15])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 2CD9D4D4;
        Fri, 13 Jan 2023 08:46:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1673596008;
        bh=wltYQdcEAMz3UcFF0QVHXXUKY2mcn2dIbJ+Vsno/G9o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LPk9GDnJb8yIAG/qZw7j85ZzRhjxe0eUQN+NAsK+9uT/7opY3bx+SaNPEdtJt/mLy
         7ehj3skE2f1g4W6IvOyNfZJFjCDi/ZIYJt389ghohYbhf6hpvDv0vqO0a1KKztGEE2
         l1/4JdyjqER4jRCS7n87hgkuZ+xUKmlP2i0l0lNc=
Date:   Fri, 13 Jan 2023 09:46:47 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arch@vger.kernel.org,
        dmaengine@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH 01/22] gpu/drm: remove the shmobile drm driver
Message-ID: <Y8EMZ0GI5rtor9xr@pendragon.ideasonboard.com>
References: <20230113062339.1909087-1-hch@lst.de>
 <20230113062339.1909087-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230113062339.1909087-2-hch@lst.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christoph,

Thank you for the patch.

On Fri, Jan 13, 2023 at 07:23:18AM +0100, Christoph Hellwig wrote:
> This driver depends on ARM && ARCH_SHMOBILE, but ARCH_SHMOBILE can only be
> set for each/sh, making the driver dead code except for the COMPILE_TEST
> case.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

No objection from me.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/gpu/drm/Kconfig                       |   2 -
>  drivers/gpu/drm/Makefile                      |   1 -
>  drivers/gpu/drm/shmobile/Kconfig              |  12 -
>  drivers/gpu/drm/shmobile/Makefile             |   8 -
>  .../gpu/drm/shmobile/shmob_drm_backlight.c    |  82 ---
>  .../gpu/drm/shmobile/shmob_drm_backlight.h    |  19 -
>  drivers/gpu/drm/shmobile/shmob_drm_crtc.c     | 683 ------------------
>  drivers/gpu/drm/shmobile/shmob_drm_crtc.h     |  55 --
>  drivers/gpu/drm/shmobile/shmob_drm_drv.c      | 303 --------
>  drivers/gpu/drm/shmobile/shmob_drm_drv.h      |  42 --
>  drivers/gpu/drm/shmobile/shmob_drm_kms.c      | 150 ----
>  drivers/gpu/drm/shmobile/shmob_drm_kms.h      |  29 -
>  drivers/gpu/drm/shmobile/shmob_drm_plane.c    | 261 -------
>  drivers/gpu/drm/shmobile/shmob_drm_plane.h    |  19 -
>  drivers/gpu/drm/shmobile/shmob_drm_regs.h     | 310 --------
>  15 files changed, 1976 deletions(-)
>  delete mode 100644 drivers/gpu/drm/shmobile/Kconfig
>  delete mode 100644 drivers/gpu/drm/shmobile/Makefile
>  delete mode 100644 drivers/gpu/drm/shmobile/shmob_drm_backlight.c
>  delete mode 100644 drivers/gpu/drm/shmobile/shmob_drm_backlight.h
>  delete mode 100644 drivers/gpu/drm/shmobile/shmob_drm_crtc.c
>  delete mode 100644 drivers/gpu/drm/shmobile/shmob_drm_crtc.h
>  delete mode 100644 drivers/gpu/drm/shmobile/shmob_drm_drv.c
>  delete mode 100644 drivers/gpu/drm/shmobile/shmob_drm_drv.h
>  delete mode 100644 drivers/gpu/drm/shmobile/shmob_drm_kms.c
>  delete mode 100644 drivers/gpu/drm/shmobile/shmob_drm_kms.h
>  delete mode 100644 drivers/gpu/drm/shmobile/shmob_drm_plane.c
>  delete mode 100644 drivers/gpu/drm/shmobile/shmob_drm_plane.h
>  delete mode 100644 drivers/gpu/drm/shmobile/shmob_drm_regs.h

-- 
Regards,

Laurent Pinchart
