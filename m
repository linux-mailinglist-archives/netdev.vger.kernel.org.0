Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 757C44D744B
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 11:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232720AbiCMKsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 06:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbiCMKsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 06:48:37 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22518114FC3;
        Sun, 13 Mar 2022 03:47:28 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 7B54922239;
        Sun, 13 Mar 2022 11:47:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1647168446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wIZiFEsZAeYnOqGs2+bUuvQH61Nh7FBJ6q0NJr//BIc=;
        b=Jsqb8R27K4Qb9rhh2kkLgl4QF30L8Zoir/MEJOYpBLov6Da5zXRUtfV+p+nGRhKbvGTnwF
        4Lb61D5TLrpwVDwpyDGWfpEDpMqzJDkq/3IQ2AZ2Lh/Uc0xSmioHscQLiXleTN7XG8PXKq
        Wb9AV4OIWFUGZw+ADvWBDNImlOWbAMk=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 13 Mar 2022 11:47:26 +0100
From:   Michael Walle <michael@walle.cc>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/3] dt-bindings: net: mscc-miim: add lan966x
 compatible
In-Reply-To: <08b89b3f-d0d3-e96f-d1c3-80e8dfd0798f@kernel.org>
References: <20220313002536.13068-1-michael@walle.cc>
 <20220313002536.13068-2-michael@walle.cc>
 <08b89b3f-d0d3-e96f-d1c3-80e8dfd0798f@kernel.org>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <d18291ff8d81f03a58900935d92115f2@walle.cc>
X-Sender: michael@walle.cc
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

Am 2022-03-13 10:47, schrieb Krzysztof Kozlowski:
> On 13/03/2022 01:25, Michael Walle wrote:
>> The MDIO controller has support to release the internal PHYs from 
>> reset
>> by specifying a second memory resource. This is different between the
>> currently supported SparX-5 and the LAN966x. Add a new compatible to
>> distiguish between these two.
>> 
>> Signed-off-by: Michael Walle <michael@walle.cc>
>> ---
>>  Documentation/devicetree/bindings/net/mscc-miim.txt | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/Documentation/devicetree/bindings/net/mscc-miim.txt 
>> b/Documentation/devicetree/bindings/net/mscc-miim.txt
>> index 7104679cf59d..a9efff252ca6 100644
>> --- a/Documentation/devicetree/bindings/net/mscc-miim.txt
>> +++ b/Documentation/devicetree/bindings/net/mscc-miim.txt
>> @@ -2,7 +2,7 @@ Microsemi MII Management Controller (MIIM) / MDIO
>>  =================================================
>> 
>>  Properties:
>> -- compatible: must be "mscc,ocelot-miim"
>> +- compatible: must be "mscc,ocelot-miim" or "mscc,lan966x-miim"
> 
> No wildcards, use one, specific compatible.

I'm in a kind of dilemma here, have a look yourself:
grep -r "lan966[28x]-" Documentation

Should I deviate from the common "name" now? To make things
worse, there was a similar request by Arnd [1]. But the
solution feels like cheating ("lan966x" -> "lan966") ;)

On a side note, I understand that there should be no wildcards,
because the compatible should target one specific implementation,
right? But then the codename "ocelot" represents a whole series of
chips. Therefore, names for whole families shouldn't be used neither,
right?

-michael

[1] 
https://lore.kernel.org/lkml/CAK8P3a2kRhCOoXnvcMyqS-zK2WDZjtUq4aqOzE5VV=VMg=pVOA@mail.gmail.com/
