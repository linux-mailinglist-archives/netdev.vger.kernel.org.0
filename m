Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5938141FB17
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 13:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbhJBLUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 07:20:33 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:33251 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232621AbhJBLUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 07:20:32 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633173526; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=XbOlq0yV9tI+HC++0Jz6+JIOkLBrknbCOV4MG10Kd6w=; b=dEOgSqHGhqTE9DvVARiJYVPo8pdsmuXRgNGEvFgaaLRZyRW58bgXv7nDh1UNwZkkIm8urmh+
 Hun+2CeITy2mZPQWordX/JiNY2Po82VvK7l3GlpVVr4B/QqE7SpiKKxc7UxthpZnScjki09H
 Ajar4pRYtKj6OeAgE1EJjvUEujQ=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 61584015a5a9bab6e8a6be61 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 02 Oct 2021 11:18:45
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1258DC43616; Sat,  2 Oct 2021 11:18:45 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CDD89C4338F;
        Sat,  2 Oct 2021 11:18:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org CDD89C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     "David S. Miller" <davem@davemloft.net>,
        ath9k-devel@qca.qualcomm.com,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: Two ath9k_htc fixes
References: <77b76ac8-2bee-6444-d26c-8c30858b8daa@i-love.sakura.ne.jp>
        <dfe7d982-2f6a-325a-c257-6d039033a2ed@i-love.sakura.ne.jp>
Date:   Sat, 02 Oct 2021 14:18:37 +0300
In-Reply-To: <dfe7d982-2f6a-325a-c257-6d039033a2ed@i-love.sakura.ne.jp>
        (Tetsuo Handa's message of "Sat, 2 Oct 2021 18:29:51 +0900")
Message-ID: <87tuhzhdyq.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> writes:

> I don't know whether these patches can fix all races.
> But since no response from ath9k maintainers/developers,
> can you directly pick up these patches via your tree?

Dave, please do not take ath9k patches. It seems that all ath9k syzbot
fixes are of questionable quality, and at least some of them have
created regressions, so they need to be tested on a real device before I
apply them. I asked for help but nobody cared, so I now need to create
an ath9k_htc test setup myself and that will take a while.

Tetsuo, the patches are on my deferred queue and you can follow the
status via patchwork:

https://patchwork.kernel.org/project/linux-wireless/list/?series=550357&state=*

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
