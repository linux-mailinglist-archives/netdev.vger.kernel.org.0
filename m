Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6974176F0
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 13:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbfEHL3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 07:29:45 -0400
Received: from mail-eopbgr810083.outbound.protection.outlook.com ([40.107.81.83]:38989
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725778AbfEHL3l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 07:29:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector1-analog-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rZeVg/yeEO8QwcWertBlPmQ2l7Vvz2vxMkhYSAMALsQ=;
 b=Zmj6CCQTYIB00ZoWV93J92uTIgwz63rUoeawQKSxQ+DdnNQYgn1SRHMS0l4O2RAp4YDRvEGtNxW29jgr7HbuBrnNdjkUodQSa2KKmeoPfm0TSDQELrcfmdOsC867p0tSyTYBuUFQiKTF+V3OV/OnA5FSSXw5816lnQ5ojFrccCc=
Received: from BN8PR03CA0012.namprd03.prod.outlook.com (2603:10b6:408:94::25)
 by SN2PR03MB2270.namprd03.prod.outlook.com (2603:10b6:804:d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1856.10; Wed, 8 May
 2019 11:29:33 +0000
Received: from CY1NAM02FT046.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::209) by BN8PR03CA0012.outlook.office365.com
 (2603:10b6:408:94::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1878.20 via Frontend
 Transport; Wed, 8 May 2019 11:29:32 +0000
Authentication-Results: spf=pass (sender IP is 137.71.25.57)
 smtp.mailfrom=analog.com; lists.freedesktop.org; dkim=none (message not
 signed) header.d=none;lists.freedesktop.org; dmarc=bestguesspass action=none
 header.from=analog.com;
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT046.mail.protection.outlook.com (10.152.74.232) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1856.11
 via Frontend Transport; Wed, 8 May 2019 11:29:31 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x48BTUIq017012
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Wed, 8 May 2019 04:29:30 -0700
Received: from saturn.analog.com (10.50.1.244) by NWD2HUBCAS7.ad.analog.com
 (10.64.69.107) with Microsoft SMTP Server id 14.3.408.0; Wed, 8 May 2019
 07:29:29 -0400
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
CC:     <gregkh@linuxfoundation.org>, <andriy.shevchenko@linux.intel.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 02/16] treewide: rename match_string() -> __match_string()
Date:   Wed, 8 May 2019 14:28:28 +0300
Message-ID: <20190508112842.11654-4-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190508112842.11654-1-alexandru.ardelean@analog.com>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(1496009)(136003)(346002)(39860400002)(396003)(376002)(2980300002)(199004)(189003)(76176011)(7696005)(356004)(70206006)(51416003)(316002)(7416002)(2201001)(305945005)(7636002)(107886003)(48376002)(47776003)(110136005)(16586007)(4326008)(2906002)(54906003)(53416004)(106002)(53946003)(11346002)(446003)(14444005)(36756003)(478600001)(2441003)(186003)(486006)(50226002)(126002)(2616005)(476003)(86362001)(70586007)(50466002)(336012)(8936002)(5660300002)(1076003)(30864003)(426003)(77096007)(26005)(44832011)(246002)(8676002)(921003)(83996005)(1121003)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN2PR03MB2270;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6493bca1-5441-41b0-7a65-08d6d3a87133
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4709054)(2017052603328);SRVR:SN2PR03MB2270;
X-MS-TrafficTypeDiagnostic: SN2PR03MB2270:
X-Microsoft-Antispam-PRVS: <SN2PR03MB2270D9AB9AEC7495C2FCC6D2F9320@SN2PR03MB2270.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:792;
X-Forefront-PRVS: 0031A0FFAF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 5+KmdLLnqwxyIcBxR3vMYyaOddNMcxSjX0hi8ijv9hA5KSlNr+cq0uJEwqa0LT+u1BaKbrF5td99i9yckshqmFf5qKus7IW14Y1chQE6/ACj6l+/R/3QEY6wqrkJn1T574YOv0KUrwnwc7PcJhgUggnqeCaTFIn5FwiN4x16gI5zn/7LAWar+UXMj/d0X0OzIccN9QE6emuT3RrKdiowr+Sm6R1tIFUngc8CVFG4eUV5z3rlaet5aBsZfs2B9Jdz5/6A6YYMxjgB+oAsP0hkHpa6UTNuG/TamX4o39dzPX2G593gqRhGCOCkW+R00Ea4AVcxI/4JxEIQ8Q2Jan7+Ef5Acl4SZLOXiJGhwgEkAsvvRgxs1IlzFMQgmt5rYUjpdGAlYwko5VLFYJgA5yCiw4HizCQm8RhrX5DJLAYC0+8=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2019 11:29:31.1227
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6493bca1-5441-41b0-7a65-08d6d3a87133
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR03MB2270
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change does a rename of match_string() -> __match_string().

