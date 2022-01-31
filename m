Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC7EC4A4E54
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 19:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356050AbiAaSbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 13:31:15 -0500
Received: from mail-qv1-f53.google.com ([209.85.219.53]:46982 "EHLO
        mail-qv1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350610AbiAaSbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 13:31:14 -0500
Received: by mail-qv1-f53.google.com with SMTP id o9so13594767qvy.13;
        Mon, 31 Jan 2022 10:31:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tAq3Aw1ybEeRSqT/qCBaoBSWDhM07pp4fGD0hDfaeXE=;
        b=2QDsW5SuXyhmGB5cv8ZmX9skjTH/M49/cHeOcwnPvrfZLhwwqwaKTU4XWblXcEnJSG
         8uDjjTgbRAYo4QxbioNFGGqsLZzPDgpVuKCJej7bURZ3Z/3uttqY8E7RoFBT129xQGf+
         XHHN/QF+c29yu6zhc05aFQ2iypz4Ci0tQiMZYp8Z4UCfs8ZVeVXwI+lHaE1fs/RHRw+8
         RASZCcdLpHgySwb7Kigjvxnmmi8HTJKoJqrmyZeYFnO6ylRKbUH83ZwSVFJ5/CcvfFLB
         FMjXjT2C9YTyfF4/3tBX2L/CdLLjLy8jfTPXvOYSBRgB+DB2Gj5ULKibQpRm7SlSNBoD
         IcLg==
X-Gm-Message-State: AOAM5300Q5dPHAsp5rirDcRcHZ9DGK2Sx3QaJ9vRM5n3Zj4JAITYMzKE
        2+uaBR59/p4DoLgJld6AF+eIZTGooW+bt2nV
X-Google-Smtp-Source: ABdhPJzq3enqzJRFLnEFxdmRVXs7d2EFm9ZdR0EM+sF3t6B/7H7vYeqs0ppP1jup2uQa0T66JLyLlA==
X-Received: by 2002:a05:6214:d0c:: with SMTP id 12mr19148531qvh.93.1643653873140;
        Mon, 31 Jan 2022 10:31:13 -0800 (PST)
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com. [209.85.219.179])
        by smtp.gmail.com with ESMTPSA id s14sm8459533qkp.79.2022.01.31.10.31.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 10:31:12 -0800 (PST)
Received: by mail-yb1-f179.google.com with SMTP id c6so43286968ybk.3;
        Mon, 31 Jan 2022 10:31:11 -0800 (PST)
X-Received: by 2002:ab0:44c:: with SMTP id 70mr9021725uav.78.1643653861178;
 Mon, 31 Jan 2022 10:31:01 -0800 (PST)
MIME-Version: 1.0
References: <20220131172450.4905-1-saeed@kernel.org> <20220131095905.08722670@hermes.local>
In-Reply-To: <20220131095905.08722670@hermes.local>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 31 Jan 2022 19:30:48 +0100
X-Gmail-Original-Message-ID: <CAMuHMdU17cBzivFm9q-VwF9EG5MX75Qct=is=F2h+Kc+VddZ4g@mail.gmail.com>
Message-ID: <CAMuHMdU17cBzivFm9q-VwF9EG5MX75Qct=is=F2h+Kc+VddZ4g@mail.gmail.com>
Subject: Re: [PATCH net-next] net: kbuild: Don't default net vendor configs to y
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
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
        Shannon Nelson <snelson@pensando.io>, drivers@pensando.io,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Jiri Pirko <jiri@resnulli.us>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Rob Herring <robh@kernel.org>, l.stelmach@samsung.com,
        rafal@milecki.pl, Florian Fainelli <f.fainelli@gmail.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Chan <michael.chan@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Gabriel Somlo <gsomlo@gmail.com>,
        Joel Stanley <joel@jms.id.au>, Slark Xiao <slark_xiao@163.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
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
        Gary Guo <gary@garyguo.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev, intel-wired-lan@lists.osuosl.org,
        linux-hyperv@vger.kernel.org, oss-drivers@corigine.com,
        linux-renesas-soc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 6:59 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
> On Mon, 31 Jan 2022 09:24:50 -0800
> Saeed Mahameed <saeed@kernel.org> wrote:
>
> > From: Saeed Mahameed <saeedm@nvidia.com>
> >
> > NET_VENDOR_XYZ were defaulted to 'y' for no technical reason.
> >
> > Since all drivers belonging to a vendor are supposed to default to 'n',
> > defaulting all vendors to 'n' shouldn't be an issue, and aligns well
> > with the 'no new drivers' by default mentality.
> >
> > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
>
> This was done back when vendors were introduced in the network drivers tree.
> The default of Y allowed older configurations to just work.

And changing the defaults means all defconfigs must be updated first,
else the user's configs will end up without drivers needed.

> So there was a reason, not sure if it matters anymore.
> But it seems like useless repainting to change it now.

It might make sense to tune some of the defaults (i.e. change to
"default y if ARCH_*") for drivers with clear platform dependencies.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
