Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75DF854F9B1
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 16:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382650AbiFQOz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 10:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358452AbiFQOz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 10:55:57 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301501BEA9
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 07:55:56 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id c189so4785271iof.3
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 07:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=DFc2znw3v46JZmrBeWiAM8kydODkW84KLxvbAMxOM8Y=;
        b=oKTDQTb+KgQlBcTheYDdolBcspHG0KqiUfKsrHoSH2w9anGOkE5Zpgi9Z10jZ2sck5
         9xPPYMad7RhkfIU6c++NrQc4d2MNxSxxhJALwzmEoAkgmjvclm4MwyEsDOdSbw3vKFSs
         nY9SaMBs7Y9P95e72K8ifduRaGN/bvyCUU5NAVSxIg8EqE+cWCGJGTY/h+WIMNVunq8a
         Mki3lfqN3HTf7zy4Rn3d3loCEmaUPcZXPAqO6WrvWHbiObj36Vx+lRNH3rkJrIsabBvB
         umLwKMU51grkh2GrUV2s37Djy/8SO99c4fbI8RXKC2ahsicDgdOd4XQLA6xIMJQb0xn9
         YRCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DFc2znw3v46JZmrBeWiAM8kydODkW84KLxvbAMxOM8Y=;
        b=I8KOTGlwgr49+uHGKuFO0lOjbRIm5m5m+KycYek4kXEVxvldJt73yAp5WiomZfngi2
         /iqXDHljn/DM7EPtq1sW234RU+CciPeHTWPhKikooKNylRWbT7y/Xy44A4YShglhtN0E
         by2VM3eFyxvkz7ZvsCmnizqBQc9Dx7HCbtSqsfXQDtBxsY/RzLTcYOeYqJrietcvOxQI
         stjrmNd9F+0EVh3Ym4jkSxcHpgzaAQHUlkFbitPH8Mde9E/ehn80MVxyc/C7QeWHO5O6
         vU5Y1KsAJZKPMsHA1xepeOoAq1MFmfEcM+Ws+p7i1Ugm/boOaYedagHBvq1tEwdrkr+Z
         jZGg==
X-Gm-Message-State: AJIora+S6e2I/+9EvRI0hGPy0Yg4GbzxycT0Z8rIhqzm8qrEeha0nH4M
        Hhk9UI/HLA3S8ITmkiSSW7A=
X-Google-Smtp-Source: AGRyM1uPvaKMX6SKZmsjVM8jh8y4Fx6mqouH4hASucA7TnUiZkuyYITAt9LX5IYB06xgku0V0vbL0A==
X-Received: by 2002:a5e:8404:0:b0:66a:13cc:f2bc with SMTP id h4-20020a5e8404000000b0066a13ccf2bcmr5050584ioj.95.1655477755542;
        Fri, 17 Jun 2022 07:55:55 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:6c50:af42:34c6:3055? ([2601:282:800:dc80:6c50:af42:34c6:3055])
        by smtp.googlemail.com with ESMTPSA id h4-20020a02cd24000000b0032ebaebb4d2sm2291410jaq.50.2022.06.17.07.55.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jun 2022 07:55:54 -0700 (PDT)
Message-ID: <9598e112-55b5-a8c0-8a52-0c0f3918e0cd@gmail.com>
Date:   Fri, 17 Jun 2022 08:55:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: Netlink NLM_F_DUMP_INTR flag lost
Content-Language: en-US
To:     Ismael Luceno <iluceno@suse.de>, Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20220615171113.7d93af3e@pirotess>
 <20220615090044.54229e73@kernel.org> <20220616171016.56d4ec9c@pirotess>
 <20220616171612.66638e54@kernel.org> <20220617150110.6366d5bf@pirotess>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220617150110.6366d5bf@pirotess>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/17/22 7:01 AM, Ismael Luceno wrote:
> On Thu, 16 Jun 2022 17:16:12 -0700
> Jakub Kicinski <kuba@kernel.org> wrote:
>> On Thu, 16 Jun 2022 17:10:16 +0200 Ismael Luceno wrote:
>>> On Wed, 15 Jun 2022 09:00:44 -0700
>>> Jakub Kicinski <kuba@kernel.org> wrote:  
>>>> On Wed, 15 Jun 2022 17:11:13 +0200 Ismael Luceno wrote:    
>>>>> It seems a RTM_GETADDR request with AF_UNSPEC has a corner case
>>>>> where the NLM_F_DUMP_INTR flag is lost.
>>>>>
>>>>> After a change in an address table, if a packet has been fully
>>>>> filled just previous, and if the end of the table is found at
>>>>> the same time, then the next packet should be flagged, which
>>>>> works fine when it's NLMSG_DONE, but gets clobbered when
>>>>> another table is to be dumped next.    
>>>>
>>>> Could you describe how it gets clobbered? You mean that prev_seq
>>>> gets updated somewhere without setting the flag or something
>>>> overwrites nlmsg_flags? Or we set _INTR on an empty skb which
>>>> never ends up getting sent? Or..    
>>>
>>> It seems to me that in most functions, but specifically in the case
>>> of net/ipv4/devinet.c:in_dev_dump_addr or inet_netconf_dump_devconf,
>>> nl_dump_check_consistent is called after each address/attribute is
>>> dumped, meaning a hash table generation change happening just after
>>> it adds an entry, if it also causes it to find the end of the table,
>>> wouldn't be flagged.
>>>
>>> Adding an extra call at the end of all these functions should fix
>>> that, and spill the flag into the next packet, but would that be
>>> correct?  
>>
>> The whole _DUMP_INTR scheme does indeed seem to lack robustness.
>> The update side changes the atomic after the update, and the read
>> side validates it before. So there's plenty time for a race to happen.
>> But I'm not sure if that's what you mean or you see more issues.
> 
> No, I'm concerned that while in the dumping loop, the table might
> change between iterations, and if this results in the loop not finding
> more entries, because in most these functions there's no
> consistency check after the loop, this will go undetected.

Specific example? e.g., fib dump and address dumps have a generation id
that gets recorded before the start of the dump and checked at the end
of the dump.

> 
>>> It seems this condition is flagged correctly when NLM_DONE is
>>> produced, I couldn't see why, but I'm guessing another call to
>>> nl_dump_check_consistent...
>>>
>>> Also, I noticed that in net/core/rtnetlink.c:rtnl_dump_all: 
>>>
>>> 	if (idx > s_idx) {
>>> 		memset(&cb->args[0], 0, sizeof(cb->args));
>>> 		cb->prev_seq = 0;
>>> 		cb->seq = 0;
>>> 	}
>>> 	ret = dumpit(skb, cb);
>>>
>>> This also prevents it to be detect the condition when dumping the
>>> next table, but that seems desirable...  
>>
>> That's iterating over protocols, AFAICT, we don't guarantee
>> consistency across protocols.
> 
> That's reasonable, I was just wondering about it because it does seem
> reasonable that the flags affect only the packets describing the table
> whose dump got interrupted...
> 

