Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79EF22ADEE1
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 19:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731608AbgKJS5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 13:57:05 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:32007 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730618AbgKJS5E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 13:57:04 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605034624; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=vDq62T/03iDGRK+aP4t5YbSfr7W0BoTtgT+qO9wVCOY=;
 b=bxrryI2258aMOuw/fS6qqxOsLpHhSPLADpga8nvNnfbJv6JszOizH26muyXNcyNE2RDblfBM
 arfLr68EAtFddyyI6vZ8qmfSM/PaOQDMHxSUOSrhxDsQhyjkg82lIJaDLzNb9dEYYICqLCan
 p3nmynu4+z9BsvaBcjQrYTWj0/Q=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5faae27b40d4446125790e87 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 10 Nov 2020 18:56:59
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B4E7EC43382; Tue, 10 Nov 2020 18:56:58 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4C130C433C6;
        Tue, 10 Nov 2020 18:56:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4C130C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: rtlwifi: fix spelling typo of workaround
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1604738439-24794-1-git-send-email-wangqing@vivo.com>
References: <1604738439-24794-1-git-send-email-wangqing@vivo.com>
To:     Wang Qing <wangqing@vivo.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Joe Perches <joe@perches.com>,
        Zheng Bin <zhengbin13@huawei.com>,
        Wang Qing <wangqing@vivo.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201110185658.B4E7EC43382@smtp.codeaurora.org>
Date:   Tue, 10 Nov 2020 18:56:58 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wang Qing <wangqing@vivo.com> wrote:

> workarould -> workaround
> 
> Signed-off-by: Wang Qing <wangqing@vivo.com>

Patch applied to wireless-drivers-next.git, thanks.

dd90fc4630d2 rtlwifi: fix spelling typo of workaround

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1604738439-24794-1-git-send-email-wangqing@vivo.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

