Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67F0D193B6E
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 10:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbgCZJCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 05:02:55 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53450 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgCZJCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 05:02:55 -0400
Received: by mail-wm1-f67.google.com with SMTP id b12so5583610wmj.3
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 02:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+0ECwnYSfkluAdOeCKth+5SoxqRZbIi1MX2ConGrTKY=;
        b=CDdL5ixs1oL+fu2Hnt/42oDMpEjz+YbiW/6HHG0ItzEA96/pUKjysVHttiat+8yiBn
         EZsQbDqwlzGh+BFQnFlEHmKGwJASXIngFl4+Z4R0Hz+o8hvnCIqzDL6eR2x1dqiHeU0k
         n2khr9TlwPBMvbjrzSBM7Y6z0w/WoAjfJuTTWusSPtSuMf4hukJ0AkknBkLIgFhm0jo8
         x2tYT5Hf6T1tTSyPtKL9LsgyuxY1iWam+mLpWPfZq1Vneg14VcvKndZLdqmYguzAByVM
         cKjvZSHuhRKTW0vGaVxc6i8G5VX062ker9xD7LlFDoiDjU+nWQqFBJB2wHdp/9t4pxWE
         /9Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+0ECwnYSfkluAdOeCKth+5SoxqRZbIi1MX2ConGrTKY=;
        b=ruyLAPYyD++dg4ltm4YMQ9lM9l69mgluJP2KkMDwMcIZfHVaODdftR/L8nG/x59MqE
         RVLhAQatfi3ej1ScH0dvMgiHQdV8ig+jqV3z/bqKAU+rVpjM+tfixlNFRUNovpxmFwna
         kBW4D1EqifS4Ph2uRF3skG76kRQgT2jioEWffHUgIZSxH6di5O2iK6PfQMFNYraOxdA2
         s9DjZIug6LMxliKudnihYxE8h+7FeZp0konG1MMa8NyrE9HBuAIeQyyt0QqjsJnTL689
         jf00FEWN77L6ygX2Wdqd89f9YVeTb21oMiC65Sp5nbSmuSXTmZ6ROLcowLxe+nDQEJbX
         r2SQ==
X-Gm-Message-State: ANhLgQ1q/xNkX9b54UrPadi4gwoo9MEZtiFBcXHcwJ0ZiJiIOTTvU89y
        h31DM44FxviuG/U6QYSsaqVga2r/oX0=
X-Google-Smtp-Source: ADFU+vvRQ/qMweRl0DaO/+R2bRsk0oHr8HL61c9i024X7IghObTJJdjLl1CS8GS1zIOVO1zILuytuQ==
X-Received: by 2002:a7b:c343:: with SMTP id l3mr2116958wmj.38.1585213372112;
        Thu, 26 Mar 2020 02:02:52 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id s15sm2660787wrt.16.2020.03.26.02.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 02:02:51 -0700 (PDT)
Date:   Thu, 26 Mar 2020 10:02:50 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next v2 11/11] ice: add a devlink region for dumping NVM
 contents
Message-ID: <20200326090250.GQ11304@nanopsycho.orion>
References: <20200326035157.2211090-1-jacob.e.keller@intel.com>
 <20200326035157.2211090-12-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326035157.2211090-12-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 26, 2020 at 04:51:57AM CET, jacob.e.keller@intel.com wrote:
