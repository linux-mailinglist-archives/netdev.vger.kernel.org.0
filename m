Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F35341EA31
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 11:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353257AbhJAJ5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 05:57:38 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:22568 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353183AbhJAJ5g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 05:57:36 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633082153; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=tMw5Hzb3ztdNEHxY4bAev68n6seU8HT3Mf7aFuIt4P8=; b=rdHIMJnrygDT4HQsdbk1vGLisqmAwBPTqYwmEkK/eo4DZs24rq3Y7FLPZ4rVfV4FcM+8uPFT
 wxL8Jvi1IA/EC0OHna65u/Q0ZQuYHJq1X1mJJgKM7U/2La590uUKIEo6PYrnORyxYgqUiF6j
 2nbo57CndejHwtvijRNT+UUOWQQ=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 6156db1c605ecf100b49b611 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 01 Oct 2021 09:55:40
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 910CFC43618; Fri,  1 Oct 2021 09:55:40 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E8C99C4338F;
        Fri,  1 Oct 2021 09:55:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org E8C99C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        Pali =?utf-8?Q?Roh?= =?utf-8?Q?=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v7 13/24] wfx: add hif_tx*.c/hif_tx*.h
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com>
        <20210920161136.2398632-14-Jerome.Pouiller@silabs.com>
Date:   Fri, 01 Oct 2021 12:55:33 +0300
In-Reply-To: <20210920161136.2398632-14-Jerome.Pouiller@silabs.com> (Jerome
        Pouiller's message of "Mon, 20 Sep 2021 18:11:25 +0200")
Message-ID: <87fstlkr1m.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:

> From: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
>
> Signed-off-by: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>

[...]

> --- /dev/null
> +++ b/drivers/net/wireless/silabs/wfx/hif_tx_mib.h
> @@ -0,0 +1,49 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Implementation of the host-to-chip MIBs of the hardware API.
> + *
> + * Copyright (c) 2017-2020, Silicon Laboratories, Inc.
> + * Copyright (c) 2010, ST-Ericsson
> + * Copyright (C) 2010, ST-Ericsson SA
> + */
> +#ifndef WFX_HIF_TX_MIB_H
> +#define WFX_HIF_TX_MIB_H
> +
> +struct wfx_vif;
> +struct sk_buff;
> +
> +int hif_set_output_power(struct wfx_vif *wvif, int val);
> +int hif_set_beacon_wakeup_period(struct wfx_vif *wvif,
> +				 unsigned int dtim_interval,
> +				 unsigned int listen_interval);
> +int hif_set_rcpi_rssi_threshold(struct wfx_vif *wvif,
> +				int rssi_thold, int rssi_hyst);
> +int hif_get_counters_table(struct wfx_dev *wdev, int vif_id,
> +			   struct hif_mib_extended_count_table *arg);
> +int hif_set_macaddr(struct wfx_vif *wvif, u8 *mac);
> +int hif_set_rx_filter(struct wfx_vif *wvif,
> +		      bool filter_bssid, bool fwd_probe_req);
> +int hif_set_beacon_filter_table(struct wfx_vif *wvif, int tbl_len,
> +				const struct hif_ie_table_entry *tbl);
> +int hif_beacon_filter_control(struct wfx_vif *wvif,
> +			      int enable, int beacon_count);
> +int hif_set_operational_mode(struct wfx_dev *wdev, enum hif_op_power_mod=
e mode);
> +int hif_set_template_frame(struct wfx_vif *wvif, struct sk_buff *skb,
> +			   u8 frame_type, int init_rate);
> +int hif_set_mfp(struct wfx_vif *wvif, bool capable, bool required);
> +int hif_set_block_ack_policy(struct wfx_vif *wvif,
> +			     u8 tx_tid_policy, u8 rx_tid_policy);
> +int hif_set_association_mode(struct wfx_vif *wvif, int ampdu_density,
> +			     bool greenfield, bool short_preamble);
> +int hif_set_tx_rate_retry_policy(struct wfx_vif *wvif,
> +				 int policy_index, u8 *rates);
> +int hif_keep_alive_period(struct wfx_vif *wvif, int period);
> +int hif_set_arp_ipv4_filter(struct wfx_vif *wvif, int idx, __be32 *addr);
> +int hif_use_multi_tx_conf(struct wfx_dev *wdev, bool enable);
> +int hif_set_uapsd_info(struct wfx_vif *wvif, unsigned long val);
> +int hif_erp_use_protection(struct wfx_vif *wvif, bool enable);
> +int hif_slot_time(struct wfx_vif *wvif, int val);
> +int hif_wep_default_key_id(struct wfx_vif *wvif, int val);
> +int hif_rts_threshold(struct wfx_vif *wvif, int val);

"wfx_" prefix missing from quite a few functions.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
