Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1DCC2428B
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 23:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfETVM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 17:12:59 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38415 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbfETVM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 17:12:58 -0400
Received: by mail-qt1-f195.google.com with SMTP id l3so7249165qtj.5
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 14:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0SBQUh01k/D4qTLkUumG0BLJtFQ2+u9yPwRghK7487Q=;
        b=Z55EJ2350oSJOZ4ONH9AB6H90eBHZCqOQAqxvS8Q99DHN1OK1xnDUL6fM09o13cgxD
         C/Ew2Q/p+o3TrrPgZF6E+IeS/LyQXqLO8TliI4DcFpPMBrObmQ2tpdQkeoWBRbmT8qZw
         toi39lwCdyUWH4GtZ7gA+rluxrlVO0QjK7MuY/NQ/svWPK0rhSB9MKVpZd9h1pUwRuEy
         xIPpHHriHQSyy+Z4uCbgwrZUQcytPinQcdQfj1hj8yK4WnQftJjtmG6jW7B7VKL33bZr
         gzZlvaGkwf02LeE9VEUpaAT92zc8gUeYect5Y5af8cVoLd8Pga0ISfDT9g9Pa05aeswr
         A1cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0SBQUh01k/D4qTLkUumG0BLJtFQ2+u9yPwRghK7487Q=;
        b=MDi1jmpENY6RW2mfMo8rMp47Gwou0yXEVsZ4G/67SN02tHw3uG7beiXTPPDddWkECB
         dMyMiaQCyo1DnVp7F5wzC/bmcCH0t6eP6e0nxV4p1syVZrebc4WeMOtVhCcxThtdg3qD
         IwmnEqaTPD3VhcXDP7/RGfJ8/bR/qRoqnj2Ma9KulqVI5unE84c4yrUPa0+/ZPwj0oM8
         4mjPCgw7IYBM0XabkvF0ZlelHwxH5MSuEqWa+Z+TY2u4BZYopvLsweDl5tuhu4YTRhkY
         2ktnp8MOomgiJo1ryw2U4pFbOENtoTZuiUP/yVkx3X7v5kY6EEt17b45mwUg6iGZC2FN
         8t/w==
X-Gm-Message-State: APjAAAXrApN3lNlWWiQxEJeh+P0xH0pYBYXVxIm/P8aNT5jMPyjT9AeK
        zy9cqRo4kFbp12H2tOv+/dG7KQ==
X-Google-Smtp-Source: APXvYqxcNLGu8rNI6j4kLmGj7ZsWv7E597NIEJxYo1ngUXo1RolnqeVmOx/kxk203U3bA3bvpsFtaQ==
X-Received: by 2002:ac8:8b2:: with SMTP id v47mr30502424qth.80.1558386777314;
        Mon, 20 May 2019 14:12:57 -0700 (PDT)
Received: from [192.168.0.124] (24-212-162-241.cable.teksavvy.com. [24.212.162.241])
        by smtp.googlemail.com with ESMTPSA id t30sm11371730qtc.80.2019.05.20.14.12.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 14:12:56 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next 0/3] flow_offload: Re-add per-action
 statistics
To:     Edward Cree <ecree@solarflare.com>, Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Vlad Buslov <vladbu@mellanox.com>
References: <9b137a90-9bfb-9232-b01b-6b6c10286741@solarflare.com>
 <f4fdc1f1-bee2-8456-8daa-fbf65aabe0d4@solarflare.com>
 <cacfe0ec-4a98-b16b-ef30-647b9e50759d@mojatatu.com>
 <f27a6a44-5016-1d17-580c-08682d29a767@solarflare.com>
 <3db2e5bf-4142-de4b-7085-f86a592e2e09@mojatatu.com>
 <17cf3488-6f17-cb59-42a3-6b73f7a0091e@solarflare.com>
 <b4b5e1e7-ebef-5d20-67b6-a3324e886942@mojatatu.com>
 <d70ed72f-69db-dfd0-3c0d-42728dbf45c7@solarflare.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <e0603687-272d-6d41-1c3a-9ea14aa8cfad@mojatatu.com>
Date:   Mon, 20 May 2019 17:12:53 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <d70ed72f-69db-dfd0-3c0d-42728dbf45c7@solarflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-05-20 2:36 p.m., Edward Cree wrote:
> On 20/05/2019 17:29, Jamal Hadi Salim wrote:
>> Maybe dump after each step and it will be easier to see what is
>> happening.
>>
>>> I don't *think* my changes can have caused this, but I'll try a test on a
>>>    vanilla kernel just to make sure the same thing happens there.
>>
>> Possible an offload bug that was already in existence.
> I've now reproduced on vanilla net-next (63863ee8e2f6); the breakage occurs
>   when I run `tc -s actions get action drop index 104`, even _without_ having
>   previously deleted a rule.
> And in a correction to my last email, it turns out this *does* reproduce
>   without offloading (I evidently didn't hit the right sequence to tickle
>   the bug before).
> 

Ok, so the "get" does it. Will try to reproduce when i get some
cycles. Meantime CCing Cong and Vlad.

cheers,
jamal

