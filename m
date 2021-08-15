Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8309E3EC9A9
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 16:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238507AbhHOOqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 10:46:52 -0400
Received: from mail-ot1-f41.google.com ([209.85.210.41]:34646 "EHLO
        mail-ot1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232465AbhHOOqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Aug 2021 10:46:51 -0400
Received: by mail-ot1-f41.google.com with SMTP id e13-20020a9d63cd0000b02904fa42f9d275so18081164otl.1;
        Sun, 15 Aug 2021 07:46:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=bN9vbmH+m3Pz3a9oy8BHMNpNJ+l72voM9EutrVxvcfo=;
        b=hZWOpjmIRcl+UtcKfYrhpZUeLq3VLV49mB2Inx9SONvJJRrvDW1Ie88VOAB/pye6Ts
         k0csbN8iqTY+wL7G+IsDBsWKim0RkkQCio0Lj7iT6po+AvUfUjtiX3KhbG9S2xVot3Rv
         h59iIFSHDoG9qpDJFF+lt+nOtRkVEypdzm/qNT6RUFUAyMpXxi/KWlRzx+yIZEiW+/ck
         cH3zGFvKd45+eDTdgqjnbmxiUE9Jg1bY7rN8gKfK0qSkzOeKjndZOS74/r9nC95zg4IY
         JzIs5HzGRHXL6nF5Cj0mp+tVr8JB8Kw0nbnodqbMWk9rWyTM8P1/izIynyLgwt8GPfYi
         Cc0g==
X-Gm-Message-State: AOAM532jYs3Q9FyDb+VMetAUDrEeMLkc0XMgJGoWOeduh88KTdURtDkG
        eOxgppNhosoTc9e5dNrHMQ==
X-Google-Smtp-Source: ABdhPJxOz7S+J5MfxTQeFPjpH1CJlbwBQMlfJvhsU9v1nWWA8PTlFMY7ojPLTzq2Ex737zmQZ7kDDg==
X-Received: by 2002:a9d:640e:: with SMTP id h14mr9140741otl.119.1629038780992;
        Sun, 15 Aug 2021 07:46:20 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id o133sm174032oia.10.2021.08.15.07.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Aug 2021 07:46:20 -0700 (PDT)
Received: (nullmailer pid 3706646 invoked by uid 1000);
        Sun, 15 Aug 2021 14:46:19 -0000
From:   Rob Herring <robh@kernel.org>
To:     David Bauer <mail@david-bauer.net>
Cc:     devicetree@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, netdev@vger.kernel.org
In-Reply-To: <20210814181107.138992-1-mail@david-bauer.net>
References: <20210814181107.138992-1-mail@david-bauer.net>
Subject: Re: [PATCH 1/2] dt-bindings: net: add RTL8152 binding documentation
Date:   Sun, 15 Aug 2021 09:46:19 -0500
Message-Id: <1629038779.035202.3706645.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 Aug 2021 20:11:06 +0200, David Bauer wrote:
> Add binding documentation for the Realtek RTL8152 / RTL8153 USB ethernet
> adapters.
> 
> Signed-off-by: David Bauer <mail@david-bauer.net>
> ---
>  .../bindings/net/realtek,rtl8152.yaml         | 43 +++++++++++++++++++
>  1 file changed, 43 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/realtek,rtl8152.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/realtek,rtl8152.yaml: 'additionalProperties' is a required property
	hint: A schema without a "$ref" to another schema must define all properties and use "additionalProperties"
	from schema $id: http://devicetree.org/meta-schemas/base.yaml#
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/realtek,rtl8152.yaml: ignoring, error in schema: 
warning: no schema found in file: ./Documentation/devicetree/bindings/net/realtek,rtl8152.yaml
Documentation/devicetree/bindings/net/realtek,rtl8152.example.dt.yaml:0:0: /example-0/usb@100/usb-eth@2: failed to match any schema with compatible: ['realtek,rtl8153']

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1516862

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

