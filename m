Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67572195373
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 09:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgC0I7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 04:59:53 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:45778 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbgC0I7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 04:59:52 -0400
Received: by mail-io1-f67.google.com with SMTP id a24so8421946iol.12;
        Fri, 27 Mar 2020 01:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RBOtf2DqJoWHFVM15/311A1LMfBrRb9C5cYTXtCJK3k=;
        b=PRIFirX+I9IYxmOs3GNEPzB9euwL8wYW3i0GcjxYU8+u4PD4ilgK3ftWPOKy4UvAIV
         Yxs4hGefrOo93jYx0KQANcct7qQypcWNzeGL3Hsnf40Yx/8Wq2Lk5Idei32o/kMgEZaG
         Z5yFTf2oq4bC1Otx6YSjGZ28ob4GAgVLMKXXKaUXDmKALCqtYt5DDGlyuoPDjcm+n6Fs
         SzGgtu8MUjwylEp3RbOZw72Sf+43rj5Z8jk88BeBgfLvB9RLqrDrjaF3ONGonVLMDT+X
         YU74x2tDHLVHRQ/301o9ha63vP1q6zgPLZ0ipwuGZrOKcSfr3WrFc3+1RjlXzIvftYDF
         R01w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RBOtf2DqJoWHFVM15/311A1LMfBrRb9C5cYTXtCJK3k=;
        b=R17+lsF8hrdTrM4dl3Sql7VOKwFON6Os7VrJRsdubbqd3tqs6A1P4mVvgyVVbapOMo
         f3jI3PVoux+BxLG6oyJDqhLf7TjREg0oLq6b6VTTLWJWNNUs8impVrLdI7lyYj1/8s5n
         YaVRxabSFOLX0ExBFWeCIzWslSwAiTTyCQdG89RAo4wvU3HXm+a+9qUWcn7e84CbXbON
         HIQTlNwPXjOyxj5VCixf10542l8Z0MwVT2NoNsE2rcG/GafSUn2RYZRqxP646QcD3iuM
         8pm72HtEK8LQq8T1mdMWSDpwAQNHanMZArCKRpC8u6ffoadZ9/oVKUP7Ef5rEUloieFQ
         M6gA==
X-Gm-Message-State: ANhLgQ189nXMqhAM+kst+YHRlwa02FqrUHI9zDRFinaOgRRqrmaSjDR9
        dMmoTuloJd4KjraFpsDqAiyKLeqlpZS8Ig8XTUE=
X-Google-Smtp-Source: ADFU+vt9+zpixXgYFT6uUBnk8dLLEcgG1YwNH79ku9PPljMuZTh8hFZ2JT74em7Xfb7pSoe7nS6ClfmQ0C1YS8+muug=
X-Received: by 2002:a02:954c:: with SMTP id y70mr11803170jah.16.1585299591696;
 Fri, 27 Mar 2020 01:59:51 -0700 (PDT)
MIME-Version: 1.0
References: <5e7dbb10.ulraq/ljeOm297+z%chenanqing@oppo.com>
In-Reply-To: <5e7dbb10.ulraq/ljeOm297+z%chenanqing@oppo.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 27 Mar 2020 09:59:57 +0100
Message-ID: <CAOi1vP_SyWiGdE084P5U-GLuRf1=CPh_+kTgAnqomuFjR6AR+g@mail.gmail.com>
Subject: Re:
To:     chenanqing@oppo.com
Cc:     LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>, kuba@kernel.org,
        Sage Weil <sage@redhat.com>, Jeff Layton <jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 9:36 AM <chenanqing@oppo.com> wrote:
>
> From: Chen Anqing <chenanqing@oppo.com>
> To: Ilya Dryomov <idryomov@gmail.com>
> Cc: Jeff Layton <jlayton@kernel.org>,
>         Sage Weil <sage@redhat.com>,
>         Jakub Kicinski <kuba@kernel.org>,
>         ceph-devel@vger.kernel.org,
>         netdev@vger.kernel.org,
>         linux-kernel@vger.kernel.org,
>         chenanqing@oppo.com
> Subject: [PATCH] libceph: we should take compound page into account also
> Date: Fri, 27 Mar 2020 04:36:30 -0400
> Message-Id: <20200327083630.36296-1-chenanqing@oppo.com>
> X-Mailer: git-send-email 2.18.2
>
> the patch is occur at a real crash,which slab is
> come from a compound page,so we need take the compound page
> into account also.
> fixed commit 7e241f647dc7 ("libceph: fall back to sendmsg for slab pages")'
>
> Signed-off-by: Chen Anqing <chenanqing@oppo.com>
> ---
>  net/ceph/messenger.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> index f8ca5edc5f2c..e08c1c334cd9 100644
> --- a/net/ceph/messenger.c
> +++ b/net/ceph/messenger.c
> @@ -582,7 +582,7 @@ static int ceph_tcp_sendpage(struct socket *sock, struct page *page,
>          * coalescing neighboring slab objects into a single frag which
>          * triggers one of hardened usercopy checks.
>          */
> -       if (page_count(page) >= 1 && !PageSlab(page))
> +       if (page_count(page) >= 1 && !PageSlab(compound_head(page)))
>                 sendpage = sock->ops->sendpage;
>         else
>                 sendpage = sock_no_sendpage;

Hi Chen,

AFAICT compound pages should already be taken into account, because
PageSlab is defined as:

  __PAGEFLAG(Slab, slab, PF_NO_TAIL)

  #define __PAGEFLAG(uname, lname, policy)                       \
      TESTPAGEFLAG(uname, lname, policy)                         \
      __SETPAGEFLAG(uname, lname, policy)                        \
      __CLEARPAGEFLAG(uname, lname, policy)

  #define TESTPAGEFLAG(uname, lname, policy)                     \
  static __always_inline int Page##uname(struct page *page)      \
      { return test_bit(PG_##lname, &policy(page, 0)->flags); }

and PF_NO_TAIL policy is defined as:

  #define PF_NO_TAIL(page, enforce) ({                        \
      VM_BUG_ON_PGFLAGS(enforce && PageTail(page), page);     \
      PF_POISONED_CHECK(compound_head(page)); })

So compound_head() is called behind the scenes.

Could you please explain what crash did you observe in more detail?
Perhaps you backported this patch to an older kernel?

Thanks,

                Ilya
