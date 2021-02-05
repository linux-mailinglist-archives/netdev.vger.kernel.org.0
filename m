Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4B6311587
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbhBEOHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 09:07:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbhBEOBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 09:01:50 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BFFAC0613D6;
        Fri,  5 Feb 2021 06:01:09 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id d16so7742300wro.11;
        Fri, 05 Feb 2021 06:01:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hJspoQKIWUzdqDPt9UWimHH0DAFk1pHJ8MGdnopELRM=;
        b=TbgxvQwdyRdJnL6aC/RVtpAN64WPVpCuWqYVibPDl1RzW1bo+BTGeVs2qIO7O4VDKI
         PVkuDIJ9dx8W7pOY2MYtoKkrH9vdOTkpbSiCSuoWCYBf4zE4goOBgKoiFlVU4n0sniBF
         73HUmD2oMp2gPootywJ7YJTeAJhBrdMdJTaTlgWn5QH4utkXlJ9BJYXtCkwC7kbf/nv9
         9+WNvOnquXRoR3wuHQsKEPVLf33XtegEeZ91h/wgVDpkXrkjz2ozOSsz3G69hsMfAOLj
         CrkadTN5v5LCORn7VJHPSYGD8Cp9gLgGXVf5YJpaeBPEbtKXgw3bJvlUY/9i+1fP6I6b
         L4Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hJspoQKIWUzdqDPt9UWimHH0DAFk1pHJ8MGdnopELRM=;
        b=cVkQnprIwBSxTr7F6mLercTf5SepRdN7t0d/j9K/GNwVZMUm66tGcFE+tVNCdkigt6
         UhacaE8PKdDCNWNetGf3rmpkv0QRS+HJk8CA9+jn6OLKyGfW6GBRk65HXGw0GzFXQ7ER
         q66yCAHQfpk8xroSvcsDZgc7QM80p5QiBcYHpULJUSR4XlmH5/eHDSPRERpYnmLYwuie
         uzP4PB80mGoOZ5C5FUdauyD5GXEbAMcmVC+Vv26IKDXomgwlm7oYH9ijkFAJba6QInX6
         Jl6dZc64axJ5IVclArlYNnDaYMhp31PJhPmomF7Fugc+65pnpl7KhQsP+8MjeYbbHq25
         YetA==
X-Gm-Message-State: AOAM531HfHXPYJajuXFyJBD25BOyBXCBYRrJ+opWwZcqvP8lhxUfPsTY
        PY1vos+IFNQrbzajwC9033A=
X-Google-Smtp-Source: ABdhPJzCGvEVCDOdYAaKYmj7TV7crawJZIXaa4q+THPqLYCe41MbPaQQeoVutg+aTDxp8CgVCb2fHA==
X-Received: by 2002:a05:6000:12c7:: with SMTP id l7mr5149539wrx.103.1612533668071;
        Fri, 05 Feb 2021 06:01:08 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:9118:8653:7e7:879e? (p200300ea8f1fad009118865307e7879e.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:9118:8653:7e7:879e])
        by smtp.googlemail.com with ESMTPSA id d30sm14059811wrc.92.2021.02.05.06.01.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 06:01:07 -0800 (PST)
Subject: Re: [PATCH net-next 1/4] PCI/VPD: Remove Chelsio T3 quirk
To:     Raju Rangoju <rajur@chelsio.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        rahul.lakkireddy@chelsio.com
References: <b07dc99d-7fd0-48c0-3fc4-89cda90ee5d7@gmail.com>
 <a64e550c-b8d2-889e-1f55-019b10060c1b@gmail.com>
 <20210205124236.GA18529@chelsio.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <fd24860f-67b0-e1ef-16e6-889cb08c5567@gmail.com>
