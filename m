Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6804366AB
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 17:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbhJUPqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 11:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbhJUPqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 11:46:12 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A19C061764;
        Thu, 21 Oct 2021 08:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=5oXqA8yREmsm15OMElvEDaPpaCHr1798YGN6KIBSmrE=; t=1634831035; x=1636040635; 
        b=D2y7kWB1EpHAaqlAdf5NgG2DTj/0zhvvZTpQgHJWis3DHEV0AIQ09mIWYchv5wgN29baOHQdvcC
        HQmOGwKatqwmVw33u/ecF1JdI9F2zi2xZajWTvecQ8UcPfO8NHnxXb6QcS3uCVF6khJ4VqxeyJX6t
        0UGgF6W4/2m1UTehECIWYDWAMyDLW5IizI4F5dEfzMouH8w38Q9TUlrrxgJOnD5CQAnwP+mdKdQor
        16Quh6kUvzTe8zAB+ipLOdzJXfuh8ZdkOsN0tY9k+L/dMEp4CGxJ6lanVx6Mm8FUIRfnl3EZiocEw
        9yBZ0ZB75JSbL0QRThFPlUn+I+xTQx24kOLA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mdaET-005KJ6-N3;
        Thu, 21 Oct 2021 17:43:53 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2021-10-21
Date:   Thu, 21 Oct 2021 17:43:50 +0200
Message-Id: <20211021154351.134297-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

So I had two fixes pending in my tree and forgot to send them before
going on vacation ... at least they've been there for a while now ;)

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit ca6e11c337daf7925ff8a2aac8e84490a8691905:

  phy: mdio: fix memory leak (2021-09-30 17:11:59 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2021-10-21

for you to fetch changes up to a2083eeb119fb9307258baea9b7c243ca9a2e0b6:

  cfg80211: scan: fix RCU in cfg80211_add_nontrans_list() (2021-10-01 11:02:27 +0200)

----------------------------------------------------------------
Two small fixes:
 * RCU misuse in scan processing in cfg80211
 * missing size check for HE data in mac80211 mesh

----------------------------------------------------------------
Johannes Berg (2):
      mac80211: mesh: fix HE operation element length check
      cfg80211: scan: fix RCU in cfg80211_add_nontrans_list()

 net/mac80211/mesh.c | 9 +++++----
 net/wireless/scan.c | 7 +++++--
 2 files changed, 10 insertions(+), 6 deletions(-)

