Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE55D391166
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 09:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbhEZHaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 03:30:13 -0400
Received: from mout.gmx.net ([212.227.17.20]:46551 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232844AbhEZHaM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 03:30:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1622014119;
        bh=JzrZEUM2EhJCgC1oh9NUCnWDnd8zhdH5ziS5JuD4xcg=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=dR7IeTEKwuvDmeUB7aCoYwSh1lkFiVvcG+CCBIFUzQCnZcbm7Ke7P6CjLMLxN1wEK
         5/EvUU/LjaJyDFJzxpQI/h0/uIOCU7kf+hHFgP/Mr06rTU6u3rDf52O6QqCVtKRseB
         PR1PdmPpUOuWs6oAQvR0d2M1c25rffvTEgr+PV+Y=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [80.245.78.60] ([80.245.78.60]) by web-mail.gmx.net
 (3c-app-gmx-bs33.server.lan [172.19.170.85]) (via HTTP); Wed, 26 May 2021
 09:28:39 +0200
MIME-Version: 1.0
Message-ID: <trinity-5186a317-8934-483e-834c-a0f320a8c287-1622014119710@3c-app-gmx-bs33>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: Aw: Re: Crosscompiling iproute2
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 26 May 2021 09:28:39 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20210525142331.39594c34@hermes.local>
References: <trinity-a96735e9-a95a-45be-9386-6e0aa9955a86-1621176719037@3c-app-gmx-bap46>
 <20210516141745.009403b7@hermes.local>
 <trinity-00d9e9f2-6c60-48b7-ad84-64fd50043001-1621237461808@3c-app-gmx-bap57>
 <20210517123628.13624eeb@hermes.local>
 <D24044ED-FAC6-4587-B157-A2082A502476@public-files.de>
 <20210524143620.465dd25d@hermes.local>
 <AACFD746-4047-49D5-81B2-C0CD5D037FAB@public-files.de>
 <20210525090846.513dddb1@hermes.local>
 <trinity-3a2b0fba-68a6-47d1-8ed1-6f3fc0cf8200-1621966719535@3c-app-gmx-bs13>
 <20210525142331.39594c34@hermes.local>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:wYewgMFePQ5gpk0JOl4gdPNONqD/BMKln78HfYRr87Kd6MA1ImHdCbcES/tOZJGUCcDbV
 Zk+qhSNb4/wZzxZj+k2JB+45LYlDfcixMnqLiBIT/sHnSgMJ+wJ+NehJA2dbHbRwoDfyyTiVk48s
 VpaZcxxdbozGH14iYNLplpL+L3FO7/bYL96E3B+kxdm+ZOXPm3HgUHBLIwaucidScEwYjRZPo0F0
 +bacydioyRwEvBeRmeJQa6I8nzs5TvC3fxig3FTiKfTq+p/DTjm5Os74y3T0ogLijbG/3PPJgEeV
 V0=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:a7Yykor0+4o=:Z9HdXdIpQ8HdnXYsUolmd1
 eRrjtmNAX0RFdqKe4ulzwxC9R0/3DIoa42B5I3Su8hYjFPaXcjlu1odM4N8Gtovg0+SFiWeyh
 NfYZVhaUDafr1Kd58yaVeTteDXRxEMJyvE5jSThxjyxxpnidoVs8gIw6458yaJSiChLSUYl4J
 7DM97BF4EjcusURML6hIwG6QFJkZ/vaZrRc/kY8S1IVOYT6Ki1XN18ALfiHWh82PA0S+P8kZt
 SyEpcYppczWKZ+vW1bcax8Smt92CQcNuFwaY1g4DUlJKTS4f6nVzyQIazb6v1/0UCZmoPT5Vj
 y9svFPO3aHLZgTxU8XoKViQu1ys7gAzseM/N9q/4XlE4sylrC6kUly0Pcb/9M5/IBo9FF0UcJ
 pirLkp64RSUz4ZdNmI+jYQ0oH3COyUqwedNCI37NNQoq/Ce7uQPCx4hgO6q3ZPpMxq0JO+Bzh
 AXR3hZUiBoIhinVJwFB8C4NDgFYMB5i6w7KsTWHOV1dOLfXvgo/iw4dwML+gDh6z9A9xe4gXr
 /taEKUTKBNjy6YdhbRR8OcPS8eOyxT/9e0kNjUvs4F8+qWqAl2MupWioX4ZWmFg8XFEUg6l8E
 M0dkySRWn/CkzLGxCwHCD5vKjU3pX2hLEB/J7MeZpuliovIWEkJ7ygRGT7nZLUbHgt68N3cwZ
 kshfTpvWZ1wCA88LU4qaMlP1mQ8muyP+CkaaXelFKFKAh565dt8PH+tIhR0nLtsvtXmAEi/XZ
 pfC4X8bp3YUMWwLzncJDreNF93MFEJiNEk6nGYAobvj5HANfFI0TGa5064nmiUF8eZ6kJRINw
 puyFSWRMqxQ4oF0R6FtdYJ+JunTFe2JL3ho2XtrCSATZcuwqNw=
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
> Gesendet: Dienstag, 25. Mai 2021 um 23:37 Uhr
> Von: "Stephen Hemminger" <stephen@networkplumber.org>

> That only gets called if you haven't got the bridge part in the original=
 ip command.
> The shared library stuff is for other non-static libraries to extend ipr=
oute2.
> This is unused by most distro's and you shouldn't need it.
>
> I think the bridge part was just not built in your version.

i see the compilation of iplink_bridge.o before linking ip, so i guess it =
should be compiled in

    CC       iplink_bridge.o
    CC       iplink_bridge_slave.o

i wonder why it tries to use a lib which was not compiled....

but i still need to disable mnl and selinux after creating config.mk to av=
oid linking errors (now i see only warning about error reporting).

i updated the compile-script, so you can see what i'm doing

https://github.com/frank-w/iproute2/blob/main/crosscompile.sh

regards Frank
