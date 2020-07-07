Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30612217B7D
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 01:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbgGGXDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 19:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728001AbgGGXDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 19:03:42 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D26C061755;
        Tue,  7 Jul 2020 16:03:41 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id dm19so33817171edb.13;
        Tue, 07 Jul 2020 16:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=kTq/VH/p4TyQ5wPRzJwyOD8JsPzalLXL/D+9ThOBTJk=;
        b=E+virPP7R0DNmaCjVGtSUu/QcvSxTf4R7sOk6VcFsmCvGe0J84CcBd5HeNBiHdEGFF
         JmZI2QMdJ3elJ5MqdzZR/53PLHZyXBiuCFyv35oO8MHG9CZxR2Iq5EhY68cQJh6tS3FM
         8criJyFHjuNIStjyC28tRfZTtvROoXe7nu6rzuI3busfBGfKDruR6mMoncEkVbIcPRMU
         3N/NxjKHK7cc70B3dsJJ2bJ/tFj3dVtUDJmcxY3vtXJ/MTH3h7iZdQ/G7oUXSqNkMlnJ
         ECGvJ/Ssb2a2O9P/PsgcX12j0Sc5qUzPp+C5ZZ0LsYvGa3vZu43Jj4nfAT10J0pBwVjO
         sZhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kTq/VH/p4TyQ5wPRzJwyOD8JsPzalLXL/D+9ThOBTJk=;
        b=qPcEAtJ7p9UsL7lAOBpl+0zewZCrDH8dqEtaTjiXsyae++iZae88IfBCz+6TBKPvYT
         KGXBTrNLPARMtt7GpDdJsVkpzv6OIVZlkvzPZ3rk5huwbEKzneHwy61IT3TmkY9Z/XTD
         Rtfbon1E6TX8wHm24CBuDYOYsdVMGWCEpFZ4hV5voARPGI6Ab4mlATOIK3zYXMHxQNah
         /ymv5Tu6UGJwr4qqA+ZZfvYjIjapZiF3iqIy4eY6zjgxOT7FQf7MiV/9vK1elfKY401B
         Zj6IJFRI+Lh+WZGu8FqfsTte3oweqfGxWm2SM/ynf1TtR3Q7lgyfv4+lyNEF/fKo4Vp5
         ne1w==
X-Gm-Message-State: AOAM5317PrAOBbBOleAhSzdZsff0hux/xPg3vuu0J+jVR2Ftxjc+0TOM
        sbYEn+MTGuKivZ+VZ0fUbF4=
X-Google-Smtp-Source: ABdhPJyCkNHIU7Mg/3LR3/ROH8pv8slqj90hjhE3e1+AdXgWeG9fxZ5hQsBoE731r/kg9QH8KEcJqA==
X-Received: by 2002:aa7:d989:: with SMTP id u9mr46087113eds.85.1594163020678;
        Tue, 07 Jul 2020 16:03:40 -0700 (PDT)
Received: from net.saheed (54007186.dsl.pool.telekom.hu. [84.0.113.134])
        by smtp.gmail.com with ESMTPSA id f10sm27096310edx.5.2020.07.07.16.03.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 16:03:39 -0700 (PDT)
From:   Saheed Olayemi Bolarinwa <refactormyself@gmail.com>
To:     helgaas@kernel.org
Cc:     Bolarinwa Olayemi Saheed <refactormyself@gmail.com>,
        bjorn@helgaas.com, skhan@linuxfoundation.org,
        linux-pci@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, Russell Currey <ruscur@russell.cc>,
        Sam Bobroff <sbobroff@linux.ibm.com>,
        "Oliver O'Halloran" <oohall@gmail.com>,
        linuxppc-dev@lists.ozlabs.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, Lukas Wunner <lukas@wunner.de>,
        linux-acpi@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jakub Kicinski <kuba@kernel.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 0/13] PCI: Remove '*val = 0' from pcie_capability_read_*()
Date:   Wed,  8 Jul 2020 00:03:11 +0200
Message-Id: <20200707220324.8425-1-refactormyself@gmail.com>
X-Mailer: git-send-email 2.18.2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bolarinwa Olayemi Saheed <refactormyself@gmail.com>

MERGING:
Only Patch 13/13 depend on all preceeding patchs. All other patches are
independent of one another. Hence, please merge PATCH 13/13 only after
other patches in this series have been merged.

