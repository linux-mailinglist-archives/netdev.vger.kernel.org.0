Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9E2381DED
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 12:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbhEPKUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 May 2021 06:20:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231386AbhEPKTx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 May 2021 06:19:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 768AD611CA;
        Sun, 16 May 2021 10:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621160317;
        bh=uz12JEUkFl1zk0MKhwqoy7Swq0yIqwlg559U5vqLb64=;
        h=From:To:Cc:Subject:Date:From;
        b=NZoYuL4T8pZP0XVsuqpo1xaXga3djUflecwXx5LGut8qbhlW3Y9NzBmiQJpti66iQ
         XEctA9a/tkYn6eIfMFOD23iU2NVyAWENwzAu5GTKImts+lpuYv0eNqgw/CUZ2ZkWss
         fllyfJ2EOkHcmxftZ1iXvAx83SROwJwSmenZXooYhJTuiuJxIyQ+zDnL2KcckWJO3l
         HXjHP9OcKsGcnNSkEPNKSqumMlW9xOUSyWQbW7rfHCgaVLEVCKAvIaHdwvFlEJ1a7n
         T0Jc41mYwmUESpLNWcMxWdQoD+Yw7News+EAAT/i+fb8vmW0PjoNLGp13h2ptdOtyU
         rkJ7P+/53g9gg==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1liDr1-003o89-5Z; Sun, 16 May 2021 12:18:35 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Corentin Labbe <clabbe@baylibre.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Jean Delvare <jdelvare@suse.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Leo Yan <leo.yan@linaro.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mike Leach <mike.leach@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Thorsten Leemhuis <linux@leemhuis.info>,
        alsa-devel@alsa-project.org, coresight@lists.linaro.org,
        intel-wired-lan@lists.osuosl.org, kvm@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ext4@vger.kernel.org, linux-hwmon@vger.kernel.org,
        linux-media@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-usb@vger.kernel.org, mjpeg-users@lists.sourceforge.net,
        netdev@vger.kernel.org, rcu@vger.kernel.org
Subject: [PATCH v3 00/16] Replace some bad characters on documents
Date:   Sun, 16 May 2021 12:18:17 +0200
Message-Id: <cover.1621159997.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The conversion tools used during DocBook/LaTeX/html/Markdown->ReST 
conversion and some cut-and-pasted text contain some characters that
aren't easily reachable on standard keyboards and/or could cause 
troubles when parsed by the documentation build system.

Replace the occurences of the following characters:

            - U+00a0 (' '): NO-BREAK SPACE
            - U+00ad ('­'): SOFT HYPHEN
            - U+2010 ('‐'): HYPHEN
            - U+2217 ('∗'): ASTERISK OPERATOR
            - U+feff ('﻿'): BOM

I'll submit in separate another series to address other character occurrences.

v3:
  - removed curly commas and changed the patch descriptions.
v2:
  - removed EM/EN dashes and changed the patch descriptions.


Mauro Carvalho Chehab (16):
  docs: hwmon: ir36021.rst: replace some characters
  docs: admin-guide: reporting-issues.rst: replace some characters
  docs: trace: coresight: coresight-etm4x-reference.rst: replace some
    characters
  docs: driver-api: ioctl.rst: replace some characters
  docs: driver-api: media: drivers: zoran.rst: replace some characters
  docs: usb: replace some characters
  docs: userspace-api: media: v4l: dev-decoder.rst: replace some
    characters
  docs: userspace-api: media: dvb: intro.rst: replace some characters
  docs: vm: zswap.rst: replace some characters
  docs: filesystems: ext4: blockgroup.rst: replace some characters
  docs: networking: device_drivers: replace some characters
  docs: PCI: acpi-info.rst: replace some characters
  docs: sound: kernel-api: writing-an-alsa-driver.rst: replace some
    characters
  docs: firmware-guide: acpi: dsd: graph.rst: replace some characters
  docs: virt: kvm: api.rst: replace some characters
  docs: RCU: replace some characters

 Documentation/PCI/acpi-info.rst               | 18 ++---
 .../Data-Structures/Data-Structures.rst       | 46 ++++++------
 .../Expedited-Grace-Periods.rst               | 36 +++++-----
 .../Tree-RCU-Memory-Ordering.rst              |  2 +-
 .../RCU/Design/Requirements/Requirements.rst  | 70 +++++++++----------
 .../admin-guide/reporting-issues.rst          |  2 +-
 Documentation/driver-api/ioctl.rst            |  8 +--
 .../driver-api/media/drivers/zoran.rst        |  2 +-
 Documentation/filesystems/ext4/blockgroup.rst |  2 +-
 .../firmware-guide/acpi/dsd/graph.rst         |  2 +-
 Documentation/hwmon/ir36021.rst               |  2 +-
 .../device_drivers/ethernet/intel/i40e.rst    |  6 +-
 .../device_drivers/ethernet/intel/iavf.rst    |  2 +-
 .../kernel-api/writing-an-alsa-driver.rst     |  2 +-
 .../coresight/coresight-etm4x-reference.rst   |  2 +-
 Documentation/usb/ehci.rst                    |  2 +-
 Documentation/usb/gadget_printer.rst          |  2 +-
 .../userspace-api/media/dvb/intro.rst         |  4 +-
 .../userspace-api/media/v4l/dev-decoder.rst   |  2 +-
 Documentation/virt/kvm/api.rst                | 28 ++++----
 Documentation/vm/zswap.rst                    |  4 +-
 21 files changed, 122 insertions(+), 122 deletions(-)

-- 
2.31.1


