Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70BCD616A45
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 18:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbiKBRNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 13:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbiKBRNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 13:13:38 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E2D51DF3C;
        Wed,  2 Nov 2022 10:13:37 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D068022AF9;
        Wed,  2 Nov 2022 17:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1667409215; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FjC+X+IGjVIQCN9uPjsHYAeg5Fp899IsmxwXbW3ArI4=;
        b=EbfWZ5Ab0gfFfbSBI0QUXUrVicapq9089Yr2aPJG9yILWhz4bPAs7Hk2AhP3GF/YbCLwGP
        Z5wg2sqGnniUp/+GuE8yHePIQbQRDqzhjQRth8zYBED/52vrIpTv+vfIT7YGpcCd88zeLD
        xCBURvWdi3uVVF2GPCTj3HTfjoPT2vw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1667409215;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FjC+X+IGjVIQCN9uPjsHYAeg5Fp899IsmxwXbW3ArI4=;
        b=mdwAzgOj/hjLJzRWy7/A+VPgcC2iH8jTbPKjcSx6lAhkQVxtuHVoPT3h+0wvSSrKrwsFym
        /IiOyLGTMamyQ4BQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7A3A513AE0;
        Wed,  2 Nov 2022 17:13:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id bNdiHD+lYmPaOQAAMHmgww
        (envelope-from <afaerber@suse.de>); Wed, 02 Nov 2022 17:13:35 +0000
Message-ID: <2a7ebef4-77cc-1c26-ec6d-86db5ee5a94b@suse.de>
Date:   Wed, 2 Nov 2022 18:13:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 2/5] dt-bindings: net: add schema for NXP S32CC dwmac glue
 driver
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>, Chester Lin <clin@suse.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jan Petrous <jan.petrous@nxp.com>, netdev@vger.kernel.org,
        s32@nxp.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Matthias Brugger <mbrugger@suse.com>
References: <20221031101052.14956-1-clin@suse.com>
 <20221031101052.14956-3-clin@suse.com>
 <20221102155515.GA3959603-robh@kernel.org>
From:   =?UTF-8?Q?Andreas_F=c3=a4rber?= <afaerber@suse.de>
Organization: SUSE Software Solutions Germany GmbH
In-Reply-To: <20221102155515.GA3959603-robh@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On 02.11.22 16:55, Rob Herring wrote:
> On Mon, Oct 31, 2022 at 06:10:49PM +0800, Chester Lin wrote:
>> Add the DT schema for the DWMAC Ethernet controller on NXP S32 Common
>> Chassis.
>>
>> Signed-off-by: Jan Petrous <jan.petrous@nxp.com>
>> Signed-off-by: Chester Lin <clin@suse.com>
>> ---
>>   .../bindings/net/nxp,s32cc-dwmac.yaml         | 145 ++++++++++++++++++
>>   1 file changed, 145 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml
>>
>> diff --git a/Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml b/Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml
>> new file mode 100644
>> index 000000000000..f6b8486f9d42
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml
>> @@ -0,0 +1,145 @@
>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> +# Copyright 2021-2022 NXP
>> +%YAML 1.2
>> +---
>> +$id: "http://devicetree.org/schemas/net/nxp,s32cc-dwmac.yaml#"
>> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
>> +
>> +title: NXP S32CC DWMAC Ethernet controller
>> +
>> +maintainers:
>> +  - Jan Petrous <jan.petrous@nxp.com>
>> +  - Chester Lin <clin@suse.com>
[...]
>> +properties:
>> +  compatible:
>> +    contains:
> 
> Drop 'contains'.
> 
>> +      enum:
>> +        - nxp,s32cc-dwmac

In the past you were adamant that we use concrete SoC-specific strings. 
Here that would mean s32g2 or s32g274 instead of s32cc (which aims to 
share with S32G3 IIUC).

[...]
>> +  clocks:
>> +    items:
>> +      - description: Main GMAC clock
>> +      - description: Peripheral registers clock
>> +      - description: Transmit SGMII clock
>> +      - description: Transmit RGMII clock
>> +      - description: Transmit RMII clock
>> +      - description: Transmit MII clock
>> +      - description: Receive SGMII clock
>> +      - description: Receive RGMII clock
>> +      - description: Receive RMII clock
>> +      - description: Receive MII clock
>> +      - description:
>> +          PTP reference clock. This clock is used for programming the
>> +          Timestamp Addend Register. If not passed then the system
>> +          clock will be used.
> 
> If optional, then you need 'minItems'.
[snip]

Do we have any precedence of bindings with *MII clocks like these?

AFAIU the reason there are so many here is that there are in fact 
physically just five, but different parent clock configurations that 
SCMI does not currently expose to Linux. Thus I was raising that we may 
want to extend the SCMI protocol with some SET_PARENT operation that 
could allow us to use less input clocks here, but obviously such a 
standardization process will take time...

What are your thoughts on how to best handle this here?

Not clear to me has been whether the PHY mode can be switched at runtime 
(like DPAA2 on Layerscape allows for SFPs) or whether this is fixed by 
board design. If the latter, the two out of six SCMI IDs could get 
selected in TF-A, to have only physical clocks here in the binding.

Regards,
Andreas

-- 
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany
GF: Ivo Totev, Andrew Myers, Andrew McDonald, Boudien Moerman
HRB 36809 (AG Nürnberg)

