Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3D41B37A5
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 08:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbgDVGlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 02:41:51 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:26618 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726508AbgDVGlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 02:41:50 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1587537710; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=oKUumuQTcasIYWPCKuU4pWf17rQd2gOkZlK1vxrDvYQ=;
 b=d9iymOvPI6bFFROXTWIHjuEC2pXIU/OmaPGpj+LjZ8nQAjak5rHbm0r+9dhDc0wHKk42KRKB
 fKM3++YG+pjmfhfYgDxUGTGWGTl2cRwOkhZnczvh3VMIKuUNW23vC1LTLfEucXieMflQH/4n
 MMBz2EeR02hl06jOOZWO15NfBsg=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e9fe718.7f0225d3f5e0-smtp-out-n03;
 Wed, 22 Apr 2020 06:41:28 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 478D4C432C2; Wed, 22 Apr 2020 06:41:28 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DAEFCC433BA;
        Wed, 22 Apr 2020 06:41:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DAEFCC433BA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath11k: remove conversion to bool in
 ath11k_dp_rxdesc_mpdu_valid()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200420123718.3384-1-yanaijie@huawei.com>
References: <20200420123718.3384-1-yanaijie@huawei.com>
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <davem@davemloft.net>, <srirrama@codeaurora.org>,
        <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jason Yan <yanaijie@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200422064128.478D4C432C2@smtp.codeaurora.org>
Date:   Wed, 22 Apr 2020 06:41:28 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jason Yan <yanaijie@huawei.com> wrote:

> The '==' expression itself is bool, no need to convert it to bool again.
> This fixes the following coccicheck warning:
> 
> drivers/net/wireless/ath/ath11k/dp_rx.c:255:46-51: WARNING: conversion
> to bool not needed here
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

8af40902f839 ath11k: remove conversion to bool in ath11k_dp_rxdesc_mpdu_valid()

-- 
https://patchwork.kernel.org/patch/11498781/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
