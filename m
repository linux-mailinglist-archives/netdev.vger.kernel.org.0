Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA3952102
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 05:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729328AbfFYDTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 23:19:41 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:19618 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728022AbfFYDTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 23:19:38 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5P36vKw025910
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 23:19:34 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tb9r3ur3c-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 23:19:34 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <alastair@au1.ibm.com>;
        Tue, 25 Jun 2019 04:19:31 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 25 Jun 2019 04:19:22 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5P3JL6J43384890
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jun 2019 03:19:21 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75F53AE057;
        Tue, 25 Jun 2019 03:19:21 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7C43CAE058;
        Tue, 25 Jun 2019 03:19:20 +0000 (GMT)
Received: from ozlabs.au.ibm.com (unknown [9.192.253.14])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Jun 2019 03:19:20 +0000 (GMT)
Received: from adsilva.ozlabs.ibm.com (haven.au.ibm.com [9.192.254.114])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ozlabs.au.ibm.com (Postfix) with ESMTPSA id 5E386A02C5;
        Tue, 25 Jun 2019 13:19:19 +1000 (AEST)
From:   "Alastair D'Silva" <alastair@au1.ibm.com>
To:     alastair@d-silva.org
Cc:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Karsten Keil <isdn@linux-pingi.de>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Benson Leung <bleung@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Andrew Morton <akpm@linux-foundation.org>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v4 4/7] lib/hexdump.c: Replace ascii bool in hex_dump_to_buffer with flags
Date:   Tue, 25 Jun 2019 13:17:23 +1000
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190625031726.12173-1-alastair@au1.ibm.com>
References: <20190625031726.12173-1-alastair@au1.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19062503-0012-0000-0000-0000032C1757
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062503-0013-0000-0000-000021654AAD
Message-Id: <20190625031726.12173-5-alastair@au1.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-25_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906250024
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alastair D'Silva <alastair@d-silva.org>

In order to support additional features, rename hex_dump_to_buffer to
hex_dump_to_buffer_ext, and replace the ascii bool parameter with flags.

A wrapper is provided for callers that do not need anything but a basic
dump.

Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
---
 drivers/gpu/drm/i915/intel_engine_cs.c        |  5 +-
 drivers/isdn/hardware/mISDN/mISDNisar.c       | 10 ++--
 drivers/mailbox/mailbox-test.c                |  8 ++--
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      |  2 +-
 .../net/ethernet/synopsys/dwc-xlgmac-common.c |  2 +-
 drivers/net/wireless/ath/ath10k/debug.c       |  7 +--
 .../net/wireless/intel/iwlegacy/3945-mac.c    |  4 +-
 drivers/platform/chrome/wilco_ec/debugfs.c    | 10 ++--
 drivers/scsi/scsi_logging.c                   |  8 ++--
 drivers/staging/fbtft/fbtft-core.c            |  2 +-
 fs/seq_file.c                                 |  6 ++-
 include/linux/printk.h                        | 46 +++++++++++++++++--
 lib/hexdump.c                                 | 24 +++++-----
 lib/test_hexdump.c                            | 10 ++--
 14 files changed, 94 insertions(+), 50 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_engine_cs.c b/drivers/gpu/drm/i915/intel_engine_cs.c
index eea9bec04f1b..64189a0e5ec9 100644
--- a/drivers/gpu/drm/i915/intel_engine_cs.c
+++ b/drivers/gpu/drm/i915/intel_engine_cs.c
@@ -1338,9 +1338,8 @@ static void hexdump(struct drm_printer *m, const void *buf, size_t len)
 		}
 
 		WARN_ON_ONCE(hex_dump_to_buffer(buf + pos, len - pos,
-						rowsize, sizeof(u32),
-						line, sizeof(line),
-						false) >= sizeof(line));
+						rowsize, sizeof(u32), line,
+						sizeof(line)) >= sizeof(line));
 		drm_printf(m, "[%04zx] %s\n", pos, line);
 
 		prev = buf + pos;
