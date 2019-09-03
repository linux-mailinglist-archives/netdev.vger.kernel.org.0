Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2224EA6248
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 09:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727248AbfICHMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 03:12:52 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44025 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfICHMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 03:12:52 -0400
Received: by mail-wr1-f65.google.com with SMTP id y8so16157290wrn.10;
        Tue, 03 Sep 2019 00:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0nREtTN95potLu4W2e5nNuzYPnZZK1vRcOjmxb5qt8k=;
        b=GuKXlPx3GBaC6/0CpcczL7/+ySL6PYqohNeR9jse0yMlI+17sN+eI/Raj26KvtYxFc
         rTTNTzo0mJx6u+6Xh2/NWh7eNfU+5ihvheFRNn+LQaj29cILcWuDJg8TRqQea4FkB/ZL
         1u3pmOokfoytQN+uVg9Klcwbt8puWMNBcKcP0XOmX9p0ZvNtpXqu7DRXXMIelASqWbuc
         dAgkOG8lTSn2rALzfAm0stvbwmXUv+A52bvu4CDeyEuKMVuCpBGXiyZfXxHCMuImAcXe
         bR4Q7ABEi0PPS2wcSmOtfgXVOpgqO1vHfsch7jyfBPIgzIpn0gM8M7BXi053K5X3AS2b
         v8Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0nREtTN95potLu4W2e5nNuzYPnZZK1vRcOjmxb5qt8k=;
        b=Aze2Okk7llwzVVo6iHLlNnPD2rBS+dv8d3Wb4U8R+ArqDDXoNVCLzfSv+pYhxfMinU
         LmWfr2yvrhtwr6OCZ1RJExz2km+o2saNlJeY2RU3zNLmCCamH1nMhc0t7856OW5Ef7cu
         mPGvgwqi6Wxu5iAZjMT3hRM9+S1YHa0uaDAZ63NVJkdyuqejIp2ah+EQhas3SNa9vSG4
         WeanCHFxMVpYtnDDJPlBd32yNjT/zdrUfGjrvpS6aVQVVs/nG7aAnve5dbEsA+drXZZ9
         rfdGqU7R3Gm6oNItnMfp0e5R01xVbhQWJ1qcEOc9/CGOSRpEN5W7AaJfKYYi1DtDvFro
         vgFQ==
X-Gm-Message-State: APjAAAU5uwjWNM0glf7H/9Pov4q5B2eHTgEyU/fyca15auUANufLdBck
        Ijp5bER4rlhfIM9FtyimUcHVfJvs
X-Google-Smtp-Source: APXvYqzfWk6g6SoBPMwtQ2eo0rdkdMGUgpd52YcdCfxsIuGYU52KA26KDcqM3qZNXbPz7tOCgdyICg==
X-Received: by 2002:adf:e452:: with SMTP id t18mr40790664wrm.0.1567494770075;
        Tue, 03 Sep 2019 00:12:50 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f04:7c00:f018:f11c:b684:4652? (p200300EA8F047C00F018F11CB6844652.dip0.t-ipconnect.de. [2003:ea:8f04:7c00:f018:f11c:b684:4652])
        by smtp.googlemail.com with ESMTPSA id z189sm9155590wmc.25.2019.09.03.00.12.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Sep 2019 00:12:49 -0700 (PDT)
Subject: Re: [PATCH net-next] r8152: modify rtl8152_set_speed function
To:     Hayes Wang <hayeswang@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1394712342-15778-326-Taiwan-albertk@realtek.com>
 <280e6a3d-c6c3-ef32-a65d-19566190a1d3@gmail.com>
 <0835B3720019904CB8F7AA43166CEEB2F18DAB41@RTITMBSVM03.realtek.com.tw>
 <aa9513ff-3cef-4b9f-ecbd-1310660a911c@gmail.com>
 <0835B3720019904CB8F7AA43166CEEB2F18DACE1@RTITMBSVM03.realtek.com.tw>
 <56675c6b-c792-245e-54d0-eacd50e7a139@gmail.com>
 <0835B3720019904CB8F7AA43166CEEB2F18DAD2A@RTITMBSVM03.realtek.com.tw>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <32d490ae-70af-ba86-93de-be342a2a7e39@gmail.com>
Date:   Tue, 3 Sep 2019 09:12:43 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <0835B3720019904CB8F7AA43166CEEB2F18DAD2A@RTITMBSVM03.realtek.com.tw>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.09.2019 08:55, Hayes Wang wrote:
> Heiner Kallweit [mailto:hkallweit1@gmail.com]
>> Sent: Tuesday, September 03, 2019 2:45 PM
> [...]
>>> Besides, I have a question. I think I don't need rtl8152_set_speed()
>>> if I implement phylib. However, I need to record some information
>>> according to the settings of speed. For now, I do it in rtl8152_set_speed().
>>> Do you have any idea about how I should do it with phylib without
>>> rtl8152_set_speed()?
>>>
>> When saying "record some information", what kind of information?
> 
> Some of our chips support the feature of UPS. When satisfying certain
> condition, the hw would recover the settings of speed. Therefore, I have
> to record the settings of the speed, and set them to hw.
> 
Not knowing the UPS feature in detail:
In net-next I changed the software "PHY speed-down" implementation to
be more generic. It stores the old advertised settings in a new
phy_device member adv_old, and restores them in phy_speed_up().
Maybe what you need is similar.

>> The speed itself is stored in struct phy_device, if you need to adjust
>> certain chip settings depending on negotiated speed, then you can do
>> this in a callback (parameter handler of phy_connect_direct).
>> See e.g. r8169_phylink_handler()
> 
> Thanks. I would study it.
> 
> Best Regards,
> Hayes
> 
> 
Heiner
