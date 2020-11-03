Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B6A2A4FFB
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbgKCTWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:22:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:58330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725957AbgKCTWa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 14:22:30 -0500
Received: from dellmb.labs.office.nic.cz (nat-1.nic.cz [217.31.205.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 194B620870;
        Tue,  3 Nov 2020 19:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604431350;
        bh=y1B6dua4mamNeguqjeQKepmpaM475fW8XD5REdSR9nw=;
        h=From:To:Cc:Subject:Date:From;
        b=eurtcBgWt0b4bogAZT0Nnnl4iYxs9mrPvv6CFB6fo3J/P76XROULPdwa2QAC4saZ9
         oD2UlD/zho/R+0jW/n5ns+wkWOKKRZgke0TcgUV9McULuaGskFXlJFXyS+Qkv06B9m
         7m6gNRazDe40n4T14wuoqhdB9w1naiEnHfeO9o7Q=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, Hayes Wang <hayeswang@realtek.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 0/5] r8152 changes
Date:   Tue,  3 Nov 2020 20:22:21 +0100
Message-Id: <20201103192226.2455-1-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

these are some changes for r8152.

At first I just wanted to add support for rtl8156 (which supports
2500baseT), by porting from Realtek's out-of-tree driver.

It instead turned out into cosmetic changes first, though.

Please review this. I would much like to try to port rtl8156 after
these patches are merged, so that _modify functions can be used.
Thanks.

Marek

Marek Behún (5):
  r8152: use generic USB macros to define product table
  r8152: cosmetic improvement of product table macro
  r8152: add MCU typed read/write functions
  r8152: rename r8153_phy_status to r8153_phy_status_wait
  r8152: use *_modify helpers instead of read/write combos

 drivers/net/usb/r8152.c | 1156 +++++++++++++--------------------------
 1 file changed, 387 insertions(+), 769 deletions(-)


base-commit: 6d89076e6ef09337a29a7b1ea4fdf2d892be9650
-- 
2.26.2

