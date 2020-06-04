Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094E01EDC68
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 06:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728485AbgFDEii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 00:38:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:45784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726956AbgFDEih (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jun 2020 00:38:37 -0400
Received: from kernel.org (unknown [104.132.0.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04A91206C3;
        Thu,  4 Jun 2020 04:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591245517;
        bh=2lMQ7ysGCU8GBBi628ZDf5NUJ8tIyihWdEeZRWeBBRs=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=rjNKa+NoPrDtpvFIskphpRAzqIuZC2EDaeiH8NLviKFG4z0voPiz2uE07z0nrysfQ
         2eLhdaruaSQ74UQKr1AOe02dy7ouM14/8cQEr/sK93Ykg+9oEquqLX/ary5lgIdgf1
         J8RYhQkIfWZ8Ohep5Uxh6ufpuFKZW5VLYrPucY5o=
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20200603233203.1695403-7-keescook@chromium.org>
References: <20200603233203.1695403-1-keescook@chromium.org> <20200603233203.1695403-7-keescook@chromium.org>
Subject: Re: [PATCH 06/10] clk: st: Remove uninitialized_var() usage
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>, x86@kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-mm@kvack.org, clang-built-linux@googlegroups.com
To:     Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Date:   Wed, 03 Jun 2020 21:38:36 -0700
Message-ID: <159124551620.69627.18245138803269803785@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Kees Cook (2020-06-03 16:31:59)
> Using uninitialized_var() is dangerous as it papers over real bugs[1]
> (or can in the future), and suppresses unrelated compiler warnings (e.g.
> "unused variable"). If the compiler thinks it is uninitialized, either
> simply initialize the variable or make compiler changes. As a precursor
> to removing[2] this[3] macro[4], just remove this variable since it was
> actually unused:
>=20
> drivers/clk/st/clkgen-fsyn.c: In function \u2018quadfs_set_rate\u2019:
> drivers/clk/st/clkgen-fsyn.c:793:6: warning: unused variable \u2018i\u201=
9 [-Wunused-variable]
>   793 |  int i;
>       |      ^
>=20
> [1] https://lore.kernel.org/lkml/20200603174714.192027-1-glider@google.co=
m/
> [2] https://lore.kernel.org/lkml/CA+55aFw+Vbj0i=3D1TGqCR5vQkCzWJ0QxK6Cern=
OU6eedsudAixw@mail.gmail.com/
> [3] https://lore.kernel.org/lkml/CA+55aFwgbgqhbp1fkxvRKEpzyR5J8n1vKT1VZdz=
9knmPuXhOeg@mail.gmail.com/
> [4] https://lore.kernel.org/lkml/CA+55aFz2500WfbKXAx8s67wrm9=3DyVJu65TpLg=
N_ybYNv0VEOKA@mail.gmail.com/
>=20
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---

Acked-by: Stephen Boyd <sboyd@kernel.org>
