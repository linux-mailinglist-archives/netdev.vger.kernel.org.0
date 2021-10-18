Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B42743192E
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 14:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhJRMg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 08:36:28 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:28027 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbhJRMg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 08:36:28 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634560457; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=78huWSW48dpLsjExYLT1rNtU/f7bhv2g8eGApbb/7BE=;
 b=XEFYweGaPkn7RKZaf20SSq+/xOsL88qfCCOwhkRAt9X5PWMaB2ykRqytGFe+avJXdCPpkaBl
 +wYAmC2dUYMde85YkNq8YPI0r+guePE+owB1G5mhaRM6GDD5GJiYrDvrkN8EiI7bnGabq5wf
 YuEeMnX6UiviZIsYDCVE6JzXyaY=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 616d69ba30ce13d2b4b16ea1 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 18 Oct 2021 12:34:02
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BA6BDC4360C; Mon, 18 Oct 2021 12:34:02 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B8F3FC4338F;
        Mon, 18 Oct 2021 12:33:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org B8F3FC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wireless: ath5k: replace snprintf in show functions with
 sysfs_emit
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1634095651-4273-1-git-send-email-wangqing@vivo.com>
References: <1634095651-4273-1-git-send-email-wangqing@vivo.com>
To:     Qing Wang <wangqing@vivo.com>
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qing Wang <wangqing@vivo.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163456043468.24652.4752103758451442171.kvalo@codeaurora.org>
Date:   Mon, 18 Oct 2021 12:34:02 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Qing Wang <wangqing@vivo.com> wrote:

> coccicheck complains about the use of snprintf() in sysfs show functions.
> 
> Fix the coccicheck warning:
> WARNING: use scnprintf or sprintf.
> 
> Use sysfs_emit instead of scnprintf or sprintf makes more sense.
> 
> Signed-off-by: Qing Wang <wangqing@vivo.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

65b4b8aa0f59 ath5k: replace snprintf in show functions with sysfs_emit

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1634095651-4273-1-git-send-email-wangqing@vivo.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

