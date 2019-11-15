Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8BEEFDD6F
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 13:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbfKOMZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 07:25:00 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:50842 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727200AbfKOMY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 07:24:59 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D5F0760EE7; Fri, 15 Nov 2019 12:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573820698;
        bh=xJRbHFZXwBSUUf48p/Joe8hCtHadnvSE5DFVfhVnXkg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=GqAtFON+l4HaYUOQchRISBBIqFSp8VyyhBKqQr3sXzS+qV7edThZDM7ySD1hpoZKu
         GKgD5BGtq6u1W0kq8HK3eNXLIHSuuHm3QuEOAq7TKAh3m8KGnka78PTkx9o34SO8qC
         DhyveU6FNevpq9//t+LXL5UjwWZyc4yGGIU06w70=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F1AC760DEA;
        Fri, 15 Nov 2019 12:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573820698;
        bh=xJRbHFZXwBSUUf48p/Joe8hCtHadnvSE5DFVfhVnXkg=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=XHrFVz1Se8cpZYA7cONZtTqVV/VPNW3Yph/aYduuPwdJoQVeXM/ahQ0sapQedNL5e
         trwJlLnPHLefdG3cRMSmC4jQVmfL98nrVjfcYqws8Jgh9Td5UHydcK90M22aMONJ3G
         Mc3+YEX06DzhAJSZDvlWdkwhBpk03gu+4UqKer8w=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F1AC760DEA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtw88: remove duplicated include from ps.c
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191111033427.122443-1-yuehaibing@huawei.com>
References: <20191111033427.122443-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191115122458.D5F0760EE7@smtp.codeaurora.org>
Date:   Fri, 15 Nov 2019 12:24:58 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> Remove duplicated include.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Reviewed-by: Simon Horman <simon.horman@netronome.com>

Patch applied to wireless-drivers-next.git, thanks.

4f5969c36a45 rtw88: remove duplicated include from ps.c

-- 
https://patchwork.kernel.org/patch/11236527/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

