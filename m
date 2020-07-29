Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA63A232126
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 17:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgG2PDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 11:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgG2PDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 11:03:02 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3140C061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 08:03:02 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id e8so14369910pgc.5
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 08:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0UrBcCC/qo6N5OC4VZGsONSElUUvbsgexErDfLJaLds=;
        b=PIxEO/hNVu0oEQXYlkxKz8KJpMEe7CLksCXv7bd0zzv9ZBmC6VXw9nzCdNwOGIvJlM
         vEgtwdG87zGIPLOL4E50FpngKINb9wCbHOWtfzWDy2NLux45zARG2JG+Msln0PPd886l
         bTt6YY6L5TnT6NxPS0jtvdqOXnebXFJBINaKlNuOTq8a6eBCOSTNgArGgD2iKpdW7uQX
         tbvScUCogjLbyyBLm0zodSbPrsc7JPP7LwTcrwpaZRiThkrmOMldZcpa4//k1r85thIe
         ZM6N8YxUrwR2M65kmKDBFYz/0TRqxh/vAtDpmvyCtuYgZQF3+7H6/3dlsSN3cNVOsT4p
         32Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0UrBcCC/qo6N5OC4VZGsONSElUUvbsgexErDfLJaLds=;
        b=BtWcQbiHCNStWJlib4Ab9+wkJ4lIyo6KjywM7HliRs2lRdQIiG88C/q0eyTY7EXtvj
         Meb+2C5NYTzf2jUsx1GlaT7vx0GHak06+u4vlf1Z/EyFtIHPoWsP3OayKAi0Txtnbp+B
         26KnUjR1gE1njIKWoot7/m5AXMslkdhUzx+3ZHZEH9gND6WkNC2MDmXE9IapomNJEb7Q
         a+xmecGCXQGFkoOt1Kn5F+h8nEU5GA3CPR+0adFrLV1HsugjyswMZ2oYPh0i/Qw+Iiri
         HvyLLp3u7u0a3n5UTujNDu0ps639lwe+v8yzTUk3OqWEJ9L3YxG1napJtgdzmeyAD+QE
         jvGg==
X-Gm-Message-State: AOAM533i1NcvOcfdMKo57R/AXvGp9JG648nVrBufLdFUvnuJ7oW2MAv7
        6LMoqVO9mmf+LYpRtGKAc8GGaHqi
X-Google-Smtp-Source: ABdhPJywkWwrnYcL2gOLtnjTd2ZQAd3UlQ8UhKzMW1hz3GEFxmSwRpqTxgagb2zJur0p8y2ZABP03g==
X-Received: by 2002:a63:b919:: with SMTP id z25mr30208167pge.416.1596034981434;
        Wed, 29 Jul 2020 08:03:01 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b185sm2673372pfa.148.2020.07.29.08.02.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2020 08:03:00 -0700 (PDT)
Subject: Re: AW: PROBLEM: (DSA/Microchip): 802.1Q-Header lost on KSZ9477-DSA
 ingress without bridge
To:     "Gaube, Marvin (THSE-TL1)" <Marvin.Gaube@tesat.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ad09e947263c44c48a1d2c01bcb4d90a@BK99MAIL02.bk.local>
 <c531bf92-dd7e-0e69-8307-4c4f37cb2d02@gmail.com>
 <f8465c4b8db649e0bb5463482f9be96e@BK99MAIL02.bk.local>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b5ad26fe-e6c3-e771-fb10-77eecae219f6@gmail.com>
Date:   Wed, 29 Jul 2020 08:02:55 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f8465c4b8db649e0bb5463482f9be96e@BK99MAIL02.bk.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/29/2020 7:49 AM, Gaube, Marvin (THSE-TL1) wrote:
> Hello,
> I just tried a VLAN-enabled bridge.
> All ingress packets definitely have the 802.1q-Tag on CPU ingress, double-checked that. Tried again with VLAN21-Tagged frames coming in the physical port.
> It seems that the bridge also handles all packets from lan1 as untagged. When I add lan1 to the bridge, the following happens:
> 
> If lan1 has (only) VLAN 21 tagged on the bridge, no packet appears.
> As soon as I add an untagged/pvid VLAN to lan1 on the bridge, all packets appear on the bridge with whichever VLAN I added.
> I checked simultaneously with the CPU Ingress-Port (eth1), the same packets had Ethertype 8100 with VLAN 21 when they entered CPU.