There are a few parts to the intention here (with this change):
1. Align with sysfs_match_string()/__sysfs_match_string()
2. This helps to group users of `match_string()` into simple users:
   a. those that use ARRAY_SIZE(_a) to specify the number of elements
   b. those that use -1 to pass a NULL terminated array of strings
   c. special users, which (after eliminating 1 & 2) are not that many
3. The final intent is to fix match_string()/__match_string() which is
   slightly broken, in the sense that passing -1 or a positive value does
   not make any difference: the iteration will stop at the first NULL
   element.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 arch/powerpc/xmon/xmon.c                         |  2 +-
 arch/x86/kernel/cpu/mtrr/if.c                    |  2 +-
 drivers/ata/pata_hpt366.c                        |  2 +-
 drivers/ata/pata_hpt37x.c                        |  2 +-
 drivers/base/devcon.c                            |  2 +-
 drivers/base/property.c                          |  2 +-
 drivers/clk/bcm/clk-bcm2835.c                    |  6 +++---
 drivers/clk/clk.c                                |  4 ++--
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
 drivers/phy/tegra/xusb.c                         |  2 +-
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
 48 files changed, 68 insertions(+), 68 deletions(-)

diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index a0f44f992360..efca104ac0cb 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -3231,7 +3231,7 @@ scanhex(unsigned long *vp)
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
index a219a503c229..4ba5fc9d20be 100644
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -180,7 +180,7 @@ static int hpt_dma_blacklisted(const struct ata_device *dev, char *modestr,
 
 	ata_id_c_string(dev->id, model_num, ATA_ID_PROD, sizeof(model_num));
 
-	i = match_string(list, -1, model_num);
+	i = __match_string(list, -1, model_num);
 	if (i >= 0) {
 		pr_warn("%s is not supported for %s\n", modestr, list[i]);
 		return 1;
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index ef8aaeb0c575..ce21f01dad04 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -228,7 +228,7 @@ static int hpt_dma_blacklisted(const struct ata_device *dev, char *modestr,
 
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
index 8b91ab380d14..4639275f55fe 100644
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
index 9fcae932e082..a775f6a1f717 100644
--- a/drivers/clk/bcm/clk-bcm2835.c
+++ b/drivers/clk/bcm/clk-bcm2835.c
@@ -1390,9 +1390,9 @@ static struct clk_hw *bcm2835_register_clock(struct bcm2835_cprman *cprman,
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
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 96053a96fe2f..0b6c3d300411 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -2305,8 +2305,8 @@ bool clk_has_parent(struct clk *clk, struct clk *parent)
 	if (core->parent == parent_core)
 		return true;
 
-	return match_string(core->parent_names, core->num_parents,
-			    parent_core->name) >= 0;
+	return __match_string(core->parent_names, core->num_parents,
+			      parent_core->name) >= 0;
 }
 EXPORT_SYMBOL_GPL(clk_has_parent);
 
diff --git a/drivers/clk/rockchip/clk.c b/drivers/clk/rockchip/clk.c
index c3ad92965823..373f13e9cd83 100644
--- a/drivers/clk/rockchip/clk.c
+++ b/drivers/clk/rockchip/clk.c
@@ -276,8 +276,8 @@ static struct clk *rockchip_clk_register_frac_branch(
 		struct clk *mux_clk;
 		int ret;
 
-		frac->mux_frac_idx = match_string(child->parent_names,
-						  child->num_parents, name);
+		frac->mux_frac_idx = __match_string(child->parent_names,
+						    child->num_parents, name);
 		frac->mux_ops = &clk_mux_ops;
 		frac->clk_nb.notifier_call = rockchip_clk_frac_notifier_cb;
 
diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 2986119dd31f..6ed1e705bc05 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -701,7 +701,7 @@ static ssize_t store_energy_performance_preference(
 	if (ret != 1)
 		return -EINVAL;
 
-	ret = match_string(energy_perf_strings, -1, str_preference);
+	ret = __match_string(energy_perf_strings, -1, str_preference);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index 6a3ec575a404..27d6f04ab58e 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -279,7 +279,7 @@ static struct gpio_desc *of_find_regulator_gpio(struct device *dev, const char *
 	if (!con_id)
 		return ERR_PTR(-ENOENT);
 
-	i = match_string(whitelist, ARRAY_SIZE(whitelist), con_id);
+	i = __match_string(whitelist, ARRAY_SIZE(whitelist), con_id);
 	if (i < 0)
 		return ERR_PTR(-ENOENT);
 
diff --git a/drivers/gpu/drm/drm_edid_load.c b/drivers/gpu/drm/drm_edid_load.c
index a4915099aaa9..1450051972ea 100644
--- a/drivers/gpu/drm/drm_edid_load.c
+++ b/drivers/gpu/drm/drm_edid_load.c
@@ -186,7 +186,7 @@ static void *edid_load(struct drm_connector *connector, const char *name,
 	int i, valid_extensions = 0;
 	bool print_bad_edid = !connector->bad_edid_counter || (drm_debug & DRM_UT_KMS);
 
-	builtin = match_string(generic_edid_name, GENERIC_EDIDS, name);
+	builtin = __match_string(generic_edid_name, GENERIC_EDIDS, name);
 	if (builtin >= 0) {
 		fwdata = generic_edid[builtin];
 		fwsize = sizeof(generic_edid[builtin]);
diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 52e445bb1aa5..8f7f31a1248c 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -200,7 +200,7 @@ int drm_get_panel_orientation_quirk(int width, int height)
 		if (!bios_date)
 			continue;
 
-		i = match_string(data->bios_dates, -1, bios_date);
+		i = __match_string(data->bios_dates, -1, bios_date);
 		if (i >= 0)
 			return data->orientation;
 	}
diff --git a/drivers/gpu/drm/i915/intel_pipe_crc.c b/drivers/gpu/drm/i915/intel_pipe_crc.c
index a8554dc4f196..286fad1f0e08 100644
--- a/drivers/gpu/drm/i915/intel_pipe_crc.c
+++ b/drivers/gpu/drm/i915/intel_pipe_crc.c
@@ -449,7 +449,7 @@ display_crc_ctl_parse_source(const char *buf, enum intel_pipe_crc_source *s)
 		return 0;
 	}
 
-	i = match_string(pipe_crc_sources, ARRAY_SIZE(pipe_crc_sources), buf);
+	i = __match_string(pipe_crc_sources, ARRAY_SIZE(pipe_crc_sources), buf);
 	if (i < 0)
 		return i;
 
diff --git a/drivers/ide/hpt366.c b/drivers/ide/hpt366.c
index 0a3f9bcc8b04..1c4052fd02ab 100644
--- a/drivers/ide/hpt366.c
+++ b/drivers/ide/hpt366.c
@@ -533,7 +533,7 @@ static const struct hpt_info hpt371n = {
 
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
index 776b24f54200..59ce3ff35553 100644
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
index f8fc2114ad39..41a0773a1cbc 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -203,7 +203,7 @@ void pcie_ecrc_get_policy(char *str)
 {
 	int i;
 
-	i = match_string(ecrc_policy_str, ARRAY_SIZE(ecrc_policy_str), str);
+	i = __match_string(ecrc_policy_str, ARRAY_SIZE(ecrc_policy_str), str);
 	if (i < 0)
 		return;
 
diff --git a/drivers/phy/tegra/xusb.c b/drivers/phy/tegra/xusb.c
index 5b3b8863363e..d5686b5db107 100644
--- a/drivers/phy/tegra/xusb.c
+++ b/drivers/phy/tegra/xusb.c
@@ -113,7 +113,7 @@ int tegra_xusb_lane_parse_dt(struct tegra_xusb_lane *lane,
 	if (err < 0)
 		return err;
 
-	err = match_string(lane->soc->funcs, lane->soc->num_funcs, function);
+	err = __match_string(lane->soc->funcs, lane->soc->num_funcs, function);
 	if (err < 0) {
 		dev_err(dev, "invalid function \"%s\" for lane \"%pOFn\"\n",
 			function, np);
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
index 2e8db5e6de0b..27a8ba63563e 100644
--- a/drivers/power/supply/charger-manager.c
+++ b/drivers/power/supply/charger-manager.c
@@ -2019,8 +2019,8 @@ void cm_notify_event(struct power_supply *psy, enum cm_event_types type,
 
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
index 73c8e6591746..bca0c404c6ca 100644
--- a/drivers/usb/common/common.c
+++ b/drivers/usb/common/common.c
@@ -68,7 +68,7 @@ enum usb_device_speed usb_get_maximum_speed(struct device *dev)
 	if (ret < 0)
 		return USB_SPEED_UNKNOWN;
 
-	ret = match_string(speed_names, ARRAY_SIZE(speed_names), maximum_speed);
+	ret = __match_string(speed_names, ARRAY_SIZE(speed_names), maximum_speed);
 
 	return (ret < 0) ? USB_SPEED_UNKNOWN : ret;
 }
@@ -106,7 +106,7 @@ static enum usb_dr_mode usb_get_dr_mode_from_string(const char *str)
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
index a3030cdf3c18..b31585ecf48f 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -637,9 +637,9 @@ static bool vfio_dev_whitelisted(struct device *dev, struct device_driver *drv)
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
index 5bf5fd08879e..43742d76b203 100644
--- a/fs/ubifs/auth.c
+++ b/fs/ubifs/auth.c
@@ -235,8 +235,8 @@ int ubifs_init_authentication(struct ubifs_info *c)
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
index 6ab0a6fa512e..531d04308ff9 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -191,7 +191,7 @@ static inline int strtobool(const char *s, bool *res)
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
index 8039d62ae36e..b0efc5fe641e 100644
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
index ca1ee656d6d8..d9146141d9d8 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4602,7 +4602,7 @@ static int trace_set_options(struct trace_array *tr, char *option)
 
 	mutex_lock(&trace_types_lock);
 
-	ret = match_string(trace_options, -1, cmp);
+	ret = __match_string(trace_options, -1, cmp);
 	/* If no option could be set, test the specific tracer options */
 	if (ret < 0)
 		ret = set_tracer_option(tr, cmp, neg);
diff --git a/lib/string.c b/lib/string.c
index 76edb7bf76cb..2d5f0afef1f2 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -633,7 +633,7 @@ bool sysfs_streq(const char *s1, const char *s2)
 EXPORT_SYMBOL(sysfs_streq);
 
 /**
- * match_string - matches given string in an array
+ * __match_string - matches given string in an array
  * @array:	array of strings
  * @n:		number of strings in the array or -1 for NULL terminated arrays
  * @string:	string to match with
@@ -641,7 +641,7 @@ EXPORT_SYMBOL(sysfs_streq);
  * Return:
  * index of a @string in the @array if matches, or %-EINVAL otherwise.
  */
-int match_string(const char * const *array, size_t n, const char *string)
+int __match_string(const char * const *array, size_t n, const char *string)
 {
 	int index;
 	const char *item;
@@ -659,7 +659,7 @@ int match_string(const char * const *array, size_t n, const char *string)
 
 	return -EINVAL;
 }
-EXPORT_SYMBOL(match_string);
+EXPORT_SYMBOL(__match_string);
 
 /**
  * __sysfs_match_string - matches given string in an array
@@ -667,7 +667,7 @@ EXPORT_SYMBOL(match_string);
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
index 0382a47b30bd..c9a1e27e5839 100644
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
2.17.1

