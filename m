Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C58B1CA7F9
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 12:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbgEHKKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 06:10:52 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:56515 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgEHKKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 06:10:52 -0400
Received: from mail-qt1-f181.google.com ([209.85.160.181]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MjPYI-1irriC0HE2-00kyVw; Fri, 08 May 2020 12:10:50 +0200
Received: by mail-qt1-f181.google.com with SMTP id x12so768596qts.9;
        Fri, 08 May 2020 03:10:49 -0700 (PDT)
X-Gm-Message-State: AGi0PubM1AJMs2SPzyREk1dNDm+Ef132FiQbX3qxneCk/+n8pwUXM/1B
        /NCWZJreM5ihguzXpz/DaSDEkiNR55Y10MPCzx8=
X-Google-Smtp-Source: APiQypIExSSlqA8yisz6W2ZLVMPQ/wADq+SWrAtp8zPZ88mwmRPwDsgp08zt9Fp0MCbGchCGJqbxIfTbLpDmW0GLnAY=
X-Received: by 2002:ac8:2bce:: with SMTP id n14mr2162626qtn.18.1588932648766;
 Fri, 08 May 2020 03:10:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200508095914.20509-1-grygorii.strashko@ti.com>
In-Reply-To: <20200508095914.20509-1-grygorii.strashko@ti.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 8 May 2020 12:10:32 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0qfFzJGya-Ydst8dwC8d7wydfNG-4Ef9zkycEd8WLOCA@mail.gmail.com>
Message-ID: <CAK8P3a0qfFzJGya-Ydst8dwC8d7wydfNG-4Ef9zkycEd8WLOCA@mail.gmail.com>
Subject: Re: [PATCH net v3] net: ethernet: ti: fix build and remove
 TI_CPTS_MOD workaround
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Clay McClure <clay@daemons.net>, Dan Murphy <dmurphy@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:+qrP48GYxWtsysT2SpoHntkSQ4zxwhAWRpqIiuLA9lj+qKiLLvF
 7K2NZFCXh9TEslfE98abhA93G+YP2CAYgvW5CQSXWaFhydtbdGyHpZqloKPsSleDbc1ULJL
 kxfuR9A645lLHahWvsUoOuCJ7UEvM6z/QgJSuNn2HvBukic1DJjfT9ZrzcMyly2EygNY/NB
 H+BBvitw01j3BDekVWuhA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:EPX1zmu9EZs=:b66kWz7wlyXK8CaGzsC5R1
 OIJTXQHxeIZjq9yFwdzgGaAYvKFtHDJMCyTkNvM2Z4lGddGAzWjUwuimCudzObZlYmXXd/vEM
 cj+wcjVNLKTDljX7LhMayi7QgmZOJOqflSlPu8fVkL4iue4+X86SMe7O+fYyEB7orCaXhbtkd
 ukKIngEA/BB62XP5L+osCwcTnoSsDzYPBVCf5Me4hAVhSi0TX27tl7VfsQD/OG02ZaW7dbrJ9
 YZHS0V7S9VWxFRfSDQxUnxTHzrL/MjyNPTzTH3O9fLE5IdXs+OaxbcaaiHSxjDSvpUk+34/di
 WtIoJfl6VG6EySx7jlI4t5WAC65VC0DlH/7h3cvpK7EtTa4DkfGuE/0O3soZdKT1hZeBl1FaL
 wDl9qLUVzP7YUNhXO0iMtBeQ8Wt9GQcV7q9eXMbefuB52mAtbvUGY6ASfSpsCp8LhzvBoFV8q
 zz+XppeWGE2MQHAHscK9mNnRnJ/clKjjfibr2zVgUkaguTNhxuQDGSRMiHXFNxkdtDmUaA2Pz
 +cNiRJclP/3EUxjK1+9czlk966qDK1gVJcfx/yT+DP/DSa7FPkjik81Cn+99vrsiDR0j/aQnO
 OYGmLYBeBdnsRxBauMO+yubSuwQ+W94NdX2u8NCK0ypGQTOFdlgv+TMscQUY7slnZjdi1vw7j
 Q6ixFZ+c9NpkfkMiW85Nv+GmQQKy9GFJ7x8y9x29PmQwNQZOWFhrwVT8f9YiAIimtBumgv+ZG
 6jUYkH6h4MznC1xflf0+Vjl4+56yTRma/BaAHqZ80isUc6OkhBPszNGwdmDBUgr7m9dKAlWUi
 pEkf3zMa+MxDoMVtCGkvkLf7DXcGozFP66hNJBA8I1nnCHXJgU=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 8, 2020 at 11:59 AM Grygorii Strashko
<grygorii.strashko@ti.com> wrote:
>
> From: Clay McClure <clay@daemons.net>
>
> My recent commit b6d49cab44b5 ("net: Make PTP-specific drivers depend on
> PTP_1588_CLOCK") exposes a missing dependency in defconfigs that select
> TI_CPTS without selecting PTP_1588_CLOCK, leading to linker errors of the
> form:
>
> drivers/net/ethernet/ti/cpsw.o: in function `cpsw_ndo_stop':
> cpsw.c:(.text+0x680): undefined reference to `cpts_unregister'
>  ...
>
> That's because TI_CPTS_MOD (which is the symbol gating the _compilation_ of
> cpts.c) now depends on PTP_1588_CLOCK, and so is not enabled in these
> configurations, but TI_CPTS (which is the symbol gating _calls_ to the cpts
> functions) _is_ enabled. So we end up compiling calls to functions that
> don't exist, resulting in the linker errors.
>
> This patch fixes build errors and restores previous behavior by:
>  - ensure PTP_1588_CLOCK=y in TI specific configs and CPTS will be built
>  - use IS_REACHABLE(CONFIG_TI_CPTS) in code instead of IS_ENABLED()

I don't understand what IS_REACHABLE() is needed for once all the other
changes are in place. I'd hope we can avoid that. Do you still see
failures without
that or is it just a precaution. I can do some randconfig testing on your patch
to see what else might be needed to avoid IS_REACHABLE().

        Arnd
