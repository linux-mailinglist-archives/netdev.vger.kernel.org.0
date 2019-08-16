Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51D429081E
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 21:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbfHPTNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 15:13:00 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36398 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbfHPTNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 15:13:00 -0400
Received: by mail-wm1-f68.google.com with SMTP id g67so4893228wme.1
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 12:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=+3BVIS9/xZ0BmUBMBsmw/Ldnb+acdUT009Vt8Idk8/0=;
        b=k4VdnqEBv+Y/+vViTL+TK2h3q2833LcAr9/89dWALMjhJq+eWIItldkR8PUDRIzLNV
         8pQweMBXY6m+6oP5NYjQUUeuOgtGDiZvwtOVUnViQVSUe6y6C7iFLTbKPZSa+cryr4gl
         yzg1/heNB0J99RsmrRbhr16i9wtIc3YA0vfsR80xbYZup7i1KN6uXykJCsQtQYJa1xGi
         R4MFNawRh5Eym2y/BU+i1MIZewBAywt1KBIBkcbpsn+US6BXjMwF/xOb2paycSf77aM+
         GZqHernpmia5KVwb4NhI99RPWJefOuerEtv5ikcwLhw+gmMVK8U/25tyqy1FssvGOCwx
         chPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+3BVIS9/xZ0BmUBMBsmw/Ldnb+acdUT009Vt8Idk8/0=;
        b=K939wvFasvHfqTDIKYunG4fz4sE1SlbEFjj+fe1gm5nocHKi0fROWYh0AQvlW9xgr3
         w+MTAZwLMXtYk5tfNIVNyPNyglrJPUIGLMD8Ix3vqDZS2u6ITDXZzlhrUe1WjLweDwnB
         D0m27xuxCmeO9Lt1OpsXhxU9FNpytcMjUswjvbt8Slufg/zHWuIxzTTP08rmSTBcMAn8
         qMimQ28qpzNIu7fyvp4uN28nDzjyA0EDCIeTjh7yztUFWG7fOJDthELy3DvkHHqpqT3G
         Kc8AU0uAfzUEU9rM55C/A6m1MJ2C5Wb3ME0OaWz54fA0QEp4LwowDB3kJzOpPOVaqFG0
         f6wQ==
X-Gm-Message-State: APjAAAWS3aahKjLi5CZ2bwqVLcmyAuZ42lvqKT2Ih7wHlqHKUeaIeqnl
        DRewUXpWnM7hNaplDzCbnQc1m2OH
X-Google-Smtp-Source: APXvYqwMJqRopZ+ZI0JCo4/Uo9oGI+2uB9orAoY5c5xWa5jXtLlQ13IFL6pu7YzUWsGJwWO7CnpDZQ==
X-Received: by 2002:a1c:7014:: with SMTP id l20mr4192704wmc.133.1565982777542;
        Fri, 16 Aug 2019 12:12:57 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:9c37:6397:15a9:b6d2? (p200300EA8F2F32009C37639715A9B6D2.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:9c37:6397:15a9:b6d2])
        by smtp.googlemail.com with ESMTPSA id z9sm4444554wmf.21.2019.08.16.12.12.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 12:12:56 -0700 (PDT)
Subject: Re: r8169: Performance regression and latency instability
To:     =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>,
        netdev@vger.kernel.org
References: <72898d5b-9424-0bcd-3d8a-fc2e2dd0dbf1@intra2net.com>
 <217e3fa9-7782-08c7-1f2b-8dabacaa83f9@gmail.com>
 <792d3a56-32aa-afee-f2b4-1f867b9cf75f@applied-asynchrony.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <8fa71d82-d309-df38-5924-2275db188b61@gmail.com>
Date:   Fri, 16 Aug 2019 21:12:49 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <792d3a56-32aa-afee-f2b4-1f867b9cf75f@applied-asynchrony.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.08.2019 15:59, Holger Hoffstätte wrote:
> On 8/16/19 2:35 PM, Eric Dumazet wrote:
> ..snip..
>> I also see this relevant commit : I have no idea why SG would have any relation with TSO.
>>
>> commit a7eb6a4f2560d5ae64bfac98d79d11378ca2de6c
>> Author: Holger Hoffstätte <holger@applied-asynchrony.com>
>> Date:   Fri Aug 9 00:02:40 2019 +0200
>>
>>      r8169: fix performance issue on RTL8168evl
>>           Disabling TSO but leaving SG active results is a significant
>>      performance drop. Therefore disable also SG on RTL8168evl.
>>      This restores the original performance.
>>           Fixes: 93681cd7d94f ("r8169: enable HW csum and TSO")
>>      Signed-off-by: Holger Hoffstätte <holger@applied-asynchrony.com>
>>      Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>>      Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> It does not - and admittedly none of this makes sense, but stay with me here.
> 
> The commit 93681cd7d94f to net-next enabled rx/tx HW checksumming and TSO
> by default, but disabled TSO for one specific chip revision - the most popular
> one, of course. Enabling rx/tx checksums by default while leaving SG on turned
> out to be the performance issue (~780 MBit max) that I found & fixed in the
> quoted commit. SG *can* be enabled when rx/tx checkusmming is *dis*abled
> (I just verified again), we just had to sanitize the new default.
> 
> An alternative strategy could still be to (again?) disable everything by default
> and just let people manually enable whatever settings work for their random
> chip revision + BIOS combination. I'll let Heiner chime in here.
> 
> Basically these chips are dumpster fires and should not be used for anything
> ever, which of course means they are everywhere.
> 
> AFAICT none of this has anything to do with Juliana's problem..
> 
Indeed, here we're talking about changes in linux-next, and Juliana's issue is
with 4.19. However I'd appreciate if Juliana could test with linux-next and
different combinations of the NETIF_F_xxx features.

I have no immediate idea why the referenced GSO change affects r8169 but not
other chips / drivers.

> -h
> 
Heiner
