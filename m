Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40580457C0A
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 07:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236531AbhKTG54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 01:57:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235213AbhKTG54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Nov 2021 01:57:56 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA31C061574
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 22:54:53 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id w29so21950640wra.12
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 22:54:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to
         :references:from:cc:subject:in-reply-to:content-transfer-encoding;
        bh=jIufy5/sj9ursw//KegGDro38hQLaoRwE9fym57CAoA=;
        b=B3JVr9Q01FHqKVWwTY3pCbA+IqEvrsNyRE8I5U3iGMxti+iJ6VPwRrkU9rvqXctbTC
         i6zSZWJ4cZjJgJRmMM0DFzJjamQABxmc+9YG7dLUZNX3Xc/tPUPMX4GyU88EDwV2ULR/
         PLVet9yiPjHX7GOHD7Fdai1H7sIDNelJdU0vJ4lkRDd0yTo1Dl/3KLEiNSInohAHQ9lp
         54D3AbFoQOhF/tQatKtgaJQ+wH+66u+2S18ezG9EEFkSOJdcHKuif1dNwzE/HVXLL6yp
         7EouEugfYaEAZPAtJArI+icRGoTGKEMwkl0mb9Ur82aqwyYKJrEhA6xfh7t1EgvPaDMn
         UVVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:references:from:cc:subject:in-reply-to
         :content-transfer-encoding;
        bh=jIufy5/sj9ursw//KegGDro38hQLaoRwE9fym57CAoA=;
        b=svOPn30+MdGCo6BKbUB6Rth5CXFrdhp0y3wSe9j8bQNd0b2inn7mUuYmMMGKG6z3/O
         A/deyLSqu+9GeXPCD+mTtKKmkH8DM69su637FARZG/R00ImrvDjTn5hCdRQfj38zbKOd
         vWLivIW1mPNvGvhu3R5R0BDYdA8HR3Zlwz8+VzxvuGMQpZJg5GB1glACUrjnZwVcIxt4
         oO50/Rgjax9zTKvTDQqnThb/ILB+wszYHv3/rzmdytxcXswrgWICMp6GT0zbSE3t+TO7
         t4v+h1YVQs4U/gZDjCttXmrjPG9Cpr9HSwySrdcIrneVuEvV4V50NB9ZmrnUUTlmWf0B
         o48A==
X-Gm-Message-State: AOAM530X9fTDyUsoAxN7XBrAsYEd2DmYA+hDxTKFPl3zrRIBEaYfwP05
        kMt7ap0nZejyz8kd65Rqx8w=
X-Google-Smtp-Source: ABdhPJwYQ3EaH3b5qWg8oxtmPdfuXuaZRZ0ypYi7yfj/kt0IGr07Ab3HQyxzz+1U4e027w4GDO7N0w==
X-Received: by 2002:adf:dcd0:: with SMTP id x16mr15129784wrm.229.1637391291900;
        Fri, 19 Nov 2021 22:54:51 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:7590:8daa:798f:a500? (p200300ea8f1a0f0075908daa798fa500.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:7590:8daa:798f:a500])
        by smtp.googlemail.com with ESMTPSA id be3sm14000131wmb.1.2021.11.19.22.54.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Nov 2021 22:54:51 -0800 (PST)
Message-ID: <218d4659-e114-fe9d-780d-dfd73b9601d1@gmail.com>
Date:   Sat, 20 Nov 2021 07:54:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Content-Language: en-US
To:     Q1IQ Fu <fufuyqqqqqq@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
References: <20211119184709.19209-1-fufuyqqqqqq@gmail.com>
 <9aedd796-50a1-0fe1-7d1e-43a59fb58b8d@gmail.com>
 <CANqj-X=6yri8wv=aHVxUkUDOZV20QbhK4YcGHVdSXWY7XwkQiA@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] r8169: Apply configurations to the L0s/L1 entry delay of
 RTL8105e and RTL8401
In-Reply-To: <CANqj-X=6yri8wv=aHVxUkUDOZV20QbhK4YcGHVdSXWY7XwkQiA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.11.2021 07:41, Q1IQ Fu wrote:
> Thank you very much for your attention. We detected the presence of these two bugs through our new vulnerability scanning technology. We think there may be a security issue, if not, please ignore it.
> 
What exactly is the security issue and how could it be exploited?
It's not the first time that I see a patch submitted based solely on the output of obscure tools.
Always check the result of tools, and you should be able to explain and interpret the tool output.
Especially you should be able to see whether a warning is a false positive.

> Heiner Kallweit <hkallweit1@gmail.com <mailto:hkallweit1@gmail.com>> 于2021年11月20日周六 上午4:06写道：
> 
>     On 19.11.2021 19:47, Yeqi Fu wrote:
>     > We properly configure the L0s/L1 entry delay in the startup functions of
>     > RTL8105e and RTL8401 through rtl_set_def_aspm_entry_latency(), which will
>     > avoid local denial of service.
>     >
> 
>     What do you mean with local denial of service? Are you aware of any issues
>     with these two chip versions?
> 
>     Where do you got the info from that these calls are appropriate? At least
>     for RTL8401 even the r8101 vendor driver doesn't do it.
> 
>     Your patch misses the net vs. net-next annotation. Is this supposed to be
>     a fix? Then a Fixes tag would be needed.
> 
>     > Signed-off-by: Yeqi Fu <fufuyqqqqqq@gmail.com <mailto:fufuyqqqqqq@gmail.com>>
>     > ---
>     >  drivers/net/ethernet/realtek/r8169_main.c | 2 ++
>     >  1 file changed, 2 insertions(+)
>     >
>     > diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>     > index bbe21db20417..4f533007a456 100644
>     > --- a/drivers/net/ethernet/realtek/r8169_main.c
>     > +++ b/drivers/net/ethernet/realtek/r8169_main.c
>     > @@ -3420,6 +3420,7 @@ static void rtl_hw_start_8401(struct rtl8169_private *tp)
>     >               { 0x07, 0xffff, 0x8e68 },
>     >       };
>     > 
>     > +     rtl_set_def_aspm_entry_latency(tp);
>     >       rtl_ephy_init(tp, e_info_8401);
>     >       RTL_W8(tp, Config3, RTL_R8(tp, Config3) & ~Beacon_en);
>     >  }
>     > @@ -3437,6 +3438,7 @@ static void rtl_hw_start_8105e_1(struct rtl8169_private *tp)
>     >               { 0x0a, 0, 0x0020 }
>     >       };
>     > 
>     > +     rtl_set_def_aspm_entry_latency(tp);
>     >       /* Force LAN exit from ASPM if Rx/Tx are not idle */
>     >       RTL_W32(tp, FuncEvent, RTL_R32(tp, FuncEvent) | 0x002800);
>     > 
>     >
> 

