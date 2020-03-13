Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20EC01845F0
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 12:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgCML2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 07:28:04 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:15001 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726414AbgCML2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 07:28:04 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1584098883; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=+stE8p10TQL6VTUn2WyRJgcnqxE5SIw9kxKoq1SBLWo=; b=PWgcOzSZ/zTiMDMLgIHvncH55oGHfxfKQCpThERuvA+YKzFCNpOhTYNZJ66JDflel3qYokW6
 jgM0LGYAi7oMDEeWPGgOxK2ruUQLV5kHLpxmWmSqNCXwAh1wgAeGOeYLkAS6OzNe04Tpf0Pk
 jqWf7FuutBEs/neClpanCBVFxlg=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e6b6e36.7ff723ad53b0-smtp-out-n01;
 Fri, 13 Mar 2020 11:27:50 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7FA74C433BA; Fri, 13 Mar 2020 11:27:49 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 86B46C433D2;
        Fri, 13 Mar 2020 11:27:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 86B46C433D2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-2020-03-13
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20200313112749.7FA74C433BA@smtp.codeaurora.org>
Date:   Fri, 13 Mar 2020 11:27:49 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit 2362059427494b9e318161f0447a10dc5513b2c3:

  Merge tag 'batadv-net-for-davem-20200306' of git://git.open-mesh.org/linux-merge (2020-03-09 19:08:43 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-2020-03-13

for you to fetch changes up to e2e57291097b289f84e05fa58ab5e6c6f30cc6e2:

  wlcore: remove stray plus sign (2020-03-12 18:48:14 +0200)

----------------------------------------------------------------
wireless-drivers fixes for v5.6

Third, and hopefully last, set of fixes for v5.6.

iwlwifi

* fix a locking issue in time events handling

* a fix in rate-scaling

* fix for a potential NULL pointer deref

* enable antenna diversity in some devices that were erroneously not doing it

* allow FW dumps to continue when the FW is stuck

* a fix in the HE capabilities handling

* another fix for FW dumps where we were reading wrong addresses

* fix link in MAINTAINERS file

rtlwifi

* fix regression causing connect issues in v5.4

wlcore

* remove merge damage which luckily didn't have any impact on functionality

----------------------------------------------------------------
Avraham Stern (1):
      iwlwifi: mvm: take the required lock when clearing time event data

Ilan Peer (1):
      iwlwifi: mvm: Fix rate scale NSS configuration

Johannes Berg (1):
      wlcore: remove stray plus sign

Kalle Valo (1):
      Merge tag 'iwlwifi-for-kalle-2020-03-08' of git://git.kernel.org/.../iwlwifi/iwlwifi-fixes

Larry Finger (1):
      rtlwifi: rtl8188ee: Fix regression due to commit d1d1a96bdb44

Luca Coelho (4):
      iwlwifi: check allocated pointer when allocating conf_tlvs
      iwlwifi: dbg: don't abort if sending DBGC_SUSPEND_RESUME fails
      iwlwifi: cfg: use antenna diversity with all AX101 devices
      MAINTAINERS: update web URL for iwlwifi

Mordechay Goodstein (2):
      iwlwifi: consider HE capability when setting LDPC
      iwlwifi: yoyo: don't add TLV offset when reading FIFOs

 MAINTAINERS                                        |  2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |  2 ++
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        | 25 +++++-----------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        |  6 ++--
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     | 35 ++++++++++++++++------
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |  4 +++
 .../net/wireless/realtek/rtlwifi/rtl8188ee/trx.h   |  1 +
 drivers/net/wireless/ti/wlcore/main.c              |  2 +-
 9 files changed, 47 insertions(+), 32 deletions(-)
