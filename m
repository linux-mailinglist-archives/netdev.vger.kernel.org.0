Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9F18C3008
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 11:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387582AbfJAJVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 05:21:22 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41140 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387565AbfJAJVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 05:21:22 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 68C2D61214; Tue,  1 Oct 2019 09:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569921680;
        bh=QDTFqQmt/2z8/7h6T0ElABeTmTYTi368LogpuQ3Ed9o=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=WMchxioB5TsTyX0HJ3VQ8wtJrv3iDIeDjPj0meUMrxecv23wBMeVOOPWT9rQnVkaR
         byR9HMsKcTaAIU7Pia4rMOShKLuiELZI9cGedu9iwhs/NjQDZaF8tT4wSXKBLLpcSm
         uLbUWjEvPR75apzuIRQ51zKEcNAp09XV0xHsaUog=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 94074611C5;
        Tue,  1 Oct 2019 09:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569921677;
        bh=QDTFqQmt/2z8/7h6T0ElABeTmTYTi368LogpuQ3Ed9o=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=A+mqHiECFoBiwxKN5sigk3pqJ5JkjaAxf4rifrZb7qcyb4gKZTXFD94DltMVq7UeE
         /HigrHCtLcimjMRDxVJVo5DxOuUDeG1d4meRJMPjk1wz3CtdBYcE8nNY7YHy+lJ4Aq
         RP1sSZYpftSldShvmdni20c6Ib4LKCq1i9FdzEaE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 94074611C5
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: Remove excessive check in _rtl_ps_inactive_ps()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190925205858.30216-1-efremov@linux.com>
References: <20190925205858.30216-1-efremov@linux.com>
To:     Denis Efremov <efremov@linux.com>
Cc:     Denis Efremov <efremov@linux.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191001092120.68C2D61214@smtp.codeaurora.org>
Date:   Tue,  1 Oct 2019 09:21:18 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Denis Efremov <efremov@linux.com> wrote:

> There is no need to check "rtlhal->interface == INTF_PCI" twice in
> _rtl_ps_inactive_ps(). The nested check is always true. Thus, the
> expression can be simplified.
> 
> Signed-off-by: Denis Efremov <efremov@linux.com>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Patch applied to wireless-drivers-next.git, thanks.

a0d46f7a0fa5 rtlwifi: Remove excessive check in _rtl_ps_inactive_ps()

-- 
https://patchwork.kernel.org/patch/11161357/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

