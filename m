Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6363258B5D
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 11:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbgIAJUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 05:20:55 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:40093 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726107AbgIAJUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 05:20:54 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598952054; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=9Quw6/hpHbTQZ8x3xhgu4ubjPAER9V2kJ811puQ4tU8=;
 b=IW1RezihkNf8HZrh/dNKF7Zmh0wdD4+ZmiRXJFUpJbC1ulc6re7Nc+ejeeBzQ862K7expagX
 ukkZdxrwWO5d5XRtNDvjzEXld7ovRVOY4s8j62UJ5uJRlTcLWoWq6O7I4sAKEWFO3mhcAdA4
 3/7/WgAsG1Teog2qE00xw4+tsdo=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 5f4e1276947f606f7e58e5ff (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 01 Sep 2020 09:20:54
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 41D20C43387; Tue,  1 Sep 2020 09:20:53 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E54F1C433C6;
        Tue,  1 Sep 2020 09:20:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E54F1C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [02/32] rsi: Add description for function param 'sta'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200821071644.109970-3-lee.jones@linaro.org>
References: <20200821071644.109970-3-lee.jones@linaro.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200901092053.41D20C43387@smtp.codeaurora.org>
Date:   Tue,  1 Sep 2020 09:20:53 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> wrote:

> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/wireless/rsi/rsi_91x_mac80211.c:1021: warning: Function parameter or member 'sta' not described in 'rsi_mac80211_set_key'
> 
> Cc: Amitkumar Karwar <amitkarwar@gmail.com>
> Cc: Siva Rebbagondla <siva8118@gmail.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

9 patches applied to wireless-drivers-next.git, thanks.

501c0980b752 rsi: Add description for function param 'sta'
d7f95d9204ca brcmsmac: ampdu: Remove a bunch of unused variables
5763605890fe brcmfmac: p2p: Fix a bunch of function docs
a451ff855218 rsi: Add descriptions for rsi_set_vap_capabilities()'s parameters
dceb807b2f28 brcmsmac: main: Remove a bunch of unused variables
246fe9f15036 rsi: Source file headers do not make good kernel-doc candidates
866cf939f252 brcmfmac: firmware: Demote seemingly unintentional kernel-doc header
7a03124c1df5 rsi: File headers are not suitable for kernel-doc
35b7fbfc51d6 iwlegacy: 4965-mac: Convert function headers to standard comment blocks

-- 
https://patchwork.kernel.org/patch/11728371/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

