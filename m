Return-Path: <netdev+bounces-9553-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B0CB729BFD
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 15:51:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A9F682818FF
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 13:51:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D539A17741;
	Fri,  9 Jun 2023 13:51:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D2A174E7
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 13:51:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97DE0C433D2;
	Fri,  9 Jun 2023 13:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686318695;
	bh=EIAkg1OhiPH/HKIogUaEP5jh6cv7oXgtbQxQMzRHSXA=;
	h=From:Date:Subject:To:Cc:From;
	b=ib3cqrH2FF9XRqPRWnarSoZV66R3euypn/9ACQjsaYgbGHInsKF21+e/hnVXNEcnB
	 3Y+5ZxO+KSe0t1Xpg+oLareHm/6wqxOZHRGBXno3x3HHN86SzITj9SmQOky/rrOrx4
	 00KQxpWzMuwN9PEkRsGeGY3mee55txhAyrXQ3Fo0vASY8+EbFJL7IKZEuDV6qQAJln
	 0fd0uQnxVXeV792m4fS0aFkfyfqN04jnNui/Fm0iI2ejEk1W0h3ckRz7b4qGPQhUvK
	 modqVtPUcRgUPZxHXDlVJn+88jGuKc2HvIBVNUp2RncFgqFxEzba/2FHHmBEYIL6SG
	 oa0io+kiqxbdw==
From: Simon Horman <horms@kernel.org>
Date: Fri, 09 Jun 2023 15:51:30 +0200
Subject: [PATCH net-next] bnx2x: Make dmae_reg_go_c static
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230609-bnx2x-static-v1-1-6c1a6888d227@kernel.org>
X-B4-Tracking: v=1; b=H4sIAGEug2QC/x2N0QqDMAwAf0XyvEBXZcP9ythDU+MMSDaaOgriv
 y/4eAfH7WBchA0e3Q6Ff2LyUYfrpYO8JH0zyuQMMcQ+3MKIpC02tJqqZOynO9HAPOYwgyeUjJF
 K0rx4pNu6uvwWnqWdjycoV1RuFV7H8QetcVqGfQAAAA==
To: Ariel Elior <aelior@marvell.com>, 
 Sudarsana Kalluru <skalluru@marvell.com>, 
 Manish Chopra <manishc@marvell.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
X-Mailer: b4 0.12.2

Make dmae_reg_go_c static, it is only used in bnx2x_main.c

Flagged by Sparse as:

 .../bnx2x_main.c:291:11: warning: symbol 'dmae_reg_go_c' was not declared. Should it be static?

No functional change intended.
Compile tested only.

Signed-off-by: Simon Horman <horms@kernel.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 637d162bbcfa..93f78f7a1e7b 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -288,7 +288,7 @@ static const struct pci_device_id bnx2x_pci_tbl[] = {
 
 MODULE_DEVICE_TABLE(pci, bnx2x_pci_tbl);
 
-const u32 dmae_reg_go_c[] = {
+static const u32 dmae_reg_go_c[] = {
 	DMAE_REG_GO_C0, DMAE_REG_GO_C1, DMAE_REG_GO_C2, DMAE_REG_GO_C3,
 	DMAE_REG_GO_C4, DMAE_REG_GO_C5, DMAE_REG_GO_C6, DMAE_REG_GO_C7,
 	DMAE_REG_GO_C8, DMAE_REG_GO_C9, DMAE_REG_GO_C10, DMAE_REG_GO_C11,


