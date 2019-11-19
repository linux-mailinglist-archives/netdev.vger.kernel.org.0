Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C908C101A57
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 08:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbfKSHcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 02:32:33 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43709 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbfKSHcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 02:32:32 -0500
Received: by mail-wr1-f67.google.com with SMTP id n1so22477292wra.10
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 23:32:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=avXiLdIt1HoTBIi04ENDwcFumqGokJRcjLeGEM0NQdw=;
        b=jD9gfUcorgiUKWzOPQ0fd99BboAeuQS/VxEw2Iw41dWUARFw025nWE41mCjcO4JEaq
         fyqVOS3s0kUcEXJDrENAKfX/WR58YovGHP/TwAw4nnISgu0oRpjcsZuQ4KN8AZ19BI/x
         A3+FZS4uQJD1MnKpWNEUq3NqPyqnP58zJfhCRr9/WeKMyT3AVfJ1ovSGYOZftZ3YtP1z
         4ldgLNGzP1Elk43QMwnhRjcB1nKvDABFoBurY6uqqbVeMmNKM0B/JjxZMGPRoVuhRNZN
         DC6EZdyCWSLQWzySw1YU68hYhJYbkbvMS/1racjhv0Q/iN6Bb5Vre7zTxWT0e/VcHeYu
         wxog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=avXiLdIt1HoTBIi04ENDwcFumqGokJRcjLeGEM0NQdw=;
        b=SCdWUwNjuh3lJy2sngJX0Iz8wjPgz+e6DyBRwxfsXjpXzrAquq0XYwq1Ayj8hDiMQ7
         wi5lt1DlEBKG+Scx/hG46hYP4aCzAR7smyupgGN2AtoPS/ib8OddMXsWYwtEIgXqEgLI
         FFKVuHwRPUZ0Z9LcnY+UFNbXMjG2xIiohDPpOaXRhlui2LU8yuXVdK+wXf5erWOP+1j5
         /nzwJznpgC+7/ypzQT618qYT4EQkFYhtfFvzY7czRrdJzS993Jk8OgI0jN/teVwVJ5FJ
         mPNLnqxupsTivICEvYUcxvx55gdTCpp4W4xLWpEoBofJqctO8Zp1Y4fAYBHFL8taAp3A
         Ksuw==
X-Gm-Message-State: APjAAAWFd/d9K6rPKLc+25GihZtYFcte4St1zDmeUMIp4BRG1BUf9UA5
        Yq3zrR5a+3rs+nuymGu6DU8gf44gL8bm7mJCdO4=
X-Google-Smtp-Source: APXvYqy9YxRkKLu7gXsI2bA5Tc1TtmQZKSCwQP4/HnBlkWsYZu2MxBeCt1n2VpMeTox64p2n+UZuPwnnlL4zWKmrDN4=
X-Received: by 2002:adf:e8ce:: with SMTP id k14mr34252466wrn.393.1574148749417;
 Mon, 18 Nov 2019 23:32:29 -0800 (PST)
MIME-Version: 1.0
References: <1574007266-17123-1-git-send-email-sunil.kovvuri@gmail.com>
 <1574007266-17123-13-git-send-email-sunil.kovvuri@gmail.com> <20191117.103602.1078870124245169278.davem@davemloft.net>
In-Reply-To: <20191117.103602.1078870124245169278.davem@davemloft.net>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Tue, 19 Nov 2019 13:02:18 +0530
Message-ID: <CA+sq2CcSJXjUmTqgojDUb=GVuv34-mzVA9e5TwHN3rO=5Vk01Q@mail.gmail.com>
Subject: Re: [PATCH 12/15] octeontx2-af: Add TIM unit support.
To:     David Miller <davem@davemloft.net>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        Andrew Pinski <apinski@marvell.com>,
        Pavan Nikhilesh <pbhagavatula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 12:06 AM David Miller <davem@davemloft.net> wrote:
>
> From: sunil.kovvuri@gmail.com
> Date: Sun, 17 Nov 2019 21:44:23 +0530
>
> > +static u64 get_tenns_tsc(void)
> > +{
> > +     u64 tsc = 0;
> > +
> > +#if defined(CONFIG_ARM64)
> > +     asm volatile("mrs %0, cntvct_el0" : "=r" (tsc));
> > +#endif
> > +     return tsc;
> > +}
> > +
> > +static u64 get_tenns_clk(void)
> > +{
> > +     u64 tsc = 0;
> > +
> > +#if defined(CONFIG_ARM64)
> > +     asm volatile("mrs %0, cntfrq_el0" : "=r" (tsc));
> > +#endif
> > +     return tsc;
> > +}
>
> You cannot do this.
>
> Read the tick register of the cpu in a portable way, we have interfaces for
> this.  If not, create one.
>

Will fix and resubmit.

Thanks,
Sunil.
