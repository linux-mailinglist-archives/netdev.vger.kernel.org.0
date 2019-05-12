Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 626CA1AB06
	for <lists+netdev@lfdr.de>; Sun, 12 May 2019 09:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbfELHed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 May 2019 03:34:33 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42422 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbfELHed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 May 2019 03:34:33 -0400
Received: by mail-wr1-f67.google.com with SMTP id l2so11811017wrb.9
        for <netdev@vger.kernel.org>; Sun, 12 May 2019 00:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=d7sSxRVqA8rpoJpHM55bvCBo8kEXHBET8gLdu4SoA2o=;
        b=QgJMbrd2QkXXFi6N3hEyZyuXUHHYMe41Y49a15hCZSV94FIqr9/G+VOpNB9f3Q6cVZ
         MdpEqNR2KiE2iMRCykBgTZv7ZOZJ5wNzEeg9OrkrPF9d/FLEKzOqK5U7CRh6gYLsuoZh
         3THz2AC3danPZNVWlJ8POM+h+PoUPpt1Xs2TC5abRycG9OdcP0UWrbYOXh65NlbgkZiP
         n0dyM94HDz573/Y+iUQRRoil1pSqGJn1U1vVd9dPmlzK9+fZUyYyGVFzu/Kf12am5lfx
         PQv3o/5KlitAzg1IVeAmsQxpd074wWcSHcO4iHIWc0q4mvc4KugBWH7sbrKBI4zt72YV
         JDkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d7sSxRVqA8rpoJpHM55bvCBo8kEXHBET8gLdu4SoA2o=;
        b=uPoTMXGHtgQSFwXbSMdIIhbl7an51CVWkn3Hd0WuLxkM6dn2obuOO8ZeqRo5NfhieI
         zT0T+d8EsMv0fko/coEBCpVDtgptoT7P5LX1bDUMsiwfEPxJaz5ngBednLkPZRNevWWU
         gPn1LBZFbrS0v8zn90EqwN9av9p8R3mp4w0y43WzKoA2zSH8mEJrejy7fbZSr4GYT8YA
         jhlCDP5E6O1A7S8nqSv+76fWrID1lZYnLRUcO5nLJP8oPxnvmMWzckOSfrxaViMqu+Cq
         KfpFduqDFd0Io+Utc47XsNfLn5J7fUCfjrVZIkMF0KeWh+ua27zD+idgQT5nplfcfZw8
         WNCg==
X-Gm-Message-State: APjAAAXQ/mk7v1OwAP/r7f3drmX6FGcayX/l25BpTi3b0/VEtcd6yoGN
        huR1qLellCrltnvMCxZEDwk=
X-Google-Smtp-Source: APXvYqx7W6og2OfRFEDNmOqXuHdkhnH6O12kcwF1h84yKRQb0j70jL8MyXwHOEgnpYH/QRHPgwdWYw==
X-Received: by 2002:a05:6000:10c4:: with SMTP id b4mr701248wrx.145.1557646471390;
        Sun, 12 May 2019 00:34:31 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:9c27:51d8:9ed5:dad3? (p200300EA8BD457009C2751D89ED5DAD3.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:9c27:51d8:9ed5:dad3])
        by smtp.googlemail.com with ESMTPSA id r3sm7124972wrn.5.2019.05.12.00.34.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 12 May 2019 00:34:30 -0700 (PDT)
Subject: Re: [Regression] "net: phy: realtek: Add rtl8211e rx/tx delays
 config" breaks rk3328-roc-cc networking
To:     Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     Serge Semin <fancer.lancer@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Serge Semin <Sergey.Semin@t-platforms.ru>,
        netdev@vger.kernel.org,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>
References: <066a0d38-2c64-7a1e-d176-04341f0cb6d7@gmail.com>
 <20190512023754.GK4889@lunn.ch>
 <ae62419b-53f1-395d-eb0e-66d138d294a8@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <4c6ef3f1-a2c7-f2da-3f2a-cd28624007f8@gmail.com>
Date:   Sun, 12 May 2019 09:34:24 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <ae62419b-53f1-395d-eb0e-66d138d294a8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.05.2019 04:50, Peter Geis wrote:
> On 5/11/2019 10:37 PM, Andrew Lunn wrote:
>> On Sat, May 11, 2019 at 07:17:08PM -0400, Peter Geis wrote:
>>> Good Evening,
>>>
>>> Commit f81dadbcf7fd067baf184b63c179fc392bdb226e "net: phy: realtek: Add
>>> rtl8211e rx/tx delays config" breaks networking completely on the
>>> rk3328-roc-cc.
>>> Reverting the offending commit solves the problem.
>>
>> Hi Peter
>>
>> The fix should be in net, and will soon make its way upwards.
>>
>>      Andrew
>>
> 
> 
> Good Evening,
> 
> Thanks, is there a link to the patch so I may test it?
> 
https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/?id=daf3ddbe11a2ff74c95bc814df8e5fe3201b4cb5

> Peter
> 
Heiner
