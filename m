Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09E016DF3DD
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 13:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbjDLLia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 07:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbjDLLi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 07:38:28 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9796B2D40;
        Wed, 12 Apr 2023 04:38:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1681299399; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=bBb4ZTlMVpRQpivX9ADQHKCw2VmucU7xmleAnUUP8updopzcDhO2VFlK0fVTmHPiiFoDNElWVctPLmonqjzdv7Z2J5j2PqExUX7QY31SdDay+vwcXjE384Wo0EByXHJfpG2cMya6IdCE6+tMEduDDok5i7vXLH9LL9fDKPwsUJs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1681299399; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=Ph1dIO4cwj22wpIxrJFBcvT3j+2Yf11B9FPaEwiEhDc=; 
        b=AXiM6KtRA6GZRB+qVE/02K3qs1QokGpchV3576Q6MONvTa4qCFjGjOsbc7tJZSSgC9m3d/G9H+oGfHtpqT2a40wdEBqc4rkd+JOQKNVq/sgYzmsWITWzsA8RquqJRnI0l9JFGlewmNfqNkytfPYCfxbnmx1TFnT+80tSkLiOnxg=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1681299399;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=Ph1dIO4cwj22wpIxrJFBcvT3j+2Yf11B9FPaEwiEhDc=;
        b=AshnBTcW5kSl0cdnvBPvzUQpW83opXR8d/MIyGhI+VWkQnDa6KLEIhPPNUW1n9Qp
        NylHrzQM0SFennaIuMI2Fh0VTzh11z49Hd4HSdZTEaGFeDPP4OZiK+mEjfPqHeKudpK
        4vWHyVgG5Jw09snW/xElmtgeHSOJBM9+1ZdxX8CM=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1681299397239505.78934446856533; Wed, 12 Apr 2023 04:36:37 -0700 (PDT)
Message-ID: <5068c00b-4bf8-0b05-9c26-eb96fb08b401@arinc9.com>
Date:   Wed, 12 Apr 2023 14:36:29 +0300
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
 <80d4a841-db7c-fa2b-e50d-84317ee54a40@arinc9.com>
 <20230412111752.bl2ekd7pirbyvnue@skbuf>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230412111752.bl2ekd7pirbyvnue@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.04.2023 14:17, Vladimir Oltean wrote:
> On Wed, Apr 12, 2023 at 09:36:32AM +0300, Arınç ÜNAL wrote:
>> On 12.04.2023 02:57, Vladimir Oltean wrote:
>>> Hi Arınç,
>>>
>>> On Fri, Apr 07, 2023 at 03:50:03PM +0300, arinc9.unal@gmail.com wrote:
>>>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>>>
>>>> The brand name is MediaTek, change it to that.
>>>>
>>>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>>>> Acked-by: Daniel Golle <daniel@makrotopia.org>
>>>> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>>>> ---
>>>
>>> It is good practice for series larger than 2 patches to create a cover
>>> letter, which gives the overview for the changes. Its contents gets used
>>> as the merge commit description when the series is accepted.
>>
>> Ok, will do on the next version. I'll also split the schema while at it.
> 
> Ok. I wasn't sure if you and Krzysztof were in agreement about that, so
> this is why I didn't mention it. FWIW, it's also pretty unreviewable to
> me too.

I already agreed but was planning to do that later. I prefer to divide 
things into smaller parts so I improve progressively without being 
overwhelmed. My RFC series for this driver along with this series are 
growing which has become a bit overwhelming but I'll manage.

Arınç
