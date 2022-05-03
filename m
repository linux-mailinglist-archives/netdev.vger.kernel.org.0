Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70C1B517EDA
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 09:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbiECH3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 03:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232467AbiECH3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 03:29:32 -0400
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7C23632E;
        Tue,  3 May 2022 00:26:00 -0700 (PDT)
Received: by mail-qv1-f52.google.com with SMTP id kk28so3785946qvb.3;
        Tue, 03 May 2022 00:26:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YD6pDX7MFiRlZPMrxCGiAGzBVQ9fcEPaJDRhBoAH8Fc=;
        b=pEkuhgof2k32QKTeaSAifwjGDQ3vYUtsjULG5eJ0nkg/dUGyOR/GObS3sRuHANd8kg
         mtFHqiSdYnrthcwIWgFtjU3kfRrPEpQri2wPaZtjdEpEvNd0O78nHE/tn15lvUSzJJrg
         0xdR9CaeosEmgfjH3dFeD/QVvOdkHIk91vrYwQMWgbVdFE3tugQNTzNoK7BXF7TFG7mx
         u/NDRO0l3fV7XWM3pb1mEdaCpjaUUbBcMlDf7SyP18grWkmHT54RV7YlmnAk5Mzo7x/6
         3NqIWsYSk7jOe+thy1stgv/3oo28tnxEHxaWPL2xtw/qiifB3ZYRTENHPAhJK0KSyLaM
         kj+A==
X-Gm-Message-State: AOAM533F8o7CR0pxJzkSdZhBUwPMg2ZBk9/k6U4esY28obvM2KtCxu51
        YSazU4I8E4Sw/T9etOSYiEzMXb3DkUBELg==
X-Google-Smtp-Source: ABdhPJzHz/1e6pmqFoxFOzhmK5czzvn6gCa51ixXmfxBjpqonZ17LbaghbbVcbe0exXafb+pDtBQNw==
X-Received: by 2002:a05:6214:f6f:b0:45a:8bcf:8274 with SMTP id iy15-20020a0562140f6f00b0045a8bcf8274mr6915729qvb.14.1651562759726;
        Tue, 03 May 2022 00:25:59 -0700 (PDT)
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com. [209.85.219.179])
        by smtp.gmail.com with ESMTPSA id v185-20020a372fc2000000b0069fc13ce252sm5663840qkh.131.2022.05.03.00.25.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 00:25:58 -0700 (PDT)
Received: by mail-yb1-f179.google.com with SMTP id w187so29739158ybe.2;
        Tue, 03 May 2022 00:25:57 -0700 (PDT)
X-Received: by 2002:a05:6902:352:b0:63e:94c:883c with SMTP id
 e18-20020a056902035200b0063e094c883cmr12355814ybs.365.1651562757393; Tue, 03
 May 2022 00:25:57 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1651512451.git.geert+renesas@glider.be> <20220502182635.2ntwjifykmyzbjgx@pengutronix.de>
In-Reply-To: <20220502182635.2ntwjifykmyzbjgx@pengutronix.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 3 May 2022 09:25:45 +0200
X-Gmail-Original-Message-ID: <CAMuHMdU2RfBUO7SVJ8N2dUVqzvgptLX61UJY5Wdiyobj=rQgJw@mail.gmail.com>
Message-ID: <CAMuHMdU2RfBUO7SVJ8N2dUVqzvgptLX61UJY5Wdiyobj=rQgJw@mail.gmail.com>
Subject: Re: [PATCH 0/2] dt-bindings: can: renesas,rcar-canfd: Make
 interrupt-names required
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On Mon, May 2, 2022 at 8:27 PM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 02.05.2022 19:33:51, Geert Uytterhoeven wrote:
> > The Renesas R-Car CAN FD Controller always uses two or more interrupts.
> > Hence it makes sense to make the interrupt-names property a required
> > property, to make it easier to identify the individual interrupts, and
> > validate the mapping.
> >
> >   - The first patch updates the various R-Car Gen3 and RZ/G2 DTS files
> >     to add interrupt-names properties, and is intended for the
> >     renesas-devel tree,
> >   - The second patch updates the CAN-FD DT bindings to mark the
> >     interrupt-names property required, and is intended for the DT or net
> >     tree.
> >
> > Thanks!
>
> LGTM. Who takes this series?

I'll take the first patch.

The second patch is up to you and the DT maintainers.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
