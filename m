Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 978C92F7FD1
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 16:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732870AbhAOPjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 10:39:51 -0500
Received: from mail-ot1-f44.google.com ([209.85.210.44]:46303 "EHLO
        mail-ot1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726402AbhAOPju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 10:39:50 -0500
Received: by mail-ot1-f44.google.com with SMTP id w3so8857407otp.13;
        Fri, 15 Jan 2021 07:39:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=PTG4XjYK/jBh4H7zmaVSMljX5drX3ubXuh1HX7s1fYs=;
        b=Mp5ugw9wZJYG4fAIz6nNn6qQKO2RcSzvnpiDg96KfHqgnAm5Ftv16PzFgTYq3XVSxN
         psltgJrwBtsYGUxoidlxJ4HdMBm5GqWVG9zlrr2blmZ4d+Oer+dKsmy7TweazRMiOWDp
         ViK5LaUmKx4JXcFvqtmK3FfSKOAto1I7mRYUE38ciKClo3+jLokNUZOwyqBuD5NmxwpO
         OybpYS54nTvXxvK8t7bHeIbRxMiGXL8hhjbr9fzuBiJyyTlLxDHyQCLgOudY759Qv9aE
         hxC4xDnUteC3gLp8mrQHlpE2WRaEb+pDP0vjk88bZ4Dqzy6VHF/9xVYsygUJgN1h2Kh8
         3SIw==
X-Gm-Message-State: AOAM531WOZUS3q8usXsk1C8Rlj0XUEJa66NTWSKLzOf2bE4NFUCJnBPX
        pZO8tiA56Zjem0JI0y2dwQ==
X-Google-Smtp-Source: ABdhPJwE0AownlDAn5tWiLxVCLov0JhqYkwwbYGHVgrXVQMvkITh29UivxojEnNjEQSUesJ3VTL/XA==
X-Received: by 2002:a9d:1cae:: with SMTP id l46mr8486962ota.249.1610725149077;
        Fri, 15 Jan 2021 07:39:09 -0800 (PST)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id y84sm1766890oig.36.2021.01.15.07.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 07:39:08 -0800 (PST)
Received: (nullmailer pid 1311457 invoked by uid 1000);
        Fri, 15 Jan 2021 15:39:04 -0000
From:   Rob Herring <robh@kernel.org>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Device Tree List <devicetree@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Einon <mark.einon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20210115135339.3127198-2-steen.hegelund@microchip.com>
References: <20210115135339.3127198-1-steen.hegelund@microchip.com> <20210115135339.3127198-2-steen.hegelund@microchip.com>
Subject: Re: [RFC PATCH v3 1/8] dt-bindings: net: sparx5: Add sparx5-switch bindings
Date:   Fri, 15 Jan 2021 09:39:04 -0600
Message-Id: <1610725144.888233.1311456.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Jan 2021 14:53:32 +0100, Steen Hegelund wrote:
> Document the Sparx5 switch device driver bindings
> 
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
> ---
>  .../bindings/net/microchip,sparx5-switch.yaml | 211 ++++++++++++++++++
>  1 file changed, 211 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
> 

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:
./Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml:92:16: [warning] wrong indentation: expected 14 but found 15 (indentation)

dtschema/dtc warnings/errors:

See https://patchwork.ozlabs.org/patch/1427023

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

