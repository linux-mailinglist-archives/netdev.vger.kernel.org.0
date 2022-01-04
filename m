Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD5A4844B4
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 16:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233612AbiADPeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 10:34:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbiADPeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 10:34:12 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF241C061761;
        Tue,  4 Jan 2022 07:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=m+xMehLESnZE+MHCEBfhc+Ab4EEeMmNaYRMbaBZFbxM=; t=1641310451; x=1642520051; 
        b=sPbv/qkKs3+tCkwTdF0cu+xMS1iS7Szv3cRjym0Zr15Pf2NRvChZxiTBnt3SVxxApEr3BajBY6y
        PzOJp6Nbnid0dLlv6cbrX8JAA4k24dFReK+hTHeOGfNrPTH5lIcdk7ZOEwT8kZfm8PeMGlYpA/J3o
        qgGt9xnNLVTXnN/hXQU6M60RmUs3G7rlAtPZzQPkGBZwJZHcLw6rs3ExqzQhwkDuP3+Qum/P3HjaL
        5iQeQQV5+32i/2MhAfUMn1nBJspUiM7K89kUEP2ukcfOYrmSXN2nAQU7hGj8My5NoI2tChGeVngfV
        dzXZdgWLZHZHtAbgOIyWik+cGYvwD+4CzINQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1n4lpC-001noH-3I;
        Tue, 04 Jan 2022 16:34:10 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2022-01-04
Date:   Tue,  4 Jan 2022 16:34:02 +0100
Message-Id: <20220104153403.69749-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

And a couple of more patches for -next... I have more, but most
of those are related to EHT (WiFi 7) and so not really relevant
in the short term - not going to send them this time around, as
I still need to review anyway.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 416b27439df9ecb36b03da63dc37a8840b6f2efe:

  ethernet/sfc: remove redundant rc variable (2022-01-04 12:41:41 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-net-next-2022-01-04

for you to fetch changes up to b3c1906ed02ad2b9f4db2f652cb7ea7b333963e5:

  mac80211: use ieee80211_bss_get_elem() (2022-01-04 15:50:36 +0100)

----------------------------------------------------------------
Just a few more changes:
 * mac80211: allow non-standard VHT MCSes 10/11
 * mac80211: add sleepable station iterator for drivers
 * nl80211: clarify a comment
 * mac80211: small cleanup to use typed element helpers

----------------------------------------------------------------
Felix Fietkau (1):
      nl80211: clarify comment for mesh PLINK_BLOCKED state

Johannes Berg (1):
      mac80211: use ieee80211_bss_get_elem()

Martin Blumenstingl (1):
      mac80211: Add stations iterator where the iterator function may sleep

Ping-Ke Shih (1):
      mac80211: allow non-standard VHT MCS-10/11

 include/net/mac80211.h       | 21 +++++++++++++++++++++
 include/uapi/linux/nl80211.h |  2 +-
 net/mac80211/mlme.c          | 14 +++++++-------
 net/mac80211/rx.c            |  2 +-
 net/mac80211/util.c          | 13 +++++++++++++
 5 files changed, 43 insertions(+), 9 deletions(-)

