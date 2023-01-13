Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 400E866900B
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 09:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240805AbjAMIEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 03:04:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240570AbjAMIDZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 03:03:25 -0500
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [213.167.242.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69CDE25E2;
        Fri, 13 Jan 2023 00:01:06 -0800 (PST)
Received: from pendragon.ideasonboard.com (85-76-5-15-nat.elisa-mobile.fi [85.76.5.15])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 64BE84D4;
        Fri, 13 Jan 2023 09:01:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1673596863;
        bh=cznkdyRGPN+MgO59A5w6zSqYoDDyC4/o8zwGoYFpT/4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X3sDjCHvncH8nOCQqph3lRWmzA+o7ZBGUupBaWsIqvlyia+dSiapzD4cCl/9rmiPJ
         B4jr8NUwZemj7FrJVUMSVm/jr/syT5jAqqHnHz/VIkiEeZojpijB4wyQF8mSckYAYI
         I5Uhh6NRqZJYChzv/4ySxybQmm9DouIDL6rp5RZU=
Date:   Fri, 13 Jan 2023 10:01:02 +0200
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
Subject: Re: [PATCH 20/22] media: remove sh_vou
Message-ID: <Y8EPvllOwhODRUiP@pendragon.ideasonboard.com>
References: <20230113062339.1909087-1-hch@lst.de>
 <20230113062339.1909087-21-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230113062339.1909087-21-hch@lst.de>
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

On Fri, Jan 13, 2023 at 07:23:37AM +0100, Christoph Hellwig wrote:
> Now that arch/sh is removed this driver is dead code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/media/platform/renesas/Kconfig  |    9 -
>  drivers/media/platform/renesas/Makefile |    1 -
>  drivers/media/platform/renesas/sh_vou.c | 1375 -----------------------

You can also emove include/media/drv-intf/sh_vou.sh. With that, and the
corresponding MAINTAINERS entry dropped,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  3 files changed, 1385 deletions(-)
>  delete mode 100644 drivers/media/platform/renesas/sh_vou.c

-- 
Regards,

Laurent Pinchart
