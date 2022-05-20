Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF66A52E6DC
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 10:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346789AbiETIBu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 20 May 2022 04:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346790AbiETIBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 04:01:48 -0400
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972DC37A12;
        Fri, 20 May 2022 01:01:47 -0700 (PDT)
Received: by mail-qt1-f178.google.com with SMTP id b9so224922qtx.11;
        Fri, 20 May 2022 01:01:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=H1iVOpRla5rs6rYvY27pFyr760HB96cTo8Ladb3Lo6o=;
        b=lBHH6y7xt5cg2Cl1+lNnZHtczZi0hkIEMCWn8a8E/7YotQCqL++AP8Y8px5K654cTK
         QDYIaD9ISI6QOLNcRDFSBVdG1QDF1QeshhWLaV3kupIxKvzRMDBf/sZNM4ctO1w1T5Xc
         5x9PYZfOhvDsaN67cMUsXfcFlne3Q6JOFXOxMvFb1/oXAbu4MBnzUQFbLUnrPlgvj3pr
         rAWmYZBu5o/Tx9WBBcYY7uukrph7O9PIWzO1YAKbnwrFbC2cRzltFiLCc6wgrFSx/cs9
         cMi7JaWvMUqgPaipMrcouwcwwFSz9XnVfVlpIrwoHz26C1FUlae8AFxJ3XvhrnkNUhrr
         BoWQ==
X-Gm-Message-State: AOAM533R3xdVpGNwZdVRc58DBxRIPrHhkA0NAQ1RmdbQqn7WG/VD7Ri2
        CDPCjMqfTal7FujeemX7FEQdJJSaFMhqzw==
X-Google-Smtp-Source: ABdhPJy9rlq6FYckE6dvWhZXO5Xifn+8i7hpHnmg+AMuwMrCVUiVYubqnyrVW+beXfgSifPp3eGymg==
X-Received: by 2002:ac8:5c56:0:b0:2f3:bdd1:4f1e with SMTP id j22-20020ac85c56000000b002f3bdd14f1emr6801141qtj.545.1653033706208;
        Fri, 20 May 2022 01:01:46 -0700 (PDT)
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com. [209.85.128.176])
        by smtp.gmail.com with ESMTPSA id f9-20020a05622a104900b002f39b99f69fsm3200042qte.57.2022.05.20.01.01.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 01:01:45 -0700 (PDT)
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-2ec42eae76bso79086497b3.10;
        Fri, 20 May 2022 01:01:45 -0700 (PDT)
X-Received: by 2002:a81:9b0c:0:b0:2f4:c522:7d3c with SMTP id
 s12-20020a819b0c000000b002f4c5227d3cmr8843852ywg.316.1653033705399; Fri, 20
 May 2022 01:01:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220519153107.696864-1-clement.leger@bootlin.com>
 <20220519153107.696864-7-clement.leger@bootlin.com> <CAMuHMdXRCggkTSxfnSHvz3N2Oekuw7y5Sy2AKkqZpZzK_Eg_ng@mail.gmail.com>
 <20220520095730.512bbb8d@fixe.home>
In-Reply-To: <20220520095730.512bbb8d@fixe.home>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 20 May 2022 10:01:32 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWOMYE7b=auNeVAMDgArso+8vUzkxAwnFxFYtKPxOnjxw@mail.gmail.com>
Message-ID: <CAMuHMdWOMYE7b=auNeVAMDgArso+8vUzkxAwnFxFYtKPxOnjxw@mail.gmail.com>
Subject: Re: [PATCH net-next v5 06/13] dt-bindings: net: dsa: add bindings for
 Renesas RZ/N1 Advanced 5 port switch
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?Q?Miqu=C3=A8l_Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Clément,

On Fri, May 20, 2022 at 9:58 AM Clément Léger <clement.leger@bootlin.com> wrote:
> Le Fri, 20 May 2022 09:13:23 +0200,
> Geert Uytterhoeven <geert@linux-m68k.org> a écrit :
> > On Thu, May 19, 2022 at 5:32 PM Clément Léger <clement.leger@bootlin.com> wrote:
> > > Add bindings for Renesas RZ/N1 Advanced 5 port switch. This switch is
> > > present on Renesas RZ/N1 SoC and was probably provided by MoreThanIP.
> > > This company does not exists anymore and has been bought by Synopsys.
> > > Since this IP can't be find anymore in the Synospsy portfolio, lets use
> > > Renesas as the vendor compatible for this IP.
> > >
> > > Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml

> > Missing "power-domains" property.
>
> I do not use pm_runtime* in the switch driver. I should probably do that
> right ?

For now you don't have to.  But I think it is a good idea, and it helps if the
IP block is ever reused in an SoC with real power areas.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
