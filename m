Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD5843C3F1
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 09:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240492AbhJ0Hee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 03:34:34 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:21084 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240493AbhJ0Hec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 03:34:32 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1635319927; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=n1pH7vEORGJwBJ/0+ijoKJa4bP1h2N8BGoeO6sfZt5k=;
 b=Z5rXebOZbSBn5F/v5WTKqmdhQQY8rMOzpqyUdDur1VP+SVDPTxjh16VEkddr3Lc5TVVy2bgD
 Wy48uvn3mBTBbnZxZpKb+EO6GzaUEtjqu1srpDnfjQ2TtaGeSH1a8XTEzikg7XXlWlLzL0a/
 0KxWf2ienmdQazpeiUQ1t6TJPco=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 617900759ef7bd81bd6a6745 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 27 Oct 2021 07:32:05
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 208E3C43618; Wed, 27 Oct 2021 07:32:05 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5BBA7C4338F;
        Wed, 27 Oct 2021 07:32:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 5BBA7C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wlcore: spi: Use dev_err_probe()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <465e76901b801ac0755088998249928fd546c08a.1634647460.git.geert+renesas@glider.be>
References: <465e76901b801ac0755088998249928fd546c08a.1634647460.git.geert+renesas@glider.be>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163531991942.30745.3411914074100956421.kvalo@codeaurora.org>
Date:   Wed, 27 Oct 2021 07:32:05 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Geert Uytterhoeven <geert+renesas@glider.be> wrote:

> Use the existing dev_err_probe() helper instead of open-coding the same
> operation.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Patch applied to wireless-drivers-next.git, thanks.

1aa3367ca78c wlcore: spi: Use dev_err_probe()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/465e76901b801ac0755088998249928fd546c08a.1634647460.git.geert+renesas@glider.be/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

