Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68EAB5E5CBC
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 09:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbiIVH4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 03:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiIVH4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 03:56:20 -0400
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0E4357CE;
        Thu, 22 Sep 2022 00:56:19 -0700 (PDT)
Received: by mail-qt1-f176.google.com with SMTP id g23so5776217qtu.2;
        Thu, 22 Sep 2022 00:56:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=V7WeZATWUx2tE4MxoHQwI+QugNIBy3AvjYpUsXK7axg=;
        b=vJ8Bx0nkPSoRJvAn3OcFQqJN7r4HGCaI4lQt3BJW9i5HotJZvb98P8K/mRiDZwPgFt
         UB/6mjok8FBU2co2x5SO3iw9dHKfjkt8rMgQrnobtuc9zzj0FFxUBWn4PudFwydSgNP7
         mk6f+c01gib1FIK/mq8va05ZRa/Yy2b2RwW6dhH592DrUcjd9ePFse4tcg1AGgcNBs9U
         BXOqrz/nMr9+P02oSKJ8CI2YLSBAotQskCmc+8Jf9/HxK5U4rz2dWQ8qc8SPDXWJKcv6
         l5g9TDaYj+BJUMlVjhgnspenmCLNyW2r/yc05KIE3+sdajWr3gmC8cCyptHk/iIUe46V
         +oYA==
X-Gm-Message-State: ACrzQf3atRr9RpEXXD1VqtHjmRsLttNJHfKoEaP01xmZJ+cbPPvuTqKx
        FQurPeLMGWWnuD4yoRssjiSZAYLmcIm1WFU5
X-Google-Smtp-Source: AMsMyM63XOlUqkqGwu6SSFkXxjo8O7lKmQ5/6Qz1+gFV1yzYm6wbiPYTBEHfyZqMLPUL4yROMWzSGA==
X-Received: by 2002:ac8:7d52:0:b0:343:5e7a:ee32 with SMTP id h18-20020ac87d52000000b003435e7aee32mr1756447qtb.247.1663833378383;
        Thu, 22 Sep 2022 00:56:18 -0700 (PDT)
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com. [209.85.219.169])
        by smtp.gmail.com with ESMTPSA id y4-20020ac81284000000b00342f8143599sm3013883qti.13.2022.09.22.00.56.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Sep 2022 00:56:18 -0700 (PDT)
Received: by mail-yb1-f169.google.com with SMTP id j7so1580041ybb.8;
        Thu, 22 Sep 2022 00:56:17 -0700 (PDT)
X-Received: by 2002:a25:3851:0:b0:6ad:9cba:9708 with SMTP id
 f78-20020a253851000000b006ad9cba9708mr2393590yba.36.1663833377467; Thu, 22
 Sep 2022 00:56:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220921084745.3355107-1-yoshihiro.shimoda.uh@renesas.com>
 <20220921084745.3355107-3-yoshihiro.shimoda.uh@renesas.com>
 <9b29ee3f-ed48-9d95-a262-7d9e23a20528@linaro.org> <TYBPR01MB534100D42EC0202CA8BEF04CD84E9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
In-Reply-To: <TYBPR01MB534100D42EC0202CA8BEF04CD84E9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 22 Sep 2022 09:56:06 +0200
X-Gmail-Original-Message-ID: <CAMuHMdV=HECSXtLi6BFRVFiYZvjJ_t5RDUY3DckbSB4ozEtOgg@mail.gmail.com>
Message-ID: <CAMuHMdV=HECSXtLi6BFRVFiYZvjJ_t5RDUY3DckbSB4ozEtOgg@mail.gmail.com>
Subject: Re: [PATCH v2 2/8] dt-bindings: phy: renesas: Document Renesas
 Ethernet SERDES
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "kishon@ti.com" <kishon@ti.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Shimoda-san,

On Thu, Sep 22, 2022 at 9:39 AM Yoshihiro Shimoda
<yoshihiro.shimoda.uh@renesas.com> wrote:
> > From: Krzysztof Kozlowski, Sent: Thursday, September 22, 2022 4:29 PM
> > On 21/09/2022 10:47, Yoshihiro Shimoda wrote:
> > > Document Renesas Etherent SERDES for R-Car S4-8 (r8a779f0).
> > >
> > > Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > > ---
> > >  .../bindings/phy/renesas,ether-serdes.yaml    | 54 +++++++++++++++++++
> > >  1 file changed, 54 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/phy/renesas,ether-serdes.yaml
> > >
> > > diff --git a/Documentation/devicetree/bindings/phy/renesas,ether-serdes.yaml
> > b/Documentation/devicetree/bindings/phy/renesas,ether-serdes.yaml
> > > new file mode 100644
> > > index 000000000000..04d650244a6a
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/phy/renesas,ether-serdes.yaml
> >
> > Filename based on compatible, so renesas,r8a779f0-ether-serdes.yaml
>
> I got it. I'll rename the file.

Is this serdes present on other R-Car Gen4 SoCs, or is it (so far) only
found on R-Car S4-8?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
