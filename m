Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3998D3F3BC0
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 19:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbhHURdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 13:33:08 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:18856 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbhHURdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Aug 2021 13:33:06 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1629567147; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=2BboqZtCczhs7Gj5gmMKaCpliJBrP2gnrnXMEhNrp9U=;
 b=EDmmvxaP72lWkOiUe/gSVk04K+W/4JMvKxZPXA2/bFaFsxRjDtW7DAzCJcgPgobSRdr9OojP
 58iBmBQaHMxlgi3ESYd8mzuq0lKCZVsa0R+OukhrG6XMH6cbLgUQorSbm/GmmahPzVAv9yK2
 OqqIZLGXRo9JXFezN7Aye212nN8=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 6121388ff588e42af1471068 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 21 Aug 2021 17:31:59
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7AED7C43616; Sat, 21 Aug 2021 17:31:59 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CCD6DC4338F;
        Sat, 21 Aug 2021 17:31:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org CCD6DC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 3/3] rtlwifi: rtl8192de: fix array size limit in for-loop
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210803144949.79433-3-colin.king@canonical.com>
References: <20210803144949.79433-3-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210821173159.7AED7C43616@smtp.codeaurora.org>
Date:   Sat, 21 Aug 2021 17:31:59 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the size of the entire array is being used in a for-loop
> for the element count. While this works since the elements are u8
> sized, it is preferred to use ARRAY_SIZE to get the element count
> of the array.
> 
> Kudos to Joe Perches for spotting this issue.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Dropped per Colin's request.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210803144949.79433-3-colin.king@canonical.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

