Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9AB0490FDC
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 18:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241238AbiAQRsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 12:48:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237954AbiAQRsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 12:48:43 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644CBC061574;
        Mon, 17 Jan 2022 09:48:42 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id b13so69022334edn.0;
        Mon, 17 Jan 2022 09:48:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lOU3pr5yfa0z0mv7uHkVulXBdRCWTTF3cmfmVLsfcOc=;
        b=fzqGIJMUPblqrzxjAw33Ffqrwo8GQ0sbibYBH0a9FMdyoVec4BChUAw+C6tMHqxSHt
         WDjVDuQG8VPVYywCb4aGn3oC8ODugmgHmdihlvPamuSaZ0cokYFKVe+6NQ1/1Oeu/if4
         Zx2nJBW8N/Ld/jZuHCbeGOj3tpYVOoBAKyDU0mLYrRA3YfEVXx5RUZn4JU7Bp+XOSPdb
         W2L5raJUqAjo4HngBm7tBIH+onx5zJzagVys+WOAY73PQRgUOBRa0U8mAgAuW2Am2XDY
         PpMUDw16/kbpOnyc4AiIt8yowq0pmbtqjoRMMETXIIEdu1en/M2Et+ChCSz9drU0rwXG
         DNzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lOU3pr5yfa0z0mv7uHkVulXBdRCWTTF3cmfmVLsfcOc=;
        b=gD5/8u58yqfGIOyLHm5AxX1kvrRlTN0SJfSlKwyoo6rdWA0ZonGftKgciDJJGpwPK0
         7iBMmonzQSC+paufcBzJ8uCKSFBPee3QdN3ska3B+vfiOxqaZCrCVxdJ1UGxLW0yRjh7
         LHs5yr9bIGaa8ysHDCfXT/Fj9lPY5oJCf+8B//Ac9Om60ulTShq+7PvPQGxiqP0M6h1q
         fYKmGM+76z50LGukWJoH4L/YN6lNlgCzBm6h6vsK3V64V2PZG5UCyZDbeyoEaphx45ek
         t7CaqjdPPHrJVzinqqmeLJFHYWUBHdpZ0tktMyxEa+iQxf3ksPbK/NS1ryOC3Vg+cDAT
         KoBg==
X-Gm-Message-State: AOAM5330XsOj2J7ufvzGSfxJQhFFS2EH+u70vnLHNblfcaer/porNOFU
        2PHDevgMQBDD2NDvPv/WKHUxBTTzkV4UT5DiFAs=
X-Google-Smtp-Source: ABdhPJxgACcFgbsJOGLEl1dGwIFoAAsPkFHuLnCSx4EtJIuHxSphQJRCkiR0qUqGim1saDLm7gX7qE/y8trHqorq7mE=
X-Received: by 2002:a05:6402:35d3:: with SMTP id z19mr7002466edc.29.1642441720972;
 Mon, 17 Jan 2022 09:48:40 -0800 (PST)
MIME-Version: 1.0
References: <20220114234825.110502-1-martin.blumenstingl@googlemail.com>
 <20220114234825.110502-2-martin.blumenstingl@googlemail.com> <87k0eysgs9.fsf@kernel.org>
In-Reply-To: <87k0eysgs9.fsf@kernel.org>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Mon, 17 Jan 2022 18:48:30 +0100
Message-ID: <CAFBinCCnvO-CjjzSr0wkv6d-nin2Wa=GUbMMoUh02KD5aQWFoQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] rtw88: pci: Change type of rtw_hw_queue_mapping() and
 ac_to_hwq to enum
To:     Kalle Valo <kvalo@kernel.org>
Cc:     linux-wireless@vger.kernel.org, tony0620emma@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Pkshih <pkshih@realtek.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kalle,

On Mon, Jan 17, 2022 at 1:11 PM Kalle Valo <kvalo@kernel.org> wrote:
[...]
> > -static u8 ac_to_hwq[] = {
> > +static enum rtw_tx_queue_type ac_to_hwq[] = {
> >       [IEEE80211_AC_VO] = RTW_TX_QUEUE_VO,
> >       [IEEE80211_AC_VI] = RTW_TX_QUEUE_VI,
> >       [IEEE80211_AC_BE] = RTW_TX_QUEUE_BE,
>
> Shouldn't ac_to_hwq be static const?
Good point, thanks for this suggestion!
I will include that in v2 of this series (which I will send in a few
days so others can share their thoughts about these patches as well).


Best regards,
Martin
