Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64B9A4CB188
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 22:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245406AbiCBVpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 16:45:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234670AbiCBVpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 16:45:34 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87EBA5643F;
        Wed,  2 Mar 2022 13:44:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=UMJKG+OcLOQKW/Tmm2SwU/6szHbm/IOiQYdMlh5WKBA=; t=1646257490; x=1647467090; 
        b=IVz7FeAmhMbQBJXD2MK/ZCqLumRhQQIy1tcl/BwA0+3wPV5DBwtDOHf6jxYX+bbjzEgo5UELT2j
        APOF6pj8zz+NjC8rYV8JXoKWjT1zwsDwh9WLNpB3n6mJjG6zY64+UJwgCbvwiEjIGIdCxx8Vrioez
        7CtIlHjH/tUIMM6Gb4+J8RqNB2NFP1MQPzfzSuJa2NvZE0QtVebIoLrjlSUQ3EkyF8pLBdNTyGBZJ
        DmaNIEUyoYxw/jx9HuwnVYmSO/XpifLPa10St7hfnK8BPS73tN6FuY9Cgq3GMNk/H2R0A7Z+NTr2K
        8TifY5VJqoABBePQuhBFMbOxigMFuPIyqUpA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nPWm8-007zqz-Cx;
        Wed, 02 Mar 2022 22:44:48 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: wireless 2022-03-02
Date:   Wed,  2 Mar 2022 22:44:43 +0100
Message-Id: <20220302214444.100180-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

So that was quick - got two more obvious fixes, and
figured out the build fix (the commit log describes
it, but evidently I was too dense the other day to
understand it) ... sorry about that.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 90f8f4c0e3cebd541deaa45cf0e470bb9810dd4f:

  ptp: ocp: Add ptp_ocp_adjtime_coarse for large adjustments (2022-03-02 09:51:21 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-for-net-2022-03-02

for you to fetch changes up to e6e91ec966db5af4f059cfbac1af06560404b317:

  iwlwifi: mvm: return value for request_ownership (2022-03-02 22:37:25 +0100)

----------------------------------------------------------------
Three more fixes:
 - fix build issue in iwlwifi, now that I understood
   what's going on there
 - propagate error in iwlwifi/mvm to userspace so it
   can figure out what's happening
 - fix channel switch related updates in P2P-client
   in cfg80211

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: mvm: return value for request_ownership

Randy Dunlap (1):
      iwlwifi: fix build error for IWLMEI

Sreeramya Soratkal (1):
      nl80211: Update bss channel on channel switch for P2P_CLIENT

 drivers/net/wireless/intel/Makefile                 | 1 +
 drivers/net/wireless/intel/iwlwifi/mvm/vendor-cmd.c | 5 +++--
 net/wireless/nl80211.c                              | 3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

