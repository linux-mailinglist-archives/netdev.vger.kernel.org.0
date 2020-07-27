Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7108222F96F
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 21:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728990AbgG0Tru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 15:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728721AbgG0Trt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 15:47:49 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2FE7C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 12:47:48 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id r2so10962035wrs.8
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 12:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TMlqHCkKR4O7qkPN7IKluzEnX9tBrwy3a1xhh+i0Dp8=;
        b=RJlnEx58mcuddipFVj3RjfrLn/yLsI1fq/XYYTc1Lj+N1LDq2xEnkBQgGwBdSoVoh1
         EwiheIoNYvxzeUooK+6p27DOURiKbSx8eTVNgO06TxO/71Tc5raLtwmgjyDIU8F2HE2t
         elMxHG2K+vPIfPBecETuPL1QaO6K5zur7Ton1RJE6O2F9P7BimRQmRnfHIr5AOFFp2J2
         Lj3qwTCZz5HqM1qv3AQxVXYNvEKZ+6TZOLAK9Y+9j4ANPfhnAjWA7SPR3Zo0gOF4yaGj
         q0oitZtP7N+JdOl557ZbAIruYpcY2xdYqhuj2gwYXl4wE0/J+k2iuZ+EuFgVeApKEKGk
         nbpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=TMlqHCkKR4O7qkPN7IKluzEnX9tBrwy3a1xhh+i0Dp8=;
        b=JaOOiz+2VQhelHU3kfP9DHACKioS8Gl/KBdVHGzbgjDHnI8R3wOoG2Ie6//VVmnI76
         w5UPJVvZXiX3C6oTEh/AFlo5CphzmnpGzSBYLzNlP/x3+D8ZrDTeiYe3UkORFLgpWRH6
         r/2ZLO1GTpgEtae90cCHzQrsLxa2paeIDhkbA+qdmcKXQvg3EEi4vTLyM3xNtG8vufG+
         yxI48ieGgGR2DjSLIZq/npRNLqShal2qdOXBEVL1V8Epd1FckflMNPXm6Y2PPnzMOQML
         Ck9rjimzRnE+tRKI6KXt983TcKVC0LLWsD7LZqK82RGeWH56mlOkx2GVia5cFrSmFMEi
         NsAQ==
X-Gm-Message-State: AOAM531JF0TN6EvofwVEr5T3w6OY5RQmkjktSUD7kxOMcI8vweNYIPZz
        OfgiqCXGTb4RlY2l4DU8zbC8Rq58
X-Google-Smtp-Source: ABdhPJz6A/3RUCAJ2cRXL3PL6hp1Y43tTEdcQRSaWdq5jJoXuEERryG0r1ASIZp24BRPGaPnv5a3xg==
X-Received: by 2002:a5d:6cce:: with SMTP id c14mr20779231wrc.377.1595879267187;
        Mon, 27 Jul 2020 12:47:47 -0700 (PDT)
Received: from [10.67.50.75] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y11sm14464195wrs.80.2020.07.27.12.47.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2020 12:47:46 -0700 (PDT)
Subject: Re: [PATCH net-next v4 0/5] net: phy: add Lynx PCS MDIO module
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "olteanv@gmail.com" <olteanv@gmail.com>
References: <20200724080143.12909-1-ioana.ciornei@nxp.com>
 <400c65b5-718e-64f5-a2a2-3b26108a93d5@gmail.com>
 <VI1PR0402MB387150745E6EB735F5A4D538E0720@VI1PR0402MB3871.eurprd04.prod.outlook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <6b3b9150-db4f-ae5e-90e1-96004ac46487@gmail.com>
