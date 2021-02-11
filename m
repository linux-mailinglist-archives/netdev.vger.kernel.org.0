Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E92C318553
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 07:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbhBKGrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 01:47:00 -0500
Received: from so15.mailgun.net ([198.61.254.15]:55347 "EHLO so15.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229750AbhBKGqm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 01:46:42 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1613025976; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=DDsym//m5jdussff3Wt86VkIsApiHoTnfYkkw8P6hCw=;
 b=CUThMcmxdeFhbBWs99STPaW48aUs7QDqWZ8CIuYXoWNniJeuihwyLkjkWT73SqHiGhXVlcdX
 /Ku4OcLfyVPV/Mon7FsmzhSl2UAkWJ86Uy/tdASoCJKjLq+wwMra71f3ohGppGpFUev/ua3I
 Bx7s1nhBRRtnsIsPngPvwb48d/c=
X-Mailgun-Sending-Ip: 198.61.254.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 6024d2838e43a988b701b109 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 11 Feb 2021 06:45:23
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id F0F89C43461; Thu, 11 Feb 2021 06:45:22 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C146CC433C6;
        Thu, 11 Feb 2021 06:45:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C146CC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: brcmsmac: Fix the spelling configation to configuration in the
 file d11.h
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210209232921.1255425-1-unixbhaskar@gmail.com>
References: <20210209232921.1255425-1-unixbhaskar@gmail.com>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210211064522.F0F89C43461@smtp.codeaurora.org>
Date:   Thu, 11 Feb 2021 06:45:22 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bhaskar Chowdhury <unixbhaskar@gmail.com> wrote:

> s/configation/configuration/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> Acked-by: Randy Dunlap <rdunlap@infradead.org>

Patch applied to wireless-drivers-next.git, thanks.

1899e49385fd brcmsmac: Fix the spelling configation to configuration in the file d11.h

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210209232921.1255425-1-unixbhaskar@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

