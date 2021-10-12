Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B109D42B02C
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 01:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235963AbhJLXeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 19:34:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233923AbhJLXeQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 19:34:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7F0960E0C;
        Tue, 12 Oct 2021 23:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634081534;
        bh=/npIVjxwllsU1MvqYG6qf+2Jsb2z0DMOJrkQH5LJfwo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=X9EJE3R2xP4x4bVh2T0Pu0yz3q+/jn8+4ch5hF1hS+Tg6jJq+32djVm8KAazh4saE
         +jPQGp0hdZ7/uvlWQktYqR/MGIMvcav1y2Pjf1ExGXg3nitnr7t1qpTq2t/eGRT4W/
         OlSs8mhaylMclOfEZCeVTc6lQt/8x6AgMCxdfrJ/Cib++a9tXxYwZ/4QuVxwyjRm5M
         S5ZuNwNzjSKHpixcaI7YxpLom8rWEURnTarOkuUwFQD3x3fIxZawRPON+EWGQDmEUc
         a4tzG7fzwC6aWNb1/UlbEws/pv5qs7Kk9xRQWHj9QLRym9WYypMS9Wz+iAiaxuyBz+
         nG6QlGYpJGxfQ==
Date:   Tue, 12 Oct 2021 18:32:12 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     linux-pci@vger.kernel.org, kernel@pengutronix.de,
        Alexander Duyck <alexanderduyck@fb.com>,
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
        Oliver O'Halloran <oohall@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
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
Subject: Re: [PATCH v6 00/11] PCI: Drop duplicated tracking of a pci_dev's
 bound driver
Message-ID: <20211012233212.GA1806189@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211004125935.2300113-1-u.kleine-koenig@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 02:59:24PM +0200, Uwe Kleine-König wrote:
> Hello,
> 
> this is v6 of the quest to drop the "driver" member from struct pci_dev
> which tracks the same data (apart from a constant offset) as dev.driver.

I like this a lot and applied it to pci/driver for v5.16, thanks!

I split some of the bigger patches apart so they only touched one
driver or subsystem at a time.  I also updated to_pci_driver() so it
returns NULL when given NULL, which makes some of the validations
quite a bit simpler, especially in the PM code in pci-driver.c.

Full interdiff from this v6 series:

