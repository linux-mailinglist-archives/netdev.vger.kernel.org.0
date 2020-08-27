Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 316F2254318
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 12:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbgH0KDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 06:03:30 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:24994 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728732AbgH0KDT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 06:03:19 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598522598; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=rv0P6J7OYmXCE2KVpOiobH3kXlv30j41Xb0jzb6avXo=;
 b=wwdSCENzb98tDKaJjqLQMAu1EY7dq3teasIi11LdlA9HABpWBW2aYkxaqAOEVvQkWNwN4Zxr
 RrRrlhMXTgKCS1UsMEVNhkfyWkkp57xqkAuYKzF7y7dcSY3qgkrO37uRcH700681ppvZGDTG
 8jRZRR2F+tdAE9lDARjz3Hd9Whg=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 5f4784d72fd6d21f0a9cc97a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 27 Aug 2020 10:03:03
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3C929C433A1; Thu, 27 Aug 2020 10:03:03 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3972EC433C6;
        Thu, 27 Aug 2020 10:03:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3972EC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] [v2] wilc1000: Fix memleak in wilc_bus_probe
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200820055256.24333-1-dinghao.liu@zju.edu.cn>
References: <20200820055256.24333-1-dinghao.liu@zju.edu.cn>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>
Cc:     dinghao.liu@zju.edu.cn, kjlu@umn.edu,
        Ajay Singh <ajay.kathat@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Adham Abozaeid <adham.abozaeid@microchip.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200827100303.3C929C433A1@smtp.codeaurora.org>
Date:   Thu, 27 Aug 2020 10:03:03 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dinghao Liu <dinghao.liu@zju.edu.cn> wrote:

> When devm_clk_get() returns -EPROBE_DEFER, spi_priv
> should be freed just like when wilc_cfg80211_init()
> fails.
> 
> Fixes: 854d66df74aed ("staging: wilc1000: look for rtc_clk clock in spi mode")
> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
> Acked-by: Ajay Singh <ajay.kathat@microchip.com>

Patch applied to wireless-drivers-next.git, thanks.

9a19a939abfa wilc1000: Fix memleak in wilc_bus_probe

-- 
https://patchwork.kernel.org/patch/11725515/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

