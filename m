Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF3ED2F31A2
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730943AbhALNZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:25:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:55836 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726714AbhALNZh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 08:25:37 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DCE7DAC8F;
        Tue, 12 Jan 2021 13:24:55 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 0/2] iwlwifi: Fix a crash at loading
Date:   Tue, 12 Jan 2021 14:24:47 +0100
Message-Id: <20210112132449.22243-1-tiwai@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this is the fix for the recently introduced regression of iwlwifi
driver (since 5.10), a crash at the module loading [1][2].
The first patch actually fixes the bug, and this should go to 5.11-rc.
The second patch is an enhancement to make pointers const for safety.


Takashi

[1] https://bugzilla.suse.com/show_bug.cgi?id=1180344
[2] https://bugzilla.kernel.org/show_bug.cgi?id=210733

===

Takashi Iwai (2):
  iwlwifi: dbg: Don't touch the tlv data
  iwlwifi: dbg: Mark ucode tlv data as const

 .../net/wireless/intel/iwlwifi/iwl-dbg-tlv.c  | 57 +++++++++----------
 .../net/wireless/intel/iwlwifi/iwl-dbg-tlv.h  |  2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  |  2 +-
 3 files changed, 28 insertions(+), 33 deletions(-)

-- 
2.26.2

