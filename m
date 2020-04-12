Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 720961A5EA7
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 15:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbgDLNCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 09:02:18 -0400
Received: from mta-out1.inet.fi ([62.71.2.194]:34098 "EHLO julia1.inet.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbgDLNCR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Apr 2020 09:02:17 -0400
X-Greylist: delayed 409 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Apr 2020 09:02:14 EDT
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgeduhedrvdejgdehlecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfupfevtfenuceurghilhhouhhtmecufedttdenucenucfjughrpefhuffvkffffgggtgesmhdtreertdefjeenucfhrhhomhepnfgruhhrihculfgrkhhkuhcuoehlrghurhhirdhjrghkkhhusehpphdrihhnvghtrdhfiheqnecukfhppeekgedrvdegkedrfedtrdduleehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehhvghloheplgduledvrdduieekrddurddufeegngdpihhnvghtpeekgedrvdegkedrfedtrdduleehpdhmrghilhhfrhhomhepoehlrghujhgrkhdqfeesmhgsohigrdhinhgvthdrfhhiqecuuefqffgjpeekuefkvffokffogfdprhgtphhtthhopeeonhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhgqe
Received: from [192.168.1.134] (84.248.30.195) by julia1.inet.fi (9.0.019.26-1) (authenticated as laujak-3)
        id 5E92F3500000A9DC for netdev@vger.kernel.org; Sun, 12 Apr 2020 15:55:21 +0300
From:   Lauri Jakku <lauri.jakku@pp.inet.fi>
Subject: NET: r8169 driver fix/enchansments
To:     netdev@vger.kernel.org
Message-ID: <43733c62-7d0b-258a-93c0-93788c05e475@pp.inet.fi>
Date:   Sun, 12 Apr 2020 15:55:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------B3E4339C0E7847812B6AB1E2"
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------B3E4339C0E7847812B6AB1E2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi,


I've made r8169 driver improvements & fixes, please see attachments.


--Lauri J.


-- 
Br,
Lauri J.


--------------B3E4339C0E7847812B6AB1E2
Content-Type: text/x-patch; charset=UTF-8;
 name="NET-r8169-module-enchansments.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="NET-r8169-module-enchansments.patch"

NET: r8169 module enchansments & fixes

  * Added soft depency from realtec phy to libphy.
  * realtek.ko is checked by cheking ID's of physical layer and driver

[   39.953438] Generic PHY r8169-200:00: attached PHY driver [Generic PHY] (mii_bus:phy_addr=r8169-200:00, irq=IGNORE)
[   39.957413] ------------[ cut here ]------------
[   39.957414] read_page callback not available, PHY driver not loaded?
[   39.957458] WARNING: CPU: 3 PID: 3896 at drivers/net/phy/phy-core.c:700 __phy_read_page+0x3f/0x50 [libphy]
[   39.957459] Modules linked in: cmac algif_hash algif_skcipher af_alg bnep nls_iso8859_1 nls_cp437 vfat fat squashfs loop videobuf2_vmalloc videobuf2_memops snd_usb_audio videobuf2_v4l2 amdgpu videobuf2_common snd_usbmidi_lib videodev snd_rawmidi snd_seq_device mc btusb btrtl btbcm btintel mousedev input_leds joydev
bluetooth gpu_sched snd_hda_codec_realtek i2c_algo_bit ttm ecdh_generic snd_hda_codec_generic snd_hda_codec_hdmi rfkill ecc drm_kms_helper ledtrig_audio snd_hda_intel drm snd_intel_dspcfg snd_hda_codec agpgart snd_hda_core syscopyarea sysfillrect sysimgblt snd_hwdep fb_sys_fops snd_pcm snd_timer r8169 snd soundcore eda
c_mce_amd sp5100_tco kvm_amd i2c_piix4 realtek libphy ccp wmi_bmof ppdev rng_core k10temp kvm irqbypass parport_pc evdev parport mac_hid wmi pcspkr acpi_cpufreq uinput crypto_user ip_tables x_tables ext4 crc32c_generic crc16 mbcache jbd2 hid_generic usbhid hid sr_mod cdrom sd_mod ohci_pci pata_atiixp ata_generic pata_acpi firewire_ohci ahci pata_jmicron
[   39.957483]  firewire_core libahci crc_itu_t libata scsi_mod ehci_pci ehci_hcd ohci_hcd floppy
[   39.957488] CPU: 3 PID: 3896 Comm: NetworkManager Not tainted 5.5.0-2-MANJARO-usb-mod-v4 #1
[   39.957489] Hardware name: Gigabyte Technology Co., Ltd. GA-MA790FXT-UD5P/GA-MA790FXT-UD5P, BIOS F8l 07/15/2010
[   39.957494] RIP: 0010:__phy_read_page+0x3f/0x50 [libphy]
[   39.957496] Code: c0 74 05 e9 33 77 3d e9 80 3d cd e3 00 00 00 74 06 b8 a1 ff ff ff c3 48 c7 c7 50 0c 63 c0 c6 05 b7 e3 00 00 01 e8 33 70 86 e8 <0f> 0b eb e3 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 0f 1f 44 00 00
[   39.957497] RSP: 0018:ffffa459ca3fb3b0 EFLAGS: 00010282
[   39.957498] RAX: 0000000000000000 RBX: 0000000000006662 RCX: 0000000000000000
[   39.957499] RDX: 0000000000000001 RSI: 0000000000000092 RDI: 00000000ffffffff
[   39.957499] RBP: ffff9c91b46c3800 R08: 000000000000047a R09: 0000000000000001
[   39.957500] R10: 0000000000000000 R11: 0000000000000001 R12: ffff9c91b5a8a8c0
[   39.957500] R13: 0000000000000002 R14: 0000000000000001 R15: 0000000000000000
[   39.957501] FS:  00007ff199d38d80(0000) GS:ffff9c91b7cc0000(0000) knlGS:0000000000000000
[   39.957502] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   39.957503] CR2: 00007f907f428ff8 CR3: 00000001ed122000 CR4: 00000000000006e0
[   39.957503] Call Trace:
[   39.957511]  phy_select_page+0x28/0x50 [libphy]
[   39.957518]  phy_write_paged+0x18/0x50 [libphy]
[   39.957523]  rtl8168d_1_hw_phy_config+0x1c8/0x1f0 [r8169]
[   39.957526]  rtl8169_init_phy+0x2c/0xb0 [r8169]
[   39.957529]  rtl_open+0x3b2/0x570 [r8169]
[   39.957533]  __dev_open+0xe0/0x170
[   39.957535]  __dev_change_flags+0x188/0x1e0
[   39.957537]  dev_change_flags+0x21/0x60
[   39.957539]  do_setlink+0x78a/0xf90
[   39.957544]  ? kernel_init_free_pages+0x6d/0x90
[   39.957546]  ? prep_new_page+0x46/0xd0
[   39.957548]  ? cpumask_next+0x16/0x20
[   39.957550]  ? __snmp6_fill_stats64.isra.0+0x66/0x110
[   39.957553]  __rtnl_newlink+0x5d1/0x9a0
[   39.957563]  rtnl_newlink+0x44/0x70
[   39.957564]  rtnetlink_rcv_msg+0x137/0x3c0
[   39.957566]  ? rtnl_calcit.isra.0+0x120/0x120
[   39.957568]  netlink_rcv_skb+0x75/0x140
[   39.957570]  netlink_unicast+0x199/0x240
[   39.957572]  netlink_sendmsg+0x243/0x480
[   39.957575]  sock_sendmsg+0x5e/0x60
[   39.957576]  ____sys_sendmsg+0x21b/0x290
[   39.957577]  ? copy_msghdr_from_user+0xe1/0x160
[   39.957580]  ___sys_sendmsg+0x9e/0xe0
[   39.957583]  ? addrconf_sysctl_forward+0x12b/0x270
[   39.957585]  __sys_sendmsg+0x81/0xd0
[   39.957588]  do_syscall_64+0x4e/0x150
[   39.957591]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   39.957593] RIP: 0033:0x7ff19af247ed
[   39.957594] Code: 28 89 54 24 1c 48 89 74 24 10 89 7c 24 08 e8 4a 53 f8 ff 8b 54 24 1c 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 2f 44 89 c7 48 89 44 24 08 e8 7e 53 f8 ff 48
[   39.957595] RSP: 002b:00007ffd570ac710 EFLAGS: 00000293 ORIG_RAX: 000000000000002e
[   39.957596] RAX: ffffffffffffffda RBX: 000000000000000c RCX: 00007ff19af247ed
[   39.957596] RDX: 0000000000000000 RSI: 00007ffd570ac750 RDI: 000000000000000c
[   39.957597] RBP: 0000562f3d390090 R08: 0000000000000000 R09: 0000000000000000
[   39.957597] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
[   39.957598] R13: 00007ffd570ac8b0 R14: 00007ffd570ac8ac R15: 0000000000000000
[   39.957601] ---[ end trace f2cccff3f7fdfb28 ]---