Date:   Mon, 27 Jul 2020 12:47:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <VI1PR0402MB387150745E6EB735F5A4D538E0720@VI1PR0402MB3871.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/20 11:48 AM, Ioana Ciornei wrote:
>> Subject: Re: [PATCH net-next v4 0/5] net: phy: add Lynx PCS MDIO module
>>
>>
>>
>> On 7/24/2020 1:01 AM, Ioana Ciornei wrote:
>>> Add support for the Lynx PCS as a separate module in drivers/net/phy/.
>>> The advantage of this structure is that multiple ethernet or switch
>>> drivers used on NXP hardware (ENETC, Seville, Felix DSA switch etc)
>>> can share the same implementation of PCS configuration and runtime
>>> management.
>>>
>>> The module implements phylink_pcs_ops and exports a phylink_pcs
>>> (incorporated into a lynx_pcs) which can be directly passed to phylink
>>> through phylink_pcs_set.
>>>
>>> The first 3 patches add some missing pieces in phylink and the locked
>>> mdiobus write accessor. Next, the Lynx PCS MDIO module is added as a
>>> standalone module. The majority of the code is extracted from the
>>> Felix DSA driver. The last patch makes the necessary changes in the
>>> Felix and Seville drivers in order to use the new common PCS implementation.
>>>
>>> At the moment, USXGMII (only with in-band AN), SGMII, QSGMII (with and
>>> without in-band AN) and 2500Base-X (only w/o in-band AN) are supported
>>> by the Lynx PCS MDIO module since these were also supported by Felix
>>> and no functional change is intended at this time.
>>>
>>> Changes in v2:
>>>  * got rid of the mdio_lynx_pcs structure and directly exported the
>>> functions without the need of an indirection
>>>  * made the necessary adjustments for this in the Felix DSA driver
>>>  * solved the broken allmodconfig build test by making the module
>>> tristate instead of bool
>>>  * fixed a memory leakage in the Felix driver (the pcs structure was
>>> allocated twice)
>>>
>>> Changes in v3:
>>>  * added support for PHYLINK PCS ops in DSA (patch 5/9)
>>>  * cleanup in Felix PHYLINK operations and migrate to
>>>  phylink_mac_link_up() being the callback of choice for applying MAC
>>> configuration (patches 6-8)
>>>
>>> Changes in v4:
>>>  * use the newly introduced phylink PCS mechanism
>>>  * install the phylink_pcs in the phylink_mac_config DSA ops
>>>  * remove the direct implementations of the PCS ops
>>>  * do no use the SGMII_ prefix when referring to the IF_MORE register
>>>  * add a phylink helper to decode the USXGMII code word
>>>  * remove cleanup patches for Felix (these have been already accepted)
>>>  * Seville (recently introduced) now has PCS support through the same
>>> Lynx PCS module
>>>
>>> Ioana Ciornei (5):
>>>   net: phylink: add helper function to decode USXGMII word
>>>   net: phylink: consider QSGMII interface mode in
>>>     phylink_mii_c22_pcs_get_state
>>>   net: mdiobus: add clause 45 mdiobus write accessor
>>>   net: phy: add Lynx PCS module
>>>   net: dsa: ocelot: use the Lynx PCS helpers in Felix and Seville
>>>
>>>  MAINTAINERS                              |   7 +
>>>  drivers/net/dsa/ocelot/Kconfig           |   1 +
>>>  drivers/net/dsa/ocelot/felix.c           |  28 +-
>>>  drivers/net/dsa/ocelot/felix.h           |  20 +-
>>>  drivers/net/dsa/ocelot/felix_vsc9959.c   | 374 ++---------------------
>>>  drivers/net/dsa/ocelot/seville_vsc9953.c |  21 +-
>>>  drivers/net/phy/Kconfig                  |   6 +
>>>  drivers/net/phy/Makefile                 |   1 +
>>>  drivers/net/phy/pcs-lynx.c               | 314 +++++++++++++++++++
>>
>> I believe Andrew had a plan to create a better organization within
>> drivers/net/phy, while this happens, maybe you can already create
>> drivers/net/phy/pcs/ regardless of the state of Andrew's work?
>>
> 
> I got the impression from Andrew that the plan was to do this at a later stage
> together with the Synopsys XPCS. I could certainly do what you say, I am just
> not very keen to add such things into this patch set. 

Andrew, what directory structure do you have in mind such that Ioana can
already start putting the PCS drivers in the right location?
-- 
Florian
