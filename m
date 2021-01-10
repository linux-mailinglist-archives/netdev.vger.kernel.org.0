Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70C7C2F06F8
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 13:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbhAJL7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 06:59:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbhAJL73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 06:59:29 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D525EC061786
        for <netdev@vger.kernel.org>; Sun, 10 Jan 2021 03:58:48 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id a12so13429578wrv.8
        for <netdev@vger.kernel.org>; Sun, 10 Jan 2021 03:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VOETL7gEzkQ/orNVR7vG9RCP5ZswGFgScTdaUs8p7Js=;
        b=W9QpH/ygwsdRLt2Wo6FWcSNCUM5yAm9kTqpanlt0d3jcZLM49lTazaIHqbVrqcC0CO
         CwHgolZoxtiR36W4n+znvX+zfr/h839gt38AQYTdOwoV5NjLMJfKyf2DiaZ3PD36JUCv
         BsB/ro/0moCvSyHZyUgz3ytdQagc2Q+5aei5OznhXAS6tJpXRtuR51pMdQSSySavXhDj
         2gKcgNGyyzyqg7QLuubVwHq6oDhvCuW5AGPpDUq65XdSkeJICyNZPBDLq7RGC5ANTluP
         MVCttCq9Z7kkhQpgXFFP5k8OHtLf7hDxFkUq29Z70EGHE+ORzY+/iBrH/fk8XXOLXHg2
         fW1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VOETL7gEzkQ/orNVR7vG9RCP5ZswGFgScTdaUs8p7Js=;
        b=uUzLYV1ISffHCkUveJV8h/jnif13x5uK5UYBIydKCKN+5M4s9B9e1c62hwFF1UdGjx
         bnQw0yHL4vRUXEn0Gd4yzNOrLNTRwk200XpVFCsKeXs8O6DLVWFef6Qnyc3qrFrnuN8x
         RVDn9G/HuCJBjIrklcoIOH84qECQJrXHtTIbWq+GybUJtd95jdDI0nSnQk77G2kSkBTw
         Gwslsjq9nh0omFKMXUBsW/4FH2bCx40Aay8j135y4AWxYhcykc6qZhozq3h0hj04athq
         cXmqI3j3RoyA2TSufieM7rgTmuSZizU4NyXtcTOwPrOmnkrT5VKnf9f//T+9PAao6mh5
         JqZw==
X-Gm-Message-State: AOAM533pFmBQ1hdbSaeh2jcbt38Qc2v37Qpx9yL3WZFhPwpHw4IFK2BS
        BKVM/AV6i6FitoX5RDVMleeeNTWgtkU=
X-Google-Smtp-Source: ABdhPJzLF7emAnBWHw1l2qVKu8xu3Kr+f8mj6KQgVk0NzdgphRnJikk6IyMo0aIEp6mRwZu9kwwClw==
X-Received: by 2002:a5d:6209:: with SMTP id y9mr11902445wru.197.1610279927415;
        Sun, 10 Jan 2021 03:58:47 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:45c0:cdfd:d838:af6f? (p200300ea8f06550045c0cdfdd838af6f.dip0.t-ipconnect.de. [2003:ea:8f06:5500:45c0:cdfd:d838:af6f])
        by smtp.googlemail.com with ESMTPSA id k128sm19107623wma.43.2021.01.10.03.58.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Jan 2021 03:58:46 -0800 (PST)
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <fb6ff074-a9c3-94ce-0636-52276d8604f2@gmail.com>
 <20210109181744.6b53c946@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next] r8169: deprecate support for RTL_GIGA_MAC_VER_27
Message-ID: <facbe27f-3b5e-6dc2-8837-e3989b178847@gmail.com>
Date:   Sun, 10 Jan 2021 12:58:40 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210109181744.6b53c946@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.01.2021 03:17, Jakub Kicinski wrote:
> On Fri, 8 Jan 2021 13:24:16 +0100 Heiner Kallweit wrote:
>> RTL8168dp is ancient anyway, and I haven't seen any trace of its early
>> version 27 yet. This chip versions needs quite some special handling,
>> therefore it would facilitate driver maintenance if support for it
>> could be dropped. For now just disable detection of this chip version.
>> If nobody complains we can remove support for it in the near future.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/net/ethernet/realtek/r8169_main.c | 6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>> index e72d8f3ae..f94965615 100644
>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>> @@ -1962,7 +1962,11 @@ static enum mac_version rtl8169_get_mac_version(u16 xid, bool gmii)
>>  		{ 0x7c8, 0x280,	RTL_GIGA_MAC_VER_26 },
>>  
>>  		/* 8168DP family. */
>> -		{ 0x7cf, 0x288,	RTL_GIGA_MAC_VER_27 },
>> +		/* It seems this early RTL8168dp version never made it to
>> +		 * the wild. Let's see whether somebody complains, if not
>> +		 * we'll remove support for this chip version completely.
>> +		 * { 0x7cf, 0x288,      RTL_GIGA_MAC_VER_27 },
>> +		 */
>>  		{ 0x7cf, 0x28a,	RTL_GIGA_MAC_VER_28 },
>>  		{ 0x7cf, 0x28b,	RTL_GIGA_MAC_VER_31 },
>>  
> 
> No objection to deprecating the support (although quick grep does not
> reveal the special handling you speak of), but would it make sense to
> also print some message to save the potential user out there debug time?

Version 27 has it's own way of handling MDIO access, we could get rid of
r8168dp_1_mdio_access(), r8168dp_1_mdio_write(), r8168dp_1_mdio_read(),
and also of the chip-specific PHY config rtl8168d_3_hw_phy_config().

> Something like:
> 
> 	dev_err(dev, "support for device has been removed please contact <email>");
> 
So far we'd emit the following error in dmesg: "unknown chip XID 288".
I agree that we should add a hint to contact the maintainers, this may help
also in case somebody has a system with a new, not yet supported chip version.

> ?
> 

