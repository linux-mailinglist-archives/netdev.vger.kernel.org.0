Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96B41CDA21
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 14:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730112AbgEKMiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 08:38:01 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:63482 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730104AbgEKMiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 08:38:01 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1589200680; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=XBpzjIe7dN38lP66VoHoHkV2Q6Si8+j8wos5b3eZkDU=;
 b=i4AUia9yMyoMOmb5aEhHEt9VAzcYiAiGFwpYV+Hndw/60EUQSG7rR7BVwSuSk6flB0q+HOHu
 x+rh1ea1zb62v1HBkKB0uNabWYr8d1L2Ux7IRTLjTfOOGd5nrdI+GwmXUKJ7JPHnJ4YNMpzb
 ji+lqJrBeu/cZzHYJs+xI3COEvs=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eb94719.7fa958f07260-smtp-out-n05;
 Mon, 11 May 2020 12:37:45 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BBD65C433CB; Mon, 11 May 2020 12:37:45 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0919EC433F2;
        Mon, 11 May 2020 12:37:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0919EC433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wcn36xx: Fix error handling path in 'wcn36xx_probe()'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200507043619.200051-1-christophe.jaillet@wanadoo.fr>
References: <20200507043619.200051-1-christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, bjorn.andersson@linaro.org,
        marcel@holtmann.org, andy.gross@linaro.org,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200511123745.BBD65C433CB@smtp.codeaurora.org>
Date:   Mon, 11 May 2020 12:37:45 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> In case of error, 'qcom_wcnss_open_channel()' must be undone by a call to
> 'rpmsg_destroy_ept()', as already done in the remove function.
> 
> Fixes: 5052de8deff5 ("soc: qcom: smd: Transition client drivers from smd to rpmsg")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

a86308fc534e wcn36xx: Fix error handling path in 'wcn36xx_probe()'

-- 
https://patchwork.kernel.org/patch/11532419/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
