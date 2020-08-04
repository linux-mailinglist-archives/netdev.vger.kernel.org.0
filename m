Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E22D23BD92
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 17:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729284AbgHDPvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 11:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729113AbgHDPvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 11:51:03 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E1AC06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 08:51:03 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id s16so31235113qtn.7
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 08:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GSyS0rrrzkHwrudb4BklzjOkgFWzjfR8PsMwucCFfyE=;
        b=pYJ3/InI+YCmlFg6XkTDBTvS66mp5wEWVOOnxGItH1ll+W8dl+ntyuqOLUPxWWGsby
         uk+9rDeVzyjfzlF2ZRaOOURyvaSmeQD7YggHtJzclXyZfKdpsllhZQIFGkjiBNGuEFhu
         K0sbnChHElSQFgBCCi+Ducgy2+OoogGiokMnZG0MTB8WyZVdXil2jOCZHtlRD1W6RTfd
         JlW3EpLJzLjxuExE7VYURRIgcDEEnnVslpdPaOpQcqcltZKrzvFsh1yUr0I8x4iEyInA
         V/EMdNJqjcqrWpizFIQDyqBjn6u/z6NhoEXSGI54RybOopumetyLl5Qk01+chONpVNAM
         aCrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GSyS0rrrzkHwrudb4BklzjOkgFWzjfR8PsMwucCFfyE=;
        b=tEXGVIrSRvEXRo/Wx8lifGP2+fQtT4LmbbYJPI0siVaz7YHV+dvvagRoEzo6lpkkhU
         zhSNgSb/lDsTQWMQRtMHSvkxQx0vVMPDM1SycfLKp7qBjmrMCXh0n7BnWv67KhpcAAgv
         /sxoM24vk4Rxl5DRX9oax3oBTdHEYdNOIUp4OoX5r+sViXtoJ8GlW7NsOUknPFPWIOan
         Ox6dN9NYzUjqoKANIrcgoHKRNDC1R8/X3ABSKM0eumrkaFDrtRABIFfRSe4BOLyb4Fus
         q5L8xt8YCqgNyB+QmsDXN13oTNLqK7v1aboU+AzO/VRXfnwAwuKIkbvN1t+TCWob50Cr
         OYRw==
X-Gm-Message-State: AOAM533e28a2VUgHe+6w2L+T4N45u7yAi7+tce5MHInGIQFjZXq8czMS
        sETNPexpIX3SwJv+0Qa/F7vzGEVy
X-Google-Smtp-Source: ABdhPJyHRy6rOWRHgbX+XtNYeSCbvYdxrWlmgYMrSNIebZb9C6BPJyKDE+Z3Vw2f9+Brgs29PatDEw==
X-Received: by 2002:ac8:6bce:: with SMTP id b14mr22226752qtt.255.1596556262073;
        Tue, 04 Aug 2020 08:51:02 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id n184sm22777995qkn.49.2020.08.04.08.51.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2020 08:51:01 -0700 (PDT)
Subject: Re: AW: AW: PROBLEM: (DSA/Microchip): 802.1Q-Header lost on
 KSZ9477-DSA ingress without bridge
To:     "Gaube, Marvin (THSE-TL1)" <Marvin.Gaube@tesat.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ad09e947263c44c48a1d2c01bcb4d90a@BK99MAIL02.bk.local>
 <c531bf92-dd7e-0e69-8307-4c4f37cb2d02@gmail.com>
 <f8465c4b8db649e0bb5463482f9be96e@BK99MAIL02.bk.local>
 <b5ad26fe-e6c3-e771-fb10-77eecae219f6@gmail.com>
 <020a80686edc48d5810e1dbf884ae497@BK99MAIL02.bk.local>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <800bbbe8-2c51-114c-691b-137fd96a6ccd@gmail.com>
Date:   Tue, 4 Aug 2020 08:51:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <020a80686edc48d5810e1dbf884ae497@BK99MAIL02.bk.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"I looked into it deeper, the driver does rxvlan offloading."

Is this part of the driver upstream or are you using a vendor tree from
Freescale which has that change included?

