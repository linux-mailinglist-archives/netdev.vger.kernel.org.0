Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 992BC3801E6
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 04:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbhENCZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 22:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbhENCZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 22:25:51 -0400
Received: from mxout012.mail.hostpoint.ch (mxout012.mail.hostpoint.ch [IPv6:2a00:d70:0:e::312])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05531C061574;
        Thu, 13 May 2021 19:24:40 -0700 (PDT)
Received: from [10.0.2.45] (helo=asmtp012.mail.hostpoint.ch)
        by mxout012.mail.hostpoint.ch with esmtp (Exim 4.94.2 (FreeBSD))
        (envelope-from <code@reto-schneider.ch>)
        id 1lhNCJ-000H3s-1R; Fri, 14 May 2021 04:05:03 +0200
Received: from [2a02:168:6182:1:4ea5:a8cc:a141:509c] (helo=ryzen2700.home.reto-schneider.ch)
        by asmtp012.mail.hostpoint.ch with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2 (FreeBSD))
        (envelope-from <code@reto-schneider.ch>)
        id 1lhNCI-000L6T-VM; Fri, 14 May 2021 04:05:03 +0200
X-Authenticated-Sender-Id: reto-schneider@reto-schneider.ch
From:   Reto Schneider <code@reto-schneider.ch>
To:     Jes.Sorensen@gmail.com, linux-wireless@vger.kernel.org,
        pkshih@realtek.com
Cc:     yhchuang@realtek.com, Larry.Finger@lwfinger.net,
        tehuang@realtek.com, reto.schneider@husqvarnagroup.com,
        ccchiu77@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 0/7] [RFC] rtl8xxxu/RTL8188CUS: Wi-Fi Alliance Certification
Date:   Fri, 14 May 2021 04:04:35 +0200
Message-Id: <20210514020442.946-1-code@reto-schneider.ch>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <a31d9500-73a3-f890-bebd-d0a4014f87da@reto-schneider.ch>
References: <a31d9500-73a3-f890-bebd-d0a4014f87da@reto-schneider.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Reto Schneider <reto.schneider@husqvarnagroup.com>

This is our most recent, WIP code. It is plagued by the too-frequent
retransmission issue as described in the original mail.

Any kind of help is welcome.


Chris Chiu (7):
  rtl8xxxu: add code to handle
    BSS_CHANGED_TXPOWER/IEEE80211_CONF_CHANGE_POWER
  rtl8xxxu: add handle for mac80211 get_txpower
  rtl8xxxu: Enable RX STBC by default
  rtl8xxxu: feed antenna information for mac80211
  rtl8xxxu: fill up txrate info for all chips
  rtl8xxxu: Fix the reported rx signal strength
  rtl8xxxu: Fix ampdu_action to get block ack session work

 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu.h  |   7 +
 .../realtek/rtl8xxxu/rtl8xxxu_8192c.c         |   2 +
 .../realtek/rtl8xxxu/rtl8xxxu_8723a.c         |   1 +
 .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 301 +++++++++++++++---
 4 files changed, 270 insertions(+), 41 deletions(-)

-- 
2.29.2

