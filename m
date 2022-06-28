Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4BC55E6AD
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347843AbiF1Pbw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 28 Jun 2022 11:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347722AbiF1Pbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 11:31:48 -0400
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB78237E3;
        Tue, 28 Jun 2022 08:31:47 -0700 (PDT)
Received: by mail-qv1-f53.google.com with SMTP id 59so20569770qvb.3;
        Tue, 28 Jun 2022 08:31:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=USPqLsPLtBkWtBd33iOftOG5ByagAW/lzRHAmHmeMrI=;
        b=QBGYznAcmWHhSoYA7oQca1cgBf+cpKsnxYeA4CkOJefcXKtRKNb0FjIyAID3NFtcnZ
         hQoYlqfvs+w12gtukgOHu28doKfP3mH4hxaA2Jl9fHcmc/57y6+NSogjMjzcdSLCRs8h
         nHQ6EbL4azXgWCTv+586+loihwPT8vqKCwBC1jAv/XZAULHN4wGytgabvX8x5Ty5ms8t
         8/nahl72WwPz3bhTC+e/h0UGLymNb/qn+Zb9XwyCo6uXb7oC8mUYObmRRQ2tj4t4meb3
         xjhZULTMJxfKRFreQQvf0a/w3HU7s1TDg71p4J1+aJMZnKvKj4YKsANbQrrYHpu19CWF
         9gmw==
X-Gm-Message-State: AJIora8H2+bOzUsCFOY4Cv6TbON412RKD3ycai5DBFxLprc4LVu7bzfK
        39nUEZly2H8zJq5Y+koCvOQIBt7xEDrOMA==
X-Google-Smtp-Source: AGRyM1ujxH5w7gF/IrCDQNigAvtzC2SKm21x2daTEHvW2oAF43DBu6myXGEHgi4BP8tt2V7LXYiCJQ==
X-Received: by 2002:a05:622a:58c:b0:319:9323:4ac7 with SMTP id c12-20020a05622a058c00b0031993234ac7mr9784785qtb.240.1656430306587;
        Tue, 28 Jun 2022 08:31:46 -0700 (PDT)
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com. [209.85.128.179])
        by smtp.gmail.com with ESMTPSA id ea2-20020a05620a488200b006a79d8c8198sm872494qkb.135.2022.06.28.08.31.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 08:31:46 -0700 (PDT)
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-3176d94c236so121230557b3.3;
        Tue, 28 Jun 2022 08:31:45 -0700 (PDT)
X-Received: by 2002:a81:74c5:0:b0:31b:ca4b:4bc4 with SMTP id
 p188-20020a8174c5000000b0031bca4b4bc4mr11868921ywc.358.1656430305609; Tue, 28
 Jun 2022 08:31:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220624144001.95518-1-clement.leger@bootlin.com> <20220624144001.95518-15-clement.leger@bootlin.com>
In-Reply-To: <20220624144001.95518-15-clement.leger@bootlin.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 28 Jun 2022 17:31:33 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUfu8BEKMO956n0nP7mHL7xFNFEf8UiBYv0turxktOhgQ@mail.gmail.com>
Message-ID: <CAMuHMdUfu8BEKMO956n0nP7mHL7xFNFEf8UiBYv0turxktOhgQ@mail.gmail.com>
Subject: Re: [PATCH net-next v9 14/16] ARM: dts: r9a06g032: describe switch
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
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
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
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 24, 2022 at 4:42 PM Clément Léger <clement.leger@bootlin.com> wrote:
> Add description of the switch that is present on the RZ/N1 SoC. This
> description includes ethernet-ports description for all the ports that
> are present on the switch along with their connection to the MII
> converter ports and to the GMAC for the CPU port.
>
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
i.e. will queue in renesas-devel for v5.20.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
