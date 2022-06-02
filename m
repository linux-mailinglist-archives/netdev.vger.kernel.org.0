Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97BEC53B9CB
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 15:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235352AbiFBNeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 09:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235339AbiFBNeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 09:34:14 -0400
Received: from zg8tmja5ljk3lje4ms43mwaa.icoremail.net (zg8tmja5ljk3lje4ms43mwaa.icoremail.net [209.97.181.73])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id C712725292;
        Thu,  2 Jun 2022 06:34:09 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [106.117.80.109])
        by mail-app3 (Coremail) with SMTP id cC_KCgCXn08uvJhiAyNhAQ--.19784S3;
        Thu, 02 Jun 2022 21:33:50 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     amitkarwar@gmail.com, ganapathi017@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        gregkh@linuxfoundation.org, johannes@sipsolutions.net,
        rafael@kernel.org, Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH v4 1/2] devcoredump: remove the useless gfp_t parameter in dev_coredumpv
Date:   Thu,  2 Jun 2022 21:33:33 +0800
Message-Id: <338a65fe8f30d23339cfc09fe1fb7be751ad655b.1654175941.git.duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1654175941.git.duoming@zju.edu.cn>
References: <cover.1654175941.git.duoming@zju.edu.cn>
In-Reply-To: <cover.1654175941.git.duoming@zju.edu.cn>
References: <cover.1654175941.git.duoming@zju.edu.cn>
X-CM-TRANSID: cC_KCgCXn08uvJhiAyNhAQ--.19784S3
X-Coremail-Antispam: 1UD129KBjvAXoW3CFyxXF4ktr45ZF4ktFWUurg_yoW8Jw1rXo
        WftrsxCa45Ar4Iyr93Grn7CFy3XFnrGw43Aa1rAFZ0gFZF9F1DuF1rX3W3Z3WFqa4rKw4f
        A347X3WDCr4Yk34fn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
        AaLaJ3UjIYCTnIWjp_UUUOr7AC8VAFwI0_Wr0E3s1l1xkIjI8I6I8E6xAIw20EY4v20xva
        j40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r18M28IrcIa0x
        kI8VCY1x0267AKxVW8JVW5JwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84AC
        jcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr
        1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1l
        e2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI
        8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwAC
        jcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0x
        kIwI1lc2xSY4AK67AK6ry8MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4U
        MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67
        AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0
        cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z2
        80aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI
        43ZEXa7VUUnXo7UUUUU==
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAggJAVZdtaA6nQAAs7
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dev_coredumpv() could not be used in atomic context, because
it calls kvasprintf_const() and kstrdup() with GFP_KERNEL parameter.
The process is shown below:

dev_coredumpv(..., gfp_t gfp)
  dev_coredumpm
    dev_set_name
      kobject_set_name_vargs
        kvasprintf_const(GFP_KERNEL, ...); //may sleep
          kstrdup(s, GFP_KERNEL); //may sleep

This patch removes gfp_t parameter of dev_coredumpv() and changes the
gfp_t parameter of dev_coredumpm() to GFP_KERNEL in order to show
dev_coredumpv() could not be used in atomic context.

Fixes: 833c95456a70 ("device coredump: add new device coredump class")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
Changes in v4:
  - Drop gfp_t parameter of dev_coredumpv.

 drivers/base/devcoredump.c                               | 6 ++----
 drivers/bluetooth/btmrvl_sdio.c                          | 2 +-
 drivers/bluetooth/hci_qca.c                              | 2 +-
 drivers/gpu/drm/etnaviv/etnaviv_dump.c                   | 2 +-
 drivers/media/platform/qcom/venus/core.c                 | 2 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.c           | 2 +-
 drivers/net/wireless/ath/ath10k/coredump.c               | 2 +-
 drivers/net/wireless/ath/wil6210/wil_crash_dump.c        | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c | 2 +-
 drivers/net/wireless/marvell/mwifiex/main.c              | 3 +--
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c          | 3 +--
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c          | 3 +--
 drivers/net/wireless/realtek/rtw88/main.c                | 2 +-
 drivers/net/wireless/realtek/rtw89/ser.c                 | 2 +-
 drivers/remoteproc/qcom_q6v5_mss.c                       | 2 +-
 drivers/remoteproc/remoteproc_coredump.c                 | 4 ++--
 include/linux/devcoredump.h                              | 5 ++---
 sound/soc/intel/catpt/dsp.c                              | 2 +-
 18 files changed, 21 insertions(+), 27 deletions(-)