diff --git a/drivers/isdn/hardware/mISDN/mISDNisar.c b/drivers/isdn/hardware/mISDN/mISDNisar.c
index fd5c52f37802..84455b521246 100644
--- a/drivers/isdn/hardware/mISDN/mISDNisar.c
+++ b/drivers/isdn/hardware/mISDN/mISDNisar.c
@@ -70,8 +70,9 @@ send_mbox(struct isar_hw *isar, u8 his, u8 creg, u8 len, u8 *msg)
 			int l = 0;
 
 			while (l < (int)len) {
-				hex_dump_to_buffer(msg + l, len - l, 32, 1,
-						   isar->log, 256, 1);
+				hex_dump_to_buffer_ext(msg + l, len - l, 32, 1,
+						       isar->log, 256,
+						       HEXDUMP_ASCII);
 				pr_debug("%s: %s %02x: %s\n", isar->name,
 					 __func__, l, isar->log);
 				l += 32;
@@ -99,8 +100,9 @@ rcv_mbox(struct isar_hw *isar, u8 *msg)
 			int l = 0;
 
 			while (l < (int)isar->clsb) {
-				hex_dump_to_buffer(msg + l, isar->clsb - l, 32,
-						   1, isar->log, 256, 1);
+				hex_dump_to_buffer_ext(msg + l, isar->clsb - l,
+						       32, 1, isar->log, 256,
+						       HEXDUMP_ASCII);
 				pr_debug("%s: %s %02x: %s\n", isar->name,
 					 __func__, l, isar->log);
 				l += 32;
diff --git a/drivers/mailbox/mailbox-test.c b/drivers/mailbox/mailbox-test.c
index 4555d678fadd..ce334f88a3ee 100644
--- a/drivers/mailbox/mailbox-test.c
+++ b/drivers/mailbox/mailbox-test.c
@@ -206,10 +206,10 @@ static ssize_t mbox_test_message_read(struct file *filp, char __user *userbuf,
 
 	ptr = tdev->rx_buffer;
 	while (l < MBOX_HEXDUMP_MAX_LEN) {
-		hex_dump_to_buffer(ptr,
-				   MBOX_BYTES_PER_LINE,
-				   MBOX_BYTES_PER_LINE, 1, touser + l,
-				   MBOX_HEXDUMP_LINE_LEN, true);
+		hex_dump_to_buffer_ext(ptr,
+				       MBOX_BYTES_PER_LINE,
+				       MBOX_BYTES_PER_LINE, 1, touser + l,
+				       MBOX_HEXDUMP_LINE_LEN, HEXDUMP_ASCII);
 
 		ptr += MBOX_BYTES_PER_LINE;
 		l += MBOX_HEXDUMP_LINE_LEN;
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 3dd0cecddba8..f0118fe35c41 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2992,7 +2992,7 @@ void xgbe_print_pkt(struct net_device *netdev, struct sk_buff *skb, bool tx_rx)
 		unsigned int len = min(skb->len - i, 32U);
 
 		hex_dump_to_buffer(&skb->data[i], len, 32, 1,
-				   buffer, sizeof(buffer), false);
+				   buffer, sizeof(buffer));
 		netdev_dbg(netdev, "  %#06x: %s\n", i, buffer);
 	}
 
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
index eb1c6b03c329..53991c123c4d 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
@@ -349,7 +349,7 @@ void xlgmac_print_pkt(struct net_device *netdev,
 		unsigned int len = min(skb->len - i, 32U);
 
 		hex_dump_to_buffer(&skb->data[i], len, 32, 1,
-				   buffer, sizeof(buffer), false);
+				   buffer, sizeof(buffer));
 		netdev_dbg(netdev, "  %#06x: %s\n", i, buffer);
 	}
 
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 32d967a31c65..8d79f8fc694d 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -2660,9 +2660,10 @@ void ath10k_dbg_dump(struct ath10k *ar,
 						"%s%08x: ",
 						(prefix ? prefix : ""),
 						(unsigned int)(ptr - buf));
-			hex_dump_to_buffer(ptr, len - (ptr - buf), 16, 1,
-					   linebuf + linebuflen,
-					   sizeof(linebuf) - linebuflen, true);
+			hex_dump_to_buffer_ext(ptr, len - (ptr - buf), 16, 1,
+					       linebuf + linebuflen,
+					       sizeof(linebuf) - linebuflen,
+					       HEXDUMP_ASCII);
 			dev_printk(KERN_DEBUG, ar->dev, "%s\n", linebuf);
 		}
 	}