PATCH 6/13:
Make the function set status to "Power On" by default and only set to
Set "Power Off" only if pcie_capability_read_word() is successful and
(slot_ctrl & PCI_EXP_SLTCTL_PCC) == PCI_EXP_SLTCTL_PWR_OFF. 

PATCH 1/13 to 12/13:
Check the return value of pcie_capability_read_*() to ensure success or
confirm failure. While maintaining these functions, this ensures that the
changes in PATCH 13/13 does not introduce any bug. 

PATCH 13/13:
There are several reasons why a PCI capability read may fail whether the
device is present or not. If this happens, pcie_capability_read_*() will
return -EINVAL/PCIBIOS_BAD_REGISTER_NUMBER or PCIBIOS_DEVICE_NOT_FOUND
and *val is set to 0.

This behaviour if further ensured by this code inside
pcie_capability_read_*()

 ret = pci_read_config_dword(dev, pci_pcie_cap(dev) + pos, val);
 /*
  * Reset *val to 0 if pci_read_config_dword() fails, it may
  * have been written as 0xFFFFFFFF if hardware error happens
  * during pci_read_config_dword().
  */
 if (ret)
	 *val = 0;
 return ret;

a) Since all pci_generic_config_read() does is read a register value,
it may return success after reading a ~0 which *may* have been fabricated
by the PCI host bridge due to a read timeout. Hence pci_read_config_*() 
will return success with a fabricated ~0 in *val, indicating a problem.
In this case, the assumed behaviour of  pcie_capability_read_*() will be
wrong. To avoid error slipping through, more checks are necessary.

b) pci_read_config_*() will return PCIBIOS_DEVICE_NOT_FOUND only if 
dev->error_state = pci_channel_io_perm_failure (i.e. 
pci_dev_is_disconnected()) or if pci_generic_config_read() can't find the
device. In both cases *val is initially set to ~0 but as shown in the code
above pcie_capability_read_*() resets it back to 0. Even with this effort,
drivers still have to perform validation checks more so if 0 is a valid
value.

Most drivers only consider the case (b) and in some cases, there is the 
expectation that on timeout *val has a fabricated value of ~0, which *may*
not always be true as explained in (a).

In any case, checks need to be done to validate the value read and maybe
confirm which error has occurred. It is better left to the drivers to do.

Check the return value of pcie_capability_read_dword() to ensure success
and avoid bug as a result of Patch 13/13.
Remove the reset of *val to 0 when pci_read_config_*() fails.


Bolarinwa Olayemi Saheed (13):
  IB/hfi1: Check the return value of pcie_capability_read_*()
  misc: rtsx: Check the return value of pcie_capability_read_*()
  ath9k: Check the return value of pcie_capability_read_*()
  iwlegacy: Check the return value of pcie_capability_read_*()
  PCI: pciehp: Check the return value of pcie_capability_read_*()
  PCI: pciehp: Make "Power On" the default 
  PCI/ACPI: Check the return value of pcie_capability_read_*()
  PCI: pciehp: Check the return value of pcie_capability_read_*()
  PCI: Check the return value of pcie_capability_read_*()
  PCI/PM: Check return value of pcie_capability_read_*()
  PCI/AER: Check the return value of pcie_capability_read_*()
  PCI/ASPM: Check the return value of pcie_capability_read_*()
  PCI: Remove '*val = 0' from pcie_capability_read_*()

 drivers/net/wireless/ath/ath9k/pci.c         | 5 +++--
 drivers/net/wireless/intel/iwlegacy/common.c | 4 ++--
 drivers/infiniband/hw/hfi1/aspm.c | 7 ++++---
 drivers/misc/cardreader/rts5227.c | 5 +++--
 drivers/misc/cardreader/rts5249.c | 5 +++--
 drivers/misc/cardreader/rts5260.c | 5 +++--
 drivers/misc/cardreader/rts5261.c | 5 +++--
 drivers/pci/pcie/aer.c  |  5 +++--
 drivers/pci/pcie/aspm.c | 33 +++++++++++++++++----------------
 drivers/pci/hotplug/pciehp_hpc.c | 47 ++++++++++++++++----------------
 drivers/pci/pci-acpi.c           | 10 ++++---
 drivers/pci/probe.c              | 29 ++++++++++++--------
 drivers/pci/access.c | 14 --------------
 13 files changed, 87 insertions(+), 87 deletions(-)

-- 
2.18.2

