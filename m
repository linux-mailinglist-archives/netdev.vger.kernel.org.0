Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A43612A1021
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 22:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbgJ3V11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 17:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727813AbgJ3V10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 17:27:26 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FC2C0613CF;
        Fri, 30 Oct 2020 14:27:26 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id i26so6270967pgl.5;
        Fri, 30 Oct 2020 14:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7BklsUJ0e8Lb4kq/5M0Mx9yycyEhrpl8m+tC41oBXx0=;
        b=BQKbqaZMUdfviODzkUt96orAHZ5vwNHGxs4UG256QBn9a1dA452JTxy/4NQTujoO8Y
         QAuzBYpxgcmBjH9C/EsJBD4zsfh6bu97JPlwgZ1wU/QYTDxAcnKT9kDeXpTShqPFk686
         vzgSPJY5YzAp+eLzZE26hO1Ow6upKULSFF1dWM1UQw69gpED+zRLQxunlYIEuGowGGzP
         GE9U2oly2vpkJz3wUDsXJQZ+eJfZpIjuYbOOkHSaJhdRBmJDEYdqCyYNhHxmMd/EMbNQ
         BEW997IqzfJNf8l4gI11ZWaGqP70heeL9FTSfwXblybCCiNOPVKOF+P7E8LXbe+hfNk/
         XCJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7BklsUJ0e8Lb4kq/5M0Mx9yycyEhrpl8m+tC41oBXx0=;
        b=hDbdAZKahgYGVyg/pkqRzp61HWPQvDdps6GjPYeFbz8Rfji98UfReeP25DgsGdRPYn
         rxShwDIdVGScZqbvBtUOlUImIRA2W4UeUzdqeIu7i6qPxhyWlR4qeS/mfgzYrE+gId6W
         wek3sWFboZyQGMZXUgmjAVKH+sZoYdEsB+4BhNrA7bbayzKy6HjMAk3vVh0c4OTYWL2b
         5DmQP4+CG87FI7gUaxIVBs8l7X9ZoeA09w32+dSeK3+WD0GRIa+pBYyYK63cFQa0wzsk
         uU4D6ri7blV95/5vBEbsJINmUpw68E/FJm5/0InaEsFBk4g7AxOJ9TgnkgwjhEhvhTxu
         mC5g==
X-Gm-Message-State: AOAM531qM6qqzAnDbiVmbAKP05CuNyZ2NMExFDDezHD+tOMWpAgPWFUd
        zP7sIN1wLAzEricQnD+4JwC9kNlW0/ypeCMexIs=
X-Google-Smtp-Source: ABdhPJwc/l0pzbHhU4+oDo4SchzLvpsesQbU9BzllteMGS35VuZDWZtmo7m2GGXQ1ViL7Nj5zASuP2uBuLpsZJm3k4c=
X-Received: by 2002:a17:90a:aa91:: with SMTP id l17mr5006130pjq.198.1604093246199;
 Fri, 30 Oct 2020 14:27:26 -0700 (PDT)
MIME-Version: 1.0
References: <20201030022839.438135-1-xie.he.0141@gmail.com>
 <20201030022839.438135-2-xie.he.0141@gmail.com> <CA+FuTSdeP7n1eQU2L2qSCEdJVc=Ezs+PvCof+YJfDjiEFZeH_w@mail.gmail.com>
 <CAJht_EMdbGQdXhYJ7xa_R-j-73fbsEjSUeavov40W52aGvQ21g@mail.gmail.com> <CA+FuTSfD27KDkbnO=PeS0Dhn7s3+0U1N+e_Xrn7G9m0qT2Lcrg@mail.gmail.com>
In-Reply-To: <CA+FuTSfD27KDkbnO=PeS0Dhn7s3+0U1N+e_Xrn7G9m0qT2Lcrg@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Fri, 30 Oct 2020 14:27:16 -0700
Message-ID: <CAJht_EP0F3FuiUJSpYYjEXy7h2qA=18P7JiTWV246y6FyzMAag@mail.gmail.com>
Subject: Re: [PATCH net-next v4 1/5] net: hdlc_fr: Simpify fr_rx by using
 "goto rx_drop" to drop frames
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 2:12 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> Jakub recently made stats behavior less ambiguous, in commit
> 0db0c34cfbc9 ("net: tighten the definition of interface statistics").
>
> That said, it's not entirely clear whether rx_dropped would be allowed
> to include rx_errors.
>
> My hunch is that it shouldn't. A quick scan of devices did quickly
> show at least one example where it does: macvlan. But I expect that to
> be an outlier.

OK. Thanks for the information.

> Please do always consider backward compatibility. In this case, I
> don't think that the behavioral change is needed for the core of the
> patch (changing control flow).

OK. I'll drop the change about stats.rx_dropped. Thanks.
