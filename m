Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F242A303A
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 17:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbgKBQuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 11:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgKBQuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 11:50:23 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FF0C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 08:50:22 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id dk16so19222280ejb.12
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 08:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5pw3JwYiGevfQr0UWtq+aB3msNH6dhczxQz5RMQGqdI=;
        b=VrtTH1LSJS2w8EFIOOwVAlaeIUVGsXkJvQa7Wy0FgsOZ5v+sr5Vl+cV7MrHOFrIw6L
         jkC4jAPEnJ+o5nmKCKy5VRr69qMXpwZccbKxnIPaMyZIZNmg/fgNVyOpYyWXFfZEzVqx
         WPps9sTkuKMH0zuXxGvR/JkWESTPSFm42ql9GsQGx50WIOsXNN9hB6gsbvciFrVywO38
         V7XlehsJnsDNrF2dXqqJhcBT66jMsut5dJ9x5Jy5mc7bC8jWqzoodkcjg0OnX+4SKIZ0
         CGN43laF9UoOrYz7CPEACH9TLG/tTBX1Y40PqwAbbN+umAI0jowwvwLHLsYGXY1cLDqq
         C5bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5pw3JwYiGevfQr0UWtq+aB3msNH6dhczxQz5RMQGqdI=;
        b=kWku6dokBJ1r30AXcYe5xlRZMDoNMpAmMxw/gKp4a1Wk825kR/bPAXtWDJyVKe1xIx
         mqVae1s+cA26UOcSv6QjHAF9oQcZuHma1NHzPu5ckNQHFhSe/+CCyDktBVdsgKU5NbBP
         khYPpMfLfmH2ur4Y9qZeXipTIqBme8MTRO/owDjA9a0LzgKJa0HKVNULtUPK1UJQg8SO
         YzzvSRndG+o+jpzdnPV51HTdWTimFpWxrUtCdzLaGk0NYz63Q8WwwlYo9M0w0hRtwGWK
         c4l2VsbbRBwa031ywmEsYHE+yjYKGWVtS1dQPTzxxLNtxVQyOm07IWEfeLL5cYGpHodR
         /UlQ==
X-Gm-Message-State: AOAM533rGsmZ6UwtR+NKnnt1bmTUWZFnBqXhuTcPYqA1/nr0pRrgRbFZ
        nZeVCyB9sib530BLGHdRVlMJQGQqLtQ=
X-Google-Smtp-Source: ABdhPJze41qaJuIxdDpzGWC8pdNjOl11WYElaTdrFlOZPnc5tiRB08VqFvXpjiHqLMHp1ZrX4f2XGw==
X-Received: by 2002:a17:906:35da:: with SMTP id p26mr4662224ejb.256.1604335820859;
        Mon, 02 Nov 2020 08:50:20 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:7ce1:60e1:9597:1002? (p200300ea8f2328007ce160e195971002.dip0.t-ipconnect.de. [2003:ea:8f23:2800:7ce1:60e1:9597:1002])
        by smtp.googlemail.com with ESMTPSA id hh17sm9703067ejb.125.2020.11.02.08.50.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 08:50:20 -0800 (PST)
Subject: Re: Fwd: Problem with r8169 module
To:     Gilberto Nunes <gilberto.nunes32@gmail.com>
Cc:     netdev@vger.kernel.org
References: <CAOKSTBtcsqFZTzvgF-HQGRmvcd=Qanq7r2PREB2qGmnSQZJ_-A@mail.gmail.com>
 <CAOKSTBuRw-H2VbADd6b0dw=cLBz+wwOCc7Bwz_pGve6_XHrqfw@mail.gmail.com>
 <c743770c-93a4-ad72-c883-faa0df4fa372@gmail.com>
 <CAOKSTBuP0+jjmSYNwi3RB=VYROVY08+DOqnu8=YL5zTgy-RnDw@mail.gmail.com>
 <fb81f07e-911a-729e-337d-e1cfe38b80ff@gmail.com>
 <CAOKSTBs6F=RWEWOv5OkLd25GsOk1c9Xf8yX6WSy_sKvLmdX86w@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <4ee088b0-505b-8567-7af0-3ddd4cb1c778@gmail.com>
