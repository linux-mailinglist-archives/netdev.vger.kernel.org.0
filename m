Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04DBC3D380B
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 11:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbhGWJJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 05:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbhGWJJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 05:09:39 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56C2C061575;
        Fri, 23 Jul 2021 02:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=dL6vntKK9ZYtJOzmgbsbR2Qryum7c+XUwkgh92aExVU=; t=1627033812; x=1628243412; 
        b=dUOhOjhBRbRn40UjCPNV6Pck7X/ICo2KXv2IPoYWnzuXNEyLf3hq8rJz5d4wucIHYe8sopApP5S
        639Npk1wdfIkwCTmZkXDExqL2ZxSAEi4f19sMiTkSslTLCgtI7Qa5vyovA+6AqcqemdEktYPlhd46
        Hp6OV2oviYTEr9FhRCmV7ur9IuH1zVK2KERAWK0JiXEd+9n3uWKwuM1x9QOM/uci5yNL8mYVAZ1E9
        X9d7vIamYS99tudrsKbUSf8Ad/MycvsdiWX09czdbIKyn1VbWVtYpl3DsEO1x78NnZkKkz9F4Z/IR
        C4eSlTKKDcqp2hUDvoBHbfJRkDUB3uZGAzGw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1m6rmG-000Uhx-As; Fri, 23 Jul 2021 11:50:11 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2021-07-23
Date:   Fri, 23 Jul 2021 11:50:06 +0200
Message-Id: <20210723095007.19246-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

For 5.14, we only have a couple of fixes for now.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 9f42f674a89200d4f465a7db6070e079f3c6145f:

  Merge tag 'arm64-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux (2021-07-22 10:38:19 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2021-07-23

for you to fetch changes up to f9a5c358c8d26fed0cc45f2afc64633d4ba21dff:

  cfg80211: Fix possible memory leak in function cfg80211_bss_update (2021-07-23 10:38:18 +0200)

----------------------------------------------------------------
Couple of fixes:
 * fix aggregation on mesh
 * fix late enabling of 4-addr mode
 * leave monitor SKBs with some headroom
 * limit band information for old applications
 * fix virt-wifi WARN_ON
 * fix memory leak in cfg80211 BSS list maintenance

----------------------------------------------------------------
Felix Fietkau (2):
      mac80211: fix starting aggregation sessions on mesh interfaces
      mac80211: fix enabling 4-address mode on a sta vif after assoc

Johan Almbladh (1):
      mac80211: Do not strip skb headroom on monitor frames

Johannes Berg (1):
      nl80211: limit band information in non-split data

Matteo Croce (1):
      virt_wifi: fix error on connect

Nguyen Dinh Phi (1):
      cfg80211: Fix possible memory leak in function cfg80211_bss_update

 drivers/net/wireless/virt_wifi.c | 52 ++++++++++++++++++++++--------------
 net/mac80211/cfg.c               | 19 ++++++++++++++
 net/mac80211/ieee80211_i.h       |  2 ++
 net/mac80211/mlme.c              |  4 +--
 net/mac80211/rx.c                |  3 ++-
 net/mac80211/tx.c                | 57 ++++++++++++++++++++++------------------
 net/wireless/nl80211.c           |  5 +++-
 net/wireless/scan.c              |  6 ++---
 8 files changed, 95 insertions(+), 53 deletions(-)

