Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5D9312FF3
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 12:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbhBHK7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 05:59:47 -0500
Received: from so15.mailgun.net ([198.61.254.15]:59653 "EHLO so15.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232682AbhBHK4g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 05:56:36 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612781777; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=Q76TjSodtr89rLbIry6PcAsBT6cKrUZhshGbb112ufY=;
 b=dZcywt0+QPjM6E708gSnPxF1Bi5k0PkhmzlO4MWXvi3A+5jETqFeF9wuKl7/mvAJ86YKCCKC
 5Bj8IW5+Wutu2Aytl+yLJdedkBKI5qIaTDF0GNUy9ceJzr3RYX8LQ7y/IwjOzt1fiF6lgmN7
 YkKil+PfG+ouLErgV+dz52Brefo=
X-Mailgun-Sending-Ip: 198.61.254.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 602118af8e43a988b7a8a3e2 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 08 Feb 2021 10:55:43
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CD38BC43463; Mon,  8 Feb 2021 10:55:43 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D5F62C433CA;
        Mon,  8 Feb 2021 10:55:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D5F62C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] brcmfmac: add support for CQM RSSI notifications
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210114163641.2427591-1-alsi@bang-olufsen.dk>
References: <20210114163641.2427591-1-alsi@bang-olufsen.dk>
To:     =?utf-8?q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?utf-8?q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210208105543.CD38BC43463@smtp.codeaurora.org>
Date:   Mon,  8 Feb 2021 10:55:43 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alvin Šipraga <ALSI@bang-olufsen.dk> wrote:

> Add support for CQM RSSI measurement reporting and advertise the
> NL80211_EXT_FEATURE_CQM_RSSI_LIST feature. This enables a userspace
> supplicant such as iwd to be notified of changes in the RSSI for roaming
> and signal monitoring purposes.
> 
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>

I'll drop this from my queue, please resend once the review is done.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210114163641.2427591-1-alsi@bang-olufsen.dk/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

