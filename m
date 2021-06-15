Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8653A81C4
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 16:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbhFOOHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 10:07:14 -0400
Received: from mail-il1-f179.google.com ([209.85.166.179]:34499 "EHLO
        mail-il1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbhFOOHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 10:07:05 -0400
Received: by mail-il1-f179.google.com with SMTP id w14so15413447ilv.1;
        Tue, 15 Jun 2021 07:05:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=Ul7S+YmegefjytTCybJFOmbLUpYojuCju7Gxif7Sbhw=;
        b=IY/l1KSaRggvkEyyu1N+0EgzDgsr2cIXuZxEHhi6kVZgVMmGC/RUqApiii9vd/krOe
         pA+1TjF52TYFmBAoI8/mFtFsuP6D9vO8Z7REJfBNKbn383tM9xT3VQ8DXob0VfqR/MMv
         SyokdgLxNn9U5phZfTDETJXuCo4DN2SWJFK79uB+JoQy0YrIcU6spjXFznAc7ZDfxUaP
         lFey9qc7qWBKiWE1F4GcFI9j+/iooWsli6dSgVZXikZcLL0Q6wcXumnfuiKT3DtyYiUX
         8JrnKofgTAyrSdsctxnSlGvnkFfcslRXTxvFzN/JThUCS9KvfcktPHYSRsKW/kWEctKH
         zkgg==
X-Gm-Message-State: AOAM531h0nmCKbZdvnbVH0m0uS7LUsucGKEBqnT9A+Co29IShOi9AHej
        wmtln975Mroi7+8h9L31dw==
X-Google-Smtp-Source: ABdhPJxlnUeLKisaHXDilxBGNC4oZcH3BSSM4B2ikEr4N4pEw8d4AZXuCBOQPgy54qWgugEGKRfulg==
X-Received: by 2002:a05:6e02:809:: with SMTP id u9mr18073417ilm.63.1623765900676;
        Tue, 15 Jun 2021 07:05:00 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id d5sm9299257ilf.55.2021.06.15.07.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 07:04:59 -0700 (PDT)
Received: (nullmailer pid 487355 invoked by uid 1000);
        Tue, 15 Jun 2021 14:04:53 -0000
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?b?5ZGo55Cw5p2wIChaaG91IFlhbmppZSk=?= 
        <zhouyanjie@wanyeetech.com>
Cc:     linux-mediatek@lists.infradead.org, dongsheng.qiu@ingenic.com,
        netdev@vger.kernel.org, peppe.cavallaro@st.com,
        devicetree@vger.kernel.org, joabreu@synopsys.com, kuba@kernel.org,
        davem@davemloft.net, sihui.liu@ingenic.com,
        alexandre.torgue@st.com, mcoquelin.stm32@gmail.com,
        aric.pzqi@ingenic.com, linux-kernel@vger.kernel.org,
        matthias.bgg@gmail.com, linux-stm32@st-md-mailman.stormreply.com,
        jun.jiang@ingenic.com, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org, rick.tyliu@ingenic.com,
        sernia.zhou@foxmail.com, alexandre.torgue@foss.st.com
In-Reply-To: <1623690937-52389-2-git-send-email-zhouyanjie@wanyeetech.com>
References: <1623690937-52389-1-git-send-email-zhouyanjie@wanyeetech.com> <1623690937-52389-2-git-send-email-zhouyanjie@wanyeetech.com>
Subject: Re: [PATCH v3 1/2] dt-bindings: dwmac: Add bindings for new Ingenic SoCs.
Date:   Tue, 15 Jun 2021 08:04:53 -0600
Message-Id: <1623765893.376832.487354.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Jun 2021 01:15:36 +0800, 周琰杰 (Zhou Yanjie) wrote:
> Add the dwmac bindings for the JZ4775 SoC, the X1000 SoC,
> the X1600 SoC, the X1830 SoC and the X2000 SoC from Ingenic.
> 
> Signed-off-by: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
> ---
> 
> Notes:
>     v1->v2:
>     No change.
> 
>     v2->v3:
>     Add "ingenic,mac.yaml" for Ingenic SoCs.
> 
>  .../devicetree/bindings/net/ingenic,mac.yaml       | 76 ++++++++++++++++++++++
>  .../devicetree/bindings/net/snps,dwmac.yaml        | 15 +++++
>  2 files changed, 91 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/ingenic,mac.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ingenic,mac.example.dt.yaml: ethernet@134b0000: compatible: ['ingenic,x1000-mac', 'snps,dwmac'] is too long
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ingenic,mac.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ingenic,mac.example.dt.yaml: ethernet@134b0000: compatible: Additional items are not allowed ('snps,dwmac' was unexpected)
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ingenic,mac.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ingenic,mac.example.dt.yaml: ethernet@134b0000: 'phy-mode' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/snps,dwmac.yaml
\ndoc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1491797

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

