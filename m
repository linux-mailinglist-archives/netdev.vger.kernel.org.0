Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6910C44DCE0
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 22:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233817AbhKKVLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 16:11:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:47864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229785AbhKKVLS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 16:11:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 930836108B;
        Thu, 11 Nov 2021 21:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636664908;
        bh=GLTjKvU2vT6WnqNpV0ynCagut30h9QC4h72FrfeKgtI=;
        h=From:To:Cc:Subject:Date:From;
        b=OiDWAtFV8S1cA7K9jRl1xKqi+rxNBUoiCNfbB6cEzZBtjanZU37DpKZDVDEmYkYP4
         qtb6ay+6Dl/gLnIlWc33timmhfONFCIRAnNsB95F5do9Q8E9Q+AOVqOF0bDvxV8VNG
         7n+lN/5qNb/aglFOKVGzhmxmqiGfgKe7KvHndsNFli5bS4m6KY/bwU9xJvXpUjV4Iz
         CD0Hn3a3LsScp00t5PKsgxx2biIIjaAnmO8FVJJp8Gl6uCiTOZtwwNdUHo/G9O0rsq
         ifQ6Kwui0U0lekHPczBShzccXezPF6vAsCKWzmlccMYnDfzqWdFW3saS7getwyG/Ku
         8hoG6RhMHI24A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net] ethernet: sis900: fix indentation
Date:   Thu, 11 Nov 2021 13:08:24 -0800
Message-Id: <20211111210824.676201-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A space has snuck in.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 74fad215ee3d ("ethernet: sis900: use eth_hw_addr_set()")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/sis/sis900.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sis/sis900.c b/drivers/net/ethernet/sis/sis900.c
index cc2d907c4c4b..23a336c5096e 100644
--- a/drivers/net/ethernet/sis/sis900.c
+++ b/drivers/net/ethernet/sis/sis900.c
@@ -392,7 +392,7 @@ static int sis96x_get_mac_addr(struct pci_dev *pci_dev,
 			/* get MAC address from EEPROM */
 			for (i = 0; i < 3; i++)
 			        addr[i] = read_eeprom(ioaddr, i + EEPROMMACAddr);
-			 eth_hw_addr_set(net_dev, (u8 *)addr);
+			eth_hw_addr_set(net_dev, (u8 *)addr);
 
 			rc = 1;
 			break;
-- 
2.31.1

