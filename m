Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6F57518B71
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 19:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240672AbiECRvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 13:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240674AbiECRvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 13:51:45 -0400
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1BA3B3F8;
        Tue,  3 May 2022 10:48:12 -0700 (PDT)
Received: by mail-oi1-f178.google.com with SMTP id l16so11676076oil.6;
        Tue, 03 May 2022 10:48:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kmjxA1AHp/QuEG9/oReIOpe2ZlxYy/0h3ArAEBVTp8A=;
        b=26r4FY1oDIRMqMVDYVaNbzs8sDcjNTTb9C4cMZez2NcwGyHvKhd5BZNIYFCIXxVY2i
         xk8YJdPwK418OiGEABF7DwN9utp5c92yTvIanPGo+sU979marjQdpvTZo5MFicjCi3D3
         DEiS93jwoRbDpd9W53gaw7fT8qGpaMT+IxQHRRZ3pII/XaKeGAW2mOkor9kUi1d3TxpX
         4KzaVS5oRpGwKZVD4k9EztiCV9K8qyYhSbKC0WSloCz7Pqomo9aQ3GJpO0zl1Xx1rcG0
         JUOOFLqMhFFN+42w+spyxnvOwvAsZB5/MhcerSxFsENzfKxnCtuVfwyOmKfq9T12Pk1i
         Ki8Q==
X-Gm-Message-State: AOAM531acMbGdRXIT4Y9j/kkaYaRfxk+IAK2knp1GPXH2ALD9fhLL4rA
        cXNrgD3huM23XujB2xfEFw==
X-Google-Smtp-Source: ABdhPJxLVMCPXAb5YQE9LfZ8ECA1QD5pS4N3BCoQBmSHoAOrkrcoXpXDYPzggUJNHUDjRxH9xjbr0g==
X-Received: by 2002:aca:5e84:0:b0:2ec:9c1d:fc77 with SMTP id s126-20020aca5e84000000b002ec9c1dfc77mr2320417oib.291.1651600091291;
        Tue, 03 May 2022 10:48:11 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id i23-20020a4addd7000000b0035eb4e5a6d6sm5127124oov.44.2022.05.03.10.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 10:48:10 -0700 (PDT)
Received: (nullmailer pid 3945115 invoked by uid 1000);
        Tue, 03 May 2022 17:48:09 -0000
Date:   Tue, 3 May 2022 12:48:09 -0500
From:   Rob Herring <robh@kernel.org>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     bpf@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>, devicetree@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, UNGLinuxDriver@microchip.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [Patch net-next v12 01/13] dt-bindings: net: make
 internal-delay-ps based on phy-mode
Message-ID: <YnFq2ZBPXhAfCn0B@robh.at.kernel.org>
References: <20220502155848.30493-1-arun.ramadoss@microchip.com>
 <20220502155848.30493-2-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502155848.30493-2-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 02 May 2022 21:28:36 +0530, Arun Ramadoss wrote:
> From: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> 
> *-internal-delay-ps properties would be applicable only for RGMII interface
> modes.
> 
> It is changed as per the request,
> https://lore.kernel.org/netdev/d8e5f6a8-a7e1-dabd-f4b4-ea8ea21d0a1d@gmail.com/
> 
> Ran dt_binding_check to confirm nothing is broken.
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  .../bindings/net/ethernet-controller.yaml     | 35 ++++++++++++-------
>  1 file changed, 23 insertions(+), 12 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
