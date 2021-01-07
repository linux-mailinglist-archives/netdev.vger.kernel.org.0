Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B7C2ECA94
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 07:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbhAGGji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 01:39:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60107 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbhAGGjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 01:39:37 -0500
Received: from mail-oo1-f69.google.com ([209.85.161.69])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1kxOwh-0000us-7q
        for netdev@vger.kernel.org; Thu, 07 Jan 2021 06:38:55 +0000
Received: by mail-oo1-f69.google.com with SMTP id m1so3594347ooj.23
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 22:38:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gc+fC2uzrPTIv/OjMkzLquFL5H8Wh/2Rm6W4yaQ752c=;
        b=tWgNPXaYz75wSFG/2N3YvsbAghy6pWDxXQvBNFYIJ93kVhMgOy4UaUGX86sGxkhnzY
         fZjXW9XDKh0KRtuDhCw/HG5hXZJiZFOD89SVAS345uzdzjkIUN0EQCcaA026LiCO8Ifd
         0qfDwqv9GBE33KwSy1fSfsXnr5vYGYi5AeTEIYvtRAk3SQ/gwCPrtiCG5gIcN0rov18x
         2a2DSPi6P6LEVDZEMGYB7zXiaFiocGvdp348mR2+4xDBKAr63+5IL4XE/JRiuywN1qpg
         MUKGKLEXq/J/4ct7BdJZSuUIeyXcDZ7UBBuH+DqCOthrCnqipPNe414KVYL4DySq040x
         aXxQ==
X-Gm-Message-State: AOAM531gTrjbJzMc5LZ5BcSSgF6rt1BfkQhZrWZdQNNkrAumQJmL1ME8
        kVkKRIhPXiOwkMUeLS1JOwX2EVhde9FEkLmwbtjnv0s8y3AsB+wwV6dOinOla4Hy6XDT6vA6iyp
        yGwWw4hNFIwWg+SeT3fZzsBKHlW7EbjhA31PrNvWIGoM+vQwuuA==
X-Received: by 2002:a9d:4816:: with SMTP id c22mr5539017otf.358.1610001534167;
        Wed, 06 Jan 2021 22:38:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxIfDhiYPhS3S5PaeEdW+dFoXwmfFeAUrAJeItJZ9WP8HUWgmpU0R8GvY6EhnjGOtDrahFqtDToLumrSeZxMyQ=
X-Received: by 2002:a9d:4816:: with SMTP id c22mr5539001otf.358.1610001533893;
 Wed, 06 Jan 2021 22:38:53 -0800 (PST)
MIME-Version: 1.0
References: <20200805084559.30092-1-kai.heng.feng@canonical.com>
 <c0c336d806584361992d4b52665fbb82@realtek.com> <9330BBA5-158B-49F1-8B7C-C2733F358AC1@canonical.com>
In-Reply-To: <9330BBA5-158B-49F1-8B7C-C2733F358AC1@canonical.com>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Thu, 7 Jan 2021 14:38:42 +0800
Message-ID: <CAAd53p6SA5gG8V27eD1Kh1ik932Kt8KzmYjLy33pOkw=QPKgpA@mail.gmail.com>
Subject: Re: [PATCH] rtw88: 8821c: Add RFE 2 support
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:REALTEK WIRELESS DRIVER (rtw88)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andy Huang <tehuang@realtek.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 5, 2020 at 7:24 PM Kai-Heng Feng
<kai.heng.feng@canonical.com> wrote:
>
> Hi Tony,
>
> > On Aug 5, 2020, at 19:18, Tony Chuang <yhchuang@realtek.com> wrote:
> >
> >> 8821CE with RFE 2 isn't supported:
> >> [   12.404834] rtw_8821ce 0000:02:00.0: rfe 2 isn't supported
> >> [   12.404937] rtw_8821ce 0000:02:00.0: failed to setup chip efuse info
> >> [   12.404939] rtw_8821ce 0000:02:00.0: failed to setup chip information
> >>
> >
> > NACK
> >
> > The RFE type 2 should be working with some additional fixes.
> > Did you tested connecting to AP with BT paired?
>
> No, I only tested WiFi.
>
> > The antenna configuration is different with RFE type 0.
> > I will ask someone else to fix them.
> > Then the RFE type 2 modules can be supported.
>
> Good to know that, I'll be patient and wait for a real fix.

It's been quite some time, is support for RFE type 2 ready now?

Kai-Heng

>
> Kai-Heng
>
> >
> > Yen-Hsuan
>
