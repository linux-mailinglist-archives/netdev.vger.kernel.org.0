Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1CE513B3A
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 18:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfEDQn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 12:43:26 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:40473 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbfEDQn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 12:43:26 -0400
Received: by mail-pl1-f175.google.com with SMTP id b3so4215729plr.7
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 09:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=7ZaUIho166kftAHyL5ajVT/MfQYzFI2LxRcy7r1cqSE=;
        b=sDc8mwQ3D3Gus3l+a1zLErL1Qk/WPtN0kuzDNZ+FuiUwAE5XVpRQQqw7vdr4i8sCCW
         VUWcHoUE2oa/4XyBDsv3MLMx4mQ42tVLL1bZnCqEp+WjU9y5CGRFIuczB4Bb2mZUaEUz
         ZV80927WC/Jh05TfN85/knv1OMb+W2v1iRCTEYfcb3nkmnXsGx5/1O479pYPcQuVFJNS
         RWLhC6GTOUWAdjHEqkDQB8ABhRGGKxNIP2dLTtdL6bqv1Q5/Egp7yBq0osHSKKDye3jx
         tHGXrpl/4MFWS4OTeN86KgYsbUUXicLJ9Vnc9ccrisXrmdp+3zuQvzYjtlZIVMApQVPU
         W3Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7ZaUIho166kftAHyL5ajVT/MfQYzFI2LxRcy7r1cqSE=;
        b=kMC6UmdtMohR8NASFzu3YBKscNi3uVCFPpFOIU7TpJaGbogTphyLI8LKlU7kSJCeLd
         vzVskJThwUJWh3E8Vgl8OU2nSWCqww+bNquAOcWcL2InxAahyNdXAJ0VdpUNh/hFqgf6
         f3DzhLIBmnjzDKGsE6NLV/EXycvPBFs2kx9e3wmp1TA8R69bNowh2XeChL14A9pSYd0i
         nDHFCwOACVKSo8xpuXnJWSpMt3HrqdWwjaL7fqQHx8rRq36aL/wHUwRiOhrLmls7XMeL
         JJ8PdD64JtYl3m2VhtoJveyPjAW4JD1iLPqhBwy+MLuZwUypihorSHpeGF6NicFv8IFX
         yTDA==
X-Gm-Message-State: APjAAAVK6KPKlHDGmUHQoay89O5aNFvsbGU82GUXBctq2fT+W7khANCR
        QcfRfOElg9lwQTYY4l2+xJn2D94K
X-Google-Smtp-Source: APXvYqz9M94E/ypHjT0k0adfaX4zQESyWSfRrlfFgAcQ+fy7W9+KAQ+i65vfMt4i0qXgErZ3nj0aaA==
X-Received: by 2002:a17:902:8a81:: with SMTP id p1mr19966987plo.106.1556988205569;
        Sat, 04 May 2019 09:43:25 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id s85sm12433875pfa.23.2019.05.04.09.43.24
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 09:43:24 -0700 (PDT)
Subject: Re: CVE-2019-11683
To:     Reindl Harald <h.reindl@thelounge.net>, netdev@vger.kernel.org
References: <7a1c575b-b341-261c-1f22-92d656d6d9ae@thelounge.net>
 <0ca5c3b7-49e5-6fdd-13ba-4aaee72f2060@gmail.com>
 <f81bad23-97d5-1b2b-20a1-f29cfc63ff79@thelounge.net>
 <f84d6562-3108-df30-36f7-0580bd6ea4e2@gmail.com>
 <65007ac9-97f2-425e-66f4-3b552deb20ac@thelounge.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b29aea5d-930e-778a-1627-1bfd85cbe849@gmail.com>
Date:   Sat, 4 May 2019 12:43:23 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <65007ac9-97f2-425e-66f4-3b552deb20ac@thelounge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/4/19 12:39 PM, Reindl Harald wrote:
> 
> 
> Am 04.05.19 um 18:32 schrieb Eric Dumazet:
>> On 5/4/19 12:13 PM, Reindl Harald wrote:
>>>
>>> ok, so the answer is no
>>>
>>> what's the point then release every 2 days a new "stable" kernel?
>>> even distributions like Fedora are not able to cope with that
>>
>> That is a question for distros, not for netdev@ ?
> 
> maybe, but the point is that we go in a direction where you have every 2
> or 3 days a "stable" update up to days where at 9:00 AM a "stable" point
> release appears at kernel.org and one hour later the next one from Linus
> himself to fix a regression in the release an hour ago
> 
> release-realy-release-often is fine, but that smells like rush and
> nobody downstream be it a sysadmin or a distribution can cope with that
> when you are in a testing stage a while start deploy there are 2 new
> releases with a long changelog
> 
> just because you never know if what you intended to deploy now better
> should be skipped or joust go ahead because the next one a few days
> later brings a regression and which ones are the regressions adn which
> ones are the fixes which for me personally now leads to just randomly
> update every few weaks
> 

In any case, this discussion has nothing to do with netdev@

Are you suggesting that we should not fix bugs at given period of times,
just because a 'release of some stable kernel' happened one day before ?

How you do your updates does not really concern us, sorry !
