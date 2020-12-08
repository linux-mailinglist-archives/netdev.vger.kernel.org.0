Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9342D2569
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 09:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgLHIJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 03:09:16 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:55321 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbgLHIJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 03:09:15 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607414938; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=HVvW8//D2rnwst2clmB9T1kZp2OMdvbxOdz8wy3/iTE=;
 b=IC37AOPFsRT4LvXCpr41JRrbAoBJta5hcaamvD48Po83b3xXOp1vYYF4bO6P7EeqQ5wM35rV
 1AarPIR8ECGxbY4zw2pGMHcxRqX6n/hG/UmmMRqXUoDxXnXbOxkPxkVafIc8V2UgGyAPlEsC
 eASOJLbnBBRv2zZ7CDBc7pqNbXA=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-west-2.postgun.com with SMTP id
 5fcf3478ed9d5dfa896b8aa1 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 08 Dec 2020 08:08:24
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B35FAC43463; Tue,  8 Dec 2020 08:08:24 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5CB59C433CA;
        Tue,  8 Dec 2020 08:08:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5CB59C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 065/141] airo: Fix fall-through warnings for Clang
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <b3c0f74f5b6e6bff9f1609b310319b6fdd9ee205.1605896059.git.gustavoars@kernel.org>
References: <b3c0f74f5b6e6bff9f1609b310319b6fdd9ee205.1605896059.git.gustavoars@kernel.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201208080824.B35FAC43463@smtp.codeaurora.org>
Date:   Tue,  8 Dec 2020 08:08:24 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavoars@kernel.org> wrote:

> In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
> by explicitly adding a break statement instead of letting the code fall
> through to the next case.
> 
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

4 patches applied to wireless-drivers-next.git, thanks.

48264b23fade airo: Fix fall-through warnings for Clang
f48d7dccb3e4 rt2x00: Fix fall-through warnings for Clang
0662fbebf4fb rtw88: Fix fall-through warnings for Clang
18572b0b5493 zd1201: Fix fall-through warnings for Clang

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/b3c0f74f5b6e6bff9f1609b310319b6fdd9ee205.1605896059.git.gustavoars@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

