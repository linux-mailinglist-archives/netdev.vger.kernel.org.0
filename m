Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59E492C062
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 09:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbfE1HkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 03:40:05 -0400
Received: from mail-eopbgr730071.outbound.protection.outlook.com ([40.107.73.71]:19600
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727261AbfE1HkC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 03:40:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector1-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CMwDib1zt16hSop0RjrQtEOs8yIhHicg+pE2HvbAiwY=;
 b=Rew+sVWJrVP6Z4w+l8U32T9oXU8tcvk+FzUFG4GVar2nA2/1Qzi2JWpPxQHOtUTvSfsFpKENG8nY3Nr+ygIlGEmrx2hsg4DmtvvI9hJxebVQjwylEdSyKYytY7YCgU97wA7lk3AEy/HCLI5ZlvlwWw3a5FZUolhEOjgiYLRUa8o=
Received: from CY4PR03CA0021.namprd03.prod.outlook.com (2603:10b6:903:33::31)
 by BLUPR03MB550.namprd03.prod.outlook.com (2a01:111:e400:880::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1922.23; Tue, 28 May
 2019 07:39:52 +0000
Received: from BL2NAM02FT041.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::207) by CY4PR03CA0021.outlook.office365.com
 (2603:10b6:903:33::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1943.16 via Frontend
 Transport; Tue, 28 May 2019 07:39:52 +0000
Authentication-Results: spf=pass (sender IP is 137.71.25.55)
 smtp.mailfrom=analog.com; lists.freedesktop.org; dkim=none (message not
 signed) header.d=none;lists.freedesktop.org; dmarc=bestguesspass action=none
 header.from=analog.com;
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 BL2NAM02FT041.mail.protection.outlook.com (10.152.77.122) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1922.16
 via Frontend Transport; Tue, 28 May 2019 07:39:51 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x4S7dpcI023260
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Tue, 28 May 2019 00:39:51 -0700
Received: from saturn.analog.com (10.50.1.244) by NWD2HUBCAS7.ad.analog.com
 (10.64.69.107) with Microsoft SMTP Server id 14.3.408.0; Tue, 28 May 2019
 03:39:51 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-ide@vger.kernel.org>, <linux-clk@vger.kernel.org>,
        <linux-rpi-kernel@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-rockchip@lists.infradead.org>, <linux-pm@vger.kernel.org>,
        <linux-gpio@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-omap@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <linux-usb@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-integrity@vger.kernel.org>, <alsa-devel@alsa-project.org>
CC:     <heikki.krogerus@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <andriy.shevchenko@linux.intel.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 2/3][V2] treewide: rename match_string() -> __match_string()
Date:   Tue, 28 May 2019 10:39:31 +0300
Message-ID: <20190528073932.25365-2-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190528073932.25365-1-alexandru.ardelean@analog.com>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
 <20190528073932.25365-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(979002)(1496009)(346002)(376002)(39860400002)(136003)(396003)(2980300002)(189003)(199004)(53946003)(246002)(110136005)(7636002)(36756003)(2201001)(316002)(8676002)(1076003)(54906003)(7696005)(8936002)(6666004)(70586007)(86362001)(305945005)(53416004)(478600001)(7406005)(356004)(50226002)(30864003)(106002)(7416002)(14444005)(11346002)(2441003)(107886003)(486006)(126002)(476003)(2616005)(26005)(5660300002)(76176011)(77096007)(186003)(336012)(48376002)(70206006)(2870700001)(44832011)(446003)(47776003)(426003)(4326008)(51416003)(50466002)(2906002)(921003)(2101003)(1121003)(83996005)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB550;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39c6fb28-465a-43f8-37fa-08d6e33fab79
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709054)(1401327)(2017052603328);SRVR:BLUPR03MB550;
X-MS-TrafficTypeDiagnostic: BLUPR03MB550:
X-Microsoft-Antispam-PRVS: <BLUPR03MB55037B92BC179E94F1F346BF91E0@BLUPR03MB550.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-Forefront-PRVS: 00514A2FE6
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 9ybW7rD6NoF85T5flM+e/4uhgz+IghyLornEXcx0rjnX960WqP1oVtTk+jDsa2GBaiJIghVRCEtRZxnwUcf7zab5dFNVH9xJf3n7vkrK4fcs5ifgccVdWihtGzQakUf12K6x0c0Vy3PFItt0DSbJGRm7+nwN4mcCRvebhWLlAMQTvVvHbVMuiqrywPpCjI1aJM7eUOwG29/4DzmSsxF5ce96xK3ure2FhbjWO+k1wEgjDEz/lZA5kj5a8ALdx3WVFz1CE30MLgyvBLOmO+So7+p031IkzRlPcvHDXXwmNldHQEtpxJHjGbRhZCZw5isG0ZWF2SDBVbEg2y1jE5rier4GsMAiVo0DlsR6KSCcA5z86gYOOWzVO73bemk9DEZdiqDfePAkoDQmeJ2Qy4JMhEQjTCXsx14V606jcWDSPUM=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2019 07:39:51.7648
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39c6fb28-465a-43f8-37fa-08d6e33fab79
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLUPR03MB550
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change does a rename of match_string() -> __match_string().

