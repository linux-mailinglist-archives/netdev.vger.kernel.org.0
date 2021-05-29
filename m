Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C37394E50
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 23:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbhE2Vpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 17:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbhE2Vpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 May 2021 17:45:54 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB53C061574
        for <netdev@vger.kernel.org>; Sat, 29 May 2021 14:44:16 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id b5so6529834ilc.12
        for <netdev@vger.kernel.org>; Sat, 29 May 2021 14:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=HV5pEFFz4bP18lKCHb8T+WTboQIt7vstl9QociZ0FuY=;
        b=M7rNnqYQ/eHomssmqWBiEm809LQXsGY/myfRxwSpG+nMj789+ixfqHg8aBa5B6Yowg
         y9iG2vrVKaT1b5Vxekxex0B9wDo9DfJL1c67+gMEcjysFzJ2usIzVmaGx57JynxcEOiT
         NedmswNk3ZJd7NHrjJ4oO/3MjA2+pu/aTgtTKzNxPGmH5WVLyFEu3oXtQoidKi88JuJm
         /qpVqK04Rzqo9PMSFcsbpDpVg2imivqQ7/7hEijuARRnHfmHUi0FyL/d8Zl4WSn7rtwv
         et14mUpt/lbD1vpLusEKfEwBVaYywH9U6UhqEHl6aI0Ifk2680DjS9hBuurkQcf1UUhF
         luAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=HV5pEFFz4bP18lKCHb8T+WTboQIt7vstl9QociZ0FuY=;
        b=jzOZ0ZLkfGbvX0RoOXGBJbqMMuxvREqm5bAhE88K6peDnHQmDXztIi1GBB3kvNc3I5
         7Ou1TX8O1zBRM6FoZ576A4HZR6nSG0B4KsJqPwRKQDIA7I6HWSJJTLtnoGQYOSoApPZ9
         x74CAJR+G60WPwIinDbzQiycMFj1WxJRhTeUxT0/pJr9b9AnQ7/YSmTqGZK2D9z22xGu
         fEo27kT4WiprNAfq+DIvodDtUbDLm02qCgmhXBTXUEVU3OKO9YataL2RafhhhjhkHs3M
         qw2/K9htUGteE4y3AI6J3TTji08NpLe07Wy0prnbuygjs+36BdAXVAVPWIflprMlDeUa
         QdyQ==
X-Gm-Message-State: AOAM5337D1lZDTmEaHI/3TmRbbTOKh40XYMmm8Sl9hoD0ziArjQyMvRx
        5XsWh7qSp1txKTKNLT28WCuwph1BLhk3mc6oaFXjhdY=
X-Google-Smtp-Source: ABdhPJzSurSl8pR2cc4iXssGF4/5EjKwX88zZmV1g2KrKZdLmouZf1qzIyOJHPPUblDd8WAEj7qiVSwzk0hldnV/e/0=
X-Received: by 2002:a92:c682:: with SMTP id o2mr6105692ilg.186.1622324655986;
 Sat, 29 May 2021 14:44:15 -0700 (PDT)
MIME-Version: 1.0
References: <60B24AC2.9050505@gmail.com> <ca333156-f839-9850-6e3d-696d7b725b09@gmail.com>
In-Reply-To: <ca333156-f839-9850-6e3d-696d7b725b09@gmail.com>
Reply-To: whiteheadm@acm.org
From:   tedheadster <tedheadster@gmail.com>
Date:   Sat, 29 May 2021 17:44:05 -0400
Message-ID: <CAP8WD_bKiGLczUfRVOWY3y4TT80yhRCPmLkN7pDMhkJ5m=2Pew@mail.gmail.com>
Subject: Re: Realtek 8139 problem on 486.
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Nikolai Zhubr <zhubr.2@gmail.com>, netdev <netdev@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I'm willing to do some debugging but unfortunately I'm not anywhere familiar with this driver and network controllers in general, therefore I'm asking for some hints/advice first.
> >
> This driver hasn't seen functional changes for ages. Any previous kernel
> version that works fine so that you could bisect? It will be hard to
> find any developer who has test hw, especially as your issue seems to be
> system-dependent.
> Please provide a full dmesg log, maybe it provides a hint.

I have a few active 80486 test systems (the 5.12.7 kernel works fine
on 80486) that I might be able to help test with too.

- Matthew
