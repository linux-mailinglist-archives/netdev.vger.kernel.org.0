Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 063DB3B77C
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 16:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403953AbfFJOel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 10:34:41 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:45613 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403942AbfFJOel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 10:34:41 -0400
Received: by mail-ed1-f68.google.com with SMTP id a14so12943113edv.12;
        Mon, 10 Jun 2019 07:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MTGWsUBr2L+P8aBUG4WFSYpu/sxAUSElAPcxJpHZNu0=;
        b=HKp914S4OkrsKUi0GgHD22923EyP+FFJGm6HKQ1iHKxNtx+/zxQaF9i1rbCrbHl5eb
         0OHqNXMeYYGNlQtVmEEVUJof06bsfE9J6PcREobzGwzTAw2N30iVnWVifos0ssBpbzTt
         x6PK9w3mSNENnFZ00RIt5m7CHsTewevwG6blysA42J5R8eH7Ub/HGdqSWiyP1T6kBKxg
         QnDzaRXb7fJsWeFwLkRHq+R7xaXkK5sOQ3pguBCj7FnNH0j+4V2yhKjCgOyH5/sWZXSN
         hawir52CgsvkCOghKcMb/aZgBjBiniBHMg5+Y7CDtkM1dr5YU/tjCG55jrKIjr2XC7ub
         NMsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MTGWsUBr2L+P8aBUG4WFSYpu/sxAUSElAPcxJpHZNu0=;
        b=ErlwVkrfmdGsjBacKBvy4fynH6ce9kxfzJGbeGidPTKaueZLFduJ+qaAl2s8M2axi2
         7BGgrz3/1fi0h3S8iDEYMWPDHubqOdIUEuQ6Zl4FmW7T5LCv+Q3Cmt33ekn7wrRUiQoQ
         WlL9EI6yk9V4S6W99U122Gva5tpZn+DrYjpCXwC9iQj+G6NlfQyjuqFfdOYIxMCFdax3
         DUl3O9ztQOhim/Y+voHYbO8DBvH0BojTn/egqnGwKvqzAwYsePs9u6HSEu3y1nYTmasQ
         o++msOmjr2YibnjRqysz7DQoxWakViYdZ0zRLvij8uja0idXXbcUNdKi1W6cH+JvNNJj
         MP6A==
X-Gm-Message-State: APjAAAWNGrDGX3dM3f8z7TjJL8B30O8owyj3j6P3BSbTeNiLww1gocWy
        fjLix2FQ6oVgvShfvQBfsm0j38P+w1PMzW/Zju8=
X-Google-Smtp-Source: APXvYqzG4pTXEWeYJu/98bKGKeUyLRBM6GfrMiLJSxD5yHuoJDChEYDidfgdt6pimDZUHUwcoAxyiqxSlc+gJJqdup8=
X-Received: by 2002:a50:b1db:: with SMTP id n27mr28793697edd.62.1560177279272;
 Mon, 10 Jun 2019 07:34:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190610115831.175710-1-maowenan@huawei.com> <CAF=yD-JOCZHt6q3ArCqY5PMW1vP5ZmNkYMKUB14TrgU-X30cSQ@mail.gmail.com>
 <caf8d25f-60e2-a0c0-dc21-956ea32ee59a@huawei.com>
In-Reply-To: <caf8d25f-60e2-a0c0-dc21-956ea32ee59a@huawei.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 10 Jun 2019 10:34:03 -0400
Message-ID: <CAF=yD-+g1bSGOubFUE8veZNvGiPy1oYsf+dFDd=hqXYD+k4g_Q@mail.gmail.com>
Subject: Re: [PATCH -next] packet: remove unused variable 'status' in __packet_lookup_frame_in_block
To:     maowenan <maowenan@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 10:03 AM maowenan <maowenan@huawei.com> wrote:
>
>
>
> On 2019/6/10 21:05, Willem de Bruijn wrote:
> > On Mon, Jun 10, 2019 at 8:17 AM Mao Wenan <maowenan@huawei.com> wrote:
> >>
> >> The variable 'status' in  __packet_lookup_frame_in_block() is never used since
> >> introduction in commit f6fb8f100b80 ("af-packet: TPACKET_V3 flexible buffer
> >> implementation."), we can remove it.
> >> And when __packet_lookup_frame_in_block() calls prb_retire_current_block(),
> >> it can pass macro TP_STATUS_KERNEL instead of 0.
> >>
> >> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> >> ---

> >>         /* Ok, close the current block */
> >> -       prb_retire_current_block(pkc, po, 0);
> >> +       prb_retire_current_block(pkc, po, TP_STATUS_KERNEL);
> >
> > I don't think that 0 is intended to mean TP_STATUS_KERNEL here.
> >
> > prb_retire_current_block calls prb_close_block which sets status to
> >
> >   TP_STATUS_USER | stat
> >
> > where stat is 0 or TP_STATUS_BLK_TMO.
>
>
> #define TP_STATUS_KERNEL                      0
> #define TP_STATUS_BLK_TMO               (1 << 5)
>
> Actually, packet_current_rx_frame calls __packet_lookup_frame_in_block with status=TP_STATUS_KERNEL
> in original code.
>
> __packet_lookup_frame_in_block in this function, first is to check whether the currently active block
> has enough space for the packet, which means status of block should be TP_STATUS_KERNEL, then it calls
> prb_retire_current_block to retire this block.

I know. I mean that the status here is what is passed to userspace on
block retire.

It is not intended to be TP_STATUS_USER | TP_STATUS_KERNEL. That makes no sense.

> Since there needs some discussion about means of status, I can send v2 only removing the parameter status of
> __packet_lookup_frame_in_block?

Sounds good.
