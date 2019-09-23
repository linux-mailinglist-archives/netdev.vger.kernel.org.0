Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F26C1BAF4F
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 10:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406789AbfIWIZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 04:25:12 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53086 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406076AbfIWIZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 04:25:12 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4088660850; Mon, 23 Sep 2019 08:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569227111;
        bh=WOFRHwq7H+xLOuFoB5NSwTtl8vKLqopZli8GexNDdAg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=jefdjzggo1SuHyUOqv5y/m6CCjHi7L9q3YXcxvsEl3p3zAp/ib+Q5Y6uwHvoBmPdE
         sCqnlzlKavjH6mwyEvtT0J/Ne9BKDx4wIl7l3PZr15x40POFM5tbR445QkWH8+LMpA
         cKUQHN1C3FAZL/GnM3NASSzuic5SuAny6ja1fTQU=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8D73C60850;
        Mon, 23 Sep 2019 08:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569227110;
        bh=WOFRHwq7H+xLOuFoB5NSwTtl8vKLqopZli8GexNDdAg=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=ZEUFMhZTZofECZ+NjFNcRCX33MNFX7u+h5sr5xTlGF7oCdrSlgjW7hssDpm0GNXbh
         WHhbH4Hw7IfDjt0r6012c3MR9Na8Y+ChLA6bOq7sIRhp81jySN2lFaE810OWN4vJ/7
         ndayYPXUE6zXfrCEiEF6iwKibTicvoWZDP6bum+s=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8D73C60850
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] ath: fix various spelling mistakes
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190702123904.8786-1-colin.king@canonical.com>
References: <20190702123904.8786-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Maya Erez <merez@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        wil6210@qti.qualcomm.com, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190923082511.4088660850@smtp.codeaurora.org>
Date:   Mon, 23 Sep 2019 08:25:11 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> There are a bunch of spelling mistakes in two ath drivers, fix
> these.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

80ce8ca7a647 ath: fix various spelling mistakes

-- 
https://patchwork.kernel.org/patch/11027799/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

