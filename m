Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC638450B95
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 18:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237483AbhKORZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 12:25:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237832AbhKORYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 12:24:07 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CDEBC061220;
        Mon, 15 Nov 2021 09:16:05 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id i194so15764323yba.6;
        Mon, 15 Nov 2021 09:16:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mp3YXDLV3Lfsg1Y6ExDrGxZjyZli7UH88J1E2JBajHE=;
        b=nIqjap/u/3V6NuD++3m4ct0uA2Q6kPAsQClcbqAXuTRfL/m542nxMFqwpJSYRC0n6+
         dvh8pNSkpx4Q4TlkMqrWO2yQd6kPhSNLvf7nAN757kWEYqEawoYo6/FLbmklzZivFSlb
         9xPEAGBOFjUmbrkbJns2dsSx0exPBaAj/LsCSodqn0K5OeMMBG7W0wwaKSR32zmleHZp
         KFGnhE5mT059rH7I8ZPKyZEReXJmhjASFHkr7m85H+mdAEkvAfrnqr8Ux/KHxrxTWkVU
         MYdVWytJEQxNp9U1fmgVzHiCPZSnDbDzBcRCNae/KYMbZC4QfmmTBWNjZeC+wHKo/fv9
         Xkkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mp3YXDLV3Lfsg1Y6ExDrGxZjyZli7UH88J1E2JBajHE=;
        b=nc3Yqj5JRTXvHRnY0gJ+iIq1es+/MTyeXPvPRFzuEezbO2VMoxrG652pWQ/d5pL4lT
         CPabk0die2rhjppy+orzyH3pGd2Z2kTmbSV0GmUiqLzv2od4Qexs1C6Buu3KK7MJGxlv
         +gr57bZNTvFDEBoIWmRm705Wcm6wcbZSKq40IzR80DfFBSUlrbV1cvPa8m8oLBIxru3y
         01AXuZEUgdXZwrJT5lqhXLJbM6Hwogj6ATDT5mwhizYbrfJ2hb85xnqlxNiks1AJEzF9
         B5Fg35Asr5I9P/x/iQHb+bk9819NeZDX0PU7CATal4zMcJgnowpW0YcaQoQoU6YFbT/U
         voVg==
X-Gm-Message-State: AOAM531ko8NaIw/dyTHm5mAZBw0m/6pHqUbWNMDihcBstk8dUQJ5Hw5j
        2bulWN6PWGuQfeU8VFz/G1NkHlqTloFqxjxrT4E=
X-Google-Smtp-Source: ABdhPJxnobNo5D+0u+zzJhwVSmPqW4DU4OOX8PuFrh/oilqnqYqXGgZupVBn9Zveom3O8UZ7WFrHJ8FahpJ4Sh8KPqs=
X-Received: by 2002:a25:cc4c:: with SMTP id l73mr601999ybf.114.1636996564555;
 Mon, 15 Nov 2021 09:16:04 -0800 (PST)
MIME-Version: 1.0
References: <20211115162008.25916-1-daniel@iogearbox.net> <20211115091338.5e1d6316@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211115091338.5e1d6316@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 15 Nov 2021 09:15:53 -0800
Message-ID: <CAEf4BzaWfUDr1_CqLsCEbX1S9djgQp0236e+8ah3rYmDyg0CJQ@mail.gmail.com>
Subject: Re: pull-request: bpf-next 2021-11-15
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 9:13 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 15 Nov 2021 17:20:08 +0100 Daniel Borkmann wrote:
> >                 -c -MMD -o $@ $<
>
> >                 -c -MMD $< -o $@
>
> Out of curiosity did you switch the order on purpose?

Yes, I wanted all Makefile rules to have -o at the end. It makes
debugging Makefile verbose output much easier as it's more apparent
which file each rule invocation generates.