There are a few parts to the intention here (with this change):
1. Align with sysfs_match_string()/__sysfs_match_string()
2. This helps to group users of `match_string()`:
   a. those that use ARRAY_SIZE(_a) to specify the number of elements
   b. those that use -1 to pass a NULL terminated array of strings
   c. special users, which (after eliminating 1 & 2) are not that many

This change is done treewide. Updates to the new match_string() helper will
be done on a per-subsystem basis, as the cadence of each subsystem differs.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 arch/powerpc/xmon/xmon.c                         |  2 +-
 arch/x86/kernel/cpu/mtrr/if.c                    |  2 +-
 drivers/ata/pata_hpt366.c                        |  2 +-
 drivers/ata/pata_hpt37x.c                        |  2 +-
 drivers/base/devcon.c                            |  2 +-
 drivers/base/property.c                          |  2 +-
 drivers/clk/bcm/clk-bcm2835.c                    |  6 +++---
 drivers/clk/rockchip/clk.c                       |  4 ++--
 drivers/cpufreq/intel_pstate.c                   |  2 +-
 drivers/gpio/gpiolib-of.c                        |  2 +-
 drivers/gpu/drm/drm_edid_load.c                  |  2 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c   |  2 +-
 drivers/gpu/drm/i915/intel_pipe_crc.c            |  2 +-
 drivers/ide/hpt366.c                             |  2 +-
 drivers/mfd/omap-usb-host.c                      |  2 +-
 drivers/mmc/host/sdhci-xenon-phy.c               |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c |  2 +-
 drivers/pci/pcie/aer.c                           |  2 +-
 drivers/phy/tegra/xusb.c                         |  4 ++--
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c      |  4 ++--
 drivers/pinctrl/pinmux.c                         |  2 +-
 drivers/power/supply/ab8500_btemp.c              |  2 +-
 drivers/power/supply/ab8500_charger.c            |  2 +-
 drivers/power/supply/ab8500_fg.c                 |  2 +-
 drivers/power/supply/abx500_chargalg.c           |  2 +-
 drivers/power/supply/charger-manager.c           |  4 ++--
 drivers/staging/gdm724x/gdm_tty.c                |  4 ++--
 drivers/usb/common/common.c                      |  4 ++--
 drivers/usb/typec/class.c                        | 10 +++++-----
 drivers/usb/typec/tps6598x.c                     |  2 +-
 drivers/vfio/vfio.c                              |  6 +++---
 drivers/video/fbdev/pxafb.c                      |  2 +-
 fs/ubifs/auth.c                                  |  4 ++--
 include/linux/string.h                           |  2 +-
 kernel/cgroup/rdma.c                             |  2 +-
 kernel/sched/debug.c                             |  2 +-
 kernel/trace/trace.c                             |  2 +-
 lib/string.c                                     |  8 ++++----
 mm/mempolicy.c                                   |  2 +-
 mm/vmpressure.c                                  |  4 ++--
 security/apparmor/lsm.c                          |  4 ++--
 security/integrity/ima/ima_main.c                |  2 +-
 sound/firewire/oxfw/oxfw.c                       |  2 +-
 sound/pci/oxygen/oxygen_mixer.c                  |  2 +-
 sound/soc/codecs/max98088.c                      |  2 +-
 sound/soc/codecs/max98095.c                      |  2 +-
 sound/soc/soc-dapm.c                             |  2 +-
 47 files changed, 67 insertions(+), 67 deletions(-)

diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index 1b0149b2bb6c..8039759a9e82 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -3264,7 +3264,7 @@ scanhex(unsigned long *vp)
 			regname[i] = c;
 		}
 		regname[i] = 0;
