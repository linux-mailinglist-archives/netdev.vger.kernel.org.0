Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D972570A5F
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 21:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbiGKTJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 15:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiGKTJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 15:09:51 -0400
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652212AE29;
        Mon, 11 Jul 2022 12:09:50 -0700 (PDT)
Received: by mail-il1-f180.google.com with SMTP id p13so3591920ilq.0;
        Mon, 11 Jul 2022 12:09:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=flztqminVKMZYpYH1iU55F5QEC4nG+ot8ew7MHnd8eE=;
        b=kMN+SW83xjJy/OSZxmYXxDfJQ2hlQ8LogIFD1SiNpisQk6wfUJ9YUZP0DciZouosXP
         PQs8m8+6KrckoLaPixeQyWsmpD97FETUcXiOJuMztdul8lOrnccoe0gd3isEVRvYLwxa
         bK22oQC5qF5l45rrfWV2gQHLGpJywe9XFYKmwp99DgxiTkN9ZSCNUeL7t41ULDQ3ufnJ
         YrDlGUzlQN8Ha4+VA4e6g/J0JpaLrdElP+riKPXAxkkZeTKhWzXlS3rjs4mNMwdvtZE0
         ZvPC2z4UFH2as5UDc3ZdAbHe2SVh0c7tld3B5oX8Fmj3RHu0H+2+FkSSvG053n23wJQQ
         EH1Q==
X-Gm-Message-State: AJIora+8SFZc8jViCB330vCCND1S3PJ9BQM0ElzF23gdKMlqu4xdJDUa
        B1sO61o5m0DKVf84DxP2Xw==
X-Google-Smtp-Source: AGRyM1stovigsPBJd/F3fxnlI4NIXYN+zovd3E1R5wvHMPhCL5WeBq6OcKj9MKUYMVlS8c1NVTrnMg==
X-Received: by 2002:a05:6e02:b2d:b0:2dc:5e24:7ce9 with SMTP id e13-20020a056e020b2d00b002dc5e247ce9mr9799838ilu.291.1657566589627;
        Mon, 11 Jul 2022 12:09:49 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id f95-20020a0284e8000000b0033cbbf0b762sm3249649jai.116.2022.07.11.12.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 12:09:49 -0700 (PDT)
Received: (nullmailer pid 109049 invoked by uid 1000);
        Mon, 11 Jul 2022 19:09:47 -0000
Date:   Mon, 11 Jul 2022 13:09:47 -0600
From:   Rob Herring <robh@kernel.org>
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     Bhadram Varka <vbhadram@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>, devicetree@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jon Hunter <jonathanh@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org, Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v4 5/9] dt-bindings: net: Add Tegra234 MGBE
Message-ID: <20220711190947.GA108998-robh@kernel.org>
References: <20220707074818.1481776-1-thierry.reding@gmail.com>
 <20220707074818.1481776-6-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707074818.1481776-6-thierry.reding@gmail.com>
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

On Thu, 07 Jul 2022 09:48:14 +0200, Thierry Reding wrote:
> From: Bhadram Varka <vbhadram@nvidia.com>
> 
> Add device-tree binding documentation for the Multi-Gigabit Ethernet
> (MGBE) controller found on NVIDIA Tegra234 SoCs.
> 
> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
> Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
> Changes in v4:
> - uses fixed lists of items for clock-names and reset-names
> - add missing maxItems to interrupts property
> - drop minItems where it equals maxItems
> - drop unnecessary blank lines
> - drop redundant comment
> 
> Changes in v3:
> - add macsec and macsec-ns interrupt names
> - improve mdio bus node description
> - drop power-domains description
> - improve bindings title
> 
> Changes in v2:
> - add supported PHY modes
> - change to dual license
> 
>  .../bindings/net/nvidia,tegra234-mgbe.yaml    | 162 ++++++++++++++++++
>  1 file changed, 162 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
