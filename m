Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35A992E65F
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 22:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbfE2UoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 16:44:19 -0400
Received: from mail-oi1-f177.google.com ([209.85.167.177]:45661 "EHLO
        mail-oi1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfE2UoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 16:44:19 -0400
Received: by mail-oi1-f177.google.com with SMTP id w144so3189872oie.12;
        Wed, 29 May 2019 13:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VZGSPRNTu5KLWtlJIz9+NTNedpNZDMEiLUXIhHi/rWo=;
        b=DFbsdDwmsd0Y+1s18SvJcNDWqIMcHGOm8RcO8xcvmcnhZt+KyvgtGVtnxQfv8053AT
         sLPl6aSTS0osIRzIiuYXjoX9SCfSnnz/B+L0B5tw/8LPvCtPoYgDCLutSq7703WRYL4C
         xGpuHnKn32bfCxn4xxLwxcQa7YY8d0RGekfG8hZ3Nyxs7PL86ACULL2wNKX5ls8DqwMW
         bIQNGOHun1S6lSl2mkyEs5D5ULBslY9aVA2uzdKoS2AN4JGW6CrcJalLJAUXdDx8t/eh
         MG2RPQsdlfZk8SZbAUKRElFk7D2cguy4CCzTuuiUxnyuMJPITZp2NAxvHYQzGKkmVx16
         boZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VZGSPRNTu5KLWtlJIz9+NTNedpNZDMEiLUXIhHi/rWo=;
        b=IOzYgKdF2e/hM0K1PuXk4rza9bD8wOh4Y9xgaJR7Nzc3EdflqN4ZAtRlgYDtQgFgqt
         GmJ5wa6f9yjNly0gqAQq84q3cVhMh1WZy+SLz1XMugx/lBLCAG0ERIAbn510/GGjYGxJ
         uDsB2kKCWXG1sNh5Bhhq94Tb2B8AzrfToHot2qJH8F0qFnRbFKVx4OfeduyaXY4qeRVK
         ugOvJNlDQ4GtOSQy+MFo5/YkM+xxokFOcSQEV+xAQPOd70mNqdc+nE3errGmW9agj2mb
         vfDxkjDsvM8oc2j6SQn8Fl9KArgu4CxMZS4M+6jvZz3C/OEDQ1U24cGNhaoOz3hejft+
         MMKQ==
X-Gm-Message-State: APjAAAW5y3v29Pv91H3+5MLGWaXYwgq3O3rvWHTSC2/9vEcmbW7140c5
        0gGxYMi2/XygoqYemBL/HJk=
X-Google-Smtp-Source: APXvYqzTSAR2JK8vJuUkx0N+FPhXnJHMvEPBhQvTwb3/X94x8kQ+WuNktSPJqalZ4XJAE/4ilQucvg==
X-Received: by 2002:aca:3149:: with SMTP id x70mr123700oix.97.1559162653523;
        Wed, 29 May 2019 13:44:13 -0700 (PDT)
Received: from [192.168.1.249] (cpe-70-114-247-242.austin.res.rr.com. [70.114.247.242])
        by smtp.googlemail.com with ESMTPSA id p64sm224498oif.8.2019.05.29.13.44.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 13:44:13 -0700 (PDT)
Subject: Re: cellular modem APIs - take 2
To:     Johannes Berg <johannes@sipsolutions.net>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Dan Williams <dcbw@redhat.com>,
        Sean Tranchetti <stranche@codeaurora.org>,
        Daniele Palmas <dnlplm@gmail.com>,
        Aleksander Morgado <aleksander@aleksander.es>,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>
References: <b59be15f1d0caa4eaa4476bbd8457afc44d57089.camel@sipsolutions.net>
 <662BBC5C-D0C7-4B2C-A001-D6F490D0F36F@holtmann.org>
 <acf18b398fd63f2dfece5981ebd5057141529e6a.camel@sipsolutions.net>
From:   Denis Kenzior <denkenz@gmail.com>
Message-ID: <8b6b6174-7de4-b9a9-242b-765da647402e@gmail.com>
Date:   Wed, 29 May 2019 15:44:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <acf18b398fd63f2dfece5981ebd5057141529e6a.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Johannes,

> 
> After all, I'm not really proposing that we put oFono or something like
> it into the kernel - far from it! I'm only proposing that we kill the
> many various ways of creating and managing the necessary netdevs (VLANs,
> sysfs, rmnet, ...) from a piece of software like oFono (or libmbim or
> whatever else).

I do like the concept of unifying this if possible.  The question is, is 
it actually possible :)  I think Dan covered most of the aspects of what 
userspace has to deal with already.  But the basic issue is that there's 
a heck of a lot of different ways of doing it.

> 
> Apart from CAIF and phonet, oFono doesn't even try to do this though,
> afaict, so I guess it relies on the default netdev created, or some out-
> of-band configuration is still needed?

Actually it can.  We can drive modems which provide only a single serial 
port and run multiplexing over that.  So we fully control the number of 
control channels created, the number of netdevs created and even 
create/destroy them on as needed basis.  And these netdevs can be PPP 
encapsulated or pure IP or whatever else.

Regards,
-Denis
