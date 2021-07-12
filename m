Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDC13C5E0F
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 16:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234816AbhGLOPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 10:15:53 -0400
Received: from mail-il1-f171.google.com ([209.85.166.171]:35797 "EHLO
        mail-il1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234435AbhGLOPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 10:15:52 -0400
Received: by mail-il1-f171.google.com with SMTP id a11so19639618ilf.2;
        Mon, 12 Jul 2021 07:13:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=k8igawHCplNtH/pRw0xjDqXjVsOZEfLMKg3MUaxXh5g=;
        b=GEZ1y0RNESUsEhq9eNvqOmsR32D41v8vjftI1oGWijdQ7Ag0ud4Mn1EzdzIoIHpBfa
         /W8grpvzX4PWyBs9Zp5pFU7sBtGr1aa4ghdkVyp/LvwpWTaNDe4jD+ZXlDgJSapSGuO6
         ZQO03E73q2NT/hEcYVroNW9qlhgR723nCN2IpgSwpD6LOfcCoSsRHFY8WfdUe+ukpJRF
         uRBrHwGqtmO9Xw7Rn3VlfRfZmXvB7ayAq7Wz1CiIz2S8iXs6fBapf1kxOBhdW5v4JSmu
         qmct+g5wjgkyyGNJS6II1+Qvo3aMOrtvBGG9Pl34mG0fmFd+fKopmH/sOQE9w7g/xYqL
         OERA==
X-Gm-Message-State: AOAM532JRYQKPFJ3OvVy8KijdoYtMbuCedUF+nfzBX6EqbN1nTaCi/qc
        /YE0GmCnrvrSKg6JWddbAw==
X-Google-Smtp-Source: ABdhPJwlSCyGZShHWxRoAHp6sVQ0HFvFTi+uc+SK/Qy0mlZMPuHyoGu/+I/X9H0ledRrAXAX2AqTJQ==
X-Received: by 2002:a05:6e02:c2e:: with SMTP id q14mr38126331ilg.2.1626099183211;
        Mon, 12 Jul 2021 07:13:03 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id g1sm7386544ilq.13.2021.07.12.07.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 07:13:02 -0700 (PDT)
Received: (nullmailer pid 1850545 invoked by uid 1000);
        Mon, 12 Jul 2021 14:12:53 -0000
From:   Rob Herring <robh@kernel.org>
To:     alexandru.tachici@analog.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux@armlinux.org.uk, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org, andrew@lunn.ch,
        robh+dt@kernel.org, davem@davemloft.net
In-Reply-To: <20210712130631.38153-8-alexandru.tachici@analog.com>
References: <20210712130631.38153-1-alexandru.tachici@analog.com> <20210712130631.38153-8-alexandru.tachici@analog.com>
Subject: Re: [PATCH v2 7/7] dt-bindings: adin1100: Add binding for ADIN1100 Ethernet PHY
Date:   Mon, 12 Jul 2021 08:12:53 -0600
Message-Id: <1626099173.624231.1850544.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Jul 2021 16:06:31 +0300, alexandru.tachici@analog.com wrote:
> From: Alexandru Tachici <alexandru.tachici@analog.com>
> 
> DT bindings for the ADIN1100 10BASE-T1L Ethernet PHY.
> 
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
> ---
>  .../devicetree/bindings/net/adi,adin1100.yaml | 45 +++++++++++++++++++
>  1 file changed, 45 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/adi,adin1100.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
Documentation/devicetree/bindings/net/adi,adin1100.example.dt.yaml:0:0: /example-0/ethernet@e000c000: failed to match any schema with compatible: ['cdns,zynq-gem', 'cdns,gem']
Documentation/devicetree/bindings/net/adi,adin1100.example.dt.yaml:0:0: /example-0/ethernet@e000c000: failed to match any schema with compatible: ['cdns,zynq-gem', 'cdns,gem']
\ndoc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1503981

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

