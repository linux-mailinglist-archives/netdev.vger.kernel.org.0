Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984F61E8503
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 19:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbgE2Rfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 13:35:30 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:50683 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727062AbgE2Rf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 13:35:29 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1590773728; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=SeTEctU+ztd5Ku+lnOTcND7ERvXPMycKgJ1ZXmv/LdU=;
 b=rJfK53cDlydGLFolI2bRr3FILUUNHD5RgEuqrEv30m6gOH6WrKZnzdMHQVNsSCfKuHAYuvf2
 cFnj1uHuCTk1VzW+LnE2aEyGpR1uR1ni/IvgJBrikDOT7TuFQohqwa1pyrB8FjxjJBQLxz8N
 DwNybzkrQaUO6yN0aZHZmZePA8k=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 5ed147cc27386861268c4ba3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 29 May 2020 17:35:08
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D7772C433AD; Fri, 29 May 2020 17:35:07 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D840AC43387;
        Fri, 29 May 2020 17:35:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D840AC43387
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wlcore: fix runtime pm imbalance in
 __wl1271_op_remove_interface
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200520130806.14789-1-dinghao.liu@zju.edu.cn>
References: <20200520130806.14789-1-dinghao.liu@zju.edu.cn>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>
Cc:     dinghao.liu@zju.edu.cn, kjlu@umn.edu,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Fuqian Huang <huangfq.daxian@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Maital Hahn <maitalm@ti.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200529173507.D7772C433AD@smtp.codeaurora.org>
Date:   Fri, 29 May 2020 17:35:07 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dinghao Liu <dinghao.liu@zju.edu.cn> wrote:

> When wl12xx_cmd_role_disable() returns an error code,
> a pairing runtime PM usage counter decrement is needed to
> keep the counter balanced.
> 
> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
> Acked-by: Tony Lindgren <tony@atomide.com>

Patch applied to wireless-drivers-next.git, thanks.

53df5271f239 wlcore: fix runtime pm imbalance in __wl1271_op_remove_interface

-- 
https://patchwork.kernel.org/patch/11560399/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

