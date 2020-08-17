Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C7C246478
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 12:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgHQKZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 06:25:51 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:60608 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726596AbgHQKZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 06:25:50 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1597659950; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=afrx+GYTeGfAA0L5NcErG+Sw5Rx8q7wQPJGJJR8T2QM=;
 b=N5EIPrGnK9U89T/j0XhR+5mz+wno3AEPQPi4mKCSXbAOc++KUHk9zMuwA9T3eVz6x3oxcS9D
 dUvf4JhpIfnJi1JvzRxDJSRDgiVByVCLMVBTMRlCTkiGvaHcNXKWFzagez7uRxvSenP/eoug
 +u91VkRs60DMyIlu4TzeZzZkJKM=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5f3a5b2385672017516cb4a4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 17 Aug 2020 10:25:39
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B2742C433C6; Mon, 17 Aug 2020 10:25:38 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 04D70C433CA;
        Mon, 17 Aug 2020 10:25:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 04D70C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Fix the size used in a 'dma_free_coherent()' call
 in
 an error handling path
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200802122227.678637-1-christophe.jaillet@wanadoo.fr>
References: <20200802122227.678637-1-christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, kuba@kernel.org, pillair@codeaurora.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200817102538.B2742C433C6@smtp.codeaurora.org>
Date:   Mon, 17 Aug 2020 10:25:38 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> Update the size used in 'dma_free_coherent()' in order to match the one
> used in the corresponding 'dma_alloc_coherent()'.
> 
> Fixes: 1863008369ae ("ath10k: fix shadow register implementation for WCN3990")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Reviewed-by: Rakesh Pillai <pillair@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

454530a9950b ath10k: Fix the size used in a 'dma_free_coherent()' call in an error handling path

-- 
https://patchwork.kernel.org/patch/11696383/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

