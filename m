Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC8C63B77
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 20:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729376AbfGISza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 14:55:30 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:43270 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbfGISza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 14:55:30 -0400
Received: by mail-qk1-f193.google.com with SMTP id m14so16813029qka.10;
        Tue, 09 Jul 2019 11:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f9RwapZGzyFkNT+dfGo5wVJbdzZuRB3mHC5GSj9LmJ8=;
        b=BmHqjFAfGGPLYECr2mLWMITHeNaZHCOuICzgPdidHDiuAYl1DuB9BIHuF8L9YXZZBN
         32fRp3SSz8YfQ9ebbRhi1MUTYnu1W5q4U5padrZzDoWDxjK6w4+GHDvFUEwCbWXuKhqQ
         V7H7zH65QGE6QRGOlLq4y3gwm6gwv1/GmzVS2ZP7A0B+6NObpJq/lCNkAoMvopXqhkZ4
         +hUhPTWV+2R/amH37Qw08ey3hykfYDMrk12/z8xg6aea9RvC6oPbm/ESUCy8qmGl44pc
         DPUY9/SJ4EOJ+RqTBxKQnK7lqFCMmjI8al7q6nuhAW9Tq7Wo/bHQ1F97J72/Ae8WDwOt
         gDqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f9RwapZGzyFkNT+dfGo5wVJbdzZuRB3mHC5GSj9LmJ8=;
        b=lqg16nVC/bz+2PTeyO8sWBlLajeDTXNwHulKb9uaxWyriUQHbLGSR6TTMR4xKSFM6N
         XkYtVmjluqmr4wrAHHMvQt6S31Is9HLKRxe0UbNeO83bc1+EzvqK3weYN7XvCw8FMqgo
         hNxf50/jAfuNPHS3Tg4QuprTAyA0U9+k6bleFgTB2X24OwxMOx9xoGFHtfC+WLWN5IfS
         Zo9hy72V3YDX1JJ835wQ4nUMC134i2fBgi1C+4SHMQ5Ip5U0o5iEzT2tsZC2GqrRPQ7w
         2ZZ0bOC5bfgZRoDK88fy2zHZfXy/mN42FH5aJNTZKY5Fxqlgox/TJ13cikagl5Dy3goO
         szwQ==
X-Gm-Message-State: APjAAAV+sMML6jXhbFyoaJr+a2WSwdRI7bgEMrl1uCQycjXDEdh6VT1Z
        asH9G1kzYcd+xRhPr77hWgiM5T4wWJ0QR0lsCPI=
X-Google-Smtp-Source: APXvYqy2K48JPuWKCtWjDTYwAWXMIBHAHIA2ef38g1U6AO2efdVySfxR3FLKDJCS+JpAxv2GrF7QjA5Xj7T/w8AyjhQ=
X-Received: by 2002:a37:660d:: with SMTP id a13mr20589208qkc.36.1562698528762;
 Tue, 09 Jul 2019 11:55:28 -0700 (PDT)
MIME-Version: 1.0
References: <CAEf4BzaUEWwGL3k0VeiFYFqyJexQU9cDZWN69jSDpBjP1ZEcpw@mail.gmail.com>
 <000000000000a94981058d37f1a4@google.com>
In-Reply-To: <000000000000a94981058d37f1a4@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 9 Jul 2019 11:55:17 -0700
Message-ID: <CAEf4BzYTGuXgN+vNJEoMbH_GFAVnSsBvq_YhvoFOeGG5Y+N_ug@mail.gmail.com>
Subject: Re: WARNING in mark_chain_precision
To:     syzbot <syzbot+f21251a7468cd46efc60@syzkaller.appspotmail.com>
Cc:     aaron.f.brown@intel.com, Alexei Starovoitov <ast@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>, hawk@kernel.org,
        intel-wired-lan@lists.osuosl.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        jeffrey.t.kirsher@intel.com,
        john fastabend <john.fastabend@gmail.com>,
        Martin Lau <kafai@fb.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, sasha.neftin@intel.com,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs@googlegroups.com, xdp-newbies@vger.kernel.org,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Original reproducer is almost identical to the one that is fixed by
https://patchwork.ozlabs.org/patch/1129479/.

bpf_prog_free_deferred bug that's undeterministically exposed after
this fix seems to be the cause of a bunch of other bug reports and is
not related to verifier precision tracking.

#syz dup: WARNING in __mark_chain_precision
