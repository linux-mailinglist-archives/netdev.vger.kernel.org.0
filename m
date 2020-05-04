Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7328A1C3E47
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 17:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729531AbgEDPQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 11:16:23 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:45093 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728684AbgEDPQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 11:16:22 -0400
Received: from mail-qt1-f181.google.com ([209.85.160.181]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MrOq7-1ilFCd3JlX-00oVu7; Mon, 04 May 2020 17:16:21 +0200
Received: by mail-qt1-f181.google.com with SMTP id g16so10264400qtp.11;
        Mon, 04 May 2020 08:16:20 -0700 (PDT)
X-Gm-Message-State: AGi0PuY7Dy0tcYZRe5lO3fJFtrFFxb5fLFN9/bg1a15M1OAKTqOM5xIR
        VbE9j8AIZQdQkreJ8B4ULYNavgDXL1EmESPI9Vc=
X-Google-Smtp-Source: APiQypL5WgUAhbeT4hCo6s57/ai3QBtJeXFaXUuzlX+bmFS85Algr9U95kT2CU1vCl6sA5XuPw/rnlhJ6X2pgdEdJ/U=
X-Received: by 2002:ac8:12c2:: with SMTP id b2mr17657477qtj.7.1588605379427;
 Mon, 04 May 2020 08:16:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200502233910.20851-1-clay@daemons.net>
In-Reply-To: <20200502233910.20851-1-clay@daemons.net>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 4 May 2020 17:16:02 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1m-zmiTx0_KJb-9PTW0iK+Zkh10gKsaBzge0OJALBFmQ@mail.gmail.com>
Message-ID: <CAK8P3a1m-zmiTx0_KJb-9PTW0iK+Zkh10gKsaBzge0OJALBFmQ@mail.gmail.com>
Subject: Re: [PATCH] net: ethernet: ti: Remove TI_CPTS_MOD workaround
To:     Clay McClure <clay@daemons.net>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        kbuild test robot <lkp@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wingman Kwok <w-kwok2@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Andi Kleen <ak@linux.intel.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Dinh Nguyen <dinguyen@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:V8qk58D27ufZzMhxnwD4iHjL4JpQbVrq0pC4GH9P7zw/lls1hfy
 Z9nW9LV7MEeBqqVqOCt1Lg1rVGN5zKlg22Z2WcWOgFG3CQO3aXj6l7cAwOGc4cFn5mBITgB
 RIPpgIHTmMQL5s1gRlwuwsM1rEKdkGDOW0BhOqaWwID0LhSr765B68eFsFWwF2xr/Mq3CmD
 buBXmHa+4qJg/8uJ7FBpQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:tbcwA8OpZ0k=:WGi0zi7PnptrFt0O9QmWzc
 H4mC49I97x4Qm0suvCYZm1vNIy3v7xWLmIfqeT+74cnP8oDKwyVBLFVQWQSBTS1xQFxYDFhlt
 WnjzHLaONPV3EvAtRvYRrpNRnAo2cEbdRi40y+wS7pZHskMLtHogaAng7Tafyl4bqRIhqN9CO
 Mih207YZupHpGD61ghLk0uftARgFAzntwoBYOWBvPgS5ei3olhWmX6FNEc728MA8r10ySmsdh
 MzR23fgu1tV9s/aBl9+luHk/4VRdtca9NqPLWP29tBVjWHBWhtUsUzFPsCS40U3oAv8Nh8qO0
 hfp9skO8dRKHMxsDt8+wIovdPby+EpbwxWTdnlOulb9SV4fJU/KlrSjqmTcoyCVLqzafLyjzz
 cpVlKs+COt6puxOYe1pcUw/CxHnX9FXZXLqApS38PEHXhgMf5xTn+nKb635JbyriVp+3GJ8FH
 S+bLFDP2E2L++2tEDYiI0V7bV6GoeQkOGB62JiCeMfyabUS0H+sd/LkpbTHd3eUJEIFgX8aC3
 qhEPee5zMD5souwtNV0FdVv3TUV6b2GGPvJUAfHMtCgGtpEyoK+PgIbiwa2rYS5qH6xgUbcwA
 kWDeEDOzvH9wkv6p0Ydjl5oc9wHyYXLLOZzfI8P/gZffkuI0a9dD/SPe7I8Ewstqtcprn1cjw
 jnfRIYhhy2OrPYMLrhUWb84CSnQTXDH5cvL4etAEaVro1Krt8QpCHMCK2uOugJHNazqQOxtcp
 3aNCuucy+Qu98Gpa0ddWgm6u7DdlTFUGtlICcjgsJjel2efY3vrR4xdY8EMOZ9LDG2ZFyqhep
 cuPdXjVEV5Bk3WTJh5aZWltLRH6QGQMDhxVJa+4592AhYfGecg=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 3, 2020 at 1:41 AM Clay McClure <clay@daemons.net> wrote:

> To preserve the existing behavior of defconfigs that select TI_CPTS, we
> must also select PTP_1588_CLOCK so that the dependency is satisfied.
> omap2plus_defconfig and keystone_defconfig have not been updated in a
> while, so some unrelated no-op changes appear in the diff.

Please don't do that at all. If you need to add a line to the defconfig file,
add just that line, to avoid merge conflicts and dropping unrelated lines
that have not been caught but need to be preserved in some way
(by enabling another dependency, or renaming the option).

      Arnd
