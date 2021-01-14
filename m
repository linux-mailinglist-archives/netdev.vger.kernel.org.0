Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB8152F67A7
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 18:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbhANR2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 12:28:55 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:56445 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727228AbhANR2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 12:28:54 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610645315; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=DaBLbfJDzwWM9O6UGymDiAuofmyWv44lE2eMuRLnp7w=;
 b=JweGDrPqsNbiqyjChP+8X2VqyPv4L/1V3uOjCVdn5lZ5/rQKam7lgmpetqBFTPFNXH5RMuM7
 Nf6bna7RDkZ9rp43BhnCGlwn3z3vLQEz9yc/DXf4mSZy5GxPYdgjmElAknoTVbGt+wHcae3+
 9NUjED4k7WFeE6xgdF6S4nSaYho=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-east-1.postgun.com with SMTP id
 60007f3c8fb3cda82fa897c8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 14 Jan 2021 17:28:28
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5E62FC433ED; Thu, 14 Jan 2021 17:28:27 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3E75CC433C6;
        Thu, 14 Jan 2021 17:28:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3E75CC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mwifiex: pcie: Drop bogus __refdata annotation
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201211133835.2970384-1-geert+renesas@glider.be>
References: <20201211133835.2970384-1-geert+renesas@glider.be>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210114172827.5E62FC433ED@smtp.codeaurora.org>
Date:   Thu, 14 Jan 2021 17:28:27 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Geert Uytterhoeven <geert+renesas@glider.be> wrote:

> As the Marvell PCIE WiFi-Ex driver does not have any code or data
> located in initmem, there is no need to annotate the mwifiex_pcie
> structure with __refdata.  Drop the annotation, to avoid suppressing
> future section warnings.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Patch applied to wireless-drivers-next.git, thanks.

596c84c49f8a mwifiex: pcie: Drop bogus __refdata annotation

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201211133835.2970384-1-geert+renesas@glider.be/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

