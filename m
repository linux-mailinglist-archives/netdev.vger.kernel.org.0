Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 728016833B0
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 18:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbjAaRUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 12:20:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232234AbjAaRTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 12:19:24 -0500
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E23759E44;
        Tue, 31 Jan 2023 09:18:40 -0800 (PST)
Received: by mail-ot1-f54.google.com with SMTP id e21-20020a9d5615000000b006884e5dce99so5629493oti.5;
        Tue, 31 Jan 2023 09:18:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ULFzANQgiwDYw64KfZ8hbkwxQA9vXXsv1ocxm2Aq+as=;
        b=ohFTtxHSFSZdTQxMbFvtZcNXQ+HYMr3rOEmIuDFts/bGJXWbQZAN1IDN+tU1R2EnOo
         36Ny+6uW3TqPz2Cha+7TLCwR2pWhXqVYRCUhuH0ZXlkDUl6YaIlQHwYJhsrdxZhmllJK
         ITx5EMFsq9xcSaldrrUNqfUTPQ190EbDmUv/bMciXq/jyQ2XUCk5fhZfsnz1h7m+tx5t
         rb4+BuDn6FpGjnx0y+SNGcoiD+GSzD7jcuCHF7E1h7UOuHbUoNczHfDyr0kBIbs43lWl
         e6gCnoC4CwiPP/E35DiuArglvb/rnrkgSRP+PkYroQim5t6gwrHnbB6VjDbTZ6jkRSch
         5ziQ==
X-Gm-Message-State: AO0yUKWQxMw997v3n1Y43XdjYMnZgNjmA5k2M+cibjB4T+PtTz6/QuDM
        nZZZ64rTFE8l6D08T84Q/66jh1TwHw==
X-Google-Smtp-Source: AK7set9E1Y/P2QG95gYriBibsVMDFj15ps4zMbd5tdZuADVrxmIQkuQ6zQaydhSgzo35IPbgIheLpA==
X-Received: by 2002:a05:6830:2466:b0:68b:a947:cc84 with SMTP id x38-20020a056830246600b0068ba947cc84mr5954033otr.18.1675185485692;
        Tue, 31 Jan 2023 09:18:05 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id h1-20020a9d6001000000b00684cbd8dd49sm4155517otj.79.2023.01.31.09.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 09:18:05 -0800 (PST)
Received: (nullmailer pid 1550858 invoked by uid 1000);
        Tue, 31 Jan 2023 17:18:04 -0000
Date:   Tue, 31 Jan 2023 11:18:04 -0600
From:   Rob Herring <robh@kernel.org>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ulrich Hecht <uli+renesas@fpond.eu>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 02/12] dt-bindings: can: renesas,rcar-canfd: Document
 R-Car V4H support
Message-ID: <20230131171804.GB1531174-robh@kernel.org>
References: <cover.1674499048.git.geert+renesas@glider.be>
 <d8158c78cc786c432df5a5e5bbad848b717aca71.1674499048.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8158c78cc786c432df5a5e5bbad848b717aca71.1674499048.git.geert+renesas@glider.be>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 07:56:04PM +0100, Geert Uytterhoeven wrote:
> Document support for the CAN-FD Interface on the Renesas R-Car V4H
> (R8A779G0) SoC.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  .../devicetree/bindings/net/can/renesas,rcar-canfd.yaml          | 1 +
>  1 file changed, 1 insertion(+)

Properly threaded resend due to header corruption.

Acked-by: Rob Herring <robh@kernel.org>
