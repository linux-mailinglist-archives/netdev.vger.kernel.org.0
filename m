Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49AF8D3B83
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 10:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727537AbfJKIq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 04:46:28 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:39634 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbfJKIq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 04:46:27 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E2F5D60AA3; Fri, 11 Oct 2019 08:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570783587;
        bh=M4acdj/SpnAHRs9HrnE1kZOeO7NTUoB09Mij0APM02M=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Oo77zUcBn7GCHy8pTt/P66Fwqx+2XwlBb2Lt5RGG8yumri+oB2/th2PJT01ujXfSl
         1fezlOBCoZzhmmD25M91z1CIuC3C14FxlEwhQrn/TNf3XUK0f953pMIZmfdjTdA7op
         c09i21OGtVcs9rPT4u4i4q2PmOsoSDXVrhXCWl/Q=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AB0D16070D;
        Fri, 11 Oct 2019 08:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570783586;
        bh=M4acdj/SpnAHRs9HrnE1kZOeO7NTUoB09Mij0APM02M=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=f2iW8FN8ep3aygl5L2hgGUUGidm3BThqdgSxPoVxE5F0C5xby4Klaqlxgqnv4/lAf
         AAuioDt+T/Bv7Xhm8oMFGTBhcei8uRpJl12OETYNx0C/6O+yC6nkzXvR5P82uCn1+X
         NWQkjw/U/0QZoQ74E2mHOoXjPpHHuGM09rPSe/es=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AB0D16070D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] ath10k: fix null dereference on pointer crash_data
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191004160227.31577-1-colin.king@canonical.com>
References: <20191004160227.31577-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191011084626.E2F5D60AA3@smtp.codeaurora.org>
Date:   Fri, 11 Oct 2019 08:46:26 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> Currently when pointer crash_data is null the present null check
> will also check that crash_data->ramdump_buf is null and will cause
> a null pointer dereference on crash_data. Fix this by using the ||
> operator instead of &&.
> 
> Fixes: 3f14b73c3843 ("ath10k: Enable MSA region dump support for WCN3990")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

a69d3bdd4d40 ath10k: fix null dereference on pointer crash_data

-- 
https://patchwork.kernel.org/patch/11174955/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

