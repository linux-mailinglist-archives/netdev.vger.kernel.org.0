Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFAA67C51F
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbjAZHsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:48:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjAZHsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:48:31 -0500
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 022933A85;
        Wed, 25 Jan 2023 23:48:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1674719294; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=WdOtFd8BY6bhLowE3xoMWu03imwMrdjzRRVmvehhISHsLAjLBRRyhcK9/tg9OMnzpSryjIsc/mn83/OlUc97e/kWwoHx7G+mf+OsCpLwZac4eARQODEBzHQVzlL8sLUgcOW6/SCsuR1RWaGzpsf9wHEMaRA8eTFAieXPOwifaOM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1674719294; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=EEhXzhQHmYCtQgjT/uvlAKq8B6aYH3VkIv/Ma+zfbpk=; 
        b=a3zwbW8Ihtz+mRcBv4RfWTXF69pLI0zAAhvkcM2m2WiHoml7JNSuFafhb7KrtVwrGjj704n0SeoqCmIh/wy0ZX396gEoF2j1ho0zNsZ859SVGiXEBJo5LPMdEq9dgmeON2SEsMbYskPuqbaLjbwauSauJ56wJ5yYAZc+yqBdMKs=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1674719294;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=EEhXzhQHmYCtQgjT/uvlAKq8B6aYH3VkIv/Ma+zfbpk=;
        b=jpgf1CUbI/hQY7BXDBmWm9Gl/e5q+9qe1GOeZJbhgCqIVwQziZ7Ajkv5aNZ7A5PP
        2vBRi8SjQpeV+WrnYlZlnZIjBqNB/rp3FWB9J9KMN8xvjIru8el73fp00WGDZE89a1G
        vP4jRhvdLj+dxDEp+PiZd94BRTTVXHeievpdnTXQ=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1674719292880698.7184766537606; Wed, 25 Jan 2023 23:48:12 -0800 (PST)
Message-ID: <c4b65e0d-ce10-1fa4-d468-ba50a5441778@arinc9.com>
Date:   Thu, 26 Jan 2023 10:48:08 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net] net: dsa: mt7530: fix tristate and help description
Content-Language: en-US
To:     John 'Warthog9' Hawley <warthog9@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, erkin.bozoglu@xeront.com
References: <20230125053653.6316-1-arinc.unal@arinc9.com>
 <20230125224411.5a535817@kernel.org>
 <dd21bd3d-b3bb-c90b-8950-e71f4af6b167@kernel.org>
 <1f0e41f4-edf8-fcb5-9bb6-5b5163afa599@arinc9.com>
 <56b25571-6083-47d6-59e9-259a36dab462@kernel.org>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <56b25571-6083-47d6-59e9-259a36dab462@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.01.2023 10:45, John 'Warthog9' Hawley wrote:
> On 1/25/2023 11:34 PM, Arınç ÜNAL wrote:
>> On 26.01.2023 10:23, John 'Warthog9' Hawley wrote:
>>> On 1/25/2023 10:44 PM, Jakub Kicinski wrote:
>>>> On Wed, 25 Jan 2023 08:36:53 +0300 Arınç ÜNAL wrote:
>>>>> Fix description for tristate and help sections which include 
>>>>> inaccurate
>>>>> information.
>>>>>
>>>>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>>>>
>>>> Didn't make it thru to the list again :(
>>>> Double check that none of the addresses in To: or Cc: are missing
>>>> spaces between name and email or after a dot. That seems to be the most
>>>> common cause of trouble. Or try to resend using just emails, no names.
>>>>
>>>
>>> You are also likely to run into trouble if your character set is set 
>>> to UTF-8.
>>
>> I think that may be the problem here. I just resent this with only 
>> Jakub and the lists without names. It didn't make it to netdev. My 
>> name includes non-Latin characters. I'm not sure how I can change 
>> UTF-8 to something else that works with this list. I had no such 
>> issues with linux-mediatek.
>>
>> Arınç
>>
> 
> So dug it out of the logs, you aren't running into UTF-8 issues, so 
> that's good.  However your mail client is appending 'Delivered-To:' to 
> the messages, which is a significant indicator of some weird mail 
> problem for lists, I.E. why is a message that's been delivered being 
> passed back through to the list, which is on the published taboo list:
> 
> http://vger.kernel.org/majordomo-taboos.txt
> 
> What are you using to send these messages, as that's a header I 
> absolutely wouldn't expect to be on messages heading to vger?

It's just git send-email on git version 2.37.2. Zoho is doing the 
hosting & SMTP.

Arınç