diff --git a/arch/x86/kernel/probe_roms.c b/arch/x86/kernel/probe_roms.c
index deaaef6efe34..36e84d904260 100644
--- a/arch/x86/kernel/probe_roms.c
+++ b/arch/x86/kernel/probe_roms.c
@@ -80,17 +80,15 @@ static struct resource video_rom_resource = {
  */
 static bool match_id(struct pci_dev *pdev, unsigned short vendor, unsigned short device)
 {
+	struct pci_driver *drv = to_pci_driver(pdev->dev.driver);
 	const struct pci_device_id *id;
 
 	if (pdev->vendor == vendor && pdev->device == device)
 		return true;
 
-	if (pdev->dev.driver) {
-		struct pci_driver *drv = to_pci_driver(pdev->dev.driver);
-		for (id = drv->id_table; id && id->vendor; id++)
-			if (id->vendor == vendor && id->device == device)
-				break;
-	}
+	for (id = drv ? drv->id_table : NULL; id && id->vendor; id++)
+		if (id->vendor == vendor && id->device == device)
+			break;
 
 	return id && id->vendor;
 }
diff --git a/drivers/misc/cxl/guest.c b/drivers/misc/cxl/guest.c
index d997c9c3ebb5..7eb3706cf42d 100644
--- a/drivers/misc/cxl/guest.c
+++ b/drivers/misc/cxl/guest.c
@@ -20,38 +20,38 @@ static void pci_error_handlers(struct cxl_afu *afu,
 				pci_channel_state_t state)
 {
 	struct pci_dev *afu_dev;
+	struct pci_driver *afu_drv;
+	struct pci_error_handlers *err_handler;
 
 	if (afu->phb == NULL)
 		return;
 
 	list_for_each_entry(afu_dev, &afu->phb->bus->devices, bus_list) {
-		struct pci_driver *afu_drv;
-
-		if (!afu_dev->dev.driver)
-			continue;
-
 		afu_drv = to_pci_driver(afu_dev->dev.driver);
+		if (!afu_drv)
+			continue;
 
+		err_handler = afu_drv->err_handler;
 		switch (bus_error_event) {
 		case CXL_ERROR_DETECTED_EVENT:
 			afu_dev->error_state = state;
 
-			if (afu_drv->err_handler &&
-			    afu_drv->err_handler->error_detected)
-				afu_drv->err_handler->error_detected(afu_dev, state);
-		break;
+			if (err_handler &&
+			    err_handler->error_detected)
+				err_handler->error_detected(afu_dev, state);
+			break;
 		case CXL_SLOT_RESET_EVENT:
 			afu_dev->error_state = state;
 
-			if (afu_drv->err_handler &&
-			    afu_drv->err_handler->slot_reset)
-				afu_drv->err_handler->slot_reset(afu_dev);
-		break;
+			if (err_handler &&
+			    err_handler->slot_reset)
+				err_handler->slot_reset(afu_dev);
+			break;
 		case CXL_RESUME_EVENT:
-			if (afu_drv->err_handler &&
-			    afu_drv->err_handler->resume)
-				afu_drv->err_handler->resume(afu_dev);
-		break;
+			if (err_handler &&
+			    err_handler->resume)
+				err_handler->resume(afu_dev);
+			break;
 		}
 	}
 }
diff --git a/drivers/misc/cxl/pci.c b/drivers/misc/cxl/pci.c
index 7e7545d01e27..08bd81854101 100644
--- a/drivers/misc/cxl/pci.c
+++ b/drivers/misc/cxl/pci.c
@@ -1795,6 +1795,8 @@ static pci_ers_result_t cxl_vphb_error_detected(struct cxl_afu *afu,
 						pci_channel_state_t state)
 {
 	struct pci_dev *afu_dev;
+	struct pci_driver *afu_drv;
+	struct pci_error_handlers *err_handler;
 	pci_ers_result_t result = PCI_ERS_RESULT_NEED_RESET;
 	pci_ers_result_t afu_result = PCI_ERS_RESULT_NEED_RESET;
 
@@ -1805,16 +1807,16 @@ static pci_ers_result_t cxl_vphb_error_detected(struct cxl_afu *afu,
 		return result;
 
 	list_for_each_entry(afu_dev, &afu->phb->bus->devices, bus_list) {
-		struct pci_driver *afu_drv;
-		if (!afu_dev->dev.driver)
-			continue;
-
 		afu_drv = to_pci_driver(afu_dev->dev.driver);
+		if (!afu_drv)
+			continue;
 
 		afu_dev->error_state = state;
 
-		if (afu_drv->err_handler)
-			afu_result = afu_drv->err_handler->error_detected(afu_dev, state);
+		err_handler = afu_drv->err_handler;
+		if (err_handler)
+			afu_result = err_handler->error_detected(afu_dev,
+								 state);
 		/* Disconnect trumps all, NONE trumps NEED_RESET */
 		if (afu_result == PCI_ERS_RESULT_DISCONNECT)
 			result = PCI_ERS_RESULT_DISCONNECT;
@@ -1974,6 +1976,8 @@ static pci_ers_result_t cxl_pci_slot_reset(struct pci_dev *pdev)
 	struct cxl_afu *afu;
 	struct cxl_context *ctx;
 	struct pci_dev *afu_dev;
+	struct pci_driver *afu_drv;
+	struct pci_error_handlers *err_handler;
 	pci_ers_result_t afu_result = PCI_ERS_RESULT_RECOVERED;
 	pci_ers_result_t result = PCI_ERS_RESULT_RECOVERED;
 	int i;
@@ -2005,8 +2009,6 @@ static pci_ers_result_t cxl_pci_slot_reset(struct pci_dev *pdev)
 			continue;
 
 		list_for_each_entry(afu_dev, &afu->phb->bus->devices, bus_list) {
-			struct pci_driver *afu_drv;
-
 			/* Reset the device context.
 			 * TODO: make this less disruptive
 			 */
@@ -2032,14 +2034,13 @@ static pci_ers_result_t cxl_pci_slot_reset(struct pci_dev *pdev)
 			 * shouldn't start new work until we call
 			 * their resume function.
 			 */
-			if (!afu_dev->dev.driver)
-				continue;
-
 			afu_drv = to_pci_driver(afu_dev->dev.driver);
+			if (!afu_drv)
+				continue;
 
-			if (afu_drv->err_handler &&
-			    afu_drv->err_handler->slot_reset)
-				afu_result = afu_drv->err_handler->slot_reset(afu_dev);
+			err_handler = afu_drv->err_handler;
+			if (err_handler && err_handler->slot_reset)
+				afu_result = err_handler->slot_reset(afu_dev);
 
 			if (afu_result == PCI_ERS_RESULT_DISCONNECT)
 				result = PCI_ERS_RESULT_DISCONNECT;
@@ -2066,6 +2067,8 @@ static void cxl_pci_resume(struct pci_dev *pdev)
 	struct cxl *adapter = pci_get_drvdata(pdev);
 	struct cxl_afu *afu;
 	struct pci_dev *afu_dev;
+	struct pci_driver *afu_drv;
+	struct pci_error_handlers *err_handler;
 	int i;
 
 	/* Everything is back now. Drivers should restart work now.
@@ -2080,11 +2083,13 @@ static void cxl_pci_resume(struct pci_dev *pdev)
 			continue;
 
 		list_for_each_entry(afu_dev, &afu->phb->bus->devices, bus_list) {
-			struct pci_driver *afu_drv;
-			if (afu_dev->dev.driver &&
-			    (afu_drv = to_pci_driver(afu_dev->dev.driver))->err_handler &&
-			    afu_drv->err_handler->resume)
-				afu_drv->err_handler->resume(afu_dev);
+			afu_drv = to_pci_driver(afu_dev->dev.driver);
+			if (!afu_drv)
+				continue;
+
+			err_handler = afu_drv->err_handler;
+			if (err_handler && err_handler->resume)
+				err_handler->resume(afu_dev);
 		}
 	}
 	spin_unlock(&adapter->afu_list_lock);
diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 0d0a34347868..fa4b52bb1e05 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -168,11 +168,8 @@ static ssize_t sriov_vf_total_msix_show(struct device *dev,
 	u32 vf_total_msix = 0;
 
 	device_lock(dev);
-	if (!dev->driver)
-		goto unlock;
-
 	pdrv = to_pci_driver(dev->driver);
-	if (!pdrv->sriov_get_vf_total_msix)
+	if (!pdrv || !pdrv->sriov_get_vf_total_msix)
 		goto unlock;
 
 	vf_total_msix = pdrv->sriov_get_vf_total_msix(pdev);
@@ -199,19 +196,14 @@ static ssize_t sriov_vf_msix_count_store(struct device *dev,
 		return -EINVAL;
 
 	device_lock(&pdev->dev);
-	if (!pdev->dev.driver) {
-		ret = -EOPNOTSUPP;
-		goto err_pdev;
-	}
-
-	pdrv = to_pci_driver(pdev->dev.driver);
-	if (!pdrv->sriov_set_msix_vec_count) {
+	pdrv = to_pci_driver(dev->driver);
+	if (!pdrv || !pdrv->sriov_set_msix_vec_count) {
 		ret = -EOPNOTSUPP;
 		goto err_pdev;
 	}
 
 	device_lock(&vf_dev->dev);
-	if (vf_dev->dev.driver) {
+	if (to_pci_driver(vf_dev->dev.driver)) {
 		/*
 		 * A driver is already attached to this VF and has configured
 		 * itself based on the current MSI-X vector count. Changing
@@ -405,14 +397,13 @@ static ssize_t sriov_numvfs_store(struct device *dev,
 		goto exit;
 
 	/* is PF driver loaded */
-	if (!pdev->dev.driver) {
+	pdrv = to_pci_driver(dev->driver);
+	if (!pdrv) {
 		pci_info(pdev, "no driver bound to device; cannot configure SR-IOV\n");
 		ret = -ENOENT;
 		goto exit;
 	}
 
-	pdrv = to_pci_driver(pdev->dev.driver);
-
 	/* is PF driver loaded w/callback */
 	if (!pdrv->sriov_configure) {
 		pci_info(pdev, "driver does not support SR-IOV configuration via sysfs\n");
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index e94aa338bab4..3884a1542e86 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -454,7 +454,7 @@ static int pci_device_probe(struct device *dev)
 static void pci_device_remove(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	struct pci_driver *drv = to_pci_driver(pci_dev->dev.driver);
+	struct pci_driver *drv = to_pci_driver(dev->driver);
 
 	if (drv->remove) {
 		pm_runtime_get_sync(dev);
@@ -489,15 +489,12 @@ static void pci_device_remove(struct device *dev)
 static void pci_device_shutdown(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct pci_driver *drv = to_pci_driver(dev->driver);
 
 	pm_runtime_resume(dev);
 
-	if (pci_dev->dev.driver) {
-		struct pci_driver *drv = to_pci_driver(pci_dev->dev.driver);
-
-		if (drv->shutdown)
-			drv->shutdown(pci_dev);
-	}
+	if (drv && drv->shutdown)
+		drv->shutdown(pci_dev);
 
 	/*
 	 * If this is a kexec reboot, turn off Bus Master bit on the
@@ -588,25 +585,22 @@ static int pci_pm_reenable_device(struct pci_dev *pci_dev)
 static int pci_legacy_suspend(struct device *dev, pm_message_t state)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct pci_driver *drv = to_pci_driver(dev->driver);
 
-	if (dev->driver) {
-		struct pci_driver *drv = to_pci_driver(dev->driver);
+	if (drv && drv->suspend) {
+		pci_power_t prev = pci_dev->current_state;
+		int error;
 
-		if (drv->suspend) {
-			pci_power_t prev = pci_dev->current_state;
-			int error;
+		error = drv->suspend(pci_dev, state);
+		suspend_report_result(drv->suspend, error);
+		if (error)
+			return error;
 
-			error = drv->suspend(pci_dev, state);
-			suspend_report_result(drv->suspend, error);
-			if (error)
-				return error;
-
-			if (!pci_dev->state_saved && pci_dev->current_state != PCI_D0
-			    && pci_dev->current_state != PCI_UNKNOWN) {
-				pci_WARN_ONCE(pci_dev, pci_dev->current_state != prev,
-					      "PCI PM: Device state not saved by %pS\n",
-					      drv->suspend);
-			}
+		if (!pci_dev->state_saved && pci_dev->current_state != PCI_D0
+		    && pci_dev->current_state != PCI_UNKNOWN) {
+			pci_WARN_ONCE(pci_dev, pci_dev->current_state != prev,
+				      "PCI PM: Device state not saved by %pS\n",
+				      drv->suspend);
 		}
 	}
 
@@ -632,17 +626,12 @@ static int pci_legacy_suspend_late(struct device *dev, pm_message_t state)
 static int pci_legacy_resume(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct pci_driver *drv = to_pci_driver(dev->driver);
 
 	pci_fixup_device(pci_fixup_resume, pci_dev);
 
-	if (pci_dev->dev.driver) {
-		struct pci_driver *drv = to_pci_driver(pci_dev->dev.driver);
-
-		if (drv->resume)
-			return drv->resume(pci_dev);
-	}
-
-	return pci_pm_reenable_device(pci_dev);
+	return drv && drv->resume ?
+			drv->resume(pci_dev) : pci_pm_reenable_device(pci_dev);
 }
 
 /* Auxiliary functions used by the new power management framework */
@@ -656,14 +645,8 @@ static void pci_pm_default_suspend(struct pci_dev *pci_dev)
 
 static bool pci_has_legacy_pm_support(struct pci_dev *pci_dev)
 {
-	struct pci_driver *drv;
-	bool ret;
-
-	if (!pci_dev->dev.driver)
-		return false;
-
-	drv = to_pci_driver(pci_dev->dev.driver);
-	ret = drv && (drv->suspend || drv->resume);
+	struct pci_driver *drv = to_pci_driver(pci_dev->dev.driver);
+	bool ret = drv && (drv->suspend || drv->resume);
 
 	/*
 	 * Legacy PM support is used by default, so warn if the new framework is
@@ -1255,11 +1238,11 @@ static int pci_pm_runtime_suspend(struct device *dev)
 	int error;
 
 	/*
-	 * If pci_dev->dev.driver is not set (unbound), we leave the device in D0,
-	 * but it may go to D3cold when the bridge above it runtime suspends.
-	 * Save its config space in case that happens.
+	 * If the device has no driver, we leave it in D0, but it may go to
+	 * D3cold when the bridge above it runtime suspends.  Save its
+	 * config space in case that happens.
 	 */
-	if (!pci_dev->dev.driver) {
+	if (!to_pci_driver(dev->driver)) {
 		pci_save_state(pci_dev);
 		return 0;
 	}
@@ -1316,7 +1299,7 @@ static int pci_pm_runtime_resume(struct device *dev)
 	 */
 	pci_restore_standard_config(pci_dev);
 
-	if (!dev->driver)
+	if (!to_pci_driver(dev->driver))
 		return 0;
 
 	pci_fixup_device(pci_fixup_resume_early, pci_dev);
@@ -1335,13 +1318,14 @@ static int pci_pm_runtime_resume(struct device *dev)
 
 static int pci_pm_runtime_idle(struct device *dev)
 {
+	struct pci_dev *pci_dev = to_pci_dev(dev);
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 
 	/*
-	 * If dev->driver is not set (unbound), the device should
-	 * always remain in D0 regardless of the runtime PM status
+	 * If the device has no driver, it should always remain in D0
+	 * regardless of the runtime PM status
 	 */
-	if (!dev->driver)
+	if (!to_pci_driver(dev->driver))
 		return 0;
 
 	if (!pm)
@@ -1448,8 +1432,10 @@ static struct pci_driver pci_compat_driver = {
  */
 struct pci_driver *pci_dev_driver(const struct pci_dev *dev)
 {
-	if (dev->dev.driver)
-		return to_pci_driver(dev->dev.driver);
+	struct pci_driver *drv = to_pci_driver(dev->dev.driver);
+
+	if (drv)
+		return drv;
 	else {
 		int i;
 		for (i = 0; i <= PCI_ROM_RESOURCE; i++)
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index ccecf740de59..5298ce131f8c 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5088,13 +5088,14 @@ EXPORT_SYMBOL_GPL(pci_dev_unlock);
 
 static void pci_dev_save_and_disable(struct pci_dev *dev)
 {
+	struct pci_driver *drv = to_pci_driver(dev->dev.driver);
 	const struct pci_error_handlers *err_handler =
-			dev->dev.driver ? to_pci_driver(dev->dev.driver)->err_handler : NULL;
+			drv ? drv->err_handler : NULL;
 
 	/*
-	 * dev->driver->err_handler->reset_prepare() is protected against
-	 * races with ->remove() by the device lock, which must be held by
-	 * the caller.
+	 * drv->err_handler->reset_prepare() is protected against races
+	 * with ->remove() by the device lock, which must be held by the
+	 * caller.
 	 */
 	if (err_handler && err_handler->reset_prepare)
 		err_handler->reset_prepare(dev);
@@ -5119,15 +5120,15 @@ static void pci_dev_save_and_disable(struct pci_dev *dev)
 
 static void pci_dev_restore(struct pci_dev *dev)
 {
+	struct pci_driver *drv = to_pci_driver(dev->dev.driver);
 	const struct pci_error_handlers *err_handler =
-			dev->dev.driver ? to_pci_driver(dev->dev.driver)->err_handler : NULL;
+			drv ? drv->err_handler : NULL;
 
 	pci_restore_state(dev);
 
 	/*
-	 * dev->driver->err_handler->reset_done() is protected against
-	 * races with ->remove() by the device lock, which must be held by
-	 * the caller.
+	 * drv->err_handler->reset_done() is protected against races with
+	 * ->remove() by the device lock, which must be held by the caller.
 	 */
 	if (err_handler && err_handler->reset_done)
 		err_handler->reset_done(dev);
diff --git a/drivers/pci/pcie/err.c b/drivers/pci/pcie/err.c
index b314b54f7821..42385fe6b7fa 100644
--- a/drivers/pci/pcie/err.c
+++ b/drivers/pci/pcie/err.c
@@ -54,9 +54,10 @@ static int report_error_detected(struct pci_dev *dev,
 	const struct pci_error_handlers *err_handler;
 
 	device_lock(&dev->dev);
+	pdrv = to_pci_driver(dev->dev.driver);
 	if (!pci_dev_set_io_state(dev, state) ||
-		!dev->dev.driver ||
-		!(pdrv = to_pci_driver(dev->dev.driver))->err_handler ||
+		!pdrv ||
+		!pdrv->err_handler ||
 		!pdrv->err_handler->error_detected) {
 		/*
 		 * If any device in the subtree does not have an error_detected
@@ -92,13 +93,14 @@ static int report_normal_detected(struct pci_dev *dev, void *data)
 
 static int report_mmio_enabled(struct pci_dev *dev, void *data)
 {
-	pci_ers_result_t vote, *result = data;
 	struct pci_driver *pdrv;
+	pci_ers_result_t vote, *result = data;
 	const struct pci_error_handlers *err_handler;
 
 	device_lock(&dev->dev);
-	if (!dev->dev.driver ||
-		!(pdrv = to_pci_driver(dev->dev.driver))->err_handler ||
+	pdrv = to_pci_driver(dev->dev.driver);
+	if (!pdrv ||
+		!pdrv->err_handler ||
 		!pdrv->err_handler->mmio_enabled)
 		goto out;
 
@@ -112,13 +114,14 @@ static int report_mmio_enabled(struct pci_dev *dev, void *data)
 
 static int report_slot_reset(struct pci_dev *dev, void *data)
 {
+	struct pci_driver *pdrv;
 	pci_ers_result_t vote, *result = data;
 	const struct pci_error_handlers *err_handler;
-	struct pci_driver *pdrv;
 
 	device_lock(&dev->dev);
-	if (!dev->dev.driver ||
-		!(pdrv = to_pci_driver(dev->dev.driver))->err_handler ||
+	pdrv = to_pci_driver(dev->dev.driver);
+	if (!pdrv ||
+		!pdrv->err_handler ||
 		!pdrv->err_handler->slot_reset)
 		goto out;
 
@@ -132,13 +135,14 @@ static int report_slot_reset(struct pci_dev *dev, void *data)
 
 static int report_resume(struct pci_dev *dev, void *data)
 {
-	const struct pci_error_handlers *err_handler;
 	struct pci_driver *pdrv;
+	const struct pci_error_handlers *err_handler;
 
 	device_lock(&dev->dev);
+	pdrv = dev->driver;
 	if (!pci_dev_set_io_state(dev, pci_channel_io_normal) ||
-		!dev->dev.driver ||
-		!(pdrv = to_pci_driver(dev->dev.driver))->err_handler ||
+		!pdrv ||
+		!pdrv->err_handler ||
 		!pdrv->err_handler->resume)
 		goto out;
 
diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index 73831fb87a1e..0ec76b4af16f 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -588,7 +588,6 @@ static pci_ers_result_t pcifront_common_process(int cmd,
 						struct pcifront_device *pdev,
 						pci_channel_state_t state)
 {
-	pci_ers_result_t result;
 	struct pci_driver *pdrv;
 	int bus = pdev->sh_info->aer_op.bus;
 	int devfn = pdev->sh_info->aer_op.devfn;
@@ -598,13 +597,12 @@ static pci_ers_result_t pcifront_common_process(int cmd,
 	dev_dbg(&pdev->xdev->dev,
 		"pcifront AER process: cmd %x (bus:%x, devfn%x)",
 		cmd, bus, devfn);
-	result = PCI_ERS_RESULT_NONE;
 
 	pcidev = pci_get_domain_bus_and_slot(domain, bus, devfn);
 	if (!pcidev || !pcidev->dev.driver) {
 		dev_err(&pdev->xdev->dev, "device or AER driver is NULL\n");
 		pci_dev_put(pcidev);
-		return result;
+		return PCI_ERS_RESULT_NONE;
 	}
 	pdrv = to_pci_driver(pcidev->dev.driver);
 
@@ -612,27 +610,18 @@ static pci_ers_result_t pcifront_common_process(int cmd,
 		pci_dbg(pcidev, "trying to call AER service\n");
 		switch (cmd) {
 		case XEN_PCI_OP_aer_detected:
-			result = pdrv->err_handler->
-				 error_detected(pcidev, state);
-			break;
+			return pdrv->err_handler->error_detected(pcidev, state);
 		case XEN_PCI_OP_aer_mmio:
-			result = pdrv->err_handler->
-				 mmio_enabled(pcidev);
-			break;
+			return pdrv->err_handler->mmio_enabled(pcidev);
 		case XEN_PCI_OP_aer_slotreset:
-			result = pdrv->err_handler->
-				 slot_reset(pcidev);
-			break;
+			return pdrv->err_handler->slot_reset(pcidev);
 		case XEN_PCI_OP_aer_resume:
 			pdrv->err_handler->resume(pcidev);
-			break;
+			return PCI_ERS_RESULT_NONE;
 		default:
 			dev_err(&pdev->xdev->dev,
-				"bad request in aer recovery "
-				"operation!\n");
+				"bad request in AER recovery operation!\n");
 		}
-
-		return result;
 	}
 
 	return PCI_ERS_RESULT_NONE;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 7c1ceb39035c..03bfdb25a55c 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -899,7 +899,10 @@ struct pci_driver {
 	struct pci_dynids	dynids;
 };
 
-#define	to_pci_driver(drv) container_of(drv, struct pci_driver, driver)
+static inline struct pci_driver *to_pci_driver(struct device_driver *drv)
+{
+    return drv ? container_of(drv, struct pci_driver, driver) : NULL;
+}
 
 /**
  * PCI_DEVICE - macro used to describe a specific PCI device
