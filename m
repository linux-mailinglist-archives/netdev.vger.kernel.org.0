Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A81D567BA7B
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 20:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235789AbjAYTPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 14:15:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235810AbjAYTP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 14:15:28 -0500
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB6F1F4BC;
        Wed, 25 Jan 2023 11:15:26 -0800 (PST)
Received: by mail-oo1-f42.google.com with SMTP id j10-20020a4aa64a000000b004f9b746ee29so3328971oom.0;
        Wed, 25 Jan 2023 11:15:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:references:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JS2zluSZvMrS699obCEEMbHDdC0QTYiPfxvkEpY7+f8=;
        b=O/JWpTlQemxGcqi28h6XrIoZ+j/exC0w5mgtrj6TUHYwsCG6l0RiuDLWxLWNxG74ha
         g1JkkhmyYnnihjPgUareTCjEbBtGLylyFe3PILNgEft7lSfzmeadqivWqFO4NVCNT+iJ
         iiHYc2r65fqI/puFLD2ZZ/1VfRHXUDxJ91HA6sg27A5EgwvY7Tq9WKPg7FI9EpL8vRb/
         uRJjExLDy1QX5nv+pf5pwTM5idd+l/AnhoilMF1hmczPXVvCg/rUpSYbTQX/IWNGvU+6
         AzmCzE6vR8bsREIu+BV4SgXDrisA2klSOH9pMiFimHw8s11Zx0cfNL1G9ccdjHu3Aod+
         Im4w==
X-Gm-Message-State: AFqh2kon9+VeKgUpCN1QYgcuCuxSP2XNqJh340+sa/5xfE9G4A6PTUlK
        AXTp9PUPBAeIouIKJfJIcUjsnduigg==
X-Google-Smtp-Source: AMrXdXsOomTAS1Yn8j8yuDVo5JzXV3IshgcY6VqTZMElIa5XqthOzcn7ww/w1zUsIUmrA4vdHW64cg==
X-Received: by 2002:a4a:a8c8:0:b0:4f2:ba0:85f1 with SMTP id r8-20020a4aa8c8000000b004f20ba085f1mr14472188oom.5.1674674125011;
        Wed, 25 Jan 2023 11:15:25 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id q187-20020a4a33c4000000b00511e01623bbsm730970ooq.7.2023.01.25.11.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 11:15:24 -0800 (PST)
Received: (nullmailer pid 2708389 invoked by uid 1000);
        Wed, 25 Jan 2023 19:15:23 -0000
Date:   Wed, 25 Jan 2023 13:15:23 -0600
From:   Rob Herring <robh@kernel.org>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Ulrich Hecht <uli+renesas@fpond.eu>, devicetree@vger.kernel.org,
        linux-can@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Subject: Re: [PATCH 01/12] dt-bindings: can: renesas,rcar-canfd: R-Car V3U is
 R-Car Gen4
Message-ID: <167467412337.2708336.7489280849623114342.robh@kernel.org>
References: <cover.1674499048.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon, 23 Jan 2023 19:56:03 +0100, Geert Uytterhoeven wrote:
> Despite the name, R-Car V3U is the first member of the R-Car Gen4
> family.  Hence generalize this by introducing a family-specific
> compatible value for R-Car Gen4.
> 
> While at it, replace "both channels" by "all channels", as the numbers
> of channels may differ from two.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  .../bindings/net/can/renesas,rcar-canfd.yaml          | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
