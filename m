Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1D21C2FF6
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 11:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387522AbfJAJUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 05:20:21 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:40088 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387515AbfJAJUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 05:20:21 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C7D6860790; Tue,  1 Oct 2019 09:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569921620;
        bh=7WqKG1aQXo8eqzbwNKamQYSCoC1vOcy+xtXyPVENorw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=a3S/jUZqXdn5/ATzU/OwOZtOnciuvUe2ysQOrdGxo6dXNoJcLoJRy92eUx8iWPbrL
         GVXf8A8Adzv9eUx9fq1D6Y9g7Tv8EVi14LkPJaFvjYfssxTxyrOUG2Myvv3BFG9jkC
         5/c/xKjvJgvzn8G9JAf3YzHI77LspKYrSWmskJ8Y=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 03B986076C;
        Tue,  1 Oct 2019 09:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569921619;
        bh=7WqKG1aQXo8eqzbwNKamQYSCoC1vOcy+xtXyPVENorw=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=N8VusvJTCkp1TL4aDroXLr1OLO99llZRgx5E78m4SPj8eRDZnpDANvoTbb1I/AqrR
         /U6TQbaeQflq0Vj7gHXShexsjWyKsjs7RqMj7R+IFcYpsOtht5qWm8O8n4nyqjI3nV
         ErLAbU5pSYr8O4D6yBr9L28WkLz5lhquiB9zKHHA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 03B986076C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: rtl8723ae: Remove unused 'rtstatus' variable
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190917065044.GA173797@LGEARND20B15>
References: <20190917065044.GA173797@LGEARND20B15>
To:     Austin Kim <austindh.kim@gmail.com>
Cc:     pkshih@realtek.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, austindh.kim@gmail.com
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191001092020.C7D6860790@smtp.codeaurora.org>
Date:   Tue,  1 Oct 2019 09:20:20 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Austin Kim <austindh.kim@gmail.com> wrote:

> 'rtstatus' local variable is not used,
> so remove it for clean-up.
> 
> Signed-off-by: Austin Kim <austindh.kim@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

6e7d59776311 rtlwifi: rtl8723ae: Remove unused 'rtstatus' variable

-- 
https://patchwork.kernel.org/patch/11148141/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

