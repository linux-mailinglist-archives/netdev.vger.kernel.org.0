Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5A53D9EE2
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 09:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234766AbhG2HlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 03:41:04 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:17027 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234744AbhG2HlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 03:41:02 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1627544460; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=mcywrMBdeZuhSxrWCJBQ0eAZkSiyZjSxKVnAJ98rhvY=; b=tGGmCN+A7g7HwLFq2JFfRUGOrSD3SLplfDIpJs05sTo0raEI006f1GiNjs4nV94X7nBWW6OO
 yuYlwprS9daPa1RYkg4Rt09iJe5w41+mCOMTbTgGNa6o9jQS8/OIYTvTEyR0hjCymU6Admah
 ufeofldKV3f/aJjbn4Hnv2GAXzE=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 61025b869771b05b24496bd9 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 29 Jul 2021 07:40:54
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 75D6AC4323A; Thu, 29 Jul 2021 07:40:54 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 47CC0C4338A;
        Thu, 29 Jul 2021 07:40:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 47CC0C4338A
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Rajat Asthana <rajatasthana4@gmail.com>
Cc:     ath9k-devel@qca.qualcomm.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k_htc: Add a missing spin_lock_init()
References: <20210727214358.466397-1-rajatasthana4@gmail.com>
        <87y29qgbff.fsf@codeaurora.org>
        <738fa8cc-c9c4-66c1-e2ee-fe02caa7ef63@gmail.com>
Date:   Thu, 29 Jul 2021 10:40:47 +0300
In-Reply-To: <738fa8cc-c9c4-66c1-e2ee-fe02caa7ef63@gmail.com> (Rajat Asthana's
        message of "Thu, 29 Jul 2021 00:32:38 +0530")
Message-ID: <87lf5pftz4.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rajat Asthana <rajatasthana4@gmail.com> writes:

>> Did you test this on a real device?
>
> No, I didn't test this on a real device. Syzkaller has a reproducer
> for this and I just relied on the fact that the reproducer did not
> reproduce the warning with this patch.

This is exactly what worries me with syzbot patches. People just try to
silence the warning and not thinking how it works on a real device.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
