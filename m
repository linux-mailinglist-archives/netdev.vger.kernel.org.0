Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58D4A2AA690
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 17:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgKGQGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 11:06:11 -0500
Received: from z5.mailgun.us ([104.130.96.5]:55140 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbgKGQGL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 11:06:11 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604765170; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=pa8KKHokUEvnLhOrdNZJbRmbV871dib3AkUNk5xWExw=;
 b=Z0W8Sgbwu+2FF8asGk5IRt5jH7+4PBXJRE8pmz89RqUZlP7/fCZSZSF1IZaIkFzuHpkZpnPY
 Bh9vbyuA076qx9Wxmhrqe34mKKM0UnHbkQ8mkQCtqbgIVVxIJMepvy4Z2GN+74jhuLEzfGAZ
 BfPGfKBu9L5xwJn3b1Xwke5p/OE=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 5fa6c5ea1d3980f7d6c528a3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 07 Nov 2020 16:06:02
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3168DC433C6; Sat,  7 Nov 2020 16:06:02 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 18B9BC433C8;
        Sat,  7 Nov 2020 16:05:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 18B9BC433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 09/41] wl1251: cmd: Rename 'len' to 'buf_len' in the
 documentation
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201102112410.1049272-10-lee.jones@linaro.org>
References: <20201102112410.1049272-10-lee.jones@linaro.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201107160602.3168DC433C6@smtp.codeaurora.org>
Date:   Sat,  7 Nov 2020 16:06:02 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> wrote:

> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/wireless/ti/wl1251/cmd.c:70: warning: Function parameter or member 'buf_len' not described in 'wl1251_cmd_test'
>  drivers/net/wireless/ti/wl1251/cmd.c:70: warning: Excess function parameter 'len' description in 'wl1251_cmd_test'
> 
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

5 patches applied to wireless-drivers-next.git, thanks.

641291eca88c wl1251: cmd: Rename 'len' to 'buf_len' in the documentation
9afcf3223675 prism54: isl_ioctl: Fix one function header and demote another
8b8a6f8c3b50 wl3501_cs: Fix misspelling and provide missing documentation
5e43d496cd8e mwifiex: pcie: Remove a couple of unchecked 'ret's
136ab258d984 wlcore: spi: Demote a non-compliant function header, fix another

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201102112410.1049272-10-lee.jones@linaro.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

