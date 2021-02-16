Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0BA631C6B6
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 08:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbhBPHOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 02:14:17 -0500
Received: from m42-2.mailgun.net ([69.72.42.2]:36993 "EHLO m42-2.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229722AbhBPHOQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 02:14:16 -0500
X-Greylist: delayed 354 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Feb 2021 02:14:15 EST
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1613459630; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=lAJ/Ozn/cSfCtWT/CbzmOiV2CMWhEZ01rK6cAFfIMPY=;
 b=nuEgFuq/PnTSO5HOt+d1VQcxcob2nmz+IIuLTvSv6nvnSb4Y8sP8PN1WlNZmsGlBC3pIfEai
 9NLE0d4NC4zX/1g2eCsVHVNmRRFvq4+jb0fG8KCWAsLAhDWRvgKDspXmQx6IPsVA/t6toqvF
 ziwSuCnArbwfziRTrK1ROy1CADk=
X-Mailgun-Sending-Ip: 69.72.42.2
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 602b6e868e43a988b772e49a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 16 Feb 2021 07:04:38
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 67950C433C6; Tue, 16 Feb 2021 07:04:38 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E4606C433CA;
        Tue, 16 Feb 2021 07:04:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E4606C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] ath11k: debugfs: Fix spelling mistake "Opportunies"
 ->
 "Opportunities"
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210212113627.212787-1-colin.king@canonical.com>
References: <20210212113627.212787-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210216070438.67950C433C6@smtp.codeaurora.org>
Date:   Tue, 16 Feb 2021 07:04:38 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> There is a spelling mistake in some debug text, fix this.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

9c349dbd0752 ath11k: debugfs: Fix spelling mistake "Opportunies" -> "Opportunities"

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210212113627.212787-1-colin.king@canonical.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

