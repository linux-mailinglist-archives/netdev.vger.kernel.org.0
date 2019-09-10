Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 934A8AEB7A
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 15:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732230AbfIJN0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 09:26:44 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:42080 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726394AbfIJN0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 09:26:43 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 91CAB6016D; Tue, 10 Sep 2019 13:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568122002;
        bh=zqYN9TIvb8LarZK+8eJvsrDczJXmcfvbrZQkTvUneDc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=GEyEZwDrI0j82BMA5t5tjkeTGp3TGfQLyltT+h4tZTH5QOq6p0wdfATFPJ1xe+e+x
         Ebta/H61Cq1kbfRrTAVWPJct7a50096QvURp6PsZY9Hp+L9zCm7ldk/SpoL3t5TBqY
         TSIydz/0F09Vyq73jgngMdxkbjT6eiyAwlkxAArk=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3CBD16016D;
        Tue, 10 Sep 2019 13:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568122001;
        bh=zqYN9TIvb8LarZK+8eJvsrDczJXmcfvbrZQkTvUneDc=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=HYZ8s6Shgh4IKV9FAwZUk4KmMMgYidyFUnuAt8p+6RFU0OHqw9m0lxhhc1fthWCiU
         cUDz1xnpFNmSUdr6VHWhJZBatSPkCFJ2ehohI+IRn3hxRz9LCuf7hvV33Q60/xu5eK
         Jb68uuhGwtuouqB8q5SHGSbcS1ORA+QYW8Orqpjw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3CBD16016D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath9k: Remove unneeded variable to store return value
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1567579428-16377-1-git-send-email-zhongjiang@huawei.com>
References: <1567579428-16377-1-git-send-email-zhongjiang@huawei.com>
To:     zhong jiang <zhongjiang@huawei.com>
Cc:     <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <zhongjiang@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190910132642.91CAB6016D@smtp.codeaurora.org>
Date:   Tue, 10 Sep 2019 13:26:42 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zhong jiang <zhongjiang@huawei.com> wrote:

> ath9k_reg_rmw_single do not need return value to cope with different
> cases. And change functon return type to void.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

45f09a1c5b85 ath9k: Remove unneeded variable to store return value

-- 
https://patchwork.kernel.org/patch/11129449/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

