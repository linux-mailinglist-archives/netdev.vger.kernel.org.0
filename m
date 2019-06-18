Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18DAF4A99E
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 20:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729981AbfFRSQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 14:16:27 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45500 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729810AbfFRSQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 14:16:27 -0400
Received: by mail-pf1-f196.google.com with SMTP id r1so8117595pfq.12
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 11:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+/rSdQh/PMwCDGmPmVEjrWjzzW6F7gT5fWsagIGnv4U=;
        b=jYbcf/zKgFtITu40rF5qoBpNShy8B1/mFvE/FP5AlOXcyd+Ehh6U4ZTLfRukJvaf7W
         TjaLL4KkC3HU4NggFpGDFqrI9EhGGDoWwKHDx3W8uTmP7m2BJn6/bL0maNtriIL4c+7A
         hvHIgvSYemn2CtPk9DCzvF2o2VBQAsMrPr/Zkhqd/LbYyHwR2BhJV8J6GvWx52ziiJHq
         9KJZU2tUjh+kdG+NNilIepiMt7JjaoCETCzsPs6GZegchQSFG3zaD5BGmfPiTD6ccQzw
         vtDEB2puAnwAbFHS5+83onQ1BJbDEt/zKnJa9F2lmYVCUpQ6C8JGaBg9oCs/diG/FSnu
         odJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=+/rSdQh/PMwCDGmPmVEjrWjzzW6F7gT5fWsagIGnv4U=;
        b=cFLA1BTTKNqnFF+blRxyo37DNqQRoHKtursYgK8DqJkRcl3zLDCzojnWZPyhBh4VUv
         sm6rt5NDiCldDrOYObJEnMgiYBXWZKeUwVqIqYp3x6eEY/zHtmjqwCloM9B1VoFZUP7z
         q7eoz/mr4gzthcxibE2cshj/Y2fK+sYZwEE/lFk47iJ3hOgAPN9GAaUfJ+gPtz6zs1ia
         ndhEOGgFM9EKs/mdo6P3f/b6AmlFGQ7yfTRyVWDQGkwnN/G0aAHCsnQyD/x7POWzqHGb
         I2MhHTlfoUTnaVw0Nw5e83mfdOis9hG5u9/LoSx1VaCuB4mU1J7EPVHovD25pDtQ1ajs
         rK2Q==
X-Gm-Message-State: APjAAAXKDdVoOo2qfoj7gbsc0wAW5IjsVR+5wAQM7kbtnLL19S+Bz6S5
        wHEZtFqODKoWzjs646TyoYIf5bPY
X-Google-Smtp-Source: APXvYqx4nhhrJlGvbYGHMQjy40y90oqeqrKMqpYTezSE465SqZosr83NwZ1HcnZXeOW/1yy+TtP5fA==
X-Received: by 2002:a63:56:: with SMTP id 83mr3952282pga.145.1560881785998;
        Tue, 18 Jun 2019 11:16:25 -0700 (PDT)
Received: from [10.67.49.123] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id n89sm6474970pjc.0.2019.06.18.11.16.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 11:16:25 -0700 (PDT)
Subject: Re: [RFC PATCH 0/2] enable broadcom tagging for bcm531x5 switches
To:     Benedikt Spranger <b.spranger@linutronix.de>,
        netdev@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
