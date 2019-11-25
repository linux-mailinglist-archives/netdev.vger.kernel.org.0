Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F57C108D9A
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 13:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbfKYMLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 07:11:22 -0500
Received: from a27-21.smtp-out.us-west-2.amazonses.com ([54.240.27.21]:52064
        "EHLO a27-21.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725828AbfKYMLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 07:11:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574683880;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=dZsCIhysheSA6zhrVti9PRmRDfktYhj5NEIj4Sd9LIY=;
        b=es9llh8fC7Y8D0ISBR7qEK0u7P4lfHdlaza4Z+EJdm9ZQHfh3IiXP4M/q7jqGIpR
        qLc6H57ITuSe3+wuhs7dirjbLupnCSmtWXVMFP91Xvtr8kU2RUaBP3a2ST4p9E3P16l
        F9qk0DHJ17mrKMskc+sV0lXB+a9sMm4K/ZUZLoYs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574683880;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=dZsCIhysheSA6zhrVti9PRmRDfktYhj5NEIj4Sd9LIY=;
        b=M1g5Sb/rA3VojiI75WPCHYvfDUrOsSn/WjFegV2bBqepgce+Mjf37+drstQhar/V
        fGk9jOm9ZgPmhS1RfrKOKho/xoZa2YXThAk8hzd8U4TZb2h3L9lN4C4DRToxxIfg/mk
        HqqW4mfpYuou8J0SEEb+0dAXfbrkesS+MODQFazM=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C1961C447B4
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] ath10k: Handle "invalid" BDFs for msm8998 devices
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191113154646.43048-1-jeffrey.l.hugo@gmail.com>
References: <20191113154646.43048-1-jeffrey.l.hugo@gmail.com>
To:     Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Cc:     davem@davemloft.net, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-ID: <0101016ea2792bf8-85cec4e9-f426-43ba-89a1-242f2308e25e-000000@us-west-2.amazonses.com>
Date:   Mon, 25 Nov 2019 12:11:20 +0000
X-SES-Outgoing: 2019.11.25-54.240.27.21
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jeffrey Hugo <jeffrey.l.hugo@gmail.com> wrote:

> When the BDF download QMI message has the end field set to 1, it signals
> the end of the transfer, and triggers the firmware to do a CRC check.  The
> BDFs for msm8998 devices fail this check, yet the firmware is happy to
> still use the BDF.  It appears that this error is not caught by the
> downstream drive by concidence, therefore there are production devices
> in the field where this issue needs to be handled otherwise we cannot
> support wifi on them.  So, attempt to detect this scenario as best we can
> and treat it as non-fatal.
> 
> Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
> Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

319c2b71041f ath10k: Handle "invalid" BDFs for msm8998 devices

-- 
https://patchwork.kernel.org/patch/11242143/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

