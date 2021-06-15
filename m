Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F543A7C28
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 12:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbhFOKku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 06:40:50 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:59251 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231611AbhFOKks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 06:40:48 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623753524; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=JaKx1CKZIDx0TuLph45j+xEB4eubD8ZPfNMkov94gHA=;
 b=wSDpe72UwqeQ+3WIFGQneyMr4RquNHHLxLpRr+gnqWa3UHj7wx495UgLgwARof3+WL5sKRL/
 eozdkZtjNqzscgjD7N1Ol4ybvXk40IzBG26G9YsdXHL0AseWGXddNc2BEE4DnFj5PHW+SFWV
 Fm/39UbpclfgJp5JAY/4dQBA2Hc=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 60c88327ed59bf69cc3a59f9 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 15 Jun 2021 10:38:31
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 26C4FC433F1; Tue, 15 Jun 2021 10:38:31 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9AE40C433F1;
        Tue, 15 Jun 2021 10:38:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9AE40C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmfmac: Add clm_blob firmware files to modinfo
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210607103433.21022-1-matthias.bgg@kernel.org>
References: <20210607103433.21022-1-matthias.bgg@kernel.org>
To:     matthias.bgg@kernel.org
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        brcm80211-dev-list.pdl@broadcom.com,
        Remi Depommier <rde@setrix.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        linux-wireless@vger.kernel.org, Amar Shankar <amsr@cypress.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        SHA-cyfmac-dev-list@infineon.com, rafal@milecki.pl,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Lee Jones <lee.jones@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <mbrugger@suse.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Wright Feng <wright.feng@infineon.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210615103831.26C4FC433F1@smtp.codeaurora.org>
Date:   Tue, 15 Jun 2021 10:38:31 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

matthias.bgg@kernel.org wrote:

> From: Matthias Brugger <mbrugger@suse.com>
> 
> Cypress Wi-Fi chipsets include information regarding regulatory
> constraints. These are provided to the driver through "Country Local
> Matrix" (CLM) blobs. Files present in Linux firmware repository are
> on a generic world-wide safe version with conservative power
> settings which is designed to comply with regulatory but may not
> provide best performance on all boards. Never the less, a better
> functionality can be expected with the file present, so add it to the
> modinfo of the driver.
> 
> Signed-off-by: Matthias Brugger <mbrugger@suse.com>
> Reviewed-by: Hans de Goede <hdegoede@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

885f256f61f9 brcmfmac: Add clm_blob firmware files to modinfo

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210607103433.21022-1-matthias.bgg@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

