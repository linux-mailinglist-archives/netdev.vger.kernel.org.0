Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCA6B59CB02
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 23:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238314AbiHVVmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 17:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238228AbiHVVms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 17:42:48 -0400
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C49564E5;
        Mon, 22 Aug 2022 14:42:45 -0700 (PDT)
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-11cab7d7e0fso13399115fac.6;
        Mon, 22 Aug 2022 14:42:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=8qz7d74c7hlW7xUtwZsKmdSVCAcr0dLusrNA4SvhZkw=;
        b=SbD5M5VXbfDmJkilP4c9OdcFiP6FiVCqdioUXz2mcToKqNNK/xo7yza08IE5NPaV75
         czFcRWhmwTZnxVHKcIWKW3jfl+fwJFySdqM6VukIu0Qqyl7imHfbC4V0kUk4v69ibV3W
         5K8DPK8FGkgCLViNV8ExPEnrgq5l3tudEv7WnNOifP8Zg3bvITL1T/WfDLR8ZBdAqf35
         mGqexJTNhWrXaCTZbQtew7tIC0/5CGhSYr6bMbjWYaUYQTw/NmcAP3oH6R0M9VJZFrET
         nMBMiZyCLTHiAfiwmG5PK1k6TRRJtqgi9pyCO4WFdMUbkflvtQVsaPZfZg/gPDaLewdl
         2IFw==
X-Gm-Message-State: ACgBeo0+yyamCj8I8J3d5M9lujjLT4O5R7tEYvQyyg9FFTaJjp+74BKV
        ujKbasG0yPCP1Kbtw9MF7g==
X-Google-Smtp-Source: AA6agR5+QasWh1056W/zDMJdK8QFt2ntS1331IEU+sr3LGpLX0apZzm4iitCBw/JvzFolOXeqBkGZw==
X-Received: by 2002:a05:6871:612:b0:11c:ef28:83d3 with SMTP id w18-20020a056871061200b0011cef2883d3mr130923oan.87.1661204564905;
        Mon, 22 Aug 2022 14:42:44 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id k4-20020a056870570400b0010f07647598sm3231930oap.7.2022.08.22.14.42.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 14:42:44 -0700 (PDT)
Received: (nullmailer pid 905461 invoked by uid 1000);
        Mon, 22 Aug 2022 21:42:43 -0000
Date:   Mon, 22 Aug 2022 16:42:43 -0500
From:   Rob Herring <robh@kernel.org>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     robh+dt@kernel.org, nsekhar@ti.com,
        krzysztof.kozlowski+dt@linaro.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, kishon@ti.com, vladimir.oltean@nxp.com,
        devicetree@vger.kernel.org, grygorii.strashko@ti.com,
        vigneshr@ti.com, kuba@kernel.org, edumazet@google.com,
        krzysztof.kozlowski@linaro.org, linux@armlinux.org.uk
Subject: Re: [PATCH v5 1/3] dt-bindings: net: ti: k3-am654-cpsw-nuss: Update
 bindings for J7200 CPSW5G
Message-ID: <20220822214243.GA905400-robh@kernel.org>
References: <20220822070125.28236-1-s-vadapalli@ti.com>
 <20220822070125.28236-2-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822070125.28236-2-s-vadapalli@ti.com>
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

On Mon, 22 Aug 2022 12:31:23 +0530, Siddharth Vadapalli wrote:
> Update bindings for TI K3 J7200 SoC which contains 5 ports (4 external
> ports) CPSW5G module and add compatible for it.
> 
> Changes made:
>     - Add new compatible ti,j7200-cpswxg-nuss for CPSW5G.
>     - Extend pattern properties for new compatible.
>     - Change maximum number of CPSW ports to 4 for new compatible.
> 
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> ---
>  .../bindings/net/ti,k3-am654-cpsw-nuss.yaml    | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
