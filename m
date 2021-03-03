Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFDB32C40C
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381588AbhCDAKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:10:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241098AbhCCK1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 05:27:03 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69710C061788;
        Wed,  3 Mar 2021 02:26:21 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id w7so4696794wmb.5;
        Wed, 03 Mar 2021 02:26:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ma2HB9E5H3KHA4WWM5KO4LEHsZhrnd0lev/W5XpOJBI=;
        b=uFnkDTh4CHyxgbYj+CNPtDrs37vUhVntKwvYUFMhdcKqtVQE/BpC2zgHu7Wc1kb8JB
         fZWhXFn/O5I2IXikx3emJFdGhDai7DcsXEUUTm9j2UcbI4vQbu9cw2fGw+WRD68/YzgE
         9vujTiDiZboJpoSUC6Jg+lX4dfu588KtqRpuQiZXy5HFKKFtMq6yF6nePomQaptv/a0t
         4YHNVtxea0x/Dbo2c6zd2mxhP+WMaZwxwHR6NIRloYKRsRP+yv9mqtJZkKD2XunN8sjb
         /IQ0pgVnpgdRwikZdEHTVIBk7pXvtIKXvubT1UxxJWnxL3C+1vYP5o6H854S8JOSyqWw
         jJuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ma2HB9E5H3KHA4WWM5KO4LEHsZhrnd0lev/W5XpOJBI=;
        b=dh61gXBLYPJxoS7smEvOIvLpGei7PV7uc0HhcCDHKn0egcBygRDk2JmtM2Z/1UoVRd
         aUCadkH1ryEzxST6Q9KKVgsE6U98+FlEQxhSH3sjzs1C2XcwhxLVQ5HNBrQ1vFJmu+eU
         QZ/BeJPzxW7szAFIs5yyQTB4VIS9zd0jp7as5u6zM++uzRykl4zBcyoZklL0O7Ws+9bd
         pJ8xFF8rJg/K7Ec/trL4XrWvMTiXq4Q8DnSEzsXL0WpsRpUrixgg0KVRgA0LLqgSn2Z5
         XNu2H12oQlcJnArr5nll8LIEEk7Jy6B4gmI1KyECMZ8t64T4aQKlOsGr3fazvGcPwMD+
         3PwA==
X-Gm-Message-State: AOAM533fIatjLsL5L1FtdM4M5S5MEI69qLHA8bUNM11b8Et6Vqw6+Dgr
        8If6FF1POPCOyXwmaS4WAgE=
X-Google-Smtp-Source: ABdhPJx+rDKlvtD8GjAb5KlxMsjjGMJvdU+p1wNENYYD1nqVCOJ8h4m65/Cl8Z7OukL5+KDszgQc/Q==
X-Received: by 2002:a05:600c:1550:: with SMTP id f16mr4464261wmg.97.1614767180168;
        Wed, 03 Mar 2021 02:26:20 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:bb00:75b1:c098:325a:ae1? (p200300ea8f1fbb0075b1c098325a0ae1.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:75b1:c098:325a:ae1])
        by smtp.googlemail.com with ESMTPSA id i8sm20158999wrx.43.2021.03.03.02.26.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Mar 2021 02:26:19 -0800 (PST)
Subject: Re: next-20210302 - build issue with linux-firmware and rtl_nic/
 firmware.
To:     =?UTF-8?Q?Valdis_Kl=c4=93tnieks?= <valdis.kletnieks@vt.edu>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
References: <199898.1614751762@turing-police>
 <02b966f5-a056-b799-dd6d-c5dc762d42f3@gmail.com>
 <205633.1614757174@turing-police>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <c0a272c2-1e7d-022a-88b6-29fca298e7d7@gmail.com>
Date:   Wed, 3 Mar 2021 11:26:11 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <205633.1614757174@turing-police>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.03.2021 08:39, Valdis Klētnieks wrote:
> On Wed, 03 Mar 2021 07:51:06 +0100, Heiner Kallweit said:
>>> # Firmware loader
>>> CONFIG_EXTRA_FIRMWARE="rtl_nic/rtl8106e-1.fw"
>>> CONFIG_EXTRA_FIRMWARE_DIR="/lib/firmware"
>>>
>> This is wrong, simply remove it.
> 
>>> But then I take a closer look at  drivers/net/ethernet/realtek/r8169_main.c
>>> #define FIRMWARE_8168D_1	"rtl_nic/rtl8168d-1.fw"
>>> #define FIRMWARE_8168D_2	"rtl_nic/rtl8168d-2.fw"
>>> #define FIRMWARE_8168E_1	"rtl_nic/rtl8168e-1.fw"
> 
> Yes, but then how are *these* filenames supposed to work? Is a userspace helper
> supposed to be smart enough to append the .xz, and the EXTRA_FIRMWARE variant
> for embedding out-of-tree firmware has to point at an uncompressed version? 
> 
There is no such thing as compressed firmware files, see here:
https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/rtl_nic

Your issue may be distro-specific, so you should check in a support forum of
your respective distro.
