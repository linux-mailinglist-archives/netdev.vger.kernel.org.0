Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9A166BF333
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 21:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbjCQU4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 16:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbjCQU4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 16:56:13 -0400
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B96AA5DEDD;
        Fri, 17 Mar 2023 13:56:07 -0700 (PDT)
Received: by mail-io1-f54.google.com with SMTP id v10so2854714iol.9;
        Fri, 17 Mar 2023 13:56:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679086567;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BsmT8NNfgtZ1PRYiAmAwLcJbWZcQsKoINOi+pi4N8hw=;
        b=FMCL6CC7KnVgF6n47ppyLDq8GgigpeAZh/4pYzGkBESGO7xCC4+zvzb2m5WKR07SI3
         NacMCpZtzykQgri5jj6RFihZC5AqzqxzSY51gRfo8iQlYjuchqkVgeUDKD+sPp4N0kDb
         idTCrIEZ2eNuouR4FDUbsd7s2oO3AkbN4EjmOCiMEl4k1O+DeEYt6jSuZSOX6VAcjHTG
         knvPGKugfnW3G6nK6wrUEzaYvoLqkYENeRx4/G/pb3LTokJrpmIM9B/SETSI1He/UEYL
         L8Q/BziRuLc+t5KdJQ5+b3PRqukn0MhmkdSkCo0mv3F3gnQih0FHGZM5+jUp+HbmO7w9
         61Wg==
X-Gm-Message-State: AO0yUKVxmIK5q2uTDB6059rSBvGSNhVpVq7MjXZGCSJHKjJDnpKLi3xo
        h7Ev3UaucricBo0W5PkJtA==
X-Google-Smtp-Source: AK7set+ToKO0PixBlYFJyzo1fXru242mTxE/nxzBaShob3BSkATM7RWthimVc23v51gN8LFcASQXtw==
X-Received: by 2002:a5e:950b:0:b0:74c:91c3:3837 with SMTP id r11-20020a5e950b000000b0074c91c33837mr505432ioj.18.1679086566973;
        Fri, 17 Mar 2023 13:56:06 -0700 (PDT)
Received: from robh_at_kernel.org ([64.188.179.249])
        by smtp.gmail.com with ESMTPSA id d65-20020a026244000000b004062d749099sm1011915jac.51.2023.03.17.13.56.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 13:56:06 -0700 (PDT)
Received: (nullmailer pid 2787143 invoked by uid 1000);
        Fri, 17 Mar 2023 20:56:04 -0000
Date:   Fri, 17 Mar 2023 15:56:04 -0500
From:   Rob Herring <robh@kernel.org>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 15/16] dt-bindings: net: dwmac: Simplify MTL
 queue props dependencies
Message-ID: <20230317205604.GA2723387-robh@kernel.org>
References: <20230313225103.30512-1-Sergey.Semin@baikalelectronics.ru>
 <20230313225103.30512-16-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313225103.30512-16-Sergey.Semin@baikalelectronics.ru>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 01:51:02AM +0300, Serge Semin wrote:
> Currently the Tx/Rx queues properties interdependencies are described by
> means of the pattern: "if: required: X, then: properties: Y: false, Z:
> false, etc". Due to very unfortunate MTL Tx/Rx queue DT-node design the
> resultant sub-nodes schemas look very bulky and thus hard to read. The
> situation can be improved by using the "allOf:/oneOf: required: X,
> required: Y, etc" pattern instead thus getting shorter and a bit easier to
> comprehend constructions.
> 
> Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> 
> ---

Reviewed-by: Rob Herring <robh@kernel.org>

> 
> Note the solution can be shortened out a bit further by replacing the
> single-entry allOf statements with just the "not: required: etc" pattern.
> But in order to do that the DT-schema validation tool must be fixed like
> this:
> 
> --- a/meta-schemas/nodes.yaml	2021-02-08 14:20:56.732447780 +0300
> +++ b/meta-schemas/nodes.yaml	2021-02-08 14:21:00.736492245 +0300
> @@ -22,6 +22,7 @@
>      - unevaluatedProperties
>      - deprecated
>      - required
> +    - not
>      - allOf
>      - anyOf
>      - oneOf

This should be added regardless. Can you send a patch to devicetree-spec 
or a GH PR. But I'd skip using that here for now because then we require 
a new version of dtschema.

Rob
