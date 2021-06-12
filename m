Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A863B3A4E35
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 12:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbhFLKgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 06:36:51 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:23179 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbhFLKgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 06:36:49 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623494090; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=Lwmlq36y7lSeGqVRPg7L2zIKwMXO5Z6J8ulWWFB46BI=;
 b=W1d9aA+AJ88cYtrhbl/is3Pj1zmV1pVUIP+dykwcCyTlAVrEMMLWPLIXRQs1j7V42jSWI6Q0
 brn+Wk0COuE1KmVXNjCE4w1fMHkC3voFk8rKYM2QiYfDUMhkEGh8tr6rftg8zjl1lYV4tVJd
 cGe8QxRu5WT6GkAUjEgXH6/9M3w=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 60c48dc4e27c0cc77f3e7729 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 12 Jun 2021 10:34:44
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2E050C433F1; Sat, 12 Jun 2021 10:34:44 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6E59EC433D3;
        Sat, 12 Jun 2021 10:34:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6E59EC433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH -next 1/2] ath10k: go to path err_unsupported when chip id
 is
 not supported
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210522105822.1091848-2-yangyingliang@huawei.com>
References: <20210522105822.1091848-2-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210612103444.2E050C433F1@smtp.codeaurora.org>
Date:   Sat, 12 Jun 2021 10:34:44 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yang Yingliang <yangyingliang@huawei.com> wrote:

> When chip id is not supported, it go to path err_unsupported
> to print the error message.
> 
> Fixes: f8914a14623a ("ath10k: restore QCA9880-AR1A (v1) detection")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

2 patches applied to ath-next branch of ath.git, thanks.

9e88dd431d23 ath10k: go to path err_unsupported when chip id is not supported
e2783e2f39ba ath10k: add missing error return code in ath10k_pci_probe()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210522105822.1091848-2-yangyingliang@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

