Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2C166DA10F
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 21:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240212AbjDFTXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 15:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240205AbjDFTXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 15:23:53 -0400
Received: from sender3-op-o19.zoho.com (sender3-op-o19.zoho.com [136.143.184.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9D661AC;
        Thu,  6 Apr 2023 12:23:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1680809003; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=hYBOG+y/5rMK2lctWKFmWUBjL2d5tYyfVSmTy4KefCPkvjyQZqPkt8QZykIBPpFdCc5WbR6kbNn/h3vafI4gF+BuGsN0A7YteqSjiqNGbvrHToxVoCZzIVnt9Wxh/lfY0ZQNi/nmkF9qHpWUk5D6yRagneJ9+p5bkq3OB0oeyBs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1680809003; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=LwgiuEaZIlD8XunLUQ5/YjDJuNsb06sdZkJZhpcL7eU=; 
        b=VfcT1WCQM/FeGMyK95ctSGgql9oNLSs/e6p5+a+OAlXNv/p70BXqkxsGnTJk5Rgh9+Qv22AmWxqVOfnE6bXs0yLCq7R3cuGoccBj0BMxG0+duaOEeHOQlK7Ps4db3oV2SZAEOVuteFVY2MBE41dUs9FbesgfhUPPinIwec/Tfwg=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1680809003;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=LwgiuEaZIlD8XunLUQ5/YjDJuNsb06sdZkJZhpcL7eU=;
        b=UOp7eTX4Qus9073eY8AFx6SORU3GEdQPAdiC6Fj/Em2q50+Hx/oJ7fzaHFiFpoec
        MjA6ZS1SOYO77+W7R/J4YLff8FG5wur1o6g5rP6+TeHav1AP7Bz6VzLrXUPJRdoYxJy
        34pvPWu2LBdyri7OBS7q+eumPrRDxmSP4QkghehQ=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1680809001550322.06011498171586; Thu, 6 Apr 2023 12:23:21 -0700 (PDT)
Message-ID: <fc5c1f34-632e-57d0-233d-806484a9ec9c@arinc9.com>
Date:   Thu, 6 Apr 2023 22:23:15 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 1/7] dt-bindings: net: dsa: mediatek,mt7530: correct brand
 name
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
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
        Sean Wang <sean.wang@mediatek.com>
Cc:     erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20230406080141.22924-1-arinc.unal@arinc9.com>
 <678d5752-b5c8-dd21-9e43-68f4d4e674ee@linaro.org>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <678d5752-b5c8-dd21-9e43-68f4d4e674ee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6.04.2023 22:00, Krzysztof Kozlowski wrote:
> On 06/04/2023 10:01, arinc9.unal@gmail.com wrote:
>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>
>> The brand name is MediaTek, change it to that.
>>
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> ---
>>   Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml | 2 +-
> 
> 
> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> although maybe this would be a lot of churn if done per-file.

I don't intend to. There's only this schema of MediaTek for DSA, and I 
happen to maintain it. Maybe I can do a treewide change for other 
schemas in the future.

Arınç
