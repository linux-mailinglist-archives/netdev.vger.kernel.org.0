Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E3D67C4EF
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbjAZHer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:34:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjAZHeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:34:46 -0500
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9985EF9C
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:34:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1674718466; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=IQYpRnWWtPK0El+L92Ni4UwuTMux/ljq/Rl4COtsXqBW6K+hfREcfwTZ/bKk14SsvH5SuB4fsqtHo/krSibmO6Xgyku0fRMsuMXDPDFqcLrK2fPRJL4l44ZQ3x8F8GbqhGWHi5COETAXuOAyumRO/n2rycaDE/IFZ1npTFEQZO0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1674718466; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=U65p8hOzdSe3/PC0vg4Oj9gzj+NCyyXs40Dv4ecIoSg=; 
        b=ltIoxJ2frCbfyZyjop54Yqa04RFbVWO5KZ0luyfPMmj5MWpuKYEaqv37C6GJ9cXWjlcerzPrf1BgeFyRI7zQGs0gnggWJNvSlpJAAoxToXAGrWyszo25SwDkEdH2ljKssDxOT7XD9QDR7Ms7p0sy5x1epCBVKxBb/UUFDruwgOU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1674718466;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=U65p8hOzdSe3/PC0vg4Oj9gzj+NCyyXs40Dv4ecIoSg=;
        b=IV52+0Qd7O9MQ0HkOzjDHlqvpjfMgTQXIqyarOeJv+Nw3BW6tQEfcF9hCG6gdbsR
        828PGh+UwM1tosFGzLC0tWQzJFGs75H2cjZ1RY9FzJccSsZ1MLAA2VJBr8gJutd87bL
        npHrTkIUJjmFhSaKXUMkyyb62g32F1xmbOviu5LA=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1674718463412842.8049862602045; Wed, 25 Jan 2023 23:34:23 -0800 (PST)
Message-ID: <1f0e41f4-edf8-fcb5-9bb6-5b5163afa599@arinc9.com>
Date:   Thu, 26 Jan 2023 10:34:11 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net] net: dsa: mt7530: fix tristate and help description
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
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <dd21bd3d-b3bb-c90b-8950-e71f4af6b167@kernel.org>
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

On 26.01.2023 10:23, John 'Warthog9' Hawley wrote:
> On 1/25/2023 10:44 PM, Jakub Kicinski wrote:
>> On Wed, 25 Jan 2023 08:36:53 +0300 Arınç ÜNAL wrote:
>>> Fix description for tristate and help sections which include inaccurate
>>> information.
>>>
>>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>>
>> Didn't make it thru to the list again :(
>> Double check that none of the addresses in To: or Cc: are missing
>> spaces between name and email or after a dot. That seems to be the most
>> common cause of trouble. Or try to resend using just emails, no names.
>>
> 
> You are also likely to run into trouble if your character set is set to 
> UTF-8.

I think that may be the problem here. I just resent this with only Jakub 
and the lists without names. It didn't make it to netdev. My name 
includes non-Latin characters. I'm not sure how I can change UTF-8 to 
something else that works with this list. I had no such issues with 
linux-mediatek.

Arınç
