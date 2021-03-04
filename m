Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D0732DB90
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 22:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236074AbhCDVIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 16:08:42 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:51564 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234921AbhCDVId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 16:08:33 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4Ds3NF6Zhxz1qs10;
        Thu,  4 Mar 2021 22:07:24 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4Ds3ND3k9kz1qqkJ;
        Thu,  4 Mar 2021 22:07:24 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id NF9l6MSuqCwo; Thu,  4 Mar 2021 22:07:22 +0100 (CET)
X-Auth-Info: /bjdHCSRRBO1hy/kHQ3KWZ31WRCi0CyJyL23VTq/CMI=
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Thu,  4 Mar 2021 22:07:22 +0100 (CET)
Subject: Re: [PATCH AUTOSEL 5.10 050/217] rsi: Fix TX EAPOL packet handling
 against iwlwifi AP
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Angus Ainslie <angus@akkea.ca>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>,
        Martin Kepplinger <martink@posteo.de>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20201223021626.2790791-1-sashal@kernel.org>
 <20201223021626.2790791-50-sashal@kernel.org>
 <68699f8a-2fcd-3b3d-f809-afa54790e9f9@denx.de> <YEFHULdbXVVxORn9@sashalap>
From:   Marek Vasut <marex@denx.de>
Message-ID: <d4b4f1d1-8041-3563-708a-850fe95549b8@denx.de>
Date:   Thu, 4 Mar 2021 22:07:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <YEFHULdbXVVxORn9@sashalap>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/4/21 9:47 PM, Sasha Levin wrote:
> On Tue, Mar 02, 2021 at 08:25:49PM +0100, Marek Vasut wrote:
>> On 12/23/20 3:13 AM, Sasha Levin wrote:
>>
>> Hello Sasha,
>>
>>> From: Marek Vasut <marex@denx.de>
>>>
>>> [ Upstream commit 65277100caa2f2c62b6f3c4648b90d6f0435f3bc ]
>>>
>>> In case RSI9116 SDIO WiFi operates in STA mode against Intel 9260 in 
>>> AP mode,
>>> the association fails. The former is using wpa_supplicant during 
>>> association,
>>> the later is set up using hostapd:
>>
>> [...]
>>
>> Was this patch possibly missed from 5.10.y ?
> 
> I'm not sure what happened there, but I can queue it up.

Thank you

>> Also, while at it, I think it might make sense to pick the following 
>> two patches as well, they dramatically reduce interrupt rate of the 
>> RSI WiFi device, so it stops overloading lower-end devices:
>> 287431463e786 ("rsi: Move card interrupt handling to RX thread")
> 
> And this one too.

Thanks

>> abd131a19f6b8 ("rsi: Clean up loop in the interrupt handler")
> 
> But not this one, it looks like just a cleanup. Why is it needed?

Now I got confused, yes, please skip abd131a19f6b8, thanks for spotting 
it. (I still have one more patch for the RSI wifi which I need to send 
out, but that's for later)
