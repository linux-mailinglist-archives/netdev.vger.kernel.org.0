Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5E9515857
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 00:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381439AbiD2W2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 18:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236352AbiD2W2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 18:28:15 -0400
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741ABDC9BE;
        Fri, 29 Apr 2022 15:24:55 -0700 (PDT)
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-e68392d626so9493525fac.4;
        Fri, 29 Apr 2022 15:24:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YCmqAAnVLNhsmckgTlfLUmtn3Y/KcNNFdVhyuvsnwxk=;
        b=s1ov+1J53nOyTKj4Q2UHwaKxpaWN61gj/rzaCv1SRProg2Qo7Zh8ddFyFxTLGVCvLW
         ajX0vl5WpmTz+lACxcrI8pGqv5KOovIrZG7xgTm9m6fTdjAMMf7SzhFTfVVTJN3myO+x
         JPTewKgYFVmV5BTkH7qXFDQ+Sg7Kf3igJktaNUiR7MFlZNjhM5Oil4IUlsHxeWUYaYVf
         KV4OYgTr/Ud6akBvnydTQgPccCL7ipptWR5V9Au/hie39jD6TLVMw/vFZyueetJ1nzVn
         TcDHULzj55OmG1t4+WcbkyO0ad6CcgDdntZy4ZkyauptjLp9kJe9dtpeT5BN/sfopWlf
         40FQ==
X-Gm-Message-State: AOAM533Un+T1uAHTOoQup8+Fkrs5eqYSA4DB3nHOofmrWRtf+6InrngK
        ofAo21gPYJsFAkzqrgGq/g==
X-Google-Smtp-Source: ABdhPJzS0Uoy4UmKVrQb0X16U9pcJorx5GejXUvMVqyAWpQOS/LlOWe43Zwwmb3Hu2WJvgqltwr4+A==
X-Received: by 2002:a05:6870:d354:b0:e2:6a0a:6c1c with SMTP id h20-20020a056870d35400b000e26a0a6c1cmr659459oag.255.1651271094779;
        Fri, 29 Apr 2022 15:24:54 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id w11-20020a4adecb000000b0035eb4e5a6cesm1276713oou.36.2022.04.29.15.24.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 15:24:54 -0700 (PDT)
Received: (nullmailer pid 3008594 invoked by uid 1000);
        Fri, 29 Apr 2022 22:24:53 -0000
Date:   Fri, 29 Apr 2022 17:24:53 -0500
From:   Rob Herring <robh@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh+dt@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/3] dt-bindings: net: micrel: add
 coma-mode-gpios property
Message-ID: <YmxltUykqdguwPko@robh.at.kernel.org>
References: <20220427214406.1348872-1-michael@walle.cc>
 <20220427214406.1348872-2-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427214406.1348872-2-michael@walle.cc>
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

On Wed, 27 Apr 2022 23:44:04 +0200, Michael Walle wrote:
> The LAN8814 has a coma mode pin which is used to put the PHY into
> isolate and power-down mode. Usually strapped to be asserted by default.
> A GPIO is then used to take the PHY out of this mode.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  Documentation/devicetree/bindings/net/micrel.txt | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
