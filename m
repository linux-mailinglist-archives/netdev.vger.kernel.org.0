Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01AAE2933B3
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 05:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391211AbgJTDqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 23:46:05 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:33455 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391206AbgJTDqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 23:46:05 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id D7747806B5;
        Tue, 20 Oct 2020 16:46:02 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1603165562;
        bh=zzxOcIuFi0MxWpOQTLXjFZSqkuicDStOBOZPTA20Zds=;
        h=From:To:Cc:Subject:Date;
        b=TmAr+hm/2ku13ZWIcywAj4TTh+T+YkjX0tsm2n4wF+lx6Wn1D1wJguSuhpLrka86b
         MMXwd4dr4NKxidmavpRHQaoMi5GJZdJhsFlU7pdXM+VVHJ2E9uiAQ1/M6a/gjYVujJ
         F070jfEAHzeILrTFUtxOyUXJSJ10cCbAhpXYdmOQsAdVZRIb+AMqyzXfxJXK+B5huC
         twXy2IlujAmw9tEK9+3K3wDtEms7FZY2gYWJFQuubY/LF2hN+F8QXkPL/Fk/5Pdfb7
         Fnt/+2sYx10V3SakKdt9aAHqR+6xGiXh3VYIgS1L3Y7Rha2IOsovDyxhJ0SUwPhnVZ
         Y/GI/y77A6J2w==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f8e5d7a0000>; Tue, 20 Oct 2020 16:46:02 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.20])
        by smtp (Postfix) with ESMTP id 4F69613EEBB;
        Tue, 20 Oct 2020 16:46:02 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 972F6283A9C; Tue, 20 Oct 2020 16:46:02 +1300 (NZDT)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH v3 0/3] net: dsa: mv88e6xxx: serdes link without phy
Date:   Tue, 20 Oct 2020 16:45:55 +1300
Message-Id: <20201020034558.19438-1-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small series gets my hardware into a working state. The key points a=
re to
make sure we don't force the link and that we ask the MAC for the link st=
atus.
I also have updated my dts to say `phy-mode =3D "1000base-x";` and `manag=
ed =3D
"in-band-status";`

I've included patch #3 in this series but I don't have anything to test i=
t on.
It's just a guess based on the datasheets. I'd suggest applying patch 1 &=
 2
and leaving 3 for the mailing list archives.

Chris Packham (3):
  net: dsa: mv88e6xxx: Don't force link when using in-band-status
  net: dsa: mv88e6xxx: Support serdes ports on MV88E6097/6095/6185
  net: dsa: mv88e6xxx: Support serdes ports on MV88E6123/6131

 drivers/net/dsa/mv88e6xxx/chip.c   |  26 ++++++-
 drivers/net/dsa/mv88e6xxx/serdes.c | 106 +++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/serdes.h |   9 +++
 3 files changed, 139 insertions(+), 2 deletions(-)

--=20
2.28.0