On 8/4/2020 7:14 AM, Gaube, Marvin (THSE-TL1) wrote:
> Hello,
> I looked into it deeper, the driver does rxvlan offloading. 
> By disabling it manually trough ethtool, the behavior becomes as expected.
> 
> I've taken "net: dsa: sja1105: disable rxvlan offload for the DSA master" from (https://lore.kernel.org/netdev/20200512234921.25460-1-olteanv@gmail.com/) and also applied it to the KSZ9477-Driver, which fixes the problem.
> It's probably a workaround, but fixes the VLAN behavior for now. I would suggest also applying "ds->disable_master_rxvlan = true;" to KSZ9477 after the mentioned patch is merged.
> 
> Best Regards
> Marvin Gaube
> 
> -----Ursprüngliche Nachricht-----
> Von: Gaube, Marvin (THSE-TL1) 
> Gesendet: Donnerstag, 30. Juli 2020 11:35
> An: 'Florian Fainelli' <f.fainelli@gmail.com>; Woojung Huh <woojung.huh@microchip.com>; Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
> Cc: netdev@vger.kernel.org
> Betreff: AW: AW: PROBLEM: (DSA/Microchip): 802.1Q-Header lost on KSZ9477-DSA ingress without bridge
> 
> Hello,
> the following was tested:
> 
> ip link add name br0 type bridge
> echo 1 >/sys/class/net/br0/bridge/vlan_filtering
> ip link set dev lan1 master br0
> ip link set dev lan1 up
> ip link set dev br0 up
> bridge vlan show
>> port              vlan-id  
>> lan1              1 PVID Egress Untagged
>> br0               1 PVID Egress Untagged
> tcpdump -i br0 -e
>> de:1c:87:(..) (oui Unknown) > 33:33:00:01:00:06 (oui Unknown), ethertype IPv6 (0x86dd), length 308 ...
> bridge vlan del dev lan1 vid 1
> bridge vlan add dev lan1 vid 21 tagged
> bridge vlan show
>> port              vlan-id  
>> lan1              21
>> br0               1 PVID Egress Untagged
> tcpdump -i br0 -e
>> Nothing. The frames with VLAN 21 ingress should appear here
> bridge vlan del dev lan1 vid 21
> bridge vlan add dev lan1 vid 25 pvid
> bridge vlan show
>> port              vlan-id  
>> lan1              25 PVID
>> br0               1 PVID Egress Untagged
> tcpdump -i br0 -e
>> de:1c:87:(..) (oui Unknown) > 33:33:00:01:00:06 (oui Unknown), ethertype 802.1Q (0x8100), length 312: vlan 25, p 0, ethertype IPv6 ...
> 
> When I tcpdump onto eth1, I see the packets with 0x8100 vid 21 all the time.
> 
> The MAC driver is freescale/fec on imx7d (compatible string in device tree: "fsl,imx7d-fecfsl,imx6sx-fec"). 
> It seems, that it not sets NETIF_F_HW_VLAN_CTAG_FILTER.
> 
> Best Regards
> Marvin Gaube
> 
> -----Ursprüngliche Nachricht-----
> Von: Florian Fainelli <f.fainelli@gmail.com> 
> Gesendet: Mittwoch, 29. Juli 2020 17:03
> An: Gaube, Marvin (THSE-TL1) <Marvin.Gaube@tesat.de>; Woojung Huh <woojung.huh@microchip.com>; Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
> Cc: netdev@vger.kernel.org
> Betreff: Re: AW: PROBLEM: (DSA/Microchip): 802.1Q-Header lost on KSZ9477-DSA ingress without bridge
> 
> 
> 
> On 7/29/2020 7:49 AM, Gaube, Marvin (THSE-TL1) wrote:
>> Hello,
>> I just tried a VLAN-enabled bridge.
>> All ingress packets definitely have the 802.1q-Tag on CPU ingress, double-checked that. Tried again with VLAN21-Tagged frames coming in the physical port.
>> It seems that the bridge also handles all packets from lan1 as untagged. When I add lan1 to the bridge, the following happens:
>>
>> If lan1 has (only) VLAN 21 tagged on the bridge, no packet appears.
>> As soon as I add an untagged/pvid VLAN to lan1 on the bridge, all packets appear on the bridge with whichever VLAN I added.
>> I checked simultaneously with the CPU Ingress-Port (eth1), the same packets had Ethertype 8100 with VLAN 21 when they entered CPU.
> 
> Can you share the commands you use to set-up your bridge with VLAN filtering and VLAN21 added to the VLAN database of the bridge for lan1?
> 
>>
>> With Switchport 1, the physical switch port of the KSZ is meant.
> 
> OK.
> 
>>
>> About the last thing: VLAN tagged frames are definitively passed to the CPU.
>> If I "tcpdump -xx" onto eth1, I see for example "(12 byte MAC) 8100 0015 86dd (IPv6-Payload)". The tail tag is also visible.
>> Exactly the same frame appears on lan1 as "(12 byte MAC) 86dd (IPv6-Payload)", so the 802.1q-Header is present on CPU ingress.
>> Therefore the VLAN tag probably is lost between eth1 (Ingress) and the respective DSA-Interface, and is not filtered on the KSZ9477.
> 
> What Ethernet controller driver is eth1, does it support VLAN receive filter (NETIF_F_HW_VLAN_CTAG_FILTER)?
> 
>>
>> Best Regards
>> Marvin Gaube
>>
>> -----Ursprüngliche Nachricht-----
>> Von: Florian Fainelli <f.fainelli@gmail.com>
>> Gesendet: Mittwoch, 29. Juli 2020 15:48
>> An: Gaube, Marvin (THSE-TL1) <Marvin.Gaube@tesat.de>; Woojung Huh 
>> <woojung.huh@microchip.com>; Microchip Linux Driver Support 
>> <UNGLinuxDriver@microchip.com>
>> Cc: netdev@vger.kernel.org
>> Betreff: Re: PROBLEM: (DSA/Microchip): 802.1Q-Header lost on 
>> KSZ9477-DSA ingress without bridge
>>
>>
>>
>> On 7/28/2020 11:05 PM, Gaube, Marvin (THSE-TL1) wrote:
>>> Summary: 802.1Q-Header lost on KSZ9477-DSA ingress without bridge
>>> Keywords: networking, dsa, microchip, 802.1q, vlan Full description:
>>>
>>> Hello,
>>> we're trying to get 802.1Q-Tagged Ethernet Frames through an KSZ9477 DSA-enabled switch without creating a bridge on the kernel side.
>>
>> Does it work if you have a bridge that is VLAN aware though? If it does, this would suggest that the default VLAN behavior without a bridge is too restrictive and needs changing.
>>
>>> Following setup:
>>> Switchport 1 <-- KSZ9477 --> eth1 (CPU-Port) <---> lan1
>>
>> This representation is confusing, is switchport 1 a network device or is this meant to be physical switch port number of 1 of the KSZ9477?
>>
>>>
>>> No bridge is configured, only the interface directly. Untagged packets are working without problems. The Switch uses the ksz9477-DSA-Driver with Tail-Tagging ("DSA_TAG_PROTO_KSZ9477").
>>> When sending packets with 802.1Q-Header (tagged VLAN) into the Switchport, I see them including the 802.1Q-Header on eth1.
>>> They also appear on lan1, but with the 802.1Q-Header missing.
>>> When I create an VLAN-Interface over lan1 (e.g. lan1.21), nothing arrives there.
>>> The other way around, everything works fine: Packets transmitted into lan1.21 are appearing in 802.1Q-VLAN 21 on the Switchport 1.
>>>
>>> I assume that is not the intended behavior.
>>> I haven't found an obvious reason for this behavior yet, but I suspect the VLAN-Header gets stripped of anywhere around "dsa_switch_rcv" in net/dsa/dsa.c or "ksz9477_rcv" in net/dsa/tag_ksz.c.
>>
>> Not sure how though, ksz9477_rcv() only removes the trail tag, this should leave any header intact. It seems to me that the switch is incorrectly configured and is not VLAN aware at all, nor passing VLAN tagged frames through on ingress to CPU when it should.
>> --
>> Florian
>>
>> ________________________________
>>
>> Tesat-Spacecom GmbH & Co. KG
>> Sitz: Backnang; Registergericht: Amtsgericht Stuttgart HRA 270977 
>> Persoenlich haftender Gesellschafter: Tesat-Spacecom 
>> Geschaeftsfuehrungs GmbH;
>> Sitz: Backnang; Registergericht: Amtsgericht Stuttgart HRB 271658;
>> Geschaeftsfuehrung: Dr. Marc Steckling, Kerstin Basche, Ralf 
>> Zimmermann
>>
>> [banner]
>>
> 
> --
> Florian
> 

-- 
Florian
