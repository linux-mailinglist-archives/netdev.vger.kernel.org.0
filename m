Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2080D67BA83
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 20:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235422AbjAYTQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 14:16:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjAYTQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 14:16:03 -0500
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629C2C157;
        Wed, 25 Jan 2023 11:16:02 -0800 (PST)
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-142b72a728fso22551159fac.9;
        Wed, 25 Jan 2023 11:16:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:references:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ET5JmTgXm+LbQNG9OMNR0lWgn8/fOI2cY5p7uWgl0cw=;
        b=tohIGw/UD7003TfWJDS7NFwTVfV4eiDQ/TWDqzVN+pWrC1SA/XmFgf08ZG2Gf10wWF
         mOLkLoezWuYTG/vfD6gCHsJ+Afi+I9cDY7frW8gWKS4V5oxUEZzDg5UAURVC94AAtp57
         H124L1ozYjDp36kgnxMkaLLEINUcAm99VAD8CD0xS0+S3ATavz2+JZBudQO9N2UvRJnG
         E4wT1YLwnxmHJrhzsnJzQWNO0unuMejeTR0IXmkxpGml0v0bV7WOnFihxdNf9qkUI+3m
         RDbmTP2zDXF9MuOv1KzKTw5luakPJdv+6BVdI0AQ6Sw+sbWPGquaa6FDp7OxpbQwm1BH
         LNMw==
X-Gm-Message-State: AFqh2ko4eHQnJSyp9Zb7rw3p2z7cfofWVw5QBlTnH0vwQM1miMe3vRhI
        UZ/djK2ecXpSqRuWxNiZvA==
X-Google-Smtp-Source: AMrXdXvgbQawq2+Dx+lUA/Un4UhhydyHNV1fwE7OY++wHZ5Jfdc8HZRVnRUHFbUZ/xm3meqgLnZyzQ==
X-Received: by 2002:a05:6870:4985:b0:152:d0dc:2bba with SMTP id ho5-20020a056870498500b00152d0dc2bbamr17286732oab.15.1674674161655;
        Wed, 25 Jan 2023 11:16:01 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id k43-20020a4a94ae000000b004f1f6b25091sm2193375ooi.41.2023.01.25.11.16.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 11:16:01 -0800 (PST)
Received: (nullmailer pid 2709254 invoked by uid 1000);
        Wed, 25 Jan 2023 19:16:00 -0000
Date:   Wed, 25 Jan 2023 13:16:00 -0600
From:   Rob Herring <robh@kernel.org>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     linux-can@vger.kernel.org, Ulrich Hecht <uli+renesas@fpond.eu>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-renesas-soc@vger.kernel.org,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: [PATCH 03/12] dt-bindings: can: renesas,rcar-canfd: Add
 transceiver support
Message-ID: <167467416007.2709195.16290383367221054920.robh@kernel.org>
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


On Mon, 23 Jan 2023 19:56:05 +0100, Geert Uytterhoeven wrote:
> Add support for describing CAN transceivers as PHYs.
> 
> While simple CAN transceivers can do without, this is needed for CAN
> transceivers like NXP TJR1443 that need a configuration step (like
> pulling standby or enable lines), and/or impose a bitrate limit.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  .../devicetree/bindings/net/can/renesas,rcar-canfd.yaml       | 4 ++++
>  1 file changed, 4 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
