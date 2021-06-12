Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B92E3A4E3E
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 12:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhFLKkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 06:40:37 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:10388 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbhFLKkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 06:40:35 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623494315; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=VrXPNpDv7WacuPMGlLje+hrxsCRRKU7x5OH9JHGdD/E=;
 b=DnCgsrcJUIA99hLklq3EzPfNK01mqBUHywzWinAgqNAfytcrDIJTFvlbrtkkOSn3f9Qjlsp/
 JNDDOn8s5vjPLHxuaaRZFK7PyDhXfvyUGU3nlDRjEjxCa8iStYgWVF23p4WhmEcdCtj1PpHM
 wnKYImJUKnEcO0s3RgrDdAQ2/nk=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 60c48eabb6ccaab7537bd235 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 12 Jun 2021 10:38:35
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 494EEC4338A; Sat, 12 Jun 2021 10:38:35 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0D0B9C433D3;
        Sat, 12 Jun 2021 10:38:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0D0B9C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] ath10k: Fix W=1 build warning in htt_rx.c
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210526142219.2542528-1-yangyingliang@huawei.com>
References: <20210526142219.2542528-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>,
        <davem@davemloft.net>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210612103835.494EEC4338A@smtp.codeaurora.org>
Date:   Sat, 12 Jun 2021 10:38:35 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yang Yingliang <yangyingliang@huawei.com> wrote:

> Fix the following W=1 build warning:
> 
>   drivers/net/wireless/ath/ath10k/htt_rx.c:1790:7: warning: variable ‘more_frags’ set but not used [-Wunused-but-set-variable]
>    1790 |  bool more_frags;
>         |       ^~~~~~~~~~
> 
> Fixes: a1166b2653db ("ath10k: add CCMP PN replay protection for fragmented frames for PCIe")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

e0a6120f6816 ath10k: remove unused more_frags variable

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210526142219.2542528-1-yangyingliang@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