Date:   Mon, 2 Nov 2020 17:50:16 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAOKSTBs6F=RWEWOv5OkLd25GsOk1c9Xf8yX6WSy_sKvLmdX86w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.11.2020 17:29, Gilberto Nunes wrote:
>>From kernel 5.4
> 
> ethtool -d enp1s0f1
> RealTek RTL8411 registers:
> --------------------------------------------------------
> 0x00: MAC Address                      98:29:a6:e6:e5:6a
> 0x08: Multicast Address Filter     0xffffffff 0xffffffff
> 0x10: Dump Tally Counter Command   0xffffe000 0x00000000
> 0x20: Tx Normal Priority Ring Addr 0xff50b000 0x00000000
> 0x28: Tx High Priority Ring Addr   0x00000000 0x00000000
> 0x30: Flash memory read/write                 0x00000000
> 0x34: Early Rx Byte Count                              0
> 0x36: Early Rx Status                               0x00
> 0x37: Command                                       0x0c
>       Rx on, Tx on
> 0x3C: Interrupt Mask                              0x003f
>       LinkChg RxNoBuf TxErr TxOK RxErr RxOK
> 0x3E: Interrupt Status                            0x0000
> 
> 0x40: Tx Configuration                        0x5f800f80
> 0x44: Rx Configuration                        0x0002cf0f
> 0x48: Timer count                             0x00000000
> 0x4C: Missed packet counter                     0x000000
> 0x50: EEPROM Command                                0x10
> 0x51: Config 0                                      0x00
> 0x52: Config 1                                      0xcf
> 0x53: Config 2                                      0x3c
> 0x54: Config 3                                      0x60
> 0x55: Config 4                                      0x11
> 0x56: Config 5                                      0x02
> 0x58: Timer interrupt                         0x00000000
> 0x5C: Multiple Interrupt Select                   0x0000
> 0x60: PHY access                              0x00000000
> 0x64: TBI control and status                  0x12011025
> 0x68: TBI Autonegotiation advertisement (ANAR)    0xf02c
> 0x6A: TBI Link partner ability (LPAR)             0x8000
> 0x6C: PHY status                                    0xeb

Thanks for the additional info. PHY status 0xeb means that
a link is established at 100Mbps, see following from the
driver source. Having said that the downshift happens also
under 5.4, it's just not reported.

	/* rtl8169_PHYstatus */
	TBI_Enable	= 0x80,
	TxFlowCtrl	= 0x40,
	RxFlowCtrl	= 0x20,
	_1000bpsF	= 0x10,
	_100bps		= 0x08,
	_10bps		= 0x04,
	LinkStatus	= 0x02,
	FullDup		= 0x01,

1Gbps needs all four cable pairs, whilst 100Mbps is happy
with two. Therefore one reason could be a physical problem
(e.g. corrosion) with a pin in a RJ45 port.
(in case you tried other cables already and you can rule out
a cable problem)