diff --git a/drivers/base/devcoredump.c b/drivers/base/devcoredump.c
index f4d794d6bb8..5b331e9460e 100644
--- a/drivers/base/devcoredump.c
+++ b/drivers/base/devcoredump.c
@@ -173,15 +173,13 @@ static void devcd_freev(void *data)
  * @dev: the struct device for the crashed device
  * @data: vmalloc data containing the device coredump
  * @datalen: length of the data
- * @gfp: allocation flags
  *
  * This function takes ownership of the vmalloc'ed data and will free
  * it when it is no longer used. See dev_coredumpm() for more information.
  */
-void dev_coredumpv(struct device *dev, void *data, size_t datalen,
-		   gfp_t gfp)
+void dev_coredumpv(struct device *dev, void *data, size_t datalen)
 {
-	dev_coredumpm(dev, NULL, data, datalen, gfp, devcd_readv, devcd_freev);
+	dev_coredumpm(dev, NULL, data, datalen, GFP_KERNEL, devcd_readv, devcd_freev);
 }
 EXPORT_SYMBOL_GPL(dev_coredumpv);
 
diff --git a/drivers/bluetooth/btmrvl_sdio.c b/drivers/bluetooth/btmrvl_sdio.c
index b8ef66f89fc..9b9728719db 100644
--- a/drivers/bluetooth/btmrvl_sdio.c
+++ b/drivers/bluetooth/btmrvl_sdio.c
@@ -1515,7 +1515,7 @@ static void btmrvl_sdio_coredump(struct device *dev)
 	/* fw_dump_data will be free in device coredump release function
 	 * after 5 min
 	 */
-	dev_coredumpv(&card->func->dev, fw_dump_data, fw_dump_len, GFP_KERNEL);
+	dev_coredumpv(&card->func->dev, fw_dump_data, fw_dump_len);
 	BT_INFO("== btmrvl firmware dump to /sys/class/devcoredump end");
 }
 
diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index eab34e24d94..2e4074211ae 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1120,7 +1120,7 @@ static void qca_controller_memdump(struct work_struct *work)
 				    qca_memdump->ram_dump_size);
 			memdump_buf = qca_memdump->memdump_buf_head;
 			dev_coredumpv(&hu->serdev->dev, memdump_buf,
-				      qca_memdump->received_dump, GFP_KERNEL);
+				      qca_memdump->received_dump);
 			cancel_delayed_work(&qca->ctrl_memdump_timeout);
 			kfree(qca->qca_memdump);
 			qca->qca_memdump = NULL;
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_dump.c b/drivers/gpu/drm/etnaviv/etnaviv_dump.c
index f418e0b7577..519fcb234b3 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_dump.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_dump.c
@@ -225,5 +225,5 @@ void etnaviv_core_dump(struct etnaviv_gem_submit *submit)
 
 	etnaviv_core_dump_header(&iter, ETDUMP_BUF_END, iter.data);
 
-	dev_coredumpv(gpu->dev, iter.start, iter.data - iter.start, GFP_KERNEL);
+	dev_coredumpv(gpu->dev, iter.start, iter.data - iter.start);
 }
diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index 877eca12580..db84dfb3fb1 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -49,7 +49,7 @@ static void venus_coredump(struct venus_core *core)
 
 	memcpy(data, mem_va, mem_size);
 	memunmap(mem_va);
-	dev_coredumpv(dev, data, mem_size, GFP_KERNEL);
+	dev_coredumpv(dev, data, mem_size);
 }
 
 static void venus_event_notify(struct venus_core *core, u32 event)
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.c
index c991b30bc9f..fa520ab7c96 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.c
@@ -281,5 +281,5 @@ void mcp251xfd_dump(const struct mcp251xfd_priv *priv)
 	mcp251xfd_dump_end(priv, &iter);
 
 	dev_coredumpv(&priv->spi->dev, iter.start,
-		      iter.data - iter.start, GFP_KERNEL);
+		      iter.data - iter.start);
 }
