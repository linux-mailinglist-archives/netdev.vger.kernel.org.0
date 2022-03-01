Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA364C8F28
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 16:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235584AbiCAPeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 10:34:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbiCAPen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 10:34:43 -0500
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583902B278;
        Tue,  1 Mar 2022 07:34:02 -0800 (PST)
Received: by mail-oi1-f174.google.com with SMTP id s5so16509747oic.10;
        Tue, 01 Mar 2022 07:34:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DZMJhlazRxfiZZMLqWDvXZ/jU6J34RFBtjvG+CX9Qvo=;
        b=m6PEbxOLQ93mW8Vz5txTJrg/wxUo0R/c+FsqdfRHmqgKvFZ9MGqnUu3ycWzfDXm5fy
         ugbUrm/u8oiooMhF9PZIvOhs09eg4Pmxxgg7tO95pZKCW1GbGKYsb1jjITmO1jP5utVN
         2ATBTKIVdJKp4NA0vpgWB9jmIIzmqjb6zrp/bd0fsmXiX/2UByYiMrMDcYInK/DaEFlD
         SzmiLPIylB1rVVICSD4hJg6IKLWwh8e8NYbn3/uFOAX1ltXI5ubZwSe/JVYlsgyZ90M9
         D7uQpn5lnAeBv87pmwZKh7CS2FgHOcyWrdQj5tRsLrqBchBBWrVVG5vDUJh79cbwaADd
         a1aw==
X-Gm-Message-State: AOAM531iI+yRRPvzNGN6qZMiM2M/sNoWBpRGW8Iwv19axxhI8Gk5pLe4
        QBPIfTYXmbanMyoaQSjmdJcxuNqgug==
X-Google-Smtp-Source: ABdhPJyX5GznUyW/6kq2K9kPRxLyMQ6vU2vmLih0ec/ihrobd/pIAkPZC2Ry2gH0Kl4Q+e2ptvmJTw==
X-Received: by 2002:a05:6808:2211:b0:2d4:a1de:9c05 with SMTP id bd17-20020a056808221100b002d4a1de9c05mr13160764oib.137.1646148841596;
        Tue, 01 Mar 2022 07:34:01 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id u12-20020a056808114c00b002d72b6e5676sm8528947oiu.29.2022.03.01.07.34.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 07:34:00 -0800 (PST)
Received: (nullmailer pid 1286582 invoked by uid 1000);
        Tue, 01 Mar 2022 15:33:59 -0000
Date:   Tue, 1 Mar 2022 09:33:59 -0600
From:   Rob Herring <robh@kernel.org>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>
Subject: Re: [PATCH] dt-bindings: net: can: renesas,rcar-canfd: Document
 RZ/V2L SoC
Message-ID: <Yh4855Np63fEUl4G@robh.at.kernel.org>
References: <20220227213250.23637-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220227213250.23637-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
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

On Sun, Feb 27, 2022 at 09:32:50PM +0000, Lad Prabhakar wrote:
> Document RZ/V2L CANFD bindings. RZ/V2L CANFD is identical to one found on
> the RZ/G2L SoC. No driver changes are required as generic compatible
> string "renesas,rzg2l-canfd" will be used as a fallback.
> 
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
> DTSI changes [0] have been posted as part of separate series.
> 
> [0] https://patchwork.kernel.org/project/linux-renesas-soc/patch/
> 20220227203744.18355-4-prabhakar.mahadev-lad.rj@bp.renesas.com/
> ---
>  .../devicetree/bindings/net/can/renesas,rcar-canfd.yaml          | 1 +
>  1 file changed, 1 insertion(+)

The patch wouldn't apply, but I don't see the problem other than the 
sha hashes are not from a known base. Please send patches against a 
known rcX (rc1 is preferred) unless you have some other dependency. And 
document that dependency.

Anyways, it is applied manually now.

Rob
