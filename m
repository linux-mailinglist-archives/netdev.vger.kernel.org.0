Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94A354299AF
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 01:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235691AbhJKXPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 19:15:46 -0400
Received: from mail-oi1-f170.google.com ([209.85.167.170]:34453 "EHLO
        mail-oi1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235622AbhJKXPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 19:15:46 -0400
Received: by mail-oi1-f170.google.com with SMTP id z11so26687075oih.1;
        Mon, 11 Oct 2021 16:13:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=tD30uQ2DlWg/Srv+bQh0AB6RrI17CFHuZ9aaH7t42I4=;
        b=DTnEjTtThSVhOhi/B0hLBpGy50Qi7gmA566NSNi/ccMJz2aTbkP6rBYln4Rk0YcLgJ
         vZPy5qQ3yqTKf4w+qQhvqbZJw5g0f5eCmhNq1cQnNHWzFJWkq8f+IXoXe7dLjlcHMD49
         TZV1tNxYxKnofzCYh/qdFI0cNNznj54WJh+5z1sqUJZcq/epCdzhxAn1TxcJUK2AXOIX
         TdkUDlg7og3d98wHycwkGfZe6Tyy4RoPbTC1wjH5BF1f1RD4vB3hjbEJscfIHRYtKpnK
         69R3mTRw9EVJx9/kC86mGr3DP536EkyPR+GmtVsl48r6o62tZGn5a6J6BdBiesWIv+Ke
         qLag==
X-Gm-Message-State: AOAM5321QWRZDt62HH/ZHmFUuS5ZyuAPwsYaI/gZMygcayzA5Zqaiqwr
        1yJ51zWVi73NsSYEPLnfXg==
X-Google-Smtp-Source: ABdhPJzJAiCnXOesBGcIEXOE/1j1Fy08Mvz6MllerqCyO0cxyOTtJBv2tTpoJsTreMowkdnXcBLQRw==
X-Received: by 2002:a05:6808:2106:: with SMTP id r6mr1302751oiw.72.1633994024922;
        Mon, 11 Oct 2021 16:13:44 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id k2sm1800346oot.37.2021.10.11.16.13.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 16:13:44 -0700 (PDT)
Received: (nullmailer pid 1347635 invoked by uid 1000);
        Mon, 11 Oct 2021 23:13:43 -0000
From:   Rob Herring <robh@kernel.org>
To:     alexandru.tachici@analog.com
Cc:     devicetree@vger.kernel.org, linux@armlinux.org.uk, andrew@lunn.ch,
        kuba@kernel.org, netdev@vger.kernel.org, hkallweit1@gmail.com,
        robh+dt@kernel.org, davem@davemloft.net, o.rempel@pengutronix.de,
        linux-kernel@vger.kernel.org
In-Reply-To: <20211011142215.9013-9-alexandru.tachici@analog.com>
References: <20211011142215.9013-1-alexandru.tachici@analog.com> <20211011142215.9013-9-alexandru.tachici@analog.com>
Subject: Re: [PATCH v3 8/8] dt-bindings: adin1100: Add binding for ADIN1100 Ethernet PHY
Date:   Mon, 11 Oct 2021 18:13:43 -0500
Message-Id: <1633994023.311795.1347634.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Oct 2021 17:22:15 +0300, alexandru.tachici@analog.com wrote:
> From: Alexandru Tachici <alexandru.tachici@analog.com>
> 
> DT bindings for the ADIN1100 10BASE-T1L Ethernet PHY.
> 
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
> ---
>  .../devicetree/bindings/net/adi,adin1100.yaml | 30 +++++++++++++++++++
>  1 file changed, 30 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/adi,adin1100.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/adi,adin1100.yaml: 'oneOf' conditional failed, one must be fixed:
	'unevaluatedProperties' is a required property
	'additionalProperties' is a required property
	hint: A schema with a "$ref" to another schema either can define all properties used and use "additionalProperties" or can use "unevaluatedProperties"
	from schema $id: http://devicetree.org/meta-schemas/base.yaml#
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/adi,adin1100.yaml: 'anyOf' conditional failed, one must be fixed:
	'properties' is a required property
	'patternProperties' is a required property
	hint: Metaschema for devicetree binding documentation
	from schema $id: http://devicetree.org/meta-schemas/core.yaml#
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/adi,adin1100.yaml: ignoring, error in schema: 
warning: no schema found in file: ./Documentation/devicetree/bindings/net/adi,adin1100.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/adi,adin1100.example.dt.yaml: ethernet: '10base-t1l-2.4vpp' does not match any of the regexes: '.*-names$', '.*-supply$', '^#.*-cells$', '^#[a-zA-Z0-9,+\\-._]{0,63}$', '^[a-zA-Z][a-zA-Z0-9,+\\-._]{0,63}$', '^[a-zA-Z][a-zA-Z0-9,+\\-._]{0,63}@[0-9a-fA-F]+(,[0-9a-fA-F]+)*$', '^__.*__$', 'pinctrl-[0-9]+'
	From schema: /usr/local/lib/python3.8/dist-packages/dtschema/schemas/dt-core.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1539350

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

