Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D130B350A61
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 00:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbhCaWoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 18:44:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232786AbhCaWnl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 18:43:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 717E461007;
        Wed, 31 Mar 2021 22:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617230621;
        bh=wIF7G0wE4NoaNmMeOVZyn1oo+mSAjvyT3b4OXOh5EB4=;
        h=Date:From:To:Cc:Subject:From;
        b=YNJ/5eCjxFOIVZgf9wldlNdP96DKPUI0aRTkJ4Y7ncOzt0hzrGf2j0E9KXkqeyzC9
         xdzu9Spu0xjP2XSGz9KpRCPykC/TUw14Vm7U5Zvl8+7uvFFKIyVSNcd38QVZtE+oWs
         7V2FGgK0+nlQ83whfEgNEjSuchuxjCaqyWqXRhq1yYXZEPWztFxOTahGJSlShKpMMT
         4hiGx4SOjL0VTsT7kqoArRqhG5vS1IhSSSGOpgsedwOvDBaLgEjJ+uyMe0Vm1mRpmA
         OsSdQlmEvT9xmPkGxSPsea0VQh4nJvkDv5VZMk0nJ61H5vSpW/fJ5bOg4ldzjK9Hh2
         EDj3we9orM5pQ==
Date:   Wed, 31 Mar 2021 16:43:43 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH v2 0/2][next] wl3501_cs: Fix out-of-bounds warnings
Message-ID: <cover.1617226663.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the a couple of  out-of-bounds warnings by making the code
a bit more structured.

This helps with the ongoing efforts to enable -Warray-bounds and
avoid confusing the compiler.

Link: https://github.com/KSPP/linux/issues/109

Changes in v2:
 - Update changelog text in patch 1/2.
 - Replace a couple of magic numbers with new variable sig_addr_len.

Gustavo A. R. Silva (2):
  wl3501_cs: Fix out-of-bounds warning in wl3501_send_pkt
  wl3501_cs: Fix out-of-bounds warning in wl3501_mgmt_join

 drivers/net/wireless/wl3501.h    | 28 ++++++++++++++++------------
 drivers/net/wireless/wl3501_cs.c | 11 ++++++-----
 2 files changed, 22 insertions(+), 17 deletions(-)

-- 
2.27.0

