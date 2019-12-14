Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE5C11F264
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 16:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfLNPRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 10:17:15 -0500
Received: from mout.kundenserver.de ([217.72.192.75]:50751 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbfLNPRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 10:17:15 -0500
Received: from mail-qk1-f175.google.com ([209.85.222.175]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MDy9C-1iWD0A0pQC-00A28h for <netdev@vger.kernel.org>; Sat, 14 Dec 2019
 16:17:14 +0100
Received: by mail-qk1-f175.google.com with SMTP id z76so1761312qka.2
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 07:17:14 -0800 (PST)
X-Gm-Message-State: APjAAAV+N0vjKA3UW4qPVIT83Ng9yoH+7cipd4DhzkXJh4UvP3coLSnu
        raBO0hhTqhSiu39yjuhpfV4nq5JLLDcuBqGLSWI=
X-Google-Smtp-Source: APXvYqzxeWzQv5rYazLvcBNQABh3fsXIww78G/F3NFHy0y1jXgzEyo9+pIqbjsBHpNJ8pbSqYTr9QcLysu0BdMQ7i6I=
X-Received: by 2002:a37:4e4e:: with SMTP id c75mr18384162qkb.3.1576336633071;
 Sat, 14 Dec 2019 07:17:13 -0800 (PST)
MIME-Version: 1.0
References: <20191212171125.9933-1-olteanv@gmail.com>
In-Reply-To: <20191212171125.9933-1-olteanv@gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Sat, 14 Dec 2019 16:16:56 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1PBa0bcfmPnVGry-6GUQ0WTLJ36MAE89QWXzbnuEf_XQ@mail.gmail.com>
Message-ID: <CAK8P3a1PBa0bcfmPnVGry-6GUQ0WTLJ36MAE89QWXzbnuEf_XQ@mail.gmail.com>
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
X-Provags-ID: V03:K1:0y1wzDjwqK4zF8QLHV1NBZNPuqLqLXyjAqzsaCOxPvWhLp3HtjG
 qaImHS/MNcEMLqVRBM4AduQBIkO7X9NxEO6kxpW71fnzXqJesoELUWP3DUuMH+gi0q9dTrx
 X6osLsYce6eyPdW5ZeXkszpHXmTMVgMMhtQKwJbCKVNUj1Mi8Yv/dAuuKCs2U1ggkdKINW/
 X5Zuz5/z8uvz8HzctUIuQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:1BFeOTFeWdQ=:DYC6rl65KFTRlr2Aio53Md
 3lNDN/V6fsaz92IzJLkqswrz406bMxXnTVJATrV9u7FqXxTLFu5egf8N68KpXCo4IaLLX0p3d
 MEAZoT5gRKBlnfKrPvS9344O+csSQyx5txjnIQfWF+xwmzD6n39nEl+sdD0A3xEHMTz+cxHjC
 QKy59Se85nKvSYscKRCjezzNSPp0POYkDj1J8YpM/QtrQrR0dq3tlTMsyMYDv+Pi1tioUTtpQ
 5j/SW8UYvLMj8tLsT5sL1i5LBb+r/Rvzy8oz6q7hkqrft40bvm6N1QiWxaf59m+vBta1o8eBZ
 i+5+se8qXyOHiYIgUWWLnnqSNiOd87rmCIqUYeVOjN4H97PR3/NHY4lxCVeBzPEo3P9Mg2Ww7
 fT3ah82B1pvKHKaSsq0yhZTD6H3YfOjt/EHoLpjTUqo2tl/Ry6ZfzC9iNt3tdOXZTfZQ+HWyN
 gu1/WGAdji90JKc8bl5ujPfoVoE72z7lCecUB+Z1LZizc0/lXgorW+IErU0geNShewsj/TO9y
 G4NplC3+Ou9iE8gZMrq47ko1osW6VCc9lsP6rfgzC99GrSbB5TaWJlvD8HmEjo/nbr0KJBT/i
 7AM0L/hdNu6g2KX2CCGq/XcfX97AVTn8JuDQaX7C3DJ8IDE87qtw5GuIEaQ+9ThBKrx++srNt
 dEsyE2FbogAR3SnwpJqAmunR8pRxoWKNjpWa+8LURlXQFTAgBGnje96V6gXXEJUTm3U6UnSXP
 kL1JfsdgcvrufLIyPtGd6Nu1LIFlUteg85+liwYcnSHRlqo3dYDXlhy1NlR9NJ8ArVw3YTC3i
 R0nDCpk52miB3okOrXrGVhYP6VZrFA6Dv1cXuhorCSOqnIlzZY+B9gCAORz4X6qLmP1QdPK/T
 eVm8x9jLq0tlV0Ty4Dqg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 6:11 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> NET_DSA_MSCC_FELIX and MSCC_OCELOT_SWITCH_OCELOT are 2 different drivers
> that use the same core operations, compiled under MSCC_OCELOT_SWITCH.

> Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Reported-by: Mao Wenan <maowenan@huawei.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

I did some more build testing and ran into another issue now that
MSCC_OCELOT_SWITCH_OCELOT can be built without
CONFIG_SWITCHDEV:

WARNING: unmet direct dependencies detected for MSCC_OCELOT_SWITCH
  Depends on [n]: NETDEVICES [=y] && ETHERNET [=y] && NET_SWITCHDEV
[=n] && HAS_IOMEM [=y]
  Selected by [y]:
  - MSCC_OCELOT_SWITCH_OCELOT [=y] && NETDEVICES [=y] && ETHERNET [=y]
&& NET_VENDOR_MICROSEMI [=y]
drivers/net/ethernet/mscc/ocelot_board.c: In function 'ocelot_xtr_irq_handler':
drivers/net/ethernet/mscc/ocelot_board.c:176:7: error: 'struct
sk_buff' has no member named 'offload_fwd_mark'
    skb->offload_fwd_mark = 1;
       ^~

Adding another "depends on NET_SWITCHDEV"  fixed it for me.

       Arnd
