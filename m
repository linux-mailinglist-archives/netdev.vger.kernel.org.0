Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1EDA4F914A
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 11:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbiDHJFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 05:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiDHJFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 05:05:33 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F91B31;
        Fri,  8 Apr 2022 02:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3rpjg5Y91rJlgDeWKeNVL63VHsFaTGQWttlj6s5sV2o=; b=ZsyVXJW+qTz67jq5E82oaR2nXo
        br8DmLPxSWOXp1ShbvI27ilcs3GA+JvX9nwaCn8CJDYZPGQ89l6WuepFWpVhgbEXqEF4a/RAKA5iM
        AO7Q+q5Siwb2UJWR3JINtlxjWqZ0BcJEYhvOcTqD0XloVc/cZYtZyl2FYkb9+KBwAwhY=;
Received: from p200300daa70ef200411eb61494300c34.dip0.t-ipconnect.de ([2003:da:a70e:f200:411e:b614:9430:c34] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1nckWR-0004kO-B0; Fri, 08 Apr 2022 11:03:15 +0200
Message-ID: <96bdfd6b-4c22-9a32-48b4-1d2cc8a16119@nbd.name>
Date:   Fri, 8 Apr 2022 11:03:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v2 05/14] dt-bindings: arm: mediatek: document the pcie
 mirror node on MT7622
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>
Cc:     netdev@vger.kernel.org, Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20220405195755.10817-1-nbd@nbd.name>
 <20220405195755.10817-6-nbd@nbd.name> <Yk8dHLDG8EHKtl54@robh.at.kernel.org>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <Yk8dHLDG8EHKtl54@robh.at.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.04.22 19:19, Rob Herring wrote:
> On Tue, Apr 05, 2022 at 09:57:46PM +0200, Felix Fietkau wrote:
>> From: Lorenzo Bianconi <lorenzo@kernel.org>
>> 
>> This patch adds the pcie mirror document bindings for MT7622 SoC.
>> The feature is used for intercepting PCIe MMIO access for the WED core
>> Add related info in mediatek-net bindings.
>> 
>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
>> ---
>>  .../mediatek/mediatek,mt7622-pcie-mirror.yaml | 42 +++++++++++++++++++
>>  .../devicetree/bindings/net/mediatek-net.txt  |  2 +
>>  2 files changed, 44 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-pcie-mirror.yaml
>> 
>> diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-pcie-mirror.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-pcie-mirror.yaml
>> new file mode 100644
>> index 000000000000..9fbeb626ab23
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-pcie-mirror.yaml
>> @@ -0,0 +1,42 @@
>> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
>> +%YAML 1.2
>> +---
>> +$id: "http://devicetree.org/schemas/arm/mediatek/mediatek,mt7622-pcie-mirror.yaml#"
>> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
>> +
>> +title: MediaTek PCIE Mirror Controller for MT7622
>> +
>> +maintainers:
>> +  - Lorenzo Bianconi <lorenzo@kernel.org>
>> +  - Felix Fietkau <nbd@nbd.name>
>> +
>> +description:
>> +  The mediatek PCIE mirror provides a configuration interface for PCIE
>> +  controller on MT7622 soc.
>> +
>> +properties:
>> +  compatible:
>> +    items:
>> +      - enum:
>> +          - mediatek,mt7622-pcie-mirror
>> +      - const: syscon
> 
> This doesn't sound like a syscon to me. Are there multiple clients or
> functions in this block? A 'syscon' property is not the only way to
> create a regmap if that's what you need.
It's used only by the WED code in the ethernet driver, but there are 
multiple WED instances and only a single pcie-mirror block containing 
configuration for them.

- Felix
