Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF8034282C
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 22:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbhCSVtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 17:49:50 -0400
Received: from mail-io1-f41.google.com ([209.85.166.41]:43926 "EHLO
        mail-io1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbhCSVt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 17:49:29 -0400
Received: by mail-io1-f41.google.com with SMTP id z136so7639786iof.10;
        Fri, 19 Mar 2021 14:49:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=nVNpQyYOtmrSglfD8Z65o/yIxcj8DvlX9sa4XJ9lDig=;
        b=qvE6+zbFtt6dOC9KRHrxMEUAWpyTuCzOgTuCno2mNRnvjNZj/JTRkb8216QZpmciW6
         Gyf8j12a8YYAOZhHu8EeJamGEuYXqbJVqHISmFETt+NapTEVhmHNq6GcshB1TTIRwDgJ
         r03E++mCpU16bZ8Nbc5IZbKQhZT3YKkf3sSVPHdssQnFlzkZVNHBNReSIxpecr1Qk01Q
         ngEZ+GKdsftJQtSWICbjY+7oFMdAj32YXyCIYz2sd35WPcixMFpvl1EfQK3Y+7YE29VN
         Y2/uK/b+vFF19vugyYjEzqNI0VeTBUnS7RfnenEhdMg+tXzZ528zAofWR3gwbgfftAqP
         /85Q==
X-Gm-Message-State: AOAM532gXm32U/hs3wsxa9a/8cgZC5/M8jh7sQsID3Ai/XLw8tBUtwvC
        gwWsqDrFase2GBD0Y5xofA==
X-Google-Smtp-Source: ABdhPJxf+QdVGiihK/D3bpZJDhiJcIzSYsVBzieW10H9QAwenf4duSCk/xF/WZcxilo+M7rJ8YngMg==
X-Received: by 2002:a6b:d80d:: with SMTP id y13mr4269877iob.75.1616190568865;
        Fri, 19 Mar 2021 14:49:28 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id k4sm3493683iol.18.2021.03.19.14.49.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 14:49:27 -0700 (PDT)
Received: (nullmailer pid 1647638 invoked by uid 1000);
        Fri, 19 Mar 2021 21:49:12 -0000
From:   Rob Herring <robh@kernel.org>
To:     Michael Tretter <m.tretter@pengutronix.de>
Cc:     robh+dt@kernel.org, kernel@pengutronix.de, hkallweit1@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org, dmurphy@ti.com,
        andrew@lunn.ch
In-Reply-To: <20210319155710.2793637-2-m.tretter@pengutronix.de>
References: <20210319155710.2793637-1-m.tretter@pengutronix.de> <20210319155710.2793637-2-m.tretter@pengutronix.de>
Subject: Re: [PATCH 1/2] dt-bindings: dp83867: Add binding for LED mode configuration
Date:   Fri, 19 Mar 2021 15:49:12 -0600
Message-Id: <1616190552.577725.1647637.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Mar 2021 16:57:09 +0100, Michael Tretter wrote:
> The DP83867 supports four configurable LED pins. Describe the
> multiplexing of functions to the LEDs via device tree.
> 
> Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
> ---
>  .../devicetree/bindings/net/ti,dp83867.yaml   | 24 +++++++++++++++++++
>  include/dt-bindings/net/ti-dp83867.h          | 16 +++++++++++++
>  2 files changed, 40 insertions(+)
> 

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,dp83867.yaml: properties:ti,dp83867-led-mode-names:items: 'anyOf' conditional failed, one must be fixed:
	{'anyOf': {'items': [{'const': 'led-0'}, {'const': 'led-1'}, {'const': 'led-2'}, {'const': 'led-gpio'}]}} is not of type 'array'
	{'items': [{'const': 'led-0'}, {'const': 'led-1'}, {'const': 'led-2'}, {'const': 'led-gpio'}]} is not of type 'array'
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,dp83867.yaml: properties:ti,dp83867-led-mode-names:items: {'anyOf': {'items': [{'const': 'led-0'}, {'const': 'led-1'}, {'const': 'led-2'}, {'const': 'led-gpio'}]}} is not of type 'array'
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,dp83867.yaml: properties:ti,dp83867-led-mode-names:items: 'oneOf' conditional failed, one must be fixed:
	{'anyOf': {'items': [{'const': 'led-0'}, {'const': 'led-1'}, {'const': 'led-2'}, {'const': 'led-gpio'}]}} is not of type 'array'
	{'items': [{'const': 'led-0'}, {'const': 'led-1'}, {'const': 'led-2'}, {'const': 'led-gpio'}]} is not of type 'array'
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,dp83867.yaml: ignoring, error in schema: properties: ti,dp83867-led-mode-names: items
warning: no schema found in file: ./Documentation/devicetree/bindings/net/ti,dp83867.yaml

See https://patchwork.ozlabs.org/patch/1455937

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

