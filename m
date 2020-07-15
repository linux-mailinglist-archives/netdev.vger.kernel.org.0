Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9DB2221084
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 17:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbgGOPK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 11:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbgGOPK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 11:10:26 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE5BC061755
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 08:10:26 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id a8so1880626edy.1
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 08:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T3r+bp0OiAAGEwQYy5fF5a2DX/v5TuTMSBpKwf0E30I=;
        b=pvtH9LfEtvkfR7GQjf/T5owhywUEwchljAv5eCKeTLT6GQMWnMBJl9sarTrRkSQIXg
         BFsi0YAvmf0oFLzqRtB1s3XXGRYrCVIxWvQA5NQubgTUVD6qb6bsmQ7ahVXRMz8unbRM
         TuDEv4b2qWSRs6CRiJNl7DcZvJqDLD7a2QYr+gSS5azzQaas8nYDJWfc3b8Pyrgmmq4M
         Ys2cSM+OcSAsCysvEzlMp7dZ2uhRfcIlhLDX5Tdt6TcVzTmW4Xn11iRUjxYj5sKksrn/
         B5Ft0l04nvAsYZ9C9hw8d7gOgd9lJncQcNhAD4tXEILPlpq03p9OizwGfiiLzEUyUumJ
         Q2NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T3r+bp0OiAAGEwQYy5fF5a2DX/v5TuTMSBpKwf0E30I=;
        b=MwTI3oJnjlpcHJQnb7xnj/ewcYXbum/jRgjJSCOBOky/d904d0T40JDqftOZfFUVt8
         0ESwXZBeXBTJ0LYzEH98Q1GRm4L+EluZg9Mdwmd/z57cPiqcXggUQP2hXFkSvwLfaKNA
         LiNa7G2B4qmaDoAocxoQ0hlEeTnHk+nPWgZjx8bU3MC8BPXSS9zkZbBGeb+feL2n/YJ+
         wedeYu7qD8pYR9o7cN6QEAobSJoWC1NAe25ya/hX/IBSbuoBremF3LbnBRWp0O8T+tyN
         /upbSHnZZThBK9jlSDVMs0KYMqqNC+6nxUeQBJI6bIgl8eYaBARuAELhuTNzwV6q3Iyw
         uOmQ==
X-Gm-Message-State: AOAM532OoH8s7NHPGGObuyqunqnvlEXLbRlA5K1wb+Ip+/ruRzskoli4
        xgfk3jVIwRfy1lWdRiPoV4opT4ilRhQ=
X-Google-Smtp-Source: ABdhPJxzSmjWBX0rZtlG61sBJIsWErcXU0baiGs9lv4ayE4IoiCW8xaslokakkL9ipuSeAORwo2nag==
X-Received: by 2002:a50:aca6:: with SMTP id x35mr74848edc.328.1594825824443;
        Wed, 15 Jul 2020 08:10:24 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:a057:4ec1:54f8:5de3? (p200300ea8f235700a0574ec154f85de3.dip0.t-ipconnect.de. [2003:ea:8f23:5700:a057:4ec1:54f8:5de3])
        by smtp.googlemail.com with ESMTPSA id o17sm2323070ejb.105.2020.07.15.08.10.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2020 08:10:23 -0700 (PDT)
Subject: Re: wake-on-lan
To:     Michal Kubecek <mkubecek@suse.cz>,
        "Michael J. Baars" <mjbaars1977.netdev@cyberfiber.eu>
Cc:     netdev@vger.kernel.org
References: <309b0348938a475f256cbc8afbbc127c285fec69.camel@cyberfiber.eu>
 <20200715133922.tu2ptsfeu25fnuwe@lion.mk-sys.cz>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <730ce89e-1dfe-1133-2cf7-399e8875c449@gmail.com>
Date:   Wed, 15 Jul 2020 17:10:18 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200715133922.tu2ptsfeu25fnuwe@lion.mk-sys.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.07.2020 15:39, Michal Kubecek wrote:
> On Wed, Jul 15, 2020 at 11:27:20AM +0200, Michael J. Baars wrote:
>> Hi Michal,
>>
>> This is my network card:
>>
>> 01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 0c)
>> 	Subsystem: Realtek Semiconductor Co., Ltd. Device 0123
>> 	Kernel driver in use: r8169
>>
>> On the Realtek website
>> (https://www.realtek.com/en/products/communications-network-ics/item/rtl8168e)
>> it says that both wake-on-lan and remote wake-on-lan are supported. I
>> got the wake-on-lan from my local network working, but I have problems
>> getting the remote wake-on-lan to work.
>>
>> When I set 'Wake-on' to 'g' and suspend my system, everything works
>> fine (the router does lose the ip address assigned to the mac address
>> of the system). I figured the SecureOn password is meant to forward
>> magic packets to the correct machine when the router does not have an
>> ip address assigned to a mac address, i.e. port-forwarding does not
>> work.
>>
>> Ethtool 'Supports Wake-on' gives 'pumbg', and when I try to set 'Wake-on' to 's' I get:
>>
>> netlink error: cannot enable unsupported WoL mode (offset 36)
>> netlink error: Invalid argument
>>
>> Does this mean that remote wake-on-lan is not supported (according to
>> ethtool)?
> 
> "MagicPacket" ('g') means that the NIC would wake on reception of packet
> containing specific pattern described e.g. here:
> 
>   https://en.wikipedia.org/wiki/Wake-on-LAN#Magic_packet
> 
> This is the most frequently used wake on LAN mode and, in my experience,
> what most people mean when they say "enable wake on LAN".
> 
> The "SecureOn(tm) mode" ('s') is an extension of this which seems to be
> supported only by a handful of drivers; it involves a "password" (48-bit
> value set by sopass parameter of ethtool) which is appended to the
> MagicPacket.
> 
> I'm not sure how is the remote wake-on-lan supposed to work but
> technically you need to get _any_ packet with the "magic" pattern to the
> NIC.
> 
WoL is MAC-based and works on layer 2 only. WoW (Wake-on-WAN) requires
routing and therefore a running IP stack. In sleep mode the BIOS has
to provide this. One approach was DASH: https://www.dmtf.org/standards/dash

Realtek provides a DASH Windows client, however it's limited to specific
network chip set versions and systems (as it requires BIOS support).

>> I also tried to set 'Wake-on' to 'b' and 'bg' but then the systems
>> turns back on almost immediately for both settings.
> 
> This is not surprising as enabling "b" should wake the system upon
> reception of any broadcast which means e.g. any ARP request. Enabling
> multiple modes wakes the system on a packet matching any of them.
> 
> Michal
> 

