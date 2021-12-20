Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA6547B019
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 16:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239459AbhLTPZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 10:25:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240226AbhLTPYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 10:24:35 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB435C08E844;
        Mon, 20 Dec 2021 07:05:14 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id s1so20784962wrg.1;
        Mon, 20 Dec 2021 07:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=WKsItc8qb4NH+0pTbL6ZOgydloP+OoL+KHA/3JDZDo0=;
        b=iJvHwH1XBbQ6J+JV9gsPa2NlYacxsJrx7qwcqNpdeKciNQie8pnKX/uGVx2Fhyw1rK
         NJAnp4BD6MjJVmic82z/7BKMErHa97Y6YBLSE9PMEfF9RnWTR0M79MzWEaltygSyOxdp
         BTc4NAxvMmAXcZI4QODr8K0Rb0wI+xlwp0OcaHXTFsGiCKF/YOzdOGdv0FisG6q51anj
         oRNuFyz1KS/tSim/98VmhMX3pW6/zJb2NvzXQnEk73q5dukSOZKQ6Ei43mgayIFs5VnF
         9ho5XLi4I2Gc6sv1ZVaRpvhKeT5O7QPBaAohvjzSR+SzT3bOPtfjCuIfYQ1U/P1qa/Tv
         Z3/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=WKsItc8qb4NH+0pTbL6ZOgydloP+OoL+KHA/3JDZDo0=;
        b=g+3YqKK+pwv3Q4cCgkFl1a5wig1hITM/++J7hHK+1u1EIhWfXoww7bVh8vDkSx+rr8
         mpTKCVsRK2L+W7qX8KLzk499mh3OqJKPt8ZnOWuz69of5q0dhzpcXJIk2FE/hRKPak7+
         FtVIYrxH2oVhIHbl0fCHBKNpQTytuHUVTvtE+K8z0cFb/loEax/JF+8CtiJn11IQy/4v
         ZMqLpCDbK36QLG7E7n/3bzVdtYslqAP9ilh9aoD40JFveABi3yFDweWSNIx5ldqEMErG
         ljy+qamwqgZ+wbE5IwCqmU03s517G/iHR4xD5z5PXBDKP9no/xbsvQjbVjQdciO17IVo
         HcrQ==
X-Gm-Message-State: AOAM532NF+JnmNwQPB4UybY6aNjrsMrSq0rMzBRLMguIoHsIu0tfnyxh
        ECUASlsV8nPmLF6vzRl2VvB5Vah8YTfWRw==
X-Google-Smtp-Source: ABdhPJxy6zhA15CkJTGApJc/tuRtpWLksGUbi0ez56txyiDeNQLMXVZB8Wnsn47imjzQ3FxR2GO96Q==
X-Received: by 2002:a5d:4b87:: with SMTP id b7mr13452325wrt.586.1640012713188;
        Mon, 20 Dec 2021 07:05:13 -0800 (PST)
Received: from [10.0.0.4] ([37.165.147.173])
        by smtp.gmail.com with ESMTPSA id g5sm9746744wru.48.2021.12.20.07.05.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Dec 2021 07:05:12 -0800 (PST)
Subject: Re: [PATCH V2] net: bonding: Add support for IPV6 ns/na
To:     =?UTF-8?B?5a2Z5a6I6ZGr?= <sunshouxin@chinatelecom.cn>,
        Eric Dumazet <eric.dumazet@gmail.com>, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        huyd12@chinatelecom.cn
References: <1639141691-3741-1-git-send-email-sunshouxin@chinatelecom.cn>
 <dad92c6d-d5b2-38a9-a8ad-e36a6a987a79@gmail.com>
 <eb4c1dfe-d7c6-3011-e550-7498ccd023d7@chinatelecom.cn>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <5db962ec-4953-c25a-5f9e-0f18003e37b3@gmail.com>
