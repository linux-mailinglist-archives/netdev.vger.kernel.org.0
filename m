Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE4B62AC81C
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 23:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731161AbgKIWL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 17:11:27 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:41097 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729247AbgKIWL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 17:11:26 -0500
Received: by mail-ot1-f68.google.com with SMTP id n15so10548880otl.8;
        Mon, 09 Nov 2020 14:11:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w99VRsHxGGVhkKnYr9GxplJ6+hwzD9gZqjB/fyCbsQA=;
        b=OUlRQ4rFhqspSc7MrCRLYMiTt77jR5sJ8K6a2Kzr4rYYg+mACq1z3LzqYIQ7akCfM7
         DX/2CRpmX6Qie4quKkzSTwiOYrIgN2H76QEmKizVxOtjraFzgp8aesbAFFMC5Fvhck0n
         O1YF3y6rXC9BJ0V7XC+qvaR0lgwecQxqBemq4QzVDqJnKonlsoBxcfh7u8RKOb4QxNav
         RZTy+jcDJOXhNnPg15zos7yQBEUQJ4H7uLOxsAzlTLSgLwDh/ruVAWpgxgcAscaPwjYg
         Faf6+w828HVn4eEvRG1fnzoM1iyCmzMx7bDkC1nk+bgiPKeUv94eUh9El+lARomJz+8C
         Qi5g==
X-Gm-Message-State: AOAM530kn4tgKaZDfDC+YqWk1ikVA4RqztZ4GUVaFl6LdW0J2yqzNZLP
        HBSHbogTw5dTkKsFcOyG4Q==
X-Google-Smtp-Source: ABdhPJyOksCeOBm7Kr71g34UbyQfWqqLB5Tuz20BPaZCFCHazu4Vl2Z1fmfv9TZy1F4NE4IFf2jMVA==
X-Received: by 2002:a9d:6416:: with SMTP id h22mr1316544otl.241.1604959884908;
        Mon, 09 Nov 2020 14:11:24 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id z77sm2676516ooa.37.2020.11.09.14.11.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 14:11:24 -0800 (PST)
Received: (nullmailer pid 1846745 invoked by uid 1000);
        Mon, 09 Nov 2020 22:11:23 -0000
Date:   Mon, 9 Nov 2020 16:11:23 -0600
From:   Rob Herring <robh@kernel.org>
To:     Laurentiu Tudor <laurentiu.tudor@nxp.com>
Cc:     ioana.ciornei@nxp.com, corbet@lwn.net, leoyang.li@nxp.com,
        davem@davemloft.net, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, robh+dt@kernel.org, kuba@kernel.org,
        Ionut-robert Aron <ionut-robert.aron@nxp.com>
Subject: Re: [PATCH v2 2/2] dt-bindings: misc: convert fsl, qoriq-mc from txt
 to YAML
Message-ID: <20201109221123.GA1846668@bogus>
References: <20201109104635.21116-1-laurentiu.tudor@nxp.com>
 <20201109104635.21116-2-laurentiu.tudor@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201109104635.21116-2-laurentiu.tudor@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 09 Nov 2020 12:46:35 +0200, Laurentiu Tudor wrote:
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
> Changes in v2:
>  - fixed errors reported by yamllint
>  - dropped multiple unnecessary quotes
>  - used schema instead of text in description
>  - added constraints on dpmac reg property
> 
>  .../devicetree/bindings/misc/fsl,qoriq-mc.txt | 196 ----------------
>  .../bindings/misc/fsl,qoriq-mc.yaml           | 210 ++++++++++++++++++
>  .../ethernet/freescale/dpaa2/overview.rst     |   5 +-
>  MAINTAINERS                                   |   4 +-
>  4 files changed, 217 insertions(+), 198 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/misc/fsl,qoriq-mc.txt
>  create mode 100644 Documentation/devicetree/bindings/misc/fsl,qoriq-mc.yaml
> 

Applied, thanks!
