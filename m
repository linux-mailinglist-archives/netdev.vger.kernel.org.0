Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9227E149BAC
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 16:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbgAZPt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 10:49:58 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:15675 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726079AbgAZPt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 10:49:57 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580053797; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=0ACMIx0vNvxE/ZpblsQ/pYyMZSg0rEuOGRCaibRFMx8=;
 b=X1AaiMlrCKB8tIBeoTgLbwd3XZEI1juBH7MMNO2u6PCVr3tIOBbL8HQQDDggD2GQjTZQ2HOv
 LCyRImP7HZ1mfScpq/VFGx6cRDfyQd6WsejMd24L/r0Rx7kEeMm3V9H7rg3azndjuQP4SP1T
 RMd+/aqmJKiE3D0KqDu7ObnWLJY=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e2db524.7f8eeb65c3e8-smtp-out-n02;
 Sun, 26 Jan 2020 15:49:56 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 019D1C433A2; Sun, 26 Jan 2020 15:49:55 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AD08EC433CB;
        Sun, 26 Jan 2020 15:49:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AD08EC433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: fix spelling mistake
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200124043433.GA3024@google.com>
References: <20200124043433.GA3024@google.com>
To:     Saurav Girepunje <saurav.girepunje@gmail.com>
Cc:     pkshih@realtek.com, davem@davemloft.net, Larry.Finger@lwfinger.net,
        saurav.girepunje@gmail.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        saurav.girepunje@hotmail.com
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200126154955.019D1C433A2@smtp.codeaurora.org>
Date:   Sun, 26 Jan 2020 15:49:55 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Saurav Girepunje <saurav.girepunje@gmail.com> wrote:

> fix spelling mistake reported by checkpatch in trx.c .
> 
> Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>

Failed to apply to wireless-drivers-next, please rebase and resend as
v2.

error: patch failed: drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c:276
error: drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c: patch does not apply
error: Did you hand edit your patch?
It does not apply to blobs recorded in its index.
Applying: rtlwifi: fix spelling mistake
Using index info to reconstruct a base tree...
Patch failed at 0001 rtlwifi: fix spelling mistake
The copy of the patch that failed is found in: .git/rebase-apply/patch

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/11349731/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