diff --git a/drivers/net/wireless/intel/iwlegacy/3945-mac.c b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
index b82da75a9ae3..92d030109395 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
@@ -3231,8 +3231,8 @@ il3945_show_measurement(struct device *d, struct device_attribute *attr,
 	spin_unlock_irqrestore(&il->lock, flags);
 
 	while (size && PAGE_SIZE - len) {
-		hex_dump_to_buffer(data + ofs, size, 16, 1, buf + len,
-				   PAGE_SIZE - len, true);
+		hex_dump_to_buffer_ext(data + ofs, size, 16, 1, buf + len,
+				       PAGE_SIZE - len, HEXDUMP_ASCII);
 		len = strlen(buf);
 		if (PAGE_SIZE - len)
 			buf[len++] = '\n';
diff --git a/drivers/platform/chrome/wilco_ec/debugfs.c b/drivers/platform/chrome/wilco_ec/debugfs.c
index f163476d080d..6c0a443bdb1b 100644
--- a/drivers/platform/chrome/wilco_ec/debugfs.c
+++ b/drivers/platform/chrome/wilco_ec/debugfs.c
@@ -144,11 +144,11 @@ static ssize_t raw_read(struct file *file, char __user *user_buf, size_t count,
 	int fmt_len = 0;
 
 	if (debug_info->response_size) {
-		fmt_len = hex_dump_to_buffer(debug_info->raw_data,
-					     debug_info->response_size,
-					     16, 1, debug_info->formatted_data,
-					     sizeof(debug_info->formatted_data),
-					     true);
+		fmt_len = hex_dump_to_buffer_ext(debug_info->raw_data,
+					debug_info->response_size,
+					16, 1, debug_info->formatted_data,
+					sizeof(debug_info->formatted_data),
+					HEXDUMP_ASCII);
 		/* Only return response the first time it is read */
 		debug_info->response_size = 0;
 	}
diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
index 39b8cc4574b4..aead28e5c4cd 100644
--- a/drivers/scsi/scsi_logging.c
+++ b/drivers/scsi/scsi_logging.c
@@ -262,7 +262,7 @@ void scsi_print_command(struct scsi_cmnd *cmd)
 						 "CDB[%02x]: ", k);
 				hex_dump_to_buffer(&cmd->cmnd[k], linelen,
 						   16, 1, logbuf + off,
-						   logbuf_len - off, false);
+						   logbuf_len - off);
 			}
 			dev_printk(KERN_INFO, &cmd->device->sdev_gendev, "%s",
 				   logbuf);
@@ -273,8 +273,7 @@ void scsi_print_command(struct scsi_cmnd *cmd)
 	if (!WARN_ON(off > logbuf_len - 49)) {
 		off += scnprintf(logbuf + off, logbuf_len - off, " ");
 		hex_dump_to_buffer(cmd->cmnd, cmd->cmd_len, 16, 1,
-				   logbuf + off, logbuf_len - off,
-				   false);
+				   logbuf + off, logbuf_len - off);
 	}
 out_printk:
 	dev_printk(KERN_INFO, &cmd->device->sdev_gendev, "%s", logbuf);
@@ -353,8 +352,7 @@ scsi_log_dump_sense(const struct scsi_device *sdev, const char *name, int tag,
 		off = sdev_format_header(logbuf, logbuf_len,
 					 name, tag);
 		hex_dump_to_buffer(&sense_buffer[i], len, 16, 1,
-				   logbuf + off, logbuf_len - off,
-				   false);
+				   logbuf + off, logbuf_len - off);
 		dev_printk(KERN_INFO, &sdev->sdev_gendev, "%s", logbuf);
 	}
 	scsi_log_release_buffer(logbuf);
diff --git a/drivers/staging/fbtft/fbtft-core.c b/drivers/staging/fbtft/fbtft-core.c
index 9b07badf4c6c..9765a7962f0c 100644
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -61,7 +61,7 @@ void fbtft_dbg_hex(const struct device *dev, int groupsize,
 	va_end(args);
 
 	hex_dump_to_buffer(buf, len, 32, groupsize, text + text_len,
-			   512 - text_len, false);
+			   512 - text_len);
 
 	if (len > 32)
 		dev_info(dev, "%s ...\n", text);