Signed-off-by: Lauri Jakku <lja@iki.fi>
Only in linux-modattu/drivers/net/ethernet/realtek: .r8169_phy_config.c.kate-swp
diff -ur linux-patsatty/drivers/net/ethernet/realtek/r8169_main.c linux-modattu/drivers/net/ethernet/realtek/r8169_main.c
--- linux-patsatty/drivers/net/ethernet/realtek/r8169_main.c	2020-03-30 01:25:41.000000000 +0300
+++ linux-modattu/drivers/net/ethernet/realtek/r8169_main.c	2020-04-12 15:42:59.876628465 +0300
@@ -2153,6 +2153,9 @@
 		p++;
 	tp->mac_version = p->mac_version;
 
+	dev_dbg(tp_to_dev(tp), "Detected chip XID %03x, ENUM: %d\n",
+		reg & 0xfcf, p->mac_version);
+
 	if (tp->mac_version == RTL_GIGA_MAC_NONE) {
 		dev_err(tp_to_dev(tp), "unknown chip XID %03x\n", reg & 0xfcf);
 	} else if (!tp->supports_gmii) {
@@ -2163,6 +2166,9 @@
 		else if (tp->mac_version == RTL_GIGA_MAC_VER_46)
 			tp->mac_version = RTL_GIGA_MAC_VER_48;
 	}
