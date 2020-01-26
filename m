Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 699E5149B7E
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 16:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbgAZPkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 10:40:20 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:61852 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726275AbgAZPkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 10:40:20 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580053219; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=OF9fRbiOS6tzfpTdXJ/mEBq3doMM9zm/VxgXYRmkFP8=;
 b=J3aDGqtb2heOnauDr4lirj1//9oZRGk+SFS6wphh3jBZpMg6PkhqmHVq9ofvZ0m+B3vcqBnu
 1ltDEOzrbR78SmytGc2RePFGoUN6WOUo8sGv+06xFwLkEdkt2TKHyHNsQr9YV0x+p3E5nGmy
 5aCcFhwmZHHtXrM8e1JYS2VfJRU=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e2db2de.7f84087ed228-smtp-out-n03;
 Sun, 26 Jan 2020 15:40:14 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5E46AC433A2; Sun, 26 Jan 2020 15:40:14 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 66EB6C433CB;
        Sun, 26 Jan 2020 15:40:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 66EB6C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/9] rtlwifi: rtl8192cu: Fix typo
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191223123715.7177-2-amade@asmblr.net>
References: <20191223123715.7177-2-amade@asmblr.net>
To:     =?utf-8?q?Amadeusz_S=C5=82awi=C5=84ski?= <amade@asmblr.net>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org,
        =?utf-8?q?Amadeusz_?==?utf-8?q?S=C5=82awi=C5=84ski?= 
        <amade@asmblr.net>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200126154014.5E46AC433A2@smtp.codeaurora.org>
Date:   Sun, 26 Jan 2020 15:40:14 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Amadeusz Sławiński wrote:

> Replace USB_VENDER_ID_REALTEK with USB_VENDOR_ID_REALTEK.
> 
> Signed-off-by: Amadeusz Sławiński <amade@asmblr.net>

9 patches applied to wireless-drivers-next.git, thanks.

fd156bdf62bb rtlwifi: rtl8192cu: Fix typo
5d3f9145f54e rtlwifi: rtl8188ee: Make functions static & rm sw.h
be913e3f49ac rtlwifi: rtl8192ce: Make functions static & rm sw.h
a3cda3c363ca rtlwifi: rtl8192cu: Remove sw.h header
fef8a2d969af rtlwifi: rtl8192ee: Make functions static & rm sw.h
5b2640835a34 rtlwifi: rtl8192se: Remove sw.h header
c218acfaa637 rtlwifi: rtl8723ae: Make functions static & rm sw.h
02a214e29ea4 rtlwifi: rtl8723be: Make functions static & rm sw.h
8ddd4a2a6b59 rtlwifi: rtl8821ae: Make functions static & rm sw.h

-- 
https://patchwork.kernel.org/patch/11308205/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
