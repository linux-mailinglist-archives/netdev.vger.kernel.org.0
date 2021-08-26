Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079293F8486
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 11:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241001AbhHZJ3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 05:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233249AbhHZJ3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 05:29:41 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F6BC061757;
        Thu, 26 Aug 2021 02:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=h/jIXyoyAHbuXfwf0yKoxIhgV6fCX+3ThenGetfLVts=; t=1629970134; x=1631179734; 
        b=pBvhrgSZOP8cDkbnD88eWHn0x+pDjWuV3khFKenbs5O9pzSUTtIrEf/PowYBRThDy8LP8vvfBuo
        +dJPzQduD6VSE77uvb1W77jYWVDNPHZJkT79s68oa9mWA8mtzmEJbuev8QiGsM99oRw9sOqz/RpK8
        73+b5uSZgcJBLLzu5RFX0rkrCVVwNJ04vz7NMva2OQ85EzOo8aRscHWkV4uNRm+PlOVHVANkGaHWw
        8nneXzXqRgrsd2ZzAkXfpO1H2ck/a4DWnuILsNoc84xTCOVNLKpkqUVtBOJXmpi44lXKpRkdWMM21
        ANhoJi4mwUovJSO7k31Arr9dEpjFF2rJKDoQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mJBgp-00G5uI-JE; Thu, 26 Aug 2021 11:28:51 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2021-08-26
Date:   Thu, 26 Aug 2021 11:28:47 +0200
Message-Id: <20210826092848.45290-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

As I mentioned last time, since we got another week, I have
a few more changes - I had been waiting for a respin of the
TWT and 6 GHz regulatory, but in the end not all of the
latter made it.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit f6a4e0e8a00ff6fadb29f3646ccd33cc85195a38:

  via-velocity: Use of_device_get_match_data to simplify code (2021-08-23 12:56:15 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-net-next-2021-08-26

for you to fetch changes up to 90bd5bee50f2a209ba66f013866959a56ff400b9:

  cfg80211: use wiphy DFS domain if it is self-managed (2021-08-26 11:04:55 +0200)

----------------------------------------------------------------
A few more things:
 * Use correct DFS domain for self-managed devices
 * some preparations for transmit power element handling
   and other 6 GHz regulatory handling
 * TWT support in AP mode in mac80211

----------------------------------------------------------------
Lorenzo Bianconi (2):
      ieee80211: add TWT element definitions
      mac80211: introduce individual TWT support in AP mode

Sriram R (1):
      cfg80211: use wiphy DFS domain if it is self-managed

Wen Gong (3):
      ieee80211: add definition of regulatory info in 6 GHz operation information
      ieee80211: add definition for transmit power envelope element
      mac80211: parse transmit power envelope element

 include/linux/ieee80211.h  | 106 +++++++++++++++++++++++++-
 include/net/mac80211.h     |  12 +++
 net/mac80211/driver-ops.h  |  36 +++++++++
 net/mac80211/ieee80211_i.h |   9 +++
 net/mac80211/iface.c       |  41 +++++++++++
 net/mac80211/rx.c          |  73 ++++++++++++++++++
 net/mac80211/s1g.c         | 180 +++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/status.c      |  17 ++++-
 net/mac80211/trace.h       |  67 +++++++++++++++++
 net/mac80211/util.c        |  12 +++
 net/wireless/reg.c         |   9 ++-
 11 files changed, 558 insertions(+), 4 deletions(-)

