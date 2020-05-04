Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 168AB1C3608
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 11:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728458AbgEDJr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 05:47:59 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:59370 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728344AbgEDJr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 05:47:58 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588585678; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=WM9/aRStIaPaqyNPtJJyM+h9b/Ec7TT+ctCUD/qlxj0=;
 b=cy3LcYWOZJpfMlJQdOkkBgMG26XhM0u6SZ/ICmb6+kK1nThIm7o85RASLadTciv4dX5Rw9jJ
 5KzwHODbAqb41SRPf46qNblMwkemChqGksWvifLz5IBMRXBDR7LGkOIBbT6MA4ajnrgbB+Qk
 IIS/SOAj0ag7MGlhev5Kl3VTEa4=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eafe4c5.7f106080c4c8-smtp-out-n02;
 Mon, 04 May 2020 09:47:49 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 265EFC433BA; Mon,  4 May 2020 09:47:48 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E0311C433D2;
        Mon,  4 May 2020 09:47:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E0311C433D2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] rtw88: fix spelling mistake "fimrware" ->
 "firmware"
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200424084733.7716-1-colin.king@canonical.com>
References: <20200424084733.7716-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200504094748.265EFC433BA@smtp.codeaurora.org>
Date:   Mon,  4 May 2020 09:47:48 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> There are spelling mistakes in two rtw_err error messages. Fix them.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Patch applied to wireless-drivers-next.git, thanks.

a6336094c3ab rtw88: fix spelling mistake "fimrware" -> "firmware"

-- 
https://patchwork.kernel.org/patch/11507317/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
