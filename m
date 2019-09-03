Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77C5FA69F6
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 15:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729118AbfICNg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 09:36:27 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48834 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727941AbfICNg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 09:36:27 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DD0A3605A2; Tue,  3 Sep 2019 13:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567517785;
        bh=T4+qthdIa+JdtJ1JZNw78DDAC6sdnSeXsq52RWos8i8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=eu4SuX4XJTg98x2tGFMxG20wx4cFDttZSQzpbJg3b6Wn1pO346QTjqcrRO3rxZxjJ
         KUYy1H6vDhwFTMKl0B4xb+w+mEmMtbryFE88MC7ogW7bf+f5yHdmFPpt1cYRe74B2z
         rybsJ5EqkOjXuBHzp4eS6OSoZAUib3VzPelsncUA=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CB942602CA;
        Tue,  3 Sep 2019 13:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567517785;
        bh=T4+qthdIa+JdtJ1JZNw78DDAC6sdnSeXsq52RWos8i8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=n4N6oMCI7ZAh48ltOR5O3mymXNlUO4JcKKK99is1xAel8K0RsIq0Mrj8yLzJLlctL
         gr79ARrs4bsck8Od+R9MUGVVnLj3WhaC/HwYmQDERP7t4fOGClJUggt0H4bnpZwlcL
         JLPn0o7Fm41sqbVjRi0Q1rqaTvhu3NZvjQHeQhwQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CB942602CA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtw88: remove redundant assignment to pointer
 debugfs_topdir
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190822113728.25494-1-colin.king@canonical.com>
References: <20190822113728.25494-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190903133625.DD0A3605A2@smtp.codeaurora.org>
Date:   Tue,  3 Sep 2019 13:36:25 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Pointer debugfs_topdir is initialized to a value that is never read
> and it is re-assigned later. The initialization is redundant and can
> be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

9f7d65fb3935 rtw88: remove redundant assignment to pointer debugfs_topdir

-- 
https://patchwork.kernel.org/patch/11109159/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

