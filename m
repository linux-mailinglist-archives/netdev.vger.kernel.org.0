Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96AEEA61B0
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 08:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfICGox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 02:44:53 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35615 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfICGow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 02:44:52 -0400
Received: by mail-wr1-f66.google.com with SMTP id g7so16139710wrx.2;
        Mon, 02 Sep 2019 23:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eLRHaMm5B6DSKtBXOKSlfBnVpYhlS9Wrwjo0dsWl554=;
        b=X1VieKiIW2+c25kqAeFrDvYt7EmjVEd8Tmz/+8Y5rn6/kk3AvXWpSrLq82nzgX3aSp
         Pxi9+vvsDdF/bX0jIy5Ms11O1blGFPRTxKY861UecdyxJpbcIui+xg8QMEtr4zd4SIsN
         39YRwUO9eFxBb4AFHlSth9agDY1QbMUbuW96obGsHwB1Ppt7j/mM8VJ0GB2gw1Z+BRD0
         o8OAHfsSQRxwv8gPtJCyYl4VO+3kyFbKSfzoWBHqHze2fhS8CbzB+t4plEsfe/VfKRXN
         kGbXtJKhCQZmHhaUNJqwip4Ch9Uk05YTJt/zhS675PrQbktWViFA6J2zJHeuBt4esFE4
         yYDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eLRHaMm5B6DSKtBXOKSlfBnVpYhlS9Wrwjo0dsWl554=;
        b=lW5IYCdVtMa1Xd5osHH3nhO1lkkJGb0NG26HP8jXn08GNi9z5yRlQtL1qbBpjQLOCr
         7/kwrlsKbi1H5BFvMdR9nvCxg88kJiQ3YZj6Z4Jru7I4sGS96ghWZ6E863FdahpH7NFR
         XiX2eVPnELfwepJyA6PZ7Xq5LHamiLvjVKI7uEbY+TrqVIniIOmgkc+xMWvC4UOCGXbE
         pMKtRHavU0X3gL7GbcI1Po2xvNomU5Z+PjccHa/odC3hguNsZngprez6J8KI8mQg3ix0
         DSH7J8ytGX3KCHkmF40gq22XfRTxReJn11wiNVaiwAMsAHUQyB9Jwmqvu6Ae6OSW0FaL
         MFlw==
X-Gm-Message-State: APjAAAXqNk3cpRndKFN4ngHzNJbG7FeD2raZu9COTlgkNsz4qbQSi9dy
        8pV/cpod9QNEWkcT4DW3/MIyQShs
X-Google-Smtp-Source: APXvYqxXLB7BoBubkP6IC8GWOdgEhRE+9kBdQ3Qqut5fAf+PeV/MDxcIdkWVxypqwI4PUQjIYcRw0A==
X-Received: by 2002:a5d:5612:: with SMTP id l18mr23176354wrv.177.1567493090192;
        Mon, 02 Sep 2019 23:44:50 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f04:7c00:f018:f11c:b684:4652? (p200300EA8F047C00F018F11CB6844652.dip0.t-ipconnect.de. [2003:ea:8f04:7c00:f018:f11c:b684:4652])
        by smtp.googlemail.com with ESMTPSA id g201sm19148197wmg.34.2019.09.02.23.44.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Sep 2019 23:44:49 -0700 (PDT)
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
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <56675c6b-c792-245e-54d0-eacd50e7a139@gmail.com>
Date:   Tue, 3 Sep 2019 08:44:44 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <0835B3720019904CB8F7AA43166CEEB2F18DACE1@RTITMBSVM03.realtek.com.tw>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.09.2019 08:36, Hayes Wang wrote:
> Heiner Kallweit [mailto:hkallweit1@gmail.com]
>> Sent: Tuesday, September 03, 2019 2:14 PM
> [...]
>>>> Seeing all this code it might be a good idea to switch this driver
>>>> to phylib, similar to what I did with r8169 some time ago.
>>>
>>> It is too complex to be completed for me at the moment.
>>> If this patch is unacceptable, I would submit other
>>> patches first. Thanks.
>>>
>> My remark isn't directly related to your patch and wasn't
>> meant as an immediate ToDo. It's just a hint, because I think
>> using phylib could help to significantly simplify the driver.
> 
> I would schedule this in my work. Maybe I finish submitting
> the other patches later.
> 
> Besides, I have a question. I think I don't need rtl8152_set_speed()
> if I implement phylib. However, I need to record some information
> according to the settings of speed. For now, I do it in rtl8152_set_speed().
> Do you have any idea about how I should do it with phylib without
> rtl8152_set_speed()?
> 
When saying "record some information", what kind of information?
The speed itself is stored in struct phy_device, if you need to adjust
certain chip settings depending on negotiated speed, then you can do
this in a callback (parameter handler of phy_connect_direct).
See e.g. r8169_phylink_handler()

> Best Regards,
> Hayes
> 
> 

Heiner
