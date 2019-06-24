Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7C08517D5
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 18:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728848AbfFXQAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 12:00:52 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39672 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbfFXQAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 12:00:52 -0400
Received: by mail-wr1-f66.google.com with SMTP id x4so14488975wrt.6
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 09:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YdRzxe6Q+zn/5xTeZGYYejalAGDTIZM+YjpMFef3Ko8=;
        b=FP9JiPX7ih+dikuyHy3L/OqPtKBjsumovXYh2kCCy7owOPTtjTb88uO94MHyuYGVqt
         VvLHXnX9/uHyRp21hmLyFpJbfn4P+z+H+dZYZqgybjBTa5+Ov2gKNtIYAogQ3MnplH38
         dI8praVIsJ7r2/R5zYHe99PWKkmJ6/fqXyj0bxAJVYQbumZzsy/2kEUdXuGTrhJlRfc4
         hj6HF2gwOvfmwp8OThxLbRke/lKqghQS8wcNmXYOnQPRf1vVSoyvcm54VmokZ0iHDf4o
         yl0oNLZeXkORGwmDKkhvL1zENBp9z378FJUetO2Hmgqeyt5YhcLvyDTooOAogimFGKF4
         W1Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YdRzxe6Q+zn/5xTeZGYYejalAGDTIZM+YjpMFef3Ko8=;
        b=KotgTiBPEUKrT5ea6AkxyImR/NmLj0Y6yKps9Rq0Hqw0boSvJjxvTCL1zFHVDY2i3Z
         NJqWE3KcAz0vzbcXwQqP63GiNfDwTeBlgvpmBskP47xSMwc4LuIjWzfpn1F3hq/lHhMj
         Xr6uvAxAFR9vjEeYt8eVUEqfyNdotwNMeobkob1G3PcvdVEcjJry4QL+WNdEtk390w9M
         aaaRFiqHcLDYd6OJAYMx0wtebCoaE5e3iqBFxI652Eh3cIrF/nGSsEnYiteV3O54DZzw
         6HSTo0wX47vLZEf0X6zt0dVe6C7Rr8JzYn14ppBwPzurJZClQb4yKInMtr/JFsfYJWtw
         oBaA==
X-Gm-Message-State: APjAAAVHgmepzeOWWhoyWv8yJtZciHehbqojSVOAWotezvpqsyZVygDR
        OB+Hi4jz6ePeqndcWDbzM3icEXgX7xtnJ2t6+oA=
X-Google-Smtp-Source: APXvYqyldwXao3D0pyTSXGcRgmWbJSvetdJ7B+NCHDKt/p5lw0hHshQTnPsxXiijYECAcWNe4PW77naikfdDmMgmImM=
X-Received: by 2002:adf:fb81:: with SMTP id a1mr25254311wrr.329.1561392050126;
 Mon, 24 Jun 2019 09:00:50 -0700 (PDT)
MIME-Version: 1.0
References: <4fd888cb669434b00dce24ace4410524665be285.1561363146.git.lucien.xin@gmail.com>
 <061d3bd2-46a2-04aa-a3f7-3091e6ff8523@gmail.com>
In-Reply-To: <061d3bd2-46a2-04aa-a3f7-3091e6ff8523@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 25 Jun 2019 00:00:39 +0800
Message-ID: <CADvbK_dSghWbMtmpH+oMpW=0CsSU-usjQ=_nZw2qkgQ0iEuH+A@mail.gmail.com>
Subject: Re: [PATCH net] tipc: check msg->req data len in tipc_nl_compat_bearer_disable
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Jon Maloy <jon.maloy@ericsson.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 4:33 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 6/24/19 12:59 AM, Xin Long wrote:
> > This patch is to fix an uninit-value issue, reported by syzbot:
> >
> >   BUG: KMSAN: uninit-value in memchr+0xce/0x110 lib/string.c:981
> >   Call Trace:
> >     __dump_stack lib/dump_stack.c:77 [inline]
> >     dump_stack+0x191/0x1f0 lib/dump_stack.c:113
> >     kmsan_report+0x130/0x2a0 mm/kmsan/kmsan.c:622
> >     __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:310
> >     memchr+0xce/0x110 lib/string.c:981
> >     string_is_valid net/tipc/netlink_compat.c:176 [inline]
> >     tipc_nl_compat_bearer_disable+0x2a1/0x480 net/tipc/netlink_compat.c:449
> >     __tipc_nl_compat_doit net/tipc/netlink_compat.c:327 [inline]
> >     tipc_nl_compat_doit+0x3ac/0xb00 net/tipc/netlink_compat.c:360
> >     tipc_nl_compat_handle net/tipc/netlink_compat.c:1178 [inline]
> >     tipc_nl_compat_recv+0x1b1b/0x27b0 net/tipc/netlink_compat.c:1281
> >
> > TLV_GET_DATA_LEN() may return a negtive int value, which will be
> > used as size_t (becoming a big unsigned long) passed into memchr,
> > cause this issue.
> >
> > Similar to what it does in tipc_nl_compat_bearer_enable(), this
> > fix is to return -EINVAL when TLV_GET_DATA_LEN() is negtive in
> > tipc_nl_compat_bearer_disable(), as well as in
> > tipc_nl_compat_link_stat_dump() and tipc_nl_compat_link_reset_stats().
> >
> > Reported-by: syzbot+30eaa8bf392f7fafffaf@syzkaller.appspotmail.com
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
>
> Please add an appropriate Fixes: tag, thanks !
>
Fixes: 0762216c0ad2 ("tipc: fix uninit-value in tipc_nl_compat_bearer_enable")
Fixes: 8b66fee7f8ee (:tipc: fix uninit-value in
tipc_nl_compat_link_reset_stats")

Sorry, David, do I need to resend this one?
