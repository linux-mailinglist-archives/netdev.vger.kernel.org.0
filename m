Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73FB839A087
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 14:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbhFCMI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 08:08:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36225 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbhFCMI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 08:08:28 -0400
Received: from 1.general.mschiu77.us.vpn ([10.172.65.162] helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <chris.chiu@canonical.com>)
        id 1lom7T-0007iL-DG; Thu, 03 Jun 2021 12:06:40 +0000
From:   chris.chiu@canonical.com
To:     Jes.Sorensen@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Chiu <chris.chiu@canonical.com>
Subject: [PATCH v2 0/2] Make ampdu tx work correctly
Date:   Thu,  3 Jun 2021 20:06:07 +0800
Message-Id: <20210603120609.58932-1-chris.chiu@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Chiu <chris.chiu@canonical.com>

The rtl8xxxu is the driver based on mac80211 framework, but the
ampdu tx is never working. Fix the ampdu_action and the hw capability
to enable the ampdu tx.

Chris Chiu (2):
  rtl8xxxu: unset the hw capability HAS_RATE_CONTROL
  rtl8xxxu: Fix ampdu_action to get block ack session work

 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu.h  |  1 +
 .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 28 ++++++++++++-------
 2 files changed, 19 insertions(+), 10 deletions(-)

-- 
2.20.1

