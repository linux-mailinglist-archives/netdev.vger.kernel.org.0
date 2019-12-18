Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 092BD12514B
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 20:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbfLRTHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 14:07:15 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:53334 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726698AbfLRTHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 14:07:15 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576696035; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=Ab4NGr8qk+XaJqpupgPmtusLhOTBZgyemH+ZzAaLCcA=;
 b=SeERzDiaG4a7KfZHUCArX8CmYti9wLQAWeXshDENNbJ97Gk9zdGNsGVToZl14NjtRSJ02pbl
 Oaoyx77wNZOf6cxiknL2b1N3PYSMBTpMblll9G9tY4f2HcYJL73Sce2mWpB870+y45lzas1i
 kFdpiQu3gEvhGNlULfYYbz7xa8g=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5dfa78e2.7f045e908a78-smtp-out-n03;
 Wed, 18 Dec 2019 19:07:14 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0D0DCC43383; Wed, 18 Dec 2019 19:07:14 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2FC2AC433CB;
        Wed, 18 Dec 2019 19:07:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2FC2AC433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/6] rtlwifi: rtl8192ce: use generic
 rtl_query_rxpwrpercentage
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191211154755.15012-2-straube.linux@gmail.com>
References: <20191211154755.15012-2-straube.linux@gmail.com>
To:     Michael Straube <straube.linux@gmail.com>
Cc:     pkshih@realtek.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Straube <straube.linux@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191218190714.0D0DCC43383@smtp.codeaurora.org>
Date:   Wed, 18 Dec 2019 19:07:14 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Michael Straube <straube.linux@gmail.com> wrote:

> Function _rtl92c_query_rxpwrpercentage is identical to the generic
> version rtl_query_rxpwrpercentage. Remove _rtl92c_query_rxpwrpercentage
> and use the generic function.
> 
> Signed-off-by: Michael Straube <straube.linux@gmail.com>

6 patches applied to wireless-drivers-next.git, thanks.

f365f2f67b6a rtlwifi: rtl8192ce: use generic rtl_query_rxpwrpercentage
b8a19dd64501 rtlwifi: rtl8192cu: use generic rtl_query_rxpwrpercentage
5a87ae1d676e rtlwifi: rtl8192de: use generic rtl_query_rxpwrpercentage
d01b26734297 rtlwifi: rtl8192ce: use generic rtl_signal_scale_mapping
fef91a2b5f5f rtlwifi: rtl8192cu: use generic rtl_signal_scale_mapping
716c733f52ec rtlwifi: rtl8192de: use generic rtl_signal_scale_mapping

-- 
https://patchwork.kernel.org/patch/11285545/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