> # tc -stats filter show dev $vfrep parent ffff:
> filter protocol ip pref 49151 flower chain 0
> filter protocol ip pref 49151 flower chain 0 handle 0x1
>    eth_type ipv4
>    skip_sw
>    in_hw in_hw_count 1
>          action order 1: vlan  push id 100 protocol 802.1Q priority 0 pipe
>           index 3 ref 1 bind 1 installed 7 sec used 7 sec
>          Action statistics:
>          Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>          backlog 0b 0p requeues 0
> 
>          action order 2: mirred (Egress Mirror to device $pf) pipe
>          index 102 ref 1 bind 1 installed 7 sec used 3 sec
>          Action statistics:
>          Sent 306 bytes 3 pkt (dropped 0, overlimits 0 requeues 0)
>          Sent software 0 bytes 0 pkt
>          Sent hardware 306 bytes 3 pkt
>          backlog 0b 0p requeues 0
> 
>          action order 3: vlan  pop pipe
>           index 4 ref 1 bind 1 installed 7 sec used 7 sec
>          Action statistics:
>          Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>          backlog 0b 0p requeues 0
> 
>          action order 4: gact action drop
>           random type none pass val 0
>           index 104 ref 3 bind 2 installed 13 sec used 3 sec
>          Action statistics:
>          Sent 306 bytes 3 pkt (dropped 3, overlimits 0 requeues 0)
>          Sent software 0 bytes 0 pkt
>          Sent hardware 306 bytes 3 pkt
>          backlog 0b 0p requeues 0
> 
> filter protocol arp pref 49152 flower chain 0
> filter protocol arp pref 49152 flower chain 0 handle 0x1
>    eth_type arp
>    skip_sw
>    in_hw in_hw_count 1
>          action order 1: vlan  push id 100 protocol 802.1Q priority 0 pipe
>           index 1 ref 1 bind 1 installed 7 sec used 7 sec
>          Action statistics:
>          Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>          backlog 0b 0p requeues 0
> 
>          action order 2: mirred (Egress Mirror to device $pf) pipe
>          index 101 ref 1 bind 1 installed 7 sec used 5 sec
>          Action statistics:
>          Sent 64 bytes 1 pkt (dropped 0, overlimits 0 requeues 0)
>          Sent software 0 bytes 0 pkt
>          Sent hardware 64 bytes 1 pkt
>          backlog 0b 0p requeues 0
> 
>          action order 3: vlan  pop pipe
>           index 2 ref 1 bind 1 installed 7 sec used 7 sec
>          Action statistics:
>          Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>          backlog 0b 0p requeues 0
> 
>          action order 4: gact action drop
>           random type none pass val 0
>           index 104 ref 3 bind 2 installed 13 sec used 3 sec
>          Action statistics:
>          Sent 370 bytes 4 pkt (dropped 4, overlimits 0 requeues 0)
>          Sent software 0 bytes 0 pkt
>          Sent hardware 370 bytes 4 pkt
>          backlog 0b 0p requeues 0
> 
> # tc -s actions get action drop index 104
> total acts 0
> 
>          action order 1: gact action drop
>           random type none pass val 0
>           index 104 ref 3 bind 2 installed 27 sec used 17 sec
>          Action statistics:
>          Sent 370 bytes 4 pkt (dropped 4, overlimits 0 requeues 0)
>          Sent software 0 bytes 0 pkt
>          Sent hardware 370 bytes 4 pkt
>          backlog 0b 0p requeues 0
> # tc -stats filter show dev $vfrep parent ffff:
> filter protocol ip pref 49151 flower chain 0
> filter protocol ip pref 49151 flower chain 0 handle 0x1
>    eth_type ipv4
>    skip_sw
>    in_hw in_hw_count 1
>          action order 1: vlan  push id 100 protocol 802.1Q priority 0 pipe
>           index 3 ref 1 bind 1 installed 26 sec used 26 sec
>          Action statistics:
>          Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>          backlog 0b 0p requeues 0
> 
>          action order 2: mirred (Egress Mirror to device $pf) pipe
>          index 102 ref 1 bind 1 installed 26 sec used 22 sec
>          Action statistics:
>          Sent 306 bytes 3 pkt (dropped 0, overlimits 0 requeues 0)
>          Sent software 0 bytes 0 pkt
>          Sent hardware 306 bytes 3 pkt
>          backlog 0b 0p requeues 0
> 
>          action order 3: vlan  pop pipe
>           index 4 ref 1 bind 1 installed 26 sec used 26 sec
>          Action statistics:
>          Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>          backlog 0b 0p requeues 0
> 
> filter protocol arp pref 49152 flower chain 0
> filter protocol arp pref 49152 flower chain 0 handle 0x1
>    eth_type arp
>    skip_sw
>    in_hw in_hw_count 1
>          action order 1: vlan  push id 100 protocol 802.1Q priority 0 pipe
>           index 1 ref 1 bind 1 installed 27 sec used 27 sec
>          Action statistics:
>          Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>          backlog 0b 0p requeues 0
> 
>          action order 2: mirred (Egress Mirror to device $pf) pipe
>          index 101 ref 1 bind 1 installed 27 sec used 17 sec
>          Action statistics:
>          Sent 256 bytes 4 pkt (dropped 0, overlimits 0 requeues 0)
>          Sent software 0 bytes 0 pkt
>          Sent hardware 256 bytes 4 pkt
>          backlog 0b 0p requeues 0
> 
>          action order 3: vlan  pop pipe
>           index 2 ref 1 bind 1 installed 27 sec used 27 sec
>          Action statistics:
>          Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>          backlog 0b 0p requeues 0
> 
> #
> 

