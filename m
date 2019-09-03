Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEB07A69D4
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 15:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729097AbfICN24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 09:28:56 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:43856 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727667AbfICN24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 09:28:56 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8AD376083E; Tue,  3 Sep 2019 13:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567517335;
        bh=K3E/QGwt8PVRCKQtxROTYRObKHRnmgQXb96agiICqk8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=oWyyGkcBm1bYRXtIfgtVXK459fuDWDJoQMzTNnBsY/ImTIbY9QSWvLttZzumOIZA1
         kDaHy4tacjsRgjM64U0+vY49NBK5IlXrv9ChgsfiX3OjX9MPUdKAUSqhNwYZF2D8WB
         hofKGcTK4EQkXUQnLK6CxS3yIFjbuWvuJ3/CNcAw=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9BE12605A2;
        Tue,  3 Sep 2019 13:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567517335;
        bh=K3E/QGwt8PVRCKQtxROTYRObKHRnmgQXb96agiICqk8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Pnl8xAnYep/ueky0p38sQ5/fga0Je+FBS3gzV+NwrmnenpvFCrATfI+ltEAHqdYiB
         Opdsiuopg4OisnZpnm1kjyEuyUsKq8GdSb96qRUzGY5bmJSVY2izYar8wEzsgWlywB
         iH9/9lue5LhiNXIPrbwStw0XnfCUTA4GLUnHh+C0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9BE12605A2
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: remove unused variables
 'RTL8712_SDIO_EFUSE_TABLE' and 'MAX_PGPKT_SIZE'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190816140513.72572-1-yuehaibing@huawei.com>
References: <20190816140513.72572-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <pkshih@realtek.com>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190903132855.8AD376083E@smtp.codeaurora.org>
Date:   Tue,  3 Sep 2019 13:28:55 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> drivers/net/wireless/realtek/rtlwifi/efuse.c:16:31:
>  warning: RTL8712_SDIO_EFUSE_TABLE defined but not used [-Wunused-const-variable=]
> drivers/net/wireless/realtek/rtlwifi/efuse.c:9:17:
>  warning: MAX_PGPKT_SIZE defined but not used [-Wunused-const-variable=]
> 
> They are never used, so can be removed.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

84d31d3b6234 rtlwifi: remove unused variables 'RTL8712_SDIO_EFUSE_TABLE' and 'MAX_PGPKT_SIZE'

-- 
https://patchwork.kernel.org/patch/11097803/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

