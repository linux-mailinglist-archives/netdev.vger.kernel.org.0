Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454EE252B4F
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 12:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbgHZKWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 06:22:04 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:24591 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728327AbgHZKWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 06:22:02 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598437320; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=MkBteFA49aiDVrV3uQvOo1CKvWxeAW0hpmXtiWdWsqg=;
 b=kLKJum/YUlk6WgjSTMQm1/WLJwBVZK9xWGCpw0Vc7+CXdPqVSbPEgXfNoACBKQToBwdUWRsO
 0LuP/w0ecqZHQV2SQYQP0gZQrmvVjF3wT08O9MpzQFzTd/LTTbm0DYy5eU840krL+U2kAJTr
 LwQRaOltQ5polEg7b4J9YsITH5s=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5f4637c2e2d4d29fc898b68e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 26 Aug 2020 10:21:54
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B653AC433CA; Wed, 26 Aug 2020 10:21:54 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: merez)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id ACA26C433C6;
        Wed, 26 Aug 2020 10:21:53 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 26 Aug 2020 13:21:53 +0300
From:   merez@codeaurora.org
To:     Lee Jones <lee.jones@linaro.org>
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, wil6210@qti.qualcomm.com
Subject: Re: [PATCH 25/32] wireless: ath: wil6210: wmi: Fix formatting and
 demote non-conforming function headers
In-Reply-To: <20200821071644.109970-26-lee.jones@linaro.org>
References: <20200821071644.109970-1-lee.jones@linaro.org>
 <20200821071644.109970-26-lee.jones@linaro.org>
Message-ID: <330bc340a4d16f383c9adef2324db60e@codeaurora.org>
X-Sender: merez@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-08-21 10:16, Lee Jones wrote:
> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/wireless/ath/wil6210/wmi.c:52: warning: Incorrect use of
> kernel-doc format:  * Addressing - theory of operations
>  drivers/net/wireless/ath/wil6210/wmi.c:70: warning: Incorrect use of
> kernel-doc format:  * @sparrow_fw_mapping provides memory remapping
> table for sparrow
>  drivers/net/wireless/ath/wil6210/wmi.c:80: warning: cannot understand
> function prototype: 'const struct fw_map sparrow_fw_mapping[] = '
>  drivers/net/wireless/ath/wil6210/wmi.c:107: warning: Cannot
> understand  * @sparrow_d0_mac_rgf_ext - mac_rgf_ext section for
> Sparrow D0
>  drivers/net/wireless/ath/wil6210/wmi.c:115: warning: Cannot
> understand  * @talyn_fw_mapping provides memory remapping table for
> Talyn
>  drivers/net/wireless/ath/wil6210/wmi.c:158: warning: Cannot
> understand  * @talyn_mb_fw_mapping provides memory remapping table for
> Talyn-MB
>  drivers/net/wireless/ath/wil6210/wmi.c:236: warning: Function
> parameter or member 'x' not described in 'wmi_addr_remap'
>  drivers/net/wireless/ath/wil6210/wmi.c:255: warning: Function
> parameter or member 'section' not described in 'wil_find_fw_mapping'
>  drivers/net/wireless/ath/wil6210/wmi.c:278: warning: Function
> parameter or member 'wil' not described in 'wmi_buffer_block'
>  drivers/net/wireless/ath/wil6210/wmi.c:278: warning: Function
> parameter or member 'ptr_' not described in 'wmi_buffer_block'
>  drivers/net/wireless/ath/wil6210/wmi.c:278: warning: Function
> parameter or member 'size' not described in 'wmi_buffer_block'
>  drivers/net/wireless/ath/wil6210/wmi.c:307: warning: Function
> parameter or member 'wil' not described in 'wmi_addr'
>  drivers/net/wireless/ath/wil6210/wmi.c:307: warning: Function
> parameter or member 'ptr' not described in 'wmi_addr'
>  drivers/net/wireless/ath/wil6210/wmi.c:1589: warning: Function
> parameter or member 'wil' not described in 'wil_find_cid_ringid_sta'
>  drivers/net/wireless/ath/wil6210/wmi.c:1589: warning: Function
> parameter or member 'vif' not described in 'wil_find_cid_ringid_sta'
>  drivers/net/wireless/ath/wil6210/wmi.c:1589: warning: Function
> parameter or member 'cid' not described in 'wil_find_cid_ringid_sta'
>  drivers/net/wireless/ath/wil6210/wmi.c:1589: warning: Function
> parameter or member 'ringid' not described in
> 'wil_find_cid_ringid_sta'
>  drivers/net/wireless/ath/wil6210/wmi.c:1876: warning: Function
> parameter or member 'vif' not described in 'wmi_evt_ignore'
>  drivers/net/wireless/ath/wil6210/wmi.c:1876: warning: Function
> parameter or member 'id' not described in 'wmi_evt_ignore'
>  drivers/net/wireless/ath/wil6210/wmi.c:1876: warning: Function
> parameter or member 'd' not described in 'wmi_evt_ignore'
>  drivers/net/wireless/ath/wil6210/wmi.c:1876: warning: Function
> parameter or member 'len' not described in 'wmi_evt_ignore'
>  drivers/net/wireless/ath/wil6210/wmi.c:2588: warning: Function
> parameter or member 'wil' not described in 'wmi_rxon'
> 
> Cc: Maya Erez <merez@codeaurora.org>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: wil6210@qti.qualcomm.com
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/net/wireless/ath/wil6210/wmi.c | 28 ++++++++++++++------------
>  1 file changed, 15 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/wil6210/wmi.c
> b/drivers/net/wireless/ath/wil6210/wmi.c
> index c7136ce567eea..3a6ee85acf6c7 100644
> --- a/drivers/net/wireless/ath/wil6210/wmi.c
> +++ b/drivers/net/wireless/ath/wil6210/wmi.c
> @@ -31,7 +31,7 @@ MODULE_PARM_DESC(led_id,
>  #define WIL_WAIT_FOR_SUSPEND_RESUME_COMP 200
>  #define WIL_WMI_PCP_STOP_TO_MS 5000
> 
> -/**
> +/*
>   * WMI event receiving - theory of operations
>   *
>   * When firmware about to report WMI event, it fills memory area

The correct format for such documentation blocks is:
/**
  * DOC: Theory of Operation

This comment is also applicable for the rest of such documentation 
blocks changed in this patch.

> @@ -66,7 +66,7 @@ MODULE_PARM_DESC(led_id,
>   * AHB address must be used.
>   */
> 
> -/**
> +/*
>   * @sparrow_fw_mapping provides memory remapping table for sparrow
>   *
>   * array size should be in sync with the declaration in the wil6210.h
For files in net/ and drivers/net/ the preferred style for long 
(multi-line) comments is a different and
the text should be in the same line as /*, as follows:
/* sparrow_fw_mapping provides memory remapping table for sparrow
I would also remove the @ from @sparrow_fw_mapping.
This comment is also applicable for the rest of such documentation 
blocks changed in this patch.