+	dev_info(tp_to_dev(tp), "Final chip XID %03x, ENUM: %d\n",
+		reg & 0xfcf, p->mac_version);
+
 }
 
 static void rtl_release_firmware(struct rtl8169_private *tp)
@@ -5262,6 +5268,9 @@
 {
 	struct pci_dev *pdev = tp->pci_dev;
 	struct mii_bus *new_bus;
+	u32 phydev_id = 0;
+	u32 phydrv_id = 0;
+	u32 phydrv_id_mask = 0;
 	int ret;
 
 	new_bus = devm_mdiobus_alloc(&pdev->dev);
@@ -5278,20 +5287,62 @@
 	new_bus->write = r8169_mdio_write_reg;
 
 	ret = mdiobus_register(new_bus);
+	dev_info(&pdev->dev,
+		 "mdiobus_register: %s, %d\n",
+		 new_bus->id, ret);
 	if (ret)
 		return ret;
 
 	tp->phydev = mdiobus_get_phy(new_bus, 0);
+
 	if (!tp->phydev) {
 		mdiobus_unregister(new_bus);
 		return -ENODEV;
-	} else if (!tp->phydev->drv) {
-		/* Most chip versions fail with the genphy driver.
-		 * Therefore ensure that the dedicated PHY driver is loaded.
-		 */
-		dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to be added to initramfs?\n");
-		mdiobus_unregister(new_bus);
-		return -EUNATCH;
+	} else {
+		/* tp -> phydev ok */
+		int everything_OK = 0;
+
+		/* get id's if not null */
+
+		if (tp->phydev->drv) {
+			u32 phydev_masked = 0xBEEFDEAD;
+			u32 drv_masked = !0;
+			u32 phydev_match = !0;
+			u32 drv_match = 0xDEADBEEF;
+
+			phydev_id      = tp->phydev->phy_id;
+			phydrv_id      = tp->phydev->drv->phy_id;
+			phydrv_id_mask = tp->phydev->drv->phy_id_mask;
+
+			drv_masked    = phydrv_id & phydrv_id_mask;
+			phydev_masked = phydev_id & phydrv_id_mask;
+
+			dev_debug(&pdev->dev,
+				  "%s: ID Check: (%x -> %x), drv (%x -> %x)\n",
+				new_bus->id, phydev_id, phydev_masked,
+				phydrv_id, drv_masked);
+
+			phydev_match = phydev_masked & drv_masked;
+			phydev_match = phydev_match == phydev_masked;
+
+			drv_match    = phydev_masked & drv_masked;
+			drv_match    = drv_match == drv_masked;
+
+			dev_debug(&pdev->dev, "%s: ID Check: %x == %x\n",
+				new_bus->id, phydev_match, drv_match);
+
+			everything_OK = (phydev_match == drv_match);
+		}
+
+		if (!everything_OK) {
+			/* Most chip versions fail with the genphy driver.
+			 * Therefore ensure that the dedicated PHY driver
+			 * is loaded.
+			 */
+			dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to be added to initramfs?\n");
+			mdiobus_unregister(new_bus);
+			return -EUNATCH;
+		}
 	}
 
 	/* PHY will be woken up in rtl_open() */
@@ -5486,7 +5537,7 @@
 	}
 
 	if (pcim_set_mwi(pdev) < 0)
