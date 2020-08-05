Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7CD323C59C
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 08:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbgHEGQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 02:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbgHEGQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 02:16:54 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF840C06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 23:16:53 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id l4so45013793ejd.13
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 23:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=y9STU8eBxXfNE6Av0kO8QI7kPDY/r38ynfn1dPE1Q78=;
        b=G1++EdkpqHWLqsLcJHmcrB6amz7oO09FzhjlJuDhdJ8jZ3994Ks/9JxoqW8SrOQOEn
         o19HF75ABxz6PQHb5JofptAMSDuOQlaWnYmH+Pgv/KcUua5qhipVOQJYPwnucz/HWWBy
         xHpXxPU/YV9jYlpyuMmug3tdZadY7NJIEbWBvcZOyO4KJ3YkkIE6/ANnOGk6WLZiJ/zy
         8ulpEPM29IgNevqSpo2s8SB3y3WMxbH1HAFtGM1VJ6S45JSEFXo884scQTbQIo0RBJSg
         Y0dDpxskyfGgoAJq8sgAPBqGi81LiWEo4dY13nPlHMycIaI1f1X/KYJavWDGmg6A5N8O
         DvmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y9STU8eBxXfNE6Av0kO8QI7kPDY/r38ynfn1dPE1Q78=;
        b=pj/aVK/JFSvAdOdnEdh3HwDDJgzdO/WscY3VZ/BGjrn/XHb+OUVZUxUce6MBDHvn2j
         RoRg3kGdIg9bm7c2PbBgSU4mKD4FoKj9hHHpWg4QlHDjQU3BPw6AtaexOw3emBnT7B3g
         Kf7gQY95peH/2IQKBB8rfi9VbxhWRh3F2nGnvG1P+jSJIg1uMjCdSUGYl5CI6WMIpOq3
         8o8uQ9CRWENDeM0yn13aIba+8ffrE71csJTRdLu+fSkmEtM7MRfFq4Ki8XGftiQaByJG
         9HOyIBrKD6fxAQ0DiTqvZWfzJiCMfh01pmsnrM3iU82DAsH/Zj1SC/8gVBKnuMCmcMes
         usVA==
X-Gm-Message-State: AOAM530J64LZeBcexKZYgQCvM9k5A/qggBlKMsZxU/RUznR1NHeS5Jau
        fBVFM5uS6MlprrTiwW4BYkJRyZuM3zc=
X-Google-Smtp-Source: ABdhPJxDZWA+cGv/WrlMQ7VTmgSdwUhfLKf1+SHIpruP2nTPDPSZfr29KBKOdC0R7pbLE5hnIQ+c2w==
X-Received: by 2002:a17:906:29d5:: with SMTP id y21mr1587585eje.131.1596608212169;
        Tue, 04 Aug 2020 23:16:52 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:5daf:b7bc:eb5e:fc5a? (p200300ea8f2357005dafb7bceb5efc5a.dip0.t-ipconnect.de. [2003:ea:8f23:5700:5daf:b7bc:eb5e:fc5a])
        by smtp.googlemail.com with ESMTPSA id q3sm752452edc.88.2020.08.04.23.16.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2020 23:16:51 -0700 (PDT)
Subject: Re: The card speed limited to 100 Mb/s
To:     jsbien@mimuw.edu.pl
Cc:     netdev@vger.kernel.org
References: <86sgd2g2vo.fsf@mimuw.edu.pl> <86wo2eo05x.fsf@mimuw.edu.pl>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <198814f6-ddc8-0be4-4df2-d255a133971a@gmail.com>
Date:   Wed, 5 Aug 2020 08:16:43 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <86wo2eo05x.fsf@mimuw.edu.pl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.08.2020 18:17, Janusz S. Bień wrote:
> 
> I apologize for a false alarm - the cable had to be replaced.
> 
It wouldn't have been a question for the kernel community anyway
because it's about a out-of-tree vendor driver.
And the 150MB/s - 300MB/s obviously refer to WiFi.


> Regards
> 
> Janusz
> 
> On Tue, Aug 04 2020 at 11:46 +02, Janusz S. Bień wrote:
>> Hi!
>>
>> I follow the instruction from the README.Debian file in
>> r8168-dkms_8.048.03-1_all.deb.
>>
>> This is a HP laptop connected to a 150 Mb/s. The HP service claims the
>> card should be working with the speed up to 300 Mb/s. Both tests and
>> Setting show the speed of 100 Mb/s only. For videoconferences the
>> difference can be quite essential.
>>
>> Best regards
>>
>> Janusz
>>
>> root@debian:~# lshw -class network -short
>> H/W path               Device     Class          Description
>> ============================================================
>> /0/100/2.2/0           enp2s0     network        RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller
>> /0/100/2.4/0                      network        Realtek Semiconductor Co., Ltd.
>> /2                     docker0    network        Ethernet interface
>> root@debian:~# ethtool -i enp2s0 
>> driver: r8168
>> version: 8.046.00-NAPI
>> firmware-version: 
>> expansion-rom-version: 
>> bus-info: 0000:02:00.0
>> supports-statistics: yes
>> supports-test: no
>> supports-eeprom-access: no
>> supports-register-dump: yes
>> supports-priv-flags: no
> 

