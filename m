Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64BED2EC2B3
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 18:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbhAFRsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 12:48:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727203AbhAFRsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 12:48:42 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF8EC061575;
        Wed,  6 Jan 2021 09:48:01 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id q22so6228959eja.2;
        Wed, 06 Jan 2021 09:48:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IGY7/SPZqlhfzimwK9zIX4GmCaCBvqq2AJVtpbzpQ5s=;
        b=eaTLHJM7ITvqDCpMKNycI2E8rrcp1NBR4Iv3hQ9WhhMlEihcyC7rDtMCipqCgwNzHr
         cQ/SUdZLiaIHE7M7oRlL4jb7fQ0fJ1Lm1EZQyJgtbCwG5QHXkJ1Z0O18TLLgEhumaUgE
         GUkeHx0feO0t2HnHaC0AOvfFP/bqOJsJa0A/pTNIq/EjjwqDWmap0H158F0Yv1HBf7/2
         CbLgxxx6tCNAsA37Q1VMcsSW5Dxyt+xBLvNW/00VjVYJVLNDU+cgYHgirGwnSbaWMKUF
         Y2lWdi5K4K5MoP9/D1xZ8inR18dljhpPDRoYx0cBA8Kf87kNOrVmcG//yWUDTR/MHMU+
         bFPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IGY7/SPZqlhfzimwK9zIX4GmCaCBvqq2AJVtpbzpQ5s=;
        b=t8NWm9+a+vieo/LNMt2m6Od4/YPk4S8IiPIJOtQHxAw4LK5HrAlGjZqvIcIM2JRxoy
         i/7/JlHatBKi5D8918LXnCuBN9bA0qfilyyweMGLxzaJzip7HDB1Fe6gyNVlvUeSYp77
         nl9o2W5qyoxZR+vy0vc1ePhCcsR0pw60obzGN3zxjpRqapnG472ZCwDoVjPR0Vpz3jBX
         FdlgbhJGzoOUt/4Zhw+5y69GS0QXhLtd1w5Pfi/etftGmRvq/By8mAQeUVfkHMYDKlst
         q2OWC6U+G4LThq/1fLLD3zKXMpb7kfkxj/03iL7v1iPBA3opW/2zH6j98IiRHmigQ2MT
         JBfg==
X-Gm-Message-State: AOAM530ch/4n+igXFptervtvQ1tu0eFU02qXKiznkExJb6AnQRNYjEeo
        KLDvpqp6f/ut0TeDqOchs0rw7T9VyAM=
X-Google-Smtp-Source: ABdhPJyyVMZKqQNBBrjTGQENxqC0tOeWGnnfGvrShGZYkXODVDPN+il+hAD54F5fnYFhQUWOwtTy+Q==
X-Received: by 2002:a17:906:2ccb:: with SMTP id r11mr3651863ejr.39.1609955280095;
        Wed, 06 Jan 2021 09:48:00 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:e1db:b990:7e09:f1cf? (p200300ea8f065500e1dbb9907e09f1cf.dip0.t-ipconnect.de. [2003:ea:8f06:5500:e1db:b990:7e09:f1cf])
        by smtp.googlemail.com with ESMTPSA id x16sm1536046ejb.38.2021.01.06.09.47.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 09:47:59 -0800 (PST)
Subject: Re: [PATCH v2 2/3] ARM: iop32x: improve N2100 PCI broken parity
 quirk'
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20210106173725.GA1316633@bjorn-Precision-5520>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <297679ab-6a72-7f99-6b72-9b26675342cf@gmail.com>
Date:   Wed, 6 Jan 2021 18:47:56 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210106173725.GA1316633@bjorn-Precision-5520>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.01.2021 18:37, Bjorn Helgaas wrote:
> On Wed, Jan 06, 2021 at 12:05:41PM +0100, Heiner Kallweit wrote:
>> Use new PCI core function pci_quirk_broken_parity(), in addition to
>> setting broken_parity_status is disables parity checking.
> 
> That sentence has a typo or something so it doesn't read quite right.
> Maybe:
> 
>   Use new PCI core function pci_quirk_broken_parity() to disable
>   parity checking.
> 
OK, let me adjust this in a v3.

> "broken_parity_status" is basically internal to the PCI core and
> doesn't really seem relevant here.  The only uses are the sysfs
> store/show functions and edac.
> 
>> This allows us to remove a quirk in r8169 driver.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>> v2:
>> - remove additional changes from this patch
>> ---
>>  arch/arm/mach-iop32x/n2100.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/mach-iop32x/n2100.c b/arch/arm/mach-iop32x/n2100.c
>> index 78b9a5ee4..9f2aae3cd 100644
>> --- a/arch/arm/mach-iop32x/n2100.c
>> +++ b/arch/arm/mach-iop32x/n2100.c
>> @@ -125,7 +125,7 @@ static void n2100_fixup_r8169(struct pci_dev *dev)
>>  	if (dev->bus->number == 0 &&
>>  	    (dev->devfn == PCI_DEVFN(1, 0) ||
>>  	     dev->devfn == PCI_DEVFN(2, 0)))
>> -		dev->broken_parity_status = 1;
>> +		pci_quirk_broken_parity(dev);
>>  }
>>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_REALTEK, PCI_ANY_ID, n2100_fixup_r8169);
>>  
>> -- 
>> 2.30.0
>>
>>

