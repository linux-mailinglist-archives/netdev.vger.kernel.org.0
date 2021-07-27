Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEE8A3D7C32
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 19:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbhG0RdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 13:33:21 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:36472
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229453AbhG0RdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 13:33:21 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 93F3F3F22C;
        Tue, 27 Jul 2021 17:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627407199;
        bh=cBQwGCAj7Np0JZQGOqZ79HMB7qL2mXEkmrdNgg4EJ4E=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=mfTD8IsCtnM8DhI3A9RQumKOhdpf7ZkKijfXkyOWFCQko26ZHn5khfdTsC/i6ttXy
         6WUd8CwBtSFSMHHXsGfQx9cjBy20PSAYjLCQLj9JdjKsuzdnx8QAg1p1lDrd3h0kGF
         mFBD7q0kubdi1Ks4c0Tw8FK7FD0Vq9IbA4bp2PqJbTCDbRfVimCiT5ckbDriwtH+Gg
         728Pksb2SVbSble2fxbYTg/8ls7rwjRrHoVhkhCxlBcT0S78ZLGnC5wKCprbo1m+vY
         MkhxwqTCsiSxmmL1z6FYFohA942fyGoqweUHiR6RAIkMJNowfBHEAOmOqK/GRi4gQX
         eT+Kp6H2/WdJA==
From:   Colin King <colin.king@canonical.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] i40e: Fix spelling mistake "dissable" -> "disable"
Date:   Tue, 27 Jul 2021 18:33:18 +0100
Message-Id: <20210727173318.78154-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a dev_info message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index b4a57251256a..4eb9005e85da 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -4638,7 +4638,7 @@ void i40e_vsi_stop_rings(struct i40e_vsi *vsi)
 		err = i40e_control_wait_rx_q(pf, pf_q, false);
 		if (err)
 			dev_info(&pf->pdev->dev,
-				 "VSI seid %d Rx ring %d dissable timeout\n",
+				 "VSI seid %d Rx ring %d disable timeout\n",
 				 vsi->seid, pf_q);
 	}
 
-- 
2.31.1

