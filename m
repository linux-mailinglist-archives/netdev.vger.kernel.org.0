Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E612EE3F45
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 00:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731451AbfJXWTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 18:19:36 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36957 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730505AbfJXWTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 18:19:36 -0400
Received: by mail-wm1-f67.google.com with SMTP id q130so40827wme.2;
        Thu, 24 Oct 2019 15:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=61tXmnwFgJupwGh7MTwQnvoEyl8qr5HF8JRPeMrYT4o=;
        b=aAKEmAV9oCDvcrpEBE5Ux1dq5lngg5qRa+Rvg9vKT090LewtSsw031Y0nxPLkdY1j5
         XgPy5rt4dO1jqBLXXJW2WJyXExKsU8uKWcPHRRnAbJLcUp2VOI2CkWrdgQRINDFHk6iD
         gDMxcu35dlZEMh0DkleIMRyHrCbD6Av6sGm4itcxO444e3zMEr150DHdml3oVfObj5KA
         2elyO6Nv6gsOVH+n9o5ZC3n75TYPtBwCsV3zM/GXEGHNWKGk1eUch/+lEs9ezljGQINc
         WVS/SFQFNQDp4ACYoQEHtzUmEfKeVlyKyi0eiKKoUIgxC7HubikG1SUnQlw7eLq5vXQe
         Uo8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=61tXmnwFgJupwGh7MTwQnvoEyl8qr5HF8JRPeMrYT4o=;
        b=QUPMwfcmHyUQ87c+008hHlDcxcZhhxohuETDr+9+bd93uFpy9fs43t5hi6i3bS/s3t
         STSFIO65pk6Mk+2DzTGYBp1TE6i/sfDlifmqcmawlczQOsmKllB9te7PxQVMp4JGJwgx
         LbzJDsjosd+FCxtsNINkR1ZJrLdJerKyjQybQAOjgS4htdI9GgpUxJsiuGv4OT4sStxV
         OtjOeDxx95clFlszYqYdL+HYnrikBo+J3Hxpu/PTv1fc9hDuQPTgj4lDpBNU5do3Bo+u
         +/7RjY5PssVq2ilKtYiKaJUrZ9mhGnCGjNBhmyVX/WLLclMhu+FT5dUZMdMI0owRl3ih
         nFKA==
X-Gm-Message-State: APjAAAWLODJyXZjEd8d5L55gFMDyq1NmnfCw8XYJx3YLKKOTubi0WRGk
        4AMZORrpQRuWf4q7ODQBfQqlrz0p
X-Google-Smtp-Source: APXvYqwt5BDAwJOlSy4Hf4D40159EQG0+Do/4ZiNROZFuw0GrF1NViFnW95+vUKoaGKRshLbdMG/zQ==
X-Received: by 2002:a1c:96c9:: with SMTP id y192mr556340wmd.8.1571955571597;
        Thu, 24 Oct 2019 15:19:31 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:ac52:2d04:d8e7:8f98? (p200300EA8F266400AC522D04D8E78F98.dip0.t-ipconnect.de. [2003:ea:8f26:6400:ac52:2d04:d8e7:8f98])
        by smtp.googlemail.com with ESMTPSA id i3sm140505wrw.69.2019.10.24.15.19.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Oct 2019 15:19:31 -0700 (PDT)
Subject: Re: [PATCH wireless-drivers 1/2] mt76: mt76x2e: disable pcie_aspm by
 default
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     kvalo@codeaurora.org, linux-wireless@vger.kernel.org, nbd@nbd.name,
        sgruszka@redhat.com, lorenzo.bianconi@redhat.com,
        oleksandr@natalenko.name, netdev@vger.kernel.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
References: <cover.1571868221.git.lorenzo@kernel.org>
 <fec60f066bab1936d58b2e69bae3f20e645d1304.1571868221.git.lorenzo@kernel.org>
 <5924c8eb-7269-b8ef-ad0e-957104645638@gmail.com>
 <20191024215451.GA30822@lore-desk.lan>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <9cac34a5-0bfe-0443-503f-218210dab4d6@gmail.com>
