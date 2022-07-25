Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91591580735
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 00:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237100AbiGYWSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 18:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235512AbiGYWSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 18:18:34 -0400
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F0F252A5;
        Mon, 25 Jul 2022 15:18:33 -0700 (PDT)
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-10bd4812c29so16524563fac.11;
        Mon, 25 Jul 2022 15:18:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GQJ27cbLPN4WtWZWwnZz2P3rL6DTXfcmRiafT85CsZE=;
        b=ZwJhX2W9QVqv5uEV3EgBRgEt+nvPI689D3DfMescT0eCqXnevj/r+A5nz/Pxq2mYcu
         P6UckpFgoAlJ5wyPBlnjg0pzh7a6d6g18U3Jb0heeJ+fa7IYTHj7afAMGgsQrBrg/GnY
         sM+Czk+zhLGbr+E9Ku1Tzj7nMcvHoKp6/dNaKK3hLnvpuGLAewNo6j7q3f39aQh4goSu
         safjEpWw5whAOpVEhnu7uFMMoneyL1HE+LRRy4K41RaZvszJK2iz9xBMBauNEauzDpb0
         /n9qAtV8i79ubter5Q/W9j+Dd7x9TGPrq6z+g1XCg+E2EsSCDKJMY2BKEqSCMHXFJGBc
         seZA==
X-Gm-Message-State: AJIora/OS54ihrBdEZfSUwp+5OR3SXbbdvuQ68z2pltD3S6tA3N6QZKA
        dw50Mz1zy3gBU27qLuMuKQ==
X-Google-Smtp-Source: AGRyM1tAPn2LzxjK8m9cI+Fxi0dC8NDSonDDYYQ+uDkRGu+ZS8ZmO6uzPUSoVLP7iHEm/cxHuYUI/g==
X-Received: by 2002:a05:6871:8b:b0:fe:3656:9071 with SMTP id u11-20020a056871008b00b000fe36569071mr15872330oaa.230.1658787511957;
        Mon, 25 Jul 2022 15:18:31 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id x13-20020a4ab90d000000b00435f239e5b3sm690600ooo.10.2022.07.25.15.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 15:18:31 -0700 (PDT)
Received: (nullmailer pid 2842661 invoked by uid 1000);
        Mon, 25 Jul 2022 22:18:30 -0000
Date:   Mon, 25 Jul 2022 16:18:30 -0600
From:   Rob Herring <robh@kernel.org>
To:     Alexander Stein <alexander.stein@ew.tq-group.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: Re: [PATCH v3 1/1] dt-bindings: net: fsl,fec: Add nvmem-cells /
 nvmem-cell-names properties
Message-ID: <20220725221830.GA2842602-robh@kernel.org>
References: <20220720063924.1412799-1-alexander.stein@ew.tq-group.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220720063924.1412799-1-alexander.stein@ew.tq-group.com>
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

On Wed, 20 Jul 2022 08:39:24 +0200, Alexander Stein wrote:
> These properties are inherited from ethernet-controller.yaml.
> This fixes the dt_binding_check warning:
> imx8mm-tqma8mqml-mba8mx.dt.yaml: ethernet@30be0000: 'nvmem-cell-names',
> 'nvmem-cells' do not match any of the regexes: 'pinctrl-[0-9]+'
> 
> Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
> ---
> Changes in v3:
> * Use nvmem-cells/nvmem-cell-names properties from ethernet-controller.yaml
> * Set unevaluatedProperties instead of additionalProperties
> 
> Changes in v2:
> * Add amount and names of nvmem-cells (copied from ethernet-controller.yaml)
> 
>  Documentation/devicetree/bindings/net/fsl,fec.yaml | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
