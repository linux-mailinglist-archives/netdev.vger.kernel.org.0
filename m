Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3CBE2649C1
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 18:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgIJQar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 12:30:47 -0400
Received: from a27-188.smtp-out.us-west-2.amazonses.com ([54.240.27.188]:51052
        "EHLO a27-188.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726612AbgIJQal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:30:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1599755440;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=PSzMYC4YNqc6rv73jtWgLdWzj8wLx0nM62wh0UhzA3w=;
        b=QMpbJZtggpUxK/s7kMxhd201XxmhOgurjCbKBVNnWtEczOeB6s6zzFmTPuQd7vtH
        Q5HIzXEgAIcz/zUO/2qcuvAvvgPjNVE9jMOORHIO/LAQNQT2DNBdyCefw2etp3HlKxI
        k4yT0IboyVkkHRj2JwE8hYdMsOw1+oxByGUCFbqE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1599755440;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=PSzMYC4YNqc6rv73jtWgLdWzj8wLx0nM62wh0UhzA3w=;
        b=L+tFjzKy9zpXIj5hgvu8FvfmSOdL22JXUjaBvL3JmUa+qx5RtcvoUChAlETfCR/A
        RWJtKKeZ4KQJQ7eMG0x8JCjALZiVFnYuulpfHHujisjd2BcQvHMUtqVqIfkDUKjD/MK
        2oKxTOqIZgBr9qxUuBxxBKRFLJ+Uc4Szp7mZ0huI=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3B64DC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 23/29] ath6kl: wmi: Remove unused variable 'rate'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200910065431.657636-24-lee.jones@linaro.org>
References: <20200910065431.657636-24-lee.jones@linaro.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-ID: <0101017478dad1ec-ffcb8c6b-abde-41f9-b802-2fea9970bd9b-000000@us-west-2.amazonses.com>
Date:   Thu, 10 Sep 2020 16:30:40 +0000
X-SES-Outgoing: 2020.09.10-54.240.27.188
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> wrote:

> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/wireless/ath/ath6kl/wmi.c: In function ‘ath6kl_wmi_bitrate_reply_rx’:
>  drivers/net/wireless/ath/ath6kl/wmi.c:1204:6: warning: variable ‘rate’ set but not used [-Wunused-but-set-variable]
> 
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Already fixed in ath.git.

error: patch failed: drivers/net/wireless/ath/ath6kl/wmi.c:1201
error: drivers/net/wireless/ath/ath6kl/wmi.c: patch does not apply
stg import: Diff does not apply cleanly

Patch set to Rejected.

-- 
https://patchwork.kernel.org/patch/11766815/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

