Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA101A82E0
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 17:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439961AbgDNPfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 11:35:31 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:19418 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2439903AbgDNPfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 11:35:11 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1586878510; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=zwVm3N6lynEaYOGDVZOBioQGpxXYlDM1rp/MNP2pfUQ=; b=Cw+afaOR06tYCa0MfkFfhiu4V4wT3G43pZAEtmEoz7knX5ehOADOelJpBxrlBJa9/6Jc4xOZ
 E2D/VnnK3bSQmG36oqqLdF264OVAPEpxi3B6dryR6WuB0Vg9BggWIvDprrIttGNdtXM7HxKs
 +d/Fpol8sLAEdCBVs7mTbCaDAvg=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e95d825.7fb14ca1ba78-smtp-out-n02;
 Tue, 14 Apr 2020 15:35:01 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E59C9C432C2; Tue, 14 Apr 2020 15:35:00 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 13ECDC433F2;
        Tue, 14 Apr 2020 15:34:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 13ECDC433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-2020-04-14
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20200414153500.E59C9C432C2@smtp.codeaurora.org>
Date:   Tue, 14 Apr 2020 15:35:00 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit 0452800f6db4ed0a42ffb15867c0acfd68829f6a:

  net: dsa: mt7530: fix null pointer dereferencing in port5 setup (2020-04-03 16:10:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-2020-04-14

for you to fetch changes up to 7dc7c41607d192ff660ba4ea82d517745c1d7523:

  rtw88: avoid unused function warnings (2020-04-14 15:45:36 +0300)

----------------------------------------------------------------
wireless-drivers fixes for v5.7

First set of fixes for v5.6. Fixes for a crash and for two compiler
warnings.

brcmfmac

* fix a crash related to monitor interface

ath11k

* fix compiler warnings without CONFIG_THERMAL

rtw88

* fix compiler warnings related to suspend and resume functions

----------------------------------------------------------------
Arnd Bergmann (1):
      rtw88: avoid unused function warnings

Rafał Miłecki (1):
      brcmfmac: add stub for monitor interface xmit

YueHaibing (1):
      ath11k: fix compiler warnings without CONFIG_THERMAL

 drivers/net/wireless/ath/ath11k/thermal.h               |  3 ++-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c |  9 +++++++++
 drivers/net/wireless/realtek/rtw88/pci.c                | 11 +++--------
 3 files changed, 14 insertions(+), 9 deletions(-)
