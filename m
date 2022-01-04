Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C762C48439E
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 15:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234340AbiADOo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 09:44:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234151AbiADOo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 09:44:57 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8528EC061761;
        Tue,  4 Jan 2022 06:44:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=C9wVj34hcXacMvzo/tgZg0X8D36JV4yUehWYG3GA9+w=; t=1641307496; x=1642517096; 
        b=vgKVkU/rTNhVmdvdNaVcKBkiRHmdZ8BlhB2B7jyRcwfFBNt+dY4rDnWVEDDUxZ1cQWDHCXY6hN0
        ZSe7lPCP94wzVCk0ExyDPvC8qery6YB95ln3/wZJUxUVYIZokBfs/3xan1myIjBDs4gae5DPy/Prx
        70Up666g3jHrpmYg/4GJKcwUHb7iQMV1VEhX17IBsLKSJoCDAo+OUSqbJwZFK5dnmMveQxmpaaK+F
        eTVVwksvVR2G6CKtTFNqIsGRYM7U+5wl9SgMGNuifgNvr51u4ZFz1GrAiAZK+c/TQA+Qk/DUt18Is
        7S/NJrpeXAHLB9y4/3puL6E/DbvARPYHV2Nw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1n4l3W-001n4R-UD;
        Tue, 04 Jan 2022 15:44:55 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2022-01-04
Date:   Tue,  4 Jan 2022 15:44:48 +0100
Message-Id: <20220104144449.64937-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

So I know it's getting late, but two more fixes came to
me over the holidays/vacations.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 1ef5e1d0dca5b4ffd49d7dec4a83660882f1fda4:

  net/fsl: Remove leftover definition in xgmac_mdio (2022-01-02 18:43:42 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2022-01-04

for you to fetch changes up to 8b5cb7e41d9d77ffca036b0239177de123394a55:

  mac80211: mesh: embedd mesh_paths and mpp_paths into ieee80211_if_mesh (2022-01-04 15:11:49 +0100)

----------------------------------------------------------------
Two more changes:
 * mac80211: initialize a variable to avoid using it uninitialized
 * mac80211 mesh: put some data structures into the container to
   fix bugs with and not have to deal with allocation failures

----------------------------------------------------------------
Pavel Skripkin (1):
      mac80211: mesh: embedd mesh_paths and mpp_paths into ieee80211_if_mesh

Tom Rix (1):
      mac80211: initialize variable have_higher_than_11mbit

 net/mac80211/ieee80211_i.h  | 24 +++++++++++-
 net/mac80211/mesh.h         | 22 +----------
 net/mac80211/mesh_pathtbl.c | 89 ++++++++++++++++-----------------------------
 net/mac80211/mlme.c         |  2 +-
 4 files changed, 55 insertions(+), 82 deletions(-)

