Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC2052258
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 07:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbfFYE7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 00:59:55 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:59164 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726804AbfFYE7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 00:59:55 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 29EE4607CA; Tue, 25 Jun 2019 04:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561438794;
        bh=md7kE4BdEUt2E2wtf3+wWFZnGTK4S+hsToX1pbW5wv8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=U3rQceye6dl4WnHbimh5n4MbwQB+0gSuQw0dIhK7s6h7SreGr2E2JtxF2dW90jgZZ
         uNQR5tAUHhfzZCFdLmDL4fVSl/Q6DsMNTBG9Ib6LttPZb89t1B6495PL5joKAmXuWa
         9vABLYz/VC4sxHMGlu7fI3L1lA6w9I4nLQw6L/x8=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 042A36019D;
        Tue, 25 Jun 2019 04:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561438793;
        bh=md7kE4BdEUt2E2wtf3+wWFZnGTK4S+hsToX1pbW5wv8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=YVAzPyj8GmFwNIeDgJjypXDgACHEZNPbv/VTdpe+5Jizqyk1ikShjHT8DZJcaDiJM
         cNVoj2VtaKYfx/+K5xRGfzA2dk75H2at6gcBJS1Ae9tPDJXC11eZ+Wb5LmhKlh9A0D
         OSJPHGTnaTUL47gv/Xxvd2KLIrCWHo/LgCSssvUU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 042A36019D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: remove redundant assignment to variable badworden
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190530184044.8479-1-colin.king@canonical.com>
References: <20190530184044.8479-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190625045954.29EE4607CA@smtp.codeaurora.org>
Date:   Tue, 25 Jun 2019 04:59:54 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable badworden is assigned with a value that is never read and
> it is re-assigned a new value immediately afterwards.  The assignment is
> redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Patch applied to wireless-drivers-next.git, thanks.

5315f9d40191 rtlwifi: remove redundant assignment to variable badworden

-- 
https://patchwork.kernel.org/patch/10969175/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

