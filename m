Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01182363173
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 19:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236842AbhDQR2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 13:28:25 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:62859 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236759AbhDQR2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 13:28:24 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1618680477; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=SyeI61oZ24scnndAVY7UeZAx6lkAez7VCTFBmV1gZmk=;
 b=A5kfkQJKxx9tkb7EzvjI23fQe5G9+yxB4aDKuQhEmZm2WD9Tny4C6e33mh8wfxqrwwWFE4wv
 BpazRbc/i+u1k5nxtyGnGp4t0hHZtfJVmESaGO29DUMreGdbdyhmES1nkZA539f9ysp+lNDg
 WWTU7HvrvpZcdBaCWox+0sKOBbg=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 607b1a9cfebcffa80f27d558 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 17 Apr 2021 17:27:56
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 67486C4338A; Sat, 17 Apr 2021 17:27:56 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A498BC433D3;
        Sat, 17 Apr 2021 17:27:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A498BC433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] qtnfmac: remove meaningless labels
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210223065754.34392-1-samirweng1979@163.com>
References: <20210223065754.34392-1-samirweng1979@163.com>
To:     samirweng1979 <samirweng1979@163.com>
Cc:     imitsyanko@quantenna.com, geomatsi@gmail.com, kuba@kernel.org,
        ohannes.berg@intel.com, dlebed@quantenna.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210417172756.67486C4338A@smtp.codeaurora.org>
Date:   Sat, 17 Apr 2021 17:27:56 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

samirweng1979 <samirweng1979@163.com> wrote:

> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> some function's label meaningless, the return statement follows
> the goto statement, so just remove it.
> 
> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
> Reviewed-by: Sergey Matyukevich <geomatsi@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

a221d0afbf39 qtnfmac: remove meaningless labels

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210223065754.34392-1-samirweng1979@163.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

