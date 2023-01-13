Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C409F669C00
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 16:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbjAMP0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 10:26:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbjAMP0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 10:26:15 -0500
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 288F47278D;
        Fri, 13 Jan 2023 07:18:56 -0800 (PST)
Received: by mail-oi1-f175.google.com with SMTP id n8so17958266oih.0;
        Fri, 13 Jan 2023 07:18:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ieDDnBbNB9JJsaMwpNzXJlERKk1wwpqLtOrBhJRfGpo=;
        b=IZra8qjrcHr3eLbPGF9QPAUCfQ/039Fts8ql1H2MrriLwt0C+pWfFHzqSsotqYsAkf
         ZGo295nFFgvvEGxogSV2+JT7dob+NPjhG6hSRVsSZStYXkIyyc7dRVaEMIjGOPDCY9UK
         O66HdNI62tmqqgNk4dw9CPXy91TGjtJr2fqRjuM7anMwV5/cU60RP24hQt89WtTVNqD6
         qm59rGQO/Vh2r/WPj3KKafL7EkljDSCZrJJCFgAedT0SCouSgdjtS6bWTso0aNsabsX3
         OemNwBFGDatZgl2lLsDvvKLMAj/NRVfdqPyDzT0KS1DNd7eaaeYFdj7LiY8ZZyIznUot
         XpvQ==
X-Gm-Message-State: AFqh2kpj4Uo7mbYOiA4tQZeNtkdhNKVxyY6iHmSGExsuQsB6IR7DIX8d
        9wfsKuz4lP2bsRMc5dSsNQ==
X-Google-Smtp-Source: AMrXdXvKjUuXqtnMP8HRUWF6KklExF2oSAG2rWu9CjnEqT3LUV2kOArvIgWmH2DzIBq+esFLR8R2ag==
X-Received: by 2002:a05:6808:996:b0:364:c003:e1ba with SMTP id a22-20020a056808099600b00364c003e1bamr517132oic.46.1673623135307;
        Fri, 13 Jan 2023 07:18:55 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id w11-20020a0568080d4b00b0035c422bb303sm9298016oik.19.2023.01.13.07.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 07:18:54 -0800 (PST)
Received: (nullmailer pid 2206759 invoked by uid 1000);
        Fri, 13 Jan 2023 15:18:53 -0000
Date:   Fri, 13 Jan 2023 09:18:53 -0600
From:   Rob Herring <robh@kernel.org>
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
Subject: Re: remove arch/sh
Message-ID: <20230113151853.GA2184281-robh@kernel.org>
References: <20230113062339.1909087-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113062339.1909087-1-hch@lst.de>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 07:23:17AM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> arch/sh has been a long drag because it supports a lot of SOCs, and most
> of them haven't even been converted to device tree infrastructure.  These
> SOCs are generally obsolete as well, and all of the support has been barely
> maintained for almost 10 years, and not at all for more than 1 year.
> 
> Drop arch/sh and everything that depends on it.
> 
> Diffstat:
>  Documentation/sh/booting.rst                             |   12 
>  Documentation/sh/features.rst                            |    3 
>  Documentation/sh/index.rst                               |   56 
>  Documentation/sh/new-machine.rst                         |  277 -
>  Documentation/sh/register-banks.rst                      |   40 

Can you please also remove:

Documentation/devicetree/bindings/mtd/flctl-nand.txt
Documentation/devicetree/bindings/interrupt-controller/jcore,aic.txt
Documentation/devicetree/bindings/spi/jcore,spi.txt
Documentation/devicetree/bindings/timer/jcore,pit.txt

Rob