> 0x84: PM wakeup frame 0            0x00000000 0x00000000
> 0x8C: PM wakeup frame 1            0x00000000 0x00000000
> 0x94: PM wakeup frame 2 (low)      0x00000000 0x00000000
> 0x9C: PM wakeup frame 2 (high)     0x00000000 0x00000000
> 0xA4: PM wakeup frame 3 (low)      0x00000000 0x00000000
> 0xAC: PM wakeup frame 3 (high)     0x00000000 0x00000001
> 0xB4: PM wakeup frame 4 (low)      0x00000000 0xd205cde1
> 0xBC: PM wakeup frame 4 (high)     0x00000000 0x00000000
> 0xC4: Wakeup frame 0 CRC                          0x0000
> 0xC6: Wakeup frame 1 CRC                          0x0000
> 0xC8: Wakeup frame 2 CRC                          0x0000
> 0xCA: Wakeup frame 3 CRC                          0x0000
> 0xCC: Wakeup frame 4 CRC                          0x0000
> 0xDA: RX packet maximum size                      0x4000
> 0xE0: C+ Command                                  0x2060
>       VLAN de-tagging
>       RX checksumming
> 0xE2: Interrupt Mitigation                        0x0000
>       TxTimer:       0
>       TxPackets:     0
>       RxTimer:       0
>       RxPackets:     0
> 0xE4: Rx Ring Addr                 0xff50f000 0x00000000
> 0xEC: Early Tx threshold                            0x27
> 0xF0: Func Event                              0x0000003f
> 0xF4: Func Event Mask                         0x00000000
> 0xF8: Func Preset State                       0x00000003
> 0xFC: Func Force Event                        0x00000000
> 
>>From kernel 5.9.3
> 
> ethtool -d enp1s0f1
> RealTek RTL8411 registers:
> --------------------------------------------------------
> 0x00: MAC Address                      98:29:a6:e6:e5:6a
> 0x08: Multicast Address Filter     0xffffffff 0xffffffff
> 0x10: Dump Tally Counter Command   0xffffe000 0x00000000
> 0x20: Tx Normal Priority Ring Addr 0xff582000 0x00000000
> 0x28: Tx High Priority Ring Addr   0x00000000 0x00000000
> 0x30: Flash memory read/write                 0x00000000
> 0x34: Early Rx Byte Count                              0
> 0x36: Early Rx Status                               0x00
> 0x37: Command                                       0x0c
>       Rx on, Tx on
> 0x3C: Interrupt Mask                              0x003f
>       LinkChg RxNoBuf TxErr TxOK RxErr RxOK
> 0x3E: Interrupt Status                            0x0000
> 
> 0x40: Tx Configuration                        0x5f800f80
> 0x44: Rx Configuration                        0x0002cf0f
> 0x48: Timer count                             0x00000000
> 0x4C: Missed packet counter                     0x000000
> 0x50: EEPROM Command                                0x10
> 0x51: Config 0                                      0x00
> 0x52: Config 1                                      0xcf
> 0x53: Config 2                                      0x3c
> 0x54: Config 3                                      0x60
> 0x55: Config 4                                      0x11
> 0x56: Config 5                                      0x02
> 0x58: Timer interrupt                         0x00000000
> 0x5C: Multiple Interrupt Select                   0x0000
> 0x60: PHY access                              0x00000000
> 0x64: TBI control and status                  0x12011025
> 0x68: TBI Autonegotiation advertisement (ANAR)    0xf02c
> 0x6A: TBI Link partner ability (LPAR)             0x8000
> 0x6C: PHY status                                    0xeb
> 0x84: PM wakeup frame 0            0x00000000 0x00000000
> 0x8C: PM wakeup frame 1            0x00000000 0x00000000
> 0x94: PM wakeup frame 2 (low)      0x00000000 0x00000000
> 0x9C: PM wakeup frame 2 (high)     0x00000000 0x00000000
> 0xA4: PM wakeup frame 3 (low)      0x00000000 0x00000000
> 0xAC: PM wakeup frame 3 (high)     0x00000000 0x00000001
> 0xB4: PM wakeup frame 4 (low)      0x00000000 0xd21a30de
> 0xBC: PM wakeup frame 4 (high)     0x00000000 0x00000000
> 0xC4: Wakeup frame 0 CRC                          0x0000
> 0xC6: Wakeup frame 1 CRC                          0x0000
> 0xC8: Wakeup frame 2 CRC                          0x0000
> 0xCA: Wakeup frame 3 CRC                          0x0000
> 0xCC: Wakeup frame 4 CRC                          0x0000
> 0xDA: RX packet maximum size                      0x4000
> 0xE0: C+ Command                                  0x2060
>       VLAN de-tagging
>       RX checksumming
> 0xE2: Interrupt Mitigation                        0x0000
>       TxTimer:       0
>       TxPackets:     0
>       RxTimer:       0
>       RxPackets:     0
> 0xE4: Rx Ring Addr                 0xff583000 0x00000000
> 0xEC: Early Tx threshold                            0x27
> 0xF0: Func Event                              0x0000003f
> 0xF4: Func Event Mask                         0x00000000
> 0xF8: Func Preset State                       0x00000003
> 0xFC: Func Force Event                        0x00000000
> 
> 
> I also noticed this message when ran update-initramfs -k all -u when
> installed kernel 5.9.3.
> I had made a git clone from linux-firmware and copied this missed
> firmware but no change!
> 
> W: Possible missing firmware /lib/firmware/rtl_nic/rtl8125b-2.fw for
> module r8169
> 
> 
> 
> ---
> Gilberto Nunes Ferreira
> 
> 
> 
> Em seg., 2 de nov. de 2020 às 10:40, Heiner Kallweit
> <hkallweit1@gmail.com> escreveu:
>>
>> On 02.11.2020 14:20, Gilberto Nunes wrote:
>>> Hi
>>>
>>> ethtool using 5.4
>>>
>> ethtool doesn't know about the actual speed, because the downshift
>> occurs PHY-internally. Please test actual the speed.
>> Alternatively provide the output of ethtool -d <if>, the RTL8169
>> chip family has an internal register refkecting the actual link speed.

