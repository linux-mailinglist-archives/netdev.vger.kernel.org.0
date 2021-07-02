Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDA03BA419
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 20:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbhGBSyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 14:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbhGBSyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 14:54:13 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B509AC061762
        for <netdev@vger.kernel.org>; Fri,  2 Jul 2021 11:51:40 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id k21so14632657ljh.2
        for <netdev@vger.kernel.org>; Fri, 02 Jul 2021 11:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-transfer-encoding;
        bh=JPKVudL6PfqWrbkbZh1f6GiTfa8IkX+CXBD/7o66dK0=;
        b=g2ZrSfwStkON1HqNIvHik1z2qqpdcINTys0PnxU81UnEy3qYkVWTAaivnlH2cGtWcG
         qpQAqOmOLZ9ZPPvwfhXn0n+iys8Pbc+FbTE4GCkvQlcvEvCu+d+MOsFb0Qb3RPpoucnt
         Qatd4sl1aAVtd9oJEJm6JaIbgvGoTOZcs+UmKi3loOLuZos3q0jUIzjyWUpAvUR/Mtbo
         xfsu8et8ILRdoNx3bqk2yDwyn+KL1mjg31cPknBbGsb+7/yb5qXsE6yy2g0+m9/J2A5m
         bde4SglnPiWeMQ1jjgzE5ovItAWHuZcZYm+kPgpABfRC+IMKlqA6Filczl8SZ0c7CfGD
         aodA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-transfer-encoding;
        bh=JPKVudL6PfqWrbkbZh1f6GiTfa8IkX+CXBD/7o66dK0=;
        b=TnMf9EFIWyEasTwkCIXQ2f6ONMX7KQpjqLePIubxQVu3aOEynMBvK05X1qFYiUI0RU
         v9rcRTVgainVYuynRkmKhY3ov3nyLL2IfmEwPi2AtFo1N0f6xgksRhd0MssAeBM+2h5g
         dWgTZlWy1w/Ivch+1oQwlM4L9xJ0isWy20GAd4Obix2oJYV7+hFLWEmwXt8QmCsEXk6R
         1qTQpsw0riQX4INDPesl0f/TCGbkIyOJOQeAQdiCvAHOYf8Ye6JwXr9Bbslx4aCjFvJQ
         gr4VoJ0u67ocoY0ff19JhiOa2CyGM3/TjAp7WgGoUolxln7f/7gpxBS0WbzliEDyJE2o
         lt9Q==
X-Gm-Message-State: AOAM533nmugpxJ36rUcRwtzfTdh6coarKUjTtRoEVSzw7TNrvF+FwH59
        VE0i9lOUGxHZTSXBnoUTcXo=
X-Google-Smtp-Source: ABdhPJxTGqiZKBqkmGlMSfom4YkaXFM51tEhL/9RHD6+E1guQ1rZxn/b3dktYIxUvSglvjVi2BDdlw==
X-Received: by 2002:a2e:b5a6:: with SMTP id f6mr641357ljn.198.1625251899125;
        Fri, 02 Jul 2021 11:51:39 -0700 (PDT)
Received: from [192.168.0.91] ([188.242.181.97])
        by smtp.googlemail.com with ESMTPSA id x10sm344049lfu.263.2021.07.02.11.51.38
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Fri, 02 Jul 2021 11:51:38 -0700 (PDT)
Message-ID: <60DF62DA.6030508@gmail.com>
Date:   Fri, 02 Jul 2021 22:02:50 +0300
From:   Nikolai Zhubr <zhubr.2@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To:     Arnd Bergmann <arnd@kernel.org>
CC:     "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Realtek 8139 problem on 486.
References: <60B24AC2.9050505@gmail.com> <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com> <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com> <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com> <60B65BBB.2040507@gmail.com> <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com> <alpine.DEB.2.21.2106032014320.2979@angie.orcam.me.uk> <CAK8P3a0oLiBD+zjmBxsrHxdMeYSeNhg6fhC+VPV8TAf9wbauSg@mail.gmail.com> <877dipgyrb.ffs@nanos.tec.linutronix.de> <alpine.DEB.2.21.2106200749300.61140@angie.orcam.me.uk> <CAK8P3a0Z56XvLHJHjvsX3F76ZF0n-VXwPoWbvfQdTgfEBfOneg@mail.gmail.com> <60D1DAC1.9060200@gmail.com> <CAK8P3a1XaTUgxM3YBa=iHGrLX_Wn66NhTTEXtV=vaNre7K3GOA@mail.gmail.com> <60D22F1D.1000205@gmail.com> <CAK8P3a3Jk+zNnQ5r9gb60deqCmJT+S07VvL3SipKRYXdxM2kPQ@mail.gmail.com> <60D361FF.70905@gmail.com> <alpine.DEB.2.21.2106240044080.37803@angie.orcam.me.uk> <CAK8P3a0u+usoPon7aNOAB_g+Jzkhbz9Q7-vyYci1ReHB6c-JMQ@mail.gmail.com>
In-Reply-To: <CAK8P3a0u+usoPon7aNOAB_g+Jzkhbz9Q7-vyYci1ReHB6c-JMQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

24.06.2021 11:28, Arnd Bergmann:
> Right, I forgot you saw that one WARN_ON trigger. If you enable KALLSYMS
> and BUGVERBOSE, it should become obvious what that one is about.

Here is new log with a better backtrace:

https://pastebin.com/DP3dSE4w

The respective diff against regular 8139too.c is here:

https://pastebin.com/v8kA7ZmX

(Basically the same as you proposed initially, just slight difference 
might be as a remainder of my various previous testing)


Thank you,

Regards,
Nikolai
