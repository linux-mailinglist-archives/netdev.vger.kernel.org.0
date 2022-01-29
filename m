Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8954A318C
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 20:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353054AbiA2TgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 14:36:14 -0500
Received: from sender4-op-o14.zoho.com ([136.143.188.14]:17440 "EHLO
        sender4-op-o14.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234299AbiA2TgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 14:36:14 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1643484952; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=OdKWt5SRXmNnPSyXvJFEBYe8AWD6rzOSMvgoVygHf0OLvOzpjh3DmG3OTQRTSg1Kicu25SIwA4YnWYOrlDBxPH3HtMib8V8Zo/QEiNp0IQrVSouMMmQ+f+LW7qiM0o+QwWZpU8W+xSTjaTAHw8aBVfDJ0l9z4tqbQpV0XAX2pJw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1643484952; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=N1Hwv51BAqhdf7aViF596fnwYG+Of4tumhKRqgfnAFM=; 
        b=QKUkkfo+2b6H5iOzRpUxDTZu/zZ4LXT8frDJYy8AbkYg/d686S5PVZUaji9H9kQAFk5q2WPj/PVI5FAiPCuE7B09hDZmQKZniq4oNptRCp8AIA/7AeenOvigyssC2bxIVbu08L8lNiyX6GxdL1EcMJCoZWOxmeq4CWlLkVG4riE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1643484952;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=N1Hwv51BAqhdf7aViF596fnwYG+Of4tumhKRqgfnAFM=;
        b=WU+ECRjplC/9M9DKcO3Pi8iCPUvPsJpW3XwNjwzg7+CG1qJfC04XEtbvwBjtqFRv
        RozfjtxwpIiUAa3krJmBQCJPIseNQAGu+vSBG3+R7gbg7wBUl5aiHOw44CFpaiPxGHo
        fRiLJyEZqrDHm7LbG9XcRN1mNpTEFkVKA4+wjp/s=
Received: from [10.10.10.216] (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1643484949668213.43406706806388; Sat, 29 Jan 2022 11:35:49 -0800 (PST)
Message-ID: <7d6231f1-a45d-f53e-77d9-3e8425996662@arinc9.com>
Date:   Sat, 29 Jan 2022 22:35:39 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] dt-bindings: net: dsa: realtek-smi: convert to YAML
 schema
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Rob Herring <robh@kernel.org>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <ALSI@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20211228072645.32341-1-luizluca@gmail.com>
 <Ydx4+o5TsWZkZd45@robh.at.kernel.org>
 <CAJq09z4G40ttsTHXtOywjyusNLSjt_BQ9D78PhwSodJr=4p6OA@mail.gmail.com>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <CAJq09z4G40ttsTHXtOywjyusNLSjt_BQ9D78PhwSodJr=4p6OA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/01/2022 19:02, Luiz Angelo Daros de Luca wrote:
> Thanks Rob, now that the code side is merged, I'm back to docs.
> 
> 
>>> +      interrupt-controller:
>>> +        description: see interrupt-controller/interrupts.txt
>>
>> Don't need generic descriptions. Just 'true' here is fine.
> 
> Do you really mean quoted true, like in "description: 'true' "?
> Without quotes it will fail
>>
>>> +
>>> +      interrupts:
>>> +        description: TODO
>>
>> You have to define how many interrupts and what they are.
> 
> I didn't write the interruption code and Linus and Alvin might help here.
> 
> The switch has a single interrupt pin that signals an interruption happened.
> The code reads a register to multiplex to these interruptions:
> 
> INT_TYPE_LINK_STATUS = 0,
> INT_TYPE_METER_EXCEED,
> INT_TYPE_LEARN_LIMIT,
> INT_TYPE_LINK_SPEED,
> INT_TYPE_CONGEST,
> INT_TYPE_GREEN_FEATURE,
> INT_TYPE_LOOP_DETECT,
> INT_TYPE_8051,
> INT_TYPE_CABLE_DIAG,
> INT_TYPE_ACL,
> INT_TYPE_RESERVED, /* Unused */
> INT_TYPE_SLIENT,
> 
> And most of them, but not all, multiplex again to each port.
> 
> However, the linux driver today does not care about any of these
> interruptions but INT_TYPE_LINK_STATUS. So it simply multiplex only
> this the interruption to each port, in a n-cell map (n being number of
> ports).
> I don't know what to describe here as device-tree should be something
> independent of a particular OS or driver.
> 
> Anyway, I doubt someone might want to plug one of these interruptions
> outside the switch driver. Could it be simple as this:
> 
>        interrupts:
>         minItems: 3
>         maxItems: 10
>         description:
>           interrupt mapping one per switch port
> 
> Once realtek-smi.yaml settles, I'll also send the realtek-mdio.yaml.

Why not turn realtek-smi.yaml into realtek.yaml which would also contain 
information for the mdio interface? The things different with using MDIO 
are that we don't use the [mdc,mdio,reset]-gpios properties and don't 
handle the PHYs to the DSA ports. Couldn't you present these differences 
on a single YAML file?

Arınç
