Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76D99248244
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 11:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgHRJvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 05:51:44 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:64123 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726694AbgHRJvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 05:51:43 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1597744302; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=hzpVyPWKFg4D4ANT8DjNIVmlgu/bhkSWN4fRW6pYeQs=;
 b=bqdw/s8QjA/CAMBCdOZqRoHlxceOC0uPvsA8TTwwyxBa5kq3oFcVy/0tFGkzSdur4YbMlnLg
 zB+OCO5owJ4Y7ViIQdslFrfT2pgUbgdEuF9Bw4a7aMGAoSxc1rZwdE2BthxfpBJuzAM8gU5O
 0n5HTfy0HO+hHvmQ9zwoKW6qlPs=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5f3ba4ac3f2ce110201a9cc5 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 18 Aug 2020 09:51:40
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 65EF8C433A1; Tue, 18 Aug 2020 09:51:40 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5CDA9C433C6;
        Tue, 18 Aug 2020 09:51:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5CDA9C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net-next] ath11k: Fix possible memleak in
 ath11k_qmi_init_service
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1595237804-66297-1-git-send-email-wangyufen@huawei.com>
References: <1595237804-66297-1-git-send-email-wangyufen@huawei.com>
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <brcm80211-dev-list@cypress.com>, <linux-wireless@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <franky.lin@broadcom.com>, <wright.feng@cypress.com>,
        Wang Yufen <wangyufen@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200818095140.65EF8C433A1@smtp.codeaurora.org>
Date:   Tue, 18 Aug 2020 09:51:40 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wang Yufen <wangyufen@huawei.com> wrote:

> When qmi_add_lookup fail, we should destroy the workqueue
> 
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

28f163211881 ath11k: Fix possible memleak in ath11k_qmi_init_service

-- 
https://patchwork.kernel.org/patch/11673293/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

