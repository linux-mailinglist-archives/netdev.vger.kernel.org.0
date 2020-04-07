Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 362D91A148A
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 20:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbgDGSjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 14:39:16 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45956 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbgDGSjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 14:39:16 -0400
Received: by mail-lj1-f193.google.com with SMTP id t17so4845760ljc.12
        for <netdev@vger.kernel.org>; Tue, 07 Apr 2020 11:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YTOMqzmqJZ7tcU1cgqIhCtHjF6AAr4kLgyB3spNq9dY=;
        b=R3M7TuTqwbkZfw3MwAcf0K0cGJwJKEfxA2AavRzCYf0Sar3jH2TBM/hkdAIJRyfjJa
         pPV76pPDODDAFCfUWhb5b7KYIzcNEJTQIjB8R8ogGVkpLKFsmg+EzwrorYSE20LouXIX
         Uo5qkcMm0qhjrkPAfjGOiT0xD6uPI9O3g9rac=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YTOMqzmqJZ7tcU1cgqIhCtHjF6AAr4kLgyB3spNq9dY=;
        b=MI1sakorUHLA54tRJi0gCdLkHHMbhSsSA7uC0iz2lcgpBE1ciVQgRMBDLp4HFe/N1u
         /dYLCjq0iLAz2KpFDf42o8hMdx6P1bMjzKAND+heru1oYOgoyuiDoBYAUPPbFIPZEWuc
         RAa0Jm1jytOOJDyaC5mYLExcRInyB9YllP501kc/U9fIub1/F7Cx/3zvz3DtO1gmTYLs
         rQK2FpAlEh9ECTk9SR1+ZGXFbyijGMd9R3wCW15i1hwzici5J75F7EoAaFnnqIuang+u
         SZKitr1wQBYdCvGeDI2CkmuKd7HZE0Av+P0pOhDOpaktl1tl8zQO0Ou87YInB2nvWkxC
         jF+g==
X-Gm-Message-State: AGi0PuaARo8XHOMyOzPVPmD6wyN27RSsmw48KeQU6L0hYD7gFcLaX/bH
        SxwqLOau4zbKK4SRl2+iHmaavedyB9g=
X-Google-Smtp-Source: APiQypLl19W7mSK+HR3wjDy7mqjYWv7DXby1kia4az4X4+6wmhnw1a4LCBPERmYTwmL7jI/VdWADrQ==
X-Received: by 2002:a2e:b8c1:: with SMTP id s1mr2686976ljp.0.1586284752881;
        Tue, 07 Apr 2020 11:39:12 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id l132sm5060035lfd.95.2020.04.07.11.39.11
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 11:39:11 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id r7so4842489ljg.13
        for <netdev@vger.kernel.org>; Tue, 07 Apr 2020 11:39:11 -0700 (PDT)
X-Received: by 2002:a05:651c:50e:: with SMTP id o14mr2484705ljp.241.1586284750968;
 Tue, 07 Apr 2020 11:39:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200407174306.145032-1-briannorris@chromium.org> <20200407112427.403c73c9@hermes.lan>
In-Reply-To: <20200407112427.403c73c9@hermes.lan>
From:   Brian Norris <briannorris@chromium.org>
Date:   Tue, 7 Apr 2020 11:38:59 -0700
X-Gmail-Original-Message-ID: <CA+ASDXM540KLNXjRh0swrp=ATGfxWS-VUcZcqYT1Udm4QLPaVQ@mail.gmail.com>
Message-ID: <CA+ASDXM540KLNXjRh0swrp=ATGfxWS-VUcZcqYT1Udm4QLPaVQ@mail.gmail.com>
Subject: Re: [PATCH iproute2 1/2] man: add ip-netns(8) as generation target
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 7, 2020 at 11:24 AM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Tue,  7 Apr 2020 10:43:05 -0700
> Brian Norris <briannorris@chromium.org> wrote:
>
> > Prepare for adding new variable substitutions. Unify the sed rules while
> > we're at it, since there's no need to write this out 4 times.
> >
> > Signed-off-by: Brian Norris <briannorris@chromium.org>
>
> Why is this needed?

For patch 1: it's only for the sake of patch 2.
If you're implying that patch 2 doesn't describe the "why?" well
enough: I'll try again:

> man: replace $(NETNS_ETC_DIR) and $(NETNS_RUN_DIR) in ip-netns(8)
>
> These can be configured to different paths. Reflect that in the
> generated documentation.

This is needed because Chrom{ium,e} OS patches iproute2 to use /run
directly instead of /var/run [1]. We also build the man pages, so we'd
like the man-pages to match.

Incidentally, we were already manually patching this out (in both
source and man-page) before this upstream patch existed:
e2f5ceccdab5 Allow to configure /var/run/netns directory
It would be nice if we could just use the Makefile variable instead.

I can resubmit if you'd like a more verbose description in the patch
submission itself.

Brian

[1] Longer answer: because the latter traverses a symlink on a
read/write partition, whereas the former is a direct-mounted tmpfs. We
can provide better guarantees for programs that avoid symlinks like
this.
