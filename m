Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9CBE1F135D
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 09:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgFHHOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 03:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728022AbgFHHOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 03:14:51 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4D4C08C5C3;
        Mon,  8 Jun 2020 00:14:51 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id 9so15691867ilg.12;
        Mon, 08 Jun 2020 00:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=mS23H/U8VmavZYZwF9NgDU0XMmt3bFlrFjmm1dz0ikk=;
        b=s+bE+NGIKQDHynRi3/1JqxAoWa0Eq5IQIXAH9Dbth9rUsXI8LIyDHvGlXRSCOi89S4
         p/GeWHa693w8HNHirswN5L/5FiHpfSd9y+cAKuLamHXYdSka64lQPvZ7YLkTWHfVKU7K
         ekR40Z8UTzKqYWuqgMPKqj23WQo4hNI+wpehnsaeqqxkVLKSf0lBQjpiUrnAE7Wes+yp
         t9A9ZMnZ+9ge/c2zpy6NKP+gbqvnrB1YqvnhOw/MJgSiap43aN4X1+XJfJncSI2tKckn
         4v7rv9jaYOb2PhgBnKT8U0aQb4HEv4F7smT5vLq8gb9eVDOy22x4e99puRlyOuIQbWMv
         jF+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=mS23H/U8VmavZYZwF9NgDU0XMmt3bFlrFjmm1dz0ikk=;
        b=jD/mi2d+VsvC3/5tHl1Q+as4tBTAEHo0+oIp41bR70jJSOheN/ZWcKP6LO+FDLdewb
         wYCMiTztvB8sTNk27KW0AWaBPgUaRPwdkbpT9OxGt5rT1FpT+6gE9ZIjnrmw6dVhlMFx
         PV74Qn2/sfMpRMTZZcx2KqFezZFx5IEgYbtX2MtOAqEAh183v5OsfFgRe2OXXF4lDQwN
         icXuJBEkCz3cDT/U9+PwRZJrGhTZC/efMegDDd7pF5lFtdAYSpy3ksmEVCNdW5O1RgDB
         lYBguTVHyovWntsxlb07rlYH/FA018WIpmxcJd1F0F8RKhMrzQpkcXzDJJiShpgRd1mh
         mHkw==
X-Gm-Message-State: AOAM532DDVt3IlI69MOpGA53u8+19y/9M1vsci9JT93M7jqiaUieGX+J
        XpcP6pZp1aUIGuGdIFF8OGzfa5BojBn6PPOr/FkcNU0cVl0=
X-Google-Smtp-Source: ABdhPJwkbl2E1UnvVJ+49C+SXMpTKy91Y2xA+WgX8yoeSH34+AjiDOI5pxgP46syNJB77a12QYk0DF4jxXTdn5mEONk=
X-Received: by 2002:a92:3646:: with SMTP id d6mr21288775ilf.255.1591600490350;
 Mon, 08 Jun 2020 00:14:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wj0QUaYcLHKG=_fw65NqhGbqvnU958SkHak9mg9qNwR+A@mail.gmail.com>
 <5DD82C75-5868-4F2D-B90F-F6205CA85C66@sipsolutions.net>
In-Reply-To: <5DD82C75-5868-4F2D-B90F-F6205CA85C66@sipsolutions.net>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Mon, 8 Jun 2020 09:14:39 +0200
Message-ID: <CA+icZUVLb9Kq88yfB3kZCjDczmSaUE1vvRygPjGH6Ps+0PhDMQ@mail.gmail.com>
Subject: Re: Hang on wireless removal..
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 6, 2020 at 9:56 AM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> Hi, sorry for the top post, on my phone.
>
> Yes, your analysis is spot on I think. I've got a fix for this in my jberg/mac80211 tree, there's a deadlock with a work struct and the rtnl.
>
> Sorry about that. My testing should've caught it, but that exact scenario didn't happen, and lockdep for disabled due to some unrelated issues at early boot,so this didn't show up... (I also sent fixes for the other issue in user mode Linux)
>

Is that the fix you are talking about?

commit 79ea1e12c0b8540100e89b32afb9f0e6503fad35
"cfg80211: fix management registrations deadlock"

- Sedat -

P.S.: I fixed up the top-post issue :-).

[1] https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git/commit/?id=79ea1e12c0b8540100e89b32afb9f0e6503fad35