-		dev_info(&pdev->dev, "Mem-Wr-Inval unavailable\n");
+		dev_dbg(&pdev->dev, "Mem-Wr-Inval unavailable\n");
 
 	/* use first MMIO region */
 	region = ffs(pci_select_bars(pdev, IORESOURCE_MEM)) - 1;
@@ -5508,9 +5559,12 @@
 	}
 
 	tp->mmio_addr = pcim_iomap_table(pdev)[region];
+	dev_err(&pdev->dev, "MMIO addr: 0x%p\n", tp->mmio_addr);
 
 	/* Identify chip attached to board */
 	rtl8169_get_mac_version(tp);
+	dev_err(&pdev->dev, "MAC version: %d\n", tp->mac_version);
+
 	if (tp->mac_version == RTL_GIGA_MAC_NONE)
 		return -ENODEV;
 
@@ -5520,17 +5574,23 @@
 	    !dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)))
 		dev->features |= NETIF_F_HIGHDMA;
 
+	dev_dbg(&pdev->dev, "init: rxcfg\n");
 	rtl_init_rxcfg(tp);
 
+	dev_dbg(&pdev->dev, "init: irq_mask_and_ack\n");
 	rtl8169_irq_mask_and_ack(tp);
 
+	dev_dbg(&pdev->dev, "init: HW\n");
 	rtl_hw_initialize(tp);
 
+	dev_dbg(&pdev->dev, "init: reset HW\n");
 	rtl_hw_reset(tp);
 
+	dev_dbg(&pdev->dev, "init: pci master\n");
 	pci_set_master(pdev);
 
 	chipset = tp->mac_version;
