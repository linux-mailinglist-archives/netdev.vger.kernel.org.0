Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1A31CEE2A
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 09:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbgELHep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 03:34:45 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:31387 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729104AbgELHel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 03:34:41 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1589268881; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=uFiuGc8W66I7hSPinkBYZFyZWCjdkRgvzWyfPckBQg4=;
 b=rmXCDJUcYZP6352Y/4LTdL5g+YiTm5VI63HqKH8Bwy2r5dQWZc1NvZK5YGYvFjjaml3K0+XZ
 ajwZurOheInTJoMbZYPwI4w6XwCAi49OaNdlEZSrjmCtdZiEE6ptQFfQzgR8TaBFGUXxIeQ3
 fxdWXr1hRB8ebICCPkh7uWjn1FI=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eba5182.7f4fa1cc5c38-smtp-out-n05;
 Tue, 12 May 2020 07:34:26 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0C16DC433F2; Tue, 12 May 2020 07:34:25 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2003FC433BA;
        Tue, 12 May 2020 07:34:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2003FC433BA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] ath11k: remove redundant initialization of pointer
 info
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200507164318.56570-1-colin.king@canonical.com>
References: <20200507164318.56570-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200512073425.0C16DC433F2@smtp.codeaurora.org>
Date:   Tue, 12 May 2020 07:34:25 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> Pointer info is being assigned twice, once at the start of the function
> and secondly when it is just about to be accessed. Remove the redundant
> initialization and keep the original assignment to info that is close
> to the memcpy that uses it.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

52b776fa5921 ath11k: remove redundant initialization of pointer info

-- 
https://patchwork.kernel.org/patch/11534415/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
