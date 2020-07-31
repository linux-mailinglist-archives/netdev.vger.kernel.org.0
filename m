Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A786B234AFA
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 20:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387866AbgGaS1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 14:27:54 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:26638 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387841AbgGaS1u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 14:27:50 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596220069; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=S8XeKCmkQHOV3cQ6vfseomy/7CKwe+QQyLxczgc9k0M=; b=J152i/GaJy4+rjuJiplePLb/Mgnd4JtvH2WwI2QI97JK9JAvrFWC6sCmQt4eMRpkO4nlCzHV
 kTBGeu5HLbCpn3fTHEvFoHo7HaJJPoyHoM/xEeRRv3fy/rqLMdsbkO4pPnDfYIvvTfEHLVOc
 3HYPrNABYUlLCRT82ZvLNRO3NJQ=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n18.prod.us-west-2.postgun.com with SMTP id
 5f246299710a7a29d53b9963 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 31 Jul 2020 18:27:37
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 529C1C433A0; Fri, 31 Jul 2020 18:27:36 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from pillair-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pillair)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3507DC433C6;
        Fri, 31 Jul 2020 18:27:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3507DC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Rakesh Pillai <pillair@codeaurora.org>
Subject: [PATCH v2 0/3] 
Date:   Fri, 31 Jul 2020 23:57:19 +0530
Message-Id: <1596220042-2778-1-git-send-email-pillair@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The history recording will be compiled only if
ATH10K_DEBUG is enabled, and also enabled via
the module parameter. Once the history recording
is enabled via module parameter, it can be enabled
or disabled runtime via debugfs.

---
Changes from v1:
- Add module param and debugfs to enable/disable history recording.

Rakesh Pillai (3):
  ath10k: Add history for tracking certain events
  ath10k: Add module param to enable history
  ath10k: Add debugfs support to enable event history

 drivers/net/wireless/ath/ath10k/ce.c      |   1 +
 drivers/net/wireless/ath/ath10k/core.c    |   3 +
 drivers/net/wireless/ath/ath10k/core.h    |  82 ++++++++++++
 drivers/net/wireless/ath/ath10k/debug.c   | 207 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/debug.h   |  75 +++++++++++
 drivers/net/wireless/ath/ath10k/snoc.c    |  15 ++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |   1 +
 drivers/net/wireless/ath/ath10k/wmi.c     |  10 ++
 8 files changed, 393 insertions(+), 1 deletion(-)

-- 
2.7.4

