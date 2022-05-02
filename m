Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C56F95176AA
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 20:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386932AbiEBSmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 14:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231752AbiEBSmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 14:42:51 -0400
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 785C99FF1;
        Mon,  2 May 2022 11:39:21 -0700 (PDT)
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-ed9a75c453so4559729fac.11;
        Mon, 02 May 2022 11:39:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VVcMzvyTq+QCVR9FKWTpGDU5miJJoGoqrT5NVytuZtY=;
        b=MJZjPDmWJVul52OfHvPoIqg7G95+4GKYsHFt0FB+zyjhxJQGNU0pkVv/BP5ydvAxAK
         r8CiPyAvKau+CgSFhiacHcSLZ9fPy5CV7OYMkd0AN1rPooSbnbbFaEujjFbpfjz4vaYn
         0hqIazArwDRL0FHb8DOhGgtQ9BZBRAEMp/PXAPFADxyKPQFHcgrJjkO4mGJ0EnaAT+U1
         92pIlOtQ1Uq1KfDSbxk0PZUW2yE2WC0gbYQjmtfiGGjW2oAUEUnxfqfN0VOCDv0CgXzo
         0VMuGWF96p9czAcMmub08KlZYl/pb7JBhKIh/cdt7rlozH7ABUFu6CrS5Cdc9vW006CS
         6+GA==
X-Gm-Message-State: AOAM532J22zzbF1KUGCZY/qQDGfJjpylxW0i0wh5OLq0kR+vE/uN8/rR
        71vrIoZgTls5qOpudL7rOw==
X-Google-Smtp-Source: ABdhPJyYgpKONXd4WCpiY4fUPrOQnoiftHSAAMZwKmFvxKURVy5OoQFoTnJejNJOEQ9lYC9mfiNvbg==
X-Received: by 2002:a05:6870:d5a2:b0:de:f682:6c4d with SMTP id u34-20020a056870d5a200b000def6826c4dmr210993oao.283.1651516759431;
        Mon, 02 May 2022 11:39:19 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id b3-20020a05687061c300b000e686d13879sm6088920oah.19.2022.05.02.11.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 11:39:18 -0700 (PDT)
Received: (nullmailer pid 1499405 invoked by uid 1000);
        Mon, 02 May 2022 18:39:17 -0000
Date:   Mon, 2 May 2022 13:39:17 -0500
From:   Rob Herring <robh@kernel.org>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     netdev@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Biju Das <biju.das@bp.renesas.com>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: can: renesas,rcar-canfd: Document RZ/G2UL
 support
Message-ID: <YnAlVQr1A6UU0tB3@robh.at.kernel.org>
References: <20220423130743.123198-1-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220423130743.123198-1-biju.das.jz@bp.renesas.com>
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

On Sat, 23 Apr 2022 14:07:43 +0100, Biju Das wrote:
> Add CANFD binding documentation for Renesas R9A07G043 (RZ/G2UL) SoC.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
>  .../devicetree/bindings/net/can/renesas,rcar-canfd.yaml          | 1 +
>  1 file changed, 1 insertion(+)
> 

Applied, thanks!
