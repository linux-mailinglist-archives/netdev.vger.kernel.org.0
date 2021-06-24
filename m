Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9C233B2E90
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 14:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhFXMId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 08:08:33 -0400
Received: from pb-smtp20.pobox.com ([173.228.157.52]:56649 "EHLO
        pb-smtp20.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbhFXMIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 08:08:31 -0400
Received: from pb-smtp20.pobox.com (unknown [127.0.0.1])
        by pb-smtp20.pobox.com (Postfix) with ESMTP id AA71512757B;
        Thu, 24 Jun 2021 08:06:12 -0400 (EDT)
        (envelope-from tdavies@darkphysics.net)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed; d=pobox.com; h=date:from
        :to:cc:subject:message-id:mime-version:content-type; s=sasl; bh=
        j8rQrshbvNd0uPBvyfgmlh5xUyZNgnP8aHq0npBHc5s=; b=G+v8TewOzwdjp0p2
        Bxphv8Q4GtPYbQs8WVKwxwl81dDKU1V5ujoCh7seUuur9Wnzvz7aPj7bKZ9mpjOa
        iGPwWcKusE2aKpo/GhleoF69nefnjciVHMANq4/kLELhNQVeZjqsG7cQrxRKzPld
        xpCNOhd8wQ5zS+I2EEHxzqgdkF4=
Received: from pb-smtp20.sea.icgroup.com (unknown [127.0.0.1])
        by pb-smtp20.pobox.com (Postfix) with ESMTP id A39FC12757A;
        Thu, 24 Jun 2021 08:06:12 -0400 (EDT)
        (envelope-from tdavies@darkphysics.net)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed; d=darkphysics.net;
 h=date:from:to:cc:subject:message-id:mime-version:content-type;
 s=2019-09.pbsmtp; bh=j8rQrshbvNd0uPBvyfgmlh5xUyZNgnP8aHq0npBHc5s=;
 b=r0qsKzRmXhFkMDXQtG5r6Xp3zx+XwDutAKZMEvyflZw/I5pevQU8DQ9Gvb17QnMwEcJdRzZUT6tEo211qdZwm+0xrAY/4a1wFMCONS9I3/eMEtHzmToINfL1mszSw8X6aPAtTyF450yzg+4+62wflpwlASy32chPsGEC5pRAPn0=
Received: from oatmeal.darkphysics (unknown [24.19.107.226])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by pb-smtp20.pobox.com (Postfix) with ESMTPSA id 015CC127579;
        Thu, 24 Jun 2021 08:06:09 -0400 (EDT)
        (envelope-from tdavies@darkphysics.net)
Date:   Thu, 24 Jun 2021 05:06:01 -0700
From:   Tree Davies <tdavies@darkphysics.net>
To:     tdavies@darkphysics.net, netdev@vger.kernel.org
Cc:     intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v1 1/1] net/e1000e: Fix spelling mistake "The" -> "This"
Message-ID: <20210624120511.GA6221@oatmeal.darkphysics>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Pobox-Relay-ID: 9026903A-D4E4-11EB-B14D-D5C30F5B5667-45285927!pb-smtp20.pobox.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a spelling mistake in the comment block.

Signed-off-by: Tree Davies <tdavies@darkphysics.net>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 88e9035b75cf..ff267cf75ef8 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7674,7 +7674,7 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
  * @pdev: PCI device information struct
  *
  * e1000_remove is called by the PCI subsystem to alert the driver
- * that it should release a PCI device.  The could be caused by a
+ * that it should release a PCI device.  This could be caused by a
  * Hot-Plug event, or because the driver is going to be removed from
  * memory.
  **/
-- 
2.20.1

