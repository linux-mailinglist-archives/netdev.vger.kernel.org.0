Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7B55E838
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 18:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbfD2Q5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 12:57:25 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:55692 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728737AbfD2Q5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 12:57:25 -0400
Received: by mail-it1-f194.google.com with SMTP id w130so95524itc.5;
        Mon, 29 Apr 2019 09:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vo42sLr7XvPo3ivTeFYMrdkUH5vqxLmd782xS33uwXo=;
        b=kFE13lnN1QBGIVayx6huxYJ69TzRJ8aNSp2lvLz6rwpJfqq3mLFP7gy6FWJTxnQ8iP
         2c+ulvLdbkOSQRQVe8dwLW2ArcN0QpI9IZTyVLemmIWBjPkoGXdo+UeqjadB8sehJHwk
         fRWmiMGKZ+MDlQyJ1cJjXsOdf4StBIfO9f+G8DXE3rINCRBC7pHKGkk7YGTiVB+Gj9FU
         Ngg3zyDwWZbdaQthhdMtTS5AWbdNFbptxSS16vlVnw0Fs9ZxgK8zxwSyY82Q23qAC+z4
         bkbwZhjlB9cjKuJzMpoLtXbLUfV3JFhgC77R0T6Bfz8Poj2GAAiwg9D0rjIcs/mmnJR9
         /dQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vo42sLr7XvPo3ivTeFYMrdkUH5vqxLmd782xS33uwXo=;
        b=Rdt3pR+9bnngt5IfUnHwKNLPPtaFh3G2d/omjRQLL9ujAblD9+VY9VJBvhzq2d5oR2
         XXZVXIFtlRbGA8F3UmOvgBffJjhEEUD3MJJSRg1q1bYyALLg2B0yjC1LeAI4LoFXjZSR
         qidJIfjkzLj9pt2d7ZkDFPtw5MEYeO+l+81g3MRyK5hFWlHQwZPnojqrE40aY8Vivzds
         bcxGtrbYypncFyfmqu/731RwN8rTVFrf8ZNTdV/FfR0XeTnsMF570PY3fTcD9ZdYciz+
         PUpSmdsDvXAcHoEHFG2e1/WOCyxxno6ogZU91JXcSXnNLvnL4+UPGbwo5R8izCd89/Dq
         NXgw==
X-Gm-Message-State: APjAAAXGyYrhQWs/puRUT/1hgXA9WvABGuzQPS/DPI/54mom3JLHnVRV
        nK9bW3Eetyb8HtkWYFXmiSev8KJE5NfQlieX/ZmjDGEe
X-Google-Smtp-Source: APXvYqy2UoVrfI/6zipqnh6JFw3RC+/Ecw/3DWfnUyj1NliE9KQBS6PaQWeGWvIVMRPyvIVidZNh9wiMW+VhqjpiJFo=
X-Received: by 2002:a02:760b:: with SMTP id z11mr37053487jab.139.1556557044218;
 Mon, 29 Apr 2019 09:57:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190426154108.52277-1-posk@google.com>
In-Reply-To: <20190426154108.52277-1-posk@google.com>
From:   Captain Wiggum <captwiggum@gmail.com>
Date:   Mon, 29 Apr 2019 10:57:13 -0600
Message-ID: <CAB=W+o=rNc9R0L+e23xox0m-g3q2YWO7Wd-MsGDpU7DUPqV5kw@mail.gmail.com>
Subject: Re: [PATCH 4.9 stable 0/5] net: ip6 defrag: backport fixes
To:     Peter Oskolkov <posk@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        Peter Oskolkov <posk@posk.io>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Sasha Levin <sashal@kernel.org>, Lars Persson <lists@bofh.nu>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have run the 4.9 patch set on the full TAHI test sweet.
Similar to 4.14, it does fix all the IPv6 frag header issues.
But the "change MTU" mesg routing is still broken.
Overall, it fixes what it was intended to fix, so I suggest it move
toward release.
Thanks Peter!

--John Masinter

On Fri, Apr 26, 2019 at 9:41 AM Peter Oskolkov <posk@google.com> wrote:
>
> This is a backport of a 5.1rc patchset:
>   https://patchwork.ozlabs.org/cover/1029418/
>
> Which was backported into 4.19:
>   https://patchwork.ozlabs.org/cover/1081619/
>
> and into 4.14:
>   https://patchwork.ozlabs.org/cover/1089651/
>
>
> This 4.9 patchset is very close to the 4.14 patchset above
> (cherry-picks from 4.14 were almost clean).
>
>
> Eric Dumazet (1):
>   ipv6: frags: fix a lockdep false positive
>
> Florian Westphal (1):
>   ipv6: remove dependency of nf_defrag_ipv6 on ipv6 module
>
> Peter Oskolkov (3):
>   net: IP defrag: encapsulate rbtree defrag code into callable functions
>   net: IP6 defrag: use rbtrees for IPv6 defrag
>   net: IP6 defrag: use rbtrees in nf_conntrack_reasm.c
>
>  include/net/inet_frag.h                   |  16 +-
>  include/net/ipv6.h                        |  29 --
>  include/net/ipv6_frag.h                   | 111 +++++++
>  net/ieee802154/6lowpan/reassembly.c       |   2 +-
>  net/ipv4/inet_fragment.c                  | 293 ++++++++++++++++++
>  net/ipv4/ip_fragment.c                    | 295 +++---------------
>  net/ipv6/netfilter/nf_conntrack_reasm.c   | 273 +++++-----------
>  net/ipv6/netfilter/nf_defrag_ipv6_hooks.c |   3 +-
>  net/ipv6/reassembly.c                     | 361 ++++++----------------
>  net/openvswitch/conntrack.c               |   1 +
>  10 files changed, 631 insertions(+), 753 deletions(-)
>  create mode 100644 include/net/ipv6_frag.h
>
> --
> 2.21.0.593.g511ec345e18-goog
>
