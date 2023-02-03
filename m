Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFF9689727
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 11:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbjBCKlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 05:41:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjBCKlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 05:41:19 -0500
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF2B1BCD;
        Fri,  3 Feb 2023 02:41:18 -0800 (PST)
Received: by mail-qt1-f177.google.com with SMTP id g8so4900859qtq.13;
        Fri, 03 Feb 2023 02:41:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7A9k4QSf8av6qzMk9PJKNV90s0Q4PXBSAXyaJlyJVU8=;
        b=am+1AT4lhoVM6wqmxALHPFCLZUMPsYWhGo62zC7G+AtkY86Opme3by+3C0DEnxtJKP
         JXHTy9dpYDeDQD8+A8kxGjP0/Z45o4NFhedPIKsftsbS9eFr7J1ZwGCQtG7ti0UojZ9k
         mQRU/+i8aOEHs+RIntLkgqXhe2S+7xtMSvhizF7IIOHf3YwtFHBlM+fJOzMrKGqVDsHT
         Pb3jhGNQ+ct1mjcriME4qjGzNMuxYWQlUzxQMOwDKpR6AdlHDj7Lu2vil5fPjcvj+3Li
         lqc5smXXWwhHcWknsdLPvGMcZfGQ3dlqoywHozKD1y5GiWhHfpLqXI6ykJigkRwIxXOv
         kzvw==
X-Gm-Message-State: AO0yUKWvF1f0VsFcoCJ7dx+hcgAfKLyDRrGEYQfFKvz0z20gl3m9dpmy
        R8Q6wGqY+H3IKQpW1hCAPWcLRcYpOMrpJg==
X-Google-Smtp-Source: AK7set+00rykB5Nae53BloQzE0HluidqWGrvcn6wS/Sj78GrbnuGE+A6Txy+8UtQaFzP8LGpaBaySg==
X-Received: by 2002:a05:622a:1ce:b0:3b6:334b:2cbc with SMTP id t14-20020a05622a01ce00b003b6334b2cbcmr19738789qtw.65.1675420877133;
        Fri, 03 Feb 2023 02:41:17 -0800 (PST)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com. [209.85.219.174])
        by smtp.gmail.com with ESMTPSA id o14-20020ac872ce000000b003b62bc6cd1csm1298100qtp.82.2023.02.03.02.41.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 02:41:17 -0800 (PST)
Received: by mail-yb1-f174.google.com with SMTP id 123so5721369ybv.6;
        Fri, 03 Feb 2023 02:41:16 -0800 (PST)
X-Received: by 2002:a25:9c83:0:b0:7bf:d201:60cb with SMTP id
 y3-20020a259c83000000b007bfd20160cbmr900933ybo.365.1675420405273; Fri, 03 Feb
 2023 02:33:25 -0800 (PST)
MIME-Version: 1.0
References: <20230113062339.1909087-1-hch@lst.de> <11e2e0a8-eabe-2d8c-d612-9cdd4bcc3648@physik.fu-berlin.de>
 <20230116071306.GA15848@lst.de> <40dc1bc1-d9cd-d9be-188e-5167ebae235c@physik.fu-berlin.de>
 <20230203071423.GA24833@lst.de> <afd056a95d21944db1dc0c9708f692dd1f7bb757.camel@physik.fu-berlin.de>
 <20230203083037.GA30738@lst.de> <d10fe31b2af6cf4e03618f38ca9d3ca5c72601ed.camel@physik.fu-berlin.de>
In-Reply-To: <d10fe31b2af6cf4e03618f38ca9d3ca5c72601ed.camel@physik.fu-berlin.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 3 Feb 2023 11:33:13 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUitVfW088YOmqYm4kwbKwkwb22fAakHcu6boxv7dXDfQ@mail.gmail.com>
Message-ID: <CAMuHMdUitVfW088YOmqYm4kwbKwkwb22fAakHcu6boxv7dXDfQ@mail.gmail.com>
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
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Adrian,

On Fri, Feb 3, 2023 at 11:29 AM John Paul Adrian Glaubitz
<glaubitz@physik.fu-berlin.de> wrote:
> On Fri, 2023-02-03 at 09:30 +0100, Christoph Hellwig wrote:
> > On Fri, Feb 03, 2023 at 09:24:46AM +0100, John Paul Adrian Glaubitz wrote:
> > > Since this is my very first time stepping up as a kernel maintainer, I was hoping
> > > to get some pointers on what to do to make this happen.
> > >
> > > So far, we have set up a new kernel tree and I have set up a local development and
> > > test environment for SH kernels using my SH7785LCR board as the target platform.
> > >
> > > Do I just need to send a patch asking to change the corresponding entry in the
> > > MAINTAINERS file?
> >
> > I'm not sure a there is a document, but:
> >
> >  - add the MAINTAINERS change to your tree
> >  - ask Stephen to get your tree included in linux-next
> >
> > then eventually send a pull request to Linus with all of that.  Make
> > sure it's been in linux-next for a while.
>
> OK, thanks for the pointers! Will try to get this done by next week.
>
> We're still discussing among SuperH developer community whether there will be a second
> maintainer, so please bear with us a few more days. I will collect patches in the
> meantime.

Thanks a lot!

If you need any help with process, setup, ... don't hesitate to ask
(on e.g. #renesas-soc on Libera).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