>Add a devlink region for exposing the device's Non Volatime Memory flash
>contents.
>
>Support the recently added .snapshot operation, enabling userspace to
>request a snapshot of the NVM contents via DEVLINK_CMD_REGION_NEW.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>---
> Documentation/networking/devlink/ice.rst     | 26 +++++
> drivers/net/ethernet/intel/ice/ice.h         |  2 +
> drivers/net/ethernet/intel/ice/ice_devlink.c | 99 ++++++++++++++++++++
> drivers/net/ethernet/intel/ice/ice_devlink.h |  3 +
> drivers/net/ethernet/intel/ice/ice_main.c    |  4 +
> 5 files changed, 134 insertions(+)
>
>diff --git a/Documentation/networking/devlink/ice.rst b/Documentation/networking/devlink/ice.rst
>index 37fbbd40a5e5..f3d6a3b50342 100644
>--- a/Documentation/networking/devlink/ice.rst
>+++ b/Documentation/networking/devlink/ice.rst
>@@ -69,3 +69,29 @@ The ``ice`` driver reports the following versions
>       - The version of the DDP package that is active in the device. Note
>         that both the name (as reported by ``fw.app.name``) and version are
>         required to uniquely identify the package.
>+
>+Regions
>+=======
>+
>+The ``ice`` driver enables access to the contents of the Non Volatile Memory
>+flash chip via the ``nvm-flash`` region.
>+
>+Users can request an immediate capture of a snapshot via the
>+``DEVLINK_CMD_REGION_NEW``
>+
>+.. code:: shell
>+
>+    $ devlink region new pci/0000:01:00.0/nvm-flash snapshot 1
>+    $ devlink region dump pci/0000:01:00.0/nvm-flash snapshot 1
>+
>+    $ devlink region dump pci/0000:01:00.0/nvm-flash snapshot 1
>+    0000000000000000 0014 95dc 0014 9514 0035 1670 0034 db30
>+    0000000000000010 0000 0000 ffff ff04 0029 8c00 0028 8cc8
>+    0000000000000020 0016 0bb8 0016 1720 0000 0000 c00f 3ffc
>+    0000000000000030 bada cce5 bada cce5 bada cce5 bada cce5
>+
>+    $ devlink region read pci/0000:01:00.0/nvm-flash snapshot 1 address 0
>+        length 16

Don't wrap the cmdline.


