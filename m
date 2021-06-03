Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8D5739A360
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 16:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbhFCOgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 10:36:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:41882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231760AbhFCOgk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 10:36:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12D58613D6;
        Thu,  3 Jun 2021 14:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622730896;
        bh=zC5o6nmJh82wCjYwhPQ484UYLvePnOpYVLth3rHvgbE=;
        h=Date:From:To:Cc:Subject:From;
        b=AFSjBT3W2fQzXOAHVkS+Nj1QRDm7ouAXdNeuT2JraCjDt2+PUi/jggkye8x7zpsu+
         PAtGCfbUHEsQadZkNH0Qfq2fG5P926zxokxCagQC8GWfNI/XKKwhKXibC6HiPHjxZP
         ueSbgFJZPTa41+jsqnLVUVtFsPXX9esW9/lGts8U63RtYYs71cv8g11DxEjykmVv3B
         r6UsVlr99GDPcxk0++ybIJynNx6H8S+ScUgMjLRZyevt6y9k6d6ZSl70rGlUeUVT3V
         tA8Pc3JOv3q/AQJQlfY12qzGkmhoER8ZhK2AgsTourrIWGtzCPNBvdRyQ61dgEpUcp
         1p8NXsCOQeJIw==
Received: by pali.im (Postfix)
        id 3B87A1229; Thu,  3 Jun 2021 16:34:53 +0200 (CEST)
Date:   Thu, 3 Jun 2021 16:34:53 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Igal Liberman <Igal.Liberman@freescale.com>,
        Shruti Kanetkar <Shruti@freescale.com>,
        Emil Medve <Emilian.Medve@Freescale.com>,
        Scott Wood <oss@buserror.net>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Unsupported phy-connection-type sgmii-2500 in
 arch/powerpc/boot/dts/fsl/t1023rdb.dts
Message-ID: <20210603143453.if7hgifupx5k433b@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

In commit 84e0f1c13806 ("powerpc/mpc85xx: Add MDIO bus muxing support to
the board device tree(s)") was added following DT property into DT node:
arch/powerpc/boot/dts/fsl/t1023rdb.dts fm1mac3: ethernet@e4000

    phy-connection-type = "sgmii-2500";

But currently kernel does not recognize this "sgmii-2500" phy mode. See
file include/linux/phy.h. In my opinion it should be "2500base-x" as
this is mode which operates at 2.5 Gbps.

I do not think that sgmii-2500 mode exist at all (correct me if I'm
wrong).

Could you look at this DT property issue? What should be filled here?

I'm CCing netdev and other developers as I see that there is lot of
times confusion between sgmii, 1000base-x and 2500base-x modes.
