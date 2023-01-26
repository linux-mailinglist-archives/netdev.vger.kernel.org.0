Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6DBA67C5B9
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 09:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbjAZIYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 03:24:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjAZIYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 03:24:43 -0500
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413F547ED3;
        Thu, 26 Jan 2023 00:24:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1674721464; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=N1/PuHr01SaJ3PJW5UFbBYRdKwjmrcwjKxL1/v225ZNY2EgNh77MerlphGsETjpjVfbs1REkeg/W8kkvy7oNYgGSX0S0TX738srA+oKuVcHCZkWR0P0xW8wwFfvsFii+HvtC1x48eTM+6xDAj9+jmp4aYt1GuW1sli7E3oAZNDg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1674721464; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=fv+2HZe8J6qly+nq7TOMY/X9ADPVwEXmbRIEwbBP6uc=; 
        b=MDfglfI3wJSPk/6cvFPOSKB+xAW7CNu8Gw9BUer+gDr6yZhv0kVNaVnpvIQezrMuAR8B33n93Vdxt9ZQmP35hiG0cj3OT1HZODM7SISUp7iUnEGOM0UjcYsTHArpMFHgGUvY8vnWcv1TDy2i/uXAOJnwYX2I8D3cwNxWn+1kPB4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1674721464;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=fv+2HZe8J6qly+nq7TOMY/X9ADPVwEXmbRIEwbBP6uc=;
        b=ffnwY1ugNXeVvpEEYqwPRjRv3I01EOPlEfI5Tw4yemPJ/3HvSHQyrhf5lgKzAKjI
        fsZ2agOzQ39q1AQyl9lUjJ3SiMvp0cIdtFAz+++YJcnOTcC2sC61C++7DdQToV+pXGu
        Kag6u2L8Lt2vieWgnYNvVLHEhLAQlgxEXPQrg62s=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1674721464135238.11031232741198; Thu, 26 Jan 2023 00:24:24 -0800 (PST)
Message-ID: <9ede1ace-4d10-142b-3dc1-6bcd87d9e646@arinc9.com>
Date:   Thu, 26 Jan 2023 11:24:20 +0300
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
 <c4b65e0d-ce10-1fa4-d468-ba50a5441778@arinc9.com>
 <9539b880-642d-9ac5-ccfa-2b237548f4fc@kernel.org>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <9539b880-642d-9ac5-ccfa-2b237548f4fc@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.01.2023 11:12, John 'Warthog9' Hawley wrote:
> On 1/25/2023 11:48 PM, Arınç ÜNAL wrote:
>> On 26.01.2023 10:45, John 'Warthog9' Hawley wrote:
>>> On 1/25/2023 11:34 PM, Arınç ÜNAL wrote:
>>>> On 26.01.2023 10:23, John 'Warthog9' Hawley wrote:
>>>>> On 1/25/2023 10:44 PM, Jakub Kicinski wrote:
>>>>>> On Wed, 25 Jan 2023 08:36:53 +0300 Arınç ÜNAL wrote:
>>>>>>> Fix description for tristate and help sections which include 
>>>>>>> inaccurate
>>>>>>> information.
>>>>>>>
>>>>>>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>>>>>>
>>>>>> Didn't make it thru to the list again :(
>>>>>> Double check that none of the addresses in To: or Cc: are missing
>>>>>> spaces between name and email or after a dot. That seems to be the 
>>>>>> most
>>>>>> common cause of trouble. Or try to resend using just emails, no 
>>>>>> names.
>>>>>>
>>>>>
>>>>> You are also likely to run into trouble if your character set is 
>>>>> set to UTF-8.
>>>>
>>>> I think that may be the problem here. I just resent this with only 
>>>> Jakub and the lists without names. It didn't make it to netdev. My 
>>>> name includes non-Latin characters. I'm not sure how I can change 
>>>> UTF-8 to something else that works with this list. I had no such 
>>>> issues with linux-mediatek.
>>>>
>>>> Arınç
>>>>
>>>
>>> So dug it out of the logs, you aren't running into UTF-8 issues, so 
>>> that's good.  However your mail client is appending 'Delivered-To:' 
>>> to the messages, which is a significant indicator of some weird mail 
>>> problem for lists, I.E. why is a message that's been delivered being 
>>> passed back through to the list, which is on the published taboo list:
>>>
>>> http://vger.kernel.org/majordomo-taboos.txt
>>>
>>> What are you using to send these messages, as that's a header I 
>>> absolutely wouldn't expect to be on messages heading to vger?
>>
>> It's just git send-email on git version 2.37.2. Zoho is doing the 
>> hosting & SMTP.
>>
>> Arınç
>>
> 
> Best I can suggest for testing is try sending the patch series to only 
> the following 2 e-mail addresses:
>      to: testing@vger.kernel.org
>      cc: warthog9@eaglescrag.net
> 
> That will cut out more or less everything in the interim and might get 
> me a better look at the series.

Done, thanks for looking over this.

> 
> Only other thing I can think of is how is git send-email configured? 
> Where the 'Delivered-To:' header is in the headers makes me think that 
> it's added somewhere in what zoho is doing, which doesn't particularly 
> make any sense, as that would imply you are sending it to yourself and 
> then it passes it on?

My .gitconfig is as follows, the rest is straight out of apt install 
git-email.

[user]
         email = arinc.unal@arinc9.com
         name = Arınç ÜNAL

[sendemail]
         smtpEncryption = ssl
         smtpServer = smtppro.zoho.com
         smtpUser = arinc.unal@arinc9.com
         smtpPass =
         smtpServerPort = 465

> 
> I'll admit zoho is one of the mail providers that has a tendency to 
> reject a lot of mail coming from vger and has been unresponsive to any 
> queries I've made on that front (though I'll note your domain is not on 
> the list of domains that are having problems there).  Only other thing I 
> could suggest is pinging zoho technical support and asking them what's 
> up, as that's a very odd header to have there.

I'll see what I can do. I've been getting suspicious header mails from 
linux-arm-kernel and pabeni@redhat.com's mail server outright claims 
Zoho's SMTP IP as spam.

Your mail to 'linux-arm-kernel' with the subject

     [PATCH net] net: ethernet: mtk_eth_soc: disable hardware DSA
untagging for second MAC

Is being held until the list moderator can review it for approval.

The reason it is being held:

     Message has a suspicious header

---

This message was created automatically by mail delivery software.
  A message that you sent could not be delivered to one or more of its 
recipients. This is a permanent error.

pabeni@redhat.com, ERROR CODE :550 - spamcop.mimecast.org Blocked - see 
https://www.spamcop.net/bl.shtml?136.143.188.14. - 
https://community.mimecast.com/docs/DOC-1369#550 
[nSq2mM6RNqWOxCrbHVMv8Q.us380]

Arınç
