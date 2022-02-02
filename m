Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D04D4A761D
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 17:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345972AbiBBQlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 11:41:49 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:48325 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233527AbiBBQls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 11:41:48 -0500
Received: from mail-yb1-f181.google.com ([209.85.219.181]) by
 mrelayeu.kundenserver.de (mreue109 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1M7sQ8-1nAKtM24nq-0054CK; Wed, 02 Feb 2022 17:41:46 +0100
Received: by mail-yb1-f181.google.com with SMTP id w81so230109ybg.12;
        Wed, 02 Feb 2022 08:41:46 -0800 (PST)
X-Gm-Message-State: AOAM531DRrf08nEE9DAXs9TXwDwxD5R9zuOtmpMARhK34ngl7PXfVPbl
        JZjOCRPPUhhApICfv70yDr/1QlhRQ2GrsdMyAWA=
X-Google-Smtp-Source: ABdhPJz2O/9Dqb43FQaFEs2fgdQ11r4WChyB6XAjTgMFNwZoBX1IgqEBVLSxxOha4gVbBN3Qpzy/vvWlFqfDO4Fo+i8=
X-Received: by 2002:a05:6830:33c2:: with SMTP id q2mr16651474ott.368.1643815893880;
 Wed, 02 Feb 2022 07:31:33 -0800 (PST)
MIME-Version: 1.0
References: <30ed8220-e24d-4b40-c7a6-4b09c84f9a1f@gmail.com>
 <20220131121027.4fe3e8dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <7dc930c6-4ffc-0dd0-8385-d7956e7d16ff@gmail.com> <20220131151315.4ec5f2d3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <dd1497ca-b1da-311a-e5fc-7c7265eb3ddf@gmail.com> <20220202044603.tuchbk72iujdyxi4@sx1>
 <20220201205818.2f28cfe5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20220202051609.h55eto4rdbfhw5t7@sx1> <8566b1e3-2c99-1e63-5606-aad8525a5378@csgroup.eu>
 <20220202064950.qyomo7ns27mbedds@sx1> <20220202151707.GA2365@hoboy.vegasvil.org>
In-Reply-To: <20220202151707.GA2365@hoboy.vegasvil.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 2 Feb 2022 16:31:17 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3ZGFBmxUWm5-DT_QfvU0k8HViEbV4zhwwC8FJLMKZTYg@mail.gmail.com>
Message-ID: <CAK8P3a3ZGFBmxUWm5-DT_QfvU0k8HViEbV4zhwwC8FJLMKZTYg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: kbuild: Don't default net vendor configs to y
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Einon <mark.einon@gmail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Chris Snook <chris.snook@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jeroen de Borst <jeroendb@google.com>,
        Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Jon Mason <jdmason@kudzu.us>,
        Simon Horman <simon.horman@corigine.com>,
        Rain River <rain.1986.08.12@gmail.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        "drivers@pensando.io" <drivers@pensando.io>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Jiri Pirko <jiri@resnulli.us>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Rob Herring <robh@kernel.org>,
        "l.stelmach@samsung.com" <l.stelmach@samsung.com>,
        "rafal@milecki.pl" <rafal@milecki.pl>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Chan <michael.chan@broadcom.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Gabriel Somlo <gsomlo@gmail.com>,
        Joel Stanley <joel@jms.id.au>, Slark Xiao <slark_xiao@163.com>,
        Liming Sun <limings@nvidia.com>,
        David Thompson <davthompson@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Omkar Kulkarni <okulkarni@marvell.com>,
        Shai Malin <smalin@marvell.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Gary Guo <gary@garyguo.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-sunxi@lists.linux.dev" <linux-sunxi@lists.linux.dev>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "oss-drivers@corigine.com" <oss-drivers@corigine.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:ZQ7YVbNOA3ijeCFuYuwaryPOvD4+23Ued8C+mXh3hFmrSPPkufX
 BafSlefdo6abOSK03UqoZpBA9TGMQcbsiULKoTP7xGwBtiO9YS4R4dgVUtLLbE6P2wJH1FD
 mtvYJIiyZkSwkbR06T1tODhOBZNAdRn4RUH4FYhKniYMYOK5/FtFn3EoE7nWgUbSnxaWJtL
 pshO0/rC/WN/zkL9XXpBw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:KNkpdbsaUjI=:Zq58Dacjs4Y2sUUz9C6CEU
 COPlIZtGJJUULjqIqK1UEoPTJLYcqo1OWLJGj6Kfq/k23bHwVtzB0Y0GEboC2wBifwQiK2VEv
 whrZvQPorXJeachAuH6iTb2+CVm8823GJl9OYpKQD8vwFbl0V6+gagQte73thTBBTi42KNSLU
 VOjMZXAW6ZsMMMsAoga3Nhrv+Z2lkKkreQF4fVIPP1v2xm00k/X3JCmaPE8ksC62bcRvPUHfL
 ImBL3Q2cVg4E1cxCeUZfGvX7S3bB8S6ue2NTIC0iXgUyqLitX3swU30lFR5wpI6tPZTQHiZ//
 2Cfj0Na0AjX8PH/l3QlzaibRfo2/KzLXVootC/1DLl2pwF47wJRu88ScsvsHsvfBix3ZGBTXE
 txllgCbFgf83LqxI0g+hkBmLSRGDCxq+DQGRweHRsbbAJzcamZAL3JocWWe1NZmcyL8q9UbSi
 7Ie3nGz11RRw0W/vxxVwqXsXsBLz3mTQ9J0EZou0/6z/HA37RWDJgYrOi1kenYbt9v18BNZpO
 13hIjOn9EngAcGzL/ZmLJNAGVUP+yjJbkcRFv9rzSDnOl8I+b1refkvrE7udTCnkfAUqQTJAL
 2h/9Z6QUlUZxoq2lqyUezta/1sbWlUif5q+JfkOfp3IorCDWiuij7jcpNh0VtTdAy42FQKFHX
 ZSrpNG0ev+0pGMm2u/0iyt1NHT8P6Y8hDXndYhqQfgAOGcrIYAxg/2n9BVAEtlkNzjqW7Kx/j
 xxCFag3Wr3LnkvK0J7JckFX2JEfgJQslPz8uIolAnXt8aryH+PILM+ZMN6QSUBbE6bl0vIxda
 SY8MmZ787IbSxMdwOJZZDVlmOd84wt70pxbWoimNvqcNbuajyYINa8mxRYMJP5CLCCFzmc0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 2, 2022 at 4:17 PM Richard Cochran <richardcochran@gmail.com> wrote:
>
> On Tue, Feb 01, 2022 at 10:49:50PM -0800, Saeed Mahameed wrote:
> > I can't think of a clever easily verifiable way to map boards to their VENDORS.
> > Add to that dispersing the VENDORS configs accurately.
>
> Just an idea...
>
> 1. make foo_defconfig
> 2. for each vendor, do scripts/config --disable vendor
> 3. make savedefconfig
> 4. compare defconfig with foo_defconfig
>    difference means some MAC was removed

This needs an extra 'savedefconfig' step in the beginning, as a lot of
the defconfig
files are already different from what you get after savedefconfig, both in the
order of options, and in options that got renamed or removed over time.

         Arnd
