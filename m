Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8EF12CC69E
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 20:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731040AbgLBT0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 14:26:50 -0500
Received: from m42-5.mailgun.net ([69.72.42.5]:35343 "EHLO m42-5.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbgLBT0u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 14:26:50 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606937190; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=UJu1LcNWD2K3Tm5r7wZWFQR7WfPh0Nebwnit2jCiSZM=;
 b=tzPBJcKJxQpX4k2UhQmAlgWHytDgZ3bSju1ihU96QdDjHqqR8oOH4XBiMiy14tgmaSuqyTzj
 qowbaOzhmb59MqeWrMUXwo6/GLCnuePrE92ejrvAl3QGAZ/LROTwU/VaFEQ9XrtwfjKJiTlU
 XOCLZNn5EIXI992iYIEsmTYFIQ8=
X-Mailgun-Sending-Ip: 69.72.42.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5fc7ea46265512b1b2a99728 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 02 Dec 2020 19:25:58
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E434CC43461; Wed,  2 Dec 2020 19:25:57 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8D741C43462;
        Wed,  2 Dec 2020 19:25:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8D741C43462
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wlcore: Switch to using the new API kobj_to_dev()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1606096062-32251-1-git-send-email-tiantao6@hisilicon.com>
References: <1606096062-32251-1-git-send-email-tiantao6@hisilicon.com>
To:     Tian Tao <tiantao6@hisilicon.com>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201202192557.E434CC43461@smtp.codeaurora.org>
Date:   Wed,  2 Dec 2020 19:25:57 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tian Tao <tiantao6@hisilicon.com> wrote:

> Switch to using the new API kobj_to_dev().
> 
> Signed-off-by: Tian Tao <tiantao6@hisilicon.com>

Patch applied to wireless-drivers-next.git, thanks.

3b52cf6242b4 wlcore: Switch to using the new API kobj_to_dev()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1606096062-32251-1-git-send-email-tiantao6@hisilicon.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

