Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41C13EAB4B
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 09:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbfJaIGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 04:06:00 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:42064 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbfJaIF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 04:05:59 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BCAE460540; Thu, 31 Oct 2019 08:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572509158;
        bh=WHeWFGVI8FXgoo0+ORMSvzLBzhwnvWn3vDPVfuLXLO0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Sj+qaBmIiXdB3BWIYfZjvstLQ/kDPwIQcRsQD2plw3hZSt7Bm8fUUaaplf8DPDOBV
         bfTZhwmR/DKzvnk2AKGd52yjJDFanXSkU1MbiCyJUFSZxWDwkioWhj7wODVmv5jGoF
         YB3deZ6qchJnYRkqbhhUIdsRmm7s1LusYJlnCWmg=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 363D660540;
        Thu, 31 Oct 2019 08:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572509158;
        bh=WHeWFGVI8FXgoo0+ORMSvzLBzhwnvWn3vDPVfuLXLO0=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=MJAYRR1/w+p+XIDcUJmEPxqcJbhEg5sCsB/uRsAMMK0Q2oObmLDjXlB9Pr6aoftMo
         5yNUTHXbkiC2OoIW76E4+FMBkNhKau19cZjYSlrg72gGIwrl4cwYNEjiNzbukbGN9M
         HMgwSm+Z5pb2g7pKmVZHzZAm1PWZOSIHHAPz5XAM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 363D660540
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: rtl8192c: Drop condition with no effect
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191028185130.GA26825@saurav>
References: <20191028185130.GA26825@saurav>
To:     Saurav Girepunje <saurav.girepunje@gmail.com>
Cc:     pkshih@realtek.com, davem@davemloft.net, Larry.Finger@lwfinger.net,
        saurav.girepunje@gmail.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        saurav.girepunje@hotmail.com
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191031080558.BCAE460540@smtp.codeaurora.org>
Date:   Thu, 31 Oct 2019 08:05:58 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Saurav Girepunje <saurav.girepunje@gmail.com> wrote:

> As the "else if" and "else" branch body are identical the condition
> has no effect. So drop the "else if" condition.
> 
> Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

cbbd7f9a5e76 rtlwifi: rtl8192c: Drop condition with no effect

-- 
https://patchwork.kernel.org/patch/11216285/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