-		i = match_string(regnames, N_PTREGS, regname);
+		i = __match_string(regnames, N_PTREGS, regname);
 		if (i < 0) {
 			printf("invalid register name '%%%s'\n", regname);
 			return 0;
diff --git a/arch/x86/kernel/cpu/mtrr/if.c b/arch/x86/kernel/cpu/mtrr/if.c
index 4d36dcc1cf87..4ec7a5f7b94c 100644
--- a/arch/x86/kernel/cpu/mtrr/if.c
+++ b/arch/x86/kernel/cpu/mtrr/if.c
@@ -142,7 +142,7 @@ mtrr_write(struct file *file, const char __user *buf, size_t len, loff_t * ppos)
 		return -EINVAL;
 	ptr = skip_spaces(ptr + 5);
 
-	i = match_string(mtrr_strings, MTRR_NUM_TYPES, ptr);
+	i = __match_string(mtrr_strings, MTRR_NUM_TYPES, ptr);
 	if (i < 0)
 		return i;
 
diff --git a/drivers/ata/pata_hpt366.c b/drivers/ata/pata_hpt366.c
index 2574d6fbb1ad..a23ec26cc95f 100644
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -181,7 +181,7 @@ static int hpt_dma_blacklisted(const struct ata_device *dev, char *modestr,
 
 	ata_id_c_string(dev->id, model_num, ATA_ID_PROD, sizeof(model_num));
 
-	i = match_string(list, -1, model_num);
+	i = __match_string(list, -1, model_num);
 	if (i >= 0) {
 		pr_warn("%s is not supported for %s\n", modestr, list[i]);
 		return 1;
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index fad6c6a87313..ac0499e4ae4b 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -229,7 +229,7 @@ static int hpt_dma_blacklisted(const struct ata_device *dev, char *modestr,
 
 	ata_id_c_string(dev->id, model_num, ATA_ID_PROD, sizeof(model_num));
 
-	i = match_string(list, -1, model_num);
+	i = __match_string(list, -1, model_num);
 	if (i >= 0) {
 		pr_warn("%s is not supported for %s\n", modestr, list[i]);
 		return 1;
diff --git a/drivers/base/devcon.c b/drivers/base/devcon.c
index 04db9ae235e4..7bc1c619b721 100644
--- a/drivers/base/devcon.c
+++ b/drivers/base/devcon.c
@@ -70,7 +70,7 @@ void *device_connection_find_match(struct device *dev, const char *con_id,
 	mutex_lock(&devcon_lock);
 
 	list_for_each_entry(con, &devcon_list, list) {
-		ep = match_string(con->endpoint, 2, devname);
+		ep = __match_string(con->endpoint, 2, devname);
 		if (ep < 0)
 			continue;
 
diff --git a/drivers/base/property.c b/drivers/base/property.c
index 348b37e64944..67195d6bfdca 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -443,7 +443,7 @@ int fwnode_property_match_string(const struct fwnode_handle *fwnode,
 	if (ret < 0)
 		goto out;
 
-	ret = match_string(values, nval, string);
+	ret = __match_string(values, nval, string);
 	if (ret < 0)
 		ret = -ENODATA;
 out:
diff --git a/drivers/clk/bcm/clk-bcm2835.c b/drivers/clk/bcm/clk-bcm2835.c
index 770bb01f523e..91bb94d68798 100644
--- a/drivers/clk/bcm/clk-bcm2835.c
+++ b/drivers/clk/bcm/clk-bcm2835.c
@@ -1391,9 +1391,9 @@ static struct clk_hw *bcm2835_register_clock(struct bcm2835_cprman *cprman,
 	for (i = 0; i < data->num_mux_parents; i++) {
 		parents[i] = data->parents[i];
 
-		ret = match_string(cprman_parent_names,
-				   ARRAY_SIZE(cprman_parent_names),
-				   parents[i]);
+		ret = __match_string(cprman_parent_names,
+				     ARRAY_SIZE(cprman_parent_names),
+				     parents[i]);
 		if (ret >= 0)
 			parents[i] = cprman->real_parent_names[ret];
 	}
diff --git a/drivers/clk/rockchip/clk.c b/drivers/clk/rockchip/clk.c
index d5fac5a8a3d7..2163bb54a663 100644
--- a/drivers/clk/rockchip/clk.c
+++ b/drivers/clk/rockchip/clk.c
@@ -280,8 +280,8 @@ static struct clk *rockchip_clk_register_frac_branch(
 		struct clk *mux_clk;
 		int ret;
 
-		frac->mux_frac_idx = match_string(child->parent_names,
-						  child->num_parents, name);
+		frac->mux_frac_idx = __match_string(child->parent_names,
+						    child->num_parents, name);
 		frac->mux_ops = &clk_mux_ops;
 		frac->clk_nb.notifier_call = rockchip_clk_frac_notifier_cb;
 
diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 34b54df41aaa..a1f79451308c 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -703,7 +703,7 @@ static ssize_t store_energy_performance_preference(
 	if (ret != 1)
 		return -EINVAL;
 
-	ret = match_string(energy_perf_strings, -1, str_preference);
+	ret = __match_string(energy_perf_strings, -1, str_preference);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index aec7bd86ae7e..527be82e1bac 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -278,7 +278,7 @@ static struct gpio_desc *of_find_regulator_gpio(struct device *dev, const char *
 	if (!con_id)
 		return ERR_PTR(-ENOENT);
 
-	i = match_string(whitelist, ARRAY_SIZE(whitelist), con_id);
+	i = __match_string(whitelist, ARRAY_SIZE(whitelist), con_id);
 	if (i < 0)
 		return ERR_PTR(-ENOENT);
 
diff --git a/drivers/gpu/drm/drm_edid_load.c b/drivers/gpu/drm/drm_edid_load.c
index 1e5593575d23..53c55fc8b8c2 100644
--- a/drivers/gpu/drm/drm_edid_load.c
+++ b/drivers/gpu/drm/drm_edid_load.c
@@ -174,7 +174,7 @@ static void *edid_load(struct drm_connector *connector, const char *name,
 	int i, valid_extensions = 0;
 	bool print_bad_edid = !connector->bad_edid_counter || (drm_debug & DRM_UT_KMS);
 
-	builtin = match_string(generic_edid_name, GENERIC_EDIDS, name);
+	builtin = __match_string(generic_edid_name, GENERIC_EDIDS, name);
 	if (builtin >= 0) {
 		fwdata = generic_edid[builtin];
 		fwsize = sizeof(generic_edid[builtin]);
diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 521aff99b08a..063553adb22d 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -213,7 +213,7 @@ int drm_get_panel_orientation_quirk(int width, int height)
 		if (!bios_date)
 			continue;
 
-		i = match_string(data->bios_dates, -1, bios_date);
+		i = __match_string(data->bios_dates, -1, bios_date);
 		if (i >= 0)
 			return data->orientation;
 	}
diff --git a/drivers/gpu/drm/i915/intel_pipe_crc.c b/drivers/gpu/drm/i915/intel_pipe_crc.c
index e7c7be4911c1..3e6af7600c25 100644
--- a/drivers/gpu/drm/i915/intel_pipe_crc.c
+++ b/drivers/gpu/drm/i915/intel_pipe_crc.c
@@ -440,7 +440,7 @@ display_crc_ctl_parse_source(const char *buf, enum intel_pipe_crc_source *s)
 		return 0;
 	}
 
-	i = match_string(pipe_crc_sources, ARRAY_SIZE(pipe_crc_sources), buf);
+	i = __match_string(pipe_crc_sources, ARRAY_SIZE(pipe_crc_sources), buf);
 	if (i < 0)
 		return i;
 
diff --git a/drivers/ide/hpt366.c b/drivers/ide/hpt366.c
index fd3b5da44619..5e880a1ebcde 100644
--- a/drivers/ide/hpt366.c
+++ b/drivers/ide/hpt366.c
@@ -534,7 +534,7 @@ static const struct hpt_info hpt371n = {
 
 static bool check_in_drive_list(ide_drive_t *drive, const char **list)
 {
-	return match_string(list, -1, (char *)&drive->id[ATA_ID_PROD]) >= 0;
+	return __match_string(list, -1, (char *)&drive->id[ATA_ID_PROD]) >= 0;
 }
 
 static struct hpt_info *hpt3xx_get_info(struct device *dev)
diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 800986a79704..9aaacb5bdb26 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -509,7 +509,7 @@ static int usbhs_omap_get_dt_pdata(struct device *dev,
 			continue;
 
 		/* get 'enum usbhs_omap_port_mode' from port mode string */
-		ret = match_string(port_modes, ARRAY_SIZE(port_modes), mode);
+		ret = __match_string(port_modes, ARRAY_SIZE(port_modes), mode);
 		if (ret < 0) {
 			dev_warn(dev, "Invalid port%d-mode \"%s\" in device tree\n",
 					i, mode);
diff --git a/drivers/mmc/host/sdhci-xenon-phy.c b/drivers/mmc/host/sdhci-xenon-phy.c
index 8d07ee1b8f08..59b7a6cac995 100644
--- a/drivers/mmc/host/sdhci-xenon-phy.c
+++ b/drivers/mmc/host/sdhci-xenon-phy.c
@@ -821,7 +821,7 @@ static int xenon_add_phy(struct device_node *np, struct sdhci_host *host,
 	struct xenon_priv *priv = sdhci_pltfm_priv(pltfm_host);
 	int ret;
 
-	priv->phy_type = match_string(phy_types, NR_PHY_TYPES, phy_name);
+	priv->phy_type = __match_string(phy_types, NR_PHY_TYPES, phy_name);
 	if (priv->phy_type < 0) {
 		dev_err(mmc_dev(host->mmc),
 			"Unable to determine PHY name %s. Use default eMMC 5.1 PHY\n",
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index d4ff6b44de2c..969f09a56ba7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -667,7 +667,7 @@ iwl_dbgfs_bt_force_ant_write(struct iwl_mvm *mvm, char *buf,
 	};
 	int ret, bt_force_ant_mode;
 
-	ret = match_string(modes_str, ARRAY_SIZE(modes_str), buf);
+	ret = __match_string(modes_str, ARRAY_SIZE(modes_str), buf);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index b45bc47d04fe..02f54802fca0 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -206,7 +206,7 @@ void pcie_ecrc_get_policy(char *str)
 {
 	int i;
 
-	i = match_string(ecrc_policy_str, ARRAY_SIZE(ecrc_policy_str), str);
+	i = __match_string(ecrc_policy_str, ARRAY_SIZE(ecrc_policy_str), str);
 	if (i < 0)
 		return;
 
diff --git a/drivers/phy/tegra/xusb.c b/drivers/phy/tegra/xusb.c
index 0417213ed68b..060ba6a0a031 100644
--- a/drivers/phy/tegra/xusb.c
+++ b/drivers/phy/tegra/xusb.c
@@ -119,7 +119,7 @@ int tegra_xusb_lane_parse_dt(struct tegra_xusb_lane *lane,
 	if (err < 0)
 		return err;
 
-	err = match_string(lane->soc->funcs, lane->soc->num_funcs, function);
+	err = __match_string(lane->soc->funcs, lane->soc->num_funcs, function);
 	if (err < 0) {
 		dev_err(dev, "invalid function \"%s\" for lane \"%pOFn\"\n",
 			function, np);
@@ -568,7 +568,7 @@ static int tegra_xusb_usb2_port_parse_dt(struct tegra_xusb_usb2_port *usb2)
 	usb2->internal = of_property_read_bool(np, "nvidia,internal");
 
 	if (!of_property_read_string(np, "mode", &mode)) {
-		int err = match_string(modes, ARRAY_SIZE(modes), mode);
+		int err = __match_string(modes, ARRAY_SIZE(modes), mode);
 		if (err < 0) {
 			dev_err(&port->dev, "invalid value %s for \"mode\"\n",
 				mode);
diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
index 6462d3ca7ceb..07a5bcaa0067 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -348,7 +348,7 @@ static int armada_37xx_pmx_set_by_name(struct pinctrl_dev *pctldev,
 	dev_dbg(info->dev, "enable function %s group %s\n",
 		name, grp->name);
 
-	func = match_string(grp->funcs, NB_FUNCS, name);
+	func = __match_string(grp->funcs, NB_FUNCS, name);
 	if (func < 0)
 		return -ENOTSUPP;
 
@@ -938,7 +938,7 @@ static int armada_37xx_fill_func(struct armada_37xx_pinctrl *info)
 			struct armada_37xx_pin_group *gp = &info->groups[g];
 			int f;
 
-			f = match_string(gp->funcs, NB_FUNCS, name);
+			f = __match_string(gp->funcs, NB_FUNCS, name);
 			if (f < 0)
 				continue;
 
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 4d0cc1889dd9..041326d0ab7b 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -348,7 +348,7 @@ int pinmux_map_to_setting(const struct pinctrl_map *map,
 	}
 	if (map->data.mux.group) {
 		group = map->data.mux.group;
-		ret = match_string(groups, num_groups, group);
+		ret = __match_string(groups, num_groups, group);
 		if (ret < 0) {
 			dev_err(pctldev->dev,
 				"invalid group \"%s\" for function \"%s\"\n",
diff --git a/drivers/power/supply/ab8500_btemp.c b/drivers/power/supply/ab8500_btemp.c
index 708fd58cd62b..1cf3b43a41e4 100644
--- a/drivers/power/supply/ab8500_btemp.c
+++ b/drivers/power/supply/ab8500_btemp.c
@@ -858,7 +858,7 @@ static int ab8500_btemp_get_ext_psy_data(struct device *dev, void *data)
 	 * For all psy where the name of your driver
 	 * appears in any supplied_to
 	 */
-	j = match_string(supplicants, ext->num_supplicants, psy->desc->name);
+	j = __match_string(supplicants, ext->num_supplicants, psy->desc->name);
 	if (j < 0)
 		return 0;
 
diff --git a/drivers/power/supply/ab8500_charger.c b/drivers/power/supply/ab8500_charger.c
index 98b335042ba6..8094f38e4085 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -1876,7 +1876,7 @@ static int ab8500_charger_get_ext_psy_data(struct device *dev, void *data)
 	di = to_ab8500_charger_usb_device_info(usb_chg);
 
 	/* For all psy where the driver name appears in any supplied_to */
-	j = match_string(supplicants, ext->num_supplicants, psy->desc->name);
+	j = __match_string(supplicants, ext->num_supplicants, psy->desc->name);
 	if (j < 0)
 		return 0;
 
diff --git a/drivers/power/supply/ab8500_fg.c b/drivers/power/supply/ab8500_fg.c
index 776102c31305..408339c5a4a8 100644
--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -2174,7 +2174,7 @@ static int ab8500_fg_get_ext_psy_data(struct device *dev, void *data)
 	 * For all psy where the name of your driver
 	 * appears in any supplied_to
 	 */
-	j = match_string(supplicants, ext->num_supplicants, psy->desc->name);
+	j = __match_string(supplicants, ext->num_supplicants, psy->desc->name);
 	if (j < 0)
 		return 0;
 
diff --git a/drivers/power/supply/abx500_chargalg.c b/drivers/power/supply/abx500_chargalg.c
index 947709cdd14e..b2fcd0ba379d 100644
--- a/drivers/power/supply/abx500_chargalg.c
+++ b/drivers/power/supply/abx500_chargalg.c
@@ -946,7 +946,7 @@ static int abx500_chargalg_get_ext_psy_data(struct device *dev, void *data)
 	psy = (struct power_supply *)data;
 	di = power_supply_get_drvdata(psy);
 	/* For all psy where the driver name appears in any supplied_to */
-	j = match_string(supplicants, ext->num_supplicants, psy->desc->name);
+	j = __match_string(supplicants, ext->num_supplicants, psy->desc->name);
 	if (j < 0)
 		return 0;
 
diff --git a/drivers/power/supply/charger-manager.c b/drivers/power/supply/charger-manager.c
index a6900aa0d2ed..70e758e4f4f4 100644
--- a/drivers/power/supply/charger-manager.c
+++ b/drivers/power/supply/charger-manager.c
@@ -2022,8 +2022,8 @@ void cm_notify_event(struct power_supply *psy, enum cm_event_types type,
 
 	mutex_lock(&cm_list_mtx);
 	list_for_each_entry(cm, &cm_list, entry) {
-		if (match_string(cm->desc->psy_charger_stat, -1,
-				 psy->desc->name) >= 0) {
+		if (__match_string(cm->desc->psy_charger_stat, -1,
+				   psy->desc->name) >= 0) {
 			found_power_supply = true;
 			break;
 		}
diff --git a/drivers/staging/gdm724x/gdm_tty.c b/drivers/staging/gdm724x/gdm_tty.c
index 6e813693a766..6e147a324652 100644
--- a/drivers/staging/gdm724x/gdm_tty.c
+++ b/drivers/staging/gdm724x/gdm_tty.c
@@ -56,8 +56,8 @@ static int gdm_tty_install(struct tty_driver *driver, struct tty_struct *tty)
 	struct gdm *gdm = NULL;
 	int ret;
 
-	ret = match_string(DRIVER_STRING, TTY_MAX_COUNT,
-			   tty->driver->driver_name);
+	ret = __match_string(DRIVER_STRING, TTY_MAX_COUNT,
+			     tty->driver->driver_name);
 	if (ret < 0)
 		return -ENODEV;
 
diff --git a/drivers/usb/common/common.c b/drivers/usb/common/common.c
index 18f5dcf58b0d..97f87d758e8a 100644
--- a/drivers/usb/common/common.c
+++ b/drivers/usb/common/common.c
@@ -84,7 +84,7 @@ enum usb_device_speed usb_get_maximum_speed(struct device *dev)
 	if (ret < 0)
 		return USB_SPEED_UNKNOWN;
 
-	ret = match_string(speed_names, ARRAY_SIZE(speed_names), maximum_speed);
+	ret = __match_string(speed_names, ARRAY_SIZE(speed_names), maximum_speed);
 
 	return (ret < 0) ? USB_SPEED_UNKNOWN : ret;
 }
@@ -122,7 +122,7 @@ static enum usb_dr_mode usb_get_dr_mode_from_string(const char *str)
 {
 	int ret;
 
-	ret = match_string(usb_dr_modes, ARRAY_SIZE(usb_dr_modes), str);
+	ret = __match_string(usb_dr_modes, ARRAY_SIZE(usb_dr_modes), str);
 	return (ret < 0) ? USB_DR_MODE_UNKNOWN : ret;
 }
 
diff --git a/drivers/usb/typec/class.c b/drivers/usb/typec/class.c
index 2eb623841847..4abc5a76ec51 100644
--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -1409,8 +1409,8 @@ EXPORT_SYMBOL_GPL(typec_set_pwr_opmode);
  */
 int typec_find_port_power_role(const char *name)
 {
-	return match_string(typec_port_power_roles,
-			    ARRAY_SIZE(typec_port_power_roles), name);
+	return __match_string(typec_port_power_roles,
+			      ARRAY_SIZE(typec_port_power_roles), name);
 }
 EXPORT_SYMBOL_GPL(typec_find_port_power_role);
 
@@ -1424,7 +1424,7 @@ EXPORT_SYMBOL_GPL(typec_find_port_power_role);
  */
 int typec_find_power_role(const char *name)
 {
-	return match_string(typec_roles, ARRAY_SIZE(typec_roles), name);
+	return __match_string(typec_roles, ARRAY_SIZE(typec_roles), name);
 }
 EXPORT_SYMBOL_GPL(typec_find_power_role);
 
@@ -1438,8 +1438,8 @@ EXPORT_SYMBOL_GPL(typec_find_power_role);
  */
 int typec_find_port_data_role(const char *name)
 {
-	return match_string(typec_port_data_roles,
-			    ARRAY_SIZE(typec_port_data_roles), name);
+	return __match_string(typec_port_data_roles,
+			      ARRAY_SIZE(typec_port_data_roles), name);
 }
 EXPORT_SYMBOL_GPL(typec_find_port_data_role);
 
diff --git a/drivers/usb/typec/tps6598x.c b/drivers/usb/typec/tps6598x.c
index c674abe3cf99..0389e4391faf 100644
--- a/drivers/usb/typec/tps6598x.c
+++ b/drivers/usb/typec/tps6598x.c
@@ -423,7 +423,7 @@ static int tps6598x_check_mode(struct tps6598x *tps)
 	if (ret)
 		return ret;
 
-	switch (match_string(modes, ARRAY_SIZE(modes), mode)) {
+	switch (__match_string(modes, ARRAY_SIZE(modes), mode)) {
 	case TPS_MODE_APP:
 		return 0;
 	case TPS_MODE_BOOT:
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 82fcf07fa9ea..01c7bb7316fb 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -638,9 +638,9 @@ static bool vfio_dev_whitelisted(struct device *dev, struct device_driver *drv)
 			return true;
 	}
 
-	return match_string(vfio_driver_whitelist,
-			    ARRAY_SIZE(vfio_driver_whitelist),
-			    drv->name) >= 0;
+	return __match_string(vfio_driver_whitelist,
+			      ARRAY_SIZE(vfio_driver_whitelist),
+			      drv->name) >= 0;
 }
 
 /*
diff --git a/drivers/video/fbdev/pxafb.c b/drivers/video/fbdev/pxafb.c
index d59c8a59f582..0025781e6e1e 100644
--- a/drivers/video/fbdev/pxafb.c
+++ b/drivers/video/fbdev/pxafb.c
@@ -2129,7 +2129,7 @@ static int of_get_pxafb_display(struct device *dev, struct device_node *disp,
 	if (ret)
 		s = "color-tft";
 
-	i = match_string(lcd_types, -1, s);
+	i = __match_string(lcd_types, -1, s);
 	if (i < 0) {
 		dev_err(dev, "lcd-type %s is unknown\n", s);
 		return i;
diff --git a/fs/ubifs/auth.c b/fs/ubifs/auth.c
index 60f43b93d06e..076feb5a9cb6 100644
--- a/fs/ubifs/auth.c
+++ b/fs/ubifs/auth.c
@@ -216,8 +216,8 @@ int ubifs_init_authentication(struct ubifs_info *c)
 		return -EINVAL;
 	}
 
-	c->auth_hash_algo = match_string(hash_algo_name, HASH_ALGO__LAST,
-					 c->auth_hash_name);
+	c->auth_hash_algo = __match_string(hash_algo_name, HASH_ALGO__LAST,
+					   c->auth_hash_name);
 	if ((int)c->auth_hash_algo < 0) {
 		ubifs_err(c, "Unknown hash algo %s specified",
 			  c->auth_hash_name);
diff --git a/include/linux/string.h b/include/linux/string.h
index 4deb11f7976b..7149fcdf62df 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -195,7 +195,7 @@ static inline int strtobool(const char *s, bool *res)
 	return kstrtobool(s, res);
 }
 
-int match_string(const char * const *array, size_t n, const char *string);
+int __match_string(const char * const *array, size_t n, const char *string);
 int __sysfs_match_string(const char * const *array, size_t n, const char *s);
 
 /**
diff --git a/kernel/cgroup/rdma.c b/kernel/cgroup/rdma.c
index 1d75ae7f1cb7..65d4df148603 100644
--- a/kernel/cgroup/rdma.c
+++ b/kernel/cgroup/rdma.c
@@ -367,7 +367,7 @@ static int parse_resource(char *c, int *intval)
 	if (!name || !value)
 		return -EINVAL;
 
-	i = match_string(rdmacg_resource_names, RDMACG_RESOURCE_MAX, name);
+	i = __match_string(rdmacg_resource_names, RDMACG_RESOURCE_MAX, name);
 	if (i < 0)
 		return i;
 
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 678bfb9bd87f..ef89323c1541 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -111,7 +111,7 @@ static int sched_feat_set(char *cmp)
 		cmp += 3;
 	}
 
-	i = match_string(sched_feat_names, __SCHED_FEAT_NR, cmp);
+	i = __match_string(sched_feat_names, __SCHED_FEAT_NR, cmp);
 	if (i < 0)
 		return i;
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 1c80521fd436..a818c6145d94 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4625,7 +4625,7 @@ static int trace_set_options(struct trace_array *tr, char *option)
 
 	mutex_lock(&trace_types_lock);
 
-	ret = match_string(trace_options, -1, cmp);
+	ret = __match_string(trace_options, -1, cmp);
 	/* If no option could be set, test the specific tracer options */
 	if (ret < 0)
 		ret = set_tracer_option(tr, cmp, neg);
diff --git a/lib/string.c b/lib/string.c
index e2cf5acc83bd..1797cf31760c 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -666,7 +666,7 @@ bool sysfs_streq(const char *s1, const char *s2)
 EXPORT_SYMBOL(sysfs_streq);
 
 /**
- * match_string - matches given string in an array
+ * __match_string - matches given string in an array
  * @array:	array of strings
  * @n:		number of strings in the array or -1 for NULL terminated arrays
  * @string:	string to match with
@@ -674,7 +674,7 @@ EXPORT_SYMBOL(sysfs_streq);
  * Return:
  * index of a @string in the @array if matches, or %-EINVAL otherwise.
  */
-int match_string(const char * const *array, size_t n, const char *string)
+int __match_string(const char * const *array, size_t n, const char *string)
 {
 	int index;
 	const char *item;
@@ -692,7 +692,7 @@ int match_string(const char * const *array, size_t n, const char *string)
 
 	return -EINVAL;
 }
-EXPORT_SYMBOL(match_string);
+EXPORT_SYMBOL(__match_string);
 
 /**
  * __sysfs_match_string - matches given string in an array
@@ -700,7 +700,7 @@ EXPORT_SYMBOL(match_string);
  * @n: number of strings in the array or -1 for NULL terminated arrays
  * @str: string to match with
  *
- * Returns index of @str in the @array or -EINVAL, just like match_string().
+ * Returns index of @str in the @array or -EINVAL, just like __match_string().
  * Uses sysfs_streq instead of strcmp for matching.
  */
 int __sysfs_match_string(const char * const *array, size_t n, const char *str)
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 2219e747df49..97bcf4658317 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2755,7 +2755,7 @@ int mpol_parse_str(char *str, struct mempolicy **mpol)
 	if (flags)
 		*flags++ = '\0';	/* terminate mode string */
 
-	mode = match_string(policy_modes, MPOL_MAX, str);
+	mode = __match_string(policy_modes, MPOL_MAX, str);
 	if (mode < 0)
 		goto out;
 
diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index 4854584ec436..d43f33139568 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -378,7 +378,7 @@ int vmpressure_register_event(struct mem_cgroup *memcg,
 
 	/* Find required level */
 	token = strsep(&spec, ",");
-	level = match_string(vmpressure_str_levels, VMPRESSURE_NUM_LEVELS, token);
+	level = __match_string(vmpressure_str_levels, VMPRESSURE_NUM_LEVELS, token);
 	if (level < 0) {
 		ret = level;
 		goto out;
@@ -387,7 +387,7 @@ int vmpressure_register_event(struct mem_cgroup *memcg,
 	/* Find optional mode */
 	token = strsep(&spec, ",");
 	if (token) {
-		mode = match_string(vmpressure_str_modes, VMPRESSURE_NUM_MODES, token);
+		mode = __match_string(vmpressure_str_modes, VMPRESSURE_NUM_MODES, token);
 		if (mode < 0) {
 			ret = mode;
 			goto out;
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 87500bde5a92..45d28db85e5a 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -1480,7 +1480,7 @@ static int param_set_audit(const char *val, const struct kernel_param *kp)
 	if (apparmor_initialized && !policy_admin_capable(NULL))
 		return -EPERM;
 
-	i = match_string(audit_mode_names, AUDIT_MAX_INDEX, val);
+	i = __match_string(audit_mode_names, AUDIT_MAX_INDEX, val);
 	if (i < 0)
 		return -EINVAL;
 
@@ -1509,7 +1509,7 @@ static int param_set_mode(const char *val, const struct kernel_param *kp)
 	if (apparmor_initialized && !policy_admin_capable(NULL))
 		return -EPERM;
 
-	i = match_string(aa_profile_mode_names, APPARMOR_MODE_NAMES_MAX_INDEX,
+	i = __match_string(aa_profile_mode_names, APPARMOR_MODE_NAMES_MAX_INDEX,
 			 val);
 	if (i < 0)
 		return -EINVAL;
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 357edd140c09..618842f85f2d 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -61,7 +61,7 @@ static int __init hash_setup(char *str)
 		goto out;
 	}
 
-	i = match_string(hash_algo_name, HASH_ALGO__LAST, str);
+	i = __match_string(hash_algo_name, HASH_ALGO__LAST, str);
 	if (i < 0)
 		return 1;
 
diff --git a/sound/firewire/oxfw/oxfw.c b/sound/firewire/oxfw/oxfw.c
index 3d27f3378d5d..9ec5316f3bb5 100644
--- a/sound/firewire/oxfw/oxfw.c
+++ b/sound/firewire/oxfw/oxfw.c
@@ -57,7 +57,7 @@ static bool detect_loud_models(struct fw_unit *unit)
 	if (err < 0)
 		return false;
 
-	return match_string(models, ARRAY_SIZE(models), model) >= 0;
+	return __match_string(models, ARRAY_SIZE(models), model) >= 0;
 }
 
 static int name_card(struct snd_oxfw *oxfw)
diff --git a/sound/pci/oxygen/oxygen_mixer.c b/sound/pci/oxygen/oxygen_mixer.c
index 81af21ac1439..13c2fb75fd71 100644
--- a/sound/pci/oxygen/oxygen_mixer.c
+++ b/sound/pci/oxygen/oxygen_mixer.c
@@ -1086,7 +1086,7 @@ static int add_controls(struct oxygen *chip,
 		err = snd_ctl_add(chip->card, ctl);
 		if (err < 0)
 			return err;
-		j = match_string(known_ctl_names, CONTROL_COUNT, ctl->id.name);
+		j = __match_string(known_ctl_names, CONTROL_COUNT, ctl->id.name);
 		if (j >= 0) {
 			chip->controls[j] = ctl;
 			ctl->private_free = oxygen_any_ctl_free;
diff --git a/sound/soc/codecs/max98088.c b/sound/soc/codecs/max98088.c
index ca172a4b6849..3ef743075bda 100644
--- a/sound/soc/codecs/max98088.c
+++ b/sound/soc/codecs/max98088.c
@@ -1405,7 +1405,7 @@ static int max98088_get_channel(struct snd_soc_component *component, const char
 {
 	int ret;
 
-	ret = match_string(eq_mode_name, ARRAY_SIZE(eq_mode_name), name);
+	ret = __match_string(eq_mode_name, ARRAY_SIZE(eq_mode_name), name);
 	if (ret < 0)
 		dev_err(component->dev, "Bad EQ channel name '%s'\n", name);
 	return ret;
diff --git a/sound/soc/codecs/max98095.c b/sound/soc/codecs/max98095.c
index 3b3a10da7f40..cd69916d5dcb 100644
--- a/sound/soc/codecs/max98095.c
+++ b/sound/soc/codecs/max98095.c
@@ -1636,7 +1636,7 @@ static int max98095_get_bq_channel(struct snd_soc_component *component,
 {
 	int ret;
 
-	ret = match_string(bq_mode_name, ARRAY_SIZE(bq_mode_name), name);
+	ret = __match_string(bq_mode_name, ARRAY_SIZE(bq_mode_name), name);
 	if (ret < 0)
 		dev_err(component->dev, "Bad biquad channel name '%s'\n", name);
 	return ret;
diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index 81a7a12196ff..33ccea0518b1 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -753,7 +753,7 @@ static int dapm_connect_mux(struct snd_soc_dapm_context *dapm,
 		item = 0;
 	}
 
-	i = match_string(e->texts, e->items, control_name);
+	i = __match_string(e->texts, e->items, control_name);
 	if (i < 0)
 		return -ENODEV;
 
-- 
2.20.1

