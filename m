Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA2F48B229
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 17:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349961AbiAKQ2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 11:28:44 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.82]:32911 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349977AbiAKQ2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 11:28:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1641918159;
    s=strato-dkim-0002; d=fpond.eu;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=26V/zdrL+JyppG2XyT3B/o+gGDVMKccXxGHmJw1lG6g=;
    b=nt4rw6dA3Ry4EsJwc0rgizf9tWJcdY0aru2wgSUReQBalCFRIBu21+VgKPmcsBWtrs
    ueA5THOfwVhWEEjE2Hg7WSTKrXeOm112TFLxKepcbYo38gwlE4TVMI8M3rMkt5Z6jWvj
    2qrwiYerkxVi+jdI80xQhX/3p9C+G6bc2RDvFcCSxvEI/UOE5idklKFzd2cDQ86Al4JO
    YuJ8ueS2DDHL3A1TRxoNf/9dsEvy1cGeCbGRCioTwwOG5noAN+JKUycnFqi3+KwL1ul1
    zyLmwNtR46wEgELFYiPizivYf8JC8Twcj9AS1WaKUi4HReygqKNhxXPyWNKpyteVycBs
    s0UA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73dmm4I5W0/AvA67Ot4fvR8nxYa0aI"
X-RZG-CLASS-ID: mo00
Received: from gummo.fritz.box
    by smtp.strato.de (RZmta 47.37.6 DYNA|AUTH)
    with ESMTPSA id a48ca5y0BGMdHKr
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 11 Jan 2022 17:22:39 +0100 (CET)
From:   Ulrich Hecht <uli+renesas@fpond.eu>
To:     linux-renesas-soc@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, prabhakar.mahadev-lad.rj@bp.renesas.com,
        biju.das.jz@bp.renesas.com, wsa@kernel.org,
        yoshihiro.shimoda.uh@renesas.com, wg@grandegger.com,
        mkl@pengutronix.de, kuba@kernel.org, mailhol.vincent@wanadoo.fr,
        socketcan@hartkopp.net, geert@linux-m68k.org,
        kieran.bingham@ideasonboard.com,
        Ulrich Hecht <uli+renesas@fpond.eu>
Subject: [PATCH v2 1/5] clk: renesas: r8a779a0: add CANFD module clock
Date:   Tue, 11 Jan 2022 17:22:27 +0100
Message-Id: <20220111162231.10390-2-uli+renesas@fpond.eu>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220111162231.10390-1-uli+renesas@fpond.eu>
References: <20220111162231.10390-1-uli+renesas@fpond.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds "canfd0" to mod clocks.

Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>
---
 drivers/clk/renesas/r8a779a0-cpg-mssr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/renesas/r8a779a0-cpg-mssr.c b/drivers/clk/renesas/r8a779a0-cpg-mssr.c
index 1c09d4ebe90f..fadd8a1718c6 100644
--- a/drivers/clk/renesas/r8a779a0-cpg-mssr.c
+++ b/drivers/clk/renesas/r8a779a0-cpg-mssr.c
@@ -136,6 +136,7 @@ static const struct mssr_mod_clk r8a779a0_mod_clks[] __initconst = {
 	DEF_MOD("avb3",		214,	R8A779A0_CLK_S3D2),
 	DEF_MOD("avb4",		215,	R8A779A0_CLK_S3D2),
 	DEF_MOD("avb5",		216,	R8A779A0_CLK_S3D2),
+	DEF_MOD("canfd0",	328,	R8A779A0_CLK_CANFD),
 	DEF_MOD("csi40",	331,	R8A779A0_CLK_CSI0),
 	DEF_MOD("csi41",	400,	R8A779A0_CLK_CSI0),
 	DEF_MOD("csi42",	401,	R8A779A0_CLK_CSI0),
-- 
2.20.1

