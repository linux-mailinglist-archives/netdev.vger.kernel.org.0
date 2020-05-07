Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50A821C9D7E
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 23:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgEGVhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 17:37:54 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:51863 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbgEGVhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 17:37:53 -0400
Received: from mail-qv1-f47.google.com ([209.85.219.47]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1N6bHC-1j3f8b023y-01876O; Thu, 07 May 2020 23:37:51 +0200
Received: by mail-qv1-f47.google.com with SMTP id di6so109920qvb.10;
        Thu, 07 May 2020 14:37:50 -0700 (PDT)
X-Gm-Message-State: AGi0PuaP5twFroNwrDBYwPxLU2RKp0S5DWMqIzatJxq2f/f9FIZNHOvs
        vAknHqdriVUsPMHZvHE7zsf9KCknc6XxRDNxI34=
X-Google-Smtp-Source: APiQypIy0ivVXkCT3c5B4I5EgvFGLWa7J/9f8YYkIpCwUCnJWSFZ90o0xiJTmB7TdUw0mxevxdV5Wmq5dREViYtj/Ks=
X-Received: by 2002:ad4:4d50:: with SMTP id m16mr15688068qvm.222.1588887469634;
 Thu, 07 May 2020 14:37:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAK8P3a1m-zmiTx0_KJb-9PTW0iK+Zkh10gKsaBzge0OJALBFmQ@mail.gmail.com>
 <20200504165711.5621-1-clay@daemons.net> <f07c695b-5537-41bf-e4f8-0d8012532f64@ti.com>
 <20200506065105.GA3226@arctic-shiba-lx> <1654101f-9dd7-2e10-7344-0d08e32bc309@ti.com>
In-Reply-To: <1654101f-9dd7-2e10-7344-0d08e32bc309@ti.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 7 May 2020 23:37:32 +0200
X-Gmail-Original-Message-ID: <CAK8P3a07z=kauDKVJzroHyOZ1ZSqpqZA4X69XJ5QCQ4c6JO_pg@mail.gmail.com>
Message-ID: <CAK8P3a07z=kauDKVJzroHyOZ1ZSqpqZA4X69XJ5QCQ4c6JO_pg@mail.gmail.com>
Subject: Re: [PATCH v2] net: ethernet: ti: Remove TI_CPTS_MOD workaround
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Clay McClure <clay@daemons.net>, kbuild test robot <lkp@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        "David S. Miller" <davem@davemloft.net>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:9yXGI+NqB+AOFwl/6L16oGEr+M21Ket9aHWEOHOZ5lCrMDxKb/l
 PLlRan9UoQACO/ySVcQeg/wI8Mya1FO4hH4IJFR0Jw4esTfIpvP2BW+XcrUtVhQsWYOq0NG
 d8p5zDwJZeDNW9DUH1sv+D4ZwyIRlGoeo46TdiEZBRuhRnEZqGijnRts+zpm3c5e+65jQVu
 0MZGaoyoVpGxlufZSPRhw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Fa3joaS3tmg=:rTCt8t7D72VKmYSjJxwcoj
 E5fer22LS1XghS8Ohw1DVVKD20xHzylIr+q1Pi/sc9oqKLebRNspSeFjvj6sG9it2cKiPtJxc
 TG6AuWnX0JRgseQZMo52uIInsS0xfd707boEJZFfAnpqCCwTgytZSPpVcqVK/GSUbDUDmy78Z
 HpVx0/WA2M39gUVnAx/HM3jazyNVe3NLLySj5q6FsuwdCYXVKdVZePAjKUSLQzEaMyvaDNTAC
 bj4JiaoW7jyazrWu1K2OnW1ETul4RzWT8YZTyudr7NzwUaU9IGSKss24ib/dV/6V0Q25q7d33
 tBeu1ujzdFwOQEZA6ct+NiKvsOUcQ4s0Ws8DpLDC7yzdcuml/770tp5NRgjPT4wXu33dduAbZ
 9kG7Fzu3bb2KHdZgAeFBpS82XIJFhBrnqG5RImkDqGv3YEiknJ3r8yhyAT70uPVuP2r9ZoCAB
 z5fWmShFpksYlbHHyE3/0YOcPs/v2HysWGyHSr+n9HBPBvwW4SbXKxcpIcizJ30BMKH6cLMbK
 ZB5EGoOkBHOhgp3xOtKt/DvSfdEcUwSA4Bc/COypB1IcSHaod8/d1+kCvB3q5A2890YTMUGFD
 2gZ1fTDiYZ+a961FqcMo88EwUkNvmtVdIv+6Kb6wyeooIgQCBjS1oo5qmx4vqpRmW/4Us3LsH
 SiKdLw/EOw0hbZNmbPHWZcdqvMea9VkJRDvAFSXmhTPer0Cg+04ge7bK0CwZYSb8Ip1h9NsRm
 +k6M/eE5SFtztnRGS1iP4JRV9ccdM5AFQvDlizTbD3JD36LLWfmbbB7nERQnWn5NYNxwdfKBg
 XriS5/RlIrfzXH2VrCdpsRy56Fn3Kv+SIDl4ChBjQD+3InKnK0=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 6, 2020 at 10:57 PM Grygorii Strashko
<grygorii.strashko@ti.com> wrote:
> On 06/05/2020 09:51, Clay McClure wrote:
> > On Tue, May 05, 2020 at 10:41:26AM +0300, Grygorii Strashko wrote:

> >
>
> Ok. After some thinking and hence you commit b6d49cab44b5 ("net: Make PTP-specific drivers depend on PTP_1588_CLOCK")
> seems was merged in net (not net-next)
> 1) for-net: defconfig changes can be separated to fix build fail, but add change for multi_v7_defconfig
> 2) for-net-next: rest of changes plus below diff on top of it
>
> diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
> index f3f8bb724294..62f809b67469 100644
> --- a/drivers/net/ethernet/ti/Kconfig
> +++ b/drivers/net/ethernet/ti/Kconfig
> @@ -49,6 +49,7 @@ config TI_CPSW_PHY_SEL
>   config TI_CPSW
>          tristate "TI CPSW Switch Support"
>          depends on ARCH_DAVINCI || ARCH_OMAP2PLUS || COMPILE_TEST
> +       depends on TI_CPTS || !TI_CPTS
>          select TI_DAVINCI_MDIO
>          select MFD_SYSCON
>          select PAGE_POOL
> @@ -64,6 +65,7 @@ config TI_CPSW_SWITCHDEV
>          tristate "TI CPSW Switch Support with switchdev"
>          depends on ARCH_DAVINCI || ARCH_OMAP2PLUS || COMPILE_TEST
>          depends on NET_SWITCHDEV
> +       depends on TI_CPTS || !TI_CPTS
>          select PAGE_POOL
>          select TI_DAVINCI_MDIO
>          select MFD_SYSCON
> @@ -78,11 +80,9 @@ config TI_CPSW_SWITCHDEV
>
>   config TI_CPTS
>          tristate "TI Common Platform Time Sync (CPTS) Support"
> -       depends on TI_CPSW || TI_KEYSTONE_NETCP || TI_CPSW_SWITCHDEV || COMPILE_TEST
> +       depends on ARCH_OMAP2PLUS || ARCH_KEYSTONE || COMPILE_TEST
>          depends on COMMON_CLK
>          depends on PTP_1588_CLOCK
> -       default y if TI_CPSW=y || TI_KEYSTONE_NETCP=y || TI_CPSW_SWITCHDEV=y
> -       default m
>          ---help---
>            This driver supports the Common Platform Time Sync unit of
>            the CPSW Ethernet Switch and Keystone 2 1g/10g Switch Subsystem.
> @@ -109,6 +109,7 @@ config TI_KEYSTONE_NETCP
>          select TI_DAVINCI_MDIO
>          depends on OF
>          depends on KEYSTONE_NAVIGATOR_DMA && KEYSTONE_NAVIGATOR_QMSS
> +       depends on TI_CPTS || !TI_CPTS
>          ---help---
>            This driver supports TI's Keystone NETCP Core.
>
> It should properly resolve "M" vs "Y" dependencies between
>   PTP_1588_CLOCK->TI_CPTS->TI_CPSW
>
> On thing, TI_CPTS can be selected without TI_CPSW, but it's probably ok.

