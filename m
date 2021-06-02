Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C33339951B
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 23:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbhFBVFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 17:05:32 -0400
Received: from mail-oi1-f175.google.com ([209.85.167.175]:47038 "EHLO
        mail-oi1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhFBVFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 17:05:30 -0400
Received: by mail-oi1-f175.google.com with SMTP id x15so4008751oic.13;
        Wed, 02 Jun 2021 14:03:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dLnYTEbSZ20S1sAYbhXfu4nsy5YD5/Va1Hrjfwf4SZI=;
        b=iQlgGwkEZYwVNGxgOPja8tdFFSMsqOsI/VRJwkIAgciQH/Y4TVb6/ddCDn821BSXJ3
         ZXCqoUkWno+xtBtwBauoyIePzmrb4ML4kkMDTa1pIMA11opS4Edstl847AcRpkiwDUPE
         gWYmvOqTeWzwrEGNOX2+uARfVbYrcOtMJlemCKY+L3OqTLF0U1kp5cqE4DaXQ38kmedY
         JVu94JVwZy64SUIR3WUgFuLeqq0oHTaln73Lum7jUZWhvReRwJcsRUPGw3gxCBqTgyfK
         VrAHDqwbrBZTe3hTfEWA6INw7aPFP0qrm/Bm/DKmGK9hwOISM7DFRlcYVdI2xCmb2cSl
         TX3Q==
X-Gm-Message-State: AOAM530JBkcGFE6Uio0eQwH6hS2OGdav9ImtpbejV5VrlbnSBRfK+0dS
        v8xmqknMBuxVO9AVsgJPsQ==
X-Google-Smtp-Source: ABdhPJwzqC2XJXHhkwYt4RptxqcSdFcN/kP0H0MQF9MHuOZBc6phW4g8h6Op9s6Ub7E54um+kyvYNA==
X-Received: by 2002:a05:6808:a97:: with SMTP id q23mr7233255oij.39.1622667812829;
        Wed, 02 Jun 2021 14:03:32 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id q63sm234944oic.15.2021.06.02.14.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 14:03:32 -0700 (PDT)
Received: (nullmailer pid 4037543 invoked by uid 1000);
        Wed, 02 Jun 2021 21:03:30 -0000
Date:   Wed, 2 Jun 2021 16:03:30 -0500
From:   Rob Herring <robh@kernel.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     dmaengine@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-remoteproc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Ohad Ben-Cohen <ohad@wizery.com>,
        linux-usb@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Tero Kristo <kristo@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nishanth Menon <nm@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Stephen Boyd <sboyd@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-can@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Sekhar Nori <nsekhar@ti.com>, Jakub Kicinski <kuba@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        linux-mmc@vger.kernel.org, Roger Quadros <rogerq@ti.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: Re: [PATCH 03/12] dt-bindings: soc: ti: update sci-pm-domain.yaml
 references
Message-ID: <20210602210330.GA4037450@robh.at.kernel.org>
References: <cover.1622648507.git.mchehab+huawei@kernel.org>
 <c03020ff281054c3bd2527c510659e05fec6f181.1622648507.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c03020ff281054c3bd2527c510659e05fec6f181.1622648507.git.mchehab+huawei@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 02 Jun 2021 17:43:09 +0200, Mauro Carvalho Chehab wrote:
> Changeset fda55c7256fe ("dt-bindings: soc: ti: Convert ti,sci-pm-domain to json schema")
> renamed: Documentation/devicetree/bindings/soc/ti/sci-pm-domain.txt
> to: Documentation/devicetree/bindings/soc/ti/sci-pm-domain.yaml.
> 
> Update the cross-references accordingly.
> 
> Fixes: fda55c7256fe ("dt-bindings: soc: ti: Convert ti,sci-pm-domain to json schema")
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  Documentation/devicetree/bindings/dma/ti-edma.txt             | 4 ++--
>  Documentation/devicetree/bindings/i2c/i2c-davinci.txt         | 2 +-
>  Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt       | 2 +-
>  Documentation/devicetree/bindings/net/can/c_can.txt           | 2 +-
>  .../devicetree/bindings/remoteproc/ti,keystone-rproc.txt      | 2 +-
>  Documentation/devicetree/bindings/usb/ti,j721e-usb.yaml       | 2 +-
>  Documentation/devicetree/bindings/usb/ti,keystone-dwc3.yaml   | 2 +-
>  MAINTAINERS                                                   | 2 +-
>  8 files changed, 9 insertions(+), 9 deletions(-)
> 

Applied, thanks!
