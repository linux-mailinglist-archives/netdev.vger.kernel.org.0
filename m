Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D4B3A809A
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 15:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbhFONlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 09:41:07 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:13184 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231709AbhFONkp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 09:40:45 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623764321; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=sKsSOWucqGgH3ur3EcwsTOp/csCK6kROKn0ljqTvDh8=;
 b=uuzvSMK6aHuMDjev2UP3WF+mw1pE4NG9+JqNZ10dJZyvkIjwfp/guJ3SSDEdu5R+oIr+qaqn
 eET30yMV68bRRv30Z5SlPc62Bhs7OkIKjnHKRBPJRtJcUqCKequn/HRbcX53Ps52OfpEw8Yn
 5tpGgc0Rn0xYpz3/67Dndzy4Ln0=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 60c8ad48e27c0cc77f21cff7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 15 Jun 2021 13:38:16
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 48CE4C433D3; Tue, 15 Jun 2021 13:38:15 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 144CAC433F1;
        Tue, 15 Jun 2021 13:38:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 144CAC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/1] rtlwifi: btcoex: 21a 2ant: Delete several duplicate
 condition branch codes
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210510082237.3315-1-thunder.leizhen@huawei.com>
References: <20210510082237.3315-1-thunder.leizhen@huawei.com>
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Zhen Lei <thunder.leizhen@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210615133815.48CE4C433D3@smtp.codeaurora.org>
Date:   Tue, 15 Jun 2021 13:38:15 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zhen Lei <thunder.leizhen@huawei.com> wrote:

> The statements of the "if (max_interval == 3)" branch are the same as
> those of the "else" branch. Delete them to simplify the code.
> 
> No functional change.
> 
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

d56b69c4fbc7 rtlwifi: btcoex: 21a 2ant: Delete several duplicate condition branch codes

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210510082237.3315-1-thunder.leizhen@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

