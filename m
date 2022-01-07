Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35006487863
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 14:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347618AbiAGNnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 08:43:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232401AbiAGNnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 08:43:11 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16808C061574;
        Fri,  7 Jan 2022 05:43:11 -0800 (PST)
Received: from [IPV6:2003:e9:d724:9af0:641c:922:9a06:5c2c] (p200300e9d7249af0641c09229a065c2c.dip0.t-ipconnect.de [IPv6:2003:e9:d724:9af0:641c:922:9a06:5c2c])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 1C528C06A5;
        Fri,  7 Jan 2022 14:43:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1641562988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xgvv/BN2hqhP+sJ44u1JOv48sEmMdyWk01XkHLTl728=;
        b=awL8hM6osUIJXbbgqRa3hltRETS48qw2F/JS0ENCfTugvB6gUqHhdQjq2XWmqX/VD8lQ2h
        dKo2FPpDQzapEpnscFAkoW6pnA+krRKArceVarJ3/ZF2uVrr3az8tBueRlPWFfJmAmLgDE
        L8YihBBGVJn6uAhgIliU1q60sQOiuTef7pFqPTgU3+0viLL/YvLziuulHthrgwR/q8rkwG
        Ux2sNUtW5PsVnWD95reru+VTUqPnsSPQU8r7kB6czeGOu/fY4bsIwDRMUfj+ROGq0KtrzV
        +KwxOBaOnGYdUuT5hpCuEpG4UieUeKBj1jxBQXZyUENAet5SkhgrHFrIDUEBKA==
Message-ID: <ce5c92ac-a439-661f-6005-c4dd31c547be@datenfreihafen.org>
Date:   Fri, 7 Jan 2022 14:43:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH -next] ieee802154: atusb: move to new USB API
Content-Language: en-US
To:     Pavel Skripkin <paskripkin@gmail.com>, alex.aring@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220105144947.12540-1-paskripkin@gmail.com>
 <4186d48a-ea7e-39c1-d1fa-1db3f6627a3a@datenfreihafen.org>
 <8da136c2-a4f8-bc3b-7c61-de29217153fa@gmail.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <8da136c2-a4f8-bc3b-7c61-de29217153fa@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello.

On 05.01.22 21:58, Pavel Skripkin wrote:
> Hi Stefan,
> 
> On 1/5/22 23:27, Stefan Schmidt wrote:
>>> +    ret = usb_control_msg_recv(usb_dev, 0, ATUSB_REG_READ, 
>>> ATUSB_REQ_FROM_DEV,
>>> +                   0, RG_PART_NUM, &atusb, 1, 1000, GFP_KERNEL);
>>
>> This needs to be written to &part_num and not &atusb.
>>
> 
> Oh, stupid copy-paste error :( Thanks for catching this!
> 
>> Pretty nice for a first blind try without hardware. Thanks.
>>
>> Will let you know if I find anything else from testing.
> 
> Ok, will wait for test results. Thank you for your time ;)

Testing went fine and showed no additional problems. I spotted one more 
thing in review though which I would like to see changed. See my reply 
to the patch itself.

regards
Stefan Schmidt
