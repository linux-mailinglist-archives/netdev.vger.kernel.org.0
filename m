Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E097D26BC3F
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 08:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgIPGJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 02:09:54 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:30615 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbgIPGJy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 02:09:54 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600236593; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=2bsRWcOs2KtGCGJrBNPHMESg8+k8f8E/7bPkVcMV2Po=;
 b=EIQ7KYQXEi6PsooRMP0GlCtfMtXpki9O/zSLiHO+ROkksooI99xZpiQaA/IGK7AOwufn9kP0
 l9qzyBZWuzMnx5gYKDjpEOAggr4/Do9/u1zSZrMfgM+0YUX58qDpvWU2OD5az0bwskTMMUze
 W3pTEnPdmkZJrMQd4+9j2MeanDw=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5f61ac20698ee477d1bce67b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 16 Sep 2020 06:09:36
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 07FC9C433F1; Wed, 16 Sep 2020 06:09:36 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4786EC433C8;
        Wed, 16 Sep 2020 06:09:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4786EC433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] qtnfmac: Remove unused macro QTNF_DMP_MAX_LEN
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200909135951.4028-1-yuehaibing@huawei.com>
References: <20200909135951.4028-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <imitsyanko@quantenna.com>, <geomatsi@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200916060936.07FC9C433F1@smtp.codeaurora.org>
Date:   Wed, 16 Sep 2020 06:09:36 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> There is no caller in tree, so remove it.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

edadae4778b0 qtnfmac: Remove unused macro QTNF_DMP_MAX_LEN

-- 
https://patchwork.kernel.org/patch/11765841/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

