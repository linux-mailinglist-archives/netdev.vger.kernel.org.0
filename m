Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C007A257C2C
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 17:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbgHaPTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 11:19:33 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:23676 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728109AbgHaPT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 11:19:29 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598887168; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=4u536xE6VM//6j9yfuTuY3V55yP7Lhb2M62vzlpJNx0=;
 b=EAkpIFMSafuHnCMcLQhl/vm7hiwCM9eLYMCks1vh38I+sw8V4voPtqDYJ9dTbHeiXzVaWwCW
 cmZzOfExjnAG0n/iBQ4aCXlT4CvB3SmJM4gGPBBfiyw0jYN9R3rcpYh/Cn0hUej3EVKInhqR
 MwgRGqTwoSbo+wr72TMzIJPVoes=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 5f4d14eb32925f96e147d743 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 31 Aug 2020 15:19:06
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 39021C43391; Mon, 31 Aug 2020 15:19:06 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A490CC433CA;
        Mon, 31 Aug 2020 15:19:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A490CC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 25/32] wireless: ath: wil6210: wmi: Fix formatting and
 demote non-conforming function headers
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200827073201.GR3248864@dell>
References: <20200827073201.GR3248864@dell>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Maya Erez <merez@codeaurora.org>, wil6210@qti.qualcomm.com
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200831151906.39021C43391@smtp.codeaurora.org>
Date:   Mon, 31 Aug 2020 15:19:06 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> wrote:

> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/wireless/ath/wil6210/wmi.c:52: warning: Incorrect use of kernel-doc format:  * Addressing - theory of operations
>  drivers/net/wireless/ath/wil6210/wmi.c:70: warning: Incorrect use of kernel-doc format:  * @sparrow_fw_mapping provides memory remapping table for sparrow
>  drivers/net/wireless/ath/wil6210/wmi.c:80: warning: cannot understand function prototype: 'const struct fw_map sparrow_fw_mapping[] = '
>  drivers/net/wireless/ath/wil6210/wmi.c:107: warning: Cannot understand  * @sparrow_d0_mac_rgf_ext - mac_rgf_ext section for Sparrow D0
>  drivers/net/wireless/ath/wil6210/wmi.c:115: warning: Cannot understand  * @talyn_fw_mapping provides memory remapping table for Talyn
>  drivers/net/wireless/ath/wil6210/wmi.c:158: warning: Cannot understand  * @talyn_mb_fw_mapping provides memory remapping table for Talyn-MB
>  drivers/net/wireless/ath/wil6210/wmi.c:236: warning: Function parameter or member 'x' not described in 'wmi_addr_remap'
>  drivers/net/wireless/ath/wil6210/wmi.c:255: warning: Function parameter or member 'section' not described in 'wil_find_fw_mapping'
>  drivers/net/wireless/ath/wil6210/wmi.c:278: warning: Function parameter or member 'wil' not described in 'wmi_buffer_block'
>  drivers/net/wireless/ath/wil6210/wmi.c:278: warning: Function parameter or member 'ptr_' not described in 'wmi_buffer_block'
>  drivers/net/wireless/ath/wil6210/wmi.c:278: warning: Function parameter or member 'size' not described in 'wmi_buffer_block'
>  drivers/net/wireless/ath/wil6210/wmi.c:307: warning: Function parameter or member 'wil' not described in 'wmi_addr'
>  drivers/net/wireless/ath/wil6210/wmi.c:307: warning: Function parameter or member 'ptr' not described in 'wmi_addr'
>  drivers/net/wireless/ath/wil6210/wmi.c:1589: warning: Function parameter or member 'wil' not described in 'wil_find_cid_ringid_sta'
>  drivers/net/wireless/ath/wil6210/wmi.c:1589: warning: Function parameter or member 'vif' not described in 'wil_find_cid_ringid_sta'
>  drivers/net/wireless/ath/wil6210/wmi.c:1589: warning: Function parameter or member 'cid' not described in 'wil_find_cid_ringid_sta'
>  drivers/net/wireless/ath/wil6210/wmi.c:1589: warning: Function parameter or member 'ringid' not described in 'wil_find_cid_ringid_sta'
>  drivers/net/wireless/ath/wil6210/wmi.c:1876: warning: Function parameter or member 'vif' not described in 'wmi_evt_ignore'
>  drivers/net/wireless/ath/wil6210/wmi.c:1876: warning: Function parameter or member 'id' not described in 'wmi_evt_ignore'
>  drivers/net/wireless/ath/wil6210/wmi.c:1876: warning: Function parameter or member 'd' not described in 'wmi_evt_ignore'
>  drivers/net/wireless/ath/wil6210/wmi.c:1876: warning: Function parameter or member 'len' not described in 'wmi_evt_ignore'
>  drivers/net/wireless/ath/wil6210/wmi.c:2588: warning: Function parameter or member 'wil' not described in 'wmi_rxon'
> 
> Cc: Maya Erez <merez@codeaurora.org>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: wil6210@qti.qualcomm.com
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

6 patches applied to ath-next branch of ath.git, thanks.

6b9739c8b8b8 wil6210: wmi: Fix formatting and demote non-conforming function headers
299ff6c6baa2 wil6210: interrupt: Demote comment header which is clearly not kernel-doc
e6636d649474 wil6210: txrx: Demote obvious abuse of kernel-doc
e2d651b99379 wil6210: txrx_edma: Demote comments which are clearly not kernel-doc
c7b1a9b358e1 wil6210: pmc: Demote a few nonconformant kernel-doc function headers
ea2e3df7c4f2 wil6210: wil_platform: Demote kernel-doc header to standard comment block

-- 
https://patchwork.kernel.org/patch/11740165/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

