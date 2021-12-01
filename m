Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56CB4464FE3
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 15:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350511AbhLAOif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 09:38:35 -0500
Received: from mail-ot1-f42.google.com ([209.85.210.42]:38847 "EHLO
        mail-ot1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350336AbhLAOgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 09:36:52 -0500
Received: by mail-ot1-f42.google.com with SMTP id n104-20020a9d2071000000b005799790cf0bso35434460ota.5;
        Wed, 01 Dec 2021 06:33:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=vSKp8SW4qJAlrZvF2oE3bJgEbh9IKSRAd1t3AInQQks=;
        b=Zw47FNAqlXslMyc47CA8cF9crSjJnhxzeKY73NMgQQvcMt/7b4/ivhx6X7JWhIOTPe
         7B5rqqb9yHOtSO0lKTlVyoQwKsFXo9dTVFQgY1fQ8goUav4HJiT2W/RPEeHvxQfiDq9d
         KiJv78vyDr6h/8DIcp79FRUsTSBkZ/qK/lmjDHX82kYzF7gDtwsbAqzRxgFAyQShNwTo
         LPSYOvilcaI0DKAGDl3pYxrFJkUEIqoP+ByMB3h7tgJdeDGClrAKIBdMDtNM5Ou8X6n4
         w+AU3CZUnkZDZxTS7gdhgYpBNZw+9nQDKpEOnUJ2dAo25i6tUXZFRytVL3qCRyLkElmQ
         FZJg==
X-Gm-Message-State: AOAM533d2outJOZgyZKC8j7v26tCaxLWEUcw91xMquaDceOvbmTV4sIG
        GBUzM46ZxKTCIbeloxryaw==
X-Google-Smtp-Source: ABdhPJz4DWainMSGpJA3GeB3DrsIvMs7rQ2KU2Huya0Ppx0oRV/KZ+OXV7WMcKSyPZygpq4wjbtY3Q==
X-Received: by 2002:a05:6830:1da:: with SMTP id r26mr5997007ota.73.1638369210988;
        Wed, 01 Dec 2021 06:33:30 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id bq5sm4412oib.55.2021.12.01.06.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 06:33:30 -0800 (PST)
Received: (nullmailer pid 1684347 invoked by uid 1000);
        Wed, 01 Dec 2021 14:33:22 -0000
From:   Rob Herring <robh@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Ray Jui <rjui@broadcom.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Scott Branden <sbranden@broadcom.com>,
        =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        bcm-kernel-feedback-list@broadcom.com,
        Doug Berger <opendmb@gmail.com>
In-Reply-To: <20211201041228.32444-7-f.fainelli@gmail.com>
References: <20211201041228.32444-1-f.fainelli@gmail.com> <20211201041228.32444-7-f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 6/7] dt-bindings: net: Convert SYSTEMPORT to YAML
Date:   Wed, 01 Dec 2021 08:33:22 -0600
Message-Id: <1638369202.204682.1684346.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 20:12:27 -0800, Florian Fainelli wrote:
> Convert the Broadcom SYSTEMPORT Ethernet controller Device Tree binding
> to YAML.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  .../bindings/net/brcm,systemport.txt          | 38 ---------
>  .../bindings/net/brcm,systemport.yaml         | 83 +++++++++++++++++++
>  MAINTAINERS                                   |  1 +
>  3 files changed, 84 insertions(+), 38 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/brcm,systemport.txt
>  create mode 100644 Documentation/devicetree/bindings/net/brcm,systemport.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/brcm,systemport.yaml: properties:interrupts: {'minItems': 2, 'maxItems': 3, 'items': [{'description': 'interrupt line for RX queues'}, {'description': 'interrupt line for TX queues'}, {'description': 'interrupt line for Wake-on-LAN'}]} should not be valid under {'required': ['maxItems']}
	hint: "maxItems" is not needed with an "items" list
	from schema $id: http://devicetree.org/meta-schemas/items.yaml#
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/brcm,systemport.yaml: ignoring, error in schema: properties: interrupts
warning: no schema found in file: ./Documentation/devicetree/bindings/net/brcm,systemport.yaml
Documentation/devicetree/bindings/net/brcm,systemport.example.dt.yaml:0:0: /example-0/ethernet@f04a0000: failed to match any schema with compatible: ['brcm,systemport-v1.00']

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1561999

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

