Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D983A181E4A
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 17:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730237AbgCKQw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 12:52:26 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:46259 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730175AbgCKQwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 12:52:25 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1583945545; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=13ER7EC6tNsem5IUYhvbU5i7rUU+ucV6ONkTZXwQszY=;
 b=bb8MHUqODHAdKnV3MLwXrFf9400G0ea9K66iLFUF9ZYn/pmv6sD9Xpi7Ck9XrVfaq/tZ0rmO
 /Uk95jV24K8Y2hO+JRhTqnSzS8/wMQaxHp33rXMocMt00Ve9pRFCb5t2R1pBi6Bs7+2eZm5t
 SW3bYRQP+7L8djn/vopjBLBj/88=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e69173f.7fa8321f8340-smtp-out-n02;
 Wed, 11 Mar 2020 16:52:15 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4AE34C433CB; Wed, 11 Mar 2020 16:52:15 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D0E1FC433CB;
        Wed, 11 Mar 2020 16:52:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D0E1FC433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath5k: Add proper dependency for ATH5K_AHB
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200224182447.4054-1-krzk@kernel.org>
References: <20200224182447.4054-1-krzk@kernel.org>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Jiri Slaby <jirislaby@gmail.com>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200311165215.4AE34C433CB@smtp.codeaurora.org>
Date:   Wed, 11 Mar 2020 16:52:15 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Krzysztof Kozlowski <krzk@kernel.org> wrote:

> The CONFIG_ATH5K_AHB could be enabled on ATH25 system without enabling
> ATH5K driver itself.  This does not make sense because CONFIG_ATH5K_AHB
> controls object build within drivers/net/wireless/ath/ath5k/ so enabling
> it without CONFIG_ATH5K brings nothing.
> 
> Add proper dependency to CONFIG_ATH5K_AHB.
> 
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

c98cdaef931c ath5k: Add proper dependency for ATH5K_AHB

-- 
https://patchwork.kernel.org/patch/11401313/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
