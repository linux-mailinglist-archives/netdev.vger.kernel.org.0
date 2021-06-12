Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05AF13A4E38
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 12:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbhFLKin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 06:38:43 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:42571 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231178AbhFLKik (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Jun 2021 06:38:40 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623494201; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=brVC1m2uQ7jacnf+j+PhnRqs+Cy6+AllMm/70hQRjPg=;
 b=xWsZw7lL+v4s/gGWwEKPkgxLsmNLG1Q+7y9/AaElWWYZcgr1v8etz3HYctOaGTRdFN5yAsuA
 oWjfigxjf08cj3dvBGyR+BsgmnDpFR2KOHJ/xYPitDtD6gIOJ27ge45V+uU2gWYmq/ttjm/d
 C+d8YCSjPc5C3GxRTmXRFhrq22Y=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 60c48e38f726fa41884fba3c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 12 Jun 2021 10:36:40
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2FD93C433F1; Sat, 12 Jun 2021 10:36:40 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EEF44C433F1;
        Sat, 12 Jun 2021 10:36:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EEF44C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: demote chan info without scan request warning
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210522171609.299611-1-caleb@connolly.tech>
References: <20210522171609.299611-1-caleb@connolly.tech>
To:     Caleb Connolly <caleb@connolly.tech>
Cc:     caleb@connolly.tech, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210612103640.2FD93C433F1@smtp.codeaurora.org>
Date:   Sat, 12 Jun 2021 10:36:40 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Caleb Connolly <caleb@connolly.tech> wrote:

> Some devices/firmwares cause this to be printed every 5-15 seconds,
> though it has no impact on functionality. Demote this to a debug
> message.
> 
> Signed-off-by: Caleb Connolly <caleb@connolly.tech>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

On what hardware and firmware version do you see this?

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210522171609.299611-1-caleb@connolly.tech/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

