Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7C3125163
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 20:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727563AbfLRTJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 14:09:53 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:53979 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726977AbfLRTJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 14:09:52 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576696191; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=9FmfKq8lX65gFLtKmYO1d5wTTZANyQDiYN2cm9uFzg0=;
 b=ZErvcHW8FEn+KyASx0tfuRJofizYsf0Z88gC+Ccd80C66A8UI12yx9uZi4t6YmlLLEPKj+g5
 hyThWemolw4RVdvUwz7FeOzspI2s3JDNsfF9/7yzN6y2S5qI5g0yNOqqpqjORTfNfjCbYelC
 gzwM1WvLDfYGxr5WxJNpUjyHl4Q=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5dfa797d.7fd587501650-smtp-out-n03;
 Wed, 18 Dec 2019 19:09:49 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8FD16C43383; Wed, 18 Dec 2019 19:09:49 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 85FD3C433CB;
        Wed, 18 Dec 2019 19:09:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 85FD3C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] orinoco: avoid assertion in case of NULL pointer
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191215195900.6109-1-pakki001@umn.edu>
References: <20191215195900.6109-1-pakki001@umn.edu>
To:     Aditya Pakki <pakki001@umn.edu>
Cc:     pakki001@umn.edu, kjlu@umn.edu,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191218190949.8FD16C43383@smtp.codeaurora.org>
Date:   Wed, 18 Dec 2019 19:09:49 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Aditya Pakki <pakki001@umn.edu> wrote:

> In ezusb_init, if upriv is NULL, the code crashes. However, the caller
> in ezusb_probe can handle the error and print the failure message.
> The patch replaces the BUG_ON call to error return.
> 
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>

Patch applied to wireless-drivers-next.git, thanks.

c705f9fc6a17 orinoco: avoid assertion in case of NULL pointer

-- 
https://patchwork.kernel.org/patch/11293143/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
