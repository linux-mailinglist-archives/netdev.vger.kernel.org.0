Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A047350A0F
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 00:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbhCaWOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 18:14:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232927AbhCaWOa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 18:14:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A6AA61078;
        Wed, 31 Mar 2021 22:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617228870;
        bh=mrLBos/CAgdGWR21qY3zs3GniHUtc419xSmwc+HgHSU=;
        h=Date:From:To:Cc:Subject:From;
        b=g0Y5yKP+43NhiVe22Sk7oO18fMgUonL6du/Y8ISEllMGv7HpegYnUG3D+xDS4mIe4
         yiVRNSy/yORHoCIPcWPtt6G4CxgguVd+c0kjpKltq7YMLjSkeDIOi3pzRbc0BFzU/f
         TK8a8sPsBU5SOgXFrLNjC04arIch7i/8GlSiBHPywnLUbwcBH6FsmLQrhiJ7lD9j0E
         7gfmamdV321ljtKmISJ0UMhqIlm++X5dZ3HkBKpvJ3u0Y0c3Vm6ijVswyj0iy67RmY
         bwqTq8wCvshCmEmYmpODsnMQHX9JiFuLt+cZWgPiOneZIGdrOqJIkmy79U7YhKOdwq
         vzyrXRVSZ+B7Q==
Date:   Wed, 31 Mar 2021 16:14:32 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 0/2][next] wl3501_cs: Fix out-of-bounds warnings
Message-ID: <cover.1617223928.git.gustavoars@kernel.org>
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

Gustavo A. R. Silva (2):
  wl3501_cs: Fix out-of-bounds warning in wl3501_send_pkt
  wl3501_cs: Fix out-of-bounds warning in wl3501_mgmt_join

 drivers/net/wireless/wl3501.h    | 28 ++++++++++++++++------------
 drivers/net/wireless/wl3501_cs.c |  6 +++---
 2 files changed, 19 insertions(+), 15 deletions(-)

-- 
2.27.0

