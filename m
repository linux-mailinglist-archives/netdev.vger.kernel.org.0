Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20C4D363188
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 19:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236887AbhDQRcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 13:32:22 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:24085 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236595AbhDQRcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 13:32:20 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1618680713; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=OvjCrB03pAZ717Waa/KK/ZXkatWv/Yu33xJzLdiQE5w=;
 b=k+qzQ75uLXGd7b9y1k4ESRRNlQ3Nv3f/S2PY23F3GwtFHK4d3FFOtQn5cHc65BCNI7DMaH9O
 Ejm3z1VyAUxY0zBOZs9Q7mJ//MyhVcYDgxf+PGI3DnHgccc+USa4maU7I4BAV6syep4TKGr2
 x9dBRkWebnKiZsu0hyqd1sgzfO0=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 607b1b83853c0a2c467a5e8e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 17 Apr 2021 17:31:47
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3C8E1C4338A; Sat, 17 Apr 2021 17:31:46 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B1ECEC433D3;
        Sat, 17 Apr 2021 17:31:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B1ECEC433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: remove rtl_get_tid_h
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <db340a67a95c119e4f9ba8fa99aea1c73d0dcfc9.1617383263.git.christophe.jaillet@wanadoo.fr>
References: <db340a67a95c119e4f9ba8fa99aea1c73d0dcfc9.1617383263.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     pkshih@realtek.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210417173146.3C8E1C4338A@smtp.codeaurora.org>
Date:   Sat, 17 Apr 2021 17:31:46 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> 'rtl_get_tid_h()' is the same as 'ieee80211_get_tid()'.
> So this function can be removed to save a line of code.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Patch applied to wireless-drivers-next.git, thanks.

987e9bcdd0b7 rtlwifi: remove rtl_get_tid_h

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/db340a67a95c119e4f9ba8fa99aea1c73d0dcfc9.1617383263.git.christophe.jaillet@wanadoo.fr/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

