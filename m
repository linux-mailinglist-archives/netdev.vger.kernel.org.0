Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A2630B8BD
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 08:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbhBBHhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 02:37:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39200 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbhBBHhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 02:37:04 -0500
Received: from mail-lj1-f197.google.com ([209.85.208.197])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1l6qEX-0007nU-TI
        for netdev@vger.kernel.org; Tue, 02 Feb 2021 07:36:22 +0000
Received: by mail-lj1-f197.google.com with SMTP id r20so10846895ljg.21
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 23:36:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LSoMdUbpzG6cQwzLgZZTiGXvRVf2gEXyL2WC99OtW+s=;
        b=swp152svtHgqyWGwr9OKBWjK/8PXHZoSgEtgnTA5isbKw7UXWwRxe+DOwlekQWdrcR
         iydPDpmEfHLjoQVplJkwrlK1hrG0NYOSzb7fx5e9gMVSrvn5ohasvqtH+pJVsMvCgK1N
         v8ujpHE7WuTzJrnERBMRmFUEdvBBeycHYYdOrMA4DYWIJqslV0H2JSaw661hZd6Ce9Nb
         PlH7rLYXesTVMXxj5n28qAePWGf6R8biwpL6WxhflE5ei6mFEc6O4vSFxc/pAVAPZ78q
         3SOnjKaXxuVLM4vcDp/+57riNPNI+SE8HMUq277oQar7/Wb76rBX7m9u+4jQWBZr2ifv
         G9Yw==
X-Gm-Message-State: AOAM533jvj6yEwOzTZNrM7BPCL+krchbZLEHLwyOixvOCM6ga/l6nAAm
        IOonyDEFINqYpUocM9+2UXNy8efY8glschp/kpipgpTAIERSsMxNQRwYGRWvZ1A7O/D5eYZ+R9u
        QYcKaN5zoCp94S49viFpBZw+cq/OY77cJ9ceNj2BaUe6PXXMFnA==
X-Received: by 2002:a05:6512:b1b:: with SMTP id w27mr10509602lfu.10.1612251381361;
        Mon, 01 Feb 2021 23:36:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx5dv1Lrlfrr7Ynb6iQgLdZKKxLKhBfVWGXB8B6/fyiUueDPcltK2OaDOeatPA3x15vvGz/Vb5SF9Yn6KsvJL4=
X-Received: by 2002:a05:6512:b1b:: with SMTP id w27mr10509591lfu.10.1612251381100;
 Mon, 01 Feb 2021 23:36:21 -0800 (PST)
MIME-Version: 1.0
References: <20200805084559.30092-1-kai.heng.feng@canonical.com>
 <c0c336d806584361992d4b52665fbb82@realtek.com> <9330BBA5-158B-49F1-8B7C-C2733F358AC1@canonical.com>
 <CAAd53p6SA5gG8V27eD1Kh1ik932Kt8KzmYjLy33pOkw=QPKgpA@mail.gmail.com>
 <871rdz7zjf.fsf@codeaurora.org> <e4f2fe2b-52a2-7b39-6758-decf22d82eb6@lwfinger.net>
In-Reply-To: <e4f2fe2b-52a2-7b39-6758-decf22d82eb6@lwfinger.net>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Tue, 2 Feb 2021 15:36:09 +0800
Message-ID: <CAAd53p5p=Bz-VKLxbajhZ2VeHs1Dczcqc1hgPZtNsMb-Fy6J3w@mail.gmail.com>
Subject: Re: [PATCH] rtw88: 8821c: Add RFE 2 support
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Tony Chuang <yhchuang@realtek.com>,
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

On Tue, Feb 2, 2021 at 3:02 PM Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
> On 2/2/21 12:29 AM, Kalle Valo wrote:
> > Kai-Heng Feng <kai.heng.feng@canonical.com> writes:
> >
> >> On Wed, Aug 5, 2020 at 7:24 PM Kai-Heng Feng
> >> <kai.heng.feng@canonical.com> wrote:
> >>>
> >>> Hi Tony,
> >>>
> >>>> On Aug 5, 2020, at 19:18, Tony Chuang <yhchuang@realtek.com> wrote:
> >>>>
> >>>>> 8821CE with RFE 2 isn't supported:
> >>>>> [   12.404834] rtw_8821ce 0000:02:00.0: rfe 2 isn't supported
> >>>>> [   12.404937] rtw_8821ce 0000:02:00.0: failed to setup chip efuse info
> >>>>> [   12.404939] rtw_8821ce 0000:02:00.0: failed to setup chip information
> >>>>>
> >>>>
> >>>> NACK
> >>>>
> >>>> The RFE type 2 should be working with some additional fixes.
> >>>> Did you tested connecting to AP with BT paired?
> >>>
> >>> No, I only tested WiFi.
> >>>
> >>>> The antenna configuration is different with RFE type 0.
> >>>> I will ask someone else to fix them.
> >>>> Then the RFE type 2 modules can be supported.
> >>>
> >>> Good to know that, I'll be patient and wait for a real fix.
> >>
> >> It's been quite some time, is support for RFE type 2 ready now?
> >
> > It looks like this patch should add it:
> >
> > https://patchwork.kernel.org/project/linux-wireless/patch/20210202055012.8296-4-pkshih@realtek.com/
> >
> New firmware (rtw8821c_fw.bin) is also needed. That is available at
> https://github.com/lwfinger/rtw88.git.

Thanks. RFE2 works with the new firmware.

Kai-Heng

>
> Larry
>
