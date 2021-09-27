Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9902E41A070
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 22:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237007AbhI0Uqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 16:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236921AbhI0Uqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 16:46:44 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACECC061604
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 13:45:06 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mUxTe-0001jl-FQ; Mon, 27 Sep 2021 22:43:54 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mUxTX-0001YL-VH; Mon, 27 Sep 2021 22:43:47 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mUxTX-0001Li-Pk; Mon, 27 Sep 2021 22:43:47 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, linux-pci@vger.kernel.org,
        kernel@pengutronix.de, Alexander Duyck <alexanderduyck@fb.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "H. Peter Anvin" <hpa@zytor.com>, Ido Schimmel <idosch@nvidia.com>,
        Ingo Molnar <mingo@redhat.com>, Jack Xu <jack.xu@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        Juergen Gross <jgross@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Michael Buesch <m@bues.ch>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Namhyung Kim <namhyung@kernel.org>,
        "Oliver O'Halloran" <oohall@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Russell Currey <ruscur@russell.cc>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Simon Horman <simon.horman@corigine.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomaszx Kowalik <tomaszx.kowalik@intel.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        qat-linux@intel.com, x86@kernel.org, xen-devel@lists.xenproject.org
Subject: [PATCH v4 0/8] PCI: Drop duplicated tracking of a pci_dev's bound driver
Date:   Mon, 27 Sep 2021 22:43:18 +0200
Message-Id: <20210927204326.612555-1-uwe@kleine-koenig.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Hello,

this is v4 of the quest to drop the "driver" member from struct pci_dev
which tracks the same data (apart from a constant offset) as dev.driver.

Changes since v3:
 - Add some Reviewed-by and Acked-by tags
 - Rebase to v5.15-rc3 (no conflicts)
 - Changes in patch #4 addressing review comments by Christoph Hellwig

I didn't do extensive build tests, so I might have missed a build
problem. I have some builds running, but want to get some feedback on
the changes suggested by Christoph.

Best regards
Uwe

Uwe Kleine-König (8):
  PCI: Simplify pci_device_remove()
  PCI: Drop useless check from pci_device_probe()
  xen/pci: Drop some checks that are always true
  PCI: replace pci_dev::driver usage that gets the driver name
  scsi: message: fusion: Remove unused parameter of mpt_pci driver's
    probe()
  crypto: qat - simplify adf_enable_aer()
  PCI: Replace pci_dev::driver usage by pci_dev::dev.driver
  PCI: Drop duplicated tracking of a pci_dev's bound driver

 arch/powerpc/include/asm/ppc-pci.h            |  9 ++-
 arch/powerpc/kernel/eeh_driver.c              | 10 +--
 arch/x86/events/intel/uncore.c                |  2 +-
 arch/x86/kernel/probe_roms.c                  |  2 +-
 drivers/bcma/host_pci.c                       |  7 ++-
 drivers/crypto/hisilicon/qm.c                 |  2 +-
 drivers/crypto/qat/qat_4xxx/adf_drv.c         |  7 +--
 drivers/crypto/qat/qat_c3xxx/adf_drv.c        |  7 +--
 drivers/crypto/qat/qat_c62x/adf_drv.c         |  7 +--
 drivers/crypto/qat/qat_common/adf_aer.c       | 10 +--
 .../crypto/qat/qat_common/adf_common_drv.h    |  2 +-
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c     |  7 +--
 drivers/message/fusion/mptbase.c              |  7 +--
 drivers/message/fusion/mptbase.h              |  2 +-
 drivers/message/fusion/mptctl.c               |  4 +-
 drivers/message/fusion/mptlan.c               |  2 +-
 drivers/misc/cxl/guest.c                      | 24 ++++---
 drivers/misc/cxl/pci.c                        | 30 +++++----
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    |  2 +-
 .../ethernet/marvell/prestera/prestera_pci.c  |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c     |  2 +-
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  |  2 +-
 drivers/pci/iov.c                             | 25 +++++---
 drivers/pci/pci-driver.c                      | 45 ++++++-------
 drivers/pci/pci.c                             |  4 +-
 drivers/pci/pcie/err.c                        | 36 ++++++-----
 drivers/pci/xen-pcifront.c                    | 63 +++++++++----------
 drivers/ssb/pcihost_wrapper.c                 |  8 ++-
 drivers/usb/host/xhci-pci.c                   |  2 +-
 include/linux/pci.h                           |  1 -
 30 files changed, 166 insertions(+), 167 deletions(-)


base-commit: 5816b3e6577eaa676ceb00a848f0fd65fe2adc29
-- 
2.30.2

