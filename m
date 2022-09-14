Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7400E5B87A5
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 13:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiINL4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 07:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiINL4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 07:56:51 -0400
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972482F03E;
        Wed, 14 Sep 2022 04:56:49 -0700 (PDT)
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-1274ec87ad5so40335254fac.0;
        Wed, 14 Sep 2022 04:56:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=JxLgOu6mpwnw6SY29Fdqty2Ik/m+3DmPqodTz8p4N7c=;
        b=bcJEqOtNAatRINLla1+kNIoiKJNMMPW4lw+YuXyAnOKSP9Dij2+fySL9C4jk9kHzj/
         6ZI5pUNbpXHvkr6z4PmlvTNOeyu2Cu00FbZQCng2PS14g0kzcGZUUAd/qs/rRJeEeMdL
         NR9LgDTFpaOYMAFCI8i4QALlpr4sOCZtw+YyXf5dA63XwE6NAc95u7Vjkh+XGib1y6n0
         PHrhwk9f6BrKQluZr077+fK2ZDVRYQJY5EpaEfhLn0HWZeCECEYnfLnxiBQ2swFcQDNM
         aKMMv+sgEEe9udupLHagnPt8iG5xbMgxdkNc00MtYS8n9Ti3uO4RIeIvYHTmpLhWsYMf
         DICw==
X-Gm-Message-State: ACgBeo16XE7jYTBOm4iPvw/VwFeA9jO800syK3gGk9ftY6omCFkkob2B
        yJ078+Qwb9hrjW9Sxvw+vQ==
X-Google-Smtp-Source: AA6agR6iZ+uJtt57/qlMbscIjcVecG6JevOV1N1fEvnEnVqYWCqmEO8HGbz9r0g/xhTHzye7sagkSw==
X-Received: by 2002:aca:add2:0:b0:34f:6883:5878 with SMTP id w201-20020acaadd2000000b0034f68835878mr1690227oie.260.1663156608789;
        Wed, 14 Sep 2022 04:56:48 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id y19-20020a4acb93000000b0044b02c62872sm6431880ooq.10.2022.09.14.04.56.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 04:56:48 -0700 (PDT)
Received: (nullmailer pid 1837080 invoked by uid 1000);
        Wed, 14 Sep 2022 11:56:47 -0000
Date:   Wed, 14 Sep 2022 06:56:47 -0500
From:   Rob Herring <robh@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v2 net-next] dt-bindings: net: dsa: convert ocelot.txt to
 dt-schema
Message-ID: <20220914115647.GA1837019-robh@kernel.org>
References: <20220913125806.524314-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220913125806.524314-1-vladimir.oltean@nxp.com>
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

On Tue, 13 Sep 2022 15:58:06 +0300, Vladimir Oltean wrote:
> Replace the free-form description of device tree bindings for VSC9959
> and VSC9953 with a YAML formatted dt-schema description. This contains
> more or less the same information, but reworded to be a bit more
> succint.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Maxim Kochetkov <fido_max@inbox.ru>
> ---
> v1->v2:
> - provide a more detailed description of the DT binding
> - allow little-endian and big-endian properties
> - allow interrupts property and make it required for vsc9959
> - describe the meaning of the interrupts property
> - reduce indentation in examples from 8 spaces to 4
> - change license so it matches the driver
> 
>  .../bindings/net/dsa/mscc,ocelot.yaml         | 260 ++++++++++++++++++
>  .../devicetree/bindings/net/dsa/ocelot.txt    | 213 --------------
>  2 files changed, 260 insertions(+), 213 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/dsa/ocelot.txt
> 

Reviewed-by: Rob Herring <robh@kernel.org>
