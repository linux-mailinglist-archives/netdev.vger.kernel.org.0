Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306AC43CC64
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 16:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238872AbhJ0Ok1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 10:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238908AbhJ0Ok0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 10:40:26 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79172C061570;
        Wed, 27 Oct 2021 07:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=t24zkGGtpZN1OU7jf/ooKPLCofpu4nHbLEvJSrls7Zk=; t=1635345481; x=1636555081; 
        b=uPMuS7umEWDL+U2NPJ7dBLxkph0xZg+S4yh5MJOTjE+e9QHAvXmHkHUqymyq8Dbkqqe+DrPw1mz
        7A9LCqLgvQ0veeegcAJQwOI5BNqsTobDMfZIr/ZnI5QY5MX1MbTZA45segJ5B0ZogcRgwmpGsIult
        dhAvwg+jBzW5hdfJ/2n6xpkN16E55OlfcMow2ulm35v7dymvAWMlw+SBAZf2ZZmXrc8fPY1BIXf/T
        7cnmg6BMYhdpbMIVSougjv5iJwiACHswLwWbHoeSWX/HhK8iFCcT/36ZVidkj/30v9uRgBFhHoa6q
        E7jzmnDUPDiuCvxSg9mNfpaAR/I514rjJ0Aw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mfk3z-007Yfx-6r;
        Wed, 27 Oct 2021 16:37:59 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2021-10-27
Date:   Wed, 27 Oct 2021 16:37:55 +0200
Message-Id: <20211027143756.91711-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Two more fixes. Both issues have been around for a while though.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 95a359c9553342d36d408d35331ff0bfce75272f:

  net: ethernet: microchip: lan743x: Fix dma allocation failure by using dma_set_mask_and_coherent (2021-10-24 13:38:56 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2021-10-27

for you to fetch changes up to 689a0a9f505f7bffdefe6f17fddb41c8ab6344f6:

  cfg80211: correct bridge/4addr mode check (2021-10-25 15:23:20 +0200)

----------------------------------------------------------------
Two fixes:
 * bridge vs. 4-addr mode check was wrong
 * management frame registrations locking was
   wrong, causing list corruption/crashes

----------------------------------------------------------------
Janusz Dziedzic (1):
      cfg80211: correct bridge/4addr mode check

Johannes Berg (1):
      cfg80211: fix management registrations locking

 include/net/cfg80211.h |  2 --
 net/wireless/core.c    |  2 +-
 net/wireless/core.h    |  2 ++
 net/wireless/mlme.c    | 26 ++++++++++++++------------
 net/wireless/util.c    | 14 +++++++-------
 5 files changed, 24 insertions(+), 22 deletions(-)

