Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E22BA2649F3
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 18:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgIJQhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 12:37:41 -0400
Received: from a27-186.smtp-out.us-west-2.amazonses.com ([54.240.27.186]:34566
        "EHLO a27-186.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727035AbgIJQfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:35:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1599755708;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=0PT+vIyl1PoeZhnomnVBk6Rk41hJM44VFaoGQTbCFoo=;
        b=KoCbIREUQM0dfEuq3aDk8d4GZgl8qXtHs4Wb3lR557IQ18uz9IbbU+VRRhKO1zQ6
        dBsXmVL7swkggjl3xQPctbPZmtT+U2jkMjmtoZZ9DdUy3MVinchge8pC/Gmi1PjG1PM
        hLxsYkWezodhbsPMom8tKzJ8rVK0ASRebdgr1vnA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1599755708;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=0PT+vIyl1PoeZhnomnVBk6Rk41hJM44VFaoGQTbCFoo=;
        b=b4CRwJu/VsIOjn2SJRgR8PUsUJBOXF7+JwnJ3I0V+kVc/MYNy7j1+Tc+luGH2OUy
        oLUmCc2rNvLrmGWy3P8MR8mOGIkz6W5hD6rqZN66zA/9p9mNR9BZxO0nn2E4AgE5NLx
        AxDLUGAunDwkx2x/aWbbRSMEUSY5EuNivRWr1rUc=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 76771C433F0
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 27/29] ath9k: ar5008_initvals: Move ar5416Bank{0,1,2,3,7}
 to
 where they are used
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200910065431.657636-28-lee.jones@linaro.org>
References: <20200910065431.657636-28-lee.jones@linaro.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-ID: <0101017478dee7a5-d1bf9eb4-8ec4-44d0-bc89-11497cdf681c-000000@us-west-2.amazonses.com>
Date:   Thu, 10 Sep 2020 16:35:08 +0000
X-SES-Outgoing: 2020.09.10-54.240.27.186
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> wrote:

> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/wireless/ath/ath9k/ar5008_initvals.h:627:18: warning: ‘ar5416Bank7’ defined but not used [-Wunused-const-variable=]
>  627 | static const u32 ar5416Bank7[][2] = {
>  | ^~~~~~~~~~~
>  drivers/net/wireless/ath/ath9k/ar5008_initvals.h:548:18: warning: ‘ar5416Bank3’ defined but not used [-Wunused-const-variable=]
>  548 | static const u32 ar5416Bank3[][3] = {
>  | ^~~~~~~~~~~
>  drivers/net/wireless/ath/ath9k/ar5008_initvals.h:542:18: warning: ‘ar5416Bank2’ defined but not used [-Wunused-const-variable=]
>  542 | static const u32 ar5416Bank2[][2] = {
>  | ^~~~~~~~~~~
>  drivers/net/wireless/ath/ath9k/ar5008_initvals.h:536:18: warning: ‘ar5416Bank1’ defined but not used [-Wunused-const-variable=]
>  536 | static const u32 ar5416Bank1[][2] = {
>  | ^~~~~~~~~~~
>  drivers/net/wireless/ath/ath9k/ar5008_initvals.h:462:18: warning: ‘ar5416Bank0’ defined but not used [-Wunused-const-variable=]
>  462 | static const u32 ar5416Bank0[][2] = {
>  | ^~~~~~~~~~~
> 
> Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Already fixed in ath.git.

error: patch failed: drivers/net/wireless/ath/ath9k/ar5008_initvals.h:459
error: drivers/net/wireless/ath/ath9k/ar5008_initvals.h: patch does not apply
error: patch failed: drivers/net/wireless/ath/ath9k/ar5008_phy.c:18
error: drivers/net/wireless/ath/ath9k/ar5008_phy.c: patch does not apply
stg import: Diff does not apply cleanly

Patch set to Rejected.

-- 
https://patchwork.kernel.org/patch/11766769/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

