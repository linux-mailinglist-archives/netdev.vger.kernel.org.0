Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C66F9508C23
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 17:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380108AbiDTPei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 11:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379306AbiDTPeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 11:34:37 -0400
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F6A38BE4;
        Wed, 20 Apr 2022 08:31:48 -0700 (PDT)
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-e2afb80550so2323422fac.1;
        Wed, 20 Apr 2022 08:31:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3tn/Xnj7jVEGnM7tpSeUDM7Zy5GkSZ35bAu09jhqsy0=;
        b=8PVRA1t4+8d3PRQhwRCGawYIv/hzdZS6NIsJEQvshZ1smbM1y0DQalitis9T6ylYtF
         S7PwXsQfWBgsl6jmTkTeCMV9kRSSRsn8Gp2ygmZo6h2k7ivlrwFr0KSDJyRgsG+dpYfi
         hMp1bxLhR2DROs/ebUk+h56qhVqqRPGA9ml7HNtAAjBF3MKaThA4jXIdzvQLcMY3wKiX
         RkmHXnuNvy4fLjxFJ+1JwKGMXSDqrGJQ2YldY2tT2mmoCYfHqTY9SB9+WW7qG1pGgTyt
         kfuOwBKvP6Imd//G6cKqeYozZj/GipuaOrohDi18Wyxr/kOIq4tI/1sajOiySl5y0Mo5
         SWiQ==
X-Gm-Message-State: AOAM533dnSsccX4TzY7qe+5hl5AfDSZzBGqi4EogHJH2zeWWdvp3vHvm
        x4JXfi/o1hEW3w2/qX2gaA==
X-Google-Smtp-Source: ABdhPJx6Bs/LRTPzjTkofSGDgl42ahXLa67nFTUc271XwpqiXI6PC35wvTT4c6JGoZQhKY5u6lY02g==
X-Received: by 2002:a05:6870:a108:b0:e5:ce89:5034 with SMTP id m8-20020a056870a10800b000e5ce895034mr1915535oae.127.1650468707738;
        Wed, 20 Apr 2022 08:31:47 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id x24-20020a4a9b98000000b0033a70525c35sm964856ooj.30.2022.04.20.08.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 08:31:47 -0700 (PDT)
Received: (nullmailer pid 1340926 invoked by uid 1000);
        Wed, 20 Apr 2022 15:31:46 -0000
Date:   Wed, 20 Apr 2022 10:31:46 -0500
From:   Rob Herring <robh@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     devicetree@vger.kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, john@phrozen.org,
        nbd@nbd.name
Subject: Re: [PATCH v3 net-next] dt-bindings: net: mediatek,net: convert to
 the json-schema
Message-ID: <YmAnYvGXxW0UNYuv@robh.at.kernel.org>
References: <6b417ab35163bd8a4bef4bd38cf46d777925bd26.1650463289.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b417ab35163bd8a4bef4bd38cf46d777925bd26.1650463289.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Apr 2022 16:07:07 +0200, Lorenzo Bianconi wrote:
> This patch converts the existing mediatek-net.txt binding file
> in yaml format.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
> Changes since v2:
> - remove additionalItems for clock-names properties
> - move mediatek,sgmiisys definition out of the if block
> 
> Changes since v1:
> - set resets maxItems to 3
> - fix cci-control-port usage in example
> 
> This patch is based on commits [0] and [1] available in net-next tree but not
> in Linus's one yet.
> 
> [0] 1dafd0d60703 ("dt-bindings: net: mediatek: add optional properties for the SoC ethernet core")
> [1] 4263f77a5144 ("net: ethernet: mtk_eth_soc: use standard property for cci-control-port")
> ---
>  .../devicetree/bindings/net/mediatek,net.yaml | 297 ++++++++++++++++++
>  .../devicetree/bindings/net/mediatek-net.txt  | 108 -------
>  2 files changed, 297 insertions(+), 108 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/mediatek,net.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/mediatek-net.txt
> 

Assuming this passes 'make dt_binding_check' as I haven't run it:

Reviewed-by: Rob Herring <robh@kernel.org>
