Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E10B41651F0
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 22:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbgBSVyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 16:54:24 -0500
Received: from mail-wr1-f43.google.com ([209.85.221.43]:42842 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgBSVyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 16:54:24 -0500
Received: by mail-wr1-f43.google.com with SMTP id k11so2308359wrd.9
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 13:54:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3UoAYIZ+M7rSviJWzY8P0bFSYlVZ+SF4yS7FzXbX1U8=;
        b=F9vGDCKmESXItJIt+Ue4stXsHHMPISoqIwSqElJ6Sc/xtg314uGDWxrE7lPtQNWCc4
         sQ2chmusBueqXud3uhbLx2O7m5a76zlJRPtCRnMgZy7hjiSqVkL0g3ys1+L5qY88v1oO
         nYPsCvbEe9bd7NSZ/mRvQH9ChrwFpsVsckg5vq6f3m2kizMFXSoro6ONO+8+sSeeXsNQ
         Cx3jH/CIy33IBw2bVqIiQMlxzgkoiLj9FQVWhe5viWDmMFkSNP5uV6A27hNLVajRnIc+
         kpvNV+Qmk3A3ReYsK5lSGir68KLsNWG6T614kKYCnIyXI3C8ywe7nMMRplt4MSqls28W
         sGPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3UoAYIZ+M7rSviJWzY8P0bFSYlVZ+SF4yS7FzXbX1U8=;
        b=J4l0H4+QH8cB6haqN1G0bsQOeAHl+yb8JcRJLO+ACMortOWTJuLg1B2q26jSLUi5uH
         MQbzpIBwt2d1pq3h0xJRq8ZY4mmlLURuHUqw3MZ+okQR+R9O7TEXio7XWX8mKzXTv32R
         10MpPsKqsaz4YtA/Qg4RF0fp0GoSK0brfonYe3kbfiR2Nix/adqRVXx8UvMI9srsgT4q
         1+lpr8pZQhPs0oY1B7rBke0kAgMK5GhYG7zPZBQiSxqJtqU6fQCoFrwiQqyNDucSVv0X
         ncjdjnmyEg/bEeHDdSH0sjEN6eFi1eqD9OpIGH86tQsqbO2Klzd/avjU9Hraq82gInU7
         kd4g==
X-Gm-Message-State: APjAAAV3DqzTvEtRicxLNqj32NxSP2lduXWMlh5s4U/TzxwFPfaKgKnM
        qLDjsaXIllVbsqKhC2dbzLeD8U7W
X-Google-Smtp-Source: APXvYqzz4Meob5l9WGn1V0HGbl8W+h0VbHEm0oPFvUk8pu8ikBKmt0GBxIPXggjhhFQzQ1v7YSYRMA==
X-Received: by 2002:adf:f012:: with SMTP id j18mr37918079wro.314.1582149262178;
        Wed, 19 Feb 2020 13:54:22 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:a8cb:6924:1f30:ec1a? (p200300EA8F296000A8CB69241F30EC1A.dip0.t-ipconnect.de. [2003:ea:8f29:6000:a8cb:6924:1f30:ec1a])
        by smtp.googlemail.com with ESMTPSA id e17sm1604599wrn.62.2020.02.19.13.54.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2020 13:54:21 -0800 (PST)
Subject: Re: About r8169 regression 5.4
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Vincas Dargis <vindrg@gmail.com>,
        Salvatore Bonaccorso <carnil@debian.org>
Cc:     netdev@vger.kernel.org
References: <b46d29d8-faf6-351e-0d9f-a4d4c043a54c@gmail.com>
 <9e865e39-0406-d5e0-5022-9978ef4ec6ac@gmail.com>
 <97b0eb30-7ae2-80e2-6961-f52a8bb26b81@gmail.com>
 <20200215161247.GA179065@eldamar.local>
 <269f588f-78f2-4acf-06d3-eeefaa5d8e0f@gmail.com>
 <3ad8a76d-5da1-eb62-689e-44ea0534907f@gmail.com>
 <74c2d5db-3396-96c4-cbb3-744046c55c46@gmail.com>
 <81548409-2fd3-9645-eeaf-ab8f7789b676@gmail.com>
 <e0c43868-8201-fe46-9e8b-5e38c2611340@gmail.com>
Message-ID: <badbb4f9-9fd2-3f7b-b7eb-92bd960769d9@gmail.com>
Date:   Wed, 19 Feb 2020 22:54:14 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <e0c43868-8201-fe46-9e8b-5e38c2611340@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.02.2020 20:59, Heiner Kallweit wrote:
> On 17.02.2020 19:08, Vincas Dargis wrote:
>> 2020-02-16 01:27, Heiner Kallweit rašė:
>>> One more idea:
>>> Commit "r8169: enable HW csum and TSO" enables certain hardware offloading by default.
>>> Maybe your chip version has a hw issue with offloading. You could try:
>>>
>>> 1. Disable TSO
>>> ethtool -K <if> tso off
>>>
>>> 2. If this didn't help, disable all offloading.
>>> ethtool -K <if> tx off sg off tso off
>>>
>>
>> Unmodified 5.4 was running successfully for whole Sunday with `tx off sg off tso off`! Disabling only tso did not help, while disabling all actually avoided the timeout.
>>
> Great, thanks a lot for testing! Then the bisecting shouldn't be needed. Since 5.4 these features are enabled by default,
> up to 5.3 they are available but have to be enabled explicitly. This should explain the observed behavior.
> So it looks like this chip version has a hw issue with tx checksumming. I contacted Realtek to see whether
> they are aware of any such hw issue. Depending on their feedback we may have to add a quirk for this chip version
> to not enable these features by default.
> 
Realtek responded that they are not aware of a HW issue with RTL8411b. They will try to reproduce the error,
in addition they ask to test whether same issue occurs with their own driver, r8168.
Would be great if you could give r8168 a try. Most distributions provide it as an optional package.
Worst case it can be downloaded from Realtek's website, then it needs to be compiled.