diff --git a/drivers/net/wireless/ath/ath10k/coredump.c b/drivers/net/wireless/ath/ath10k/coredump.c
index fe6b6f97a91..dc923706992 100644
--- a/drivers/net/wireless/ath/ath10k/coredump.c
+++ b/drivers/net/wireless/ath/ath10k/coredump.c
@@ -1607,7 +1607,7 @@ int ath10k_coredump_submit(struct ath10k *ar)
 		return -ENODATA;
 	}
 
-	dev_coredumpv(ar->dev, dump, le32_to_cpu(dump->len), GFP_KERNEL);
+	dev_coredumpv(ar->dev, dump, le32_to_cpu(dump->len));
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/wil6210/wil_crash_dump.c b/drivers/net/wireless/ath/wil6210/wil_crash_dump.c
index 89c12cb2aaa..79299609dd6 100644
--- a/drivers/net/wireless/ath/wil6210/wil_crash_dump.c
+++ b/drivers/net/wireless/ath/wil6210/wil_crash_dump.c
@@ -117,6 +117,6 @@ void wil_fw_core_dump(struct wil6210_priv *wil)
 	/* fw_dump_data will be free in device coredump release function
 	 * after 5 min
 	 */
-	dev_coredumpv(wil_to_dev(wil), fw_dump_data, fw_dump_size, GFP_KERNEL);
+	dev_coredumpv(wil_to_dev(wil), fw_dump_data, fw_dump_size);
 	wil_info(wil, "fw core dumped, size %d bytes\n", fw_dump_size);
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
index eecf8a38d94..87f3652ef3b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
@@ -37,7 +37,7 @@ int brcmf_debug_create_memdump(struct brcmf_bus *bus, const void *data,
 		return err;
 	}
 
-	dev_coredumpv(bus->dev, dump, len + ramsize, GFP_KERNEL);
+	dev_coredumpv(bus->dev, dump, len + ramsize);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index ace7371c477..26fef0ab1b0 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1115,8 +1115,7 @@ void mwifiex_upload_device_dump(struct mwifiex_adapter *adapter)
 	 */
 	mwifiex_dbg(adapter, MSG,
 		    "== mwifiex dump information to /sys/class/devcoredump start\n");
-	dev_coredumpv(adapter->dev, adapter->devdump_data, adapter->devdump_len,
-		      GFP_KERNEL);
+	dev_coredumpv(adapter->dev, adapter->devdump_data, adapter->devdump_len);
 	mwifiex_dbg(adapter, MSG,
 		    "== mwifiex dump information to /sys/class/devcoredump end\n");
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index bd687f7de62..5336fe8c668 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -2421,6 +2421,5 @@ void mt7615_coredump_work(struct work_struct *work)
 
 		dev_kfree_skb(skb);
 	}
-	dev_coredumpv(dev->mt76.dev, dump, MT76_CONNAC_COREDUMP_SZ,
-		      GFP_KERNEL);
+	dev_coredumpv(dev->mt76.dev, dump, MT76_CONNAC_COREDUMP_SZ);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index a630ddbf19e..cac284f95ce 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -1630,8 +1630,7 @@ void mt7921_coredump_work(struct work_struct *work)
 	}
 
 	if (dump)
-		dev_coredumpv(dev->mt76.dev, dump, MT76_CONNAC_COREDUMP_SZ,
-			      GFP_KERNEL);
+		dev_coredumpv(dev->mt76.dev, dump, MT76_CONNAC_COREDUMP_SZ);
 
 	mt7921_reset(&dev->mt76);
 }
diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index efabd5b1bf5..a276544cecd 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -414,7 +414,7 @@ static void rtw_fwcd_dump(struct rtw_dev *rtwdev)
 	 * framework. Note that a new dump will be discarded if a previous one
 	 * hasn't been released yet.
 	 */
-	dev_coredumpv(rtwdev->dev, desc->data, desc->size, GFP_KERNEL);
+	dev_coredumpv(rtwdev->dev, desc->data, desc->size);
 }
 
 static void rtw_fwcd_free(struct rtw_dev *rtwdev, bool free_self)
