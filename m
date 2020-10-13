Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11C7C28C713
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 04:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728639AbgJMCTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 22:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728583AbgJMCTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 22:19:09 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130B0C0613D7
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 19:19:08 -0700 (PDT)
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 85A2A806B5;
        Tue, 13 Oct 2020 15:19:03 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1602555543;
        bh=LnIDRFzW9Hxev/nUxi3JhJt0J3qjL7J6jgkL3TeEa6Q=;
        h=From:To:Cc:Subject:Date;
        b=mL9ur4sptJoL38TYh/Z1W/bvvyiRWX2EMf/l45VoxZ1yHf49xtbg7x0/Byj/WOibN
         lLzb0oxe9F+9B/KbdJ45DgPrE2TsJAICVgN1qmxaqeF51p8tvplBhJ2S57giuRebWh
         hTaqsCYADZecT9ULxtKy5Da3N4m7WA6kQYQfjzX+Ps1KdH9i5YRzDOCZMI0RX4RyC7
         OKMJRQnWI5vpmSNRHQrNU1LM1dNJrATPw+dcbXx92A/6Di2gCf8uwkMuGvsthvH5Yh
         8pck1vKVFYjKMeT/eN5bYRKeKKiwg3yXyP8W1By/wszMZ3HTAMoBLO3eyLeelaC5E/
         VDzsF1FjujH1g==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f850e950000>; Tue, 13 Oct 2020 15:19:01 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.20])
        by smtp (Postfix) with ESMTP id 2D07D13EEB7;
        Tue, 13 Oct 2020 15:19:02 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 507FA280063; Tue, 13 Oct 2020 15:19:03 +1300 (NZDT)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH 0/2] net: dsa: mv88e6xxx: serdes link without phy
Date:   Tue, 13 Oct 2020 15:18:56 +1300
Message-Id: <20201013021858.20530-1-chris.packham@alliedtelesis.co.nz>
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

Chris Packham (2):
  net: dsa: mv88e6xxx: Don't force link when using in-band-status
  net: dsa: mv88e6xxx: Support serdes ports on MV88E6097

 drivers/net/dsa/mv88e6xxx/chip.c | 68 +++++++++++++++++++++++++++++++-
 1 file changed, 66 insertions(+), 2 deletions(-)

--=20
2.28.0

