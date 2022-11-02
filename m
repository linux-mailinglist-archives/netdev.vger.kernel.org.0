Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B385616995
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 17:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbiKBQqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 12:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232065AbiKBQpn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 12:45:43 -0400
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514FB2CE24;
        Wed,  2 Nov 2022 09:41:50 -0700 (PDT)
Received: by mail-ot1-f49.google.com with SMTP id cb2-20020a056830618200b00661b6e5dcd8so10585076otb.8;
        Wed, 02 Nov 2022 09:41:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SG2jPUPXoP9mCVMEEYG150l4j67U8w95YN31PzgeV68=;
        b=lGZ16iMQVttPbva2H+vz/7jGY3jeMYwTsFtLBfVKZHj0qLa1zTYb7ZOgxoRSqQNDYk
         Hkd1r24YSjz62aVqyN9ti0et9RCcW5ig31+ctLcpjcTZ25zOAwK2NFqSvDwMWt4qWaUm
         daRv4yMFpOL8XRWNntjHHtsAWwn6HF+sGeoZWakFaVz77ZfwZez8hntHSeAbU1AdbKg4
         HZ/h7ywmOWCkK1cpcBPUiZpLwZyj5bsmo3/laW+D4OoigqLcPPqNjPEW6kTASLh7srmb
         AUoi79WHnt+6uCsGw/oorUMKrAed23w0Fq/i9n2x1uq7wciqGJYyyFMNMVQE7/r/rXW2
         CWig==
X-Gm-Message-State: ACrzQf2Lejtw2QIO8VE8IrDHPWTQozuOMJtaWnxg7O2C+DPIq1CyXfGc
        WBLFbtkwtwpwjSBnU02Emw==
X-Google-Smtp-Source: AMsMyM4DoCcGf+LnOiaG0FCWa0P7Lw0dw3pic7n10FTOjB8FQKxt7ejLRSWSiD3N6L/G0ad3g3HVGw==
X-Received: by 2002:a9d:6b99:0:b0:66c:6851:b961 with SMTP id b25-20020a9d6b99000000b0066c6851b961mr5578420otq.160.1667407309544;
        Wed, 02 Nov 2022 09:41:49 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id j2-20020a056870050200b0012763819bcasm6196858oao.50.2022.11.02.09.41.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 09:41:49 -0700 (PDT)
Received: (nullmailer pid 4017630 invoked by uid 1000);
        Wed, 02 Nov 2022 16:41:50 -0000
Date:   Wed, 2 Nov 2022 11:41:50 -0500
From:   Rob Herring <robh@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     kuba@kernel.org, pabeni@redhat.com,
        linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
        greentime.hu@sifive.com, edumazet@google.com,
        netdev@vger.kernel.org, michal.simek@xilinx.com,
        krzysztof.kozlowski+dt@linaro.org, radhey.shyam.pandey@xilinx.com,
        devicetree@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v2 net-next 3/3] dt-bindings: describe the support of
 "clock-frequency" in mdio
Message-ID: <166740730970.4017574.415359172692439661.robh@kernel.org>
References: <20221101010548.900471-1-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221101010548.900471-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue, 01 Nov 2022 09:05:48 +0800, Andy Chiu wrote:
> mdio bus frequency can be configured at boottime by a property in DT
> now, so add a description to it.
> 
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
> ---
>  Documentation/devicetree/bindings/net/xilinx_axienet.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
