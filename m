Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A28CC361435
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 23:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236193AbhDOVfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 17:35:53 -0400
Received: from mail-oo1-f45.google.com ([209.85.161.45]:45602 "EHLO
        mail-oo1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236043AbhDOVfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 17:35:52 -0400
Received: by mail-oo1-f45.google.com with SMTP id s1-20020a4ac1010000b02901cfd9170ce2so5710548oop.12;
        Thu, 15 Apr 2021 14:35:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dmuE5OCkOCbeBnudYMpaUgY0xXoUF0wjgw61Smpjy14=;
        b=cTueS5L/3GrtP9wt2//hsSyzW46sk+A0SadpdU/A/NEVQKUXnJ+QmPEdgChO+4X/7B
         cqyur9dNuxUYIwIQFQqaX7zG98fAZrtLmDU8B0eN9eQIUsIE1xr7y3C6fgRgBIqqGQXH
         dH7HJ701KRzwLdNBHimnPqUzRm/hmP+Fc+h+HWjahTzXROFDuy/ivd+okxPvJHSc6uhC
         dyDGl/97ff5AXOv2bBVTirLCldB5nMxPcCHahHCfiV3m4qs/JTk32JLyMMkNbpOC/kK9
         913ItVbMUqNIUf1YjIp79wEDnAX0iRc+ZbXlNXw9TOKLeKAzCL7qhn65Gh6f1xWHYr2p
         ab7w==
X-Gm-Message-State: AOAM5302aed0uOf3fePGI7pEgZnDijuFM5Ewcy2DxIc2SghZ9lyELdY9
        L2TS/AnGc9/3WSRtUr0n8Q==
X-Google-Smtp-Source: ABdhPJxzLUMdEqX+77oFQN5BKMZF2ysJ7VeUIUWuWlLQ4vgWD/mRY2KKgtSluZ/+OLXPTpWW/nRc5Q==
X-Received: by 2002:a4a:2410:: with SMTP id m16mr861841oof.90.1618522528558;
        Thu, 15 Apr 2021 14:35:28 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id x14sm930615otk.32.2021.04.15.14.35.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 14:35:28 -0700 (PDT)
Received: (nullmailer pid 1921871 invoked by uid 1000);
        Thu, 15 Apr 2021 21:35:27 -0000
Date:   Thu, 15 Apr 2021 16:35:27 -0500
From:   Rob Herring <robh@kernel.org>
To:     Aswath Govindraju <a-govindraju@ti.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        linux-kernel@vger.kernel.org, Lokesh Vutla <lokeshvutla@ti.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: [PATCH v2 1/2] dt-bindings: net: can: Document transceiver
 implementation as phy
Message-ID: <20210415213527.GA1921841@robh.at.kernel.org>
References: <20210415154635.30094-1-a-govindraju@ti.com>
 <20210415154635.30094-2-a-govindraju@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415154635.30094-2-a-govindraju@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Apr 2021 21:16:34 +0530, Aswath Govindraju wrote:
> From: Faiz Abbas <faiz_abbas@ti.com>
> 
> Some transceivers need a configuration step (for example, pulling the
> standby or enable lines) for them to start sending messages. The
> transceiver can be implemented as a phy with the configuration done in the
> phy driver. The bit rate limitation can the be obtained by the driver using
> the phy node.
> 
> Document the above implementation in the bosch mcan bindings
> 
> Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
> Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
> ---
>  Documentation/devicetree/bindings/net/can/bosch,m_can.yaml | 3 +++
>  1 file changed, 3 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
