Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772F2273B88
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 09:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729784AbgIVHPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 03:15:09 -0400
Received: from z5.mailgun.us ([104.130.96.5]:37676 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729776AbgIVHPF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 03:15:05 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600758905; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=YQ/fWdaquh58Ptplm8zLwL0YmL9KIai8upADVMc42FM=;
 b=nStROMFB+JhNLAm8mJud8zKr+nfn6+KAzjjDKJwJJRYhmfucepYd5kOFbHqpsyyIR3aRtzdC
 df4by6bBmI0AJwBbX6fueravZD9o/NfJRi9u6OTyFNqbkuLlhn91UyEvvTZMTyUdkIjOYPFx
 nD2lSjFJ7QAc+q4ljqsQnTpRRSg=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 5f69a476aac060135417998c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 22 Sep 2020 07:15:02
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8DCAFC433F1; Tue, 22 Sep 2020 07:15:02 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B8F54C433C8;
        Tue, 22 Sep 2020 07:14:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B8F54C433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 2/5] wlcore: Remove unused function no_write_handler()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200918131305.20976-1-yuehaibing@huawei.com>
References: <20200918131305.20976-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>, <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200922071502.8DCAFC433F1@smtp.codeaurora.org>
Date:   Tue, 22 Sep 2020 07:15:02 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> There is no caller in tree, so can remove it.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

d0c8ff7c1e47 wlcore: Remove unused function no_write_handler()

-- 
https://patchwork.kernel.org/patch/11785047/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

