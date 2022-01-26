Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDF549C21D
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 04:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237188AbiAZD3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 22:29:24 -0500
Received: from mail-oi1-f170.google.com ([209.85.167.170]:34730 "EHLO
        mail-oi1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbiAZD3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 22:29:23 -0500
Received: by mail-oi1-f170.google.com with SMTP id bb37so35112633oib.1;
        Tue, 25 Jan 2022 19:29:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=MVc9s3fcMth95toFpCpjRYn/jVBPtTn1dYVLMhfLjBQ=;
        b=pNx/8RjoW3N8HEB2WAqhNnlAFSyiE3qC5kRvK0LED4PtPw/0Dttmd4YwElJZiGPuAK
         gC1Vjx8ldhqajWydRf7RHjZ9aJzMzf4JsUEsCRNZo+tV7U97zDm3HGgCG+O6Os+zkcJz
         kSQQXWAaVp4lbKV0VG5bSKL1S7Ve6b+LyQZ0EApItoXfhmU6lHBRBLUXKCx4GpFEMG+E
         eT/T7gqYYcjChwGG0ScRtAjJxmSeF9Hr6L5t1ARxrQ26NwKoziUxO5ygp2voQPCtt2ox
         hBCzLUM19Zrl+7LUtLqslJq6zid/OD//vRkdRHUk4IESeQ2gZNH+ZCYoVEUx201TiBeh
         U+ZQ==
X-Gm-Message-State: AOAM531ASCCQaYU6DnhzeKXV7Qq7excrrrgHwOvSAwIj3gwNpqfw+9qF
        AGk35E7ULcKvAZo4p6jV2w==
X-Google-Smtp-Source: ABdhPJyGjhDzW3VjlAj62sAJEzUAaYUE1AdtZZbl9Kh5WzWinsja0JijFVTHL7Ik2dLL4lN7AZDcIg==
X-Received: by 2002:a05:6808:1508:: with SMTP id u8mr2535003oiw.155.1643167762685;
        Tue, 25 Jan 2022 19:29:22 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id a10sm3693017otq.64.2022.01.25.19.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 19:29:21 -0800 (PST)
Received: (nullmailer pid 3724356 invoked by uid 1000);
        Wed, 26 Jan 2022 03:29:18 -0000
From:   Rob Herring <robh@kernel.org>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     devicetree@vger.kernel.org, claudiu.beznea@microchip.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        nicolas.ferre@microchip.com, robh+dt@kernel.org,
        michal.simek@xilinx.com
In-Reply-To: <20220125170533.256468-2-robert.hancock@calian.com>
References: <20220125170533.256468-1-robert.hancock@calian.com> <20220125170533.256468-2-robert.hancock@calian.com>
Subject: Re: [PATCH net-next v2 1/3] dt-bindings: net: cdns,macb: added generic PHY and reset mappings for ZynqMP
Date:   Tue, 25 Jan 2022 21:29:18 -0600
Message-Id: <1643167758.842879.3724354.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jan 2022 11:05:31 -0600, Robert Hancock wrote:
> Updated macb DT binding documentation to reflect the phy-names, phys,
> resets, reset-names properties which are now used with ZynqMP GEM
> devices, and added a ZynqMP-specific DT example.
> 
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> ---
>  .../devicetree/bindings/net/cdns,macb.yaml    | 46 +++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
Error: Documentation/devicetree/bindings/net/cdns,macb.example.dts:41.39-40 syntax error
FATAL ERROR: Unable to parse input tree
make[1]: *** [scripts/Makefile.lib:378: Documentation/devicetree/bindings/net/cdns,macb.example.dt.yaml] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:1398: dt_binding_check] Error 2

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1584186

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

