Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0522D58245C
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 12:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbiG0KbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 06:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiG0KbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 06:31:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC4042AD5;
        Wed, 27 Jul 2022 03:31:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 150E4B82006;
        Wed, 27 Jul 2022 10:31:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E80C433D6;
        Wed, 27 Jul 2022 10:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658917879;
        bh=jRNYk6q8JzeuZqnThtLOMt1QaoYkFMc7uSjjv3CFDnY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=NgEdFGzSPv+GYc9QqMnLSR3JvMuHzb9KqxiSI2nMH8rMkSWzLJee7W6solgNmXYni
         5BwrNstW0LGaDDDCaEvNrzIvodyPnCHnFgtvFHqK/69jHP7JN8n83n59gwq87YQRCD
         W6N6+eIztdY9wXkgkwrhA1l71xUCM3hyBJHWBKP/Z7tNIMaKI5O4uvjBUavQfBwIrW
         1044iYw3rBt0mvqyUO8PKLzmeCJMsJGrgs8kiDseZb8dgtzXweDV9OsE8ZVD5usEod
         6PmEYRkQic3dZanbavyBhFOeuDOzK+rzhEayDkapdq5cf2lMKavV60PP9kaX16gK12
         +xHQZeHAHs9kg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Cc:     loic.poulain@linaro.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 4/4] wcn36xx: Add debugfs entry to read firmware feature strings
References: <20220719143302.2071223-1-bryan.odonoghue@linaro.org>
        <20220719143302.2071223-5-bryan.odonoghue@linaro.org>
Date:   Wed, 27 Jul 2022 13:31:15 +0300
In-Reply-To: <20220719143302.2071223-5-bryan.odonoghue@linaro.org> (Bryan
        O'Donoghue's message of "Tue, 19 Jul 2022 15:33:02 +0100")
Message-ID: <87k07yq230.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bryan O'Donoghue <bryan.odonoghue@linaro.org> writes:

> Add in the ability to easily find the firmware feature bits reported in the
> get feature exchange without having to compile-in debug prints.
>
> root@linaro-alip:~# cat /sys/kernel/debug/ieee80211/phy0/wcn36xx/firmware_feat_caps
> MCC
> P2P
> DOT11AC
> SLM_SESSIONIZATION
> DOT11AC_OPMODE
> SAP32STA
> TDLS
> P2P_GO_NOA_DECOUPLE_INIT_SCAN
> WLANACTIVE_OFFLOAD
> BEACON_OFFLOAD
> SCAN_OFFLOAD
> BCN_MISS_OFFLOAD
> STA_POWERSAVE
> STA_ADVANCED_PWRSAVE
> BCN_FILTER
> RTT
> RATECTRL
> WOW
> WLAN_ROAM_SCAN_OFFLOAD
> SPECULATIVE_PS_POLL
> IBSS_HEARTBEAT_OFFLOAD
> WLAN_SCAN_OFFLOAD
> WLAN_PERIODIC_TX_PTRN
> ADVANCE_TDLS
> BATCH_SCAN
> FW_IN_TX_PATH
> EXTENDED_NSOFFLOAD_SLOT
> CH_SWITCH_V1
> HT40_OBSS_SCAN
> UPDATE_CHANNEL_LIST
> WLAN_MCADDR_FLT
> WLAN_CH144
> TDLS_SCAN_COEXISTENCE
> LINK_LAYER_STATS_MEAS
> MU_MIMO
> EXTENDED_SCAN
> DYNAMIC_WMM_PS
> MAC_SPOOFED_SCAN
> FW_STATS
> WPS_PRBRSP_TMPL
> BCN_IE_FLT_DELTA
>
> Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[...]

> +static ssize_t read_file_firmware_feature_caps(struct file *file,
> +					       char __user *user_buf,
> +					       size_t count, loff_t *ppos)
> +{
> +	struct wcn36xx *wcn = file->private_data;
> +	unsigned long page = get_zeroed_page(GFP_KERNEL);
> +	char *p = (char *)page;
> +	int i;
> +	int ret;
> +
> +	if (!p)
> +		return -ENOMEM;
> +
> +	mutex_lock(&wcn->hal_mutex);
> +	for (i = 0; i < MAX_FEATURE_SUPPORTED; i++) {
> +		if (wcn36xx_firmware_get_feat_caps(wcn->fw_feat_caps, i)) {
> +			p += sprintf(p, "%s\n",
> +				     wcn36xx_firmware_get_cap_name(i));
> +		}
> +	}
> +	mutex_unlock(&wcn->hal_mutex);
> +
> +	ret = simple_read_from_buffer(user_buf, count, ppos, (char *)page,
> +				      (unsigned long)p - page);
> +
> +	free_page(page);
> +	return ret;
> +}

Why not use the normal use kzalloc() and kfree()? That way you would not
need a separate page variable. What's the benefit from
get_zeroed_page()?

Also I don't see any checks for a memory allocation failure.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
