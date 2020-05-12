Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDC81CEF82
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 10:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbgELIw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 04:52:27 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:16076 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727783AbgELIw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 04:52:27 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1589273546; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=wAiHL69U8qDg3HPi2ZjYIfMjWrQAlikRtCOgQsR44XE=;
 b=hMNKIDaQnKgsO8OvpJQ+d6pOz3VbrzZsk9iKOurCPy5rysLMAQbOXBTWzGZOjMAAQYLbuBjt
 QOPuR/2PhcnJeE6Qu4VLtzmAvll1KyujugiDPnsX5hWFx5h5WhyxKiUNVZnhr61cWHv3K+/R
 nW2Qokr+lAxlUbuNJENDdE0aBOs=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eba63c9.7f030dc41618-smtp-out-n05;
 Tue, 12 May 2020 08:52:25 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0388CC432C2; Tue, 12 May 2020 08:52:25 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8FEBCC433CB;
        Tue, 12 May 2020 08:52:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8FEBCC433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH -next] brcmfmac: make non-global functions static
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200508013249.95196-1-chenzhou10@huawei.com>
References: <20200508013249.95196-1-chenzhou10@huawei.com>
To:     Chen Zhou <chenzhou10@huawei.com>
Cc:     <arend.vanspriel@broadcom.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <chi-hsien.lin@cypress.com>,
        <wright.feng@cypress.com>, <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <chenzhou10@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200512085225.0388CC432C2@smtp.codeaurora.org>
Date:   Tue, 12 May 2020 08:52:25 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chen Zhou <chenzhou10@huawei.com> wrote:

> Fix sparse warning:
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:2206:5:
> 	warning: symbol 'brcmf_p2p_get_conn_idx' was not declared. Should it be static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
> Reviewed-by: Wright Feng <wright.feng@cypress.com>

Patch applied to wireless-drivers-next.git, thanks.

7294ee6f5642 brcmfmac: make non-global functions static

-- 
https://patchwork.kernel.org/patch/11535195/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
