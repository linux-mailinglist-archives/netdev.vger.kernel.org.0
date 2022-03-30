Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C7B4EC970
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 18:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348699AbiC3QSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 12:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348693AbiC3QSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 12:18:31 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32A7BF4C
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 09:16:45 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id c62so25034279edf.5
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 09:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=wvcJ0kbG7fzM0+XeGFxiUHTL6MCcu+q18zHDXJW5yos=;
        b=DjzmS7pHnROcTaKdexi/iWo7fVkbtNGhniTdoIGJ0t6qo7krnmU2sgexTjdJvC0z8y
         kR9K2KlD1of3sFw17MvPvqgpwI+z8Zbx+GFSq6QmSoldGQ/WKYQkVOy2UTTAx+uSGOFI
         D4cnj/jWykSuQOwsfmK9EkXpR9QT+YjNvckx/QUvPFKdShah1RihkENhXzsHx7ehcuYx
         bBm2U3UyLgT2Mp6hdfiRyYdf911KmccuCZVZmrbHwtGU7M9UisqoS0RLHuNDXVOK/8R6
         gLF94hUr2XzDwT6NLBQCHF1OCxrzqJsCOZX8Pewl1qrdQYK1EP1yNO5ztv12mYLCqSSz
         NeNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wvcJ0kbG7fzM0+XeGFxiUHTL6MCcu+q18zHDXJW5yos=;
        b=G1JosiWeFdiX1p/OBOEsQfyy9Nbp+lqWdFDw7ZqVjmG6M/VTGQNVxi9JVmarpUpu66
         70YsEGOJAkPCprFdGI+qG5mAy2LjvNCT57QzI+g2hVM1aq8bGuETiPN/gbri+Rr3uWdq
         siaslJMoJpBTcyHrcd9dNPujd1HVAKOamK1M1+INoud9bCC4fIHAVzISFXds0Jd6qZOZ
         4lzdm7YPg1X9z3QIlzsAJ0xeODYrR4IQM4uwXwPZfsq5i6XkSLDL0QONcRNFqOHcmiri
         cMsFby7MecOD3l8N7B5hTinPIAT1pP+l3KyqztlMnBRAXfHWUd/yaoFWL/ambd38QlMe
         3xCw==
X-Gm-Message-State: AOAM531q5q8lGB3u2HA3m7X6mDuxIIodxiSCIOxHAxNM9FG62V4NRT0F
        U6LBZNGxoI/+pjr6F9kwYJagfQ==
X-Google-Smtp-Source: ABdhPJxMITlVLc8sl/rkLI5lhAQ5Q2nKl8IYXlMnrU0zdcE+tZuRD5hV1Tp7GtKBZwXieqZQNauPOA==
X-Received: by 2002:a05:6402:51d2:b0:419:7d2e:9d0 with SMTP id r18-20020a05640251d200b004197d2e09d0mr11567529edd.82.1648657004239;
        Wed, 30 Mar 2022 09:16:44 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id i4-20020a17090685c400b006e0c04f8702sm6051063ejy.123.2022.03.30.09.16.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Mar 2022 09:16:43 -0700 (PDT)
Message-ID: <c512e765-f411-9305-013b-471a07e7f3ff@blackwall.org>
Date:   Wed, 30 Mar 2022 19:16:42 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH net-next v2] veth: Support bonding events
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Alexandra Winter <wintera@linux.ibm.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        bridge@lists.linux-foundation.org,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>
References: <20220329114052.237572-1-wintera@linux.ibm.com>
 <20220329175421.4a6325d9@kernel.org>
 <d2e45c4a-ed34-10d3-58cd-01b1c19bd004@blackwall.org>
 <c1ec0612-063b-dbfa-e10a-986786178c93@linux.ibm.com>
 <20220330085154.34440715@kernel.org>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220330085154.34440715@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/03/2022 18:51, Jakub Kicinski wrote:
> On Wed, 30 Mar 2022 13:14:12 +0200 Alexandra Winter wrote:
>>>> This patch in no way addresses (2). But then, again, if we put 
>>>> a macvlan on top of a bridge master it will shotgun its GARPS all 
>>>> the same. So it's not like veth would be special in that regard.
>>>>
>>>> Nik, what am I missing?
>>>
>>> If we're talking about macvlan -> bridge -> bond then the bond flap's
>>> notify peers shouldn't reach the macvlan.
> 
> Hm, right. I'm missing a step in my understanding. As you say bridge
> does not seem to be re-broadcasting the event to its master. So how
> does Alexandra catch this kind of an event? :S
> 
> 	case NETDEV_NOTIFY_PEERS:
> 		/* propagate to peer of a bridge attached veth */
> 		if (netif_is_bridge_master(dev)) {  
> 
> IIUC bond will notify with dev == bond netdev. Where is the event with
> dev == br generated?
> 

Good question. :)

>>> Generally broadcast traffic
>>> is quite expensive for the bridge, I have patches that improve on the
>>> technical side (consider ports only for the same bcast domain), but you also
>>> wouldn't want unnecessary bcast packets being sent around. :)
>>> There are setups with tens of bond devices and propagating that to all would be
>>> very expensive, but most of all unnecessary. It would also hurt setups with
>>> a lot of vlan devices on the bridge. There are setups with hundreds of vlans
>>> and hundreds of macvlans on top, propagating it up would send it to all of
>>> them and that wouldn't scale at all, these mostly have IP addresses too.
> 
> Ack.
> 
>>> Perhaps we can enable propagation on a per-port or per-bridge basis, then we
>>> can avoid these walks. That is, make it opt-in.
> 
> Maybe opt-out? But assuming the event is only generated on
> active/backup switch over - when would it be okay to ignore
> the notification?
> 

Let me just clarify, so I'm sure I've not misunderstood you. Do you mean opt-out as in
make it default on? IMO that would be a problem, large scale setups would suddenly
start propagating it to upper devices which would cause a lot of unnecessary bcast.
I meant enable it only if needed, and only on specific ports (second part is not
necessary, could be global, I think it's ok either way). I don't think any setup
which has many upper vlans/macvlans would ever enable this.

>>>>> It also seems difficult to avoid re-bouncing the notifier.  
>>>>
>>>> syzbot will make short work of this patch, I think the potential
>>>> for infinite loops has to be addressed somehow. IIUC this is the 
>>>> first instance of forwarding those notifiers to a peer rather
>>>> than within a upper <> lower device hierarchy which is a DAG.  
>>
>> My concern was about the Hangbin's alternative proposal to notify all
>> bridge ports. I hope in my porposal I was able to avoid infinite loops.
> 
> Possibly I'm confused as to where the notification for bridge master
> gets sent..

IIUC it bypasses the bridge and sends a notify peers for the veth peer so it would
generate a grat arp (inetdev_event -> NETDEV_NOTIFY_PEERS).
