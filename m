Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B39D149A3C
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 11:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387401AbgAZKsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 05:48:36 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:62731 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729255AbgAZKsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 05:48:36 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580035716; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=6dvZlOi6F0EoCpr+/HJGOxTRA67L4SDOxF1/MIi3hmM=;
 b=qqho674ZWGAkhSeKgtHIJVxQyHD9ytptVJIv0YzXut5OxZl/MZJTTMnXZD2AGiwKTM8EgzAE
 AHBetTYwoZKj0StG2lJIAjJaS75ycZjTr+L0og5jXUALIY/FJe3swOqLdEyAhSHb2ZFRpsDt
 H7zG7c2Jv6tGoNDZ6W552DuoNxE=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e2d6e82.7fe8bb133458-smtp-out-n03;
 Sun, 26 Jan 2020 10:48:34 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 26455C4479C; Sun, 26 Jan 2020 10:48:34 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7D7C8C433CB;
        Sun, 26 Jan 2020 10:48:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7D7C8C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] ath11k: avoid null pointer dereference when pointer
 band is null
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200111090824.9999-1-colin.king@canonical.com>
References: <20200111090824.9999-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        John Crispin <john@phrozen.org>,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200126104834.26455C4479C@smtp.codeaurora.org>
Date:   Sun, 26 Jan 2020 10:48:34 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> In the unlikely event that cap->supported_bands has neither
> WMI_HOST_WLAN_2G_CAP set or WMI_HOST_WLAN_5G_CAP set then pointer
> band is null and a null dereference occurs when assigning
> band->n_iftype_data.  Move the assignment to the if blocks to
> avoid this.  Cleans up static analysis warnings.
> 
> Addresses-Coverity: ("Explicit null dereference")
> Fixes: 9f056ed8ee01 ("ath11k: add HE support")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

3b4516838eaa ath11k: avoid null pointer dereference when pointer band is null

-- 
https://patchwork.kernel.org/patch/11328755/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