>+    0000000000000000 0014 95dc 0014 9514 0035 1670 0034 db30
>+
>+    $ devlink region delete pci/0000:01:00.0/nvm-flash snapshot 1
>diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
>index 8ce3afcfeca0..5c11448bfbb3 100644
>--- a/drivers/net/ethernet/intel/ice/ice.h
>+++ b/drivers/net/ethernet/intel/ice/ice.h
>@@ -351,6 +351,8 @@ struct ice_pf {
> 	/* devlink port data */
> 	struct devlink_port devlink_port;
> 
>+	struct devlink_region *nvm_region;
>+
> 	/* OS reserved IRQ details */
> 	struct msix_entry *msix_entries;
> 	struct ice_res_tracker *irq_tracker;
>diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
>index 27c5034c039a..91edeffd73b1 100644
>--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
>+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
>@@ -318,3 +318,102 @@ void ice_devlink_destroy_port(struct ice_pf *pf)
> 	devlink_port_type_clear(&pf->devlink_port);
> 	devlink_port_unregister(&pf->devlink_port);
> }
>+
>+/**
>+ * ice_devlink_nvm_snapshot - Capture a snapshot of the Shadow RAM contents
>+ * @devlink: the devlink instance
>+ * @extack: extended ACK response structure
>+ * @data: on exit points to snapshot data buffer
>+ *
>+ * This function is called in response to the DEVLINK_CMD_REGION_TRIGGER for
>+ * the shadow-ram devlink region. It captures a snapshot of the shadow ram
>+ * contents. This snapshot can later be viewed via the devlink-region
>+ * interface.
>+ *
>+ * @returns zero on success, and updates the data pointer. Returns a non-zero
>+ * error code on failure.
>+ */
>+static int
>+ice_devlink_nvm_snapshot(struct devlink *devlink, struct netlink_ext_ack *extack,
>+			u8 **data)
>+{
>+	struct ice_pf *pf = devlink_priv(devlink);
>+	struct device *dev = ice_pf_to_dev(pf);
>+	struct ice_hw *hw = &pf->hw;
>+	enum ice_status status;
>+	void *nvm_data;
>+	u32 nvm_size;
>+
>+	nvm_size = hw->nvm.flash_size;
>+	nvm_data = vzalloc(nvm_size);
>+	if (!nvm_data) {
>+		NL_SET_ERR_MSG_MOD(extack, "Out of memory");

Pointless extack message. It is obvious from -ENOMEM. Please remove.


>+		return -ENOMEM;
>+	}
>+
>+	status = ice_acquire_nvm(hw, ICE_RES_READ);
>+	if (status) {
>+		dev_dbg(dev, "ice_acquire_nvm failed, err %d aq_err %d\n",
>+			status, hw->adminq.sq_last_status);
>+		NL_SET_ERR_MSG_MOD(extack, "Failed to acquire NVM semaphore");
>+		vfree(nvm_data);
>+		return -EIO;
>+	}
>+
>+	status = ice_read_flat_nvm(hw, 0, &nvm_size, nvm_data, false);
>+	if (status) {
>+		dev_dbg(dev, "ice_read_flat_nvm failed after reading %u bytes, err %d aq_err %d\n",
>+			nvm_size, status, hw->adminq.sq_last_status);
>+		NL_SET_ERR_MSG_MOD(extack, "Failed to read NVM contents");
>+		ice_release_nvm(hw);
>+		vfree(nvm_data);
>+		return -EIO;
>+	}
>+
>+	ice_release_nvm(hw);
>+
>+	*data = nvm_data;
>+
>+	return 0;
>+}
>+
>+static const struct devlink_region_ops ice_nvm_region_ops = {
>+	.name = "nvm-flash",
>+	.destructor = vfree,
>+	.snapshot = ice_devlink_nvm_snapshot,
>+};
>+
>+/**
>+ * ice_devlink_init_regions - Initialize devlink regions
>+ * @pf: the PF device structure
>+ *
>+ * Create devlink regions used to enable access to dump the contents of the
>+ * flash memory on the device.
>+ */
>+void ice_devlink_init_regions(struct ice_pf *pf)
>+{
>+	struct devlink *devlink = priv_to_devlink(pf);
>+	struct device *dev = ice_pf_to_dev(pf);
>+	u64 nvm_size;
>+
>+	nvm_size = pf->hw.nvm.flash_size;
>+	pf->nvm_region = devlink_region_create(devlink, &ice_nvm_region_ops, 1,
>+					       nvm_size);
>+	if (IS_ERR(pf->nvm_region)) {
>+		dev_err(dev, "failed to create NVM devlink region, err %ld\n",
>+			PTR_ERR(pf->nvm_region));
>+		pf->nvm_region = NULL;
>+	}
>+}
>+
>+/**
>+ * ice_devlink_destroy_regions - Destroy devlink regions
>+ * @pf: the PF device structure
>+ *
>+ * Remove previously created regions for this PF.
>+ */
>+void ice_devlink_destroy_regions(struct ice_pf *pf)
>+{
>+	if (pf->nvm_region)
>+		devlink_region_destroy(pf->nvm_region);
>+}
>diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.h b/drivers/net/ethernet/intel/ice/ice_devlink.h
>index f94dc93c24c5..6e806a08dc23 100644
>--- a/drivers/net/ethernet/intel/ice/ice_devlink.h
>+++ b/drivers/net/ethernet/intel/ice/ice_devlink.h
>@@ -11,4 +11,7 @@ void ice_devlink_unregister(struct ice_pf *pf);
> int ice_devlink_create_port(struct ice_pf *pf);
> void ice_devlink_destroy_port(struct ice_pf *pf);
> 
>+void ice_devlink_init_regions(struct ice_pf *pf);
>+void ice_devlink_destroy_regions(struct ice_pf *pf);
>+
> #endif /* _ICE_DEVLINK_H_ */
>diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
>index 359ff8544773..306a4e5b2320 100644
>--- a/drivers/net/ethernet/intel/ice/ice_main.c
>+++ b/drivers/net/ethernet/intel/ice/ice_main.c
>@@ -3276,6 +3276,8 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
> 		goto err_init_pf_unroll;
> 	}
> 
>+	ice_devlink_init_regions(pf);
>+
> 	pf->num_alloc_vsi = hw->func_caps.guar_num_vsi;
> 	if (!pf->num_alloc_vsi) {
> 		err = -EIO;
>@@ -3385,6 +3387,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
> 	devm_kfree(dev, pf->vsi);
> err_init_pf_unroll:
> 	ice_deinit_pf(pf);
>+	ice_devlink_destroy_regions(pf);
> 	ice_deinit_hw(hw);
> err_exit_unroll:
> 	ice_devlink_unregister(pf);
>@@ -3427,6 +3430,7 @@ static void ice_remove(struct pci_dev *pdev)
> 		ice_vsi_free_q_vectors(pf->vsi[i]);
> 	}
> 	ice_deinit_pf(pf);
>+	ice_devlink_destroy_regions(pf);
> 	ice_deinit_hw(&pf->hw);
> 	ice_devlink_unregister(pf);
> 
>-- 
>2.24.1
>
