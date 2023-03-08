Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8456B03DC
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 11:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbjCHKT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 05:19:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjCHKT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 05:19:27 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC1AB56CA;
        Wed,  8 Mar 2023 02:19:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D5A17CE1DD6;
        Wed,  8 Mar 2023 10:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4735C433D2;
        Wed,  8 Mar 2023 10:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678270762;
        bh=Ob+lu1qQhXoEH25djK2FMi1VVG6RVBjRQTT/sdM/lGY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=OEWbNQ3BHb+kJ4YYZolbRKZk4qlKx9Ej6bKg2b4P/M9GUSyEno+ILnFQfggChTxqw
         8HF1RVNWE8WQGKN5koC4IcOqK4fLt9oGTQqgHw/CXjfA128vZYVB3EI3X3x3XCPLdK
         i8ZgDuoOTcXPuaIQPn0Rw864RUV90SNz/c3g2BankwO3N4K4CQw3RGQNi3fygeamgt
         nPficzhWRc68Qoq/UXRFTFC+Z1Kcsfm5nj58v80Pgo+J5ltMEoJoKDIpvGVOI2abYZ
         cKofpiXgA2M8C8NZ50rLRqN7001z2fgjG0rokVkB/BYHN6QW6bMchnOoPCLjIgVkS5
         IuFnRUftbQUzA==
Message-ID: <ffb526e4-623b-e87d-ac64-87c373ce36fb@kernel.org>
Date:   Wed, 8 Mar 2023 11:19:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2 2/2] dt-bindings: net: adin: Document bindings for fast
 link down disable
Content-Language: en-US
To:     Ken Sloat <ken.s@variscite.com>
Cc:     "noname.nuno@gmail.com" <noname.nuno@gmail.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230228144056.2246114-1-ken.s@variscite.com>
 <20230228184956.2309584-1-ken.s@variscite.com>
 <20230228184956.2309584-2-ken.s@variscite.com>
 <9a540967-c1a6-b9df-a662-b8a729d7d64b@kernel.org>
 <DU0PR08MB9003C9BD97B4055BE1EEDB0CECB79@DU0PR08MB9003.eurprd08.prod.outlook.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
In-Reply-To: <DU0PR08MB9003C9BD97B4055BE1EEDB0CECB79@DU0PR08MB9003.eurprd08.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/03/2023 19:19, Ken Sloat wrote:
>>> Document the new optional flags "adi,disable-fast-down-1000base-t" and
>>> "adi,disable-fast-down-100base-tx" which disable the "Fast Link Down"
>>> feature in the ADI PHY.
>>
>> You did not explain why do you need it.
> 
> My thoughts were this was explained in the feature patch and so was redundant here which is why I gave a brief summary, but if the norm is to duplicate this information I can certainly do that.

At least something should be here. Bindings are separate from Linux, so
the commit should stand on its own.

>>>      description: Enable 25MHz reference clock output on CLK25_REF pin.
>>>      type: boolean
>>>
>>> +  adi,disable-fast-down-1000base-t:
>>> +    $ref: /schemas/types.yaml#definitions/flag
>>> +    description: |
>>> +      If set, disables any ADI fast link down ("Enhanced Link Detection")
>>> +      function bits for 1000base-t interfaces.
>>
>> And why disabling it per board should be a property of DT?
>>
> That seemed like a logical place to allow override on boards where it is undesired. Would you say that properties such as this should instead be custom PHY tunables, which may require patching of ethtool as well?

First, your other commit says that it breaks IEEE standard, so maybe it
should be always disabled?

Second, tunable per board, but why? DT describes the hardware, so just
because someone wants to tune something is not a reason to put it in DT.
The reason to put it in DT is - this boards requires or cannot work with
the feature because of some board characteristic.

Best regards,
Krzysztof

