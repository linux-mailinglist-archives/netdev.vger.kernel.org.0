Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C333CF9B77
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 22:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbfKLVKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 16:10:06 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:35406 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbfKLVKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 16:10:06 -0500
Received: by mail-lf1-f65.google.com with SMTP id i26so46390lfl.2
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 13:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xaHm01Sgg+TKPReDuFBWMTQnmQVu06TwBTTnsDd49Ys=;
        b=SeoqtIZz02aNI53JBKDvu5N2QIW3m15S4CitXEBHcS0KnZI3ju8yxRqUmGPPQTSjyM
         lRqB5qkM9zGjzRpYuQPU+mtlWmifZ0JUiH0Ss7v8Q9QoXARwF7hDdeo12SJ78G1KDW5v
         78Hry4BBkJc8XSWvYLyewaCkz6ZBXe5AWgCvEZir34kput1Iffw40VbNh8seNqBzWlQ8
         mtFaz81WCenlaQo4z/P+2yra6nCgEg/tmime4U7e4T11XgR6jSsrLHbOrhY2S4+K6qGI
         jWFcoAz7kRCUUfOLD00Ee7JazAmJIoJtAThNYV9JnvP6I0ak/JV1u2Rg7b5MGjldtmeR
         MMcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=xaHm01Sgg+TKPReDuFBWMTQnmQVu06TwBTTnsDd49Ys=;
        b=CgiitmpAHYf/CP8vG2fH7ui/Ira8RHZFPiOMIGiLbV+FptndnnwwYtUoEgfwn6gzpx
         C4T0jj5xpvduGT1NYD77MokQSg0AGW5xVsc5MhkrJLEQWmv5p6NNTsjwVYwvp0hkNXnd
         So5/SQt6sgv2F8g/9XsdYXcRe3yREKo2HUOPJRICV937jmoOGMTpvMLuTRWhl8hAAyK7
         Tjkn9vAAIXb2zDd2YhmvF+RjGI03VwjclMvppm0zGZznDQNoH+Tr2kns7C2I+ZPsS3Fe
         mrYnFYlULkTJY5jLzYeHSfoeTbu6ajoTJDSm9iICznWSgcEciK2yCeCmlZuSQedq6L41
         ww9Q==
X-Gm-Message-State: APjAAAXyjBWtkSaTkaGMOfv+75WGwGTwGcBTbWLDKPwJhkoMhqvAeGIh
        84ANlH+YWSVSF8FPy8TaVoQRbQ==
X-Google-Smtp-Source: APXvYqwGwZ3JUtEc0LD6ZZ5dwCWu23zzogEmNHnp0Dm+uMfJtbQqih1tnAFa541+TryXKTw6TLEnkg==
X-Received: by 2002:a19:7508:: with SMTP id y8mr2436184lfe.38.1573593002812;
        Tue, 12 Nov 2019 13:10:02 -0800 (PST)
Received: from khorivan (57-201-94-178.pool.ukrtel.net. [178.94.201.57])
        by smtp.gmail.com with ESMTPSA id z17sm8754503ljm.16.2019.11.12.13.10.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 13:10:02 -0800 (PST)
Date:   Tue, 12 Nov 2019 23:10:00 +0200
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Po Liu <po.liu@nxp.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
Subject: Re: [v2,net-next, 1/2] enetc: Configure the Time-Aware Scheduler via
 tc-taprio offload
Message-ID: <20191112210958.GB1833@khorivan>
Mail-Followup-To: Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
References: <20191111042715.13444-2-Po.Liu@nxp.com>
 <20191112082823.28998-1-Po.Liu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191112082823.28998-1-Po.Liu@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, Nov 12, 2019 at 08:42:49AM +0000, Po Liu wrote:
