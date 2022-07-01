Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 754DE563A21
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 21:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbiGATwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 15:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiGATv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 15:51:59 -0400
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA8225585;
        Fri,  1 Jul 2022 12:51:56 -0700 (PDT)
Received: by mail-il1-f181.google.com with SMTP id a7so2049554ilj.2;
        Fri, 01 Jul 2022 12:51:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y2u7piwMP8WRoOkwcLwV3edsFIFKViwRNW8iJEcQlGY=;
        b=IfnzOe0wYxqP5ksYwQjO1vTqfKQysjpQRobGzNjwICz90uzhtr52rKfRRFEPgniek4
         bwuH9y0mMUG6Dzm4mKXyccWsnIiixxY0XrwslMzFcYnUqU3ZXLuCTQsgkzfciHQ88dal
         gWiICqkcXT5XCaacp3sZDX6TxjTu12sH2Ewn5WHmGFyEtzX6ttxineETfynoCGLWFFmC
         4LfJOda7ANaNzdAhRLk/nMyqw2u7KFKldf0OlNii1XhOrPx3l8FuQ50NPCtK4ItcF9eI
         aNt7N+ecLzYTpOTVNWXlRSTBCcRjbj4iZv4nOYwirM6ErrsuYhQU5IyYCk+mU/S9XUzD
         EVYw==
X-Gm-Message-State: AJIora+4+tYwWZ/wgmAr67ml2aoPOAbLSPHSAu6uqQaUTKvB+VMW+I+R
        VZBeiRuESCL5BmxnfmDc4w==
X-Google-Smtp-Source: AGRyM1uCzukptXkjULJiVhiY7VNc7zMOwUSsnOp3OTAKsBWSKYNlI9cw6P3IxIahkJHGCw7J8sib6w==
X-Received: by 2002:a05:6e02:168f:b0:2da:72fc:feec with SMTP id f15-20020a056e02168f00b002da72fcfeecmr9308243ila.185.1656705115458;
        Fri, 01 Jul 2022 12:51:55 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id e2-20020a5d9242000000b006758cc4aa76sm3276380iol.29.2022.07.01.12.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 12:51:55 -0700 (PDT)
Received: (nullmailer pid 1407947 invoked by uid 1000);
        Fri, 01 Jul 2022 19:51:52 -0000
Date:   Fri, 1 Jul 2022 13:51:52 -0600
From:   Rob Herring <robh@kernel.org>
To:     Conor Dooley <conor.dooley@microchip.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-clk@vger.kernel.org, Stephen Boyd <sboyd@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        linux-kernel@vger.kernel.org,
        Daire McNamara <daire.mcnamara@microchip.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-riscv@lists.infradead.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        devicetree@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH v1 01/14] dt-bindings: clk: microchip: mpfs: add reset
 controller support
Message-ID: <20220701195152.GA1407913-robh@kernel.org>
References: <20220630080532.323731-1-conor.dooley@microchip.com>
 <20220630080532.323731-2-conor.dooley@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630080532.323731-2-conor.dooley@microchip.com>
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

On Thu, 30 Jun 2022 09:05:20 +0100, Conor Dooley wrote:
> The "peripheral" devices on PolarFire SoC can be put into reset, so
> update the device tree binding to reflect the presence of a reset
> controller.
> 
> Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
> ---
>  .../bindings/clock/microchip,mpfs.yaml          | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
