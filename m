Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27F234C336D
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 18:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbiBXRUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 12:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiBXRUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 12:20:13 -0500
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26EA529EBA2;
        Thu, 24 Feb 2022 09:19:43 -0800 (PST)
Received: by mail-oi1-f182.google.com with SMTP id y7so3604411oih.5;
        Thu, 24 Feb 2022 09:19:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GIkfwABiL9u4jgKQ7QzwnEVlsUine0tssVICa4obUes=;
        b=g/jJSG3508N6n1hQTkFvSgVPRlKQ5eKn0US59DGY9qROOFQJq8gHLKCQq/GtYHDS6V
         WnGZGGpon7QoavlAVgZuxfLyQXXx0+nP2fRyBHKaeQ9xUTwUrF5rKGx6G7oTmEo9Rse0
         WY3AHXSP/W4y19FFeB1gI7flw9JPi9FkguuRNuOExj2wCv0FAZH0cKeqUIhej5lg7Z8D
         HZZJEV4OC0LLI4+SMTCEhItqUyAXuP0J0iYyRsqkyrIz4bEKiN+sfsL/fOZaaUtK5qsl
         K2GCcNg8eWSAhk05Z4PtFI1egMrGQgJgqYuISqHF7iSo3jOd/zUsKGxkFY2x1QwyReCj
         XK3A==
X-Gm-Message-State: AOAM531rXyQBAJlr+GBID4HzXUNfiTONuanAC809YMz5wEzlvcapt7X3
        q7d75aOvsxjL/KlLSO1Pig==
X-Google-Smtp-Source: ABdhPJwW9NXc4ZUuWoldsXFpMnU1Bree9YmCN9tbO3wUbV9Cdsfwk+AcO5gUPlMiqfAMwr1jytWDLw==
X-Received: by 2002:a05:6870:a40b:b0:d3:4785:c580 with SMTP id m11-20020a056870a40b00b000d34785c580mr6993835oal.221.1645723181847;
        Thu, 24 Feb 2022 09:19:41 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id t5sm1396432otp.67.2022.02.24.09.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 09:19:41 -0800 (PST)
Received: (nullmailer pid 3265197 invoked by uid 1000);
        Thu, 24 Feb 2022 17:19:39 -0000
Date:   Thu, 24 Feb 2022 11:19:39 -0600
From:   Rob Herring <robh@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Ray Jui <rjui@broadcom.com>, linux-kernel@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        "David S. Miller" <davem@davemloft.net>,
        linux-rpi-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Scott Branden <sbranden@broadcom.com>,
        Rob Herring <robh+dt@kernel.org>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        linux-tegra@vger.kernel.org, devicetree@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        bcm-kernel-feedback-list@broadcom.com, linux-usb@vger.kernel.org
Subject: Re: [PATCH v5 3/9] dt-bindings: usb: ci-hdrc-usb2: fix node node for
 ethernet controller
Message-ID: <Yhe+K4rmcBtkyM6C@robh.at.kernel.org>
References: <20220216074927.3619425-1-o.rempel@pengutronix.de>
 <20220216074927.3619425-4-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216074927.3619425-4-o.rempel@pengutronix.de>
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

On Wed, 16 Feb 2022 08:49:21 +0100, Oleksij Rempel wrote:
> This documentation provides wrong node name for the Ethernet controller.
> It should be "ethernet" instead of "smsc" as required by Ethernet
> controller devicetree schema:
>  Documentation/devicetree/bindings/net/ethernet-controller.yaml
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
