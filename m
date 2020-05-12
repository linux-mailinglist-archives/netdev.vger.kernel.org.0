Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4681CF223
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 12:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729377AbgELKJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 06:09:14 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:50527 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbgELKJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 06:09:13 -0400
Received: from mail-qk1-f171.google.com ([209.85.222.171]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1N2EHo-1j6RLc3bMU-013hDb; Tue, 12 May 2020 12:09:11 +0200
Received: by mail-qk1-f171.google.com with SMTP id c64so12898336qkf.12;
        Tue, 12 May 2020 03:09:10 -0700 (PDT)
X-Gm-Message-State: AGi0PuZtGYkCzvW9ze2IebpkH+6reCMNOgelB0BrJK+xQSby4JXg6h3r
        IZNad6i5enzSHfnpgxTYPOT9tDAX4cxl1SaIEVk=
X-Google-Smtp-Source: APiQypKTcYyt4ixMf5aDlkcKt9IM/Lo13Ipwd2SLsjuT2wZJl/fy1N14jRioNhjHMVCLeyhQ3hFMj+jJEn4RCCuW56E=
X-Received: by 2002:a37:434b:: with SMTP id q72mr19292048qka.352.1589278149549;
 Tue, 12 May 2020 03:09:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200512100230.17752-1-grygorii.strashko@ti.com>
In-Reply-To: <20200512100230.17752-1-grygorii.strashko@ti.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 12 May 2020 12:08:53 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1atn3x6zntqPWpGwuLtujysTRFp+fvD-rbkddFBaA0ZA@mail.gmail.com>
Message-ID: <CAK8P3a1atn3x6zntqPWpGwuLtujysTRFp+fvD-rbkddFBaA0ZA@mail.gmail.com>
Subject: Re: [PATCH net v4] net: ethernet: ti: Remove TI_CPTS_MOD workaround
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Clay McClure <clay@daemons.net>, Dan Murphy <dmurphy@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:gheQcQvXwyjMMR/JGpoKJf1MrgvzSyuZDvU+J5olOEhdbHFmEVe
 CBrTLi4kJW6LdvUUl7+tFaVkENO9k6pMRpr8xETahrFAcZ38hLq/dvgilFn+NCD73wGC4LF
 Fz+yVz0gycBUlgZDR0Vc/urLoMaGd9NpF0NdRsuvwi5+l38mk3y8nT0GSUD6p7sqWDbz2te
 hAF5pzaiJY0hEXNhcudyA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:nmHlNLNXEqQ=:uT7tBxew1Odw+95rcho8n3
 jxmZIuuWTIFlqaQrTxLk3Vri1fwmYYhXjeeYoSGb4I0RzY2SKoU3/d1G5GVLsI+zu4gkBTrPP
 dtN4zNLQieZlhRR6F95xCMo5RFfSk5rpKbmZ6k5zJPga89XsE+2nbzdXHj6VDXB+w6BadQZMv
 mrJjW5PZaDXX1oZBh3qHJmHS08BgqU4iDHSunsskFu2p4njWv5N+1LeRr0hUOcwzQPEFtglSQ
 ZLPS5oh0ZJknIMgB0fy5IPxFuWr0P5vwzu2/OKDUKs1yje71nPE1ofyr834oteXkFDoDmKVpv
 kbdQikBDh+r+HOoHijsyzMdjyEtgoDnxawnqNetF+ePukdNRXpHMNS78bpOXgCQNYjckJCUvX
 5MgnZOmhGWhVJwxIO+AUSOkT/iOtcUmDxbj74UurKapAQHUIt4EYavLsfySpOWsBiXIjAYylG
 8sc0frlopCGT6m/jAtI8II0Z+Cd+Yj06yu1RGn6HZIh856loS+G4notd1F9xeeKqCOD/Lhbl4
 A7ci58XBaGLsA7oA7uZmFb7Z9eBf3nA9/mUr7FxslOe1EhpW9Sy3xnEuDq7Q/NM25DrWSp+l2
 Lt/9I1mQosC006IMGo9R6nLtSmNlPQvwgoSTyAXk3/d8Ubykbr6FYIovbViXLCoxmdbiNPyGz
 jRSGNmlinZ0add5lPS9b89p5cDfNlhRrjABH8yppsSuHvAOa79HXa0RH2nJbpbE5ZNOxieCAd
 SUJq9MAIwaW4GG3IBk+OC2g5xUGjL3MdWI5jUdm1AZJRp8N2FHxFhypR92O4ZIKxAxqvIYQy3
 1OllSvTRGSDhejtGc7o9m59LhrpwA4ch/pdE84Y76L8chkOHQk=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 12:02 PM Grygorii Strashko
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
>  - remove TI_CPTS_MOD and, instead, add dependencies from CPTS in
>    TI_CPSW/TI_KEYSTONE_NETCP/TI_CPSW_SWITCHDEV as below:
>
>    config TI_CPSW_SWITCHDEV
>    ...
>     depends on TI_CPTS || !TI_CPTS
>
>    which will ensure proper dependencies PTP_1588_CLOCK -> TI_CPTS ->
> TI_CPSW/TI_KEYSTONE_NETCP/TI_CPSW_SWITCHDEV and build type selection.
>
> Note. For NFS boot + CPTS all of above configs have to be built-in.
>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Dan Murphy <dmurphy@ti.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Fixes: b6d49cab44b5 ("net: Make PTP-specific drivers depend on PTP_1588_CLOCK")
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Clay McClure <clay@daemons.net>
> [grygorii.strashko@ti.com: rewording, add deps cpsw/netcp from cpts, drop IS_REACHABLE]
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