Can you share the commands you use to set-up your bridge with VLAN
filtering and VLAN21 added to the VLAN database of the bridge for lan1?

> 
> With Switchport 1, the physical switch port of the KSZ is meant.

OK.

> 
> About the last thing: VLAN tagged frames are definitively passed to the CPU.
> If I "tcpdump -xx" onto eth1, I see for example "(12 byte MAC) 8100 0015 86dd (IPv6-Payload)". The tail tag is also visible.
> Exactly the same frame appears on lan1 as "(12 byte MAC) 86dd (IPv6-Payload)", so the 802.1q-Header is present on CPU ingress.
> Therefore the VLAN tag probably is lost between eth1 (Ingress) and the respective DSA-Interface, and is not filtered on the KSZ9477.

What Ethernet controller driver is eth1, does it support VLAN receive
filter (NETIF_F_HW_VLAN_CTAG_FILTER)?

> 
> Best Regards
> Marvin Gaube
> 
> -----Ursprüngliche Nachricht-----
> Von: Florian Fainelli <f.fainelli@gmail.com>
> Gesendet: Mittwoch, 29. Juli 2020 15:48
> An: Gaube, Marvin (THSE-TL1) <Marvin.Gaube@tesat.de>; Woojung Huh <woojung.huh@microchip.com>; Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
> Cc: netdev@vger.kernel.org
> Betreff: Re: PROBLEM: (DSA/Microchip): 802.1Q-Header lost on KSZ9477-DSA ingress without bridge
> 
> 
> 
> On 7/28/2020 11:05 PM, Gaube, Marvin (THSE-TL1) wrote:
>> Summary: 802.1Q-Header lost on KSZ9477-DSA ingress without bridge
>> Keywords: networking, dsa, microchip, 802.1q, vlan Full description:
>>
>> Hello,
>> we're trying to get 802.1Q-Tagged Ethernet Frames through an KSZ9477 DSA-enabled switch without creating a bridge on the kernel side.
> 
> Does it work if you have a bridge that is VLAN aware though? If it does, this would suggest that the default VLAN behavior without a bridge is too restrictive and needs changing.
> 
>> Following setup:
>> Switchport 1 <-- KSZ9477 --> eth1 (CPU-Port) <---> lan1
> 
> This representation is confusing, is switchport 1 a network device or is this meant to be physical switch port number of 1 of the KSZ9477?
> 
>>
>> No bridge is configured, only the interface directly. Untagged packets are working without problems. The Switch uses the ksz9477-DSA-Driver with Tail-Tagging ("DSA_TAG_PROTO_KSZ9477").
>> When sending packets with 802.1Q-Header (tagged VLAN) into the Switchport, I see them including the 802.1Q-Header on eth1.
>> They also appear on lan1, but with the 802.1Q-Header missing.
>> When I create an VLAN-Interface over lan1 (e.g. lan1.21), nothing arrives there.
>> The other way around, everything works fine: Packets transmitted into lan1.21 are appearing in 802.1Q-VLAN 21 on the Switchport 1.
>>
>> I assume that is not the intended behavior.
>> I haven't found an obvious reason for this behavior yet, but I suspect the VLAN-Header gets stripped of anywhere around "dsa_switch_rcv" in net/dsa/dsa.c or "ksz9477_rcv" in net/dsa/tag_ksz.c.
> 
> Not sure how though, ksz9477_rcv() only removes the trail tag, this should leave any header intact. It seems to me that the switch is incorrectly configured and is not VLAN aware at all, nor passing VLAN tagged frames through on ingress to CPU when it should.
> --
> Florian
> 
> ________________________________
> 
> Tesat-Spacecom GmbH & Co. KG
> Sitz: Backnang; Registergericht: Amtsgericht Stuttgart HRA 270977
> Persoenlich haftender Gesellschafter: Tesat-Spacecom Geschaeftsfuehrungs GmbH;
> Sitz: Backnang; Registergericht: Amtsgericht Stuttgart HRB 271658;
> Geschaeftsfuehrung: Dr. Marc Steckling, Kerstin Basche, Ralf Zimmermann
> 
> [banner]
> 

-- 
Florian
