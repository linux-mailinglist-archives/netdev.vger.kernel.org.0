Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFF460EDDA
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 04:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233932AbiJ0CQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 22:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233839AbiJ0CQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 22:16:58 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9007FE903
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 19:16:57 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id m2so159467pjr.3
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 19:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4xjEM/dHDXmAnNSHl8ACeTM6kR0Ecmv2z1LaWAsBM64=;
        b=A6zVoKyBNe5gjWu0v+3wYgbzdUpUswtRCE+4FM7TArAMKm6VhlSRFTeE0WgPURpyqy
         NPLoPn21Eq1FA5Wcikbtaongoy62X76NcEHl+mqQ1/Fy2F9sHFkQB9RqPG3u4cd7DIg+
         p9zEqG7Z9dK5W7qqygQ664GQ0pUVENlGm5dIdpD/ezQdUb4CmdDnPBVoHl4J3OYFapdN
         ubR5LYQM46GT/f77h3iO3lv00ssVuZeYmCT5ubuLr0lXwsQWFATJJsJ960NI8sJFK4eT
         EzYjbv1xZklu3Zmx34LvsTVvSs7FTI2wi9PPwjVPxYs0y5HqjeGvo4pVhn+ln0gg9zP6
         LN8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4xjEM/dHDXmAnNSHl8ACeTM6kR0Ecmv2z1LaWAsBM64=;
        b=WllJzKdQn7U5jfdxdiY+NYBxursE8O8JlbvQ3ki9mH7zxG451OQjjQDbr7Qs5H3d0+
         ZWPOSrgQsZveszd4dCachILNBlBnSTPGyZGe3cJr+WHiXk+giJZhAr7tH3TnrJEFZYFg
         PmMRpX6edyjensEnLe6RY4SOj7YKbV7nuZwjVTrv9YNdb/FUJsc1014gTol/IDmcxZUh
         bXZ54uyyacBKfwm9tQajEZiuUZ7PXnoqe8t+7I8T84HN7Iwg/5nUY5t7uz8aFTs55o/O
         Sw3No39o1Jw/o44j7+lbmDvGrhaItYVwigv3MFkqt4ewihYndEgL08byfheXYpdzqY0y
         ACYQ==
X-Gm-Message-State: ACrzQf3GXnhZuHqhaHOG1+CDePNwKpH5aCOFJJK7L7ghoABYBXAt3dAz
        h8+LDJo2sXWdz8q10i9JvO6O6XaaO+gTcR6ZAPE=
X-Google-Smtp-Source: AMsMyM5RecdBeKXNoW0fv+EPjxEbV5QIhyZmUPFbvbL5UQanusJxAqObF0A0dhzriWpqf7z+WgCk4ybF+nbDv5BazRU=
X-Received: by 2002:a17:902:c944:b0:186:a7d7:c3b with SMTP id
 i4-20020a170902c94400b00186a7d70c3bmr19259762pla.55.1666837017129; Wed, 26
 Oct 2022 19:16:57 -0700 (PDT)
MIME-Version: 1.0
From:   Fabio Estevam <festevam@gmail.com>
Date:   Wed, 26 Oct 2022 23:16:45 -0300
Message-ID: <CAOMZO5DJAsj8-m2tEfrHn4xZdK6FE0bZepRZBrSD9=tWSSCNOA@mail.gmail.com>
Subject: Marvell 88E6320 connected to i.MX8MN
To:     Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Tim Harvey <tharvey@gateworks.com>,
        netdev <netdev@vger.kernel.org>, Marek Vasut <marex@denx.de>,
        Fabio Estevam <festevam@denx.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I am trying to make a Marvell 88E6320 switch to work on an imx8mn-based board
running kernel 6.0.5.

Ethernet is functional in U-Boot with Tim's series:
https://lore.kernel.org/all/20221004164918.2251714-1-tharvey@gateworks.com/

However, in the kernel I am not able to retrieve an IP via DHCP:

mv88e6085 30be0000.ethernet-1:00: switch 0x1150 detected: Marvell
88E6320, revision 2
fec 30be0000.ethernet eth0: registered PHC device 0
mv88e6085 30be0000.ethernet-1:00: switch 0x1150 detected: Marvell
88E6320, revision 2
mv88e6085 30be0000.ethernet-1:00: configuring for fixed/rgmii-id link mode
mv88e6085 30be0000.ethernet-1:00: Link is Up - 1Gbps/Full - flow control off
mv88e6085 30be0000.ethernet-1:00 lan3 (uninitialized): PHY
[!soc@0!bus@30800000!ethernet@30be0000!mdio!switch@0!mdio:03] driver
[Generic PHY] (irq=POLL)
mv88e6085 30be0000.ethernet-1:00 lan4 (uninitialized): PHY
[!soc@0!bus@30800000!ethernet@30be0000!mdio!switch@0!mdio:04] driver
[Generic PHY] (irq=POLL)
device eth0 entered promiscuous mode
DSA: tree 0 setup
...

~# udhcpc -i lan4
udhcpc: started, v1.31.1
[   25.174846] mv88e6085 30be0000.ethernet-1:00 lan4: configuring for
phy/gmii link mode
udhcpc: sending discover
[   27.242123] mv88e6085 30be0000.ethernet-1:00 lan4: Link is Up -
100Mbps/Full - flow control rx/tx
[   27.251064] IPv6: ADDRCONF(NETDEV_CHANGE): lan4: link becomes ready
udhcpc: sending discover
udhcpc: sending discover
udhcpc: sending discover
...

This is my devicetree:
https://pastebin.com/raw/TagQJK2a

The only way that I can get IP via DHCP to work in the kernel is if
I access the network inside U-Boot first and launch the kernel afterward.

It looks like U-Boot is doing some configuration that the kernel is missing.

Does anyone have any suggestions, please?

Thanks,

Fabio Estevam
