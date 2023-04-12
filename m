Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 254CE6DEBE0
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 08:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjDLGhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 02:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDLGhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 02:37:19 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F9B23ABC;
        Tue, 11 Apr 2023 23:37:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1681281401; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=MPx172HnOIejQDyL0d/0DUdOEHO0rjgD6Oa6glZ3HE1iJOzYBJScCGQwiUPBWcUfB7qTQ1oWbuOxkpSrSKivIIeG4C7/KvdrHEPIK38DvN3oDFTKMZMuGsBwVOdYHx7ZmdUQfqJfsbwG1d3DuNlDRsdUCWZf448dtEaqOpj7yzc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1681281401; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=2CUzAZVNmhEddWbv5po9+adEHLn5WWCOxoPTdFXS6l4=; 
        b=hO8QKIOywiaIoS0G/klCObI81udy+loHkZMRlNb27Q2pVFh1KmoK4BC4D+kD3tApqyntKxoFc6u297ewZkyN8roixqL5TpQ9MzCzXJVxyVfb9sGa8Jm+hSwIvRwJqWT+e02yoO7HvbckJ/UM4c0MqgRGdjbrag1pegsgCOE71BM=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1681281401;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=2CUzAZVNmhEddWbv5po9+adEHLn5WWCOxoPTdFXS6l4=;
        b=HU8zdvcDb/wiOXq/4JV9AcKkkkg4J778VwuzUb1bK4CSUeyllHOJNYeeW2jEJaRC
        /2hett5Z85bMYasKfsrUdc30njoAPbVB9V0huiyEOkqkuXlfCqRPQO1XJvm3hckcxtI
        w2jmcP4gc7nUSenhjPrSN092MUzCsPvyDKyemgjU=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1681281399656135.19981499513426; Tue, 11 Apr 2023 23:36:39 -0700 (PDT)
Message-ID: <80d4a841-db7c-fa2b-e50d-84317ee54a40@arinc9.com>
Date:   Wed, 12 Apr 2023 09:36:32 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v2 1/7] dt-bindings: net: dsa: mediatek,mt7530: correct
 brand name
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20230407125008.42474-1-arinc.unal@arinc9.com>
 <20230411235749.xbghzt7w77swvhnz@skbuf>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230411235749.xbghzt7w77swvhnz@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.04.2023 02:57, Vladimir Oltean wrote:
> Hi Arınç,
> 
> On Fri, Apr 07, 2023 at 03:50:03PM +0300, arinc9.unal@gmail.com wrote:
>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>
>> The brand name is MediaTek, change it to that.
>>
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> Acked-by: Daniel Golle <daniel@makrotopia.org>
>> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>> ---
> 
> It is good practice for series larger than 2 patches to create a cover
> letter, which gives the overview for the changes. Its contents gets used
> as the merge commit description when the series is accepted.

Ok, will do on the next version. I'll also split the schema while at it.

Arınç
