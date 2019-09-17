Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA4BB5828
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 00:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbfIQWmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 18:42:08 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41750 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfIQWmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 18:42:07 -0400
Received: by mail-pf1-f194.google.com with SMTP id q7so3006620pfh.8
        for <netdev@vger.kernel.org>; Tue, 17 Sep 2019 15:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4ZHsGFQ2E2luiT+HzdCU0f+44HjfCS8gCbTU/2k6hNo=;
        b=vTmL8xxzJYPH/Rd8jbvkvOsXcoKZWR9rW4hpZE3phX65BNxd16aTcP93wKUSGcalBn
         2Ge16l1wEfc0kO2KOVW2LpiAJaAKgcitR53yiiZF3pRbSyTZTm2wqetHdyRELwSazdgn
         o7O8y5fgQejc/3IvcfwiPvKe3FYLNGH+rGaqovnG2Ri8VUfg5XVx1gteKRgz803qJ9u1
         m+9H/v3ecHgPNx5IbvhVjoBWenJ9LsR2XkwiPb8yUpy5WPaW/gqOk555EJuzMRyNHWeJ
         bZJm1OCWIxoCf5aUICL/SRfoWdiHELR0AkSFIFmo2tmDSbKOqtBmV9BNy96qBHOQbX1m
         nc5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=4ZHsGFQ2E2luiT+HzdCU0f+44HjfCS8gCbTU/2k6hNo=;
        b=MGGSNyZ+IBP0Kl23LaTyqMpYQnqSZHUmij4ELb81kf7ZDF9U9EEahu8LlT6rqlc0Kn
         2SbnSmLXzY1jO26xEcyUdDTrbK5aDQcetxE0OxVmIUITarJJGHNKeLTkPluANRFVtJeZ
         L6+DL8VyHBtWmDoZWJ+fSlZgy4Y26dLEl6Wk7BOnU1TyRuYuqwBQSwU01t+L23YN+XFU
         eeG8CrtDb62wUWaLDC0r6+OLMoYNBj9B5IV2ZbojI+HSORrHkoykODk2dHvKqwDRdZK9
         YTyP2oUjcWriL4qllMPXQowooZdd1DAEnZmU1agaOD2bSPlXGCmWWtfQQMWNApvJRnkh
         z/yQ==
X-Gm-Message-State: APjAAAUUVDpNw/x8frXZ3kBpUhtpPZV2Z+G8dXgycfSzlw68U8E14mQW
        FTEyGtIldhfmjwOP5AnSFjaJqkE/Oks=
X-Google-Smtp-Source: APXvYqz0PaqLRhEuohyb6S2ScwTzdpJI4UVZQrm8lR6l5DVHPCh9k3p5sgjUh4DV0jNXQwH16/0HEA==
X-Received: by 2002:a63:304:: with SMTP id 4mr1118725pgd.13.1568760125256;
        Tue, 17 Sep 2019 15:42:05 -0700 (PDT)
Received: from [10.67.49.31] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k31sm153937pjb.14.2019.09.17.15.42.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Sep 2019 15:42:04 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Add support for port
 mirroring
To:     Iwan R Timmer <irtimmer@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20190917202301.GA29966@i5wan> <20190917205505.GF9591@lunn.ch>
 <20190917223232.GA32887@i5wan>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <dd4d4fde-39ff-c7ff-1cd4-8f5c7ddcc7a9@gmail.com>
Date:   Tue, 17 Sep 2019 15:42:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190917223232.GA32887@i5wan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/17/19 3:32 PM, Iwan R Timmer wrote:
> On Tue, Sep 17, 2019 at 10:55:05PM +0200, Andrew Lunn wrote:
>> On Tue, Sep 17, 2019 at 10:23:01PM +0200, Iwan R Timmer wrote:
>>> Add support for configuring port mirroring through the cls_matchall
>>> classifier. We do a full ingress and/or egress capture towards the
>>> capture port, configured with set_egress_port.
>>
>> Hi Iwan
>>
>> This looks good as far as it goes.
>>
>> Have you tried adding/deleting multiple port mirrors? Do we need to
>> limit how many are added. A quick look at the datasheet, you can
>> define one egress mirror port and one ingress mirror port. I think you
>> can have multiple ports mirroring ingress to that one ingress mirror
>> port. And you can have multiple port mirroring egress to the one
>> egress mirror port. We should add code to check this, and return
>> -EBUSY if the existing configuration prevents a new mirror being
>> configured.
>>
>> Thanks
>> 	Andrew
> 
> Hi Andrew,
> 
> I only own a simple 5 ports switch (88E6176) which has no problem of
> mirroring the other ports to a single port. Except for a bandwith
> shortage ofcourse. While I thought I checked adding and removing ports,
> I seemed to forgot to check removing ingress traffic as it will now
> disable mirroring egress traffic. Searching for how I can distinct
> ingress from egress mirroring in port_mirror_del, I saw there is a
> variable in the mirror struct called ingress. Which seems strange,
> because why is it a seperate argument to the port_mirror_add function?
> 
> Origally I planned to be able to set the egress and ingress mirror
> seperatly. But in my laziness when I saw there already was a function
> to configure the destination port this functionality was lost.
> 
> Because the other drivers which implemented the port_mirror_add (b53 and
> ksz9477) also lacks additional checks to prevent new mirror filters from
> breaking previous ones I assumed they were not necessary.

That does sound like a bug indeed, I just looked at b53_mirror_add()
again and clearing the MIRROR_MASK before setting up the new port
clearly sounds wrong, at least on ingress.

> 
> At least I will soon sent a new version with at least the issue of
> removing mirror ingress traffic fixed and the ability to define a 
> seperate ingress and egress port.
> 
> Regards,
> Iwan
> 


-- 
Florian
