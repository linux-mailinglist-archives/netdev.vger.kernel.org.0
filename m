Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D86501A76
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 19:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234563AbiDNRxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 13:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343931AbiDNRxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 13:53:13 -0400
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76DA8EA754;
        Thu, 14 Apr 2022 10:50:48 -0700 (PDT)
Received: by mail-oi1-f177.google.com with SMTP id b188so6155252oia.13;
        Thu, 14 Apr 2022 10:50:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Gp1UQaeAUFHUmZt7KJQtTaDbqEgS8GIsE7NBeOPlykc=;
        b=yWu+lO1f+sxrnN2TrMfqaD/MIfFG3ODL9jNKiDXO9YdmM7Ej0Tjbd9JZWRwa18JYjv
         VuPAAEPCaRuk0RdtfsiXxyKSMkcSPwTZd2lWi/mg5BSWbz2xDwsmieACzQnZpWeAZbV4
         ChNghX3YnFV9fN++MyXYJk0qmiH723po9pt7d5Tctbt7N7w9HYb2Ay4yIvfZwq6fYpa0
         yh0Apfxsm2jelt+Ap8jF9onJ+9YJPNfCNsVtDRfMHYJWYop18zVn8H/W1MYQfNPp5GQS
         X0ayG2bd/UytLH0YUodI4o0K2UrQbSN7nDTqF4/96lWGhOV/LlB7g4tKH6kSujo2j3Un
         dcxg==
X-Gm-Message-State: AOAM531TKuOI3BYJXru3Mz2q9xYur0v5ObLLQfXY0tHdrCEtIIvacL1f
        WYdHDy2RN1pcPXWl+XAbBA==
X-Google-Smtp-Source: ABdhPJwmLAk/ZemFazWzMfXV6Baqk65MFZCVYcK2ITCgH70geCs74ZOtJeb1URftFeedrkn/I6NRow==
X-Received: by 2002:a05:6808:124f:b0:321:855d:5b19 with SMTP id o15-20020a056808124f00b00321855d5b19mr1870495oiv.30.1649958647785;
        Thu, 14 Apr 2022 10:50:47 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id o18-20020a9d7652000000b005cbf6f5d7c5sm267475otl.21.2022.04.14.10.50.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 10:50:47 -0700 (PDT)
Received: (nullmailer pid 2303359 invoked by uid 1000);
        Thu, 14 Apr 2022 17:50:46 -0000
Date:   Thu, 14 Apr 2022 12:50:46 -0500
From:   Rob Herring <robh@kernel.org>
To:     Abel Vesa <abel.vesa@nxp.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-mmc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawnguo@kernel.org>
Subject: Re: [PATCH v6 12/13] dt-bindings: usb: ci-hdrc-usb2: Add i.MX8DXL
 compatible string
Message-ID: <Ylhe9qXRhghSxUQp@robh.at.kernel.org>
References: <20220413103356.3433637-1-abel.vesa@nxp.com>
 <20220413103356.3433637-13-abel.vesa@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220413103356.3433637-13-abel.vesa@nxp.com>
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

On Wed, 13 Apr 2022 13:33:55 +0300, Abel Vesa wrote:
> Add i.MX8DXL compatible string to ci-hdrc-usb2 bindings
> documentation.
> 
> Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
> ---
>  Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
