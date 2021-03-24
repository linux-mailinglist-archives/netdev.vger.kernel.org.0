Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF66348381
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 22:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238246AbhCXVT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 17:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238233AbhCXVTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 17:19:31 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87264C06174A;
        Wed, 24 Mar 2021 14:19:31 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id q5so18415075pfh.10;
        Wed, 24 Mar 2021 14:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+aMOd0WVJY1oWCTcKOvtin4y2EZdTSkVDMUS/tqikpY=;
        b=azAqSnDSyKgCLKocRpMm7jxYVZI0jAjl7Xhxd7719/tT7SjJYv2sAEJTEWYZad/F5Q
         HDYKZsXT4W3sW9MmJCl1a03B6LtkUV7r7lxWtVyMJC9LA03EMPb8epn/OhAWMV46z8Hp
         Nasy4VVh3wQqFMyl9xJyG+aU8jZtHIUvC7gFQ7znGjruHs/01hlR1/PHJYYF2tNaXY72
         CJqruhQEPm23MuTCFtsGTFX98QQgV1kfdu9wc8vNGRwxFfAm3+Dz6oWhJaBBDb/Ptp91
         z/Gc4vxYKaP06bld+nTqLRrqo16wJ69zykTWFXiORnshAr9CKGPuL9MP2hwrSPjtUEKq
         c1uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+aMOd0WVJY1oWCTcKOvtin4y2EZdTSkVDMUS/tqikpY=;
        b=YskM7GHzAvp8nvc+njwyVLVMwd8KIjc8BVeIUnuDX5t0w/k/gQFV7OsG1548boi602
         fHS3P6T6R3L5iBvtGrabixzvECRcbh/W0woez1hZutltLanhfnX2P8XcKIp03CFp+Q+7
         9TUoIEveDycukXd3CTlC1I76skAFHGzGvOINKM95Lk1miG5/BBxgLRmk0GiL5nR2X8xO
         LZQOJhayRwsn1pS8Yoi72GMuDm1RWXUCwIzYtAZK0dk9xx44YXdRTAYHkgcXSlmQmp6B
         Bdrf9b4zPNxv3Nuhjd3eswAxJ3exf+KF/rkhJT0533BVBMwb6JJ75LnM0S+w6mOu8q6s
         rXmQ==
X-Gm-Message-State: AOAM5320nXCtCFiDq6OCr9hw1M1brCiY3LE/TpduGI4b5/XpIMipurRM
        1cmqUI7hlzZIea5fo5wpMvk=
X-Google-Smtp-Source: ABdhPJzV60N8RwFtQFqZ4dnZyrdt7a5ZxkJlrn5k746EVO/ZIZNxKAB6BR9GB28r56QXdQEPiJli2Q==
X-Received: by 2002:a63:2e87:: with SMTP id u129mr4676053pgu.107.1616620770592;
        Wed, 24 Mar 2021 14:19:30 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 3sm3499917pfh.13.2021.03.24.14.19.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 14:19:30 -0700 (PDT)
Subject: Re: [PATCH net-next 0/2] dt-bindings: define property describing
 supported ethernet PHY modes
To:     =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org
Cc:     pali@kernel.org
References: <20210324103556.11338-1-kabel@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e4e088a4-1538-1e7d-241d-e43b69742811@gmail.com>
Date:   Wed, 24 Mar 2021 14:19:28 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210324103556.11338-1-kabel@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/24/2021 3:35 AM, Marek Behún wrote:
> Hello,
> 
> the Marvell Alaska PHYs (88X3310, 88E2110) can, depending on their
> configuration, change the PHY mode to the MAC, depending on the
> copper/fiber speed.
> 
> The 88X3310, for example, can be configured (via MACTYPE register)
> so that it communicates with the MAC in sgmii for 10/100/1000mbps,
> 2500base-x for 2500mbps, 5gbase-r for 5gbps and either 10gbase-r,
> xaui or rxaui for 10gbps. Or the PHY may communicate with the MAC
> in usxgmii, or one of the 10gbase-r, rxaui or xaui modes with rate
> matching.
> 
> So for the 10gbps mode we have options 10gbase-r, xaui, rxaui and
> usxgmii. The MAC can support some of these modes, and if it does more
> than one, we need to know which one to use. Not all of these modes
> must necessarily be supported by the board (xaui required wiring for
> 4 SerDes lanes, for example, and 10gbase-r requires wiring capable
> of transmitting at 10.3125 GBd).
> 
> The MACTYPE is upon HW reset configured by strapping pins - so the
> board should have a correct mode configured after HW reset.
> 
> One problem with this is that some boards configure the MACTYPE to
> a rate matching mode, which, according to the errata, is broken in
> some situations (it does not work for 10/100/1000, for example).
> 
> Another problem is that if lower modes are supported, we should
> maybe use them in order to save power.

That is an interesting proposal but if you want it to be truly valuable,
does not that mean that an user ought to be able to switch between any
of the supported PHY <=> MAC interfaces at runtime, and then within
those interfaces to the speeds that yield the best power savings?

> 
> But for this we need to know which phy-modes are supported on the
> board.
> 
> This series adds documentation for a new ethernet PHY property,
> called `supported-mac-connection-types`.

That naming does not quite make sense to me, if we want to describe the
MAC supported connection types, then those would naturally be within the
Ethernet MAC Device Tree node, no? If we are describing what the PHY is
capable, then we should be dropping "mac" from the property name not to
create confusion.

> 
> When this property is present for a PHY node, only the phy-modes
> listed in this property should be considered to be functional on
> the board.

Can you post the code that is going to utilize these properties so we
have a clearer picture of how and what you need to solve?

> 
> The second patch adds binding for this property.
> 
> The first patch does some YAML magic in ethernet-controller.yaml
> in order to be able to reuse the PHY modes enum, so that the same
> list does not have to be defined twice.
> 
> Marek
> 
> Marek Behún (2):
>   dt-bindings: ethernet-controller: create a type for PHY interface
>     modes
>   dt-bindings: ethernet-phy: define `supported-mac-connection-types`
>     property
> 
>  .../bindings/net/ethernet-controller.yaml     | 89 ++++++++++---------
>  .../devicetree/bindings/net/ethernet-phy.yaml | 18 ++++
>  2 files changed, 66 insertions(+), 41 deletions(-)
> 

-- 
Florian
