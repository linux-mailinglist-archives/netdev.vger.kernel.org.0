Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 246A8545340
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 19:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240869AbiFIRoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 13:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238037AbiFIRoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 13:44:08 -0400
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7241342483;
        Thu,  9 Jun 2022 10:44:07 -0700 (PDT)
Received: by mail-io1-f45.google.com with SMTP id h8so4543107iof.11;
        Thu, 09 Jun 2022 10:44:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2i1pp/1ZsRmToFCoqQ19skHEmaFhsE2D5haAdLzfO1w=;
        b=79uub0lu3FcVydoeQUuXi4rWwAFpIG3fh9mGbrntiKlJ6zPC+pHs6qew7gW+tc+e6g
         GbSmquzQoPWUfWNx6rCAw3SL7L3LHLk2Sjn/6oloephe433HYObAYp8t4fOArWz5hf//
         tpQHQG2+WzuIQ/ue4hhRYNWlUVY3Umf6sNqojn3urldzEXX4rGrHQRNK2Rqdb95Uv+H5
         gATCDlEfF86625WSIzjKWpa9mza5D9D3MlfXC1IyoMrWBKgB74ZhsMM03a2UeOitvQXD
         xnw82cP+knkapihpR06k+9NoHRlCdmAz7vjg+CZ+11xSDQUsiUt/XZcvzsfW7ClCHmxu
         mcyA==
X-Gm-Message-State: AOAM532RUC5cdzf0qiJQHAaPB5WvEXnt/M7iRYhUxXMCALZWg+LDdBgF
        tbcGCjuZ0BmRn9KtlVkZ47JAUIaqHg==
X-Google-Smtp-Source: ABdhPJy51+FrJNx2InXWFPKHM8IB1lHjAQX9L++85q7Lm90YQcc4+l0XuM1CF1L/kmI1uGCI+7qwsw==
X-Received: by 2002:a05:6638:2648:b0:330:be8e:9cc with SMTP id n8-20020a056638264800b00330be8e09ccmr22634260jat.85.1654796646710;
        Thu, 09 Jun 2022 10:44:06 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.251])
        by smtp.gmail.com with ESMTPSA id c12-20020a02330c000000b00331b841cf9fsm4853284jae.33.2022.06.09.10.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 10:44:05 -0700 (PDT)
Received: (nullmailer pid 4015147 invoked by uid 1000);
        Thu, 09 Jun 2022 17:44:03 -0000
Date:   Thu, 9 Jun 2022 11:44:03 -0600
From:   Rob Herring <robh@kernel.org>
To:     Johan Jonker <jbx6244@gmail.com>
Cc:     heiko@sntech.de, edumazet@google.com, linux-kernel@vger.kernel.org,
        davem@davemloft.net, robh+dt@kernel.org,
        linux-rockchip@lists.infradead.org, kuba@kernel.org,
        pabeni@redhat.com, devicetree@vger.kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/3] dt-bindings: net: convert emac_rockchip.txt to
 YAML
Message-ID: <20220609174403.GA4015071-robh@kernel.org>
References: <20220603163539.537-1-jbx6244@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603163539.537-1-jbx6244@gmail.com>
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

On Fri, 03 Jun 2022 18:35:37 +0200, Johan Jonker wrote:
> Convert emac_rockchip.txt to YAML.
> 
> Changes against original bindings:
>   Add mdio sub node.
>   Add extra clock for rk3036
> 
> Signed-off-by: Johan Jonker <jbx6244@gmail.com>
> ---
> 
> Changed V2:
>   use phy
>   rename to rockchip,emac.yaml
>   add more requirements
> ---
>  .../devicetree/bindings/net/emac_rockchip.txt |  52 --------
>  .../bindings/net/rockchip,emac.yaml           | 115 ++++++++++++++++++
>  2 files changed, 115 insertions(+), 52 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/emac_rockchip.txt
>  create mode 100644 Documentation/devicetree/bindings/net/rockchip,emac.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