Date:   Fri, 25 Oct 2019 00:19:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191024215451.GA30822@lore-desk.lan>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.10.2019 23:54, Lorenzo Bianconi wrote:
>> On 24.10.2019 00:23, Lorenzo Bianconi wrote:
>>> On same device (e.g. U7612E-H1) PCIE_ASPM causes continuous mcu hangs and
>>> instability and so let's disable PCIE_ASPM by default. This patch has
>>> been successfully tested on U7612E-H1 mini-pice card
>>>
>>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
>>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>>> ---
>>>  drivers/net/wireless/mediatek/mt76/mmio.c     | 47 +++++++++++++++++++
>>>  drivers/net/wireless/mediatek/mt76/mt76.h     |  1 +
>>>  .../net/wireless/mediatek/mt76/mt76x2/pci.c   |  2 +
>>>  3 files changed, 50 insertions(+)
>>>
> 
> [...]
> 
>>> +
>>> +	if (parent)
>>> +		pcie_capability_clear_word(parent, PCI_EXP_LNKCTL,
>>> +					   aspm_conf);
>>
>> + linux-pci mailing list
> 
> Hi Heiner,
> 
>>
>> All this seems to be legacy code copied from e1000e.
>> Fiddling with the low-level PCI(e) registers should be left to the
>> PCI core. It shouldn't be needed here, a simple call to
>> pci_disable_link_state() should be sufficient. Note that this function
>> has a return value meanwhile that you can check instead of reading
>> back low-level registers.
> 
> ack, I will add it to v2
> 
>> If BIOS forbids that OS changes ASPM settings, then this should be
>> respected (like PCI core does). Instead the network chip may provide
>> the option to configure whether it activates certain ASPM (sub-)states
>> or not. We went through a similar exercise with the r8169 driver,
>> you can check how it's done there.
> 
> looking at the vendor sdk (at least in the version I currently have) there are
> no particular ASPM configurations, it just optionally disables it writing directly
> in pci registers.
> Moreover there are multiple drivers that are currently using this approach:
> - ath9k in ath_pci_aspm_init()
> - tg3 in tg3_chip_reset()
> - e1000e in __e1000e_disable_aspm()
> - r8169 in rtl_enable_clock_request()/rtl_disable_clock_request()
> 
All these drivers include quite some legacy code. I can mainly speak for r8169:
First versions of the driver are almost as old as Linux. And even though I
refactored most of the driver still some legacy code for older chip versions
(like the two functions you mentioned) is included.

> Is disabling the ASPM for the system the only option to make this minipcie
> work?
> 

No. What we do in r8169:

- call pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1)
- If it returns 0, then ASPM (including the L1 sub-states) is disabled.
- If it returns an errno, then disabling ASPM failed (most likely due to
  BIOS forbidding ASPM changes - pci_disable_link_state will spit out
  a related warning). In this case r8169 configures the chip to not initiate
  transitions to L0s/L1 (the other end of the link may still try to enter
  ASPM states). See rtl_hw_aspm_clkreq_enable(). That's sufficient
  to avoid the ASPM-related problems with certain versions of this chip.
  Maybe your HW provides similar functionality.

> Regards,
> Lorenzo
> 
Heiner

>>
>>> +}
>>> +EXPORT_SYMBOL_GPL(mt76_mmio_disable_aspm);
>>> +
>>>  void mt76_mmio_init(struct mt76_dev *dev, void __iomem *regs)
>>>  {
>>>  	static const struct mt76_bus_ops mt76_mmio_ops = {
>>> diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
>>> index 570c159515a0..962812b6247d 100644
>>> --- a/drivers/net/wireless/mediatek/mt76/mt76.h
>>> +++ b/drivers/net/wireless/mediatek/mt76/mt76.h
>>> @@ -578,6 +578,7 @@ bool __mt76_poll_msec(struct mt76_dev *dev, u32 offset, u32 mask, u32 val,
>>>  #define mt76_poll_msec(dev, ...) __mt76_poll_msec(&((dev)->mt76), __VA_ARGS__)
>>>  
>>>  void mt76_mmio_init(struct mt76_dev *dev, void __iomem *regs);
>>> +void mt76_mmio_disable_aspm(struct pci_dev *pdev);
>>>  
>>>  static inline u16 mt76_chip(struct mt76_dev *dev)
>>>  {
>>> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
>>> index 73c3104f8858..264bef87e5c7 100644
>>> --- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
>>> +++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
>>> @@ -81,6 +81,8 @@ mt76pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>>  	/* RG_SSUSB_CDR_BR_PE1D = 0x3 */
>>>  	mt76_rmw_field(dev, 0x15c58, 0x3 << 6, 0x3);
>>>  
>>> +	mt76_mmio_disable_aspm(pdev);
>>> +
>>>  	return 0;
>>>  
>>>  error:
>>>
>>

