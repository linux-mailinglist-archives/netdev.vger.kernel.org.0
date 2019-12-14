Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6C3A11F40B
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 21:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfLNUto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 15:49:44 -0500
Received: from mout.kundenserver.de ([212.227.126.133]:43833 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbfLNUto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 15:49:44 -0500
Received: from mail-qv1-f42.google.com ([209.85.219.42]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MY5XR-1iCEjz3uJR-00YTdo for <netdev@vger.kernel.org>; Sat, 14 Dec 2019
 21:49:43 +0100
Received: by mail-qv1-f42.google.com with SMTP id l14so545353qvu.12
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 12:49:42 -0800 (PST)
X-Gm-Message-State: APjAAAUaQ9k768y+0J52YV9r0AJ6hFMGhqi8x5nvh7rUYMeodw11ZE/A
        JUJsqFQNVks/7bltc6wNSnpEiBkqPmvrtZZBfHI=
X-Google-Smtp-Source: APXvYqzJlLUF7MWn60BUT4kK3gp8XwjCtTx7yyp/Q8aat+59lR8PB0ptwD7Bx8IryMM8DcuTg7iqYlPU94fYl1DA9M4=
X-Received: by 2002:a0c:aca2:: with SMTP id m31mr19914980qvc.222.1576356581826;
 Sat, 14 Dec 2019 12:49:41 -0800 (PST)
MIME-Version: 1.0
References: <20191212171125.9933-1-olteanv@gmail.com> <CAK8P3a1PBa0bcfmPnVGry-6GUQ0WTLJ36MAE89QWXzbnuEf_XQ@mail.gmail.com>
In-Reply-To: <CAK8P3a1PBa0bcfmPnVGry-6GUQ0WTLJ36MAE89QWXzbnuEf_XQ@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Sat, 14 Dec 2019 21:49:25 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0EM0MOsgdCVHS7gPxLk2nvP4Xqs4_tmtPM4Da=M5ZUQA@mail.gmail.com>
Message-ID: <CAK8P3a0EM0MOsgdCVHS7gPxLk2nvP4Xqs4_tmtPM4Da=M5ZUQA@mail.gmail.com>
Subject: Re: [PATCH] net: mscc: ocelot: hide MSCC_OCELOT_SWITCH and move
 outside NET_VENDOR_MICROSEMI
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Mao Wenan <maowenan@huawei.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        yangbo lu <yangbo.lu@nxp.com>,
        Networking <netdev@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:XSnj6rspf5Cspmgs6AbMZs3vmlJbVwnH6dbTiLu5bmuOrY03064
 jTJldtvm5rDESmplDiaYeY8DlEXIchMTR81/oMCI5p/R4Edfz6uLN6s6oYGmSgR3TL1IHYY
 Tg2+fqsS2jC4ueFViEaMrXCKiHlj+ow6csKeRyoyzsJf292vtgwY2OiQ0Sy2ADkbldv7txl
 7P+zY7QQ/NOz8hGANpIoQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:m2AlT2KzD58=:6boU//eE4VgftCNF481qLJ
 BZb0aWTrQAewdbgw9fk1PQ0glRenzmUXMb57KzYUps7zvVnhTf3Kq8VrmYBTdm9Z3FWrybfZC
 9bqHTvgv9RKsX7BaZ/P1W3lYfIvJQEuWH4stYys/3WS1r2CmPd6n/2do16/2zLxP8/mjGim8J
 yt+QjV5/uf9DibRceTVFRGuOkGmjqNO6Da+TLVQICpBN3GKq+Mqz+LJnYr4qnlJylyOyf46JY
 /LzTkNzN942Fn2x5lSpFyg5Tgec1dH3Ubun4NNEGVF9uk+8jXH5D9sy9wQsm3bgELiI8dt+sm
 I1NghNfW3974wVo4hRibrM0l0WJZYJm9deFxSBUeT3nryKlAdIomCuNzKcWlDOdHYTw61EL9l
 cBkLvpbqTf+DVjp/h5qG2efy5aiidF3cwXuwZp/S3cLZXVZNPNKup0d7rkEtbkx5KLqOsdYpj
 oOaQH7ON1Sw7CJWn7H2TqOc2yapixT/NLQlIF93rfsMolZLOzcNTgRed+DxtyMXwMspVnJeY0
 8u0Wi251Bvjvr9ttRysJP+JxjenHWsiGRMIo5FJf7K6upmczFgUp1wMCkfPPE9mXmquld8BAv
 F1BkftUJkVFw8tEhrtm4YniMI513FNTkXOTk0INTUeYEsw/kPVD75y7VxX4LXWR26eCMq0xMU
 CACNqzzovrY5ipuzL6oyeImjbQ4RDiwwuRW+5FfLQPjhIAsF2Eehvc4MPc0F7+LzYbvhAdO77
 zfNTEjD9rEblidrVe55AsEDaXwgdbsRhaonnGUmjb9XAp+FsvJyNBJkZq0NZdTaY12WUioiLi
 o92CgjUjuqCaelWSWKKh6SoA0OyJFj1Yyl4l2Hf+Rj2xwRuiMGXNQRIsFykIyGsYJPMXm+vL3
 U06VqIzKhsysHQzUm9/A==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 14, 2019 at 4:16 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Thu, Dec 12, 2019 at 6:11 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > NET_DSA_MSCC_FELIX and MSCC_OCELOT_SWITCH_OCELOT are 2 different drivers
> > that use the same core operations, compiled under MSCC_OCELOT_SWITCH.
>
> > Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")
> > Reported-by: Arnd Bergmann <arnd@arndb.de>
> > Reported-by: Mao Wenan <maowenan@huawei.com>
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> I did some more build testing and ran into another issue now that
> MSCC_OCELOT_SWITCH_OCELOT can be built without
> CONFIG_SWITCHDEV:

And another one when CONFIG_NET_VENDOR_MICROSEMI is disabled:

ERROR: "ocelot_fdb_dump" [drivers/net/dsa/ocelot/mscc_felix.ko] undefined!
ERROR: "ocelot_regfields_init" [drivers/net/dsa/ocelot/mscc_felix.ko] undefined!
ERROR: "ocelot_regmap_init" [drivers/net/dsa/ocelot/mscc_felix.ko] undefined!
ERROR: "ocelot_init" [drivers/net/dsa/ocelot/mscc_felix.ko] undefined!
ERROR: "ocelot_fdb_del" [drivers/net/dsa/ocelot/mscc_felix.ko] undefined!
ERROR: "__ocelot_write_ix" [drivers/net/dsa/ocelot/mscc_felix.ko] undefined!
ERROR: "ocelot_bridge_stp_state_set"
[drivers/net/dsa/ocelot/mscc_felix.ko] undefined!
ERROR: "ocelot_port_vlan_filtering"
[drivers/net/dsa/ocelot/mscc_felix.ko] undefined!
ERROR: "ocelot_get_ethtool_stats"
[drivers/net/dsa/ocelot/mscc_felix.ko] undefined!
ERROR: "ocelot_port_enable" [drivers/net/dsa/ocelot/mscc_felix.ko] undefined!
ERROR: "ocelot_vlan_del" [drivers/net/dsa/ocelot/mscc_felix.ko] undefined!
ERROR: "ocelot_deinit" [drivers/net/dsa/ocelot/mscc_felix.ko] undefined!
ERROR: "ocelot_init_port" [drivers/net/dsa/ocelot/mscc_felix.ko] undefined!
ERROR: "ocelot_fdb_add" [drivers/net/dsa/ocelot/mscc_felix.ko] undefined!

This fixes it:

diff --git a/drivers/net/ethernet/Makefile b/drivers/net/ethernet/Makefile
index f8f38dcb5f8a..83351228734a 100644
--- a/drivers/net/ethernet/Makefile
+++ b/drivers/net/ethernet/Makefile
@@ -55,7 +55,7 @@ obj-$(CONFIG_NET_VENDOR_MEDIATEK) += mediatek/
 obj-$(CONFIG_NET_VENDOR_MELLANOX) += mellanox/
 obj-$(CONFIG_NET_VENDOR_MICREL) += micrel/
 obj-$(CONFIG_NET_VENDOR_MICROCHIP) += microchip/
-obj-$(CONFIG_NET_VENDOR_MICROSEMI) += mscc/
+obj-y += mscc/
 obj-$(CONFIG_NET_VENDOR_MOXART) += moxa/
 obj-$(CONFIG_NET_VENDOR_MYRI) += myricom/
 obj-$(CONFIG_FEALNX) += fealnx.o

        Arnd
