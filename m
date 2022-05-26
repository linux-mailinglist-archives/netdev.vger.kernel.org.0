Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC99534864
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 03:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343720AbiEZBxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 21:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235094AbiEZBxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 21:53:51 -0400
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA9EA76E9;
        Wed, 25 May 2022 18:53:50 -0700 (PDT)
Received: by mail-ot1-f53.google.com with SMTP id g13-20020a9d6b0d000000b0060b13026e0dso139225otp.8;
        Wed, 25 May 2022 18:53:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m55NAQ/+DalgNWR3OXGbO7JhI+ga4RyvXmQjO8mq5mQ=;
        b=rYL3y8yJdI9B6tpDipfQG8JtKDQDKmei/ngo2XHFXevlrqi64uSi6p4MVTmzV25kB4
         370bkidqoAk+aM2Oj8p03+830TJNGWANQ1akF56ozlspNScemdlvO2s7pv5SV0kEevbj
         uXBzmRhKwD60dL+XPwKwOdUAR+rpT/+J+s5EWn57nbvu8S1z3QCtgQtHdpa4WD44/oOz
         Jm/bPpnxJI2BiZXuBnNRl5841vcvWKh0Yolo/EbGS7geSPEpLj/+lI57CMBfg1wUm7ge
         Am9rX976PYnft4C7gSEpJyK4SOH//Ehifr4hBsDUt8YrHB52OtkNq2iRD7VmECVuRXP9
         2x0w==
X-Gm-Message-State: AOAM53077bXn4pyEWeZeutwSVBYvQ1HrgHLoFGNUlioBuGw8F1gfAcof
        3SfYHoAANyNzclWMWmFrCw==
X-Google-Smtp-Source: ABdhPJxUECrPKk1zVsVzwxw4o4izk5MQHkys50u0beDZYTdqa/G5za3LI8m4qnzvCPli/b7OAfXPcw==
X-Received: by 2002:a9d:5506:0:b0:60b:1f4c:85b5 with SMTP id l6-20020a9d5506000000b0060b1f4c85b5mr5483048oth.174.1653530029455;
        Wed, 25 May 2022 18:53:49 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id f18-20020a9d7b52000000b0060603221262sm117879oto.50.2022.05.25.18.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 18:53:48 -0700 (PDT)
Received: (nullmailer pid 2890783 invoked by uid 1000);
        Thu, 26 May 2022 01:53:47 -0000
Date:   Wed, 25 May 2022 20:53:47 -0500
From:   Rob Herring <robh@kernel.org>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Eric Dumazet <edumazet@google.com>,
        Josua Mayer <josua@solid-run.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] dt-bindings: net: adin: Fix adi,phy-output-clock
 description syntax
Message-ID: <20220526015347.GA2890726-robh@kernel.org>
References: <6fcef2665a6cd86a021509a84c5956ec2efd93ed.1653401420.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6fcef2665a6cd86a021509a84c5956ec2efd93ed.1653401420.git.geert+renesas@glider.be>
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

On Tue, 24 May 2022 16:11:53 +0200, Geert Uytterhoeven wrote:
> "make dt_binding_check":
> 
>     Documentation/devicetree/bindings/net/adi,adin.yaml:40:77: [error] syntax error: mapping values are not allowed here (syntax)
> 
> The first line of the description ends with a colon, hence the block
> needs to be marked with a "|".
> 
> Fixes: 1f77204e11f8b9e5 ("dt-bindings: net: adin: document phy clock output properties")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  Documentation/devicetree/bindings/net/adi,adin.yaml | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
