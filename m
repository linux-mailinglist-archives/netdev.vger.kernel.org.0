Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653171AE6C9
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 22:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731021AbgDQU3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 16:29:46 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:40421 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730903AbgDQU3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 16:29:46 -0400
Received: from mail-qk1-f180.google.com ([209.85.222.180]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MGA0o-1jSs3Y1XNk-00GVmh; Fri, 17 Apr 2020 22:29:44 +0200
Received: by mail-qk1-f180.google.com with SMTP id l78so3872120qke.7;
        Fri, 17 Apr 2020 13:29:43 -0700 (PDT)
X-Gm-Message-State: AGi0PuaRmip2HEYs0FGyC1Jiur/c0kOYGsgL5Iwx32UDXyahgTiuwQmu
        355SCgd2C2VFYoMpyvBrvX+KrXaMTZpGnTxsZkI=
X-Google-Smtp-Source: APiQypL9X/vVR1PL9UZZuqrvyfuzaBgQ+i0TzvvyfYM7CZl8gzxom+ZU/c+XmdF0y3uNAf2WacKGIivzmtllOf0moVM=
X-Received: by 2002:a37:9d08:: with SMTP id g8mr5126203qke.138.1587155382960;
 Fri, 17 Apr 2020 13:29:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200417200627.129849-1-saeedm@mellanox.com>
In-Reply-To: <20200417200627.129849-1-saeedm@mellanox.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 17 Apr 2020 22:29:26 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0nhotshTR0Bm7abRT5GLbUVYzD0CGnwaOa=+u0n6zApw@mail.gmail.com>
Message-ID: <CAK8P3a0nhotshTR0Bm7abRT5GLbUVYzD0CGnwaOa=+u0n6zApw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/3] Kconfig: Introduce "uses" keyword
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Nicolas Pitre <nico@fluxnic.net>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Leon Romanovsky <leon@kernel.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        David Airlie <airlied@linux.ie>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:OKMOH8n/uyHW+Hyxm1G2wKgheEUfRaOVLIUdJDHcWMHfqeYvmkN
 cKBPsNEg3RMRiPz5myyUnHf+b1Py3LfQMUfUa986KEneqhxZ107E21bCjCGbs/U7S0R1UeR
 ZxOIYgJtv1aQsxUyD6jN+/Re0zKhyvyC1FJOtxMx/7w11I+RHqRaaQhvx1yptnS44c0A8Qw
 hyBVfBCOvSkO5NHnIB5WQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:tm4MgMXzhY0=:wyGvXuqkLRqAZJhVbpU9pQ
 tF1UNj4Kkhx2qbt60539l900baF70ylHR/PRVlBJQvWSRHH0TsY5QCWQciFcZ3ylXq1QwAeek
 6pVbAlnrzf9Wy22/y3nTxLKyexakikOnPZFav5I9h7tmvxDkevje37h3lnxgfwL02VXa1kIUa
 Bqsb4yX8S9dt4OyG3UqPjtMv7aKtFe7/cb8bBarZOTPudaPTHTBume8ZnxIuV2vEsrjf1ZudK
 O1ihZSSjVWf+ZHP8Z84PyCCK3TbT9AMnSuGyOVkNYJSVvHu/XNXiZfPvxGJ5b6PLFJb5FNHjX
 Nf1EdkcP8TC9VYUf4caJgm3l8E98W6qkv/4BijO1/UJy1yhcOQke9xZDvY+f2pjXqPrDZNCKT
 UksTaEhbcPJfqmfxEf7dh4Ju6ZUcPVEIPZ5iS4DdHyk/HzZZVWxxOWNZHVgjfjizhWb3WDdDm
 5zGlP6fq1XSpMjj7nv072SY6gUiUt9+kMWg8RaYAq8plv6K6FkEkXCt3Ri1jS7/QdJdAXrHiS
 MHhu6XJhwiga/QH6AtD/XWJlJtDya+XEjHIYA4YNSsVrpYNPWEUW4bTStuqFwILOlVPNSwHUf
 MkTp8GRJycF1FISyV2/sfk8mBTYoeSYMVM6rifYyJ5tS3QSZF3nB/Qymr039T7WPsJDvrB7OD
 5eGgaxbNPO4MuytYdi8i8nzCJcvOiKBjF5CeN3fyJDZ3BK8sUrN9iqM9h6jDSAcwNBNNvFRfw
 4/WzDroeJ1UrnRMV8DyDPCA+VQBx7Qh9C1/o5LVbT0KTiP/b0JGaxO7tuR6Ub9UiP4EBQT9X4
 YR8DNKqSGifvXBdblTdTBjPeONd0ZypoEQBFvja2AcoXlgMdKk=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 10:07 PM Saeed Mahameed <saeedm@mellanox.com> wrote:

> V2: - Fix double free due to single allocation of sym expr.
>     - Added a 3rd patch to convert to new keyword treewide.

I've applied on my randconfig test tree, I'll let you know if something
breaks over the weekend, the initial few builds went fine.

       Arnd
