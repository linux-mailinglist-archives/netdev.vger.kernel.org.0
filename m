Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30B5866920B
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 09:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234855AbjAMI72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 03:59:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234718AbjAMI7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 03:59:19 -0500
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089F260CD6;
        Fri, 13 Jan 2023 00:59:16 -0800 (PST)
Received: by mail-qt1-f182.google.com with SMTP id fd15so8643993qtb.9;
        Fri, 13 Jan 2023 00:59:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HIx/98EgJxXRPw6eabRyCtMqFo85a6og6EquEgJiRDY=;
        b=P3MQ5D9sSanfyiSWLMMYawG0IaByrnHR3LWR0J/ngVlbs77UpipzZ67myUuOcHxh+U
         KJwaBfclCdsDirCDwyWusyU/8+JukO/BM6pDQ7Klx6YVIJk7hxmL5rq4ZnD8EHDT9pq3
         QGZeRLHhhfZKD4c8/m9sulc5LZLp9J2XCjiu/b0PwS7Cpq+5fffqC/HDGdAQH0o0j9Pv
         Iao55QppwGJpyOexQACW708C69ZJlIOs1O/fdQkSwa0ojXQwn8HOzKNMksVYxZV0XWWV
         13DOY45db+Gtv8OKaZU43L3txl+XYIaCpgbkzZE0a1Ax6n+jVO+2+MaJ9C7XvWwp/e5F
         CkPQ==
X-Gm-Message-State: AFqh2kqa+yhDSSxULc+Se/eEuQAC5YEarC3UHfVI2OdkixJlGOBtfFsv
        QU4N2qWTN5MYIM69bRr1NNZZisq8PS1Q7A==
X-Google-Smtp-Source: AMrXdXtU5fUgC+Y6jAFJJiOi80N6qQA+TZ4M6b/xL31LQs+0LdhwGXlu8iT5dxX4Ly7rzMJyHKn41Q==
X-Received: by 2002:a05:622a:6027:b0:3a5:264c:5f38 with SMTP id he39-20020a05622a602700b003a5264c5f38mr17422677qtb.63.1673600354935;
        Fri, 13 Jan 2023 00:59:14 -0800 (PST)
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com. [209.85.219.175])
        by smtp.gmail.com with ESMTPSA id g16-20020a05620a40d000b007055fa93060sm12439705qko.79.2023.01.13.00.59.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jan 2023 00:59:13 -0800 (PST)
Received: by mail-yb1-f175.google.com with SMTP id d62so5480065ybh.8;
        Fri, 13 Jan 2023 00:59:13 -0800 (PST)
X-Received: by 2002:a25:7:0:b0:7c1:b2e9:7e71 with SMTP id 7-20020a250007000000b007c1b2e97e71mr838217yba.604.1673600353257;
 Fri, 13 Jan 2023 00:59:13 -0800 (PST)
MIME-Version: 1.0
References: <20230113062339.1909087-1-hch@lst.de> <20230113062339.1909087-3-hch@lst.de>
In-Reply-To: <20230113062339.1909087-3-hch@lst.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 13 Jan 2023 09:59:02 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVM3BpvVD3c4gp1OidnwF5zFd4MJecij7zWBnahzNaSNw@mail.gmail.com>
Message-ID: <CAMuHMdVM3BpvVD3c4gp1OidnwF5zFd4MJecij7zWBnahzNaSNw@mail.gmail.com>
Subject: Re: [PATCH 02/22] usb: remove the dead USB_OHCI_SH option
To:     Christoph Hellwig <hch@lst.de>
Cc:     Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christoph,

On Fri, Jan 13, 2023 at 7:23 AM Christoph Hellwig <hch@lst.de> wrote:
> USB_OHCI_SH is a dummy option that never builds any code, remove it.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks for your patch!
Nice catch!

> --- a/drivers/usb/host/Kconfig
> +++ b/drivers/usb/host/Kconfig
> @@ -548,17 +548,6 @@ config USB_OHCI_HCD_SSB
>
>           If unsure, say N.
>
> -config USB_OHCI_SH
> -       bool "OHCI support for SuperH USB controller (DEPRECATED)"
> -       depends on SUPERH || COMPILE_TEST
> -       select USB_OHCI_HCD_PLATFORM
> -       help
> -         This option is deprecated now and the driver was removed, use
> -         USB_OHCI_HCD_PLATFORM instead.
> -
> -         Enables support for the on-chip OHCI controller on the SuperH.
> -         If you use the PCI OHCI controller, this option is not necessary.
> -

At this point in the series, there are still selects and enablements of
USB_OHCI_SH in arch/sh/Kconfig and arch/sh/configs/sh7757lcr_defconfig.
I think it would be good to replace them by USB_OHCI_HCD_PLATFORM first,
to decouple the fate of this patch from the rest of the series.

>  config USB_OHCI_EXYNOS
>         tristate "OHCI support for Samsung S5P/Exynos SoC Series"
>         depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
