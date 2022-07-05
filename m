Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64792567851
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 22:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbiGEU0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 16:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbiGEU0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 16:26:19 -0400
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB8219C1A;
        Tue,  5 Jul 2022 13:26:18 -0700 (PDT)
Received: by mail-io1-f44.google.com with SMTP id z191so12231771iof.6;
        Tue, 05 Jul 2022 13:26:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U4ORPXljghFVXRLJ4HcI8OKhjci+DLidUJVIyQ8TPR8=;
        b=GNUWNyTGONtUFZCwlaN+B13LgteM/2ctKqMfCHDCOBRMlMcsbJURZX+lCzEJHWifZd
         IXYVzuQyy5lYW5MIHIL5Y2km4LPEMiWrGhCzORWtUKkJkG1iO80y9Y6PlLWvuPByLbkj
         F2eHcR3u+1tEJYLoGhSn2Xr9Quc4tILh4eyNRjNNj3Q+ZhbEUuDOLuT+lhc+19B7c77B
         8cftwiaEqpThQqO7MI4SFY+7oceBy2jcQdWMEaty6Mf+TesZyVBCeNfqvlZ29rVW+/12
         Vn0u9KZowuhDdxgpkx12AbjTjhJ2W4VeonV6UErtyCL2cyqTnqiWcPGYGa/V/iwEMicH
         RFyQ==
X-Gm-Message-State: AJIora955oKq5nGAkQWDMQO/VJ6EWWRbHQwTfCvhOFISEbd8LGhHzSiy
        PEkHxr4R6MboA8guL1/xWg==
X-Google-Smtp-Source: AGRyM1tF5HJFkp560JBrGfhqcZzrtiL2A8SPtpsQcsMwQOokpnrLPZpx1wJn1hY9obUjQbYLVe769Q==
X-Received: by 2002:a05:6638:25c9:b0:33e:f47f:f248 with SMTP id u9-20020a05663825c900b0033ef47ff248mr2389894jat.51.1657052777505;
        Tue, 05 Jul 2022 13:26:17 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id i6-20020a056e020d8600b002d90ac862b6sm13543470ilj.55.2022.07.05.13.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 13:26:17 -0700 (PDT)
Received: (nullmailer pid 2566768 invoked by uid 1000);
        Tue, 05 Jul 2022 20:26:14 -0000
Date:   Tue, 5 Jul 2022 14:26:14 -0600
From:   Rob Herring <robh@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Rob Herring <robh+dt@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Jakub Kicinski <kuba@kernel.org>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        linux-gpio@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, katie.morris@in-advantage.com,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        UNGLinuxDriver@microchip.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v12 net-next 8/9] dt-bindings: mfd: ocelot: add bindings
 for VSC7512
Message-ID: <20220705202614.GA2566714-robh@kernel.org>
References: <20220701192609.3970317-1-colin.foster@in-advantage.com>
 <20220701192609.3970317-9-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220701192609.3970317-9-colin.foster@in-advantage.com>
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

On Fri, 01 Jul 2022 12:26:08 -0700, Colin Foster wrote:
> Add devicetree bindings for SPI-controlled Ocelot chips, specifically the
> VSC7512.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
>  .../devicetree/bindings/mfd/mscc,ocelot.yaml  | 160 ++++++++++++++++++
>  MAINTAINERS                                   |   1 +
>  2 files changed, 161 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
