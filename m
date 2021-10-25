Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A034391DE
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 10:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbhJYJBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 05:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232413AbhJYJBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 05:01:42 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3156BC061767
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 01:59:20 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id g125so14585572oif.9
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 01:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aMtv1MlJYbtimIeY9k4qdPc6dVQTgri/qRFILzyjfOw=;
        b=f/TOaAxgnS5Sqf7cFLlSRsaEGB8IwmshdNUmJCie6SlI9fL+AReznkJQr/NX9kMZP0
         TXUbtdV4mLLGrF7HbKrp/KrHuPkmGvP9xuMCiBUG+ipb6rXBrXcfd7Cnwenl6AlfrIPm
         BSVhXE/qytumbvPWnJzU5m1zmnUMrYdoDhXBTamie//W31a8Mwgy9PhZ/z63k5Rdm5je
         UtIGs98FXlYO88xCoLsQg2F9cZRXUunBNC6aIKhjRUGkGHbw/Wd91Wl7yuEXuc2RAyyt
         qu1/VyusyT3mS0rm8YxO1npUIgoYrT1owbawpwN/y9OWB8a493ToJZde+9XzeQquBhc5
         pYNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aMtv1MlJYbtimIeY9k4qdPc6dVQTgri/qRFILzyjfOw=;
        b=Wg8SFvItQTQ+v1qWvx0CdtZNMDu68FOFbyw7Slhf6dN8bbPGN02XvpQyyovEKANXyN
         UxzunT1e6R09GlyFgHd3Yj7zSizpvhOEFnn5AFYjJ6l4L7AYHf3JQAKGqMuYReTLXPii
         942fOgkTiRlHheOCvLCMEADLAjRlGBIFH51awg4eXET4eE0OjegqRwgrtit505Dmy640
         URNKXmPvzITAIIqySDsymIGTAooOvwPFLIWmL9NxgaLDgQXZ1cTRKj0p/QGJWHFM3XYa
         TKYFftx2ZmE88Jr28Ffy6seaz0kJ2JElHZ4gbAJeVfzXAvkN8PgghfgDhbBX2pikQ8Ak
         MjDw==
X-Gm-Message-State: AOAM5316IF9TuB2ml7nP79M54DZ/59hczjv40X5MjOXR80c6J5mqDh0o
        C8SZOeAQv4rqu2u4rQUdcMZzLg58VRnGXOwutBdhpg==
X-Google-Smtp-Source: ABdhPJyyLbBP/HLLAcaQpqaHX1X3fUZb1QoYuqCZ+6fctZal9FCukbtG6YmQ/xoO62cgkbAnR8rOXgDMDus0bE+s9uM=
X-Received: by 2002:a05:6808:ec9:: with SMTP id q9mr21107014oiv.160.1635152359323;
 Mon, 25 Oct 2021 01:59:19 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000d5efd605ccc6a5df@google.com> <0000000000006f55c405cf287f25@google.com>
In-Reply-To: <0000000000006f55c405cf287f25@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 25 Oct 2021 10:59:08 +0200
Message-ID: <CACT4Y+b7hhoZeEy_V2FgB5Tq39vGq797QyEsWFkXFnXySoqEpQ@mail.gmail.com>
Subject: Re: [syzbot] general protection fault in nf_tables_dump_tables
To:     syzbot <syzbot+0e3358e5ebb1956c271d@syzkaller.appspotmail.com>
Cc:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Oct 2021 at 09:42, syzbot
<syzbot+0e3358e5ebb1956c271d@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit a499b03bf36b0c2e3b958a381d828678ab0ffc5e
> Author: Florian Westphal <fw@strlen.de>
> Date:   Mon Sep 13 12:42:33 2021 +0000
>
>     netfilter: nf_tables: unlink table before deleting it
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13efcb0cb00000
> start commit:   9bc62afe03af Merge tag 'net-5.15-rc3' of git://git.kernel...
> git tree:       net
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e917f3dfc452c977
> dashboard link: https://syzkaller.appspot.com/bug?extid=0e3358e5ebb1956c271d
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14374e5f300000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: netfilter: nf_tables: unlink table before deleting it
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

Looks legit:

#syz fix: netfilter: nf_tables: unlink table before deleting it
