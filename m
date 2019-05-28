Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 080A02BCE4
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 03:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727694AbfE1BgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 21:36:05 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42086 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727018AbfE1BgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 21:36:05 -0400
Received: by mail-qk1-f196.google.com with SMTP id b18so14192294qkc.9;
        Mon, 27 May 2019 18:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Kj9t4JQJcagW18k4dyge90dwQtqjHOh2tQ9v2UatVwU=;
        b=rqRqXS8Bn7OA5NpsTq5QVD508b05RK7UY+YSHcgXWsACj98Tb0U+EKfBtcfzlnMa1u
         mAFSzEv1P6Xlv9oiZ+0R53Irqz5PJwJhpdcOCJjvDn/gI13z+DUj6ovjo5auUZC4EQI9
         uHmHwLty13Z4+osxXDd10BmEZagAl/wqYDmW42J3PWErpdAv7N+t/baZJFOeUkMzJVEP
         d+/AAWB2SKfZrv1NbpDJRt+yttmYw1yfwsvqBr5D2XRB3OnFF7UMKomc3u2Xq9zV9TXr
         lAtnjNRuGm4b+LOPjeCmz+gE0YFDBvMKz98VwKbkH2I69JsGqoISlA3iVBmg3B7+NoDe
         uyuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Kj9t4JQJcagW18k4dyge90dwQtqjHOh2tQ9v2UatVwU=;
        b=taEP7jIFrnoKTcgdT6GVFXRkTJ+Ie3OoPC7zBXB0izEAyq1HArf9foa5WB5Q7sksgI
         T/03pkYvZoMUe2Uw0iNGqhPWTdxh21lDG0OqirCi4NSl15+YRAwQKtkY8KY+PwBViHRq
         idfXobKAGs7biQ4g0OOkX73UCnXjI8tbOfXN0y3oAjHJYePSpoi5eJCL0NvetESTV4Wd
         gk7AuZPR8Whh6a6dOfYOxZ9f9Toat7DyZSBGF9Y2WAOieEjv0f1xS4lNFL5LiYp1OPQq
         onTAYrGSrRJB/ifdQHW+AHRuIwjkjhs0pbSdj2W9GHYJk71sLQqbNozXCc86Ml2JMCbh
         9vTQ==
X-Gm-Message-State: APjAAAVf0ZiFI0GqWIWrnJVD+QgX3gJdRaSkVfdwPCKkR5YFxSRvtExw
        Q7SJzsJHMSy/8hGqauucVk8=
X-Google-Smtp-Source: APXvYqw0xhgF3f6NkXqVMXN7RG6560O8XISc1F2wIzZjOMx/WjP6gmPNJBaJNH1HyJB27l4Gg5FR3w==
X-Received: by 2002:ac8:270b:: with SMTP id g11mr65112037qtg.363.1559007364479;
        Mon, 27 May 2019 18:36:04 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:4abe:239a:2941:e90:181d])
        by smtp.gmail.com with ESMTPSA id j62sm4482875qte.89.2019.05.27.18.36.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 27 May 2019 18:36:03 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 34358C0A7A; Mon, 27 May 2019 22:36:00 -0300 (-03)
Date:   Mon, 27 May 2019 22:36:00 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     syzbot <syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com,
        vyasevich@gmail.com
Subject: Re: memory leak in sctp_process_init
Message-ID: <20190528013600.GM5506@localhost.localdomain>
References: <00000000000097abb90589e804fd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000097abb90589e804fd@google.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 27, 2019 at 05:48:06PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    9c7db500 Merge tag 'selinux-pr-20190521' of git://git.kern..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=10388530a00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=61dd9e15a761691d
> dashboard link: https://syzkaller.appspot.com/bug?extid=f7e9153b037eac9b1df8
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10e32f8ca00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=177fa530a00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com
> 
>  0 to HW filter on device batadv0
> executing program
> executing program
> executing program
> BUG: memory leak
> unreferenced object 0xffff88810ef68400 (size 1024):
>   comm "syz-executor273", pid 7046, jiffies 4294945598 (age 28.770s)
>   hex dump (first 32 bytes):
>     1d de 28 8d de 0b 1b e3 b5 c2 f9 68 fd 1a 97 25  ..(........h...%
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<00000000a02cebbd>] kmemleak_alloc_recursive
> include/linux/kmemleak.h:55 [inline]
>     [<00000000a02cebbd>] slab_post_alloc_hook mm/slab.h:439 [inline]
>     [<00000000a02cebbd>] slab_alloc mm/slab.c:3326 [inline]
>     [<00000000a02cebbd>] __do_kmalloc mm/slab.c:3658 [inline]
>     [<00000000a02cebbd>] __kmalloc_track_caller+0x15d/0x2c0 mm/slab.c:3675
>     [<000000009e6245e6>] kmemdup+0x27/0x60 mm/util.c:119
>     [<00000000dfdc5d2d>] kmemdup include/linux/string.h:432 [inline]
>     [<00000000dfdc5d2d>] sctp_process_init+0xa7e/0xc20
> net/sctp/sm_make_chunk.c:2437
>     [<00000000b58b62f8>] sctp_cmd_process_init net/sctp/sm_sideeffect.c:682
> [inline]
>     [<00000000b58b62f8>] sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1384
> [inline]
>     [<00000000b58b62f8>] sctp_side_effects net/sctp/sm_sideeffect.c:1194
> [inline]
>     [<00000000b58b62f8>] sctp_do_sm+0xbdc/0x1d60
> net/sctp/sm_sideeffect.c:1165

Note that this is on the client side. It was handling the INIT_ACK
chunk, from sctp_sf_do_5_1C_ack().

I'm not seeing anything else other than sctp_association_free()
releasing this memory. This means 2 things:
- Every time the cookie is retransmitted, it leaks. As shown by the
  repetitive leaks here.
- The cookie remains allocated throughout the association, which is
  also not good as that's a 1k that we could have released back to the
  system right after the handshake.

  Marcelo
