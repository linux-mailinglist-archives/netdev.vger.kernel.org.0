Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D812EBB7D4
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 17:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbfIWPYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 11:24:45 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:48953 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725992AbfIWPYp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Sep 2019 11:24:45 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 5c870d66;
        Mon, 23 Sep 2019 14:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=8zzuCZXCZAoOQeNoK08hAiyUbsQ=; b=ZX4fLD
        uRi22sY4dnKAgyHl7/B6qFwTZIwrwe7CX9XizZ2rajREu7C8rcWVcvWuZWbd4Gqu
        k2UGnkyHP1BigoSxifQqHr8GUJkL/L6gMEWUn5NTkNNJ++bytBuggykVxw/P1kkW
        sCkX5JB21L2lGyS4og48LHiVXjo71xvwGgoaJYSmdKZaHA3dqKmP307b0TGxuq2d
        XUbfAU+1OQkyesGPzoHUzTJMadewfCMEFvhWqzL/A0NuOmG7VclEfaLWy9snlOTT
        zj3Ap70oQ8TyWVBV8Qp5hxAxcdA9pLQ3mjDd0hIayrRwWoce/YRcJuPlCKJSRGLd
        lW7RRXsePfYb2bPA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a3da75fb (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 23 Sep 2019 14:39:13 +0000 (UTC)
Received: by mail-ot1-f42.google.com with SMTP id s22so12465524otr.6;
        Mon, 23 Sep 2019 08:24:43 -0700 (PDT)
X-Gm-Message-State: APjAAAWuVs6VlfrWTbMlY7xdSlhvHB9/w2TdAIalI+NV49cZNaTXD6VW
        GG5zOW2LQmoMtkIZiBAm3KcVfJfSrxRZ/r6oy/w=
X-Google-Smtp-Source: APXvYqwgWw8Nt90k1KXN8nXE9xGerbP4lvbQ6ih8TbATzS9WfcxGaxFXrFvbPkM1i9qlgkfIMbntPM9wVWziH17rIbw=
X-Received: by 2002:a05:6830:20cd:: with SMTP id z13mr291875otq.243.1569252282678;
 Mon, 23 Sep 2019 08:24:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190923144612.29668-1-Jason@zx2c4.com> <20190923150600.GA27191@dell5510>
In-Reply-To: <20190923150600.GA27191@dell5510>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 23 Sep 2019 17:24:31 +0200
X-Gmail-Original-Message-ID: <CAHmME9pKWuJ+oKfrKxhrjLCEw1qcWE=sCZSLOGyUMvW+eUS2cw@mail.gmail.com>
Message-ID: <CAHmME9pKWuJ+oKfrKxhrjLCEw1qcWE=sCZSLOGyUMvW+eUS2cw@mail.gmail.com>
Subject: Re: [PATCH] ipv6: Properly check reference count flag before taking reference
To:     Petr Vorel <pvorel@suse.cz>
Cc:     Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Apparently even with this (certainly correct) patch attached, users
are still experiencing problems. Bug hunting continues, and I'll
report back if I figure something out.
