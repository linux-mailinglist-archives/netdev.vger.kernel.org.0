Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB5F258AFC
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 11:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgIAJHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 05:07:30 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:61902 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbgIAJH3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 05:07:29 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598951248; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=r4jgLB2Y7HqxGBSoMmSZHzBfBOvDTq/waBu4T4pLAgY=;
 b=TTmHJrIZDO/zXuJpUTuv13lxDU975lUTTOiFbAeJM/HBUNbM4Pt5H6a4nweEwXz0LRpXuXZa
 3KZexhTkqpfCAON8M7J+5sL34LLGjfnZitXVDdYvCwcUgAOfU5v050iD54gxUsSeuu4yWYY3
 rdUrliw59ljUBG+dTyMz9L5ra28=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 5f4e0f367f21d51b300b6cec (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 01 Sep 2020 09:07:02
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 09D7CC433A0; Tue,  1 Sep 2020 09:07:01 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D0A85C433C6;
        Tue,  1 Sep 2020 09:06:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D0A85C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [15/28] mt7601u: phy: Fix misnaming when documented function
 parameter 'dac'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200819072402.3085022-16-lee.jones@linaro.org>
References: <20200819072402.3085022-16-lee.jones@linaro.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Jakub Kicinski <kubakici@wp.pl>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@openwrt.org>,
        linux-mediatek@lists.infradead.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200901090702.09D7CC433A0@smtp.codeaurora.org>
Date:   Tue,  1 Sep 2020 09:07:01 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> wrote:

> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/wireless/mediatek/mt7601u/phy.c:1216: warning: Function parameter or member 'dac' not described in 'mt7601u_set_tx_dac'
>  drivers/net/wireless/mediatek/mt7601u/phy.c:1216: warning: Excess function parameter 'path' description in 'mt7601u_set_tx_dac'
> 
> Cc: Jakub Kicinski <kubakici@wp.pl>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Matthias Brugger <matthias.bgg@gmail.com>
> Cc: Felix Fietkau <nbd@openwrt.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-mediatek@lists.infradead.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> Acked-by: Jakub Kicinski <kubakici@wp.pl>

10 patches applied to wireless-drivers-next.git, thanks.

e6cf87bfe869 mt7601u: phy: Fix misnaming when documented function parameter 'dac'
a8433a92521b rsi: Fix misnamed function parameter 'rx_pkt'
5dfcdc7a520e rsi: Fix a few kerneldoc misdemeanours
311175173c8a rsi: Fix a myriad of documentation issues
9463fd554bb8 rsi: File header comments should not be kernel-doc
7951a3bfa2b1 iwlegacy: 4965: Demote a bunch of nonconformant kernel-doc headers
2de64ca7c9fa brcmfmac: p2p: Deal with set but unused variables
457023556e94 libertas: Fix misnaming for function param 'device'
f030ed4079d0 libertas_tf: Fix function documentation formatting errors
ec511969097f hostap: Remove set but unused variable 'hostscan'

-- 
https://patchwork.kernel.org/patch/11723151/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