I think that solution is reasonable. I had come up with a different
for when I ran
into the build failure, but I like yours better. Here is my patch, for
reference:


commit 94233d78655876f735189890eb40ef33c49e8523 (HEAD -> randconfig)
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Thu May 7 21:25:59 2020 +0200

    cpsw: fix cpts link failure

    When CONFIG_PTP_1588_CLOCK is a loadable module, trying to build cpts
    support into the built-in cpsw driver results in a link error:

    arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw.o: in function
`cpsw_probe':
    cpsw.c:(.text+0x918): undefined reference to `cpts_release'
    arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw.o: in function
`cpsw_remove':
    cpsw.c:(.text+0x1048): undefined reference to `cpts_release'
    arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw.o: in function
`cpsw_rx_handler':
    cpsw.c:(.text+0x12c0): undefined reference to `cpts_rx_timestamp'
    arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw.o: in function
`cpsw_ndo_open':

    Add a dependency for CPTS that only allows it to be enabled when
    doing so does not cause link-time probles.

    Fixes: b6d49cab44b5 ("net: Make PTP-specific drivers depend on
PTP_1588_CLOCK")
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index 4ab35ce7b451..571caf4192c5 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -79,6 +79,9 @@ config TI_CPSW_SWITCHDEV
 config TI_CPTS
        bool "TI Common Platform Time Sync (CPTS) Support"
        depends on TI_CPSW || TI_KEYSTONE_NETCP || TI_CPSW_SWITCHDEV
|| COMPILE_TEST
+       depends on TI_CPSW=n || TI_CPSW=PTP_1588_CLOCK || PTP_1588_CLOCK=y
+       depends on TI_KEYSTONE_NETCP=n ||
TI_KEYSTONE_NETCP=PTP_1588_CLOCK || PTP_1588_CLOCK=y
+       depends on TI_CPSW_SWITCHDEV=n ||
TI_CPSW_SWITCHDEV=PTP_1588_CLOCK || PTP_1588_CLOCK=y
        depends on COMMON_CLK
        depends on POSIX_TIMERS
        ---help---
