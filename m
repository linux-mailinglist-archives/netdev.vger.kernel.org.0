Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8666BF4D1
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 23:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjCQWDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 18:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjCQWDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 18:03:34 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C81B206B6;
        Fri, 17 Mar 2023 15:03:31 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id m6so4399612qvq.0;
        Fri, 17 Mar 2023 15:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679090610;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3lTklI3rOa3p41OpUj9rqs2zdRkNK2Et/2nf0ayXcyQ=;
        b=C4htVPyksvXIPLQJYAGCyzjwl62+vvni+X/3zK8hBjsyRA3eWHA3dHhGq+4ZFcBvnE
         OHcIzZgnuoGA9sGA9nBeI6JlkbOJ/PqxEHTDz2PwGfd0MbxzKTkJ1rH3WGOU5WLT5+Lc
         sdBvnV3VEgoYuYvvAW0Ps+Z3tf5US2kWqooRe1ZCjX750KBJ/ngSz8re7y8Frxef8uRc
         jBCZucOYE2Fmp2Owj0WpQZT3vG2tJT8WNMtjG8EDw/jURt8lE0Kajc55iCtnh6x8HexX
         UiGkZAQRlnK9eKDMW5eWLV7NTsZdXsPLY2FEFse5Aev8ez9J6OZfVfV0f1LKX9vdQELB
         +yIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679090610;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3lTklI3rOa3p41OpUj9rqs2zdRkNK2Et/2nf0ayXcyQ=;
        b=sVaXzXqL5d65H2KpVShEZ3qwvq2c0V09sz+Xx1VTEzMt6GflqGrMm4QIplvt2+JMA2
         4kc/U4wAIpRZhuSylST2EAT7zLyzMw44TzxHy3l+b2b+d1SP5IilOT68EIyh4U5hstcD
         tllhjPCrpCAldcogbsnyNPUyQpyFNq8i/D5gq4EVZCS8tqlX4R9C65zWy489/NrMnqk+
         8aQkRytVvR1elKWYT6A9Lqr7qL8iwFt9n8WYe1jXWwKrfcc1ycisEBNQjum0xV8qnrgN
         H2C+KhBfFq93sJeL4YziVx+SehCdCrWCaAPAPRWDVXphgakJeBJ039uH21aNma5k8Mi1
         JM7g==
X-Gm-Message-State: AO0yUKV9pr39bXEy5pA3ayLs6vA9SVBimyJ6lO6ol6/pHVg9aKOWDc1b
        932rT0l6finp3/UY08WgrYQ=
X-Google-Smtp-Source: AK7set9gtJW9TndvxPxMcTs0fzM0NrUCzT22qThkPEK1WOxoIsXrEPiKCtLJ9oi4UXescd5/QDDheA==
X-Received: by 2002:a05:6214:2a4a:b0:5ad:a15b:3e6c with SMTP id jf10-20020a0562142a4a00b005ada15b3e6cmr24159258qvb.48.1679090610394;
        Fri, 17 Mar 2023 15:03:30 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 80-20020a370a53000000b007424376ca4bsm2503354qkk.18.2023.03.17.15.03.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 15:03:29 -0700 (PDT)
Message-ID: <4c2a7063-c9c1-ee88-ed99-8cc69c15a56a@gmail.com>
Date:   Fri, 17 Mar 2023 15:03:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] net: dsa: tag_brcm: legacy: fix daisy-chained switches
Content-Language: en-US
To:     =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>
Cc:     Jonas Gorski <jonas.gorski@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230317120815.321871-1-noltari@gmail.com>
 <00783066-a99c-4bab-ae60-514f4bce687b@lunn.ch>
 <CAOiHx==TiSZKE4AP3PZ9Ah4zuAsrfpOTvRADWpT2kMS9UVRH9Q@mail.gmail.com>
 <9f771318-5a59-ac31-a333-e2ad9947679f@gmail.com>
 <CAKR-sGdgfztvXCymeNSPSoR=C466NzQ-6siiWSUukSAR_-c4-Q@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <CAKR-sGdgfztvXCymeNSPSoR=C466NzQ-6siiWSUukSAR_-c4-Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/17/23 14:51, Álvaro Fernández Rojas wrote:
