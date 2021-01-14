Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDFE12F6690
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 18:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbhANQ6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 11:58:11 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:17263 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbhANQ6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 11:58:10 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610643465; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=jkIwY06O0wUyBtWVOFdvtfYKoyxjQ3BUh4gd4W2GS6o=;
 b=SwmZoRsHeR4eWLWRBsJ2iXd/NoJvIfCU/eUgGqAqze7qRlRsf/PoFRYInfoy1q975sVZNDr0
 wNQgfO+6BzBPaXOba0akbczNJKELMjI3zY/E65TXkAiVnvadb6coZAllMw+Bxk84ldgiGiUx
 HXJ+i9E9GYD7e5uTNSpXZoOmhNg=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 600077e1c88af06107d4d46b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 14 Jan 2021 16:57:05
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id F3E95C43461; Thu, 14 Jan 2021 16:57:04 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BED06C433C6;
        Thu, 14 Jan 2021 16:57:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BED06C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [1/2] iwlwifi: dbg: Don't touch the tlv data
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210112132449.22243-2-tiwai@suse.de>
References: <20210112132449.22243-2-tiwai@suse.de>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210114165704.F3E95C43461@smtp.codeaurora.org>
Date:   Thu, 14 Jan 2021 16:57:04 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Takashi Iwai <tiwai@suse.de> wrote:

> The commit ba8f6f4ae254 ("iwlwifi: dbg: add dumping special device
> memory") added a termination of name string just to be sure, and this
> seems causing a regression, a GPF triggered at firmware loading.
> Basically we shouldn't modify the firmware data that may be provided
> as read-only.
> 
> This patch drops the code that caused the regression and keep the tlv
> data as is.
> 
> Fixes: ba8f6f4ae254 ("iwlwifi: dbg: add dumping special device memory")
> BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1180344
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=210733
> Cc: stable@vger.kernel.org
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Acked-by: Luca Coelho <luciano.coelho@intel.com>

Patch applied to wireless-drivers.git, thanks.

a6616bc9a0af iwlwifi: dbg: Don't touch the tlv data

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210112132449.22243-2-tiwai@suse.de/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

