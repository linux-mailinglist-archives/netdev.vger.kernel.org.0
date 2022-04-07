Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6C744F8640
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 19:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346372AbiDGRdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 13:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346870AbiDGRdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 13:33:01 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49CE518B24;
        Thu,  7 Apr 2022 10:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=i5967/a5oK0EGt/wrkemwwnhICguU6R5xviUzoKD7O8=; b=pOhYtIBmMilhtrc+5FBGc4SuH8
        YuC62mIwfZJzk3lKGHpaGHkD407+t2JCSVto8KRmiOVP+nZz4lGVAEL50VrfqVyNts7Y4EHQVhuXu
        fIONIhWZ41KxsGfZXDZ7xOrgna5/0lDeoPJIrBN+LEsIhd6nYvlU7q51Zv26NlWvW2j8=;
Received: from p200300daa70ef200411eb61494300c34.dip0.t-ipconnect.de ([2003:da:a70e:f200:411e:b614:9430:c34] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1ncVxI-0007Or-HM; Thu, 07 Apr 2022 19:30:00 +0200
Message-ID: <f9d76e22-0400-24fa-e4c4-af4b03ed5f8f@nbd.name>
Date:   Thu, 7 Apr 2022 19:29:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v2 05/14] dt-bindings: arm: mediatek: document the pcie
 mirror node on MT7622
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        netdev@vger.kernel.org, Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20220405195755.10817-1-nbd@nbd.name>
 <20220405195755.10817-6-nbd@nbd.name>
 <4bafe244-6a3d-d0ec-59d3-3f3f00e71caf@linaro.org>
 <318163cb-c771-c7eb-73ba-35c66f7d0e68@nbd.name>
 <Yk8chzNBsRZR8e1q@robh.at.kernel.org>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <Yk8chzNBsRZR8e1q@robh.at.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 07.04.22 19:16, Rob Herring wrote:
> On Wed, Apr 06, 2022 at 01:01:06PM +0200, Felix Fietkau wrote:
>> 
>> On 06.04.22 10:20, Krzysztof Kozlowski wrote:
>> > On 05/04/2022 21:57, Felix Fietkau wrote:
>> > > From: Lorenzo Bianconi <lorenzo@kernel.org>
>> > > 
>> > > This patch adds the pcie mirror document bindings for MT7622 SoC.
>> > > The feature is used for intercepting PCIe MMIO access for the WED core
>> > > Add related info in mediatek-net bindings.
>> > > 
>> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>> > > Signed-off-by: Felix Fietkau <nbd@nbd.name>
>> > > ---
>> > >  .../mediatek/mediatek,mt7622-pcie-mirror.yaml | 42 +++++++++++++++++++
>> > 
>> > Eh, I wanted to ask to not put it inside arm/, but judging by your usage
>> > - you did not create drivers for both of these (WED and PCIe mirror).
>> > 
>> > You only need them to expose address spaces via syscon.
>> > 
>> > This actually looks hacky. Either WED and PCIe mirror are part of
>> > network driver, then add the address spaces via "reg". If they are not,
>> > but instead they are separate blocks, why you don't have drivers for them?
>> The code that uses the WED block is built into the Ethernet driver, but not
>> all SoCs that use this ethernet core have it. Also, there are two WED
>> blocks, and I'm not sure if future SoCs might have a different number of
>> them at some point.
>> The WED code also needs to access registers of the ethernet MAC.
>> One reason for having a separate device is this:
>> As long as WED is not in use, ethernet supports coherent DMA for increased
>> performance. When the first wireless device attaches to WED, IO coherency
>> gets disabled and the ethernet DMA rings are cleaned up and allocated again,
>> this time with the struct device of WED (which doesn't have the dma-coherent
>> property).
> 
> I'm pretty sure there are assumptions in the driver core that coherency
> is not changing on the fly. In any case, if it is, using 'dma-coherent'
> is not appropriate. You obviously have another method to determine
> whether you are coherent or not.
It's not really on the fly. Before changing coherency, all DMA memory is 
freed, and the subsequent reallocation uses the struct device of the WED 
core, which does not have the dma-coherent property.

- Felix
