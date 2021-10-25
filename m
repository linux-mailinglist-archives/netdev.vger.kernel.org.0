Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D155243958B
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 14:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbhJYMIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 08:08:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:48736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230168AbhJYMIL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 08:08:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44EE860F22;
        Mon, 25 Oct 2021 12:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635163549;
        bh=ASfyERnwG3ybz17BtZDwHa5UqEh7zBEImYWzU7CU5Uk=;
        h=From:To:Cc:Subject:Date:From;
        b=mEFV8xCXjBcDx9bpq14EOwHTPmQoRS8oZ9sz1fJ+JByN8asGyffHcVtQ9ko8SUeio
         TRCmanRUgQ7izdB0tDxr9EtGVfIeYjD+Jz/fBcgKn+ulpwazQhiYI5Wu4COf07PP1f
         gzjFrsZF6YmUBgXN2aqIN99osVHFv4LEDu/24pGGqh0Ap5j5PHtbynhZ1aDOnDns9h
         6D1XY/eWbmArgtQ8wbWF6Phxh6j7Y0K7L2331oi7sXMzZ3pWEkJVQnWvR/rlm1ix6e
         Rl1OG6e2H1qFm7HLg4wkQ/MUSNgLpYC+Szd4CHLaNOgBrZbHedlfmp1aUwp2Pxa1bG
         yEgx+nS2CVCMA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1meyjL-0001aP-00; Mon, 25 Oct 2021 14:05:31 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Herton Ronaldo Krzesinski <herton@canonical.com>,
        Hin-Tak Leung <htl10@users.sourceforge.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 0/4] wireless: fix control-message timeouts
Date:   Mon, 25 Oct 2021 14:05:18 +0200
Message-Id: <20211025120522.6045-1-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A number of drivers throughout the tree were incorrectly specifying USB
message timeout values in jiffies instead of milliseconds.

This series fixes the wireless drivers that got it wrong.

Johan


Johan Hovold (4):
  ath10k: fix control-message timeout
  ath6kl: fix control-message timeout
  rtl8187: fix control-message timeouts
  rsi: fix control-message timeout

 drivers/net/wireless/ath/ath10k/usb.c              |  2 +-
 drivers/net/wireless/ath/ath6kl/usb.c              |  2 +-
 .../net/wireless/realtek/rtl818x/rtl8187/rtl8225.c | 14 +++++++-------
 drivers/net/wireless/rsi/rsi_91x_usb.c             |  2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

-- 
2.32.0

