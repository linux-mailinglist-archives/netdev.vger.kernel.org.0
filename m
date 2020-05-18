Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF731D7850
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 14:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgERMRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 08:17:44 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:29198 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726585AbgERMRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 08:17:44 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1589804264; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=gXT98i0A24jvgpR3VLzzjDcMw6z0mC5dHttghjpZqI0=;
 b=xdmcoKvU0TT6uKz14dbQbN5dBmgi0Mm84ui11s8pOCeIHTH6jD2imZ8a8hk18eKzgCF15zl1
 U92xhuMVof/w1a5Np0bQaVJJAmGOaX/8SphqoE1EkOudVMfT+ruq+hpOSYV1DmrUkVPewMtF
 ZeuWKhgGnMbmqLOSF4phlfW6Rlw=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5ec27ce7.7f97ccfd9730-smtp-out-n02;
 Mon, 18 May 2020 12:17:43 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 20D94C43636; Mon, 18 May 2020 12:17:42 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CFB42C433F2;
        Mon, 18 May 2020 12:17:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CFB42C433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] rtw88: 8723d: fix incorrect setting of ldo_pwr
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200514181329.16292-1-colin.king@canonical.com>
References: <20200514181329.16292-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200518121742.20D94C43636@smtp.codeaurora.org>
Date:   Mon, 18 May 2020 12:17:42 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently ldo_pwr has the LDO25 voltage bits set to zero and then
> it is overwritten with the new voltage setting. The assignment
> looks incorrect, it should be bit-wise or'ing in the new voltage
> setting rather than a direct assignment.
> 
> Addresses-Coverity: ("Unused value")
> Fixes: 1afb5eb7a00d ("rtw88: 8723d: Add cfg_ldo25 to control LDO25")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-drivers-next.git, thanks.

c5457559b626 rtw88: 8723d: fix incorrect setting of ldo_pwr

-- 
https://patchwork.kernel.org/patch/11549469/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
