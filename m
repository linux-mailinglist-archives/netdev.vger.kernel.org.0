Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6E833AD62
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 09:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhCOI0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 04:26:38 -0400
Received: from m42-2.mailgun.net ([69.72.42.2]:24172 "EHLO m42-2.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230301AbhCOI0N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 04:26:13 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1615796773; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=mxLXYdvx85X9oDNgZm9abgFv4K/c40qOxczAgM8pC6g=;
 b=p5+wCPp1uQzXxduSfFbhuToLMjbY6kWtb81b7PwdGsfvXmCGCelkKsUf4ObggU3ohhmaCmDH
 5YkLS0IT6JaBx1IZnedPQkAMbf1/ju+DOIMt53OJDlsh+agrE1bkluMpG6IJf7ngs2O7wbJO
 WhUTzTD8I0erpl/0W6TrtrEw9N0=
X-Mailgun-Sending-Ip: 69.72.42.2
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 604f1a25e2200c0a0d39fc19 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 15 Mar 2021 08:26:13
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 12A93C43465; Mon, 15 Mar 2021 08:26:13 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5F091C433ED;
        Mon, 15 Mar 2021 08:26:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5F091C433ED
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wilc1000: write value to WILC_INTR2_ENABLE register
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210224163706.519658-1-marcus.folkesson@gmail.com>
References: <20210224163706.519658-1-marcus.folkesson@gmail.com>
To:     Marcus Folkesson <marcus.folkesson@gmail.com>
Cc:     Ajay Singh <ajay.kathat@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marcus Folkesson <marcus.folkesson@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210315082613.12A93C43465@smtp.codeaurora.org>
Date:   Mon, 15 Mar 2021 08:26:13 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marcus Folkesson <marcus.folkesson@gmail.com> wrote:

> Write the value instead of reading it twice.
> 
> Fixes: c5c77ba18ea6 ("staging: wilc1000: Add SDIO/SPI 802.11 driver")
> Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

e21b6e5a5462 wilc1000: write value to WILC_INTR2_ENABLE register

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210224163706.519658-1-marcus.folkesson@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

