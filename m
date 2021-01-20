Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44AAB2FCB46
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 08:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbhATHIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 02:08:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbhATHIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 02:08:22 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F95C0613CF
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 23:07:42 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id s24so2731339wmj.0
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 23:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3M+HQe8vqmP8VRtU3XAyk2ZUt7fWVlBWnbyqOHs7X+M=;
        b=oAXOTMM5RhtKKruuhstmuCMun8C5PB4uXs15z8wlCYYe5LTA3c2FnsmeZsJuOwcyGB
         UDwmfmPiIdKjA/LWS/dKIMryEtdPM1FWQxBxBiXYq7IRCLdHs4ea5vxTa+DEoBhUXRvP
         wpYcc04+/eAd4spl3rAvvZM0vX0jkH+B2EnBtLLN2WWSdx8l1s1eRg9gKUgkVwXljYPa
         ISminmuEj2ObVeWRQr5Op/G9IHcjGqflplccjPDnfP8PSonS7+6WjBS08AADzk9JX4hr
         Za/sdtwGIsfCsmE3Vscj4hxmgAnOAAQXKA2dOX+tkc7tj5Eetj4enySRNYZAJERDlKx+
         /jiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3M+HQe8vqmP8VRtU3XAyk2ZUt7fWVlBWnbyqOHs7X+M=;
        b=SQjjPGC6PuCETIrJpa9tbODSzbIKZlRKPHpzl2mKZHLcxsaQQHDTO9DbefJJMDh9OH
         M1uCYgJZhkDBRTQY7wMpmLnb7WyouHl4VDJyyvzZehduP1nZB4UPgIGk4ocYlNRvX+LV
         O9tHZdQ+AfQ2RfYdmlSIVDFTKpkyHvXZ7r6oDWx/6nn+8gCPVuTgcZYECuVoPi2RfOuw
         7LmibbodzvwZJoHMwFOib/bcWjPiRlI4B506wtPOE1Hlg0soeGVyfxz07Bgw7Dg9t1ca
         f/+69vZO/jrvTOmx6oIlWKixjng/QF/rY6+J1VWUzU8fYP9IL2S7qb+sCrSOR1eDRjkX
         A6ng==
X-Gm-Message-State: AOAM5329bbM8wFtwVrILhzO1+Kc3oFXPOLbPDx/9677oLUMvZFmjkjGM
        bvVxu7k7kRpDgkLOlxybPNK3rnUHmFM=
X-Google-Smtp-Source: ABdhPJwCUoW3Vq72W51SKseQNUhE9rLxJmW3VXm5oE4p7Y2rDSyCbUZMcuBkOlnye0o1PPq41Ci8FA==
X-Received: by 2002:a1c:7e02:: with SMTP id z2mr2717816wmc.173.1611126460883;
        Tue, 19 Jan 2021 23:07:40 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:a490:e863:b4df:cade? (p200300ea8f065500a490e863b4dfcade.dip0.t-ipconnect.de. [2003:ea:8f06:5500:a490:e863:b4df:cade])
        by smtp.googlemail.com with ESMTPSA id f68sm2222734wmf.6.2021.01.19.23.07.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jan 2021 23:07:40 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next] cxgb4: remove bogus CHELSIO_VPD_UNIQUE_ID
 constant
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Raju Rangoju <rajur@chelsio.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <25339251-513a-75c6-e96e-c284d23eed0f@gmail.com>
 <20210119140228.1f210886@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <85fe1327-3f75-c480-c5e2-0045877188ce@gmail.com>
Date:   Wed, 20 Jan 2021 08:07:32 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210119140228.1f210886@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.01.2021 23:02, Jakub Kicinski wrote:
> On Sat, 16 Jan 2021 14:45:25 +0100 Heiner Kallweit wrote:
>> The comment is quite weird, there is no such thing as a vendor-specific
>> VPD id. 0x82 is the value of PCI_VPD_LRDT_ID_STRING. So what we are
>> doing here is simply checking whether the byte at VPD address VPD_BASE
>> is a valid string LRDT, same as what is done a few lines later in
>> the code.
>> LRDT = Large Resource Data Tag, see PCI 2.2 spec, VPD chapter
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> Did you find this by code inspection?
> 
Well, more or less ..
RTL8168 indicates it has VPD but in all cases I've seen there is no
VPD EEPROM. Result is that the VPD code throws an "invalid VPD tag" error.
When checking the VPD code (+ VPD spec) and its (few) users I came across
the chelsio driver.

>> diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
>> index 2c80371f9..48f20a6a0 100644
>> --- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
>> +++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
>> @@ -2689,7 +2689,6 @@ void t4_get_regs(struct adapter *adap, void *buf, size_t buf_size)
>>  #define VPD_BASE           0x400
>>  #define VPD_BASE_OLD       0
>>  #define VPD_LEN            1024
>> -#define CHELSIO_VPD_UNIQUE_ID 0x82
>>  
>>  /**
>>   * t4_eeprom_ptov - translate a physical EEPROM address to virtual
>> @@ -2743,9 +2742,9 @@ int t4_seeprom_wp(struct adapter *adapter, bool enable)
>>   */
>>  int t4_get_raw_vpd_params(struct adapter *adapter, struct vpd_params *p)
>>  {
>> -	int i, ret = 0, addr;
>> +	int i, ret = 0, addr = VPD_BASE;
> 
> IMHO it's more readable if the addr is set to BASE or BASE_OLD in one
> place rather than having a default value at variable init which may be
> overwritten.
> 
OK. Thought was just that VPD_BASE is the more common case.
I'll change this in a v2.

>>  	int ec, sn, pn, na;
>> -	u8 *vpd, csum;
>> +	u8 *vpd, csum, base_val = 0;
>>  	unsigned int vpdr_len, kw_offset, id_len;
>>  
>>  	vpd = vmalloc(VPD_LEN);
>> @@ -2755,17 +2754,12 @@ int t4_get_raw_vpd_params(struct adapter *adapter, struct vpd_params *p)
>>  	/* Card information normally starts at VPD_BASE but early cards had
>>  	 * it at 0.
>>  	 */
>> -	ret = pci_read_vpd(adapter->pdev, VPD_BASE, sizeof(u32), vpd);
>> +	ret = pci_read_vpd(adapter->pdev, VPD_BASE, 1, &base_val);
> 
> Are we sure this works? I've seen silicon out there which has problems
> with small PCI accesses (granted those were not VPD accesses).
> 
The underlying PCI register access reads 4 bytes, the VPD code will ignore
the higher three bytes here.

>>  	if (ret < 0)
>>  		goto out;
>>  
>> -	/* The VPD shall have a unique identifier specified by the PCI SIG.
>> -	 * For chelsio adapters, the identifier is 0x82. The first byte of a VPD
>> -	 * shall be CHELSIO_VPD_UNIQUE_ID (0x82). The VPD programming software
>> -	 * is expected to automatically put this entry at the
>> -	 * beginning of the VPD.
>> -	 */
>> -	addr = *vpd == CHELSIO_VPD_UNIQUE_ID ? VPD_BASE : VPD_BASE_OLD;
>> +	if (base_val != PCI_VPD_LRDT_ID_STRING)
>> +		addr = VPD_BASE_OLD;
>>  
>>  	ret = pci_read_vpd(adapter->pdev, addr, VPD_LEN, vpd);
>>  	if (ret < 0)
> 



