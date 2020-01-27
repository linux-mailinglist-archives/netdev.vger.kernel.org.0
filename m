Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56C3A14AC21
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 23:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgA0WgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 17:36:18 -0500
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:17825 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgA0WgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 17:36:18 -0500
Received: from localhost.localdomain ([93.22.132.58])
        by mwinf5d67 with ME
        id vacD210071Fl4A503acDc3; Mon, 27 Jan 2020 23:36:15 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 27 Jan 2020 23:36:15 +0100
X-ME-IP: 93.22.132.58
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, kuba@kernel.org,
        davem@davemloft.net
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] Bluetooth: SMP: Fix SALT value in some comments
Date:   Mon, 27 Jan 2020 23:36:09 +0100
Message-Id: <20200127223609.15066-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Salts are 16 bytes long.
Remove some extra and erroneous '0' in the human readable format used
in comments.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 net/bluetooth/smp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 4ece170c518e..a2e9492391fe 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -1145,7 +1145,7 @@ static void sc_generate_link_key(struct smp_chan *smp)
 		return;
 
 	if (test_bit(SMP_FLAG_CT2, &smp->flags)) {
-		/* SALT = 0x00000000000000000000000000000000746D7031 */
+		/* SALT = 0x000000000000000000000000746D7031 */
 		const u8 salt[16] = { 0x31, 0x70, 0x6d, 0x74 };
 
 		if (smp_h7(smp->tfm_cmac, smp->tk, salt, smp->link_key)) {
@@ -1203,7 +1203,7 @@ static void sc_generate_ltk(struct smp_chan *smp)
 		set_bit(SMP_FLAG_DEBUG_KEY, &smp->flags);
 
 	if (test_bit(SMP_FLAG_CT2, &smp->flags)) {
-		/* SALT = 0x00000000000000000000000000000000746D7032 */
+		/* SALT = 0x000000000000000000000000746D7032 */
 		const u8 salt[16] = { 0x32, 0x70, 0x6d, 0x74 };
 
 		if (smp_h7(smp->tfm_cmac, key->val, salt, smp->tk))
-- 
2.20.1

