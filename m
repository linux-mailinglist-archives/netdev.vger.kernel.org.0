Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35275149A27
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 11:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729345AbgAZKhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 05:37:46 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:63966 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729145AbgAZKhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 05:37:46 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580035065; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=Z75vo15kFHSAjpOh8gqvQcI40tUdEQ8bAOEe2NzjOZg=;
 b=CamIuXtyG6gfcFid4409AgzfidGlhfRrURfpDH9Rkp6luGKv1ECYrICsVNz6JMdfPbVki6Ov
 0pqB0kCAo6Ygvz5USifcqF/Fb6nIa8yImMa4OxKZE6BdGiXLqWGynMPIBkA2CQdPuv0rbHd2
 j9JQwvmkn6NDA1SbLq2EGZ/2XkE=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e2d6bf7.7fb04d30e810-smtp-out-n02;
 Sun, 26 Jan 2020 10:37:43 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 83EBBC433A2; Sun, 26 Jan 2020 10:37:43 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E43F3C433CB;
        Sun, 26 Jan 2020 10:37:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E43F3C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath11k: fix debugfs build failure
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200107215036.1333983-1-arnd@arndb.de>
References: <20200107215036.1333983-1-arnd@arndb.de>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Manikanta Pubbisetty <mpubbise@codeaurora.org>,
        John Crispin <john@phrozen.org>,
        Sven Eckelmann <seckelmann@datto.com>,
        Bhagavathi Perumal S <bperumal@codeaurora.org>,
        Anilkumar Kolli <akolli@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Ganesh Sesetti <gseset@codeaurora.org>,
        Govindaraj Saminathan <gsamin@codeaurora.org>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Karthikeyan Periyasamy <periyasa@codeaurora.org>,
        kbuild test robot <lkp@intel.com>,
        Maharaja Kennadyrajan <mkenna@codeaurora.org>,
        Miles Hu <milehu@codeaurora.org>,
        Muna Sinada <msinada@codeaurora.org>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Sathishkumar Muruganandam <murugana@codeaurora.org>,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        Sriram R <srirrama@codeaurora.org>,
        Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>,
        Venkateswara Naralasetty <vnaralas@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Tamizh chelvam <tamizhr@codeaurora.org>,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200126103743.83EBBC433A2@smtp.codeaurora.org>
Date:   Sun, 26 Jan 2020 10:37:43 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> wrote:

> When CONFIG_ATH11K_DEBUGFS is disabled, but CONFIG_MAC80211_DEBUGFS
> is turned on, the driver fails to build:
> 
> drivers/net/wireless/ath/ath11k/debugfs_sta.c: In function 'ath11k_dbg_sta_open_htt_peer_stats':
> drivers/net/wireless/ath/ath11k/debugfs_sta.c:416:4: error: 'struct ath11k' has no member named 'debug'
>   ar->debug.htt_stats.stats_req = stats_req;
>     ^~
> 
> It appears that just using the former symbol is sufficient here,
> adding a Kconfig dependency takes care of the corner cases.
> 
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

a45ceea5015d ath11k: fix debugfs build failure

-- 
https://patchwork.kernel.org/patch/11321921/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
