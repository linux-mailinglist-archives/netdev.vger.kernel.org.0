Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70C656833B1
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 18:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbjAaRUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 12:20:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbjAaRTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 12:19:43 -0500
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938AB59E72;
        Tue, 31 Jan 2023 09:19:00 -0800 (PST)
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-15eec491b40so20185387fac.12;
        Tue, 31 Jan 2023 09:19:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pk8cezPfRHW5nrnM5BvYmp5Qtbp4OfnuvFAfscsBAGc=;
        b=cWZjd3ORTVdXCb19dBdE3RCw7h79G61uyO+1SvOHTQVkHpVYgnMBzmdfd6trBYwKDo
         mXOb8/tIK/Yx6s2sy53JYyWY8J3PHhVDaUbEdoPfDy2/V9bxkq4r+Y0Gjl7qr9uNhc/e
         3WOIPA+vnFYKkcBou4cBRC63PP0dzpI5W9jpemADGUn56MAG0uo5c5rTXHew1V38HT7+
         r6H/z0KLtiWsSfz0MS/rCbxtqP1GRsCfw4k0imQBWlD0JXKBMea/MN3Kpy8q7+nvnEm3
         HCMjJEtcdCOTntiai5uQyDk11TQ6lz9UlZIUh+epLk6vj905DkC5SlYwb49aYmooz2uv
         meVQ==
X-Gm-Message-State: AO0yUKVbVhaBQHDXAiPU0EmeAKG1DqgAK7bmVxyVetefPUoNlJm02gFt
        th0n7srs1Kvk1LDoub6VwzYuLv0IKw==
X-Google-Smtp-Source: AK7set+3+bFrGnznFH/c20n29tXmVTtE8gdwm6azaE89h4nSrCxUfCTfsj/stLhV6Vfsfb53hubjcA==
X-Received: by 2002:a05:6871:798:b0:163:d07f:4aea with SMTP id o24-20020a056871079800b00163d07f4aeamr3570806oap.30.1675185511723;
        Tue, 31 Jan 2023 09:18:31 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id v9-20020a05687105c900b00163c90c1513sm2130733oan.28.2023.01.31.09.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 09:18:30 -0800 (PST)
Received: (nullmailer pid 1557289 invoked by uid 1000);
        Tue, 31 Jan 2023 17:18:30 -0000
Date:   Tue, 31 Jan 2023 11:18:30 -0600
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
Subject: Re: [PATCH 03/12] dt-bindings: can: renesas,rcar-canfd: Add
 transceiver support
Message-ID: <20230131171830.GC1531174-robh@kernel.org>
References: <cover.1674499048.git.geert+renesas@glider.be>
 <1bd328b5c9c6cfa633b42af87550f4c7358a05c1.1674499048.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bd328b5c9c6cfa633b42af87550f4c7358a05c1.1674499048.git.geert+renesas@glider.be>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 07:56:05PM +0100, Geert Uytterhoeven wrote:
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

Properly threaded resend due to header corruption.

Acked-by: Rob Herring <robh@kernel.org>
