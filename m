Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05D714F6A11
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 21:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbiDFTii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 15:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231926AbiDFTg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 15:36:59 -0400
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760B71CD7C8;
        Wed,  6 Apr 2022 10:37:43 -0700 (PDT)
Received: by mail-oi1-f181.google.com with SMTP id j83so3129242oih.6;
        Wed, 06 Apr 2022 10:37:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bWQxY5qyzsRtNQUVZiKXQsEQFjbMtJVPZxjBRNS4c44=;
        b=tu9pAKPhJmXFM+fWqdsFCValc43P9KWfM7AT2a6ckxloUTaHgxcM84PjJXvsl/D4jw
         wQF0lMGbgpSYysNniqoh5hSFu8F2mb/okXPehU2c0eiTmnGrMFAEPJ6S9tb384kpVt/0
         v/OtglcBlB5aMKFPLiBkj3js6z+pOIA+SU6aYc5igtqD5Bxcldz/48ifuG0jwt0NniEj
         PyzAWqVRGbcKT4OUcWnPnbZDgbirOg1OyhvEyPOaTWr9iClOCun6R+Fazs8W3opdcO2s
         61DLV9lGo38vyNz1uuw+kPbnnhN5Yo5lP+AXZ4twTLZ9SJhJz+ugdyLV7ixcT5Vv+wBN
         JyZw==
X-Gm-Message-State: AOAM530+xk1uG5MvvMnrUxVahhNWL71lEvzF10v9u/bkvhGsUBDfcPad
        6pvMPwr0Cek2prx7e5VISw==
X-Google-Smtp-Source: ABdhPJyzi7wqXV7P6dcUFRdbsbYuHW2em5UAKJdXRpZAl/Zz7UV2IAa4hpbuDLSTquX/lfirapIvOA==
X-Received: by 2002:a05:6808:218d:b0:2da:7a2e:8607 with SMTP id be13-20020a056808218d00b002da7a2e8607mr4070817oib.145.1649266662694;
        Wed, 06 Apr 2022 10:37:42 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id l1-20020a056830268100b005c93e625b9dsm7901393otu.46.2022.04.06.10.37.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 10:37:42 -0700 (PDT)
Received: (nullmailer pid 2470965 invoked by uid 1000);
        Wed, 06 Apr 2022 17:37:41 -0000
Date:   Wed, 6 Apr 2022 12:37:41 -0500
From:   Rob Herring <robh@kernel.org>
To:     Dongjin Yang <dj76.yang@samsung.com>
Cc:     Moon-Ki Jun <moonki.jun@samsung.com>,
        "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH] dt-bindings: net: snps: remove duplicate name
Message-ID: <Yk3P5b1uNln8TK60@robh.at.kernel.org>
References: <CGME20220404022857epcms1p6e6af1a6a86569f339e50c318abde7d3c@epcms1p6>
 <20220404022857epcms1p6e6af1a6a86569f339e50c318abde7d3c@epcms1p6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220404022857epcms1p6e6af1a6a86569f339e50c318abde7d3c@epcms1p6>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 04 Apr 2022 11:28:57 +0900, Dongjin Yang wrote:
> snps,dwmac has duplicated name for loongson,ls2k-dwmac and
> loongson,ls7a-dwmac.
> 
> Signed-off-by: Dongjin Yang <dj76.yang@samsung.com>
> ---
>  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 

Applied, thanks!
