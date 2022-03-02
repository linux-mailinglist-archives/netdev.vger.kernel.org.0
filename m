Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 618B84CAE84
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 20:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238002AbiCBTTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 14:19:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234453AbiCBTTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 14:19:44 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8D13EAA8
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 11:18:59 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id r10so4378840wrp.3
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 11:18:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=RMMqf9LQJWaptz0K/Gmd7Tj/qQkC6OYMvX3Op84BQbc=;
        b=rHLZI791nYv+WOrg2nIm6efxe2ocFjX6a+gFNehTNnv22fed66UWWaOE9PSFzoPeKf
         6wy1uGWP2CHDmrqJqWrd0Ugoeg74gI/KQacPvF8Atlg+Q4ppCdENUhyJTTtYBAqBhckt
         GGQ4o9pRYq76bUcaa5jrofxLvraa0I1hgdFCB43nhGELkfFzPPAZW+aT8YPJTX2/jJ6S
         EH8FKoQxSg1prOA/ChnHxK8OUiLpy6k+vjWpggLPpztMOIjdtZiUX0e1jx60xTZiiqX9
         rOlVVOO25GgZ4yIY6Mojk7/PBX9EJyfcaSA6UNJThRhYStSek//CBTu0VN4EVN26YNfd
         ws7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RMMqf9LQJWaptz0K/Gmd7Tj/qQkC6OYMvX3Op84BQbc=;
        b=hWWcabay9gZ+uGXN4a9tY1QejdmmrbVHBmdDxf1qY8V/mWVC/Jc4xUW2CWzCtiRVCf
         Lrso1FtBm5tnP3fQjxZg4aHmufMwKrWWOD8NktxuCCgHoG2GhRNRlvGRDcd84PgSe6Vs
         aBQZMNvSgyqH34vfk4bKt5nwl/QrhsqKqEXMwP7ykvBK1Y+MzL7GQcm+VHROFwVooOmg
         mZ7iMRFAEUgEkLhd+NFE+wekwCe6cz5Gt0gW+lXyKUq1tbpUBuyyKHXdzQvh4uS8OQj+
         2z6qeZDhrtq7FGhm/+kWWfV6HC9LPfHVbdzE8IfGkNMvn12P27aJk8cqwzh8Hk1bh0+b
         LzCQ==
X-Gm-Message-State: AOAM532zIUwQfNUEy6UEAzy7XthrA8lsP5+5vDAFNamRqs3FOhI34PUe
        16+jZObeJNBt37WWKb7oVS2SNQ==
X-Google-Smtp-Source: ABdhPJzfX7YF1G2ueHRNDs/b7uHYGo2ZxFSRnq/jsKtwtUWnFB4EY304tSfe3rIZCNbw9o5t2k3abg==
X-Received: by 2002:a05:6000:1ace:b0:1e8:cbe4:9920 with SMTP id i14-20020a0560001ace00b001e8cbe49920mr24599046wry.121.1646248738466;
        Wed, 02 Mar 2022 11:18:58 -0800 (PST)
Received: from [192.168.0.30] (cpc78119-cwma10-2-0-cust590.7-3.cable.virginm.net. [81.96.50.79])
        by smtp.gmail.com with ESMTPSA id h188-20020a1c21c5000000b00385699a8993sm2299258wmh.11.2022.03.02.11.18.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 11:18:58 -0800 (PST)
Message-ID: <54a9ec41-300d-a0c7-eee1-9445ea200a5e@linaro.org>
Date:   Wed, 2 Mar 2022 19:18:57 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] bluetooth: hci_event: don't print an error on vendor
 events
Content-Language: en-US
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        BlueZ <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
References: <20220302182352.441352-1-caleb.connolly@linaro.org>
 <0C35F358-3E66-457E-9080-DAE4EB10BF16@holtmann.org>
From:   Caleb Connolly <caleb.connolly@linaro.org>
In-Reply-To: <0C35F358-3E66-457E-9080-DAE4EB10BF16@holtmann.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel,

On 02/03/2022 19:16, Marcel Holtmann wrote:
> Hi Caleb,
> 
>> Since commit 3e54c5890c87 ("Bluetooth: hci_event: Use of a function table to handle HCI events"),
>> some devices see errors being printed for vendor events, e.g.
>>
>> [   75.806141] Bluetooth: hci0: setting up wcn399x
>> [   75.948311] Bluetooth: hci0: unexpected event 0xff length: 14 > 0
>> [   75.955552] Bluetooth: hci0: QCA Product ID   :0x0000000a
>> [   75.961369] Bluetooth: hci0: QCA SOC Version  :0x40010214
>> [   75.967417] Bluetooth: hci0: QCA ROM Version  :0x00000201
>> [   75.973363] Bluetooth: hci0: QCA Patch Version:0x00000001
>> [   76.000289] Bluetooth: hci0: QCA controller version 0x02140201
>> [   76.006727] Bluetooth: hci0: QCA Downloading qca/crbtfw21.tlv
>> [   76.986850] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>> [   77.013574] Bluetooth: hci0: QCA Downloading qca/oneplus6/crnv21.bin
>> [   77.024302] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>> [   77.032681] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>> [   77.040674] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>> [   77.049251] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>> [   77.057997] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>> [   77.066320] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>> [   77.075065] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>> [   77.083073] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>> [   77.091250] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>> [   77.099417] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>> [   77.110166] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>> [   77.118672] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>> [   77.127449] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>> [   77.137190] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>> [   77.146192] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>> [   77.154242] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>> [   77.163183] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>> [   77.171202] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>> [   77.179364] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>> [   77.187259] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>> [   77.198451] Bluetooth: hci0: QCA setup on UART is completed
>>
>> Use the quick-return path in hci_event_func() to avoid printing this
>> message for vendor events, this reverts to the previous behaviour which
>> didn't print an error for vendor events.
>>
>> Fixes: 3e54c5890c87 ("Bluetooth: hci_event: Use of a function table to handle HCI events")
>> Signed-off-by: Caleb Connolly <caleb.connolly@linaro.org>
>> ---
>> net/bluetooth/hci_event.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> patch has been applied to bluetooth-stable tree.
I spotted an issue with this patch - the vendor events are actually processed, it's the warning which is printed and not 
the error, I sent a v2 which properly disables the printing - you probably want that one instead, apologies for the 
noise/inconvenience.
> 
> Regards
> 
> Marcel
> 

-- 
Kind Regards,
Caleb (they/them)
