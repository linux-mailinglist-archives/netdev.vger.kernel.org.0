Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A35FE1A96F7
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 10:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894766AbgDOIkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 04:40:07 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:23429 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2894744AbgDOIjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 04:39:55 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1586939995; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=yt5GAkeWutdoRiLVjNmQh1PYnCw5y+LdfOz0sU6qfrQ=;
 b=GeFR2Mskh1cJUnaGSb3OGDuZwxF+LVQJa7qHBj53eH8H+LBeG4muSyhQcoWdjuX11FTpMcE2
 OUjUfMsXK9BkgsxhIp7pPv4T4DB2aYkZpJdFPxdQgabiYsYpN+jTnKa1KGrIqfnEjVHoUWZJ
 qhzE9JNiRQqRtYNlDG32Mkkq6uo=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e96c84b.7fc81aaa5810-smtp-out-n01;
 Wed, 15 Apr 2020 08:39:39 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 97264C4478C; Wed, 15 Apr 2020 08:39:39 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 33D41C433F2;
        Wed, 15 Apr 2020 08:39:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 33D41C433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] libertas: make lbs_init_mesh() void
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200410090942.27239-1-yanaijie@huawei.com>
References: <20200410090942.27239-1-yanaijie@huawei.com>
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <davem@davemloft.net>, <colin.king@canonical.com>,
        <yanaijie@huawei.com>, <dan.carpenter@oracle.com>,
        <lkundrak@v3.sk>, <libertas-dev@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200415083939.97264C4478C@smtp.codeaurora.org>
Date:   Wed, 15 Apr 2020 08:39:39 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jason Yan <yanaijie@huawei.com> wrote:

> Fix the following coccicheck warning:
> 
> drivers/net/wireless/marvell/libertas/mesh.c:833:5-8: Unneeded variable:
> "ret". Return "0" on line 874
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> Reviewed-by: Lubomir Rintel <lkundrak@v3.sk>

Patch applied to wireless-drivers-next.git, thanks.

2fd5fdca6a3a libertas: make lbs_init_mesh() void

-- 
https://patchwork.kernel.org/patch/11483039/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
