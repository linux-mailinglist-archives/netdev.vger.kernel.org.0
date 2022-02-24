Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE4D84C3348
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 18:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbiBXRNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 12:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiBXRNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 12:13:52 -0500
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166661AEEFF;
        Thu, 24 Feb 2022 09:13:23 -0800 (PST)
Received: by mail-ot1-f46.google.com with SMTP id j8-20020a056830014800b005ad00ef6d5dso1774152otp.0;
        Thu, 24 Feb 2022 09:13:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+ZX27TrioUK0w9RGeSuhrt2+KeVxOCfnnAKkSXg0Y28=;
        b=fas3EfMMo9gKu51kaEbeb4SyG6jOL4W2Qqg39ispmcu2rdfUUSdqXTMwt4pPXahJwf
         wvCgucb+El6sghc8QPCF0QigRlBAdkYmiKLDMYnYe6r/zENy3sVYIIMHaeEVCo5FsKKX
         Kbct7ABSlXAoD20RTcbM9v8c/Ragv5qMkc0b23cuJagk6CadASCq5MPWu1WBIheEzJEu
         3UtAzKUqKX8Hweg+Pdn7/qm7mjw4n/fRyA0tP0d7XMgB0a3lyUFFobwW+hcicihMzXba
         6OJeTXRRyRw57ZEHcsU9Pu5MxWtnW95AyfkhbgbSuGzDaIzHc/twOAbSA2Kq00wUdTle
         nb0Q==
X-Gm-Message-State: AOAM532k+cvIC2psPh+6NwqcT4UYFenHXHvoGB8RVbxxoDCDjCXYF+Jb
        mkN4/wjt5+oWpx5PlEGxbA==
X-Google-Smtp-Source: ABdhPJx9dXKdja8XTbBg2/bLvMZID1GMmU5Hnt+lvFxh5MqDE25B95ZmXREQdNQ0X9yYv6+ivnGGwA==
X-Received: by 2002:a05:6830:1c62:b0:5ad:364d:5e9c with SMTP id s2-20020a0568301c6200b005ad364d5e9cmr1296986otg.164.1645722802376;
        Thu, 24 Feb 2022 09:13:22 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id m18sm1383094otq.31.2022.02.24.09.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 09:13:21 -0800 (PST)
Received: (nullmailer pid 3257244 invoked by uid 1000);
        Thu, 24 Feb 2022 17:13:19 -0000
Date:   Thu, 24 Feb 2022 11:13:19 -0600
From:   Rob Herring <robh@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Ray Jui <rjui@broadcom.com>,
        linux-rpi-kernel@lists.infradead.org,
        Scott Branden <sbranden@broadcom.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        linux-tegra@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        linux-samsung-soc@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v5 1/9] dt-bindings: net: add schema for ASIX USB
 Ethernet controllers
Message-ID: <Yhe8r5dGmSvwJeY6@robh.at.kernel.org>
References: <20220216074927.3619425-1-o.rempel@pengutronix.de>
 <20220216074927.3619425-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216074927.3619425-2-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Feb 2022 08:49:19 +0100, Oleksij Rempel wrote:
> Create schema for ASIX USB Ethernet controllers and import some of
> currently supported USB IDs form drivers/net/usb/asix_devices.c
> 
> These devices are already used in some of DTs. So, this schema makes it official.
> NOTE: there was no previously documented txt based DT binding for this
> controllers.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  .../devicetree/bindings/net/asix,ax88178.yaml | 68 +++++++++++++++++++
>  1 file changed, 68 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/asix,ax88178.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
