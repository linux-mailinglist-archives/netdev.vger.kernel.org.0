Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96B8B6EE7D0
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 20:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234879AbjDYSxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 14:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234806AbjDYSxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 14:53:11 -0400
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4727A17A32;
        Tue, 25 Apr 2023 11:52:51 -0700 (PDT)
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-1879fc89e67so4065507fac.0;
        Tue, 25 Apr 2023 11:52:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682448703; x=1685040703;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UikZ9QXYdXTQtvhUyv/lQ7QWK7IHC52OKirQxX/ASjw=;
        b=ZasKw8Ddl3Vlom+JzQEiJLDw2rsTXCTooG9vXfWJqGOiojBwRLMM2vBwMpnOf81utb
         xoxXsyd0kO4weg+SNzB4RyVz+zABgwjX+IWppM2b5DMGnBxFVJ75VNT2wSTWLxvmlMoP
         vUxxO9JlixyyUmnC+55pUjEZ7l0ewRd0wK2pYM0mUXo3mXtRchLTA7rcP3kZyJzq7C/B
         yph+vpy8Qp2b8usK1/Ffgv/Tr5qkdiMHovKdoLmruAajwuFYsQ6ZiZHfFIes0uighlIx
         KJCDyEqqdmsnzBbY1FO5sJAr8HywTdB/uZlAc3Dkg2vpKyv9wwm0jJda6QAfl5+pMphs
         Xy2A==
X-Gm-Message-State: AAQBX9cqXAD+bjotjE29JNfRf3hP0eYvkSCtO+wG4cZupIo5M4D3HKjE
        KE9pqvaHGOWcVvvP7PLTqA==
X-Google-Smtp-Source: AKy350aKeKHxBsyU0oVHol9rrTst7OaLguL14eolfZwMFamb8qWN0SPzusU+rrDs+pi8Z83LRg9ubw==
X-Received: by 2002:a05:6870:c222:b0:18e:2db1:215d with SMTP id z34-20020a056870c22200b0018e2db1215dmr8694265oae.12.1682448703024;
        Tue, 25 Apr 2023 11:51:43 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id q1-20020a056870e88100b001727d67f2dbsm5814455oan.40.2023.04.25.11.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 11:51:42 -0700 (PDT)
Received: (nullmailer pid 2076040 invoked by uid 1000);
        Tue, 25 Apr 2023 18:51:41 -0000
Date:   Tue, 25 Apr 2023 13:51:41 -0500
From:   Rob Herring <robh@kernel.org>
To:     MD Danish Anwar <danishanwar@ti.com>
Cc:     andrew@lunn.ch, linux-kernel@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>,
        Suman Anna <s-anna@ti.com>, ssantosh@kernel.org,
        Roger Quadros <rogerq@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-omap@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "Andrew F. Davis" <afd@ti.com>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, srk@ti.com, nm@ti.com,
        Paolo Abeni <pabeni@redhat.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Tero Kristo <kristo@kernel.org>
Subject: Re: [RFC PATCH v6 1/2] dt-bindings: net: Add ICSSG Ethernet
Message-ID: <168244870080.2075982.15308799170658396149.robh@kernel.org>
References: <20230424053233.2338782-1-danishanwar@ti.com>
 <20230424053233.2338782-2-danishanwar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424053233.2338782-2-danishanwar@ti.com>
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


On Mon, 24 Apr 2023 11:02:32 +0530, MD Danish Anwar wrote:
> Add a YAML binding document for the ICSSG Programmable real time unit
> based Ethernet hardware. The ICSSG driver uses the PRU and PRUSS consumer
> APIs to interface the PRUs and load/run the firmware for supporting
> ethernet functionality.
> 
> Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
> ---
>  .../bindings/net/ti,icssg-prueth.yaml         | 184 ++++++++++++++++++
>  1 file changed, 184 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>

