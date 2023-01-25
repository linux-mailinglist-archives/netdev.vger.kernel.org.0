Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D441B67BA7F
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 20:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236074AbjAYTPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 14:15:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjAYTPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 14:15:36 -0500
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664581EFDF;
        Wed, 25 Jan 2023 11:15:32 -0800 (PST)
Received: by mail-ot1-f47.google.com with SMTP id x21-20020a056830245500b006865ccca77aso11697280otr.11;
        Wed, 25 Jan 2023 11:15:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:references:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SMgDdqA0BpsXXTqBNqcz8Isd/tcmGXFlzcJQnHd2go4=;
        b=oLeQMiR+HOBIQsP33TRIs7VPpSstlCTpoAd5iDux1OuYk+Htw93C8Xzgfanq9E6a3U
         vUd+GsC1ZNCeWqdBIQ0Jjno/HQbOm/F1ksQjCFJZTIQQMihJB67L1xmrPJeNvDKLixyt
         pX5oWei6G7zFjJvgNG/eqpW9eyzE0hvzYSdSHF4/ohD18n5yvB0euC/3+7LvPjaRjjF8
         pqtwAYXQ9ZyEQQhEagQB2TFtaxyqNYmb86DBDn3IncvKTaHsrF/3Bct0q7lEI/F44Kwp
         tPFYSL7W9ypZrlY+auFUwQCMGClc5fz+LPc531Bgi8KIIl5dV2LNdZ/7f4fh+n+hTKbC
         pIOA==
X-Gm-Message-State: AFqh2kpFIQ5ahxjJBiC78uuep/la2+ketD/6guJCfYuf6tvYuVLj/T85
        NmioJbL7D6gIehIhxZhNYw==
X-Google-Smtp-Source: AMrXdXvuwO4sTA+xwT+WvZGbfmijesy1xQ1o1RiB7CYNemhKm+zgVe81Oj6bMucV6opmx5n232y/CQ==
X-Received: by 2002:a05:6830:4486:b0:684:e29a:e236 with SMTP id r6-20020a056830448600b00684e29ae236mr18476995otv.4.1674674131647;
        Wed, 25 Jan 2023 11:15:31 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id cr11-20020a056830670b00b00661a3f4113bsm2489233otb.64.2023.01.25.11.15.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 11:15:31 -0800 (PST)
Received: (nullmailer pid 2708613 invoked by uid 1000);
        Wed, 25 Jan 2023 19:15:30 -0000
Date:   Wed, 25 Jan 2023 13:15:30 -0600
From:   Rob Herring <robh@kernel.org>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Ulrich Hecht <uli+renesas@fpond.eu>,
        linux-renesas-soc@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Subject: Re: [PATCH 02/12] dt-bindings: can: renesas,rcar-canfd: Document
 R-Car V4H support
Message-ID: <167467413003.2708566.4993105267251365877.robh@kernel.org>
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


On Mon, 23 Jan 2023 19:56:04 +0100, Geert Uytterhoeven wrote:
> Document support for the CAN-FD Interface on the Renesas R-Car V4H
> (R8A779G0) SoC.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  .../devicetree/bindings/net/can/renesas,rcar-canfd.yaml          | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
