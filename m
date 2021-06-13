Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1053A58E7
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 16:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbhFMOCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 10:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbhFMOCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 10:02:02 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4E6C061574
        for <netdev@vger.kernel.org>; Sun, 13 Jun 2021 07:00:00 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id bp38so16543607lfb.0
        for <netdev@vger.kernel.org>; Sun, 13 Jun 2021 07:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-transfer-encoding;
        bh=7gAZsI9uP80PmfleIVQwtDLemAQAvF8RP1ic//822DE=;
        b=XMaSrY+JjsDRHFLUw0zFBSHU1bBNGbIatlfGufOAzUwSmuvdLJE9V/RsHK0mN8CoDG
         NZyQmcri84H4H0I9AKbyMq53ezwrJJtGKMYMuwQkkcyhZ0whUvnnRdJ6Ew2sBNDHaXDd
         tykIXMfmn3UgkxVwz+NivIiweBtYO4MDtKN/jfTL6pBMnxcNSOAtXLHBpVV02LcRZ9lc
         p1+T5qIftu79rrCAoc8DR7axRZEHOYLxus0cvD5BSN2J4LM7xC6NvH8gKUKtKoktMbul
         k8c0tT63pLIxh5B08fYhvU0sJUSWvESjpwE42YMFm5AJf5/g8G3X2IhORRsFF+S9AM22
         rjuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-transfer-encoding;
        bh=7gAZsI9uP80PmfleIVQwtDLemAQAvF8RP1ic//822DE=;
        b=UwdRxdqgA7rMffYZVec3uoRDMXQILcb8Cl0zRwtPGLOXDSCpkE7VN6m7lAEVbWFHy1
         NlAQmos2uYAlO8zUamvZMbe6beHxvuugulyckgEV/qLaa7GqPC6ggDE+yUpDFMnH9fqE
         JT8cWTx91dpKdJUQU/ivOciwzbRL0fwUonEXEM5DQG/oc35umx4VIk++Hspa97aJq6Mu
         MwVcSFNopMmxucfMaGTYid/dTer18kO3ET6t8ntqCc+LF2GamYqp1hPsD/CuIhD6RqZD
         IxaonO0bODvQenOvlCNVTcmyrj4Sz6RYCZvWdgSjQ5Y5jF9Dm+SWVIF2FO5OVVIahizq
         E0ww==
X-Gm-Message-State: AOAM532YCGkaPLj26j/aMKlb2PrT6hLEd7RfVIssdGaPA1izPek+jpFN
        oJm0AfmWNqdhlHaR96OEmck=
X-Google-Smtp-Source: ABdhPJxAuIpGCpxuKClEK/QDVToFjg8mjGwUIB3RTDanmQCbYGyK9KQiK3V32G8gLYtWVvH8/P20cA==
X-Received: by 2002:ac2:4c8b:: with SMTP id d11mr9100303lfl.628.1623592798993;
        Sun, 13 Jun 2021 06:59:58 -0700 (PDT)
Received: from [192.168.0.91] ([188.242.181.97])
        by smtp.googlemail.com with ESMTPSA id z19sm1188115lfd.15.2021.06.13.06.59.58
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Sun, 13 Jun 2021 06:59:58 -0700 (PDT)
Message-ID: <60C611E0.5020908@gmail.com>
Date:   Sun, 13 Jun 2021 17:10:40 +0300
From:   Nikolai Zhubr <zhubr.2@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To:     Arnd Bergmann <arnd@kernel.org>
CC:     netdev <netdev@vger.kernel.org>
Subject: Re: Realtek 8139 problem on 486.
References: <60B24AC2.9050505@gmail.com> <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com> <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com> <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com> <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com> <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com> <60B65BBB.2040507@gmail.com> <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com> <60B6C4B2.1080704@gmail.com> <CAK8P3a0iwVpU_inEVH9mwkMkBxrxbGsXAfeR9_bOYBaNP4Wx5g@mail.gmail.com> <60BEA6CF.9080500@gmail.com> <CAK8P3a12-c136eHmjiN+BJfZYfRjXz6hk25uo_DMf+tvbTDzGw@mail.gmail.com> <60BFD3D9.4000107@gmail.com> <CAK8P3a0Wry54wUGpdRnet3WAx1yfd-RiAgXvmTdPd1aCTTSsFw@mail.gmail.com> <60BFEA2D.2060003@gmail.com> <CAK8P3a0j+kSsEYwzdERJ7EZ8KheAPhyj+zYi645pbykrxgZYdQ@mail.gmail.com> <60C4F187.3050808@gmail.com> <CAK8P3a3vnnaYf6+v9N1WmH0N7uG55DrC=Hy71mYi4Kt+FXBRuw@mail.gmail.com>
In-Reply-To: <CAK8P3a3vnnaYf6+v9N1WmH0N7uG55DrC=Hy71mYi4Kt+FXBRuw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

13.06.2021 1:41, Arnd Bergmann:
> Or, to keep the change simpler, keep the inner loop in the tx
> and rx processing, doing all rx events before moving on
> to processing all tx events, but then looping back to try both
> again, until either the budget runs out or no further events
> are pending.

Ok, made a new version: https://pastebin.com/3FUUrg7C
It is much simpler and is very close to your patch now.

All previous conditional defines are eliminated along with unnecessary 
code fragments, and here is TUNE8139_BIG_LOOP to introduce a top-level 
loop in poll function as you suggested above. But apparently it works 
well both with and without this loop. At least my testing did not show 
any substantial difference in performance. Therefore I think it could be 
completely removed for the sake of simplicity.

One problem though is the kernel now always throws a traceback shortly 
after communication start:
https://pastebin.com/VhwQ8wsU
According to system.map it likely points to __local_bh_endble_ip() and 
there is one WARN_ON_ONCE() in it indeed, but I have no idea what it is 
and how to fix it.

Yet another thing is that tp->rx_lock and tp->lock are now used within 
poll function in a way that possibly suggests one of them could be 
eliminated.


Thank you,

Regards,
Nikolai


>
>        Arnd
>

