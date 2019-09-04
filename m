Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B348A78EC
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 04:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbfIDCix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 22:38:53 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:39541 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727556AbfIDCix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 22:38:53 -0400
Received: by mail-oi1-f195.google.com with SMTP id w144so7650983oia.6
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 19:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qr8l030m/3BmP8EcsP561eQfhI/tMxRAFvT/xZLcZuU=;
        b=YWgQalXaOCXV0wmfeSjdPdCGpxfHipNdunoQ98FIfc0c0/UfrPYVgPpZDzZPTxb5jk
         zUkkr7ZdLnMHJk8GiTtl8bhzzD3zhx6z1i+vVTnalYllllg5L/rKFF5FT0tvwzVXA1NN
         kL3qTYyfX1dOm5pJoUCklDfdP2BhX+rtt5OPPlyt2rxqrmZrUgMh2tMu/kgWjRqLPw8x
         PmGzJ9xkcxNPOl0EqcTuTOa+70pjKA6krYpSW9K+/sCGoSKspcBLrsDrcizMB1wtx0sR
         ye0kXzubgEcfcgpBvGkl8m/SLFIos5Gnu02Pv2pCnij/0FqvO0/hI0pOcS5xJHnVG3he
         aWdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qr8l030m/3BmP8EcsP561eQfhI/tMxRAFvT/xZLcZuU=;
        b=cKrq4+Wc4gSodZe9STsi3ZDaCX+8beV+ctaggQ6w4wqYp+Z8tFiHsA8+32Tz7Uysa1
         K0oNHlFUV5bAUQN7e6soU0YSS8eYKx3E6TIRn5U7ufKKT65YIERmdyRTxRADgx/n+H6z
         cQK4afTNrM27wZe1MbFGfw4wZlSbSEJH/84GkpVJUF4xsdzIVmmBYX8w+0JiH1NNALNH
         kfVWbwwqjQiYxQZZfBQuO58z9h/2B34jRC1pZfmcaxPEsUBymwyfDNDI4BH4wLf0aem5
         jQyeIKpxRCjU6AYiafFm2KI1v3t+mpvqdzi8vaSsjepX1m6CcoLgQBa5a3thK915+DiI
         w+PA==
X-Gm-Message-State: APjAAAUHfj6eGahuFdn3xeAhcFgC0q+Gz9XaNPAREAbdhdarEmHMJMpj
        mLyl8+uUBUzQPJKWvXZWRM3Mm1K0XpwH7KiEPeEaew==
X-Google-Smtp-Source: APXvYqzHXn2jzsxC3dRsC9tJT9imYI/Ar0PlH780cjytKiIYVtdOEzJsc2OifiS4sbg19VoLLOcydDjBA98jiAJ3rRE=
X-Received: by 2002:aca:42c3:: with SMTP id p186mr1843411oia.33.1567564732459;
 Tue, 03 Sep 2019 19:38:52 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1567492316.git.baolin.wang@linaro.org> <0e71732006c11f119826b3be9c1a9ccd102742d8.1567492316.git.baolin.wang@linaro.org>
 <20190903145206.GB3499@localhost.localdomain> <20190903183331.GB26562@kroah.com>
In-Reply-To: <20190903183331.GB26562@kroah.com>
From:   Baolin Wang <baolin.wang@linaro.org>
Date:   Wed, 4 Sep 2019 10:38:40 +0800
Message-ID: <CAMz4kuJMfAR6w+SpiTA-EWMB3MQ_wiuW+_-DfL-8zdrCagmS0Q@mail.gmail.com>
Subject: Re: [BACKPORT 4.14.y 4/8] net: sctp: fix warning "NULL check before
 some freeing functions is not needed"
To:     Greg KH <greg@kroah.com>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "# 3.4.x" <stable@vger.kernel.org>, vyasevich@gmail.com,
        Neil Horman <nhorman@tuxdriver.com>,
        David Miller <davem@davemloft.net>, hariprasad.kelam@gmail.com,
        linux-sctp@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Orson Zhai <orsonzhai@gmail.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Sep 2019 at 02:33, Greg KH <greg@kroah.com> wrote:
>
> On Tue, Sep 03, 2019 at 11:52:06AM -0300, Marcelo Ricardo Leitner wrote:
> > On Tue, Sep 03, 2019 at 02:58:16PM +0800, Baolin Wang wrote:
> > > From: Hariprasad Kelam <hariprasad.kelam@gmail.com>
> > >
> > > This patch removes NULL checks before calling kfree.
> > >
> > > fixes below issues reported by coccicheck
> > > net/sctp/sm_make_chunk.c:2586:3-8: WARNING: NULL check before some
> > > freeing functions is not needed.
> > > net/sctp/sm_make_chunk.c:2652:3-8: WARNING: NULL check before some
> > > freeing functions is not needed.
> > > net/sctp/sm_make_chunk.c:2667:3-8: WARNING: NULL check before some
> > > freeing functions is not needed.
> > > net/sctp/sm_make_chunk.c:2684:3-8: WARNING: NULL check before some
> > > freeing functions is not needed.
> >
> > Hi. This doesn't seem the kind of patch that should be backported to
> > such old/stable releases. After all, it's just a cleanup.
>
> I agree, this does not seem necessary _unless_ it is needed for a later
> real fix.

It can remove warnings from our product kernel since this patch
(c4964bfaf433 sctp: Free cookie before we memdup a new one) was merged
into stable, we still need backport it to our product kernel manually.

But if you still think this is unnecessary, please ignore this patch.
Thanks for your comments.

-- 
Baolin Wang
Best Regards
