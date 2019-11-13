Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79E56FAA22
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 07:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbfKMG0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 01:26:10 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44212 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbfKMG0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 01:26:09 -0500
Received: by mail-wr1-f66.google.com with SMTP id f2so876749wrs.11
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 22:26:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=phHyAehd7Chz9ztbg0Y0Kozg4ujtX79RUOEETsB9IxY=;
        b=MokeN/bmN5D5pgxGw6ko1dg4uht6qysrfy1/tmk146SaTSerWTlygJM6sezpL5HhtQ
         d65Acnu0IY8wnh0b6g/Mk6TCwyTYnK/63XBT3HNDSK4NMaieYHg3Q/Mz7J3mOROJX3W8
         Sjo8ZeNjnE47UfBlludpBJjW72JnT/SNWQtkXGRp0n2hnNoX6xpgHFkwFRZLEdwDv6nd
         TBJblBoLeGcoehprE0FIxiZ/JhFIYOYkx5tylk9FyzApG0KAZl94pJvMwGea8B6Ua+G4
         FwTakLfT+ueVMOA5qeJdmNUk9JO49GayFMf54kUvg3rvc6zmzr+P1oEUS+TWwo4kyR8Z
         MzRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=phHyAehd7Chz9ztbg0Y0Kozg4ujtX79RUOEETsB9IxY=;
        b=gQ+QtC3smiogrzRBNh+FQa9bMX1SV/3p3v8eIgfrQ+4lmg3RPBbHDGfXtxQ0R5bq0F
         rfEGng5i84AnvKxwMOGjCcyR7RSWgE3HdcuonMWnHmywrJPa6FJWcYzdUNZ08IXqLUOt
         s+b90F9KQ0d3qVAWEbY2CV2WL76vwFreWdXCV1awji2Dw01WpK6L9NEAo9efNgpv3SAF
         OiKv3TGRIINE+3hWSrS+T8G2v6dRdP7MkagEtj6AD/+ipYt7DFv4q1uifDfUBFCTKY69
         KRw5Uwl//CdydbsOpPdlv2ElCtPYVbO6yiJtxBnBQb9CQAdeDHp08yLHMu8WH4Gb7Hja
         6B+Q==
X-Gm-Message-State: APjAAAVi4CRKeiqh71bRn5rQbZ6eBBktSKGkIadOUiaqjSJtS269hWB5
        q7QJuQ7CcM9WO3O6z89DVj3OyJiS
X-Google-Smtp-Source: APXvYqwRhpXfjCrdYajy11UZAbnIwh0MfyCKKqz/tJjyAAM3uX2mVqUsvWYurgdGAIOvaHs25eoFRg==
X-Received: by 2002:adf:e505:: with SMTP id j5mr1070660wrm.46.1573626367290;
        Tue, 12 Nov 2019 22:26:07 -0800 (PST)
Received: from ?IPv6:2003:ea:8f2d:7d00:f578:39bd:db16:1df2? (p200300EA8F2D7D00F57839BDDB161DF2.dip0.t-ipconnect.de. [2003:ea:8f2d:7d00:f578:39bd:db16:1df2])
        by smtp.googlemail.com with ESMTPSA id j10sm1600211wrx.30.2019.11.12.22.26.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Nov 2019 22:26:06 -0800 (PST)
Subject: Re: [PATCH net-next 0/3] r8169: use rtl821x_modify_extpage exported
 from Realtek PHY driver
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <461096ec-9185-a919-ae56-0208e73342fe@gmail.com>
 <6706c94a-2252-c0b2-6dcb-511f0b3ad2a6@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <3e605bec-f0ec-9c22-e2c8-58bf2587ba92@gmail.com>
Date:   Wed, 13 Nov 2019 07:25:57 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <6706c94a-2252-c0b2-6dcb-511f0b3ad2a6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.11.2019 05:13, Florian Fainelli wrote:
> 
> 
> On 11/12/2019 1:22 PM, Heiner Kallweit wrote:
>> Certain Realtek PHY's support a proprietary "extended page" access mode
>> that is used in the Realtek PHY driver and in r8169 network driver.
>> Let's implement it properly in the Realtek PHY driver and export it for
>> use in other drivers like r8169.
>>
>> Heiner Kallweit (3):
>>   net: phy: realtek: export rtl821x_modify_extpage
>>   r8169: use rtl821x_modify_extpage
>>   r8169: consider new hard dependency on REALTEK_PHY
>>
>>  drivers/net/ethernet/realtek/Kconfig      |  3 +-
>>  drivers/net/ethernet/realtek/r8169_main.c | 41 +++++++++--------------
>>  drivers/net/phy/realtek.c                 | 36 ++++++++++++--------
>>  include/linux/realtek_phy.h               |  8 +++++
>>  4 files changed, 46 insertions(+), 42 deletions(-)
> 
> The delta is not that impressive and this creates not quite a layering
> violation, but some really weird inter dependency if nothing else. Could
> we simply move all the PHY programming down the PHY driver instead or is
> this too cumbersome/fragile to do right now?
> 
The Realtek chips come with integrated MAC and PHY, so the dependency
reflects the physical structure. Moving all PHY configuration to the
PHY driver would be best of course, but:
- Even though few chip versions use the PHY ID of a PHY that exists
  also standalone, the configuration sequence differs. So it seems
  they differ.
- From a certain chip version the PHY ID is always the same:
  Realtek OUI, but model and revision number being zero. Means we'd have
  to intercept the PHY ID reads and return artificial PHY ID's.
- PHY config sequence partially includes efuse reads from MAC registers,
  see rtl8168d_1_hw_phy_config. OK, maybe we could read the efuse first,
  and hand over the value to the PHY driver via PHY driver private data
  structure.
  
Heiner
