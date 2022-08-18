Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22B71598617
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 16:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343633AbiHROef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 10:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343542AbiHROd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 10:33:57 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8948237DB
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 07:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660833221; x=1692369221;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=65V/BdZVZ8zojImbAOXOkdCE5OBUmP1lpFDgHs0EPy8=;
  b=ZJc8sVqUzVxeQTZAQfvkePJCgY1LPGg3yk5S8BFBUnA2ErC8WIzk9h3d
   2Onk0yQEZpuf/9dsOB/5Bc14MOvOEjbOVrJ7SEJq1tCrw2LVVhAdH39cc
   oyex4gLNkooqiOVS16RoS7+GOrNMWI6KYW/e6mOgGS+romzMPYwa1stqY
   bQ020kH9zekf1uy31KqNyukVSbyZ0DhN+4o8sWSYylynBxli00gnfpmRb
   NVTstbjEivSRGGdS1yUfo52TOXqOtvJQckQpoXgNv+nvaT6/6NALGEHHx
   MFtRCIEiOt/SLMpYLzSKvC22VgAvtb5R1k21Fw/KtJatFDGlPW+1Rdm0/
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="275818472"
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="275818472"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 07:33:36 -0700
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="668126008"
Received: from dursu-mobl1.ger.corp.intel.com ([10.249.42.244])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 07:33:33 -0700
Date:   Thu, 18 Aug 2022 17:33:31 +0300 (EEST)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     m.chetan.kumar@intel.com
cc:     Netdev <netdev@vger.kernel.org>, kuba@kernel.org,
        davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@linux.intel.com,
        linuxwwan@intel.com,
        Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>,
        Mishra Soumya Prakash <soumya.prakash.mishra@intel.com>
Subject: Re: [PATCH net-next 4/5] net: wwan: t7xx: Enable devlink based fw
 flashing and coredump collection
In-Reply-To: <20220816042405.2416972-1-m.chetan.kumar@intel.com>
Message-ID: <487238cc-4bdf-b5aa-cedb-61ed1a299f41@linux.intel.com>
References: <20220816042405.2416972-1-m.chetan.kumar@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Aug 2022, m.chetan.kumar@intel.com wrote:

> From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> 
> This patch brings-in support for t7xx wwan device firmware flashing &

Just say "Add support for ..."

> coredump collection using devlink.
>
> Driver Registers with Devlink framework.
> Implements devlink ops flash_update callback that programs modem firmware.
> Creates region & snapshot required for device coredump log collection.
> On early detection of wwan device in fastboot mode driver sets up CLDMA0 HW
> tx/rx queues for raw data transfer then registers with devlink framework.
> Upon receiving firmware image & partition details driver sends fastboot
> commands for flashing the firmware.

Things don't seem to connect well between sentences in this paragraph.

> In this flow the fastboot command & response gets exchanged between driver
> and device. Once firmware flashing is success completion status is reported
> to user space application.
> 
> Below is the devlink command usage for firmware flashing
> 
> $devlink dev flash pci/$BDF file ABC.img component ABC
> 
> Note: ABC.img is the firmware to be programmed to "ABC" partition.
> 
> In case of coredump collection when wwan device encounters an exception
> it reboots & stays in fastboot mode for coredump collection by host driver.
> On detecting exception state driver collects the core dump, creates the
> devlink region & reports an event to user space application for dump
> collection. The user space application invokes devlink region read command
> for dump collection.
> 
> Below are the devlink commands used for coredump collection.
> 
> devlink region new pci/$BDF/mr_dump
> devlink region read pci/$BDF/mr_dump snapshot $ID address $ADD length $LEN
> devlink region del pci/$BDF/mr_dump snapshot $ID
> 
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> Signed-off-by: Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
> Signed-off-by: Mishra Soumya Prakash <soumya.prakash.mishra@intel.com>
> ---

