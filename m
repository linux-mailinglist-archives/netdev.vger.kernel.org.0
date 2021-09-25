Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B951E4184DF
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 00:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbhIYWSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 18:18:09 -0400
Received: from mail-oi1-f173.google.com ([209.85.167.173]:42867 "EHLO
        mail-oi1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbhIYWSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 18:18:09 -0400
Received: by mail-oi1-f173.google.com with SMTP id x124so19858915oix.9;
        Sat, 25 Sep 2021 15:16:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=4zZa0pNx5SO7y8XUgl4L6wylE3A2MDP8EXBjRieRoGg=;
        b=DIL9hY59O6orwZMpvlMeyNSHAA0DVnlYINIBsEJO8VjYmv/xaPluCcg2t5m1GffqPc
         IZKiqrvJFHvAMdeiueazvnCaTPIKPvcPBjZyui+79oZI4F0m51Ehb/2SMC44s4Rx0saA
         iRQlrWaar50SqRh9W+3ovNdR3NTk6+d2dZ4wkt9bqcqyifKyxbmwgKLxUXtPl/3/dSfO
         YulnQArH/tVToZ8Wm2Ldb0wz33tf25DE2bWQHgUmLDLvd3jkTu5a24s/AqKiv9Op0FLf
         jXHshwvG9wti9VlnI0eYxFaOTAwgRXoB3wMS6wxGcFVO3jU6JsDlp+u6U83JjmLz2748
         k+dQ==
X-Gm-Message-State: AOAM532EAGhPkh+Gg6YQ1mL2AVhc4zDuCSNMvMacdRQxbtXHt6mvmo54
        VWzdSsU4loCKeGURglQPIA==
X-Google-Smtp-Source: ABdhPJyxrl+MLrGaVMhZlIuZKpsBWIPx8RYrEaa/BgmMRqDJoT3O8C2TV3JX6WZQqreUbBZ5fKjhtQ==
X-Received: by 2002:a05:6808:1a04:: with SMTP id bk4mr6680603oib.85.1632608193387;
        Sat, 25 Sep 2021 15:16:33 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id z17sm2305434ooz.38.2021.09.25.15.16.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 15:16:32 -0700 (PDT)
Received: (nullmailer pid 3839363 invoked by uid 1000);
        Sat, 25 Sep 2021 22:16:30 -0000
From:   Rob Herring <robh@kernel.org>
To:     Justin Chen <justinpopo6@gmail.com>
Cc:     netdev@vger.kernel.org,
        =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        Michael Chan <michael.chan@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Arnd Bergmann <arnd@arndb.de>, Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        dri-devel@lists.freedesktop.org,
        Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <1632519891-26510-2-git-send-email-justinpopo6@gmail.com>
References: <1632519891-26510-1-git-send-email-justinpopo6@gmail.com> <1632519891-26510-2-git-send-email-justinpopo6@gmail.com>
Subject: Re: [PATCH net-next 1/5] dt-bindings: net: Brcm ASP 2.0 Ethernet controller
Date:   Sat, 25 Sep 2021 17:16:30 -0500
Message-Id: <1632608190.772021.3839362.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Sep 2021 14:44:47 -0700, Justin Chen wrote:
> From: Florian Fainelli <f.fainelli@gmail.com>
> 
> Add a binding document for the Broadcom ASP 2.0 Ethernet controller.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Justin Chen <justinpopo6@gmail.com>
> ---
>  .../devicetree/bindings/net/brcm,asp-v2.0.yaml     | 147 +++++++++++++++++++++
>  1 file changed, 147 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:
./Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml:79:10: [warning] wrong indentation: expected 10 but found 9 (indentation)

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/brcm,asp-v2.0.example.dt.yaml: asp@9c00000: 'mdio@c614', 'mdio@ce14' do not match any of the regexes: 'pinctrl-[0-9]+'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
Documentation/devicetree/bindings/net/brcm,asp-v2.0.example.dt.yaml:0:0: /example-0/asp@9c00000/mdio@c614: failed to match any schema with compatible: ['brcm,asp-v2.0-mdio']
Documentation/devicetree/bindings/net/brcm,asp-v2.0.example.dt.yaml:0:0: /example-0/asp@9c00000/mdio@ce14: failed to match any schema with compatible: ['brcm,asp-v2.0-mdio']

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1532528

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

