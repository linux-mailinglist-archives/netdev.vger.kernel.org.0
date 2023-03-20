Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87EE06C1F51
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 19:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjCTSQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 14:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbjCTSPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 14:15:54 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D27649F3;
        Mon, 20 Mar 2023 11:09:58 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id n2so14211254qtp.0;
        Mon, 20 Mar 2023 11:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679335763;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9Ym0Aa6IJr35fCbX8wJyITkzyONp9K1eXcn9gLrMKEM=;
        b=jV+wT9G9dMq++VXoHOITcaMwSKfT7Ne8l6voVfiCeH20VK0uzRJIf9CA2v8jn1mE42
         9De/qJTXiN3NlwKDdk7NArH7WT5H+4m7s71wZTV+2BygDTiQuwk+mRLMpRhBukxFua9x
         67hE9fL+3OgJ1dTRBMXtTwDXEznGIlnqEuoH6BXNz+DtDWm5LZSaKbCnlxFhePXKvQQw
         biWPqZK1eoCZ6HeXFY1w+DmsNHS4W090fENE/el13ZE/cuRLHNVC7Li/p30/Ai1N8xhv
         3ejM9NTyAoTh9dtKbufIgtWOwd6srKtNAzDZ9KiKE0PTE7Lb1wYokPUbe9HLqHLVnTp7
         mdLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679335763;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9Ym0Aa6IJr35fCbX8wJyITkzyONp9K1eXcn9gLrMKEM=;
        b=NHVzLYtMKdmsPkDgLcR0Hyt1XcwdYrZ7B7LtiPC1O0eiQeXLJE5a8q32RtCpnnmmcY
         YDaKHsVM/VhH+pG+zQiieMGHhVbRjsaKATzEHtRTJ4gKGW06JAGUfSN6rIZLaYqi7tqh
         t+gFFGmvcfDeZ0qH+ezUoIlCOCTBWgzCB5dP27sPitDx4P+NVwho/KiD+X6rUDZbjHQs
         f6RknlOTBlTlNKxTHaUhHQ9+pMx8c8Qs1tiz5Y0XvTMy4uxsPG3ldAP8FmILHFuc+8Pv
         z3T9KNERiVevWE4bZoEtZ5RYteukkWoO03Wg8R5it6IFxHrf3Y6Xz+r+YAa7IrQy+3MI
         hYVQ==
X-Gm-Message-State: AO0yUKV2sbjaC3xcTteESAd6/v2KVSJxbC5aao3XsB06ipmsbiP85cIq
        nHlxVfLjV7/9+hgRoh/YVuY=
X-Google-Smtp-Source: AK7set/rOHA8qVlayMALPx0FGjCcSWh/Kq1WvV8aodxfR3XsSBymHa1dS0evHblRHeVucdEeSCUF5g==
X-Received: by 2002:a05:622a:190e:b0:3d7:1979:829e with SMTP id w14-20020a05622a190e00b003d71979829emr125230qtc.27.1679335763440;
        Mon, 20 Mar 2023 11:09:23 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id l16-20020ac84a90000000b003d4ee7879d0sm2042741qtq.56.2023.03.20.11.09.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 11:09:22 -0700 (PDT)
Message-ID: <82ae9fd5-a4f9-89a6-8040-c64d22a85ebb@gmail.com>
Date:   Mon, 20 Mar 2023 11:08:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] dt-bindings: net: Drop unneeded quotes
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        =?UTF-8?Q?Andreas_F=c3=a4rber?= <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        UNGLinuxDriver@microchip.com, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev, linux-aspeed@lists.ozlabs.org,
        linux-can@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-mediatek@lists.infradead.org
References: <20230317233605.3967621-1-robh@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230317233605.3967621-1-robh@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/17/23 16:36, Rob Herring wrote:
> Cleanup bindings dropping unneeded quotes. Once all these are fixed,
> checking for this can be enabled in yamllint.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>   .../devicetree/bindings/net/actions,owl-emac.yaml  |  2 +-
>   .../bindings/net/allwinner,sun4i-a10-emac.yaml     |  2 +-
>   .../bindings/net/allwinner,sun4i-a10-mdio.yaml     |  2 +-
>   .../devicetree/bindings/net/altr,tse.yaml          |  2 +-
>   .../bindings/net/aspeed,ast2600-mdio.yaml          |  2 +-
>   .../devicetree/bindings/net/brcm,amac.yaml         |  2 +-
>   .../devicetree/bindings/net/brcm,systemport.yaml   |  2 +-

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

