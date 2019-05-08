Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 245D31744E
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 10:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfEHI4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 04:56:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:51270 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbfEHI4g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 04:56:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 01:56:35 -0700
X-ExtLoop1: 1
Received: from jnikula-mobl3.fi.intel.com (HELO localhost) ([10.237.66.150])
  by fmsmga001.fm.intel.com with ESMTP; 08 May 2019 01:56:27 -0700
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Alastair D'Silva <alastair@au1.ibm.com>, alastair@d-silva.org
Cc:     Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
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
Subject: Re: [PATCH v2 4/7] lib/hexdump.c: Replace ascii bool in hex_dump_to_buffer with flags
In-Reply-To: <20190508070148.23130-5-alastair@au1.ibm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20190508070148.23130-1-alastair@au1.ibm.com> <20190508070148.23130-5-alastair@au1.ibm.com>
Date:   Wed, 08 May 2019 11:58:34 +0300
Message-ID: <87v9yll3ut.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 08 May 2019, Alastair D'Silva <alastair@au1.ibm.com> wrote:
> From: Alastair D'Silva <alastair@d-silva.org>
>
> In order to support additional features in hex_dump_to_buffer, replace
> the ascii bool parameter with flags.
>
> Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
> ---
>  drivers/gpu/drm/i915/intel_engine_cs.c            |  2 +-

For i915,

Acked-by: Jani Nikula <jani.nikula@intel.com>