diff --git a/drivers/net/wireless/realtek/rtw89/ser.c b/drivers/net/wireless/realtek/rtw89/ser.c
index 9e95ed97271..d28fe01ad72 100644
--- a/drivers/net/wireless/realtek/rtw89/ser.c
+++ b/drivers/net/wireless/realtek/rtw89/ser.c
@@ -127,7 +127,7 @@ static void rtw89_ser_cd_send(struct rtw89_dev *rtwdev,
 	 * will be discarded if a previous one hasn't been released by
 	 * framework yet.
 	 */
-	dev_coredumpv(rtwdev->dev, buf, sizeof(*buf), GFP_KERNEL);
+	dev_coredumpv(rtwdev->dev, buf, sizeof(*buf));
 }
 
 static void rtw89_ser_cd_free(struct rtw89_dev *rtwdev,
diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
index af217de75e4..813d87faef6 100644
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -597,7 +597,7 @@ static void q6v5_dump_mba_logs(struct q6v5 *qproc)
 	data = vmalloc(MBA_LOG_SIZE);
 	if (data) {
 		memcpy(data, mba_region, MBA_LOG_SIZE);
-		dev_coredumpv(&rproc->dev, data, MBA_LOG_SIZE, GFP_KERNEL);
+		dev_coredumpv(&rproc->dev, data, MBA_LOG_SIZE);
 	}
 	memunmap(mba_region);
 }
diff --git a/drivers/remoteproc/remoteproc_coredump.c b/drivers/remoteproc/remoteproc_coredump.c
index 4b093420d98..36ba7b300d5 100644
--- a/drivers/remoteproc/remoteproc_coredump.c
+++ b/drivers/remoteproc/remoteproc_coredump.c
@@ -309,7 +309,7 @@ void rproc_coredump(struct rproc *rproc)
 		phdr += elf_size_of_phdr(class);
 	}
 	if (dump_conf == RPROC_COREDUMP_ENABLED) {
-		dev_coredumpv(&rproc->dev, data, data_size, GFP_KERNEL);
+		dev_coredumpv(&rproc->dev, data, data_size);
 		return;
 	}
 
@@ -449,7 +449,7 @@ void rproc_coredump_using_sections(struct rproc *rproc)
 	}
 
 	if (dump_conf == RPROC_COREDUMP_ENABLED) {
-		dev_coredumpv(&rproc->dev, data, data_size, GFP_KERNEL);
+		dev_coredumpv(&rproc->dev, data, data_size);
 		return;
 	}
 
diff --git a/include/linux/devcoredump.h b/include/linux/devcoredump.h
index c008169ed2c..a9fba5e7046 100644
--- a/include/linux/devcoredump.h
+++ b/include/linux/devcoredump.h
@@ -52,8 +52,7 @@ static inline void _devcd_free_sgtable(struct scatterlist *table)
 
 
 #ifdef CONFIG_DEV_COREDUMP
-void dev_coredumpv(struct device *dev, void *data, size_t datalen,
-		   gfp_t gfp);
+void dev_coredumpv(struct device *dev, void *data, size_t datalen);
 
 void dev_coredumpm(struct device *dev, struct module *owner,
 		   void *data, size_t datalen, gfp_t gfp,
@@ -65,7 +64,7 @@ void dev_coredumpsg(struct device *dev, struct scatterlist *table,
 		    size_t datalen, gfp_t gfp);
 #else
 static inline void dev_coredumpv(struct device *dev, void *data,
-				 size_t datalen, gfp_t gfp)
+				 size_t datalen)
 {
 	vfree(data);
 }
diff --git a/sound/soc/intel/catpt/dsp.c b/sound/soc/intel/catpt/dsp.c
index 346bec00030..d2afe9ff1e3 100644
--- a/sound/soc/intel/catpt/dsp.c
+++ b/sound/soc/intel/catpt/dsp.c
@@ -539,7 +539,7 @@ int catpt_coredump(struct catpt_dev *cdev)
 		pos += CATPT_DMA_REGS_SIZE;
 	}
 
-	dev_coredumpv(cdev->dev, dump, dump_size, GFP_KERNEL);
+	dev_coredumpv(cdev->dev, dump, dump_size);
 
 	return 0;
 }
-- 
2.17.1

