Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2A440DCFA
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 16:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238590AbhIPOke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 10:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238479AbhIPOkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 10:40:31 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3584CC061574;
        Thu, 16 Sep 2021 07:39:11 -0700 (PDT)
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 0FFEC82F4D;
        Thu, 16 Sep 2021 16:39:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1631803148;
        bh=5DRa0+xWbxpPVlWb1mjMVVqtqnNIlVWE0nYmVxDfEvE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=i7pvwWj+UNf9wyLpj0X0jw8rjJbnCmfjsdb9N7xZyOajyZWcBGMsOn23RQAA8gA+4
         sv66yYdN4MdJm5shp/Hbcku+52MyWlwMHfAetVfsX1gJTOB3vSIXLTRbLyUdLpaEEy
         Ds3o21uXQkVfMMZ+lzfF+2xSFdi2TIfLmR3SOk0mdOfxkEv7g8/j3VmdPXCxHD+pJE
         1KC/wUAukyGnmpMb+J8w0qa5uk68EczxPt0BwuzaVrZVswhVgGh54KOZVD9KQPIsSi
         rOHZUgvvn7SlqzjK/dOlIcZi0qUPAa85g8uFiVrCS37X40VIZeECNmOZH7BlAuvk6E
         dQc8vZjExQ63w==
Subject: Re: [PATCH] rsi: Fix module dev_oper_mode parameter description
To:     Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        netdev@vger.kernel.org
Cc:     Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Angus Ainslie <angus@akkea.ca>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Karun Eagalapati <karun256@gmail.com>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Martin Kepplinger <martink@posteo.de>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>, stable@vger.kernel.org
References: <20210915080841.73938-1-marex@denx.de>
 <5957470.R6RXr1ZQNe@pliszka>
From:   Marek Vasut <marex@denx.de>
Message-ID: <a19c659a-45c5-5e3c-f681-caaa55d085b6@denx.de>
Date:   Thu, 16 Sep 2021 16:39:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <5957470.R6RXr1ZQNe@pliszka>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/16/21 9:03 AM, Sebastian Krzyszkowiak wrote:
> On środa, 15 września 2021 10:08:41 CEST Marek Vasut wrote:
>> +#define DEV_OPMODE_PARAM_DESC		\
>> +	__stringify(DEV_OPMODE_WIFI_ALONE)	"[Wi-Fi alone], "	\
>> +	__stringify(DEV_OPMODE_BT_ALONE)	"[BT classic alone], "	\
>> +	__stringify(DEV_OPMODE_BT_LE_ALONE)	"[BT LE], "		
> \
>> +	__stringify(DEV_OPMODE_BT_DUAL)		"[BT Dual], "		
> \
>> +	__stringify(DEV_OPMODE_STA_BT)		"[Wi-Fi STA + BT
> classic], " \
>> +	__stringify(DEV_OPMODE_STA_BT_LE)	"[Wi-Fi STA + BT LE], "	\
>> +	__stringify(DEV_OPMODE_STA_BT_DUAL)	"[Wi-Fi STA + BT
> classic + BT LE], " \
>> +	__stringify(DEV_OPMODE_AP_BT)		"[AP + BT classic], "	
> \
>> +	__stringify(DEV_OPMODE_AP_BT_DUAL)	"[AP + BT classic + BT LE]"
> 
> There's still some inconsistency in mode naming - how about:
> 
> - Wi-Fi STA

This mode is also AP capable

> - BT classic
> - BT LE
> - BT classic + BT LE
> - Wi-Fi STA + BT classic
> - Wi-Fi STA + BT LE
> - Wi-Fi STA + BT classic + BT LE
> - Wi-Fi AP + BT classic
> - Wi-Fi AP + BT classic + BT LE
> 
> "alone" could be added to the first three modes (you missed it in BT LE).

I can add the alone consistently, yes -- that's the point of the first 
three modes, that the "other" radio is disabled by the firmware.
