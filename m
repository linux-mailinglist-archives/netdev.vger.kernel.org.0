Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1291A972E
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 10:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894910AbgDOIoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 04:44:37 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:61196 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2894890AbgDOIof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 04:44:35 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1586940274; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=K0n+uFFwjyt7y0sfF2oMV5T+6Qw2oX3OPdXJliksZq0=;
 b=mOKStShuW267cGDIbUEjQ6BCP8Rg5AHg2kqXXHabXCt58OFNht6TfNOFVu5LmniZZzKea/4w
 8AsrtNHT7tq0C0zvbTGi0YiwhC/rtR7mZ6nYs6ap4IxDulaU4AgNb4vmo1IaviM8h+sGfXZR
 sJCKAOIw8+yjeRaEupeJQ9Aa+7k=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e96c95a.7f8e8a169c70-smtp-out-n02;
 Wed, 15 Apr 2020 08:44:10 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3744EC43636; Wed, 15 Apr 2020 08:44:10 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 12768C433CB;
        Wed, 15 Apr 2020 08:44:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 12768C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 4/9] brcmsmac: Add missing annotation for
 brcms_rfkill_set_hw_state()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200411001933.10072-5-jbi.octave@gmail.com>
References: <20200411001933.10072-5-jbi.octave@gmail.com>
To:     Jules Irenge <jbi.octave@gmail.com>
Cc:     linux-kernel@vger.kernel.org, boqun.feng@gmail.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org (open list:BROADCOM BRCM80211
        IEEE802.11n WIRELESS DRIVER),
        brcm80211-dev-list.pdl@broadcom.com (open list:BROADCOM BRCM80211
        IEEE802.11n WIRELESS DRIVER),
        brcm80211-dev-list@cypress.com (open list:BROADCOM BRCM80211
        IEEE802.11n WIRELESS DRIVER),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200415084410.3744EC43636@smtp.codeaurora.org>
Date:   Wed, 15 Apr 2020 08:44:10 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jules Irenge <jbi.octave@gmail.com> wrote:

> Sparse reports a warning at brcms_rfkill_set_hw_state()
> 
> warning: context imbalance in brcms_rfkill_set_hw_state()
> 	- unexpected unlock
> The root cause is the missing annotation at brcms_rfkill_set_hw_state()
> Add the missing __must_hold(&wl->lock) annotation
> 
> Signed-off-by: Jules Irenge <jbi.octave@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

2fe5efb8a475 brcmsmac: Add missing annotation for brcms_rfkill_set_hw_state()

-- 
https://patchwork.kernel.org/patch/11483837/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
