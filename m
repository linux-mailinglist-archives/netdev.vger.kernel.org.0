Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65C183E268B
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 10:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243851AbhHFI5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 04:57:54 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:52785 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243425AbhHFI5y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 04:57:54 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1628240258; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=fpyjPu+FBT9NUHrFq7Z7ZZkGRCTZTAek+H6Ad5eVnrk=;
 b=qsfYY6n9PV75GQFIFtV9cL7zKBU6wlPGl2yjKRlySzpAA5oBJQeW7emu/6xyDu4R8vxMscm+
 9zecT5bUdjE4WSYefHAcSZAr/yGpZjilD5/Il/4jEujIhtvaNzYZtzdSN5UVvmX+bZiAqv3n
 CSLY+M7IdCW8+YPxHxaKluz0OJI=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 610cf981041a739c46f62c7e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 06 Aug 2021 08:57:37
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 25802C43460; Fri,  6 Aug 2021 08:57:37 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 67D26C433D3;
        Fri,  6 Aug 2021 08:57:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 67D26C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: intersil: remove obsolete prism54 wireless driver
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210713054025.32006-1-lukas.bulwahn@gmail.com>
References: <20210713054025.32006-1-lukas.bulwahn@gmail.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     linux-wireless@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dwaipayan Ray <dwaipayanray1@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210806085737.25802C43460@smtp.codeaurora.org>
Date:   Fri,  6 Aug 2021 08:57:37 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lukas Bulwahn <lukas.bulwahn@gmail.com> wrote:

> Commit 1d89cae1b47d ("MAINTAINERS: mark prism54 obsolete") indicated the
> prism54 driver as obsolete in July 2010.
> 
> Now, after being exposed for ten years to refactoring, general tree-wide
> changes and various janitor clean-up, it is really time to delete the
> driver for good.
> 
> This was discovered as part of a checkpatch evaluation, investigating all
> reports of checkpatch's WARNING:OBSOLETE check.
> 
> p54 replaces prism54 so users should be unaffected. There was a one off chipset
> someone long ago reported that p54 didn't work with but the reporter never
> followed up on that. Additionally, distributions have been blacklisting prism54
> for years now.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> Acked-by: Luis Chamberlain <mcgrof@kernel.org>

Patch applied to wireless-drivers-next.git, thanks.

d249ff28b1d8 intersil: remove obsolete prism54 wireless driver

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210713054025.32006-1-lukas.bulwahn@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

