Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 635C8348294
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 21:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238071AbhCXUHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 16:07:35 -0400
Received: from mail-io1-f52.google.com ([209.85.166.52]:46738 "EHLO
        mail-io1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238170AbhCXUHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 16:07:09 -0400
Received: by mail-io1-f52.google.com with SMTP id j26so22833236iog.13;
        Wed, 24 Mar 2021 13:07:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=kQ8EfIai0iW2bIIQK0w4Z5qSxl9rVxcELF+Eo3Tf2YU=;
        b=kOgr6ar5LmlJ3xK+vriwT8/Ry6ZRS8goKGCg72ztIl6EvL3K3FwJfdz+CcBNGgc+qe
         MrtBmVpgA+SxIrpglEQAg/1Iu3HKSyQHamgUu1WdmsvoO4XqtSTturG3IH6IGutCB8pC
         kslyyJ/33v/5emjtTic7KhpLqf4hqV3zAED8dCsEqlPlBGe/zUULb2RDgdXfLxjhj68G
         mARWYbzLMClu2Nh4dDwTusaDPzK1VrTgu+zmDNN14aKMP712/Popx1b10wanZ1DXz8R3
         I76bMTG/DHM8BMKbw+guiRSDe1cyONocObpkGmH5ODIBu6G0/Ofl0D8TOBqpvZsSwHoF
         KPaQ==
X-Gm-Message-State: AOAM5302oxQEvZibMPHq51/98aBuPgZmeKVQcpqUX90/C1z2CW2+jcpQ
        Wd8NBZirD9OlEJeXJho3UA==
X-Google-Smtp-Source: ABdhPJx0+97Pr/JkbHMlL2UCLm05Zhgoan9kw7ATFj5Cv/Hz995ecWbwg/NXjiAh3m4sMsXnmG31Eg==
X-Received: by 2002:a05:6638:378c:: with SMTP id w12mr4456448jal.127.1616616428402;
        Wed, 24 Mar 2021 13:07:08 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id z12sm1619693ilb.18.2021.03.24.13.07.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 13:07:07 -0700 (PDT)
Received: (nullmailer pid 3539458 invoked by uid 1000);
        Wed, 24 Mar 2021 20:07:06 -0000
Date:   Wed, 24 Mar 2021 14:07:06 -0600
From:   Rob Herring <robh@kernel.org>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        devicetree@vger.kernel.org, pali@kernel.org
Subject: Re: [PATCH net-next 1/2] dt-bindings: ethernet-controller: create a
 type for PHY interface modes
Message-ID: <20210324200706.GA3528805@robh.at.kernel.org>
References: <20210324103556.11338-1-kabel@kernel.org>
 <20210324103556.11338-2-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210324103556.11338-2-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 11:35:55AM +0100, Marek Behún wrote:
> In order to be able to define a property describing an array of PHY
> interface modes, we need to change the current scalar
> `phy-connection-type`, which lists the possible PHY interface modes, to
> an array of length 1 (otherwise we would need to define the same list at
> two different places).
> 
> Moreover Rob Herring says that we cannot reuse the values of a property;
> we need to $ref a type.
> 
> Move the definition of possible PHY interface modes from the
> `phy-connection-type` property to an array type definition
> `phy-connection-type-array`, and simply reference this type in the
> original property.

Why not just extend phy-connection-type to support more than 1 entry?
