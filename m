Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C79646B417
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 08:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbhLGHlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 02:41:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbhLGHlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 02:41:45 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A915C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 23:38:15 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id c4so27496639wrd.9
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 23:38:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=u48KmOPEOypjU3aSC0RQEz25OhcIRe+ZcfjhtrlUnYI=;
        b=B1ZX0vnibjEiB6NOTBELUi1Kz0KopGM8EU9ZgL+dGatbjufw7JJqDFATHwZd1OyasY
         mSvJ0g7X39OANDChqZPrPt9bXmSRNlTlUOdKRyz1hrZNhAVxy3ThQgKQrP8FotbHfPuG
         SP3y8/1SBs2U5wk0vHZZQyXtefXI3SQBH28s5K/5Ic1EPr+eCS/9kPYCrGh32IhkcIyM
         eWpd6OgvHpp82Y9cNuz/9fHWZNuYHsSf1KmqOsgq4ZXGmUOJW/jbzLJOXlcyzZfkuvEH
         xbvxyhCB63ToztMg5rRDGcQ8QZgfq0DuvcR3tLtp40mvGs/U7fEAmohsv7GaCEy4H8f9
         rheQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=u48KmOPEOypjU3aSC0RQEz25OhcIRe+ZcfjhtrlUnYI=;
        b=M6Zo62dSjzPtH1+RwbQcaEGx1GB+0Be0YRHMMG2MEH05RNGO5pa4g3EWbWVMskUl/M
         XK7q+3q7QO2ulJfNhm6uaxDiDFvWOgIfVIxmkCdUyXly0wyurV1no1u0jJ+99y3s0axP
         htJGe2M1llOaOQA6zLMDmL7Q3hyedjVadzTwqHW5F1vM77BJYE6dD5BlirRrfYRmGi+v
         rxr7vIDyA9PUscBwHB7fNFj4aonpjTh2tT7AuK4cGHK9EE+vJBFSUkCZDkPb8gybBgaz
         U0NmXfR5jU1uIzWALIeVvf9IrTwpGwAyw1EKgbJOajh1DK31TsEg13Ar5vznx0/BbcAG
         C/3w==
X-Gm-Message-State: AOAM5302F+AQWnjgE4/HWYYoaFcJrCtsFMcIQi3/whVgrqL1rX5pfgsw
        Tfu/0h89d5kepy9BPMwo0qF+IDO0DWM=
X-Google-Smtp-Source: ABdhPJyHux5ROVIS4uMzBdBJJ14TumyFQ3XRcBUjYHQ+QZb9Fhrm4GUtFy+H89I2MzzryFosdfbcdg==
X-Received: by 2002:adf:d852:: with SMTP id k18mr49839446wrl.391.1638862693972;
        Mon, 06 Dec 2021 23:38:13 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:84e7:aa31:10c1:384a? (p200300ea8f1a0f0084e7aa3110c1384a.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:84e7:aa31:10c1:384a])
        by smtp.googlemail.com with ESMTPSA id d188sm2087735wmd.3.2021.12.06.23.38.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Dec 2021 23:38:13 -0800 (PST)
Message-ID: <d93143c8-5fda-70e1-8dd9-8350c6820e56@gmail.com>
Date:   Tue, 7 Dec 2021 08:38:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Content-Language: en-US
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
References: <20211129101315.16372-381-nic_swsd@realtek.com>
 <20211129101315.16372-385-nic_swsd@realtek.com>
 <b36df085-8f4e-790b-0b9e-1096047680f3@gmail.com>
 <2f5c720b6f3b46648678bee05eb23787@realtek.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [RFC PATCH 4/4] r8169: add sysfs for dash
In-Reply-To: <2f5c720b6f3b46648678bee05eb23787@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.12.2021 07:53, Hayes Wang wrote:
> Heiner Kallweit <hkallweit1@gmail.com>
>> Sent: Friday, December 3, 2021 11:15 PM
> [...]
>> With regard to sysfs usage:
>> - attributes should be documented under /Documentation/ABI/testing
>> - attributes should be defined statically (driver.dev_groups instead
>>   of sysfs_create_group)
>> - for printing info there's sysfs_emit()
>> - is really RTNL needed? Or would a lighter mutex do?
> 
> In addition to protect the critical section, RTNL is used to avoid
> calling close() before CMAC is finished. The transfer of CMAC
> may contain several steps. And close() would disable CMAC.
> I don't wish the CMAC stays at strange state. It may influence
> the firmware or hardware. Besides, I find the original driver only
> use RTNL to protect critical section. Is there a better way for it?
> 

The main issue I see is that you call rtl_dash_from_fw() under RTNL,
and this function may sleep up to 5s. Holding a system-wide mutex
for that long isn't too nice.

In rtl_dash_info() you just print FW version and build number.
Wouldn't it be sufficient to print this info once to syslog
instead of exporting it via sysfs?

> Best Regards,
> Hayes
> 