Date:   Mon, 20 Dec 2021 07:05:10 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <eb4c1dfe-d7c6-3011-e550-7498ccd023d7@chinatelecom.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/19/21 5:57 PM, 孙守鑫 wrote:
>
> 在 2021/12/14 16:05, Eric Dumazet 写道:
>>
>> On 12/10/21 5:08 AM, Sun Shouxin wrote:
>>> Since ipv6 neighbor solicitation and advertisement messages
>>> isn't handled gracefully in bonding6 driver, we can see packet
>>> drop due to inconsistency bewteen mac address in the option
>>> message and source MAC .
>>>
>>> Another examples is ipv6 neighbor solicitation and advertisement
>>> messages from VM via tap attached to host brighe, the src mac
>>> mighe be changed through balance-alb mode, but it is not synced
>>> with Link-layer address in the option message.
>>>
>>> The patch implements bond6's tx handle for ipv6 neighbor
>>> solicitation and advertisement messages.
>>>
>>>             Border-Leaf
>>>             /        \
>>>                /          \
>>>             Tunnel1    Tunnel2
>>>              /              \
>>>                 /                \
>>>           Leaf-1--Tunnel3--Leaf-2
>>>             \                /
>>>              \              /
>>>               \            /
>>>                \          /
>>>                NIC1    NIC2
>>>             \      /
>>>             server
>>>
>>> We can see in our lab the Border-Leaf receives occasionally
>>> a NA packet which is assigned to NIC1 mac in ND/NS option
>>> message, but actaully send out via NIC2 mac due to tx-alb,
>>> as a result, it will cause inconsistency between MAC table
>>> and ND Table in Border-Leaf, i.e, NIC1 = Tunnel2 in ND table
>>> and  NIC1 = Tunnel1 in mac table.
>>>
>>> And then, Border-Leaf starts to forward packet destinated
>>> to the Server, it will only check the ND table entry in some
>>> switch to encapsulate the destination MAC of the message as
>>> NIC1 MAC, and then send it out from Tunnel2 by ND table.
>>> Then, Leaf-2 receives the packet, it notices the destination
>>> MAC of message is NIC1 MAC and should forword it to Tunne1
>>> by Tunnel3.
>>>
>>> However, this traffic forward will be failure due to split
>>> horizon of VxLAN tunnels.
>>>
>>> Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
>>> Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
>>> ---
>>>   drivers/net/bonding/bond_alb.c | 131 
>>> +++++++++++++++++++++++++++++++++++++++++
>>>   1 file changed, 131 insertions(+)
>>>
>>> diff --git a/drivers/net/bonding/bond_alb.c 
>>> b/drivers/net/bonding/bond_alb.c
>>> index 533e476..afa386b 100644
>>> --- a/drivers/net/bonding/bond_alb.c
>>> +++ b/drivers/net/bonding/bond_alb.c
>>> @@ -22,6 +22,7 @@
>>>   #include <asm/byteorder.h>
>>>   #include <net/bonding.h>
>>>   #include <net/bond_alb.h>
>>> +#include <net/ndisc.h>
>>>     static const u8 mac_v6_allmcast[ETH_ALEN + 2] __long_aligned = {
>>>       0x33, 0x33, 0x00, 0x00, 0x00, 0x01
>>> @@ -1269,6 +1270,119 @@ static int alb_set_mac_address(struct 
>>> bonding *bond, void *addr)
>>>       return res;
>>>   }
>>>   +/*determine if the packet is NA or NS*/
>>> +static bool alb_determine_nd(struct icmp6hdr *hdr)
>>> +{
>>> +    if (hdr->icmp6_type == NDISC_NEIGHBOUR_ADVERTISEMENT ||
>>> +        hdr->icmp6_type == NDISC_NEIGHBOUR_SOLICITATION) {
>>> +        return true;
>>> +    }
>>> +
>>> +    return false;
>>> +}
>>> +
>>> +static void alb_change_nd_option(struct sk_buff *skb, void *data)
>>> +{
>>> +    struct nd_msg *msg = (struct nd_msg *)skb_transport_header(skb);
>>> +    struct nd_opt_hdr *nd_opt = (struct nd_opt_hdr *)msg->opt;
>>> +    struct net_device *dev = skb->dev;
>>> +    struct icmp6hdr *icmp6h = icmp6_hdr(skb);
>>> +    struct ipv6hdr *ip6hdr = ipv6_hdr(skb);
>>> +    u8 *lladdr = NULL;
>>> +    u32 ndoptlen = skb_tail_pointer(skb) - 
>>> (skb_transport_header(skb) +
>>> +                offsetof(struct nd_msg, opt));
>>> +
>>> +    while (ndoptlen) {
>>> +        int l;
>>> +
>>> +        switch (nd_opt->nd_opt_type) {
>>> +        case ND_OPT_SOURCE_LL_ADDR:
>>> +        case ND_OPT_TARGET_LL_ADDR:
>>> +        lladdr = ndisc_opt_addr_data(nd_opt, dev);
>>> +        break;
>>> +
>>> +        default:
>>> +        lladdr = NULL;
>>> +        break;
>>> +        }
>>> +
>>> +        l = nd_opt->nd_opt_len << 3;
>>> +
>>> +        if (ndoptlen < l || l == 0)
>>> +            return;
>>> +
>>> +        if (lladdr) {
>>> +            memcpy(lladdr, data, dev->addr_len);
>>
>> I am not sure it is allowed to change skb content without
>>
>> making sure skb ->head is private.
>>
>> (Think of tcpdump -i slaveX : we want to see the packet content 
>> before your change)
>>
>> I would think skb_cow_head() or something similar is needed.
>>
>> This is tricky of course, since all cached pointers (icmp6h, ip6hdr, 
>> msg, nd_opt)
>>
>> would need to be fetched again, since skb->head/data might be changed
>>
>> by skb_cow_head().
> The tcpdump should show the last packet which sent off from NIC in the 
> end.
> could you light me up specific conditions?


I think I have been clear.

You can not modify skb->head unless it is allowed to.

tcpdump on the slave must show the exact packet being received,

before your modifications in bonding driver.



>>
>>
>>
>>
>>
>>> +            icmp6h->icmp6_cksum = 0;
>>> +
>>> +            icmp6h->icmp6_cksum = csum_ipv6_magic(&ip6hdr->saddr,
>>> +                                  &ip6hdr->daddr,
>>> +                        ntohs(ip6hdr->payload_len),
>>> +                        IPPROTO_ICMPV6,
>>> +                        csum_partial(icmp6h,
>>> + ntohs(ip6hdr->payload_len), 0));
>>> +        }
>>> +        ndoptlen -= l;
>>> +        nd_opt = ((void *)nd_opt) + l;
>>> +    }
>>> +}
>>> +
>>> +static u8 *alb_get_lladdr(struct sk_buff *skb)
>>> +{
>>> +    struct nd_msg *msg = (struct nd_msg *)skb_transport_header(skb);
>>> +    struct nd_opt_hdr *nd_opt = (struct nd_opt_hdr *)msg->opt;
>>> +    struct net_device *dev = skb->dev;
>>> +    u8 *lladdr = NULL;
>>> +    u32 ndoptlen = skb_tail_pointer(skb) - 
>>> (skb_transport_header(skb) +
>>> +                offsetof(struct nd_msg, opt));
>>> +
>>> +    while (ndoptlen) {
>>> +        int l;
>>> +
>>> +        switch (nd_opt->nd_opt_type) {
>>> +        case ND_OPT_SOURCE_LL_ADDR:
>>> +        case ND_OPT_TARGET_LL_ADDR:
>>> +            lladdr = ndisc_opt_addr_data(nd_opt, dev);
>>> +            break;
>>> +
>>> +        default:
>>> +            break;
>>> +        }
>>> +
>>> +        l = nd_opt->nd_opt_len << 3;
>>> +
>>> +        if (ndoptlen < l || l == 0)
>>> +            return lladdr;
>>
>>                          return NULL ?
>>
>>                     (or risk out-of-bound access ?)
> Thanks your comment, I'll adjust it and send out V4 soon.
>>
>>> +
>>> +        if (lladdr)
>>> +            return lladdr;
>>> +
>>> +        ndoptlen -= l;
>>> +        nd_opt = ((void *)nd_opt) + l;
>>> +    }
>>> +
>>> +    return lladdr;
>>> +}
>>> +
>>> +static void alb_set_nd_option(struct sk_buff *skb, struct bonding 
>>> *bond,
>>> +                  struct slave *tx_slave)
>>> +{
>>> +    struct ipv6hdr *ip6hdr;
>>> +    struct icmp6hdr *hdr = NULL;
>>> +
>>> +    if (skb->protocol == htons(ETH_P_IPV6)) {
>>> +        if (tx_slave && tx_slave !=
>>> +            rcu_access_pointer(bond->curr_active_slave)) {
>>> +            ip6hdr = ipv6_hdr(skb);
>>> +            if (ip6hdr->nexthdr == IPPROTO_ICMPV6) {
>>> +                hdr = icmp6_hdr(skb);
>>> +                if (alb_determine_nd(hdr))
>>> +                    alb_change_nd_option(skb, 
>>> tx_slave->dev->dev_addr);
>>> +            }
>>> +        }
>>> +    }
>>> +}
>>> +
>>>   /************************ exported alb functions 
>>> ************************/
>>>     int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
>>> @@ -1415,6 +1529,7 @@ struct slave *bond_xmit_alb_slave_get(struct 
>>> bonding *bond,
>>>       }
>>>       case ETH_P_IPV6: {
>>>           const struct ipv6hdr *ip6hdr;
>>> +        struct icmp6hdr *hdr = NULL;
>>>             /* IPv6 doesn't really use broadcast mac address, but leave
>>>            * that here just in case.
>>> @@ -1446,6 +1561,21 @@ struct slave *bond_xmit_alb_slave_get(struct 
>>> bonding *bond,
>>>               break;
>>>           }
>>>   +        if (ip6hdr->nexthdr == IPPROTO_ICMPV6) {
>>> +            hdr = icmp6_hdr(skb);
>>> +            if (alb_determine_nd(hdr)) {
>>> +                u8 *lladdr = NULL;
>>> +
>>> +                lladdr = alb_get_lladdr(skb);
>>> +                if (lladdr) {
>>> +                    if (!bond_slave_has_mac_rx(bond, lladdr)) {
>>> +                        do_tx_balance = false;
>>> +                        break;
>>> +                    }
>>> +                }
>>> +            }
>>> +        }
>>> +
>>>           hash_start = (char *)&ip6hdr->daddr;
>>>           hash_size = sizeof(ip6hdr->daddr);
>>>           break;
>>> @@ -1489,6 +1619,7 @@ netdev_tx_t bond_alb_xmit(struct sk_buff *skb, 
>>> struct net_device *bond_dev)
>>>       struct slave *tx_slave = NULL;
>>>         tx_slave = bond_xmit_alb_slave_get(bond, skb);
>>> +    alb_set_nd_option(skb, bond, tx_slave);
>>>       return bond_do_alb_xmit(skb, bond, tx_slave);
>>>   }
