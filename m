Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1DF2A86C6
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 20:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732124AbgKETHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 14:07:06 -0500
Received: from mail-oo1-f65.google.com ([209.85.161.65]:44057 "EHLO
        mail-oo1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731694AbgKETHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 14:07:06 -0500
Received: by mail-oo1-f65.google.com with SMTP id i13so583756oou.11;
        Thu, 05 Nov 2020 11:07:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+0VACE33hmdxStTJYgtEs+NaMkhDM9Ld4u6K2Imaaw0=;
        b=U40tv6F00YALCWherzZtKUIdyTBjLCejJ1/WQvdJ7bC76hCdONiOlvrTjpLytTVDMG
         AB53pFyLZK1emlSPa4LSMMz1GHy8u3YhanLkmCRH1FJ84f+fRpCywLgcdKO/H1gM81Qq
         LYEyf/U4tTWYgid60Az69Tae17IWgAVQ560XKrgle86QfKq6Dk4v8FVU3t20KGO/Cdn9
         U9t8HUKKXAQMr3Mbf7GieoTR2cnT/Ituf/72z2P/kLBu3ENgYHG6F6eWqGngThNWCFDO
         fAVhx8eccLIy1+VygJfIsI3bNtKd97zUtf1a5gu2W+CVCRnXOaqdjLdkb0C2T38D82Jq
         M+jA==
X-Gm-Message-State: AOAM530/C95s1fktPwe0r39ilTMW3ywYCxxD6SWfAFU25ZgIHdh7UZ9U
        WvD5bNu+FkwKE9L2PS9ml86tKTOmqgDj
X-Google-Smtp-Source: ABdhPJxlv2YaJSGTq/PECyqzbDJue5E/f91YIMXbDcB3rZ47DKXPBTxCblP3bqGr6BC/66Y2Wtybzg==
X-Received: by 2002:a4a:d554:: with SMTP id q20mr2802975oos.23.1604603225517;
        Thu, 05 Nov 2020 11:07:05 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id a23sm535613oot.33.2020.11.05.11.07.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 11:07:04 -0800 (PST)
Received: (nullmailer pid 1645085 invoked by uid 1000);
        Thu, 05 Nov 2020 19:07:04 -0000
Date:   Thu, 5 Nov 2020 13:07:04 -0600
From:   Rob Herring <robh@kernel.org>
To:     Laurentiu Tudor <laurentiu.tudor@nxp.com>
Cc:     ioana.ciornei@nxp.com, linux-doc@vger.kernel.org,
        Ionut-robert Aron <ionut-robert.aron@nxp.com>, kuba@kernel.org,
        linux-kernel@vger.kernel.org, leoyang.li@nxp.com, corbet@lwn.net,
        davem@davemloft.net, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] dt-bindings: misc: convert fsl,qoriq-mc from txt to
 YAML
Message-ID: <20201105190704.GA1644330@bogus>
References: <20201105141114.18161-1-laurentiu.tudor@nxp.com>
 <20201105141114.18161-2-laurentiu.tudor@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201105141114.18161-2-laurentiu.tudor@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 05 Nov 2020 16:11:14 +0200, Laurentiu Tudor wrote:
> From: Ionut-robert Aron <ionut-robert.aron@nxp.com>
> 
> Convert fsl,qoriq-mc to YAML in order to automate the verification
> process of dts files. In addition, update MAINTAINERS accordingly
> and, while at it, add some missing files.
> 
> Signed-off-by: Ionut-robert Aron <ionut-robert.aron@nxp.com>
> [laurentiu.tudor@nxp.com: update MINTAINERS, updates & fixes in schema]
> Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
> ---
>  .../devicetree/bindings/misc/fsl,qoriq-mc.txt | 196 ----------------
>  .../bindings/misc/fsl,qoriq-mc.yaml           | 218 ++++++++++++++++++
>  .../ethernet/freescale/dpaa2/overview.rst     |   5 +-
>  MAINTAINERS                                   |   4 +-
>  4 files changed, 225 insertions(+), 198 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/misc/fsl,qoriq-mc.txt
>  create mode 100644 Documentation/devicetree/bindings/misc/fsl,qoriq-mc.yaml
> 


My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:
./Documentation/devicetree/bindings/misc/fsl,qoriq-mc.yaml:128:9: [warning] wrong indentation: expected 10 but found 8 (indentation)

dtschema/dtc warnings/errors:


See https://patchwork.ozlabs.org/patch/1395017

The base for the patch is generally the last rc1. Any dependencies
should be noted.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