Date:   Fri, 5 Feb 2021 15:01:02 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210205124236.GA18529@chelsio.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.02.2021 13:42, Raju Rangoju wrote:
> On Tuesday, February 02/02/21, 2021 at 21:35:55 +0100, Heiner Kallweit wrote:
>> cxgb3 driver doesn't use the PCI core code for VPD access, it has its own
>> implementation. Therefore we don't need a quirk for it in the core code.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/pci/vpd.c | 13 ++++---------
>>  1 file changed, 4 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/pci/vpd.c b/drivers/pci/vpd.c
>> index 7915d10f9..db86fe226 100644
>> --- a/drivers/pci/vpd.c
>> +++ b/drivers/pci/vpd.c
>> @@ -628,22 +628,17 @@ static void quirk_chelsio_extend_vpd(struct pci_dev *dev)
>>  {
>>  	int chip = (dev->device & 0xf000) >> 12;
>>  	int func = (dev->device & 0x0f00) >>  8;
>> -	int prod = (dev->device & 0x00ff) >>  0;
>>  
>>  	/*
>> -	 * If this is a T3-based adapter, there's a 1KB VPD area at offset
>> -	 * 0xc00 which contains the preferred VPD values.  If this is a T4 or
>> -	 * later based adapter, the special VPD is at offset 0x400 for the
>> -	 * Physical Functions (the SR-IOV Virtual Functions have no VPD
>> -	 * Capabilities).  The PCI VPD Access core routines will normally
>> +	 * If this is a T4 or later based adapter, the special VPD is at offset
>> +	 * 0x400 for the Physical Functions (the SR-IOV Virtual Functions have
>> +	 * no VPD Capabilities). The PCI VPD Access core routines will normally
>>  	 * compute the size of the VPD by parsing the VPD Data Structure at
>>  	 * offset 0x000.  This will result in silent failures when attempting
>>  	 * to accesses these other VPD areas which are beyond those computed
>>  	 * limits.
>>  	 */
>> -	if (chip == 0x0 && prod >= 0x20)
>> -		pci_set_vpd_size(dev, 8192);
> 
> The above quirk has been added by the following commit to fix VPD access
> issue in the guest VM. Wouldn't removing this quirk reopen the original
> issue?
> 

Indeed, I looked at cxgb3 and missed the problematic vfio-pci use case.
So let me remove patch 1 from the series.

> ----------------------------------------------------------
> commit 1c7de2b4ff886a45fbd2f4c3d4627e0f37a9dd77
> Author: Alexey Kardashevskiy <aik@ozlabs.ru>
> Date:   Mon Oct 24 18:04:17 2016 +1100
> 
> PCI: Enable access to non-standard VPD for Chelsio devices (cxgb3)
> 
> There is at least one Chelsio 10Gb card which uses VPD area to store 
> some non-standard blocks (example below).  However pci_vpd_size() returns the 
> length of the first block only assuming that there can be only one VPD "End 
> Tag".
> 
> Since 4e1a635552d3 ("vfio/pci: Use kernel VPD access functions"), VFIO
> blocks access beyond that offset, which prevents the guest "cxgb3" driver
> from probing the device.  The host system does not have this problem as its
> driver accesses the config space directly without pci_read_vpd().
> 
> Add a quirk to override the VPD size to a bigger value.  The maximum size
> is taken from EEPROMSIZE in drivers/net/ethernet/chelsio/cxgb3/common.h.
> We do not read the tag as the cxgb3 driver does as the driver supports
> writing to EEPROM/VPD and when it writes, it only checks for 8192 bytes
> boundary.  The quirk is registered for all devices supported by the cxgb3
> driver.
> 
> This adds a quirk to the PCI layer (not to the cxgb3 driver) as the cxgb3
> driver itself accesses VPD directly and the problem only exists with the
> vfio-pci driver (when cxgb3 is not running on the host and may not be even
> loaded) which blocks accesses beyond the first block of VPD data. However
> vfio-pci itself does not have quirks mechanism so we add it to PCI.
> 
> This is the controller:
> Ethernet controller [0200]: Chelsio Communications Inc T310 10GbE Single
> Port Adapter [1425:0030]
> 
> This is what I parsed from its VPD:
> ===
>   b'\x82*\x0010 Gigabit Ethernet-SR PCI Express Adapter\x90J\x00EC\x07D76809
>   FN\x0746K'
> 
>   0000 Large item 42 bytes; name 0x2 Identifier	String
> 	b'10 Gigabit Ethernet-SR PCI Express Adapter'
>     002d Large item 74	bytes; name 0x10
> 	#00 [EC] len=7:	b'D76809'
> 	#0a [FN] len=7:	b'46K7897'
> 	#14 [PN] len=7:	b'46K7897'
> 	#1e [MN] len=4:	b'1037'
> 	#25 [FC] len=4:	b'5769'
> 	#2c [SN] len=12: b'YL102035603V'
> 	#3b [NA] len=12: b'00145E992ED1'
>     007a Small item 1 bytes; name 0xf End Tag
>     0c00 Large item 16 bytes; name 0x2 Identifier String
> 	b'S310E-SR-X      '
>     0c13 Large item 234 bytes; name 0x10
> 	#00 [PN] len=16: b'TBD             '
> 	#13 [EC] len=16: b'110107730D2     '
> 	#26 [SN] len=16: b'97YL102035603V  '
> 	#39 [NA] len=12: b'00145E992ED1'
> 	#48 [V0] len=6: b'175000'
> 	#51 [V1] len=6: b'266666'
> 	#5a [V2] len=6: b'266666'
> 	#63 [V3] len=6: b'2000  '
> 	#6c [V4] len=2: b'1 '
> 	#71 [V5] len=6: b'c2    '
> 	#7a [V6] len=6: b'0     '
> 	#83 [V7] len=2: b'1 '
> 	#88 [V8] len=2: b'0 '
> 	#8d [V9] len=2: b'0 '
> 	#92 [VA] len=2: b'0 '
> 	#97 [RV] len=80:
> 	b's\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00'...
>    0d00 Large item 252 bytes; name 0x11
> 	#00 [VC] len=16: b'122310_1222 dp  '
> 	#13 [VD] len=16: b'610-0001-00 H1\x00\x00'
> 	#26 [VE] len=16: b'122310_1353 fp  '
> 	#39 [VF] len=16: b'610-0001-00 H1\x00\x00'
> 	 #4c [RW] len=173:
> 	 b'\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00'...
>    0dff Small item 0 bytes; name 0xf End Tag
> 
>    10f3 Large item 13315 bytes; name 0x62
>    !!! unknown item name 98:
>    b'\xd0\x03\x00@`\x0c\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00'
>    ===
> 
>    Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> ---------------------------------------------
> 
> 
>> -	else if (chip >= 0x4 && func < 0x8)
>> +	if (chip >= 0x4 && func < 0x8)
>>  		pci_set_vpd_size(dev, 2048);
>>  }
>>  
>> -- 
>> 2.30.0
>>
>>

