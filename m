Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87DCB27BF48
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 10:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727679AbgI2IZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 04:25:17 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:15055 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726944AbgI2IZQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 04:25:16 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1601367916; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=aai6Srv71h/GpojCEi4DdAL8TyEev/PPoR3eeYJ2Ohk=;
 b=fIOZQyuZCeIDx5q/UZuh0c0PGf/pVyNT6qyVJhsnC+tRmyqpg8CfCh4bPwTW4EnsshhMRJjm
 M3LpPnL2BhYhpsVgmy2E4TUIpS4ceRnlvR03m53vsmKYhGeAgSRTWg22q6G2bYLmvAi5S6gf
 EPrtRk2pPhp0+M1C0280KgVdvgY=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 5f72ef6b1fdd3a1390fd796c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 29 Sep 2020 08:25:15
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C6841C433C8; Tue, 29 Sep 2020 08:25:14 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C17CFC433CA;
        Tue, 29 Sep 2020 08:25:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C17CFC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wl1251/wl12xx: fix a typo in comments
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1601087891-11281-1-git-send-email-wangqing@vivo.com>
References: <1601087891-11281-1-git-send-email-wangqing@vivo.com>
To:     Wang Qing <wangqing@vivo.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Wang Qing <wangqing@vivo.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200929082514.C6841C433C8@smtp.codeaurora.org>
Date:   Tue, 29 Sep 2020 08:25:14 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wang Qing <wangqing@vivo.com> wrote:

> Modify the comment typo: "compliment" -> "complement".
> 
> Signed-off-by: Wang Qing <wangqing@vivo.com>

Patch applied to wireless-drivers-next.git, thanks.

42af278bff02 wl1251/wl12xx: fix a typo in comments

-- 
https://patchwork.kernel.org/patch/11801073/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