>ENETC supports in hardware for time-based egress shaping according
>to IEEE 802.1Qbv. This patch implement the Qbv enablement by the
>hardware offload method qdisc tc-taprio method.
>Also update cbdr writeback to up level since control bd ring may
>writeback data to control bd ring.
>
>Signed-off-by: Po Liu <Po.Liu@nxp.com>
>Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
>---
>changes:
>- introduce a local define CONFIG_FSL_ENETC_QOS to fix the various
>  configurations will result in link errors.
>  Since the CONFIG_NET_SCH_TAPRIO depends on many Qos configs. Not
>  to use it directly in driver. Add it to CONFIG_FSL_ENETC_QOS depends
>  on list, so only CONFIG_NET_SCH_TAPRIO enabled, user can enable this
>  tsn feature, or else, return not support.
>
> drivers/net/ethernet/freescale/enetc/Kconfig  |  10 ++
> drivers/net/ethernet/freescale/enetc/Makefile |   1 +
> drivers/net/ethernet/freescale/enetc/enetc.c  |  19 ++-
> drivers/net/ethernet/freescale/enetc/enetc.h  |   7 +
> .../net/ethernet/freescale/enetc/enetc_cbdr.c |   5 +-
> .../net/ethernet/freescale/enetc/enetc_hw.h   | 150 ++++++++++++++++--
> .../net/ethernet/freescale/enetc/enetc_qos.c  | 130 +++++++++++++++
> 7 files changed, 300 insertions(+), 22 deletions(-)
> create mode 100644 drivers/net/ethernet/freescale/enetc/enetc_qos.c
>

[...]

>
>@@ -1483,6 +1479,19 @@ int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
> 	return 0;
> }
>
>+int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
>+		   void *type_data)
>+{
>+	switch (type) {
>+	case TC_SETUP_QDISC_MQPRIO:
>+		return enetc_setup_tc_mqprio(ndev, type_data);
Sorry didn't see v2, so i duplicate my question here:

This patch is for taprio offload, I see that mqprio is related and is part of
taprio offload configuration. But taprio offload has own mqprio settings.
The taprio mqprio part is not offloaded with TC_SETUP_QDISC_MQPRIO.

So, a combination of mqprio and tario qdiscs used.
Could you please share the commands were used for your setup?

And couple interesting questions about all of this:
- The taprio qdisc has to have mqprio settings, but if it's done with
mqprio then it just skipped (by reading tc class num).
- If no separate mqprio qdisc configuration then mqprio conf from taprio
is set, who should restore tc mappings when taprio qdisc is unloaded?
Maybe there is reason to implement TC_SETUP_QDISC_MQPRIO offload in taprio
since it's required feature?

Would be better to move changes for mqprio in separate patch with explanation.

>+	case TC_SETUP_QDISC_TAPRIO:
>+		return enetc_setup_tc_taprio(ndev, type_data);
>+	default:
>+		return -EOPNOTSUPP;
>+	}
>+}
>+

[...]

>diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
>new file mode 100644
>index 000000000000..036bb39c7a0b
>--- /dev/null
>+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c

[...]

