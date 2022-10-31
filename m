Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F894613C78
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 18:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbiJaRui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 13:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiJaRuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 13:50:37 -0400
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EC762D0;
        Mon, 31 Oct 2022 10:50:34 -0700 (PDT)
Received: by mail-oi1-f174.google.com with SMTP id r187so13521218oia.8;
        Mon, 31 Oct 2022 10:50:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O/OrJUaYHRoEPjInfDVcIfVomfgyPlGqEkIKHsEo9lU=;
        b=Sws3S79oK2W9WoRcOxfaCrGsPty2JHx5XcO65A+e0fWM2FKfMaHcjfJ/Qp58SqjD/9
         7ODZHr+lJ/mVHO+5toB87jlYwT+l+w4e55owQK6TZL9q/WtEjdZjdopNs2sNX5SdnqV1
         tRMaJ0htltJ4KLd797qW5X1Pjym8F6RALR/yYQMEO23S4zmC/KzegNBGNOzM8SMkIbEH
         WM7ywfEu6Am7DeOy6U9CnM0QK6BwVLUnNRPAIAO8IL+fZe34bnXF6cn1CyJwqLp68qW+
         jEqSF6O4r9zaN9sKdWELQ/RpffuHJWzv7Hb+YXnv1Sk0dr7Pd/WMKII18cQLIICdXFSp
         pumQ==
X-Gm-Message-State: ACrzQf0MHyvzyg66zjG2XxYzuPd72pSUpuqk//B3cMTu0ALra2t0K5wW
        UOjPfsgOzPYxf2BR+FKHnA==
X-Google-Smtp-Source: AMsMyM4T6altTaqeOLsV6UcilL4G7P8IlDieSR1hoSqarcTXk4QF07+B3xUWgV1CPbP1TirWAooEhQ==
X-Received: by 2002:a05:6808:14c1:b0:354:d3bf:67b with SMTP id f1-20020a05680814c100b00354d3bf067bmr16249885oiw.160.1667238633807;
        Mon, 31 Oct 2022 10:50:33 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id bk32-20020a0568081a2000b003595494e293sm2532518oib.32.2022.10.31.10.50.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 10:50:33 -0700 (PDT)
Received: (nullmailer pid 3060092 invoked by uid 1000);
        Mon, 31 Oct 2022 17:50:34 -0000
Date:   Mon, 31 Oct 2022 12:50:34 -0500
From:   Rob Herring <robh@kernel.org>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     devicetree@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Rob Herring <robh+dt@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Michael Walle <michael@walle.cc>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Robert Marko <robert.marko@sartura.hr>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH 1/5] dt-bindings: vendor-prefixes: Add ONIE
Message-ID: <166723863431.3060035.12852650709794600644.robh@kernel.org>
References: <20221028092337.822840-1-miquel.raynal@bootlin.com>
 <20221028092337.822840-2-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221028092337.822840-2-miquel.raynal@bootlin.com>
X-Spam-Status: No, score=0.3 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLACK autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 28 Oct 2022 11:23:33 +0200, Miquel Raynal wrote:
> As described on their website (see link below),
> 
>    "The Open Network Install Environment (ONIE) is an open source
>     initiative that defines an open “install environment” for modern
>     networking hardware."
> 
> It is not a proper corporation per-se but rather more a group which
> tries to spread the use of open source standards in the networking
> hardware world.
> 
> Link: https://opencomputeproject.github.io/onie/
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
> 
> Please note ONIE is not a "company" but rather more an open source
> group. I don't know if there will be other uses of this prefix but I
> figured out it would be best to describe it to avoid warnings, but I'm
> open to other solutions otherwise.
> 
>  Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
