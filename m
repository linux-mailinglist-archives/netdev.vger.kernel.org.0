Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF3446F147
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 18:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239445AbhLIRO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 12:14:29 -0500
Received: from mail-oi1-f170.google.com ([209.85.167.170]:44562 "EHLO
        mail-oi1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242644AbhLIROS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 12:14:18 -0500
Received: by mail-oi1-f170.google.com with SMTP id be32so9509875oib.11;
        Thu, 09 Dec 2021 09:10:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=MmKmadbDU+t3SApKL7eCSJuoBOShdi6C4ig+UXVsOhY=;
        b=nQDkHzMHMlX/++CmRBEw9CjBI0EaITgT7B0BdpD90REfzcNzbV2dr+h4cf6LWgPz86
         uBKKL+IF/zn13Ua7OYKOnHRY7dgUymM286/Geng5li6mRSibE0OG4/FmrRDZnRoJQauB
         zMxhi7fuN4QVq8tba1FuZQD2MrDZkC/Wfj4RE5fdIV2i+MF2CFkCRCboTjbhZRdEEpUr
         3+ZuPIkFOZm8GUcCnlqGqlREglKuP5zU4BT+e6fQNshMWAo3wOaW5ZiVByQfp21ZLeaX
         wht8bgK4Ashy46a1KEHuasX/bVqhP0EKnHLxwAYHzxaSWCBrppPSRgt0GvQPeTANJukE
         nr2Q==
X-Gm-Message-State: AOAM531ezArIS2if4jsEE2P4T95R1zX6celUhzYyPTrdlu1bKsKZExi5
        357SyLBh5Ubf5EVZOa4taw==
X-Google-Smtp-Source: ABdhPJzMAA3qYw58cb2DgCapo43JOGd4Pt6H+SOH2dZxKpX5098kYRqh67QJ6qu4GgGT7/+dbR8UvQ==
X-Received: by 2002:a05:6808:171c:: with SMTP id bc28mr7092157oib.102.1639069844436;
        Thu, 09 Dec 2021 09:10:44 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id w19sm84120oih.44.2021.12.09.09.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 09:10:43 -0800 (PST)
Received: (nullmailer pid 3089521 invoked by uid 1000);
        Thu, 09 Dec 2021 17:10:42 -0000
From:   Rob Herring <robh@kernel.org>
To:     JosephCHANG <josright123@gmail.com>
Cc:     joseph_chang@davicom.com.tw,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org
In-Reply-To: <20211209100702.5609-2-josright123@gmail.com>
References: <20211209100702.5609-1-josright123@gmail.com> <20211209100702.5609-2-josright123@gmail.com>
Subject: Re: [PATCH v2, 1/2] yaml: Add dm9051 SPI network yaml file
Date:   Thu, 09 Dec 2021 11:10:42 -0600
Message-Id: <1639069842.726112.3089520.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 09 Dec 2021 18:07:01 +0800, JosephCHANG wrote:
> For support davicom dm9051 device tree config
> 
> Signed-off-by: JosephCHANG <josright123@gmail.com>
> ---
>  .../bindings/net/davicom,dm9051.yaml          | 62 +++++++++++++++++++
>  1 file changed, 62 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/davicom,dm9051.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
Error: Documentation/devicetree/bindings/net/davicom,dm9051.example.dts:29.34-35 syntax error
FATAL ERROR: Unable to parse input tree
make[1]: *** [scripts/Makefile.lib:373: Documentation/devicetree/bindings/net/davicom,dm9051.example.dt.yaml] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:1413: dt_binding_check] Error 2

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1565710

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

