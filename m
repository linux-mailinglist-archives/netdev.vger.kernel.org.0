Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 620C25AF8D
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 11:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfF3JM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 05:12:28 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41240 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726519AbfF3JM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 05:12:28 -0400
Received: by mail-wr1-f67.google.com with SMTP id c2so10517170wrm.8
        for <netdev@vger.kernel.org>; Sun, 30 Jun 2019 02:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oHHB283swrbNQnN/xRli60812CYuwsWCMQMYGhh71VU=;
        b=odZF9J8YAvLbkUsWSjuIhMM79IqB3y3gC6RnINqYGzc7ZCt1G6y0Kh6D286stYJGdR
         XJFywcVMSxVVa410Ex0SRjxv/hMb0UlV2tLnaHrQepXrtvEWKvEOhrISMmb0bMDFFV+N
         0r730SsmK2Zac2no6zKo/J4YNmYw/rj5foaL/WEuhBTQCa4EZAAEejj/iZyi0+zs/GAp
         rYkkt5V0/i6dkKajoRBLn0Asa8QAgquvXETMkYNNxNt/rSgQOcybsHH3HnJRzmJzXzIa
         eow+oC1ju0hmtgM89BXu1j5VmI/o5hl1vGAiuxPSv0MO2c8044EF1udqYvqvnW5XpKiB
         fcpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oHHB283swrbNQnN/xRli60812CYuwsWCMQMYGhh71VU=;
        b=FNpoUG4xl3A4BGVmzLCkJaxhIfXY3h4PZTU/skyhZtq1RrBpf6q3NhD8HqGwhcHZuv
         HiJITKRxNYFPmVjdSG2igsbhrWNK0LuIcsUKj79SUGlo3uPxPIpmHo47D2DWRFgdgngD
         nDpBn+kDyWvlFIdP4q/L26LMQBlQypfNPA1+sPUQ5A/7H+FExCqo0KcSAVfIctLTNyrI
         jI5uvzMqthot1MdnOFwWkmczv43avX/CGVlR+Hv4H3NEMwpvuG1CjtURRO3HEPhUVQa0
         ysZ3lXilf1/qt56dpQHc7QXAog5YKWnwueWEiNA7MxoWRdLLZx6rGOJlr9kIAnMe1/AE
         tO0A==
X-Gm-Message-State: APjAAAVA1Id47jxurgo1UeG50EDapx5y9YSzu69TYArhUEiXNXASd++u
        d4Z2Hpxnw+sJy6L/k0zEXZWyuLRN
X-Google-Smtp-Source: APXvYqw42DAwO6rwBKtOGeIxQW/oxAv2egtUY3bm0sb97qiD0L1HnQM/UmXv8GlO/8j6Z8/VZEbL0A==
X-Received: by 2002:a5d:4681:: with SMTP id u1mr14236510wrq.102.1561885945835;
        Sun, 30 Jun 2019 02:12:25 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:c130:58d9:1801:4501? (p200300EA8BF3BD00C13058D918014501.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:c130:58d9:1801:4501])
        by smtp.googlemail.com with ESMTPSA id r5sm15025142wrg.10.2019.06.30.02.12.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 30 Jun 2019 02:12:25 -0700 (PDT)
Subject: Re: r8169 not working on 5.2.0rc6 with GPD MicroPC
To:     Karsten Wiborg <karsten.wiborg@web.de>, nic_swsd@realtek.com,
        romieu@fr.zoreil.com
Cc:     netdev@vger.kernel.org
References: <0a560a5e-17f2-f6ff-1dad-66907133e9c2@web.de>
 <85548ec0-350b-118f-a60c-4be2235d5e4e@gmail.com>
 <4437a8a6-73f0-26a7-4a61-b215c641ff20@web.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <b104dbf2-6adc-2eee-0a1a-505c013787c0@gmail.com>
Date:   Sun, 30 Jun 2019 11:12:19 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <4437a8a6-73f0-26a7-4a61-b215c641ff20@web.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.06.2019 02:14, Karsten Wiborg wrote:
> Hi Heiner,
> 
> thanks for the speedy reply.
> 
> On 6/30/19 12:09 AM, Heiner Kallweit wrote:
>> If r8169 (the mainline driver) is running, why do you want to switch
>> to r8168 (the Realtek vendor driver)? The latter is not supported by
>> the kernel community.
> Well I did install r8168 because r8169 is not working.
> Didn't even get to see the MAC of the NIC.
> 
>>> 2: eno1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group
>>> default qlen 1000
>>>     link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff
>> Seems like the network isn't started.
> Jepp, that is the output from the r8169.
> 
Indeed the MAC is missing:
[    2.839776] r8169 0000:02:00.0 eth0: RTL8168h/8111h,
00:00:00:00:00:00, XID 541, IRQ 126

This works with RTL8168h in other systems, so I'd say you should
check with the vendor. Maybe it's a BIOS issue.

> Regards,
> Karsten
> 
Heiner
