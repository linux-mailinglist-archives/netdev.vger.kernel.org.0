Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21F4E12EB4B
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 22:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725884AbgABVYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 16:24:24 -0500
Received: from mail-wr1-f52.google.com ([209.85.221.52]:47033 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgABVYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 16:24:24 -0500
Received: by mail-wr1-f52.google.com with SMTP id z7so40541670wrl.13;
        Thu, 02 Jan 2020 13:24:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vHCgb0VDUU7IJBJSOfc8QemdJLTUS/nR2k3bIfhqBds=;
        b=ZZHDOlNwA6nw69bwkxRMJuUqfWyxZEuvxchBwNNqElLQCV71/h+yz1nrDlFdElU5Iv
         QSqOYPwgnJdecbn5mzasm/D3a+AKZnZUMTndsjuy9BW/geRdLJKxz9387kd2b+a6rl51
         3T61NBXpC9yoYxL2pR3jOKKpAfQVBtaY2LCZAxToKnn9PQ1Fxcem8fRW97+VmBY98uJO
         NuLyyMIdWVMuUnnS/dpGFxAJ+z1fc/ZwWE3zQT25a9cFzUf6aRz/E1TVxjTNc422X9r6
         hE2OAuKATwh1/5iMBIoM8pv3T5d5koH5S6QZT12PsS2OfzIfO/z9j0RA79yUaIepi28g
         XdJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vHCgb0VDUU7IJBJSOfc8QemdJLTUS/nR2k3bIfhqBds=;
        b=hdl6OLxJhNPysoPtnQ4kFjvLb+V96KGKLv79/1ux/I1iAjWXl8K+umFB0Vr6v/MvJ2
         Xr4j/FZvTeptTvcW7eL/VBDBHflM00JgWp+k2CjHiqvwlUXSkcb32sBg3jX92Zpu79XB
         W/rdbtNyTMC1P6+Leaoq5lPJgy3qSu8H2IRQl4LeyM4EjZZqQbbm0Z53yZ3mnWfTANch
         oC9uW2oNXElrZd7vegjLW8zOejBwNXaMg0Pq8ExXBON0ELYnMLGuyHcTHg+PS9YHeV7W
         Edztdalx8aJBRUBscjwE6VVoYsC4xLuPGQa2hMmqrbAycc0lZTML7mVLUQD5sFJLedbz
         Budw==
X-Gm-Message-State: APjAAAXXG/CkenOQjBvs7Nt6MXMfJPYKAog0ZD/C03OZbeHTXOVgB6WE
        gwdJOF4OtiryCpQgyZjjxQu22AuH
X-Google-Smtp-Source: APXvYqy7uSDrw8+NdILTuBJyFYZWauIh/O14WUJ44YjjkMJ/NWfglTUv6t1l7iOtrRNkuf6UDx1B5A==
X-Received: by 2002:a5d:66c3:: with SMTP id k3mr78699916wrw.370.1578000262666;
        Thu, 02 Jan 2020 13:24:22 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id q19sm9710392wmc.12.2020.01.02.13.24.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jan 2020 13:24:22 -0800 (PST)
Subject: Re: SFP+ support for 8168fp/8117
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Andrew Lunn <andrew@lunn.ch>, Chun-Hao Lin <hau@realtek.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Anthony Wong <anthony.wong@canonical.com>,
        Jason Yen <jason.yen@canonical.com>
References: <2D8F5FFE-3EC3-480B-9D15-23CACE5556DF@canonical.com>
 <20200102152143.GB1397@lunn.ch>
 <DC28A43E-4F1A-40B6-84B0-3E79215527C9@canonical.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <c148fefc-fd56-26a8-9f9b-fbefbaf25050@gmail.com>
Date:   Thu, 2 Jan 2020 22:24:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <DC28A43E-4F1A-40B6-84B0-3E79215527C9@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.01.2020 17:46, Kai-Heng Feng wrote:
> Hi Andrew,
> 
>> On Jan 2, 2020, at 23:21, Andrew Lunn <andrew@lunn.ch> wrote:
>>
>> On Thu, Jan 02, 2020 at 02:59:42PM +0800, Kai Heng Feng wrote:
>>> Hi Heiner,
>>>
>>> There's an 8168fp/8117 chip has SFP+ port instead of RJ45, the phy device ID matches "Generic FE-GE Realtek PHY" nevertheless.
>>> The problems is that, since it uses SFP+, both BMCR and BMSR read are always zero, so Realtek phylib never knows if the link is up.
>>>
>>> However, the old method to read through MMIO correctly shows the link is up:
>>> static unsigned int rtl8169_xmii_link_ok(struct rtl8169_private *tp)
>>> {
>>>       return RTL_R8(tp, PHYstatus) & LinkStatus;
>>> }
>>>
>>> Few ideas here:
>>> - Add a link state callback for phylib like phylink's phylink_fixed_state_cb(). However there's no guarantee that other parts of this chip works.
>>> - Add SFP+ support for this chip. However the phy device matches to "Generic FE-GE Realtek PHY" which may complicate things.
>>>
>>> Any advice will be welcome.
>>
>> Hi Kai
>>
>> Is the i2c bus accessible?
> 
> I don't think so. It seems to be a regular Realtek 8168 device with generic PCI ID [10ec:8168].
> 
>> Is there any documentation or example code?
> 
> Unfortunately no.
> 
>>
>> In order to correctly support SFP+ cages, we need access to the i2c
>> bus to determine what sort of module has been inserted. It would also
>> be good to have access to LOS, transmitter disable, etc, from the SFP
>> cage.
> 
> Seems like we need Realtek to provide more information to support this chip with SFP+.
> 
Indeed it would be good to have some more details how this chip handles SFP+,
therefore I add Hau to the discussion.

As I see it the PHY registers are simply dummies on this chip. Or does this chip
support both, PHY and SFP+? Hopefully SFP presence can be autodetected, we could
skip the complete PHY handling in this case. Interesting would be which parts of
the SFP interface are exposed how via (proprietary) registers.
Recently the STMMAC driver was converted from phylib to phylink, maybe we have
to do the same with r8169 one fine day. But w/o more details this is just
speculation, much appreciated would be documentation from Realtek about the
SFP+ interface.

Kai, which hardware/board are we talking about?

> Kai-Heng
> 
>>
>>   Andrew
> 
Heiner
