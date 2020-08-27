Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2282254311
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 12:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728707AbgH0KC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 06:02:58 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:24994 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726988AbgH0KCz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 06:02:55 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598522574; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=juoVvy/UqJUMfynNxh8li0pl5rUHTzQgLIgI3XRd9bQ=;
 b=DP2M96vkiN996HemyfH1V2N4YazLAxBoTE5ThI+Ggf7PhpMcfhza58oe9RWA7IK4e+/l2cLV
 1hbBeHygIwNJwV6rhVEFAN9sN3a1HYWAY8+Sl0TWB+1Sxn/lMdtElvlmXICwyz+G03acdPpJ
 +2hEyK8s+mr5EFzevOiMrSBV4j4=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 5f47848dc9ede11f5e702bd8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 27 Aug 2020 10:01:49
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 18927C43391; Thu, 27 Aug 2020 10:01:49 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B8D8FC433CA;
        Thu, 27 Aug 2020 10:01:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B8D8FC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] [v2] wilc1000: Fix memleak in wilc_sdio_probe
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200820054819.23365-1-dinghao.liu@zju.edu.cn>
References: <20200820054819.23365-1-dinghao.liu@zju.edu.cn>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>
Cc:     dinghao.liu@zju.edu.cn, kjlu@umn.edu,
        Ajay Singh <ajay.kathat@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200827100149.18927C43391@smtp.codeaurora.org>
Date:   Thu, 27 Aug 2020 10:01:49 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dinghao Liu <dinghao.liu@zju.edu.cn> wrote:

> When devm_clk_get() returns -EPROBE_DEFER, sdio_priv
> should be freed just like when wilc_cfg80211_init()
> fails.
> 
> Fixes: 8692b047e86cf ("staging: wilc1000: look for rtc_clk clock")
> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
> Acked-by: Ajay Singh <ajay.kathat@microchip.com>

Patch applied to wireless-drivers-next.git, thanks.

8d95ab34b21e wilc1000: Fix memleak in wilc_sdio_probe

-- 
https://patchwork.kernel.org/patch/11725481/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

