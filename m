Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90221149BA6
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 16:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729030AbgAZPsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 10:48:23 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:20597 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727349AbgAZPsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 10:48:23 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580053703; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=mSC7z0jN2KfIlNDsfAnxYHnv4eoBgAgVAR0WZyHRDdw=;
 b=erBWrBcaslhrzgkAkj3hqyEYi46lKB/CgKqhRlE569NdWgX7WY3GR44GjQpVzydFFiou4WnE
 Wz5ZupzphorixuCXB4u9FIf6V3ERPul9bvNCeH86C5p+VNoqiK4FGpP/PNaMw9X+A7guq3Yk
 LMSIxGJDwZKtTf+58b5HkAEN/JA=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e2db4c3.7f018acd3d88-smtp-out-n02;
 Sun, 26 Jan 2020 15:48:19 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id F08E5C4479C; Sun, 26 Jan 2020 15:48:17 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 12897C43383;
        Sun, 26 Jan 2020 15:48:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 12897C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: btcoex: fix spelling mistake "initilized" ->
 "initialized"
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200122093340.2800226-1-colin.king@canonical.com>
References: <20200122093340.2800226-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200126154817.F08E5C4479C@smtp.codeaurora.org>
Date:   Sun, 26 Jan 2020 15:48:17 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in one of the fields in the btc_coexist struct,
> fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

f76c34082b24 rtlwifi: btcoex: fix spelling mistake "initilized" -> "initialized"

-- 
https://patchwork.kernel.org/patch/11345405/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