References: <20190618175712.71148-1-b.spranger@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <bc932af1-d957-bd40-fa65-ee05b9478ec7@gmail.com>
Date:   Tue, 18 Jun 2019 11:16:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190618175712.71148-1-b.spranger@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/18/19 10:57 AM, Benedikt Spranger wrote:
> Hi,
> 
> while puting a Banana Pi R1 board into operation I faced network hickups
> and get into serious trouble from my coworkers:
> 
> Banana Pi network setup:
> PC (eth1) <--> BPi R1 (wan) / BPi R1 (lan4) <--> DUT (eth0)
> 10.0.32.1      10.0.32.2      172.16.0.1         172.16.0.2
> ---8<---
> #! /bin/bash
> 
> # create VLANs
> ip link add link eth0 name eth0.1 type vlan id 1
> ip link add link eth0 name eth0.100 type vlan id 100
> 
> # create bridges
> ip link add br0 type bridge
> ip link set dev br0 type bridge vlan_filtering 1
> 
> ip link add br1 type bridge
> ip link set dev br1 type bridge vlan_filtering 1
> 
> # add interfaces to bridges
> ip link set lan1 master br0
> ip link set lan2 master br0
> ip link set lan3 master br0
> ip link set lan4 master br0
> ip link set eth0.100 master br0
> 
> ip link set wan master br1
> 
> # adjust tagging
> bridge vlan add dev lan1 vid 100 pvid untagged
> bridge vlan add dev lan2 vid 100 pvid untagged
> bridge vlan add dev lan3 vid 100 pvid untagged
> bridge vlan add dev lan4 vid 100 pvid untagged
> 
> bridge vlan del dev lan1 vid 1
> bridge vlan del dev lan2 vid 1
> bridge vlan del dev lan3 vid 1
> bridge vlan del dev lan4 vid 1
> 
> # set IPs
> ip addr add 10.0.32.2/24 dev eth0.1
> ip addr add 172.16.0.1/24 dev br0
> 
> # up and run
> ip link set eth0 up
> ip link set eth0.1 up
> ip link set eth0.100 up
> 
> ip link set br0 up
> ip link set br1 up
> 
> ip link set wan up
> 
> ip link set lan1 up
> ip link set lan2 up
> ip link set lan3 up
> ip link set lan4 up
> ---8<---
> 
> While trying to ping a non existing host 10.0.32.111 result in
> doublication of ARP broadcasts:
> 
> On the BPi R1:
> # tshark -i br0
>     1 8.157471671 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111?
>  Tell 10.0.32.1
>     2 9.167563213 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111?
>  Tell 10.0.32.1
>     3 10.191703047 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111
> ? Tell 10.0.32.1
>     4 11.215905797 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111
> ? Tell 10.0.32.1
>     5 12.243932964 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111
> ? Tell 10.0.32.1
>     6 13.264033298 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111
> ? Tell 10.0.32.1
> 
> # tshark -i wan0
>     1 8.157421295 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111?
>  Tell 10.0.32.1
>     2 9.167510087 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111?
>  Tell 10.0.32.1
>     3 10.191649213 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111
> ? Tell 10.0.32.1
>     4 11.215856838 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111
> ? Tell 10.0.32.1
>     5 12.243881922 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111
> ? Tell 10.0.32.1
>     6 13.263981506 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111
> ? Tell 10.0.32.1
> 
> On the PC:
> # tshark -i eth1
>   116 272.660717059 DavicomS_43:18:fc → Broadcast    ARP 42 Who has 10.0.32.111? Tell 10.0.32.1
>   117 272.661062292 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111? Tell 10.0.32.1
>   118 273.670690338 DavicomS_43:18:fc → Broadcast    ARP 42 Who has 10.0.32.111? Tell 10.0.32.1
>   119 273.671058605 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111? Tell 10.0.32.1
>   120 274.694720511 DavicomS_43:18:fc → Broadcast    ARP 42 Who has 10.0.32.111? Tell 10.0.32.1
>   121 274.695250723 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111? Tell 10.0.32.1
>   122 275.718813538 DavicomS_43:18:fc → Broadcast    ARP 42 Who has 10.0.32.111? Tell 10.0.32.1
>   123 275.719285852 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111? Tell 10.0.32.1
>   124 276.746729795 DavicomS_43:18:fc → Broadcast    ARP 42 Who has 10.0.32.111? Tell 10.0.32.1
>   125 276.747236341 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111? Tell 10.0.32.1
>   126 277.766722429 DavicomS_43:18:fc → Broadcast    ARP 42 Who has 10.0.32.111? Tell 10.0.32.1
>   127 277.767233098 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111? Tell 10.0.32.1
> 
> Choosing between network disturbance by mirrored broadcast packages (and angry
> coworkers) or lack of multicast, I choose the later. 

How is that a problem for other machines? Does that lead to some kind of
broadcast storm because there are machines that keep trying to respond
to ARP solicitations?

The few aspects that bother me, not in any particular order, are that:

- you might be able to not change anything and just get away with the
one line patch below that sets skb->offload_fwd_mark to 1 to indicate to
the bridge, not to bother with sending a copy of the packet, since the
HW took care of that already

- the patch from me that you included was part of a larger series that
also addressed multicast while in management mode, such we would not
have to chose like you did, have you tested it, did it somehow not work?

- you have not copied the DSA maintainers on all of the patches, so you
get a C grade for your patch submission

diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index 9c3114179690..9169b63a89e3 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -140,6 +140,8 @@ static struct sk_buff *brcm_tag_rcv_ll(struct
sk_buff *skb,
        /* Remove Broadcom tag and update checksum */
        skb_pull_rcsum(skb, BRCM_TAG_LEN);

+       skb->offload_fwd_mark = 1;
+
        return skb;
 }
 #endif


-- 
Florian