> El vie, 17 mar 2023 a las 17:55, Florian Fainelli
> (<f.fainelli@gmail.com>) escribió:
>>
>> On 3/17/23 09:49, Jonas Gorski wrote:
>>> On Fri, 17 Mar 2023 at 17:32, Andrew Lunn <andrew@lunn.ch> wrote:
>>>>
>>>> On Fri, Mar 17, 2023 at 01:08:15PM +0100, Álvaro Fernández Rojas wrote:
>>>>> When BCM63xx internal switches are connected to switches with a 4-byte
>>>>> Broadcom tag, it does not identify the packet as VLAN tagged, so it adds one
>>>>> based on its PVID (which is likely 0).
>>>>> Right now, the packet is received by the BCM63xx internal switch and the 6-byte
>>>>> tag is properly processed. The next step would to decode the corresponding
>>>>> 4-byte tag. However, the internal switch adds an invalid VLAN tag after the
>>>>> 6-byte tag and the 4-byte tag handling fails.
>>>>> In order to fix this we need to remove the invalid VLAN tag after the 6-byte
>>>>> tag before passing it to the 4-byte tag decoding.
>>>>
>>>> Is there an errata for this invalid VLAN tag? Or is the driver simply
>>>> missing some configuration for it to produce a valid VLAN tag?
>>>>
>>>> The description does not convince me you are fixing the correct
>>>> problem.
>>>
>>> This isn't a bug per se, it's just the interaction of a packet going
>>> through two tagging CPU ports.
>>>
>>> My understanding of the behaviour is:
>>>
>>> 1. The external switch inserts a 4-byte Broadcom header before the
>>> VLAN tag, and sends it to the internal switch.
>>> 2. The internal switch looks at the EtherType, finds it is not a VLAN
>>> EtherType, so assumes it is untagged, and adds a VLAN tag based on the
>>> configured PVID (which 0 in the default case).
>>> 3. The internal switch inserts a legacy 6-byte Broadcom header before
>>> the VLAN tag when forwarding to its CPU port.
>>>
>>> The internal switch does not know how to handle the (non-legacy)
>>> Broadcom tag, so it does not know that there is a VLAN tag after it.
>>>
>>> The internal switch enforces VLAN tags on its CPU port when it is in
>>> VLAN enabled mode, regardless what the VLAN table's untag bit says.
>>>
>>> The result is a bogus VID 0 and priority 0 tag between the two
>>> Broadcom Headers. The VID would likely change based on the PVID of the
>>> port of the external switch.
>>
>> My understanding matches yours, at the very least, we should only strip
>> off the VLAN tag == 0, in case we are stacked onto a 4-bytes Broadcom
>> tag speaking switch, otherwise it seems to me we are stripping of VLAN
>> tags a bait too greedily.
> 
> Maybe I'm wrong here, but we're only removing the VLAN tag for a
> specific case in which we shouldn't have any kind of VLAN tag, right?
> 
> For example, let's say we have an internal switch with the following ports:
> - 0: LAN 1
> - 4: RGMII -> External switch
> - 8: CPU -> enetsw controller
> 
> And the external switch has the following ports:
> - 0: LAN 2
> - 1: LAN 3
> ...
> - 8: CPU -> Internal switch RGMII
> 
> A. If we get a packet from LAN 1, it will only have the 6-bytes tag
> (and optionally the VLAN tag).
> When dsa_master_find_slave() is called, the net_device returned won't
> have any kind of DSA protocol and therefore netdev_uses_dsa() will
> return FALSE.
> 
> B. However, when a packet is received from LAN 2/3, the first tag
> processed will be the 6-byte tag (corresponding to the internal
> switch).
> The 6-byte tag will identify this as coming from port 4 of the
> internal switch (RGMII) and therefore dsa_master_find_slave() will
> return the extsw interface which will have the DSA protocol of the
> 4-byte tag and netdev_uses_dsa() will return TRUE.
> 
> Only for the second case the invalid VLAN tag will be removed and
> since extsw (RGMI) will never have VLANs enabled, I don't see the
> problem that you suggest about removing the VLAN tags too greedily.
> 
> Am I wrong here?

I totally missed the netdev_uses_dsa() check you added on the looked up 
net_device, your explanation makes sense to me, thanks!
-- 
Florian

