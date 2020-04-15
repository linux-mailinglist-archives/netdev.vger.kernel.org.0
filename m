Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19AF61A9767
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 10:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895052AbgDOIsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 04:48:30 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:17053 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2895027AbgDOIs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 04:48:26 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1586940506; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=rC0Hx9+l6eblcHjkei+jpjuKRcfOwI4xV70WkS6PWIs=;
 b=mPtXqkN+IXipBUyq4qdyDwZd/LRJg8v4lyQ048d0e491Odio3YJPg3dH+3BvSEqa/JnxOMsq
 0oN4TYAO7J7cHVvgz1oET82TMo+FD/cs/Ew7dq5Y2ir+kmg9HGd68Jr1n3V9xLehDeHeOzMj
 xILJOQ2Y+5IC7th28jKiwbxl8cU=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e96ca4c.7f70bc1980d8-smtp-out-n04;
 Wed, 15 Apr 2020 08:48:12 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2D0AAC433F2; Wed, 15 Apr 2020 08:48:12 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D58A7C433CB;
        Wed, 15 Apr 2020 08:48:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D58A7C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmsmac: make brcms_c_stf_ss_update() void
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200413082126.22572-1-yanaijie@huawei.com>
References: <20200413082126.22572-1-yanaijie@huawei.com>
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <arend.vanspriel@broadcom.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <chi-hsien.lin@cypress.com>,
        <wright.feng@cypress.com>, <davem@davemloft.net>,
        <yanaijie@huawei.com>, <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200415084812.2D0AAC433F2@smtp.codeaurora.org>
Date:   Wed, 15 Apr 2020 08:48:12 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jason Yan <yanaijie@huawei.com> wrote:

> Fix the following coccicheck warning:
> 
> drivers/net/wireless/broadcom/brcm80211/brcmsmac/stf.c:309:5-13:
> Unneeded variable: "ret_code". Return "0" on line 328
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

e871b8bfedda brcmsmac: make brcms_c_stf_ss_update() void

-- 
https://patchwork.kernel.org/patch/11485249/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