diff --git a/fs/seq_file.c b/fs/seq_file.c
index abe27ec43176..5f3d656c5ed6 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -873,8 +873,10 @@ void seq_hex_dump(struct seq_file *m, const char *prefix_str, int prefix_type,
 		}
 
 		size = seq_get_buf(m, &buffer);
-		ret = hex_dump_to_buffer(ptr + i, linelen, rowsize, groupsize,
-					 buffer, size, ascii);
+		ret = hex_dump_to_buffer_ext(ptr + i, linelen,
+					     rowsize, groupsize,
+					     buffer, size,
+					     ascii ? HEXDUMP_ASCII : 0);
 		seq_commit(m, ret < size ? ret : -1);
 
 		seq_putc(m, '\n');
diff --git a/include/linux/printk.h b/include/linux/printk.h
index c0416d0eb9e2..f0761b3a2d5d 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -483,13 +483,51 @@ enum {
 	DUMP_PREFIX_OFFSET
 };
 
-extern int hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
-			      int groupsize, char *linebuf, size_t linebuflen,
-			      bool ascii);
-
 #define HEXDUMP_ASCII			BIT(0)
 #define HEXDUMP_SUPPRESS_REPEATED	BIT(1)
 
+extern int hex_dump_to_buffer_ext(const void *buf, size_t len, int rowsize,
+			      int groupsize, char *linebuf, size_t linebuflen,
+			      u32 flags);
+
+/**
+ * hex_dump_to_buffer - convert a blob of data to "hex ASCII" in memory
+ * @buf: data blob to dump
+ * @len: number of bytes in the @buf
+ * @rowsize: number of bytes to print per line; must be a multiple of groupsize
+ * @groupsize: number of bytes to print at a time (1, 2, 4, 8; default = 1)
+ * @linebuf: where to put the converted data
+ * @linebuflen: total size of @linebuf, including space for terminating NUL
+ *
+ * hex_dump_to_buffer() works on one "line" of output at a time, converting
+ * <groupsize> bytes of input to hexadecimal (and optionally printable ASCII)
+ * until <rowsize> bytes have been emitted.
+ *
+ * Given a buffer of u8 data, hex_dump_to_buffer() converts the input data
+ * to a hex dump at the supplied memory location.
+ * The converted output is always NUL-terminated.
+ *
+ * E.g.:
+ *   hex_dump_to_buffer(frame->data, frame->len, 16, 1,
+ *			linebuf, sizeof(linebuf));
+ *
+ * example output buffer:
+ * 40 41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4f
+ *
+ * Return:
+ * The amount of bytes placed in the buffer without terminating NUL. If the
+ * output was truncated, then the return value is the number of bytes
+ * (excluding the terminating NUL) which would have been written to the final
+ * string if enough space had been available.
+ */
+static inline int hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
+			      int groupsize, char *linebuf, size_t linebuflen)
+{
+	return hex_dump_to_buffer_ext(buf, len, rowsize, groupsize,
+					linebuf, linebuflen, 0);
+}
+
+
 #ifdef CONFIG_PRINTK
 extern void print_hex_dump_ext(const char *level, const char *prefix_str,
 			   int prefix_type, int rowsize, int groupsize,
diff --git a/lib/hexdump.c b/lib/hexdump.c
index 61dc625c32f5..1bf838c1a568 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -85,7 +85,8 @@ EXPORT_SYMBOL(bin2hex);
  * @groupsize: number of bytes to print at a time (1, 2, 4, 8; default = 1)
  * @linebuf: where to put the converted data
  * @linebuflen: total size of @linebuf, including space for terminating NUL
- * @ascii: include ASCII after the hex output
+ * @flags: A bitwise OR of the following flags:
+ *	HEXDUMP_ASCII:			include ASCII after the hex output
  *
  * hex_dump_to_buffer() works on one "line" of output at a time, converting
  * <groupsize> bytes of input to hexadecimal (and optionally printable ASCII)
@@ -96,8 +97,8 @@ EXPORT_SYMBOL(bin2hex);
  * The converted output is always NUL-terminated.
  *
  * E.g.:
- *   hex_dump_to_buffer(frame->data, frame->len, 16, 1,
- *			linebuf, sizeof(linebuf), true);
+ *   hex_dump_to_buffer_ext(frame->data, frame->len, 16, 1,
+ *			linebuf, sizeof(linebuf), HEXDUMP_ASCII);
  *
  * example output buffer:
  * 40 41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4f  @ABCDEFGHIJKLMNO
@@ -108,8 +109,9 @@ EXPORT_SYMBOL(bin2hex);
  * (excluding the terminating NUL) which would have been written to the final
  * string if enough space had been available.
  */
-int hex_dump_to_buffer(const void *buf, size_t len, int rowsize, int groupsize,
-		       char *linebuf, size_t linebuflen, bool ascii)
+int hex_dump_to_buffer_ext(const void *buf, size_t len, int rowsize,
+			   int groupsize, char *linebuf, size_t linebuflen,
+			   u32 flags)
 {
 	const u8 *ptr = buf;
 	int ngroups;
@@ -187,7 +189,7 @@ int hex_dump_to_buffer(const void *buf, size_t len, int rowsize, int groupsize,
 		if (j)
 			lx--;
 	}
-	if (!ascii)
+	if (!(flags & HEXDUMP_ASCII))
 		goto nil;
 
 	while (lx < ascii_column) {
@@ -207,9 +209,10 @@ int hex_dump_to_buffer(const void *buf, size_t len, int rowsize, int groupsize,
 overflow2:
 	linebuf[lx++] = '\0';
 overflow1:
-	return ascii ? ascii_column + len : (groupsize * 2 + 1) * ngroups - 1;
+	return (flags & HEXDUMP_ASCII) ? ascii_column + len :
+					 (groupsize * 2 + 1) * ngroups - 1;
 }
-EXPORT_SYMBOL(hex_dump_to_buffer);
+EXPORT_SYMBOL(hex_dump_to_buffer_ext);
 
 #ifdef CONFIG_PRINTK
 
@@ -336,9 +339,8 @@ void print_hex_dump_ext(const char *level, const char *prefix_str,
 			skipped = 0;
 		}
 
-		hex_dump_to_buffer(ptr + i, linelen, rowsize, groupsize,
-				   linebuf, linebuf_len,
-				   flags & HEXDUMP_ASCII);
+		hex_dump_to_buffer_ext(ptr + i, linelen, rowsize, groupsize,
+				   linebuf, linebuf_len, flags);
 
 		switch (prefix_type) {
 		case DUMP_PREFIX_ADDRESS:
diff --git a/lib/test_hexdump.c b/lib/test_hexdump.c
index 5e54525a937c..ad43218437f1 100644
--- a/lib/test_hexdump.c
+++ b/lib/test_hexdump.c
@@ -165,8 +165,9 @@ static void __init test_hexdump(size_t len, int rowsize, int groupsize,
 	total_tests++;
 
 	memset(real, FILL_CHAR, sizeof(real));
-	hex_dump_to_buffer(data_b, len, rowsize, groupsize, real, sizeof(real),
-			   ascii);
+	hex_dump_to_buffer_ext(data_b, len, rowsize, groupsize,
+			       real, sizeof(real),
+			       ascii ? HEXDUMP_ASCII : 0);
 
 	memset(test, FILL_CHAR, sizeof(test));
 	test_hexdump_prepare_test(len, rowsize, groupsize, test, sizeof(test),
@@ -204,8 +205,9 @@ static void __init test_hexdump_overflow(size_t buflen, size_t len,
 
 	memset(buf, FILL_CHAR, sizeof(buf));
 
-	rc = hex_dump_to_buffer(data_b, len, rowsize, groupsize, buf, buflen,
-				ascii);
+	rc = hex_dump_to_buffer_ext(data_b, len, rowsize, groupsize,
+				    buf, buflen,
+				    ascii ? HEXDUMP_ASCII : 0);
 
 	/*
 	 * Caller must provide the data length multiple of groupsize. The
-- 
2.21.0

