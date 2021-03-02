Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F4F32A331
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377995AbhCBIwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:52:22 -0500
Received: from m42-2.mailgun.net ([69.72.42.2]:30584 "EHLO m42-2.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347800AbhCBF7j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 00:59:39 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1614664756; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=SDD1P47XNaiUZrFMTSvgy2G91aczIhSVqpNha7zFNTg=; b=kGu3dPq0Lb1CBYuOZWc04lJ9qYQP95E0tn8jxkMgqCollwBWj7z8hnnRhQAEmYju0VfI8nMP
 yiDy75rl/0CUG3EuRp3OnLG3HeuMAPidcPD0hrVGxWOWi9IjlziN/4KfFFllWfPnldZcIgT5
 5q/rGCfWhZzi0VaxiTQ9SgKyeWY=
X-Mailgun-Sending-Ip: 69.72.42.2
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 603dd4171d4da3b75de04429 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 02 Mar 2021 05:58:47
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CEB27C43464; Tue,  2 Mar 2021 05:58:46 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 09D31C433CA;
        Tue,  2 Mar 2021 05:58:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 09D31C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH] iwlwifi: fix ARCH=i386 compilation warnings
References: <20210302011640.1276636-1-pierre-louis.bossart@linux.intel.com>
Date:   Tue, 02 Mar 2021 07:58:40 +0200
In-Reply-To: <20210302011640.1276636-1-pierre-louis.bossart@linux.intel.com>
        (Pierre-Louis Bossart's message of "Mon, 1 Mar 2021 19:16:37 -0600")
Message-ID: <87k0qq85bj.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com> writes:

> An unsigned long variable should rely on '%lu' format strings, not '%zd'
>
> Fixes: a1a6a4cf49ece ("iwlwifi: pnvm: implement reading PNVM from UEFI")
> Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> ---
> warnings found with v5.12-rc1 and next-20210301

Luca, can I take this to wireless-drivers?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
