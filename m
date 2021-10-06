Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433014235A8
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 04:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237167AbhJFCFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 22:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233994AbhJFCFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 22:05:06 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42FFC061749;
        Tue,  5 Oct 2021 19:03:14 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id p4so972639qki.3;
        Tue, 05 Oct 2021 19:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=+imzhIwYLWw+0XZp01QjLQU5qCZcEX7p0+XG2/HynCw=;
        b=EigJj2F1ORQcL2AewRAcVvv7ciAp5p0B6pWdsp4pHWbSzaYl69yRshEEYwmMOixa3j
         p9XoyaW23vqy3e9AyoFHMA5XDf9nd+Vdow3tq/QuF5ErHNF5jxVjqD26AvHfVfOjnbc1
         oZICRLLM1/uheg7uzbrgPgVDj1hFEsinuDeFgCoIl2U8lN2mtekYnQYV7rMafCOHFDxP
         2zeyr48ag6wQ5ewZqKb0IKAJyiudQMfnFlK1Gwj8QDBZARGDmfl+sl90SzY/3Dvlc3Vt
         iPejkQcAs8344MRXgZwTeqmOKDhkk3JYQTU1Dz7mfeRY31yo+os7LAJPPBe8Hb7R1EMi
         ICfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+imzhIwYLWw+0XZp01QjLQU5qCZcEX7p0+XG2/HynCw=;
        b=Ztnp7XDVRfTPUgsWjq5O7etYfRiwe0myupjQ0JkOiwBu9hn+0T2lKb+JicAZCL9hvZ
         sYu+lpVZtc//Y9eyWvJjskr9qk4qhtDaV1Uia/9cP70qRNgJNpcAjjlvw65wKDRZoQOr
         qVo/b9iQfgidPaknzzZB3Q1P7o0f3OYRvzhiHIgVzUnrxOqWcVlCEBNxaICc+iwrQxz6
         lDWXpuO5SAckS/OAp3rJlas4RhXz5GE/CylV/u0oQV6aFm3/yPZehQYks/ZjoFos8m/l
         7RH8ihK9IcfWFL3QYkKK9eef7bjwLjTeDdLANyEKVnJIcEhuaWXjW1owow9T+eg2WCNZ
         LlFw==
X-Gm-Message-State: AOAM532u9TTyY2/pWJvqzpYHIBDLFr8g45RLASgX9YEn30FEefoLCM1M
        9riHi33jl8dOQjqNXPstd7M=
X-Google-Smtp-Source: ABdhPJyuAzoARjaCc6ZrOCBIhFu39S2YWmuwM/wXBBoIcdN664yQX3uAVkxWIcFiAgb2IjZHoRReOw==
X-Received: by 2002:a37:a691:: with SMTP id p139mr18083435qke.365.1633485793054;
        Tue, 05 Oct 2021 19:03:13 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:c86a:e663:3309:49d7? ([2600:1700:dfe0:49f0:c86a:e663:3309:49d7])
        by smtp.gmail.com with ESMTPSA id c17sm11859127qtn.65.2021.10.05.19.03.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 19:03:12 -0700 (PDT)
Message-ID: <aeea5997-4e98-2ebe-9675-7ab883f4b422@gmail.com>
Date:   Tue, 5 Oct 2021 19:03:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [PATCH V2 net-next 1/2] net: bgmac: improve handling PHY
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20211002175812.14384-1-zajec5@gmail.com>
 <20211005182138.01b1bf98@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211005182138.01b1bf98@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/5/2021 6:21 PM, Jakub Kicinski wrote:
> On Sat,  2 Oct 2021 19:58:11 +0200 Rafał Miłecki wrote:
>> From: Rafał Miłecki <rafal@milecki.pl>
>>
>> 1. Use info from DT if available
>>
>> It allows describing for example a fixed link. It's more accurate than
>> just guessing there may be one (depending on a chipset).
>>
>> 2. Verify PHY ID before trying to connect PHY
>>
>> PHY addr 0x1e (30) is special in Broadcom routers and means a switch
>> connected as MDIO devices instead of a real PHY. Don't try connecting to
>> it.
>>
>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>> ---
>> V2: Promote it out of RFC and send together with MDIO patch per
>>      Florian's request.
> 
> Florian, ack?
> 

Roger roger, thanks for the ping.
-- 
Florian
