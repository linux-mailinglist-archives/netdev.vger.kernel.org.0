Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9027C428000
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 10:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbhJJIHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 04:07:42 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:50099 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbhJJIHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 04:07:41 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633853144; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=wy5oGgHXHFfW9iRMrwRZpKSh4hSbPBqGPKIz53A8Ibc=;
 b=sDKtQ4ZdU/GoUZ72EO/NAPFNmLC56VUbOMD/YLZuewR+VBtTxL28VL5eWQpe0eF0cKnu8Bwl
 x+9z5gldrgjJrMzhilnVQqDEd8kxpTwCTDIdr5oE22XhanItEERaNxHLcUw3jCYekRBAN5iI
 jcbEEV6d5GoUN2/NFpavfAuh4nM=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 61629ec10605239689df30d6 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 10 Oct 2021 08:05:21
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1C484C43460; Sun, 10 Oct 2021 08:05:21 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 08E66C4338F;
        Sun, 10 Oct 2021 08:05:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 08E66C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] carl9170: Fix error return -EAGAIN if not started
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20211008001558.32416-1-colin.king@canonical.com>
References: <20211008001558.32416-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Christian Lamparter <chunkeey@googlemail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "John W . Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163385309381.29673.3202738033184548655.kvalo@codeaurora.org>
Date:   Sun, 10 Oct 2021 08:05:21 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> There is an error return path where the error return is being
> assigned to err rather than count and the error exit path does
> not return -EAGAIN as expected. Fix this by setting the error
> return to variable count as this is the value that is returned
> at the end of the function.
> 
> Addresses-Coverity: ("Unused value")
> Fixes: 00c4da27a421 ("carl9170: firmware parser and debugfs code")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

I assume there will be v2 so dropping this version.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211008001558.32416-1-colin.king@canonical.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

