Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B54DD15AD20
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 17:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728606AbgBLQTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 11:19:44 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:13376 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727279AbgBLQTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 11:19:44 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1581524383; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=4NwTvCo8RgdrG2PwPK9mKwPAXPNZcr/Cls7OZG7tvew=;
 b=xVADKFwvibCNYRiIDpj+tO/GzC6nt1izx9vKM/LdDkpCDtmPRzO9Or7islk+f/olJgt4IuRg
 SjYdAdziD8HPLmakU/lVR1DJ5216QMhEoPI/c+tXIncXyzim1epkqMysNHg4Lv1RV2lmzQW4
 y2uj2ewt6j1EjFXosTUrdOtJsC0=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e44259b.7fd96339c110-smtp-out-n02;
 Wed, 12 Feb 2020 16:19:39 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6BA23C433A2; Wed, 12 Feb 2020 16:19:38 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CF11AC43383;
        Wed, 12 Feb 2020 16:19:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CF11AC43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rsi: fix null pointer dereference during rsi_shutdown()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200129130259.21919-1-martin.kepplinger@puri.sm>
References: <20200129130259.21919-1-martin.kepplinger@puri.sm>
To:     Martin Kepplinger <martin.kepplinger@puri.sm>
Cc:     amitkarwar@gmail.com, siva8118@gmail.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Kepplinger <martin.kepplinger@puri.sm>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200212161938.6BA23C433A2@smtp.codeaurora.org>
Date:   Wed, 12 Feb 2020 16:19:38 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin Kepplinger <martin.kepplinger@puri.sm> wrote:

> Appearently the hw pointer can be NULL while the module is loaded and
> in that case rsi_shutdown() crashes due to the unconditional dereference.
> 
> Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>

Patch applied to wireless-drivers-next.git, thanks.

16bbc3eb8372 rsi: fix null pointer dereference during rsi_shutdown()

-- 
https://patchwork.kernel.org/patch/11356179/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
