Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D83335C765
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 15:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239175AbhDLNUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 09:20:21 -0400
Received: from mail-ot1-f49.google.com ([209.85.210.49]:41628 "EHLO
        mail-ot1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237579AbhDLNUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 09:20:20 -0400
Received: by mail-ot1-f49.google.com with SMTP id v19-20020a0568300913b029028423b78c2dso4126786ott.8;
        Mon, 12 Apr 2021 06:20:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=SWhRtPYE2Qb9obCTbikr+1CM4i2vpSQ+VMTPtfvzZNs=;
        b=LPGLJ476UMDbOBZqMcjuGhuPJOat9HWa86OEEfOY86GAPDFSavu6IPbiP/u4IsSfwA
         ruxTTAoTf3ii73qbSmU7Up6sgrpDsnQUovJydAwd6AyEsb3tJCbG/6l2AEc9WB9oGHww
         bEjpORZ6JD68t6gWhs5Be3Scaj7wCquPy3yDUZwAutZYBGYRP0WmeuNEeOTRlU28Esvi
         jcodnzZtKuqbh/bM2zhQr6RXUOzYfwXe11QptTpyW5Gvq65Vmhux/RZ2M/fsfIFGmmWr
         AHfguwsevmSR3S1TYp2MQBDiuGCElProA9C7zXgLxMdXUYBOsnBT4+kmYGqs7icTdIze
         cmHg==
X-Gm-Message-State: AOAM5331hctrDbTOjV9KKT+W+eIzST1tvAAcOGXlnAlvu2wQs+g5k7PC
        BmG2nC/IvhOsR+Rk7RFLKw==
X-Google-Smtp-Source: ABdhPJyePONeCKFc6ooyOa218SIoc9sXLaUQnTNuMGmsRUIyZTDc2dB/Kn7vT3B7XVOUX3TBOjAl+Q==
X-Received: by 2002:a9d:d0d:: with SMTP id 13mr22895544oti.134.1618233602092;
        Mon, 12 Apr 2021 06:20:02 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id o23sm2706131otp.45.2021.04.12.06.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 06:20:01 -0700 (PDT)
Received: (nullmailer pid 3757971 invoked by uid 1000);
        Mon, 12 Apr 2021 13:20:00 -0000
From:   Rob Herring <robh@kernel.org>
To:     Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     git@xilinx.com, linux-kernel@vger.kernel.org,
        michal.simek@xilinx.com, kuba@kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, davem@davemloft.net, vkoul@kernel.org
In-Reply-To: <1617992002-38028-2-git-send-email-radhey.shyam.pandey@xilinx.com>
References: <1617992002-38028-1-git-send-email-radhey.shyam.pandey@xilinx.com> <1617992002-38028-2-git-send-email-radhey.shyam.pandey@xilinx.com>
Subject: Re: [RFC PATCH 1/3] dt-bindings: net: xilinx_axienet: convert bindings document to yaml
Date:   Mon, 12 Apr 2021 08:20:00 -0500
Message-Id: <1618233600.182122.3757970.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 09 Apr 2021 23:43:20 +0530, Radhey Shyam Pandey wrote:
> Convert the bindings document for Xilinx AXI Ethernet Subsystem
> from txt to yaml. No changes to existing binding description.
> 
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> ---
> Pending: Fix below remaining dt_binding_check warning:
> 
> ethernet@40c00000: 'device_type' does not match any of
> the regexes: 'pinctrl-[0-9]+
> ---
>  .../devicetree/bindings/net/xilinx_axienet.txt     |  80 -----------
>  .../devicetree/bindings/net/xilinx_axienet.yaml    | 147 +++++++++++++++++++++
>  MAINTAINERS                                        |   1 +
>  3 files changed, 148 insertions(+), 80 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/xilinx_axienet.txt
>  create mode 100644 Documentation/devicetree/bindings/net/xilinx_axienet.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/xilinx_axienet.example.dt.yaml: ethernet@40c00000: 'device_type' does not match any of the regexes: 'pinctrl-[0-9]+'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/xilinx_axienet.yaml

See https://patchwork.ozlabs.org/patch/1464502

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

