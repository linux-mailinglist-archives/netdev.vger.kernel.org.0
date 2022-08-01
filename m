Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE4B586CD7
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 16:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbiHAOaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 10:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbiHAOaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 10:30:21 -0400
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0BB713D3A;
        Mon,  1 Aug 2022 07:30:19 -0700 (PDT)
Received: by mail-io1-f54.google.com with SMTP id l24so8465371ion.13;
        Mon, 01 Aug 2022 07:30:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=0dbqmbbrnh6eHwm9n5c6wq1oHU5KlKV/W4sU8ErOXro=;
        b=rHvQr7yitRqPdNI+1+3IY9rk9PgXUUgG6aQWDZ+fHTuEcXnyOWPOaEX8U9MWO2dKo0
         AcVCZ03m75Xh7ihojlxhqGVrd23TAJ26ES8SQJM7kihKDVHgDAhY8n6CUDdYjH6hjx51
         /BMSzwympbA1w8QjZIsedV4J3zYwGUJFarnUUvwZo/hdEnwzisJRkpTQ/KGWORpXknpX
         OroE+XuHSGWcrtFv0IDJn/U+WDSQKXwVjQRR83P6vd5UEnU2R+oCrlf8ArGGbSgxMasT
         InMOLDLfxmz62ev9vS7sqyRWJelqy+ToM515/y8scdmr/JNeqc0Gk6CAIKhaJGUvxWp4
         GuMA==
X-Gm-Message-State: AJIora+U2trNESuYqN6bWAvuELztuVEM9tROXiKBDJwVz9jZomBnjOml
        HKPWE73WCuQdyLeMoBXGvA==
X-Google-Smtp-Source: AGRyM1v5SwV/IkWt6ScPuoGGKKT/r+zR56rXpY8ZELh6SwE0TzxAIPSBHHoxSMGwgoWx4+L2i4xBhg==
X-Received: by 2002:a05:6602:27cd:b0:669:3d8d:4d77 with SMTP id l13-20020a05660227cd00b006693d8d4d77mr5626127ios.216.1659364219057;
        Mon, 01 Aug 2022 07:30:19 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id j15-20020a056e02014f00b002de42539fddsm3267754ilr.68.2022.08.01.07.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 07:30:18 -0700 (PDT)
Received: (nullmailer pid 974343 invoked by uid 1000);
        Mon, 01 Aug 2022 14:30:17 -0000
Date:   Mon, 1 Aug 2022 08:30:17 -0600
From:   Rob Herring <robh@kernel.org>
To:     Johan Jonker <jbx6244@gmail.com>
Cc:     robh+dt@kernel.org, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, edumazet@google.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-rockchip@lists.infradead.org,
        davem@davemloft.net, heiko@sntech.de,
        krzysztof.kozlowski+dt@linaro.org, pabeni@redhat.com
Subject: Re: [PATCH v2 1/3] dt-bindings: net: convert emac_rockchip.txt to
 YAML
Message-ID: <20220801143017.GA973438-robh@kernel.org>
References: <20220603163539.537-1-jbx6244@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603163539.537-1-jbx6244@gmail.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
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

Looks like this fell through the cracks. Applied, thanks!
