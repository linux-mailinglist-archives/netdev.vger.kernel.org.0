Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5662A75DE
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 04:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388448AbgKEDDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 22:03:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729669AbgKEDDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 22:03:19 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D4BC0613CF;
        Wed,  4 Nov 2020 19:03:19 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id e7so196066pfn.12;
        Wed, 04 Nov 2020 19:03:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rqFSQ6ot3tici9BGFeRzqxwQhGWIWMLwTxPbfGjijXk=;
        b=BPtbsFVvEOpPYBu/LERKDIvUHmoBAzmRjYsL/tS1nNYkZg8rGMpYaVXLwPlr+MroaD
         Sepssjjo/wlun2gfn3kSA43k7k/MwOOR0wdO72tWmdaLjvZ5bBjz8LdbtItwAc7itKDQ
         LaJ4pShH566VhfzD6per0aaeXLuB94ge/ttqW8HN1GfclNugvPj3dV2D29A9Aiojy1D0
         DeD+zm6/FsGTBKvMA49GiOrMT3KV+7ieBZB8nG3y0XIZVpext2YADN752stXySGNfJRG
         iaClQ581rXL7Z2Vz44zlUuuekLN27hF4De54+pZJzCn4EijOEO0fcVJ0Il7WjkyU3cn5
         QLYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rqFSQ6ot3tici9BGFeRzqxwQhGWIWMLwTxPbfGjijXk=;
        b=VqNwUU4TIgkgoL57JANBsd+og/lgFkvOAfF2UVhqrNK+dsKEUfcHVdDe3YfALcd63Z
         uLTk6VoHjMcgNMQj/P77GzmNVDwb3Sfz+VwjNnpeR0nu95PgJZmHKtzFxpov/0sGEZoa
         r3+3Q06pJKOLrFV/T/EhY8F9OiV/DhLj+d6XO0pnbQU2FGJoSHEaL6ZtrZrmYdoRbkR7
         x+aMcuHV38oCSqhGfrxj6UQlNlgGVqGSp9WK0RGIjYbWp6uK4yY/6yrBxQN3H6FBFJqp
         p2RD4HM5ZgyR99HVTQlxcXPD+R2VEAPnYyWZElB93jmavse+LQBA1W3RaYNQ6mEB1R3H
         QVtg==
X-Gm-Message-State: AOAM531rtVtR0slHTSwMvuEyb6yC3qni5RgBTKn1e/5cRB5hETHmc8rS
        c/W6VrFdI/0vWKAeFRarx21sg+SPGuc=
X-Google-Smtp-Source: ABdhPJxSAfAtp7tfUeEQFfsJLevfSeMTq3MFHA+NJKqkpPsbvk4bowaBzLSSMk3Oj5v5XDqCSwKTaA==
X-Received: by 2002:a63:fc15:: with SMTP id j21mr422383pgi.258.1604545398144;
        Wed, 04 Nov 2020 19:03:18 -0800 (PST)
Received: from [10.230.28.234] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i6sm90005pjt.49.2020.11.04.19.03.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 19:03:17 -0800 (PST)
Subject: Re: [PATCH net-next v3 4/4] net: phy: dp83td510: Add support for the
 DP83TD510 Ethernet PHY
To:     Dan Murphy <dmurphy@ti.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, hkallweit1@gmail.com, robh@kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201030172950.12767-1-dmurphy@ti.com>
 <20201030172950.12767-5-dmurphy@ti.com> <20201030201515.GE1042051@lunn.ch>
 <202b6626-b7bf-3159-f474-56f6fa0c8247@ti.com>
 <20201103171838.GN1042051@lunn.ch>
 <f44af428-acd9-daef-3609-4d6ea24cd436@ti.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2513627e-42d4-88d5-c8fe-f4b90b1b56b5@gmail.com>
Date:   Wed, 4 Nov 2020 19:03:15 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <f44af428-acd9-daef-3609-4d6ea24cd436@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/3/2020 9:35 AM, Dan Murphy wrote:
> Andrew
> 
> On 11/3/20 11:18 AM, Andrew Lunn wrote:
>> On Tue, Nov 03, 2020 at 11:07:00AM -0600, Dan Murphy wrote:
>>> Andrew
>>>
>>> On 10/30/20 3:15 PM, Andrew Lunn wrote:
>>>>> +static int dp83td510_config_init(struct phy_device *phydev)
>>>>> +{
>>>>> +    struct dp83td510_private *dp83td510 = phydev->priv;
>>>>> +    int mst_slave_cfg;
>>>>> +    int ret = 0;
>>>>> +
>>>>> +    if (phy_interface_is_rgmii(phydev)) {
>>>>> +        if (dp83td510->rgmii_delay) {
>>>>> +            ret = phy_set_bits_mmd(phydev, DP83TD510_DEVADDR,
>>>>> +                           DP83TD510_MAC_CFG_1,
>>>>> dp83td510->rgmii_delay);
>>>>> +            if (ret)
>>>>> +                return ret;
>>>>> +        }
>>>>> +    }
>>>> Hi Dan
>>>>
>>>> I'm getting a bit paranoid about RGMII delays...
>>> Not sure what this means.
>> See the discussion and breakage around the realtek PHY. It wrongly
>> implemented RGMII delays. When it was fixed, lots of board broke
>> because the bug in the PHY driver hid bugs in the DT.
>>
> I will have to go find that thread. Do you have a link?

That would be the thread:

https://lore.kernel.org/netdev/CAMj1kXEEF_Un-4NTaD5iUN0NoZYaJQn-rPediX0S6oRiuVuW-A@mail.gmail.com/
-- 
Florian
