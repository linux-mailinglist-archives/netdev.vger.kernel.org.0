Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7DF41C3619
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 11:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728518AbgEDJuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 05:50:14 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:11921 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728196AbgEDJuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 05:50:14 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588585813; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=R7izQ6849vr+Ia5p6vwxddXyHNYP2hyHlhDBgmAGNhw=;
 b=JmSHsh3kebLd1b1aSGlGj5w8P2utTeGpbSb3R0x0v0WPcffpgJX/pjRlP5NMaIxnhKIInwLO
 zgZhGu7oQXxi5zz5VecBzPK6LFsvsUxchQ3eIhLR4+a9M4kOTdvOY6cg7tUCe4zH+ruMcQ/c
 Zs7Dmi7FCiG968ZvFZkbogTcaLk=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eafe54c.7f19c843f420-smtp-out-n04;
 Mon, 04 May 2020 09:50:04 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E37A9C432C2; Mon,  4 May 2020 09:50:03 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 749BCC433D2;
        Mon,  4 May 2020 09:50:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 749BCC433D2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmfmac: remove comparison to bool in brcmf_fws_attach()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200426094053.23132-1-yanaijie@huawei.com>
References: <20200426094053.23132-1-yanaijie@huawei.com>
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <arend.vanspriel@broadcom.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <chi-hsien.lin@cypress.com>,
        <wright.feng@cypress.com>, <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jason Yan <yanaijie@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200504095003.E37A9C432C2@smtp.codeaurora.org>
Date:   Mon,  4 May 2020 09:50:03 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jason Yan <yanaijie@huawei.com> wrote:

> Fix the following coccicheck warning:
> 
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c:2359:6-40:
> WARNING: Comparison to bool
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> Reviewed-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>

Patch applied to wireless-drivers-next.git, thanks.

ff2af09f4515 brcmfmac: remove comparison to bool in brcmf_fws_attach()

-- 
https://patchwork.kernel.org/patch/11510329/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
