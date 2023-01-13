Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 902FC669394
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 10:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240798AbjAMJ6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 04:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241237AbjAMJ6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 04:58:09 -0500
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D2C57928;
        Fri, 13 Jan 2023 01:56:33 -0800 (PST)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 30D9uDrA087684;
        Fri, 13 Jan 2023 03:56:13 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1673603774;
        bh=6AddglEzoh+9QUff07hr9GkAr80Dg+psvuk7ocIif98=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=xlcMPEgD80UD/noXs3i9eEw+yEBQGotNNzXcm/fyYDUrTs4e1+nuOPppZaMwOxCbA
         ocCbhd00azB6GUjhF1Vkgg+myko5DU6+zqlyt/5NTgFnKEf5W3378Gl12CRx7NnSjh
         WgBHqLLcz3FxJRXR3rQxD5UKNWxarr4so8WO85bI=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 30D9uDF5086837
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 13 Jan 2023 03:56:13 -0600
Received: from DFLE113.ent.ti.com (10.64.6.34) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Fri, 13
 Jan 2023 03:56:13 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Fri, 13 Jan 2023 03:56:13 -0600
Received: from [172.24.145.61] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 30D9u8uR004757;
        Fri, 13 Jan 2023 03:56:09 -0600
Message-ID: <19566370-3cf1-09fd-119f-c39c0309eb6d@ti.com>
Date:   Fri, 13 Jan 2023 15:26:08 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <nm@ti.com>,
        <kristo@kernel.org>, <vigneshr@ti.com>, <nsekhar@ti.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: Re: [PATCH net-next 0/5] Add PPS support to am65-cpts driver
Content-Language: en-US
To:     Roger Quadros <rogerq@kernel.org>
References: <20230111114429.1297557-1-s-vadapalli@ti.com>
 <2fc741b2-671d-8817-1d6f-511398aea9ff@kernel.org>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <2fc741b2-671d-8817-1d6f-511398aea9ff@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Roger,

On 13/01/23 15:18, Roger Quadros wrote:
> Siddharth,
> 
> On 11/01/2023 13:44, Siddharth Vadapalli wrote:
>> The CPTS hardware doesn't support PPS signal generation. Using the GenFx
>> (periodic signal generator) function, it is possible to model a PPS signal
>> followed by routing it via the time sync router to the CPTS_HWy_TS_PUSH
>> (hardware time stamp) input, in order to generate timestamps at 1 second
>> intervals.
>>
>> This series adds driver support for enabling PPS signal generation.
>> Additionally, the documentation for the am65-cpts driver is updated with
>> the bindings for the "ti,pps" property, which is used to inform the
>> pair [CPTS_HWy_TS_PUSH, GenFx] to the cpts driver. The PPS example is
>> enabled for AM625-SK board by default, by adding the timesync_router node
>> to the AM62x SoC, and configuring it for PPS in the AM625-SK board dts.
>>
>> Grygorii Strashko (3):
>>   dt-binding: net: ti: am65x-cpts: add 'ti,pps' property
>>   net: ethernet: ti: am65-cpts: add pps support
>>   net: ethernet: ti: am65-cpts: adjust pps following ptp changes
>>
>> Siddharth Vadapalli (2):
>>   arm64: dts: ti: k3-am62-main: Add timesync router node
>>   arm64: dts: ti: k3-am625-sk: Add cpsw3g cpts PPS support
> 
> Device tree patches need to be sent separately. You don't need to involve
> net maintainers for that.
> 
> If you introduce a new binding then that needs to be in maintainer's
> tree before you can send a related device tree patch.

Thank you for letting me know. Would I need to resend the series in order for it
to be reviewed? I was hoping that if I get feedback for this series, I will
implement it and post just the bindings and driver patches as the v2 series,
dropping the device tree patches. Please let me know.

Regards,
Siddharth.