> +static int t7xx_devlink_port_read(struct t7xx_port *port, char *buf, size_t count)
> +{
> +	int ret = 0, read_len;
> +	struct sk_buff *skb;
> +
> +	spin_lock_irq(&port->rx_wq.lock);
> +	if (skb_queue_empty(&port->rx_skb_list)) {
> +		ret = wait_event_interruptible_locked_irq(port->rx_wq,
> +							  !skb_queue_empty(&port->rx_skb_list));
> +		if (ret == -ERESTARTSYS) {
> +			spin_unlock_irq(&port->rx_wq.lock);
> +			return -EINTR;
> +		}
> +	}
> +	skb = skb_dequeue(&port->rx_skb_list);
> +	spin_unlock_irq(&port->rx_wq.lock);
> +
> +	read_len = count > skb->len ? skb->len : count;

max_t()

> +	memcpy(buf, skb->data, read_len);
> +	dev_kfree_skb(skb);
> +
> +	return ret ? ret : read_len;

Can ret actually be non-zero here since -ERESTARTSYS is covered above?

> +}
> +
> +static int t7xx_devlink_port_write(struct t7xx_port *port, const char *buf, size_t count)
> +{
> +	const struct t7xx_port_conf *port_conf = port->port_conf;
> +	size_t actual_count;
> +	struct sk_buff *skb;
> +	int ret, txq_mtu;
> +
> +	txq_mtu = t7xx_get_port_mtu(port);
> +	if (txq_mtu < 0)
> +		return -EINVAL;
> +
> +	actual_count = count > txq_mtu ? txq_mtu : count;

max_t()

> +	skb = __dev_alloc_skb(actual_count, GFP_KERNEL);
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	skb_put_data(skb, buf, actual_count);
> +	ret = t7xx_port_send_raw_skb(port, skb);
> +	if (ret) {
> +		dev_err(port->dev, "write error on %s, size: %zu, ret: %d\n",
> +			port_conf->name, actual_count, ret);
> +		dev_kfree_skb(skb);
> +		return ret;
> +	}
> +
> +	return actual_count;
> +}
> +
> +static int t7xx_devlink_fb_handle_response(struct t7xx_port *port, int *data)
> +{
> +	int ret = 0, index = 0, return_data = 0, read_bytes;

I'd move return_data declaration into block where it is used. I don't 
think it needs to be initialized or does the compiler complain about it?


> +	char status[T7XX_FB_RESPONSE_SIZE + 1];
> +
> +	while (index < T7XX_FB_RESP_COUNT) {
> +		index++;

for (index = 0; index < T7XX_FB_RESP_COUNT; index++) {

> +		read_bytes = t7xx_devlink_port_read(port, status, T7XX_FB_RESPONSE_SIZE);
> +		if (read_bytes < 0) {
> +			dev_err(port->dev, "status read failed");

Printing "read failed" for -ERESTARTSYS/-EINTR??

> +static int t7xx_devlink_fb_download(struct t7xx_port *port, const u8 *buf, size_t size)
> +{
> +	int ret;
> +
> +	if (size <= 0 || size > SIZE_MAX) {
> +		dev_err(port->dev, "file is too large to download");
> +		return -EINVAL;

The if condition is effectively if (!size) because unsigned cannot be <0 
nor can size_t be > (~(size_t)0). Given that, the error message is pretty 
bogus. I'd tend to think returning just -EINVAL in case of !size w/o any 
printingis sufficient here.

> +static int t7xx_devlink_fb_get_core(struct t7xx_port *port)
> +{
> +	struct t7xx_devlink_region_info *mrdump_region;
> +	char mrdump_complete_event[T7XX_FB_EVENT_SIZE];
> +	u32 mrd_mb = T7XX_MRDUMP_SIZE / (1024 * 1024);
> +	struct t7xx_devlink *dl = port->dl;
> +	int clen, dlen = 0, result = 0;

No need to init dlen.

> +	unsigned long long zipsize = 0;
> +	char mcmd[T7XX_FB_MCMD_SIZE];
> +	size_t offset_dlen = 0;
> +	char *mdata;
> +
> +	set_bit(T7XX_MRDUMP_STATUS, &dl->status);
> +	mdata = kmalloc(T7XX_FB_MDATA_SIZE, GFP_KERNEL);
> +	if (!mdata) {
> +		result = -ENOMEM;
> +		goto get_core_exit;
> +	}
> +
> +	mrdump_region = dl->dl_region_info[T7XX_MRDUMP_INDEX];
> +	mrdump_region->dump = vmalloc(mrdump_region->default_size);
> +	if (!mrdump_region->dump) {
> +		kfree(mdata);
> +		result = -ENOMEM;
> +		goto get_core_exit;
> +	}

Error handling/cleanup paths need to be cleaned up here.

> +	result = t7xx_devlink_fb_raw_command(T7XX_FB_CMD_OEM_MRDUMP, port, NULL);
> +	if (result) {
> +		dev_err(port->dev, "%s command failed\n", T7XX_FB_CMD_OEM_MRDUMP);
> +		vfree(mrdump_region->dump);
> +		kfree(mdata);
> +		goto get_core_exit;
> +	}

Ditto.

> +	while (mrdump_region->default_size > offset_dlen) {
> +		clen = t7xx_devlink_port_read(port, mcmd, sizeof(mcmd));
> +		if (clen == strlen(T7XX_FB_CMD_RTS) &&
> +		    (!strncmp(mcmd, T7XX_FB_CMD_RTS, strlen(T7XX_FB_CMD_RTS)))) {
> +			memset(mdata, 0, T7XX_FB_MDATA_SIZE);
> +			dlen = 0;

Unnecessary assignment.

> +			memset(mcmd, 0, sizeof(mcmd));
> +			clen = snprintf(mcmd, sizeof(mcmd), "%s", T7XX_FB_CMD_CTS);
> +
> +			if (t7xx_devlink_port_write(port, mcmd, clen) != clen) {
> +				dev_err(port->dev, "write for _CTS failed:%d\n", clen);
> +				goto get_core_free_mem;
> +			}
> +
> +			dlen = t7xx_devlink_port_read(port, mdata, T7XX_FB_MDATA_SIZE);
> +			if (dlen <= 0) {
> +				dev_err(port->dev, "read data error(%d)\n", dlen);
> +				goto get_core_free_mem;
> +			}
> +
> +			zipsize += (unsigned long long)(dlen);
> +			memcpy(mrdump_region->dump + offset_dlen, mdata, dlen);
> +			offset_dlen += dlen;

Why both offset_dlen and zipsize???

> +			memset(mcmd, 0, sizeof(mcmd));
> +			clen = snprintf(mcmd, sizeof(mcmd), "%s", T7XX_FB_CMD_FIN);
> +			if (t7xx_devlink_port_write(port, mcmd, clen) != clen) {
> +				dev_err(port->dev, "%s: _FIN failed, (Read %05d:%05llu)\n",
> +					__func__, clen, zipsize);

Printing __func__ probably isn't that helpful here.

> +				goto get_core_free_mem;
> +			}
> +		} else if ((clen == strlen(T7XX_FB_RESP_MRDUMP_DONE)) &&
> +			  (!strncmp(mcmd, T7XX_FB_RESP_MRDUMP_DONE,
> +				    strlen(T7XX_FB_RESP_MRDUMP_DONE)))) {

strcmp()

> +			dev_dbg(port->dev, "%s! size:%zd\n", T7XX_FB_RESP_MRDUMP_DONE, offset_dlen);
> +			mrdump_region->actual_size = offset_dlen;
> +			snprintf(mrdump_complete_event, sizeof(mrdump_complete_event),
> +				 "%s size=%zu", T7XX_UEVENT_MRDUMP_READY, offset_dlen);
> +			t7xx_uevent_send(dl->dev, mrdump_complete_event);
> +			kfree(mdata);
> +			result = 0;
> +			goto get_core_exit;
> +		} else {
> +			dev_err(port->dev, "getcore protocol error (read len %05d)\n", clen);
> +			goto get_core_free_mem;
> +		}
> +	}
> +
> +	dev_err(port->dev, "mrdump exceeds %uMB size. Discarded!", mrd_mb);
> +	t7xx_uevent_send(port->dev, T7XX_UEVENT_MRD_DISCD);
> +
> +get_core_free_mem:
> +	kfree(mdata);
> +	vfree(mrdump_region->dump);
> +	clear_bit(T7XX_MRDUMP_STATUS, &dl->status);
> +	return -EPROTO;
> +
> +get_core_exit:
> +	clear_bit(T7XX_MRDUMP_STATUS, &dl->status);
> +	return result;

Error handling/cleanup paths need to be cleaned up here.

> +}
> +
> +static int t7xx_devlink_fb_dump_log(struct t7xx_port *port)
> +{
> +	struct t7xx_devlink_region_info *lkdump_region;
> +	char lkdump_complete_event[T7XX_FB_EVENT_SIZE];
> +	struct t7xx_devlink *dl = port->dl;
> +	int dlen, datasize = 0, result;
> +	size_t offset_dlen = 0;
> +	u8 *data;
> +
> +	set_bit(T7XX_LKDUMP_STATUS, &dl->status);
> +	result = t7xx_devlink_fb_raw_command(T7XX_FB_CMD_OEM_LKDUMP, port, &datasize);
> +	if (result) {
> +		dev_err(port->dev, "%s command returns failure\n", T7XX_FB_CMD_OEM_LKDUMP);
> +		goto lkdump_exit;
> +	}
> +
> +	lkdump_region = dl->dl_region_info[T7XX_LKDUMP_INDEX];
> +	if (datasize > lkdump_region->default_size) {
> +		dev_err(port->dev, "lkdump size is more than %dKB. Discarded!",
> +			T7XX_LKDUMP_SIZE / 1024);
> +		t7xx_uevent_send(dl->dev, T7XX_UEVENT_LKD_DISCD);
> +		result = -EPROTO;
> +		goto lkdump_exit;
> +	}
> +
> +	data = kzalloc(datasize, GFP_KERNEL);
> +	if (!data) {
> +		result = -ENOMEM;
> +		goto lkdump_exit;
> +	}
> +
> +	lkdump_region->dump = vmalloc(lkdump_region->default_size);
> +	if (!lkdump_region->dump) {
> +		kfree(data);
> +		result = -ENOMEM;
> +		goto lkdump_exit;

Ditto.

> +	}
> +
> +	while (datasize > 0) {
> +		dlen = t7xx_devlink_port_read(port, data, datasize);
> +		if (dlen <= 0) {
> +			dev_err(port->dev, "lkdump read error ret = %d", dlen);
> +			kfree(data);
> +			result = -EPROTO;
> +			goto lkdump_exit;

Ditto.

> +		}
> +
> +		memcpy(lkdump_region->dump + offset_dlen, data, dlen);
> +		datasize -= dlen;
> +		offset_dlen += dlen;
> +	}
> +
> +	dev_dbg(port->dev, "LKDUMP DONE! size:%zd\n", offset_dlen);
> +	lkdump_region->actual_size = offset_dlen;
> +	snprintf(lkdump_complete_event, sizeof(lkdump_complete_event), "%s size=%zu",
> +		 T7XX_UEVENT_LKDUMP_READY, offset_dlen);
> +	t7xx_uevent_send(dl->dev, lkdump_complete_event);
> +	kfree(data);
> +	clear_bit(T7XX_LKDUMP_STATUS, &dl->status);
> +	return t7xx_devlink_fb_handle_response(port, NULL);
> +
> +lkdump_exit:
> +	clear_bit(T7XX_LKDUMP_STATUS, &dl->status);
> +	return result;
> +}


> +/* To create regions for dump files */
> +static int t7xx_devlink_create_region(struct t7xx_devlink *dl)
> +{
> +	struct devlink_region_ops *region_ops;
> +	int rc, i;
> +
> +	region_ops = dl->dl_region_ops;
> +	for (i = 0; i < T7XX_TOTAL_REGIONS; i++) {

Perhaps this is a matter of taste thing but I'd use
ARRAY_SIZE(t7xx_devlink_region_list).

> +		region_ops[i].name = t7xx_devlink_region_list[i].region_name;
> +		region_ops[i].snapshot = t7xx_devlink_region_snapshot;
> +		region_ops[i].destructor = vfree;
> +		dl->dl_region[i] =
> +		devlink_region_create(dl->dl_ctx, &region_ops[i], T7XX_MAX_SNAPSHOTS,
> +				      t7xx_devlink_region_list[i].default_size);

Indentation.

> +		if (IS_ERR(dl->dl_region[i])) {
> +			rc = PTR_ERR(dl->dl_region[i]);
> +			dev_err(dl->dev, "devlink region fail,err %d", rc);

Please fix message formatting.

> +	rc = t7xx_devlink_create_region(dl);
> +	if (rc) {
> +		dev_err(dl->dev, "devlink region creation failed, rc %d", rc);

Since this is user visible error, "rc" should be replaced with something
meaningful.


> +static int t7xx_devlink_init(struct t7xx_port *port)
> +{
> +	struct t7xx_devlink_work *dl_work;
> +	struct workqueue_struct *wq;
> +
> +	dl_work = kmalloc(sizeof(*dl_work), GFP_KERNEL);
> +	if (!dl_work)
> +		return -ENOMEM;
> +
> +	wq = create_workqueue("t7xx_devlink");
> +	if (!wq) {
> +		kfree(dl_work);
> +		dev_err(port->dev, "create_workqueue failed\n");
> +		return -ENODATA;
> +	}
> +
> +	INIT_WORK(&dl_work->work, t7xx_devlink_work_handler);
> +	dl_work->port = port;
> +	port->rx_length_th = T7XX_MAX_QUEUE_LENGTH;
> +
> +	if (!t7xx_devlink_region_init(port, dl_work, wq))
> +		return -ENOMEM;

Leaks?

> +static int t7xx_devlink_disable_chl(struct t7xx_port *port)
> +{
> +	spin_lock(&port->port_update_lock);
> +	port->chan_enable = false;
> +	spin_unlock(&port->port_update_lock);
> +
> +	return 0;
> +}

This is identical to t7xx_port_wwan_disable_chl().

> +struct t7xx_devlink_region_info {
> +	char region_name[T7XX_MAX_REGION_NAME_LENGTH];
> +	u32 default_size;
> +	u32 actual_size;
> +	u32 entry;

entry seems pretty useless, used only to show an index within a debug 
message.

> diff --git a/drivers/net/wwan/t7xx/t7xx_reg.h b/drivers/net/wwan/t7xx/t7xx_reg.h
> index 60e025e57baa..3a758bf79a4e 100644
> --- a/drivers/net/wwan/t7xx/t7xx_reg.h
> +++ b/drivers/net/wwan/t7xx/t7xx_reg.h
> @@ -101,11 +101,17 @@ enum t7xx_pm_resume_state {
>  	PM_RESUME_REG_STATE_L2_EXP,
>  };
>  
> +enum host_event_e {
> +	HOST_EVENT_INIT = 0,
> +	FASTBOOT_DL_NOTY = 0x3,

NOTIFY?


-- 
 i.

