Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF29D197EA0
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 16:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbgC3OjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 10:39:16 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37551 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727469AbgC3OjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 10:39:15 -0400
Received: by mail-wr1-f68.google.com with SMTP id w10so22010913wrm.4
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 07:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9cg405MNSrpJNCO5I+fdNIK6fKBJ4DD0d4o72zOc0ho=;
        b=loSbGk7/vOeGOy9/LUk/9IDljQnRuV9E+eSU8q/1yRSqCSFZm+Orh7b2t9ehm1AzQi
         yLua2fJwUYdMobztlXKTdVTBwA6m8TgmgfLspPbOSVe3yGLjMNJRdMzpNVbW0LEatgxd
         yN7JP3w4yuhFuuCCIsmQcjhR59FALYaXxAtUPeBbKqvxbXW/KLdYFmGPw8gR6Du6/cRJ
         jmDcWJRvAD02LbR+N2J1bhCujNq63O2ehSaOJqGN6WwzkWCCj6Sbp7Kh6whbxZ+0JbPh
         U4PbPgem75rW3McL+IRadtmqWsZF1N1ttUzKTxD+mtSKbRrQrG2E1fkIffgXZ00JUOIB
         a1gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9cg405MNSrpJNCO5I+fdNIK6fKBJ4DD0d4o72zOc0ho=;
        b=quVvnZG02dfxUqqgW1oUMsXd3AhPCYoVetPQOJHKCYBqLBuhnElVyotJ9iNQWioVVg
         Kn6FO/LXOfRfNJ7TmDfWSUZKa60iwYkzmUSf5jN0xl3nZe2BnHIIIEEu7AQP21WrXxnG
         nhxzaFkk4icQZ6IM+t2t0P9+4xvgj5pzyOmgms9LcBbxj4MLPAE8b2DNGdj5OC93BkJY
         DqoXFeqWuol/6THHxkv3YylqjV5/vxOJ/NzivycLrZ7F6jhRatKmdWteujDCfr0i4UZL
         x3cFO/O3j6QnikdDSEefs3p2fSais0E7Q/sY9n5L8NPgIlw8UfRjLF7Hji/dY/byG8cr
         UI7g==
X-Gm-Message-State: ANhLgQ1DQSjhoBaOEIWOk/M8Wi8fGYLpM8YhWdJb3VR0B6bldmI9cDER
        RSHsyJgliUMRCwQUDwgrqSpTUHHT
X-Google-Smtp-Source: ADFU+vv9KPk2CKvP/AzQz/bZpdOxzXFemTFho+wE5C5wV1i8/fWv7zEIklKNdPTMljvlqHMHeETJFA==
X-Received: by 2002:a05:6000:a:: with SMTP id h10mr16141303wrx.226.1585579153630;
        Mon, 30 Mar 2020 07:39:13 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:c854:d136:fc5b:3950? (p200300EA8F296000C854D136FC5B3950.dip0.t-ipconnect.de. [2003:ea:8f29:6000:c854:d136:fc5b:3950])
        by smtp.googlemail.com with ESMTPSA id l10sm22004898wrq.95.2020.03.30.07.39.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2020 07:39:13 -0700 (PDT)
Subject: Re: issue with 85a19b0e31e2 on 4.19 -> revert
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     David Miller <davem@davemloft.net>, nic_swsd@realtek.com,
        cwhuang@android-x86.org, netdev@vger.kernel.org
References: <40373530-6d40-4358-df58-13622a4512c2@gmail.com>
 <20200327.155753.1558332088898122758.davem@davemloft.net>
 <d2a7f1f1-cf74-ab63-3361-6adc0576aa89@gmail.com>
 <20200327.162400.1906897622883505835.davem@davemloft.net>
 <05d53fd2-f210-1963-96d1-2dc3d0a3a8c7@gmail.com>
 <20200330143038.GA449036@kroah.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <c8963e4a-2cda-e9f0-eb4d-f6919c58391e@gmail.com>
Date:   Mon, 30 Mar 2020 16:39:08 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200330143038.GA449036@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.03.2020 16:30, Greg Kroah-Hartman wrote:
> On Sat, Mar 28, 2020 at 10:52:19AM +0100, Heiner Kallweit wrote:
>> On 28.03.2020 00:24, David Miller wrote:
>>> From: Heiner Kallweit <hkallweit1@gmail.com>
>>> Date: Sat, 28 Mar 2020 00:10:57 +0100
>>>
>>>> Somehow that change made it to -stable. See e.g. commit
>>>> 85a19b0e31e256e77fd4124804b9cec10619de5e for 4.19.
>>>
>>> This is a serious issue in that it seems that the people maintaining
>>> the older stable release integrate arbitrary patches even if they
>>> haven't been sent to v5.4 and v5.5
>>>
>>> And I don't handle -stable backport submissions that far back anyways.
>>>
>>> Therefore, I'm not going to participate in that ongoing problem, so
>>> feel free to contact the folks who integrated those changes into
>>> -stable and ask them to revert.
>>>
>>> Thanks.
>>>
>> Greg,
>>
>> commit 85a19b0e31e2 ("r8169: check that Realtek PHY driver module is loaded")
>> made it accidentally to 4.19 and causes an issue with Android/x86.
>> Could you please revert it?
> 
> Now reverted.  Should I also drop this from 5.4.y and 5.5.y?
> 
Thanks! On 5.4 and 5.5 it's not needed to revert. The following fix from 5.6
should make it to 5.4 and 5.5 soon.

2e8c339b4946 ("r8169: fix PHY driver check on platforms w/o module softdeps")

> thanks,
> 
> greg k-h
> 
Heiner