+	dev_dbg(&pdev->dev, "init: chipset: %d\n", chipset);
 
 	rc = rtl_alloc_irq(tp);
 	if (rc < 0) {
@@ -5543,6 +5603,7 @@
 	u64_stats_init(&tp->rx_stats.syncp);
 	u64_stats_init(&tp->tx_stats.syncp);
 
+	dev_dbg(&pdev->dev, "init: MAC\n");
 	rtl_init_mac_address(tp);
 
 	dev->ethtool_ops = &rtl8169_ethtool_ops;
@@ -5595,12 +5656,15 @@
 	dev->hw_features |= NETIF_F_RXFCS;
 
 	jumbo_max = rtl_jumbo_max(tp);
+	dev_dbg(&pdev->dev, "init: jumbo max: %d\n", jumbo_max);
 	if (jumbo_max)
 		dev->max_mtu = jumbo_max;
 
+	dev_dbg(&pdev->dev, "init: irq mask\n");
 	rtl_set_irq_mask(tp);
 
 	tp->fw_name = rtl_chip_infos[chipset].fw_name;
+	dev_dbg(&pdev->dev, "init: FW name: %s\n", tp->fw_name);
 
 	tp->counters = dmam_alloc_coherent (&pdev->dev, sizeof(*tp->counters),
 					    &tp->counters_phys_addr,
@@ -5608,16 +5672,21 @@
 	if (!tp->counters)
 		return -ENOMEM;
 
+	dev_dbg(&pdev->dev, "init: set driver data\n");
 	pci_set_drvdata(pdev, dev);
 
+	dev_dbg(&pdev->dev, "init: register mdio\n");
 	rc = r8169_mdio_register(tp);
+	dev_dbg(&pdev->dev, "init: mdio register: %d\n", rc);
 	if (rc)
 		return rc;
 
 	/* chip gets powered up in rtl_open() */
+	dev_dbg(&pdev->dev, "init: pll pwr down\n");
 	rtl_pll_power_down(tp);
 
 	rc = register_netdev(dev);
+	dev_dbg(&pdev->dev, "init: netdev register: %d\n", rc);
 	if (rc)
 		goto err_mdio_unregister;
 
@@ -5638,6 +5707,8 @@
 	if (pci_dev_run_wake(pdev))
 		pm_runtime_put_sync(&pdev->dev);
 
+	dev_dbg(&pdev->dev, "init: ALL DONE!\n");
+
 	return 0;
 
 err_mdio_unregister:
diff -ur linux-patsatty/drivers/net/phy/mdio_bus.c linux-modattu/drivers/net/phy/mdio_bus.c
--- linux-patsatty/drivers/net/phy/mdio_bus.c	2020-03-30 01:25:41.000000000 +0300
+++ linux-modattu/drivers/net/phy/mdio_bus.c	2020-04-12 15:41:51.199019551 +0300
@@ -112,6 +112,8 @@
 struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr)
 {
 	struct mdio_device *mdiodev = bus->mdio_map[addr];
+	struct phy_device *rv = NULL;
+	pr_debug("mii_bus %s addr %d, %p\n", bus->id, addr, mdiodev);
 
 	if (!mdiodev)
 		return NULL;
@@ -119,7 +121,10 @@
 	if (!(mdiodev->flags & MDIO_DEVICE_FLAG_PHY))
 		return NULL;
 
-	return container_of(mdiodev, struct phy_device, mdio);
+	rv = container_of(mdiodev, struct phy_device, mdio);
+	pr_debug("mii_bus OK? %s addr %d, %p -> %p\n",
+		 bus->id, addr, mdiodev, rv);
+	return rv;
 }
 EXPORT_SYMBOL(mdiobus_get_phy);
 
@@ -628,10 +633,11 @@
 	mdiobus_setup_mdiodev_from_board_info(bus, mdiobus_create_device);
 
 	bus->state = MDIOBUS_REGISTERED;
-	pr_info("%s: probed\n", bus->name);
+	pr_debug("%s: probed (mdiobus_register)\n", bus->name);
 	return 0;
 
 error:
+	pr_debug("%s: ERROR while in mdiobus_register: %d\n", bus->name, err);
 	while (--i >= 0) {
 		mdiodev = bus->mdio_map[i];
 		if (!mdiodev)
diff -ur linux-patsatty/drivers/net/phy/realtek.c linux-modattu/drivers/net/phy/realtek.c
--- linux-patsatty/drivers/net/phy/realtek.c	2020-04-11 03:42:14.086416074 +0300
+++ linux-modattu/drivers/net/phy/realtek.c	2020-03-30 01:25:41.000000000 +0300
@@ -54,8 +54,6 @@
 MODULE_DESCRIPTION("Realtek PHY driver");
 MODULE_AUTHOR("Johnson Leung");
 MODULE_LICENSE("GPL");
-MODULE_SOFTDEP("pre: libphy");
-
 
 static int rtl821x_read_page(struct phy_device *phydev)
 {


--------------B3E4339C0E7847812B6AB1E2--
