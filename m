Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0339500D1
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 06:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbfFXEjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 00:39:13 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39724 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbfFXEjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 00:39:12 -0400
Received: by mail-wm1-f68.google.com with SMTP id z23so11829855wma.4;
        Sun, 23 Jun 2019 21:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YNELeqsO3ONkBzigACa9WgfAHnyRLEL6gV/TACazJzc=;
        b=GdD5hTA7BPb+tN5+F5Hd9Yjg3qpZhl/UDMGlGoEM7GFhcuPKCjk0fDtp6trqGu4LaZ
         lvZ6ASMBEqBCwbDlZLWIct7GQlpvDPbQscSsh0OGcsO4nqEikUUVnb7hxe5h5ecAQ/+x
         y5TX9lYlEQ0vRsrCzItt5ktQhH1F7Ffl0oWXTHP3u6/1e6hJZt3fg4VsTKqFGQru2cbt
         uKaRHBxTbjBYrVvT22A/wpLycOGrxVzAPdHu+5NLjZcmhOpgXnoXjWQgIBW+r1UTZbB2
         GEGIA5M5eZdYF+nUXT9aGHwjfZKMhZh6p7EasfxgJiJDES+T896MTBibUgxQSzVKnbxQ
         PwRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YNELeqsO3ONkBzigACa9WgfAHnyRLEL6gV/TACazJzc=;
        b=fR8N2L45m3hsik+bLgELB585Der7xf5N9/N3jUFE8nB+cIP8OrXMu0y3oxrDDIDYlN
         R2KgmkLVltKlxmFYzrnXRupgL6X+K/dBBAISEotUg3AwPDh8JlW7wMg4hOta3H5dnq42
         EAw2DV6nOX0P51KGUMpNZlnxFqehA/QvIEr8h0hi8aXMwVVPVspidsZktNzUKpBlJr3m
         LjdFZ2GjT9D8+pIwricOeQKGHenuW4qXkIQmB+CpabCAtEpdTsp8Hfub5WogV3p9H6pM
         osrhqZeMZYf5cK7J1gyr6ckGff/Vod3jKwKftITJxRXa6Sf4IRiUPaCVMtpBq6tVwiMA
         vJPg==
X-Gm-Message-State: APjAAAWxX1uMDi3BAHqPwQRYzBjrzlgNbolrfHc9+uBkZtHY6DQBHWvX
        nSqXNFXBiwwFwGEnMk0EnrlQSr7mW1wcAUfZIMc=
X-Google-Smtp-Source: APXvYqznBNXnEw5RZZ4tdgedDsRQHsK/vADIWjCrMTGOLQKAhTXeCoBTP+DgQlTl5assRWvi5M/A6fTORvagJxDrfCU=
X-Received: by 2002:a05:600c:230b:: with SMTP id 11mr13181852wmo.85.1561351150527;
 Sun, 23 Jun 2019 21:39:10 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000a7776f058a3ce9db@google.com> <178c7ee0-46b7-8334-ef98-e530eb60a2cf@gmail.com>
 <CACT4Y+ZqM84Ny22p7=J6vVXG7XOkqVN_jjkb87DNetNCFQRFBQ@mail.gmail.com>
In-Reply-To: <CACT4Y+ZqM84Ny22p7=J6vVXG7XOkqVN_jjkb87DNetNCFQRFBQ@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 24 Jun 2019 12:38:59 +0800
Message-ID: <CADvbK_f0kZOZRUQ3eWNMiOUTC_JE6xsrdX2VzsHsAXKrq3D8ig@mail.gmail.com>
Subject: Re: KASAN: user-memory-access Read in ip6_hold_safe (3)
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     David Ahern <dsahern@gmail.com>,
        syzbot <syzbot+a5b6e01ec8116d046842@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 3, 2019 at 2:57 PM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Sat, Jun 1, 2019 at 7:15 PM David Ahern <dsahern@gmail.com> wrote:
> >
> > On 6/1/19 12:05 AM, syzbot wrote:
> > > Hello,
> > >
> > > syzbot found the following crash on:
> > >
> > > HEAD commit:    dfb569f2 net: ll_temac: Fix compile error
> > > git tree:       net-next
> > syzbot team:
> >
> > Is there any way to know the history of syzbot runs to determine that
> > crash X did not happen at commit Y but does happen at commit Z? That
> > narrows the window when trying to find where a regression occurs.
>
> Hi David,
>
> All info is available on the dashboard:
>
> > dashboard link: https://syzkaller.appspot.com/bug?extid=a5b6e01ec8116d046842
>
> We don't keep any private info on top of that.
>
> This crash happened 129 times in the past 9 days. This suggests this
> is not a previous memory corruption, these usually happen at most few
> times.
> The first one was:
>
> 2019/05/24 15:33 net-next dfb569f2
>
> Then it was joined by bpf-next:
>
> ci-upstream-bpf-next-kasan-gce 2019/06/01 15:51 bpf-next 0462eaac
>
> Since it happens a dozen of times per day, most likely it was
> introduced into net-next around dfb569f2 (syzbot should do new builds
> every ~12h, minus broken trees).

I think all these pcpu memory corruptions can be marked as Fixed-by:

commit c3bcde026684c62d7a2b6f626dc7cf763833875c
Author: Xin Long <lucien.xin@gmail.com>
Date:   Mon Jun 17 21:34:15 2019 +0800

    tipc: pass tunnel dev as NULL to udp_tunnel(6)_xmit_skb
