Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C724E349766
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 17:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhCYQ4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 12:56:35 -0400
Received: from mail-io1-f46.google.com ([209.85.166.46]:35836 "EHLO
        mail-io1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbhCYQ4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 12:56:08 -0400
Received: by mail-io1-f46.google.com with SMTP id x17so2595273iog.2;
        Thu, 25 Mar 2021 09:56:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=dw5Qz0fa7IfdTrI8pN6SBHaaN6LsgZoAqad+QkXLhkU=;
        b=VUUEDz3Jsw5AiCvPBs28PRQSImRFDnnwDKzg8KWtkYRaibKtnGHdL+3dwxGZWBaQxM
         YkOb7G1+wIamF6/7BsCeMTZUfi/ZmSWVCPCZsqvxk5aEQjsNYBvCvDY2NNZwFsj13pAu
         jvxjdys8dA5vgIm7/6Fo1GitWi5rST85GrP8lSlMsp4EtLJk8ek61/+Q3DDiaoTq1H6r
         m3od15Zs3ZKBY4ydmVuZpZW2RHl9BQuNGnatSmkC6SwakrrcRg9FI9qwzNOg8HcRxnIC
         lBj5oK0fQ7cs/XBW0AGSws6BQVngVybg5BpY35IbF+NpMDnB6QwiwkRmAxkr0NkIEdQD
         sCQg==
X-Gm-Message-State: AOAM5312UjFMwZb0chUgVB97DJ3nBnZH3azPnPZIakgFBSOm7x7pn7uz
        StvhpHp21noUmLDq0yiwXQ5xr+JZIw==
X-Google-Smtp-Source: ABdhPJxXJzMrqHJh9PA09XbV+UNX5PeP0z0/2AkAQ+mar9DqT30Zy6ngSI2EWztUFR72J5taglG+uA==
X-Received: by 2002:a05:6638:2591:: with SMTP id s17mr3057229jat.87.1616691367840;
        Thu, 25 Mar 2021 09:56:07 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id c17sm646496ilh.32.2021.03.25.09.56.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 09:56:06 -0700 (PDT)
Received: (nullmailer pid 1321895 invoked by uid 1000);
        Thu, 25 Mar 2021 16:56:01 -0000
From:   Rob Herring <robh@kernel.org>
To:     Anand Moon <linux.amoon@gmail.com>
Cc:     Rob Herring <robh+dt@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        netdev@vger.kernel.org, Kevin Hilman <khilman@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Jerome Brunet <jbrunet@baylibre.com>,
        linux-amlogic@lists.infradead.org
In-Reply-To: <20210325124225.2760-2-linux.amoon@gmail.com>
References: <20210325124225.2760-1-linux.amoon@gmail.com> <20210325124225.2760-2-linux.amoon@gmail.com>
Subject: Re: [PATCHv1 1/6] dt-bindings: net: ethernet-phy: Fix the parsing of ethernet-phy compatible string
Date:   Thu, 25 Mar 2021 10:56:01 -0600
Message-Id: <1616691361.069761.1321894.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Mar 2021 12:42:20 +0000, Anand Moon wrote:
> Fix the parsing of check of pattern ethernet-phy-ieee802.3 used
> by the device tree to initialize the mdio phy.
> 
> As per the of_mdio below 2 are valid compatible string
> 	"ethernet-phy-ieee802.3-c22"
> 	"ethernet-phy-ieee802.3-c45"
> 
> Cc: Rob Herring <robh@kernel.org>
> Signed-off-by: Anand Moon <linux.amoon@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/ethernet-phy.yaml | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ethernet-phy.example.dt.yaml: ethernet-phy@0: compatible: 'oneOf' conditional failed, one must be fixed:
	['ethernet-phy-id0141.0e90', 'ethernet-phy-ieee802.3-c45'] is too long
	Additional items are not allowed ('ethernet-phy-ieee802.3-c45' was unexpected)
	'ethernet-phy-ieee802.3-c22' was expected
	'ethernet-phy-ieee802.3-c45' was expected
	'ethernet-phy-id0141.0e90' does not match '^ethernet-phy-ieee[0-9]{3}\\.[0-9][-][a-f0-9]{4}$'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ethernet-phy.yaml

See https://patchwork.ozlabs.org/patch/1458341

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

