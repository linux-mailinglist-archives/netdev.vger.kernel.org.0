Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47AA54FDFE6
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238663AbiDLMKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354313AbiDLMKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:10:04 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 184A96D3AA
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 04:09:57 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id e22so15811609qvf.9
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 04:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8HQYjugvN4vPXQ4iViwk6iKGa5uEY85iMW3XiQYVH9Q=;
        b=t6DQH7PdS0WBcFEfTBybj65BVU2E2JjaBEGBHyWTV2TPuLlNlkvSQCfDzaJ4qLcZv9
         G4clIb6kfQW6gYIPEqBcksjpsE135TJCO+eNtSvuAUWYyg8x/PTrodxlY9LT8+EJzH6Z
         PQ5/W5HS+D1WAnhEplN2aQXFC3ZLU9PoQz5t4sca+AAhjeaOZeiJlro4j/KBrqc07OPv
         JcWcXfpU1MouhnOUnuUv2c859KlN82fsld59QIN622RBBBOOCZO0ZRKQCs5yGdLBGSX5
         x6HbFP6CBD54uUt5TIhRPKAYs/WD1Ly7JuHHEY+sKbhJ73K51d2qO12eVmapv9mp3YUY
         niIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8HQYjugvN4vPXQ4iViwk6iKGa5uEY85iMW3XiQYVH9Q=;
        b=olLZmapVIaRHhe/pN3o8THU3oPZ66RqD5WAXDpfVyCOAxBAXZK272oQ4y67khNNh6D
         O3p5ZHwzbzu/lE18AdGI0wPguUtuGtGZLNjTrs9dVSpEu4HGOwJCV+XjHqnH9dTnz0K4
         stwrUzZJyo26V6kklqgga7MV1Jzre2+yUZ10jW8y1Ke2XmZ63uvU7QJiOtiJArtP2MsJ
         c3wq4TqORktZGkNdL+/I5K2/kogRCwQdXbi0Oh7fiOPwVbo8hVgWW497gyiznsGMEBnd
         zvK/ajwXn6IccB67os1R9fvpnc9gcGTh7/JVhLsyJB5LstmU+sxPEB2059WKcUBuqw69
         Jxsg==
X-Gm-Message-State: AOAM532djc9xb7RYG6wZj6UHDLkHNSA9ZCz0lUuVncWjVLgD6oOByU7I
        vBoTVF9wrLs23Bu7z8pAJX5PbA==
X-Google-Smtp-Source: ABdhPJwr1zBG3HK1klPqoVXbjTjJqK6OpAmzV+PKs5Mn36QB/hRTOCz5XHz/DeP9wTWckdoHfLcyAA==
X-Received: by 2002:a05:6214:d88:b0:443:e626:40e0 with SMTP id e8-20020a0562140d8800b00443e62640e0mr30718114qve.112.1649761796444;
        Tue, 12 Apr 2022 04:09:56 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-25-174-95-97-66.dsl.bell.ca. [174.95.97.66])
        by smtp.googlemail.com with ESMTPSA id m6-20020a05622a118600b002ed159394bfsm6414115qtk.31.2022.04.12.04.09.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 04:09:55 -0700 (PDT)
Message-ID: <b2c83f63-a2e9-92a2-f262-3aae3491dfc3@mojatatu.com>
Date:   Tue, 12 Apr 2022 07:09:54 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH iproute2-next 0/2] flower: match on the number of vlan
 tags
Content-Language: en-US
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        zhang kai <zhangkaiheb@126.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        Ilya Lifshits <ilya.lifshits@broadcom.com>
References: <20220411133202.18278-1-boris.sukholitko@broadcom.com>
 <20220411084536.1f18d4ea@hermes.local> <20220412104514.GB27480@noodle>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20220412104514.GB27480@noodle>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-12 06:45, Boris Sukholitko wrote:
> On Mon, Apr 11, 2022 at 08:45:36AM -0700, Stephen Hemminger wrote:
>> On Mon, 11 Apr 2022 16:32:00 +0300
>> Boris Sukholitko <boris.sukholitko@broadcom.com> wrote:
>>
>>> Hi,
>>>
>>> Our customers in the fiber telecom world have network configurations
>>> where they would like to control their traffic according to the number
>>> of tags appearing in the packet.
>>>
>>> For example, TR247 GPON conformance test suite specification mostly
>>> talks about untagged, single, double tagged packets and gives lax
>>> guidelines on the vlan protocol vs. number of vlan tags.
>>>
>>> This is different from the common IT networks where 802.1Q and 802.1ad
>>> protocols are usually describe single and double tagged packet. GPON
>>> configurations that we work with have arbitrary mix the above protocols
>>> and number of vlan tags in the packet.
>>>
>>> The following patch series implement number of vlans flower filter. They
>>> add num_of_vlans flower filter as an alternative to vlan ethtype protocol
>>> matching. The end result is that the following command becomes possible:
>>>
>>> tc filter add dev eth1 ingress flower \
>>>    num_of_vlans 1 vlan_prio 5 action drop
>>>
>>> The corresponding kernel patches are being sent separately.
>>>
>>> Thanks,
>>> Boris.
>>
>> Maybe something custom like this is better done by small BPF program?
> 
> I am not sure it is feasible to have BPF match done on the number of
> vlans and have the rest of TC machinery work as expected.
> 
> For example, the flower filters look at the protocol to allow matching
> on the vlan fields. Patch 5 of the kernel part of the series adds number
> of vlans as a different precondition. Having BPF program does nothing
> for it.
> 
> Replicating more of TC functionality in the BPF to alleviate such pain
> points is probably possible but will not be "simple".
> 
> Also (and sorry for the philosophy rant!) there is an issue of UI and
> intended audience here. The TC tools are well known and accessible. I am
> not sure that the same can be said for a custom BPF programs. :)
> 

I hate to use +1 (proverbial death-by-pluse-one in effect) but, damn
couldnt resist. Stephen, this mantra only makes sense if:

a) You are a big cloud vendor with a gazillion developers who will
write, test and maintain your custom code.
b) willing to pay some consultant or other vendor to do the above.

The majority of the world just wants to pay RH or Cannonical for the
basic distro support and then run their bash scripts (the ops part,
_not the dev_).
I wouldnt call what Boris is doing as "custom". The VLAN infrastructure
has some challenges when it comes to multiple tags.

My 2c Canadiana rant:
I am not saying there's no room for custom - in which case ebpf has
a role to play (and we widely use it here when it makes sense), just
that the standard answer shouldnt be "use ebpf" just because.

Rant continued:
As community we now seem to be driven by cloud vendor mentality really.
What happened to "lets contribute back so everyone can benefit"?
There's a lot of value still in upstreaming things.

cheers,
jamal
