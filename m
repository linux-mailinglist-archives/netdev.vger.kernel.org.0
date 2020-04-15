Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0AE41AADB4
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 18:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415534AbgDOQSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 12:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1415520AbgDOQSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 12:18:24 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3F9C061A0C
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 09:18:23 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id a25so619724wrd.0
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 09:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/B4/ntGz7VwzGR2VIQvBkjIScjkn6bja92CmBZQb9Os=;
        b=RCh12LOsRoDqd3UARMIIjS3dA7Ba3ccnAoaI6ziE/Ic8iDaTFdUkTLgg4iskxHyG8I
         04Z+qG8jOaITZT91sHgzIQ/wkKmQs6mZM5N80rb3tdHwlmjMqW0nZm70IZU+6TF/kR6w
         pYSoJSPzrMwOVERjGlfbOdBvd0RsF2XBIL/aibgVKrrGP4Hi6Wqmk1LrIR5oJmr/mDLX
         o1Rd0v5+486//Te9tS8lqHI0DVYAVFsNR2rHxeLGI2zqcIsMaaRQdYSwzFFezoG7N6zZ
         aCKgOaIGcCTS3H0yDmn3g5OHxZ9uyENHK1orj1Cagjf+3GJNApLJCiP6MfDRw3QVWyTA
         yzXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/B4/ntGz7VwzGR2VIQvBkjIScjkn6bja92CmBZQb9Os=;
        b=svN3aZ27rsdqjKz93h+IkmRcqOLho9qSvyIRVAjv6Qz2CKIggFJfMA8K2xKPFUEVFA
         0qGG5LFJs4pfKPZL34rmOrgjEZMCDtHk9Ed6LEXWUjSV0VLAnUM9MxD2r7AStL6wbTDD
         jz0SxpR57+05cDQ0Akto8eRrjjbzDHd9tkRS/O5WQ86PYrcTWLzbGCnnLrzYNM37Y+wE
         IbKdBa7IJDo59S6T1r1uC0k7xA9JkiJF9Vc4nArVbk7yKBxH5PF7UHcCy4xMoWhht7h6
         nz0gN/m6mBYzI5hR+3K9Zxsf9FHtjv9qlAwJn7fe6r1fpU2jzNlSfcml7bpQp/x8t0m3
         cK0A==
X-Gm-Message-State: AGi0PuYKvte2KUwPN9C2uXke4yevnu0rI9UxMb/t/pelVNk0X/HfiBUL
        GgqkaWfLzc5VYC5UYdwJozQ=
X-Google-Smtp-Source: APiQypIMnP+m4hhCntefHYfRT2pVr1+nSvkOmJQuUgThSzIUlCu43EtmRgB6EZ2yIbDt7/afnPaurQ==
X-Received: by 2002:adf:dfc2:: with SMTP id q2mr17917105wrn.390.1586967502444;
        Wed, 15 Apr 2020 09:18:22 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:b957:a9ee:5ba8:7ed6? (p200300EA8F296000B957A9EE5BA87ED6.dip0.t-ipconnect.de. [2003:ea:8f29:6000:b957:a9ee:5ba8:7ed6])
        by smtp.googlemail.com with ESMTPSA id d24sm24760569wra.75.2020.04.15.09.18.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2020 09:18:21 -0700 (PDT)
Subject: Re: NET: r8168/r8169 identifying fix
To:     Lauri Jakku <ljakku77@gmail.com>
Cc:     Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        nic_swsd@realtek.com
References: <4bc0fc0c-1437-fc41-1c50-38298214ec75@gmail.com>
 <20200413105838.GK334007@unreal>
 <dc2de414-0e6e-2531-0131-0f3db397680f@gmail.com>
 <20200413113430.GM334007@unreal>
 <03d9f8d9-620c-1f8b-9c58-60b824fa626c@gmail.com>
 <d3adc7f2-06bb-45bc-ab02-3d443999cefd@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <f143b58d-4caa-7c9b-b98b-806ba8d2be99@gmail.com>
Date:   Wed, 15 Apr 2020 18:18:15 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <d3adc7f2-06bb-45bc-ab02-3d443999cefd@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.04.2020 16:39, Lauri Jakku wrote:
> Hi,
> 
> There seems to he Something odd problem, maybe timing related. Stripped version not workingas expected. I get back to you, when  i have it working.

There's no point in working on your patch. W/o proper justification it
isn't acceptable anyway. And so far we still don't know which problem
you actually have.
FIRST please provide the requested logs and explain the actual problem
(incl. the commit that caused the regression).


> 13. huhtik. 2020, 14.46, Lauri Jakku <ljakku77@gmail.com <mailto:ljakku77@gmail.com>> kirjoitti:
> 
>     Hi,
> 
>     Fair enough, i'll strip them.
> 
>     -lja
> 
>     On 2020-04-13 14:34, Leon Romanovsky wrote:
> 
>         On Mon, Apr 13, 2020 at 02:02:01PM +0300, Lauri Jakku wrote:
> 
>             Hi,
> 
>             Comments inline.
> 
>             On 2020-04-13 13:58, Leon Romanovsky wrote:
> 
>                 On Mon, Apr 13, 2020 at 01:30:13PM +0300, Lauri Jakku wrote:
> 
>                     From 2d41edd4e6455187094f3a13d58c46eeee35aa31 Mon Sep 17 00:00:00 2001
>                     From: Lauri Jakku <lja@iki.fi>
>                     Date: Mon, 13 Apr 2020 13:18:35 +0300
>                     Subject: [PATCH] NET: r8168/r8169 identifying fix
> 
>                     The driver installation determination made properly by
>                     checking PHY vs DRIVER id's.
>                     ---
>                     drivers/net/ethernet/realtek/r8169_main.c | 70 ++++++++++++++++++++---
>                     drivers/net/phy/mdio_bus.c | 11 +++-
>                     2 files changed, 72 insertions(+), 9 deletions(-)
> 
> 
>                 I would say that most of the code is debug prints.
> 
> 
> 
>             I tought that they are helpful to keep, they are using the debug calls, so
>             they are not visible if user does not like those.
> 
> 
>         You are missing the point of who are your users.
> 
>         Users want to have working device and the code. They don't need or like
>         to debug their kernel.
> 
>         Thanks
> 

