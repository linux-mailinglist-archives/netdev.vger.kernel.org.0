Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71ED112964C
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 14:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbfLWNJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 08:09:27 -0500
Received: from srv2.anyservers.com ([77.79.239.202]:55552 "EHLO
        srv2.anyservers.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbfLWNJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 08:09:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=asmblr.net;
         s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1VfAtSnfC0X6/JPIbkqWGYWSuuV0dWBdbVRT2SXp/Aw=; b=cti+0k7ncAQQd4Mn50+HZX5x5H
        XMFtc4vfNd3NZ8NOnNkbUiijq8uxcz4ObdA4kY1PuClEdoNkJuYnuzfsE1K96E2UYx8CFH5r9r5SA
        vAc4IQSRfVlSBDXURLNtJs7U/oK6QR6FtumEGEpQWSOF2c0AcY6aSZUGGjxp4Z1Xfdblj0idxbqQ5
        b9zvmpwBxzfFNhXD9g1nDDPtRn0p88PQng7tfrG0jTjnFKDfuBsb+wqK2LuwXTOIw2fQ/bwdBCVTT
        PnfXpkEfxy3qfv25gc30zn3te8cyZQ6ee2jlMbMpidKiQxtfbRFMHokx4Uj1mPzSt2M2NHqCF+Bmn
        lkLO7rng==;
Received: from 89-64-37-27.dynamic.chello.pl ([89.64.37.27]:49046 helo=milkyway.galaxy)
        by srv2.anyservers.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <amade@asmblr.net>)
        id 1ijMxO-00Gi5o-Ul; Mon, 23 Dec 2019 13:37:06 +0100
From:   =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>
Subject: [PATCH 0/9] rtlwifi: Cleanups
Date:   Mon, 23 Dec 2019 13:37:06 +0100
Message-Id: <20191223123715.7177-1-amade@asmblr.net>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - srv2.anyservers.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - asmblr.net
X-Get-Message-Sender-Via: srv2.anyservers.com: authenticated_id: amade@asmblr.net
X-Authenticated-Sender: srv2.anyservers.com: amade@asmblr.net
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Start from fixing a typo error, then move onto making series of
functions static and removing unnecessary header.

Amadeusz Sławiński (9):
  rtlwifi: rtl8192cu: Fix typo
  rtlwifi: rtl8188ee: Make functions static & rm sw.h
  rtlwifi: rtl8192ce: Make functions static & rm sw.h
  rtlwifi: rtl8192cu: Remove sw.h header
  rtlwifi: rtl8192ee: Make functions static & rm sw.h
  rtlwifi: rtl8192se: Remove sw.h header
  rtlwifi: rtl8723ae: Make functions static & rm sw.h
  rtlwifi: rtl8723be: Make functions static & rm sw.h
  rtlwifi: rtl8821ae: Make functions static & rm sw.h

 .../wireless/realtek/rtlwifi/rtl8188ee/sw.c   |  7 ++--
 .../wireless/realtek/rtlwifi/rtl8188ee/sw.h   | 12 -------
 .../wireless/realtek/rtlwifi/rtl8192ce/sw.c   |  5 ++-
 .../wireless/realtek/rtlwifi/rtl8192ce/sw.h   | 15 --------
 .../wireless/realtek/rtlwifi/rtl8192cu/sw.c   | 35 +++++++++----------
 .../wireless/realtek/rtlwifi/rtl8192cu/sw.h   | 27 --------------
 .../wireless/realtek/rtlwifi/rtl8192ee/sw.c   |  7 ++--
 .../wireless/realtek/rtlwifi/rtl8192ee/sw.h   | 11 ------
 .../wireless/realtek/rtlwifi/rtl8192se/sw.c   |  1 -
 .../wireless/realtek/rtlwifi/rtl8192se/sw.h   | 13 -------
 .../wireless/realtek/rtlwifi/rtl8723ae/sw.c   |  7 ++--
 .../wireless/realtek/rtlwifi/rtl8723ae/sw.h   | 13 -------
 .../wireless/realtek/rtlwifi/rtl8723be/sw.c   |  7 ++--
 .../wireless/realtek/rtlwifi/rtl8723be/sw.h   | 13 -------
 .../wireless/realtek/rtlwifi/rtl8821ae/sw.c   |  7 ++--
 .../wireless/realtek/rtlwifi/rtl8821ae/sw.h   | 12 -------
 16 files changed, 34 insertions(+), 158 deletions(-)
 delete mode 100644 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.h
 delete mode 100644 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.h
 delete mode 100644 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.h
 delete mode 100644 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.h
 delete mode 100644 drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.h
 delete mode 100644 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.h
 delete mode 100644 drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.h
 delete mode 100644 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.h

-- 
2.24.1

