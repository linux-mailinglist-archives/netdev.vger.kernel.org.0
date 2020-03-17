Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43DE3188E20
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 20:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgCQTke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 15:40:34 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43470 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbgCQTke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 15:40:34 -0400
Received: by mail-wr1-f67.google.com with SMTP id b2so21044427wrj.10;
        Tue, 17 Mar 2020 12:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D/wp0Gm2mcc4rtHMD8u+N/+L8w8kJ6W08T5eblVfqN4=;
        b=vOEHN32J+wbhh7cEtbPHhRbQAXy0rRIhL4LzvUk8Dic2S3cAOqmz3Gzk3FKPhb2Heo
         LJjW3KY+Arjh6Ceyc2x3hjKhTRKnCB/sW3504NVASVVdmoHF3H4t8SucpzGwd4Lb/9nY
         jpaI7050NV8PCjCIuaB906gXs/D/A7FpjFva4x4HMUB5aiBZzzND46Wwyv0Zi+3LSFWh
         cXXWIuq/qHrR5Hapo2fz7bPmsLvOh3AoAAQe/sgjEv7FqwMq27EunoBcrKk8j/aJyaz8
         BV7JM5M48h0OK/8i6A1CBHJRYOwn4vL+WLMuccE3fyNafoI5WPOaS+fkxsSuSEXyuGR0
         9mtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D/wp0Gm2mcc4rtHMD8u+N/+L8w8kJ6W08T5eblVfqN4=;
        b=egN1Izs+FM1GiULBR89O2whIn5JXlT5jtWL8HT9pCKwiFtvmbFNHQCzyeJga2wnz0J
         JTsRHp6t/IYcG/KXrEwyMg8yJGcAWPjjrATNaUZ74M0SzRghEcMpzD0+tgPE/tPyptzN
         /dKv0fYXqbpEtYMTjWf4UgmWstOyj9lluoXOXpJKaHED83ofCd5/8SuFegjA+PInlc3c
         9GS3kWkg1vbsVC1n03UxMilGBn1M0wwe45HHtofcgkbESLwU5/nexTgFBUgcyQ+hMIQv
         TJftyPpqriGamcsiBrnO3Qv0HUFrvtfb5BCN1y201U9tQw1EFWwT38wb18n8v6PBzD9p
         zyOw==
X-Gm-Message-State: ANhLgQ1T040PUI8mvag6iHf2l9jo23lgROCBxSdbP2LFCK63okN6XH0S
        OZ/nZ38Z8E+7ODAkAEgjgTYRicJI
X-Google-Smtp-Source: ADFU+vthhBbNJO+yiWuwtAHW/axQSOlee3wEVkhsBobDeC76r87CTk4FJv+R6Wocf5FNVNuivbbU9Q==
X-Received: by 2002:a5d:6908:: with SMTP id t8mr687283wru.92.1584474031610;
        Tue, 17 Mar 2020 12:40:31 -0700 (PDT)
Received: from [10.230.31.111] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m2sm541200wml.24.2020.03.17.12.40.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Mar 2020 12:40:30 -0700 (PDT)
Subject: Re: [PATCH net 1/2] Revert "net: bcmgenet: use RGMII loopback for MAC
 reset"
To:     Florian Fainelli <florian.fainelli@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1584395096-41674-1-git-send-email-opendmb@gmail.com>
 <1584395096-41674-2-git-send-email-opendmb@gmail.com>
 <de2ef417-ddf0-516f-4b11-ce834764497c@broadcom.com>
From:   Doug Berger <opendmb@gmail.com>
Message-ID: <4f4a7695-0c6c-c5e8-84b2-602d0ee4fd29@gmail.com>
Date:   Tue, 17 Mar 2020 12:43:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <de2ef417-ddf0-516f-4b11-ce834764497c@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/16/2020 7:21 PM, Florian Fainelli wrote:
> 
> 
> On 3/16/2020 2:44 PM, Doug Berger wrote:
>> This reverts commit 3a55402c93877d291b0a612d25edb03d1b4b93ac.
>>
>> This is not a good solution when connecting to an external switch
>> that may not support the isolation of the TXC signal resulting in
>> output driver contention on the pin.
>>
>> A different solution is necessary.
>>
>> Signed-off-by: Doug Berger <opendmb@gmail.com>
> 
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> Did you want this to be tagged with:
> 
> Fixes: 3a55402c9387 ("net: bcmgenet: use RGMII loopback for MAC reset")
> 
> so as to make it more explicit how the two commits relate to each other?
I wasn't sure how best to tag this commit.

It seems odd to indicate that the reversion of a commit fixes the commit
that is reverted, but maybe that is the best way. It is more accurate to
say that the reversion of the commit reintroduces the problem that it
was intended to address, and therefore doesn't fix anything but rather
trades one problem for another.

It is clearer that the second commit fixes the original issue and so I
tagged it accordingly, but it is far less clear how a reversion like
this should be tagged.

If you think it is clearer to tag this as you describe I have no objection.

> 
> Thanks!
> --
> Florian
> 
Thank you for taking a look at this and for the feedback,
    Doug
