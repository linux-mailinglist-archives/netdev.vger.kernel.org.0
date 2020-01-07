Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79C35132CDC
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 18:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgAGRVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 12:21:10 -0500
Received: from mail-wm1-f51.google.com ([209.85.128.51]:56291 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728292AbgAGRVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 12:21:10 -0500
Received: by mail-wm1-f51.google.com with SMTP id q9so326658wmj.5;
        Tue, 07 Jan 2020 09:21:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=4P5SKmxzuCtFwSD35kArQdqnsI/2LGmAZfhdm0nb4do=;
        b=HG7u90xpe6jU2OHmsG8buAj69NAs0jX5dXiFXzXb7sd6lAoGUax/iPYF0SQ6d/MYfX
         ZJDF9UOfcX4t/P/vdiu/DnvftA76X80eSITofB+mABX1Zy1FOwIfOSBrT35ws4D8ig33
         6+v1xMMwbeSUYXKBXrdG9qZIJwOHF69edFNmK3Pas30Pq8iYbh50Z9saM9TadKsnsP9o
         7znvxtl9OKiLAyp9b5m4YLPbS+8Dy74EY5afl3U99WBvwAsUrgsvPuRKo44/0tMZYXkW
         emsO4g2Y/EYEzwvCxtrAXk2Xi1oKkoycnT7yrUKPcBjpsvdY99M4cTX3DWILiW2ojQCj
         obXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4P5SKmxzuCtFwSD35kArQdqnsI/2LGmAZfhdm0nb4do=;
        b=QoHTwaQBQUKwC8lHs5AE/+9gfhwFmSeAj+E+KE1yqd+W3lkkdb2AHEaeIcCIN0yTaO
         H/7d5zuEHsS72wnDFIzA3yvx5/eWldyzN31GC39/kCA5N+Jba2Aui0fjHDK7LV+/KzHG
         eCrXbJFhEVNW9fM+3+kafW3dFdHOkqtA1UKp+dl3RBI0saAxO1OmtVlPeRTEmIqNJah6
         /jp5ioDsDvvTm9oA231IA8h8UTf2kLcaNbXPA2qFc9d9CiC8Hz3EP88G521Z8SF49ORW
         qwCUW2NttdhMWenQsrOSVbOGRQ7w3yVlNuRx9ijdrogJgVhytPpxrcTGR3BuSgMcibC1
         tlig==
X-Gm-Message-State: APjAAAW5XDGNnM08Ef46IoOo5w/U0brSWbqVCVF4gtQo2da6AdemFKrt
        2OEqedKlseNdcdNUKscTcosiE0nR
X-Google-Smtp-Source: APXvYqzz06UjHTu6lzUPKpGyZ6o8bpJEdgTEsf7VpFOVKghmQi1W6kL6FSmkd4ojnVdWYyy63b5EbQ==
X-Received: by 2002:a1c:4b0a:: with SMTP id y10mr147023wma.78.1578417667738;
        Tue, 07 Jan 2020 09:21:07 -0800 (PST)
Received: from [192.168.8.147] (118.164.185.81.rev.sfr.net. [81.185.164.118])
        by smtp.gmail.com with ESMTPSA id u22sm602968wru.30.2020.01.07.09.21.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2020 09:21:07 -0800 (PST)
Subject: Re: [RPI 3B+ / TSO / lan78xx ]
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     RENARD Pierre-Francois <pfrenard@gmail.com>,
        nsaenzjulienne@suse.de, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, stefan.wahren@i2se.com
References: <5267da21-8f12-2750-c0c5-4ed31b03833b@gmail.com>
 <78b94ba2-9a87-78bb-8916-e6ef5a0668ae@gmail.com>
 <863777f2-3a7b-0736-d0a4-d9966bea3f96@gmail.com>
Message-ID: <a49c9cb2-576c-005b-580b-57ac8313d478@gmail.com>
Date:   Tue, 7 Jan 2020 09:21:06 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <863777f2-3a7b-0736-d0a4-d9966bea3f96@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/7/20 9:04 AM, Eric Dumazet wrote:
> 
> 
> On 1/7/20 5:32 AM, RENARD Pierre-Francois wrote:
>>
>> Hello all
>>
>> I am facing an issue related to Raspberry PI 3B+ and onboard ethernet card.
>>
>> When doing a huge transfer (more than 1GB) in a row, transfer hanges and failed after a few minutes.
>>
>>
>> I have two ways to reproduce this issue
>>
>>
>> using NFS (v3 or v4)
>>
>>     dd if=/dev/zero of=/NFSPATH/file bs=4M count=1000 status=progress
>>
>>
>>     we can see that at some point dd hangs and becomes non interrutible (no way to ctrl-c it or kill it)
>>
>>     after afew minutes, dd dies and a bunch of NFS server not responding / NFS server is OK are seens into the journal
>>
>>
>> Using SCP
>>
>>     dd if=/dev/zero of=/tmp/file bs=4M count=1000
>>
>>     scp /tmp/file user@server:/directory
>>
>>
>>     scp hangs after 1GB and after a few minutes scp is failing with message "client_loop: send disconnect: Broken pipe lostconnection"
>>
>>
>>
>>
>> It appears, this is a known bug relatted to TCP Segmentation Offload & Selective Acknowledge.
>>
>> disabling this TSO (ethtool -K eth0 tso off & ethtool -K eth0 gso off) solves the issue.
>>
>> A patch has been created to disable the feature by default by the raspberry team and is by default applied wihtin raspbian.
>>
>> comment from the patch :
>>
>> /* TSO seems to be having some issue with Selective Acknowledge (SACK) that
>>  * results in lost data never being retransmitted.
>>  * Disable it by default now, but adds a module parameter to enable it for
>>  * debug purposes (the full cause is not currently understood).
>>  */
>>
>>
>> For reference you can find
>>
>> a link to the issue I created yesterday : https://github.com/raspberrypi/linux/issues/3395
>>
>> links to raspberry dev team : https://github.com/raspberrypi/linux/issues/2482 & https://github.com/raspberrypi/linux/issues/2449
>>
>>
>>
>> If you need me to test things, or give you more informations, I ll be pleased to help.
>>
> 
> 
> I doubt TSO and SACK have a serious generic bug like that.
> 
> Most likely the TSO implementation on the driver/NIC has a bug .
> 
> Anyway you do not provide a kernel version, I am not sure what you expect from us.
> 

Oh well, drivers/net/usb/lan78xx.c is horribly buggy.

It wants linear skbs, which is likely to fail with too big packets.

And if skb linearization fails, skb is not freed, so a big memory leak happens.

Please try this patch :

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index f940dc6485e56a7e8f905082ce920f5dd83232b0..5e2d3c8c34dc8d8ac6f2ab3fd8a59dba5b348882 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -2724,11 +2724,6 @@ static int lan78xx_stop(struct net_device *net)
        return 0;
 }
 
-static int lan78xx_linearize(struct sk_buff *skb)
-{
-       return skb_linearize(skb);
-}
-
 static struct sk_buff *lan78xx_tx_prep(struct lan78xx_net *dev,
                                       struct sk_buff *skb, gfp_t flags)
 {
@@ -2740,8 +2735,10 @@ static struct sk_buff *lan78xx_tx_prep(struct lan78xx_net *dev,
                return NULL;
        }
 
-       if (lan78xx_linearize(skb) < 0)
+       if (skb_linearize(skb)) {
+               dev_kfree_skb_any(skb);
                return NULL;
+       }
 
        tx_cmd_a = (u32)(skb->len & TX_CMD_A_LEN_MASK_) | TX_CMD_A_FCS_;
 
@@ -3790,6 +3787,9 @@ static int lan78xx_probe(struct usb_interface *intf,
        if (ret < 0)
                goto out4;
 
+       /* since we want linear skb, avoid high-order allocations */
+       netif_set_gso_max_size(netdev, SKB_WITH_OVERHEAD(16000));
+
        ret = register_netdev(netdev);
        if (ret != 0) {
                netif_err(dev, probe, netdev, "couldn't register the device\n");
