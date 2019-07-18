Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08C446CF68
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 16:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403813AbfGRODa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 10:03:30 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49016 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390391AbfGROD3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 10:03:29 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E5DD960E5C; Thu, 18 Jul 2019 14:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563458609;
        bh=z+kGUfaXfhyP2uVpB2cL+swut/NwkjyopUAnTQSr58o=;
        h=From:To:Cc:Subject:Date:From;
        b=L1VDOS5VY2yfl/+dUUs2UaLZHnK3OqbIGjNAxCP5pMHZQZZEs/WSepurvxufOnT+P
         4dnVraL6oEGRqAzVnXSlQRyp9wZ3Y7PuP1qi3uVsUJ0n1W2BXKvpoVfUyuot2nG/l6
         srEHB9h6ZgN9qJyF+RY+vzDsq+vv78bqQVSm4Go8=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6667B60E5C;
        Thu, 18 Jul 2019 14:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563458607;
        bh=z+kGUfaXfhyP2uVpB2cL+swut/NwkjyopUAnTQSr58o=;
        h=From:To:Cc:Subject:Date:From;
        b=nuJDLqHleP27YuI8FF2cx++XvLzq/3tKBQWvWJMrx+AFUsoT7KJjA5QAHa2BzPfL3
         +Jq+wzGR0aPPPCRTYEQOIXI3LKD1e2HMfwXpRBaC/BX5nS8pTejg7r8h+SQjLWfDFl
         eSFKJ+rIoQVK7ogEOLO16GB2vn7aydK87b8OVcpk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6667B60E5C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers 2019-07-18
Date:   Thu, 18 Jul 2019 17:03:24 +0300
Message-ID: <87y30v1lub.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

here are first fixes which have accumulated during the merge window.
This pull request is to net tree for 5.3. Please let me know if there
are any problems.

Kalle

The following changes since commit 76104862cccaeaa84fdd23e39f2610a96296291c:

  sky2: Disable MSI on P5W DH Deluxe (2019-07-14 13:45:54 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-for-davem-2019-07-18

for you to fetch changes up to 41a531ffa4c5aeb062f892227c00fabb3b4a9c91:

  rt2x00usb: fix rx queue hang (2019-07-15 20:52:18 +0300)

----------------------------------------------------------------
wireless-drivers fixes for 5.3

First set of fixes for 5.3.

iwlwifi

* add new cards for 9000 and 20000 series and qu c-step devices

ath10k

* workaround an uninitialised variable warning

rt2x00

* fix rx queue hand on USB

----------------------------------------------------------------
Arnd Bergmann (1):
      ath10k: work around uninitialized vht_pfr variable

Ihab Zhaika (1):
      iwlwifi: add new cards for 9000 and 20000 series

Luca Coelho (1):
      iwlwifi: pcie: add support for qu c-step devices

Soeren Moch (1):
      rt2x00usb: fix rx queue hang

 drivers/net/wireless/ath/ath10k/mac.c           |  2 +
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c  | 53 +++++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-config.h |  7 ++++
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h    |  2 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c   | 23 +++++++++++
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c  | 12 +++---
 6 files changed, 93 insertions(+), 6 deletions(-)
