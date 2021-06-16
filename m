Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F0B3A9349
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 08:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbhFPG5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 02:57:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:34578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231168AbhFPG5X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 02:57:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E86AE613B9;
        Wed, 16 Jun 2021 06:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623826518;
        bh=JNLoEzRSUmckl8eLY94oHxsjeBDCiLlJ5aZAc+3RHhw=;
        h=From:To:Cc:Subject:Date:From;
        b=bIRjmcsZh0nDrGHZVv9Hdcp/Q7V4uZte3M33hb9qtbnnI2Do02YGKEM+D6wRBXJX8
         fXP7U8eEtlIoGGBRfcltvRJKfVLv6QfEzHWXg0RqgPTC/cqVmoVPlD3eInloJymMLC
         YFImERmycprD4hLIQfwK4FMud3KE6g98aGIK3QdPZWSv6z/ri/7N3dR5lTH3MJ8aUe
         Bp3u9e2L/j8FbtxvpC2tQVJI5GuWTuVepuuIxKMIBQ2anYz1TSwnwP/6dC4Hclk/V0
         JEx814LnbdMa7n/p9vSS8FAmzoK9B1aSqdGnO1eWFyBdMyWaXbzC4IY2JvfPF0KgqH
         Uy3+bF3abccxA==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1ltPSG-004lCD-7Q; Wed, 16 Jun 2021 08:55:16 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Jonathan Corbet <corbet@lwn.net>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jakub Kicinski <kuba@kernel.org>, Leo Yan <leo.yan@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Thorsten Leemhuis <linux@leemhuis.info>,
        coresight@lists.linaro.org, intel-wired-lan@lists.osuosl.org,
        linux-arm-kernel@lists.infradead.org, linux-ext4@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 0/8] Replace some bad characters on documents
Date:   Wed, 16 Jun 2021 08:55:06 +0200
Message-Id: <cover.1623826294.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jon,

This series contain the remaining 8 patches I submitted at v3 that
weren't merged yet at -next.

This series is rebased on the top of your docs-next branch.

No changes here, except by some Reviewed/ack lines, and at the
name of the final patch (per PCI maintainer's request).

Mauro Carvalho Chehab (8):
  docs: admin-guide: reporting-issues.rst: replace some characters
  docs: trace: coresight: coresight-etm4x-reference.rst: replace some
    characters
  docs: driver-api: ioctl.rst: replace some characters
  docs: usb: replace some characters
  docs: vm: zswap.rst: replace some characters
  docs: filesystems: ext4: blockgroup.rst: replace some characters
  docs: networking: device_drivers: replace some characters
  docs: PCI: Replace non-breaking spaces to avoid PDF issues

 Documentation/PCI/acpi-info.rst                | 18 +++++++++---------
 Documentation/admin-guide/reporting-issues.rst |  2 +-
 Documentation/driver-api/ioctl.rst             |  8 ++++----
 Documentation/filesystems/ext4/blockgroup.rst  |  2 +-
 .../device_drivers/ethernet/intel/i40e.rst     |  6 +++---
 .../device_drivers/ethernet/intel/iavf.rst     |  2 +-
 .../coresight/coresight-etm4x-reference.rst    |  2 +-
 Documentation/usb/ehci.rst                     |  2 +-
 Documentation/usb/gadget_printer.rst           |  2 +-
 Documentation/vm/zswap.rst                     |  4 ++--
 10 files changed, 24 insertions(+), 24 deletions(-)

-- 
2.31.1


