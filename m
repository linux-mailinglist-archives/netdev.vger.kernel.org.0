Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2E95B6173
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 21:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbiILTGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 15:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiILTGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 15:06:34 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96FCD402D7
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 12:06:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1663009589; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=T+v4d1I2h64wc/E/+DZWKCjvwSpYkZ4Rh9IMQBDpvGW4jV9+fJ9T23MU5RjJDzuGrKKWz76gJUw2yqppXlZ6KQkXSs34Kbpn5EldLhL6uhu7JdtzMA4Sjrm5uo75D0PFjHcd1Y5q2n2gFm2MeFk2shImbx/i+P5T47dpFm9JzvM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1663009589; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=FyCPFQeUNf9+Sh5hPj78CE0VFvbKaRaZvw9vJ39TCaY=; 
        b=Jg04QIWdPOoGqcvjY+zhP2VbaPe8hH0iHt0h8fDbSvG530sKWhiLn7DfmoMAOfMy+cgLS2zS5PhkIgQ/a0PR8NjQkfV98QPfGHfery8qmvTZIoz2DX4447R1WS7pnxUh4PBQqYBVZKvtA9klcWl5Z24jU/hwqGtZ7h7f3n4YoH8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1663009589;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=FyCPFQeUNf9+Sh5hPj78CE0VFvbKaRaZvw9vJ39TCaY=;
        b=HY3A5OQw5cK8NTDHrpvRsq+d0t00QUKKfvRH0m02jq4ZgzzMkeI4GAPUEfWbr0MP
        9Lg2y1lrkESLRWEJCGWJ4x+Kted9NZLxKI48D1QFyCtZS/X9DvVH/r9ALTXGlKWVBYJ
        eVT5eXM8hmimCjzp9kdTZ9jug+lfbPHCCj4JpzF8=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 16630095874741010.6336371056144; Mon, 12 Sep 2022 12:06:27 -0700 (PDT)
Message-ID: <170d725f-2146-f1fa-e570-4112972729df@arinc9.com>
Date:   Mon, 12 Sep 2022 22:06:25 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: mtk_eth_soc for mt7621 won't work after 6.0-rc1
Content-Language: en-US
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
References: <146b9607-ba1e-c7cf-9f56-05021642b320@arinc9.com>
 <Yx8thSbBKJhxv169@lore-desk> <Yx9z9Dm4vJFxGaJI@lore-desk>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <Yx9z9Dm4vJFxGaJI@lore-desk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenzo,

On 12.09.2022 21:01, Lorenzo Bianconi wrote:
>>> Ethernet for MT7621 SoCs no longer works after changes introduced to
>>> mtk_eth_soc with 6.0-rc1. Ethernet interfaces initialise fine. Packets are
>>> sent out from the interface fine but won't be received on the interface.
>>>
>>> Tested with MT7530 DSA switch connected to gmac0 and ICPlus IP1001 PHY
>>> connected to gmac1 of the SoC.
>>>
>>> Last working kernel is 5.19. The issue is present on 6.0-rc5.
>>>
>>> Arınç
>>
>> Hi Arınç,
>>
>> thx for testing and reporting the issue. Can you please identify
>> the offending commit running git bisect?
>>
>> Regards,
>> Lorenzo
> 
> Hi Arınç,
> 
> just a small update. I tested a mt7621 based board (Buffalo WSR-1166DHP) with
> OpenWrt master + my mtk_eth_soc series and it works fine. Can you please
> provide more details about your development board/environment?

I've got a GB-PC2, Sergio has got a GB-PC1. We both use Neil's 
gnubee-tools which makes an image with filesystem and any Linux kernel 
of choice with slight modifications (maybe not at all) on the kernel.

https://github.com/neilbrown/gnubee-tools

Sergio experiences the same problem on GB-PC1.

Arınç