>+static int enetc_setup_taprio(struct net_device *ndev,
>+			      struct tc_taprio_qopt_offload *admin_conf)
>+{
>+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
>+	struct enetc_cbd cbd = {.cmd = 0};
>+	struct tgs_gcl_conf *gcl_config;
>+	struct tgs_gcl_data *gcl_data;
>+	struct gce *gce;
>+	dma_addr_t dma;
>+	u16 data_size;
>+	u16 gcl_len;
>+	u32 temp;
>+	int i;
>+
>+	gcl_len = admin_conf->num_entries;
>+	if (gcl_len > enetc_get_max_gcl_len(&priv->si->hw))
>+		return -EINVAL;
>+
>+	if (admin_conf->enable) {
>+		enetc_wr(&priv->si->hw,
>+			 ENETC_QBV_PTGCR_OFFSET,
>+			 temp & (~ENETC_QBV_TGE));
>+		usleep_range(10, 20);
>+		enetc_wr(&priv->si->hw,
>+			 ENETC_QBV_PTGCR_OFFSET,
>+			 temp | ENETC_QBV_TGE);
>+	} else {
>+		enetc_wr(&priv->si->hw,
>+			 ENETC_QBV_PTGCR_OFFSET,
>+			 temp & (~ENETC_QBV_TGE));
>+		return 0;
>+	}

Better do the upper qbv enable/disable procedure closer to enetc_send_cmd() or
at least after kzalloc that can fail, no need to restore then.

>+
>+	/* Configure the (administrative) gate control list using the
>+	 * control BD descriptor.
>+	 */
>+	gcl_config = &cbd.gcl_conf;
>+
>+	data_size = sizeof(struct tgs_gcl_data) + gcl_len * sizeof(struct gce);
>+
>+	gcl_data = kzalloc(data_size, __GFP_DMA | GFP_KERNEL);
>+	if (!gcl_data)
>+		return -ENOMEM;
>+
>+	gce = (struct gce *)(gcl_data + 1);
>+
>+	/* Since no initial state config in taprio, set gates open as default.
>+	 */
tc-taprio and IEEE Qbv allows to change configuration in flight, so that oper
state is active till new admin start time. So, here comment says it does
initial state config, if in-flight feature is not supported then error has to
be returned instead of silently rewriting configuration. But if it can be
implemented then state should be remembered/verified in order to not brake oper
configuration?

>+	gcl_config->atc = 0xff;
>+	gcl_config->acl_len = cpu_to_le16(gcl_len);

Ok, this is maximum number of schedules.
According to tc-taprio it's possible to set cycle period more then schedules
actually can consume. If cycle time is more, then last gate's state can be
kept till the end of cycle. But if last schedule has it's own interval set
then gates should be closed till the end of cycle or no? if it has to be closed,
then one more endl schedule should be present closing gates at the end of list
for the rest cycle time. Can be implemented in h/w but just to be sure, how it's
done in h/w?

>+
>+	if (!admin_conf->base_time) {
>+		gcl_data->btl =
>+			cpu_to_le32(enetc_rd(&priv->si->hw, ENETC_SICTR0));
>+		gcl_data->bth =
>+			cpu_to_le32(enetc_rd(&priv->si->hw, ENETC_SICTR1));
>+	} else {
>+		gcl_data->btl =
>+			cpu_to_le32(lower_32_bits(admin_conf->base_time));
>+		gcl_data->bth =
>+			cpu_to_le32(upper_32_bits(admin_conf->base_time));
>+	}
>+
>+	gcl_data->ct = cpu_to_le32(admin_conf->cycle_time);
>+	gcl_data->cte = cpu_to_le32(admin_conf->cycle_time_extension);

Not sure it's good idea to write values w/o verification, The cycle time and
time extension is 64 values, so it's supposed them to be more then 4,3
seconds, it's probably not a case, but better return error if it's more.

>+
>+	for (i = 0; i < gcl_len; i++) {
>+		struct tc_taprio_sched_entry *temp_entry;
>+		struct gce *temp_gce = gce + i;
>+
>+		temp_entry = &admin_conf->entries[i];
>+
>+		temp_gce->gate = cpu_to_le32(temp_entry->gate_mask);

So, gate_mask can have up to 32 traffic classes? :-|.

>+		temp_gce->period = cpu_to_le32(temp_entry->interval);

So, the interval can be up to 4.3 seconds for one schedule?
That is, one cycle can be one schedule.
great.

>+	}

There is no schedule cmd set, so only SetGateStates is supported?
But anyway it's Ok.

>+
>+	cbd.length = cpu_to_le16(data_size);
>+	cbd.status_flags = 0;
>+
>+	dma = dma_map_single(&priv->si->pdev->dev, gcl_data,
>+			     data_size, DMA_TO_DEVICE);
>+	if (dma_mapping_error(&priv->si->pdev->dev, dma)) {
>+		netdev_err(priv->si->ndev, "DMA mapping failed!\n");
>+		kfree(gcl_data);
>+		return -ENOMEM;
>+	}
>+
>+	cbd.addr[0] = lower_32_bits(dma);
>+	cbd.addr[1] = upper_32_bits(dma);
>+	cbd.cls = BDCR_CMD_PORT_GCL;
>+
>+	/* Updated by ENETC on completion of the configuration
>+	 * command. A zero value indicates success.
>+	 */
>+	cbd.status_flags = 0;

It's updated on completion by setting 0 on success, then why it's here
set to 0 but not 1 and not verified afterwards?

>+
>+	enetc_send_cmd(priv->si, &cbd);
>+
>+	dma_unmap_single(&priv->si->pdev->dev, dma, data_size, DMA_TO_DEVICE);
>+	kfree(gcl_data);
>+
>+	return 0;
>+}
>+
>+int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data)
>+{
>+	struct tc_taprio_qopt_offload *taprio = type_data;
>+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
>+	int i;
>+
>+	for (i = 0; i < priv->num_tx_rings; i++)
>+		enetc_set_bdr_prio(&priv->si->hw,
>+				   priv->tx_ring[i]->index,
>+				   taprio->enable ? i : 0);

then why enable/disable at the beginning for whole qbv scheduler, maybe
better do it together? Or better say, what if setup_taprio failed, who restore
configuration?

>+
>+	return enetc_setup_taprio(ndev, taprio);
>+}
>-- 
>2.17.1
>

-- 
Regards,
Ivan Khoronzhuk
