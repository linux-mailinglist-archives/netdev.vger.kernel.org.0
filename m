Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 443342AFD62
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 02:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgKLBbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 20:31:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727200AbgKKWqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 17:46:45 -0500
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23CB0C061A48;
        Wed, 11 Nov 2020 14:29:22 -0800 (PST)
Received: by mail-oo1-xc44.google.com with SMTP id c25so818412ooe.13;
        Wed, 11 Nov 2020 14:29:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PfLD6hiAgtlqsfS0PgiHk/7/DoyE8bsIREmgH2sXqng=;
        b=a/eZo4Tr+r+l5mdKTc9EXuohuQcMxngY8SCzcOTKBBxV7DHB01E3DqyD1Gk0KDOAet
         IN+59vo48IiY+7fCniSOsow+pbztvaCvoUMiwNKT9z1rLpN/OZcQdE/GHxPhgBSc9dGL
         np1UheoKh72RhKOciej1E8bcbmI8kf+utCFxzuPx5LgbtF0tt0JBiAz1FoUjx1WhOOja
         z2IpikifIaCKAGNSNBQ6HSDCpbQshZ0rKnolUW5oXWSDAvGmYrwDfnNf9NtuEJ6eIlUR
         gW1ClpIB4VHQxnxZe+uLjUmSAIzVtozHOYyYYSKloQHotRtIkP0soBgVsmWSvT/IRbir
         RBEw==
X-Gm-Message-State: AOAM532ZA5Ab1fGtoaeLC1VaUgKbY2gogVyYzSO7oJ65nYJtNO66feCO
        946OUoB4Zu2rdppDdaApUg==
X-Google-Smtp-Source: ABdhPJxttazYiejrYFxGXo+eoXEAOqirf1PI5dG3AY+t4J3ZPblguuX7xtMbsBnqoKN7UfhvDTKcZw==
X-Received: by 2002:a4a:e96d:: with SMTP id i13mr18561804ooe.66.1605133461660;
        Wed, 11 Nov 2020 14:24:21 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id s14sm715728oij.4.2020.11.11.14.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 14:24:20 -0800 (PST)
Received: (nullmailer pid 2150247 invoked by uid 1000);
        Wed, 11 Nov 2020 22:24:19 -0000
Date:   Wed, 11 Nov 2020 16:24:19 -0600
From:   Rob Herring <robh@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, open list <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Kurt Kanzenbach <kurt@kmk-computers.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Scott Branden <sbranden@broadcom.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        "maintainer:BROADCOM IPROC ARM ARCHITECTURE" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "moderated list:BROADCOM IPROC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH 01/10] dt-bindings: net: dsa: Extend switch nodes pattern
Message-ID: <20201111222419.GA2150194@bogus>
References: <20201110033113.31090-1-f.fainelli@gmail.com>
 <20201110033113.31090-2-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110033113.31090-2-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 09 Nov 2020 19:31:04 -0800, Florian Fainelli wrote:
> Upon discussion with Kurt, Rob and Vladimir it appears that we should be
> allowing ethernet-switch as a node name, update dsa.yaml accordingly.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/dsa/dsa.yaml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
