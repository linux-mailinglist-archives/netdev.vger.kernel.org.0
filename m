Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9094D3DA514
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 15:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237918AbhG2N6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 09:58:01 -0400
Received: from mail-io1-f50.google.com ([209.85.166.50]:35642 "EHLO
        mail-io1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238138AbhG2N5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 09:57:41 -0400
Received: by mail-io1-f50.google.com with SMTP id y9so7287476iox.2;
        Thu, 29 Jul 2021 06:57:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=f6yLtzVKiViVv7Lb1wtruCMYUOAawC7NxRnHoG+pOk8=;
        b=feGBgC/3vgmfVHRGe9/Y72h91iPAdvL1scvBkzaVzjP86CWHixD20aVaI396NQt7lY
         v4IfsOeIf40u63SZdlbRDqtekKyaXWoxkBV1bFiCFlUyIF5HXBnWPB8doSbE0c23mwCR
         L4ckgkaWVmftt/m1RzkhCCcun/IWqAu9sIh3T2kYBj4cyOEFUT4auH+EgIG7Jk18DW/X
         2n0OKzVfJEeBvlHoNUX33893u5m/AlbxwFNJYbzxa49ytPWJsSRVHUnp168FObsHW540
         POEjufgVUSUhKKt1htM48K/vb2ddo9f0jX6eddejCo2jTCW/5cN7dCiCBL9YV3PKKbjH
         Nx1w==
X-Gm-Message-State: AOAM531raok7ichHVSFTL+gXM6xt6W5CFwBnOsIddVm8IRr7iz2Dm4dN
        65AryBJiJU96bVHvFMeMTg==
X-Google-Smtp-Source: ABdhPJyc/94GUQtfy7aN4QTYu5OZ1tFkRkbCxT6z/ChFXl9JaiEB19aizs+rmbVyKypgppOh+favxQ==
X-Received: by 2002:a05:6602:2057:: with SMTP id z23mr4169789iod.29.1627567057226;
        Thu, 29 Jul 2021 06:57:37 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id r8sm2390396iov.39.2021.07.29.06.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 06:57:36 -0700 (PDT)
Received: (nullmailer pid 200467 invoked by uid 1000);
        Thu, 29 Jul 2021 13:57:34 -0000
From:   Rob Herring <robh@kernel.org>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     linux-arm-msm@vger.kernel.org, kuba@kernel.org,
        p.zabel@pengutronix.de, hkallweit1@gmail.com, agross@kernel.org,
        andrew@lunn.ch, netdev@vger.kernel.org, davem@davemloft.net,
        robert.marko@sartura.hr, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, bjorn.andersson@linaro.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org
In-Reply-To: <20210729125358.5227-3-luoj@codeaurora.org>
References: <20210729125358.5227-1-luoj@codeaurora.org> <20210729125358.5227-3-luoj@codeaurora.org>
Subject: Re: [PATCH 3/3] dt-bindings: net: rename Qualcomm IPQ MDIO bindings
Date:   Thu, 29 Jul 2021 07:57:34 -0600
Message-Id: <1627567054.801645.200466.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Jul 2021 20:53:58 +0800, Luo Jie wrote:
> rename ipq4019-mdio.yaml to ipq-mdio.yaml for supporting more
> ipq boards such as ipq40xx, ipq807x, ipq60xx and ipq50xx.
> 
> Signed-off-by: Luo Jie <luoj@codeaurora.org>
> ---
>  ...m,ipq4019-mdio.yaml => qcom,ipq-mdio.yaml} | 32 ++++++++++++++++---
>  1 file changed, 28 insertions(+), 4 deletions(-)
>  rename Documentation/devicetree/bindings/net/{qcom,ipq4019-mdio.yaml => qcom,ipq-mdio.yaml} (58%)
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/qcom,ipq-mdio.example.dt.yaml: mdio@90000: reg: [[589824, 100]] is too short
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/qcom,ipq-mdio.yaml
\ndoc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1511253

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

