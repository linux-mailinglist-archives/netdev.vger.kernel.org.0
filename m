Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED7216690CC
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 09:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbjAMI1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 03:27:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236408AbjAMI0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 03:26:39 -0500
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 469C354720;
        Fri, 13 Jan 2023 00:26:38 -0800 (PST)
Received: by mail-qt1-f175.google.com with SMTP id fa5so13160786qtb.11;
        Fri, 13 Jan 2023 00:26:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IGwwX1FWc34aVprY9nV8lSjSaarIXrtB/QPl3dMA44o=;
        b=OrBkA4O+sdQHPVGLv9QcAtvIvznY+EGGznQc5W0bTyWkp2OTvaHsKpMVX3qGW1Km4p
         crT+1gToCalQ+RmJ17XDjzdGCnkT9AuEtGdp0JrKhUStjt6T8EDF0JR0rHmr4Ku/WCcE
         hiYBtq/ITL/Y55K3wLv2rkn1jwa4LTpg12581d135NToqljp/txHTkooefmrpq7k5zLl
         h+tdhx/1GBdIY+9jsDej0vggdV9Txf8DMRyoSnYz6SaH7vDu/ksyrH3ROEoZB0x0wmOQ
         DTwptN0akfuakj9tMxAuIge1aIfeIBGXuz8Vy/IxhhJltxwo7t0Yh4DlZKU5xuGHq5f9
         KkaA==
X-Gm-Message-State: AFqh2kp8n91rm+VJ8dh441RedMH1e7dl5ItueXtgIuHk9v/S4wHqpuxV
        9ZO/uqGXlJVi8l3uW0/ysTqR81QUolPfHg==
X-Google-Smtp-Source: AMrXdXsI1f7si/IK4pBGwX1g5ZCcbE0uL3G3n+rXVsKaK42NeEsUXSU8qYMrQi2bt3777QW8XztbPA==
X-Received: by 2002:a05:622a:6011:b0:3a9:8561:429a with SMTP id he17-20020a05622a601100b003a98561429amr17639336qtb.26.1673598396801;
        Fri, 13 Jan 2023 00:26:36 -0800 (PST)
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com. [209.85.219.177])
        by smtp.gmail.com with ESMTPSA id bk25-20020a05620a1a1900b006ff8ac9acfdsm12401133qkb.49.2023.01.13.00.26.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jan 2023 00:26:35 -0800 (PST)
Received: by mail-yb1-f177.google.com with SMTP id g4so21534409ybg.7;
        Fri, 13 Jan 2023 00:26:35 -0800 (PST)
X-Received: by 2002:a25:7:0:b0:7c1:b2e9:7e71 with SMTP id 7-20020a250007000000b007c1b2e97e71mr830819yba.604.1673598394939;
 Fri, 13 Jan 2023 00:26:34 -0800 (PST)
MIME-Version: 1.0
References: <20230113062339.1909087-1-hch@lst.de> <11e2e0a8-eabe-2d8c-d612-9cdd4bcc3648@physik.fu-berlin.de>
In-Reply-To: <11e2e0a8-eabe-2d8c-d612-9cdd4bcc3648@physik.fu-berlin.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 13 Jan 2023 09:26:23 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUcnP6a9Ch5=_CMPq-io-YWK5pshkOT2nZmP1hvNcwBAg@mail.gmail.com>
Message-ID: <CAMuHMdUcnP6a9Ch5=_CMPq-io-YWK5pshkOT2nZmP1hvNcwBAg@mail.gmail.com>
Subject: Re: remove arch/sh
To:     John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc:     Christoph Hellwig <hch@lst.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
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
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 9:10 AM John Paul Adrian Glaubitz
<glaubitz@physik.fu-berlin.de> wrote:
> On 1/13/23 07:23, Christoph Hellwig wrote:
> > arch/sh has been a long drag because it supports a lot of SOCs, and most
> > of them haven't even been converted to device tree infrastructure.  These
> > SOCs are generally obsolete as well, and all of the support has been barely
> > maintained for almost 10 years, and not at all for more than 1 year.
> >
> > Drop arch/sh and everything that depends on it.
>
> I'm still maintaining and using this port in Debian.
>
> It's a bit disappointing that people keep hammering on it. It works fine for me.

Indeed.  The main issue is not the lack of people sending patches and
fixes, but those patches never being applied by the maintainers.
Perhaps someone is willing to stand up to take over maintainership?

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
