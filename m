Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93D2654BC48
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 22:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345180AbiFNUw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 16:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245178AbiFNUwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 16:52:46 -0400
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB9E1F2F0;
        Tue, 14 Jun 2022 13:52:46 -0700 (PDT)
Received: by mail-io1-f43.google.com with SMTP id i16so10696295ioa.6;
        Tue, 14 Jun 2022 13:52:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=AQU7G9dtg8Y8H+vQgrYNezCoo/xULoFEsuyaQ6U59LU=;
        b=bL7dVC1vvzBFpadcU8JdyjynPGHSgvN4wcw+BpystNkBjUFBYlBP+HaUDtCglYOHKM
         vKlKpQEuRd9iaVlKMVPO29IXqkiG6xzZhF1NxVLOXXlrgUdN3RSDPZyIKoSNos/4DVbP
         CpHrFNZtl+AzlKsIADu5Qxs7sp4scFux2a10TU4EDwDiwSNf9Y0lf1m5tM55suK1t4hd
         QVZPF0L+z9y+mqW6ge4rWlYIQYSRpV3iAbGwZQeRaSprHgntP/XdHkkDzCZ6zuojJAg9
         l+g6NPcNbU2Nd2JFm4XhQTAhb83PwDf6VPAZQI9eFUplw+truG1q5xJP5RU/eaRazV6x
         51Ug==
X-Gm-Message-State: AOAM530JYbjUHk/cg89Mg9/i+b5qpBqMXOokbqVLuIHcvGSiXXvUCzr/
        tNaijBRaMmBiIvk57YUqrQ==
X-Google-Smtp-Source: ABdhPJy4OZTKgkm9bsNozXxDdwuI56FSZM66Se3QH8NuIoteF12/9pfiXl/uOuGuu0rZ7hwu/sJUxA==
X-Received: by 2002:a05:6638:1346:b0:331:b571:9fd6 with SMTP id u6-20020a056638134600b00331b5719fd6mr4027605jad.266.1655239965312;
        Tue, 14 Jun 2022 13:52:45 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.251])
        by smtp.gmail.com with ESMTPSA id p136-20020a6b8d8e000000b00669a3314870sm5691555iod.9.2022.06.14.13.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 13:52:44 -0700 (PDT)
Received: (nullmailer pid 2528143 invoked by uid 1000);
        Tue, 14 Jun 2022 20:52:42 -0000
Date:   Tue, 14 Jun 2022 14:52:42 -0600
From:   Rob Herring <robh@kernel.org>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     Jimmy Lalande <jimmy.lalande@se.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        =?UTF-8?Q?Miqu=C3=A8l_Raynal?= <miquel.raynal@bootlin.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, devicetree@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Herve Codina <herve.codina@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH RESEND net-next v7 11/16] dt-bindings: net: snps,dwmac:
 add "renesas,rzn1" compatible
Message-ID: <20220614205242.GA2527905-robh@kernel.org>
References: <20220610103712.550644-1-clement.leger@bootlin.com>
 <20220610103712.550644-12-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220610103712.550644-12-clement.leger@bootlin.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jun 2022 12:37:07 +0200, Clément Léger wrote:
> Add "renesas,rzn1-gmac" and "renesas,r9a06g032-gmac" compatible strings.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
>  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
