Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 794FA3B1FCF
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 19:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhFWRpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 13:45:54 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:36106 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhFWRpy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 13:45:54 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624470216; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=Fo76TQE8/Q9kJ4wak7m7iAqEc/68VzHBctu+NI++WyQ=;
 b=Ha/VoqYQzeKzHpmKIajpQ8IE0GsOO9dV5A7mt0Sjv6N2jpdNqbZD5efci8uI7NOM8GspLj/P
 EC7FbUIpGDNEzdfnpBFZlQMFyzIkCChufdkmBFq/laBHG+i4jrdiqLkrK9mP4E4z+c4ZFu6n
 q/4xXDEyGbRKP8PusYHgfBCWSAU=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 60d372bf638039e9971c3ca0 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 23 Jun 2021 17:43:27
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0FF14C43143; Wed, 23 Jun 2021 17:43:27 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8FE1FC4323A;
        Wed, 23 Jun 2021 17:43:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8FE1FC4323A
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtw88: 8822c: Fix duplicate included coex.h
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1620470153-25018-1-git-send-email-jiapeng.chong@linux.alibaba.com>
References: <1620470153-25018-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     tony0620emma@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210623174327.0FF14C43143@smtp.codeaurora.org>
Date:   Wed, 23 Jun 2021 17:43:27 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiapeng Chong <jiapeng.chong@linux.alibaba.com> wrote:

> Clean up the following includecheck warning:
> 
> ./drivers/net/wireless/realtek/rtw88/rtw8822c.c: coex.h is included more
> than once.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

This was fixed by an earlier patch:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-
next.git/commit/?id=3eab8ca6b1756d551da42e958c6f48f68cf470d3

Patch set to Superseded.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1620470153-25018-1-git-send-email-jiapeng.chong@linux.alibaba.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