>  drivers/isdn/hardware/mISDN/mISDNisar.c           |  6 ++++--
>  drivers/mailbox/mailbox-test.c                    |  2 +-
>  drivers/net/ethernet/amd/xgbe/xgbe-drv.c          |  2 +-
>  drivers/net/ethernet/synopsys/dwc-xlgmac-common.c |  2 +-
>  drivers/net/wireless/ath/ath10k/debug.c           |  3 ++-
>  drivers/net/wireless/intel/iwlegacy/3945-mac.c    |  2 +-
>  drivers/platform/chrome/wilco_ec/debugfs.c        |  2 +-
>  drivers/scsi/scsi_logging.c                       |  8 +++-----
>  drivers/staging/fbtft/fbtft-core.c                |  2 +-
>  fs/seq_file.c                                     |  3 ++-
>  include/linux/printk.h                            |  8 ++++----
>  lib/hexdump.c                                     | 15 ++++++++-------
>  lib/test_hexdump.c                                |  5 +++--
>  14 files changed, 33 insertions(+), 29 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/intel_engine_cs.c b/drivers/gpu/drm/i915/intel_engine_cs.c
> index 49fa43ff02ba..fb133e729f9a 100644
> --- a/drivers/gpu/drm/i915/intel_engine_cs.c
> +++ b/drivers/gpu/drm/i915/intel_engine_cs.c
> @@ -1318,7 +1318,7 @@ static void hexdump(struct drm_printer *m, const void *buf, size_t len)
>  		WARN_ON_ONCE(hex_dump_to_buffer(buf + pos, len - pos,
>  						rowsize, sizeof(u32),
>  						line, sizeof(line),
> -						false) >= sizeof(line));
> +						0) >= sizeof(line));
>  		drm_printf(m, "[%04zx] %s\n", pos, line);
>  
>  		prev = buf + pos;
> diff --git a/drivers/isdn/hardware/mISDN/mISDNisar.c b/drivers/isdn/hardware/mISDN/mISDNisar.c
> index 386731ec2489..f13f34db6c17 100644
> --- a/drivers/isdn/hardware/mISDN/mISDNisar.c
> +++ b/drivers/isdn/hardware/mISDN/mISDNisar.c
> @@ -84,7 +84,8 @@ send_mbox(struct isar_hw *isar, u8 his, u8 creg, u8 len, u8 *msg)
>  
>  			while (l < (int)len) {
>  				hex_dump_to_buffer(msg + l, len - l, 32, 1,
> -						   isar->log, 256, 1);
> +						   isar->log, 256,
> +						   HEXDUMP_ASCII);
>  				pr_debug("%s: %s %02x: %s\n", isar->name,
>  					 __func__, l, isar->log);
>  				l += 32;
> @@ -113,7 +114,8 @@ rcv_mbox(struct isar_hw *isar, u8 *msg)
>  
>  			while (l < (int)isar->clsb) {
>  				hex_dump_to_buffer(msg + l, isar->clsb - l, 32,
> -						   1, isar->log, 256, 1);
> +						   1, isar->log, 256,
> +						   HEXDUMP_ASCII);
>  				pr_debug("%s: %s %02x: %s\n", isar->name,
>  					 __func__, l, isar->log);
>  				l += 32;
> diff --git a/drivers/mailbox/mailbox-test.c b/drivers/mailbox/mailbox-test.c
> index 4e4ac4be6423..2f9a094d0259 100644
> --- a/drivers/mailbox/mailbox-test.c
> +++ b/drivers/mailbox/mailbox-test.c
> @@ -213,7 +213,7 @@ static ssize_t mbox_test_message_read(struct file *filp, char __user *userbuf,
>  		hex_dump_to_buffer(ptr,
>  				   MBOX_BYTES_PER_LINE,
>  				   MBOX_BYTES_PER_LINE, 1, touser + l,
> -				   MBOX_HEXDUMP_LINE_LEN, true);
> +				   MBOX_HEXDUMP_LINE_LEN, HEXDUMP_ASCII);
>  
>  		ptr += MBOX_BYTES_PER_LINE;
>  		l += MBOX_HEXDUMP_LINE_LEN;
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
> index 0cc911f928b1..e954a31cee0c 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
> @@ -2992,7 +2992,7 @@ void xgbe_print_pkt(struct net_device *netdev, struct sk_buff *skb, bool tx_rx)
>  		unsigned int len = min(skb->len - i, 32U);
>  
>  		hex_dump_to_buffer(&skb->data[i], len, 32, 1,
> -				   buffer, sizeof(buffer), false);
> +				   buffer, sizeof(buffer), 0);
>  		netdev_dbg(netdev, "  %#06x: %s\n", i, buffer);
>  	}
>  
> diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
> index eb1c6b03c329..b80adfa1f890 100644
> --- a/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
> +++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
> @@ -349,7 +349,7 @@ void xlgmac_print_pkt(struct net_device *netdev,
>  		unsigned int len = min(skb->len - i, 32U);
>  
>  		hex_dump_to_buffer(&skb->data[i], len, 32, 1,
> -				   buffer, sizeof(buffer), false);
> +				   buffer, sizeof(buffer), 0);
>  		netdev_dbg(netdev, "  %#06x: %s\n", i, buffer);
>  	}
>  
> diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
> index 32d967a31c65..4c99ea03226d 100644
> --- a/drivers/net/wireless/ath/ath10k/debug.c
> +++ b/drivers/net/wireless/ath/ath10k/debug.c
> @@ -2662,7 +2662,8 @@ void ath10k_dbg_dump(struct ath10k *ar,
>  						(unsigned int)(ptr - buf));
>  			hex_dump_to_buffer(ptr, len - (ptr - buf), 16, 1,
>  					   linebuf + linebuflen,
> -					   sizeof(linebuf) - linebuflen, true);
> +					   sizeof(linebuf) - linebuflen,
> +					   HEXDUMP_ASCII);
>  			dev_printk(KERN_DEBUG, ar->dev, "%s\n", linebuf);
>  		}
>  	}
> diff --git a/drivers/net/wireless/intel/iwlegacy/3945-mac.c b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
> index 271977f7fbb0..acbe26d22c34 100644
> --- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
> +++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
> @@ -3247,7 +3247,7 @@ il3945_show_measurement(struct device *d, struct device_attribute *attr,
>  
>  	while (size && PAGE_SIZE - len) {
>  		hex_dump_to_buffer(data + ofs, size, 16, 1, buf + len,
> -				   PAGE_SIZE - len, true);
> +				   PAGE_SIZE - len, HEXDUMP_ASCII);
>  		len = strlen(buf);
>  		if (PAGE_SIZE - len)
>  			buf[len++] = '\n';
> diff --git a/drivers/platform/chrome/wilco_ec/debugfs.c b/drivers/platform/chrome/wilco_ec/debugfs.c
> index c090db2cd5be..26d9ae5c2dc2 100644
> --- a/drivers/platform/chrome/wilco_ec/debugfs.c
> +++ b/drivers/platform/chrome/wilco_ec/debugfs.c
> @@ -174,7 +174,7 @@ static ssize_t raw_read(struct file *file, char __user *user_buf, size_t count,
>  		fmt_len = hex_dump_to_buffer(debug_info->raw_data,
>  					     debug_info->response_size,
>  					     16, 1, debug_info->formatted_data,
> -					     FORMATTED_BUFFER_SIZE, true);
> +					     FORMATTED_BUFFER_SIZE, HEXDUMP_ASCII);
>  		/* Only return response the first time it is read */
>  		debug_info->response_size = 0;
>  	}
> diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
> index bd70339c1242..fce542bb40e6 100644
> --- a/drivers/scsi/scsi_logging.c
> +++ b/drivers/scsi/scsi_logging.c
> @@ -263,7 +263,7 @@ void scsi_print_command(struct scsi_cmnd *cmd)
>  						 "CDB[%02x]: ", k);
>  				hex_dump_to_buffer(&cmd->cmnd[k], linelen,
>  						   16, 1, logbuf + off,
> -						   logbuf_len - off, false);
> +						   logbuf_len - off, 0);
>  			}
>  			dev_printk(KERN_INFO, &cmd->device->sdev_gendev, "%s",
>  				   logbuf);
> @@ -274,8 +274,7 @@ void scsi_print_command(struct scsi_cmnd *cmd)
>  	if (!WARN_ON(off > logbuf_len - 49)) {
>  		off += scnprintf(logbuf + off, logbuf_len - off, " ");
>  		hex_dump_to_buffer(cmd->cmnd, cmd->cmd_len, 16, 1,
> -				   logbuf + off, logbuf_len - off,
> -				   false);
> +				   logbuf + off, logbuf_len - off, 0);
>  	}
>  out_printk:
>  	dev_printk(KERN_INFO, &cmd->device->sdev_gendev, "%s", logbuf);
> @@ -354,8 +353,7 @@ scsi_log_dump_sense(const struct scsi_device *sdev, const char *name, int tag,
>  		off = sdev_format_header(logbuf, logbuf_len,
>  					 name, tag);
>  		hex_dump_to_buffer(&sense_buffer[i], len, 16, 1,
> -				   logbuf + off, logbuf_len - off,
> -				   false);
> +				   logbuf + off, logbuf_len - off, 0);
>  		dev_printk(KERN_INFO, &sdev->sdev_gendev, "%s", logbuf);
>  	}
>  	scsi_log_release_buffer(logbuf);
> diff --git a/drivers/staging/fbtft/fbtft-core.c b/drivers/staging/fbtft/fbtft-core.c
> index 9b07badf4c6c..2e5df5cc9d61 100644
> --- a/drivers/staging/fbtft/fbtft-core.c
> +++ b/drivers/staging/fbtft/fbtft-core.c
> @@ -61,7 +61,7 @@ void fbtft_dbg_hex(const struct device *dev, int groupsize,
>  	va_end(args);
>  
>  	hex_dump_to_buffer(buf, len, 32, groupsize, text + text_len,
> -			   512 - text_len, false);
> +			   512 - text_len, 0);
>  
>  	if (len > 32)
>  		dev_info(dev, "%s ...\n", text);
> diff --git a/fs/seq_file.c b/fs/seq_file.c
> index 1dea7a8a5255..a0213637af3e 100644
> --- a/fs/seq_file.c
> +++ b/fs/seq_file.c
> @@ -873,7 +873,8 @@ void seq_hex_dump(struct seq_file *m, const char *prefix_str, int prefix_type,
>  
>  		size = seq_get_buf(m, &buffer);
>  		ret = hex_dump_to_buffer(ptr + i, linelen, rowsize, groupsize,
> -					 buffer, size, ascii);
> +					 buffer, size,
> +					 ascii ? HEXDUMP_ASCII : 0);
>  		seq_commit(m, ret < size ? ret : -1);
>  
>  		seq_putc(m, '\n');
> diff --git a/include/linux/printk.h b/include/linux/printk.h
> index 938a67580d78..00a82e468643 100644
> --- a/include/linux/printk.h
> +++ b/include/linux/printk.h
> @@ -480,13 +480,13 @@ enum {
>  	DUMP_PREFIX_OFFSET
>  };
>  
> -extern int hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
> -			      int groupsize, char *linebuf, size_t linebuflen,
> -			      bool ascii);
> -
>  #define HEXDUMP_ASCII			(1 << 0)
>  #define HEXDUMP_SUPPRESS_REPEATED	(1 << 1)
>  
> +extern int hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
> +			      int groupsize, char *linebuf, size_t linebuflen,
> +			      u64 flags);
> +
>  #ifdef CONFIG_PRINTK
>  extern void print_hex_dump_ext(const char *level, const char *prefix_str,
>  			   int prefix_type, int rowsize, int groupsize,
> diff --git a/lib/hexdump.c b/lib/hexdump.c
> index d61a1e4f19fa..ddd1697e5f9b 100644
> --- a/lib/hexdump.c
> +++ b/lib/hexdump.c
> @@ -85,7 +85,8 @@ EXPORT_SYMBOL(bin2hex);
>   * @groupsize: number of bytes to print at a time (1, 2, 4, 8; default = 1)
>   * @linebuf: where to put the converted data
>   * @linebuflen: total size of @linebuf, including space for terminating NUL
> - * @ascii: include ASCII after the hex output
> + * @flags: A bitwise OR of the following flags:
> + *	HEXDUMP_ASCII:			include ASCII after the hex output
>   *
>   * hex_dump_to_buffer() works on one "line" of output at a time, converting
>   * <groupsize> bytes of input to hexadecimal (and optionally printable ASCII)
> @@ -97,7 +98,7 @@ EXPORT_SYMBOL(bin2hex);
>   *
>   * E.g.:
>   *   hex_dump_to_buffer(frame->data, frame->len, 16, 1,
> - *			linebuf, sizeof(linebuf), true);
> + *			linebuf, sizeof(linebuf), HEXDUMP_ASCII);
>   *
>   * example output buffer:
>   * 40 41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4f  @ABCDEFGHIJKLMNO
> @@ -109,7 +110,7 @@ EXPORT_SYMBOL(bin2hex);
>   * string if enough space had been available.
>   */
>  int hex_dump_to_buffer(const void *buf, size_t len, int rowsize, int groupsize,
> -		       char *linebuf, size_t linebuflen, bool ascii)
> +		       char *linebuf, size_t linebuflen, u64 flags)
>  {
>  	const u8 *ptr = buf;
>  	int ngroups;
> @@ -187,7 +188,7 @@ int hex_dump_to_buffer(const void *buf, size_t len, int rowsize, int groupsize,
>  		if (j)
>  			lx--;
>  	}
> -	if (!ascii)
> +	if (!(flags & HEXDUMP_ASCII))
>  		goto nil;
>  
>  	while (lx < ascii_column) {
> @@ -207,7 +208,8 @@ int hex_dump_to_buffer(const void *buf, size_t len, int rowsize, int groupsize,
>  overflow2:
>  	linebuf[lx++] = '\0';
>  overflow1:
> -	return ascii ? ascii_column + len : (groupsize * 2 + 1) * ngroups - 1;
> +	return (flags & HEXDUMP_ASCII) ? ascii_column + len :
> +					 (groupsize * 2 + 1) * ngroups - 1;
>  }
>  EXPORT_SYMBOL(hex_dump_to_buffer);
>  
> @@ -336,8 +338,7 @@ void print_hex_dump_ext(const char *level, const char *prefix_str,
>  		}
>  
>  		hex_dump_to_buffer(ptr + i, linelen, rowsize, groupsize,
> -				   linebuf, linebuf_len,
> -				   flags & HEXDUMP_ASCII);
> +				   linebuf, linebuf_len, flags);
>  
>  		switch (prefix_type) {
>  		case DUMP_PREFIX_ADDRESS:
> diff --git a/lib/test_hexdump.c b/lib/test_hexdump.c
> index 6ab75a209b43..ae340c5c1c6f 100644
> --- a/lib/test_hexdump.c
> +++ b/lib/test_hexdump.c
> @@ -166,7 +166,7 @@ static void __init test_hexdump(size_t len, int rowsize, int groupsize,
>  
>  	memset(real, FILL_CHAR, sizeof(real));
>  	hex_dump_to_buffer(data_b, len, rowsize, groupsize, real, sizeof(real),
> -			   ascii);
> +			   ascii ? HEXDUMP_ASCII : 0);
>  
>  	memset(test, FILL_CHAR, sizeof(test));
>  	test_hexdump_prepare_test(len, rowsize, groupsize, test, sizeof(test),
> @@ -204,7 +204,8 @@ static void __init test_hexdump_overflow(size_t buflen, size_t len,
>  
>  	memset(buf, FILL_CHAR, sizeof(buf));
>  
> -	rc = hex_dump_to_buffer(data_b, len, rowsize, groupsize, buf, buflen, ascii);
> +	rc = hex_dump_to_buffer(data_b, len, rowsize, groupsize, buf, buflen,
> +				ascii ? HEXDUMP_ASCII : 0);
>  
>  	/*
>  	 * Caller must provide the data length multiple of groupsize. The

-- 
Jani Nikula, Intel Open Source Graphics Center
