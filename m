Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E050F41AA8D
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 10:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239591AbhI1I0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 04:26:19 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:18442 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239568AbhI1I0S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 04:26:18 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1632817479; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=/J3WgXBQexzgk6jFJ2cFLXTOIQ/hy9vUhIyILCLwDKw=;
 b=lsdZWYY9SOpIPfXP5YzB/XEzC2CWZDaDQoPQFFcwN2D+dCrbFy9Dhc4P8IkddAoLnyW+J7Kr
 LDi1hN2VwgK8y7Vb/lqi5valV7ssJL4kgaSwDntD0CFphWZal0mNrhcgprOILpE5k4vlYdN7
 lXsgCU/wa5MoBuN0zO7/XPCA0ls=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 6152d14647d64efb6db086a3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 28 Sep 2021 08:24:38
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CCB84C4360D; Tue, 28 Sep 2021 08:24:37 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7A019C4360C;
        Tue, 28 Sep 2021 08:24:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 7A019C4360C
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ipw2200: Fix a function name in print messages
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210925124621.197-1-caihuoqing@baidu.com>
References: <20210925124621.197-1-caihuoqing@baidu.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     <caihuoqing@baidu.com>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210928082437.CCB84C4360D@smtp.codeaurora.org>
Date:   Tue, 28 Sep 2021 08:24:37 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cai Huoqing <caihuoqing@baidu.com> wrote:

> Use dma_alloc_coherent() instead of pci_alloc_consistent(),
> because only dma_alloc_coherent() is called here.
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>

Patch applied to wireless-drivers-next.git, thanks.

a8e5387f8362 ipw2200: Fix a function name in print messages

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210925124621.197-1-caihuoqing@baidu.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

