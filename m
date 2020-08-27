Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2866A254914
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 17:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgH0PUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 11:20:46 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:40271 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728725AbgH0LdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 07:33:19 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598527998; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=7LDSBdIs9MxK1D0YmJUtozSeAA1LtdaBUbnzb467+QY=;
 b=CMDsQQqW/9s52QTtON20woR8HkrriYiHV1XuQQWYEhRYPkwAXWGDk3JWvkObZRJ/iEp5cFjs
 o5bstDy0ltHRRPLb2CgUjbfIVa7SJl99Ao8GhRKnR7PN3fGBuA5nDN6LKJ3zp/VKpXqcT+aq
 yDOEn4h4PmJvnm1HeajJnUVTcHI=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 5f4799e515988fabe03b0f3a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 27 Aug 2020 11:32:53
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9794EC433A0; Thu, 27 Aug 2020 11:32:53 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 52A9AC433C6;
        Thu, 27 Aug 2020 11:32:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 52A9AC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] ath11k: fix error check on return from call to
 ath11k_core_firmware_request
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200819105712.51886-1-colin.king@canonical.com>
References: <20200819105712.51886-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200827113253.9794EC433A0@smtp.codeaurora.org>
Date:   Thu, 27 Aug 2020 11:32:53 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The call to ath11k_core_firmware_request is returning a pointer that
> can be set to an error code, however, this is not being checked.
> Instead ret is being incorrecly checked for the error return. Fix the
> error checking.
> 
> Addresses-Coverity: ("Logically dead code")
> Fixes: 7b57b2ddec21 ("ath11k: create a common function to request all firmware files")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

A similar patch has been already applied.

error: patch failed: drivers/net/wireless/ath/ath11k/qmi.c:1886
error: drivers/net/wireless/ath/ath11k/qmi.c: patch does not apply
stg import: Diff does not apply cleanly

Patch set to Rejected.

-- 
https://patchwork.kernel.org/patch/11723519/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

