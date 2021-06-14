Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 131103A6AEB
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 17:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233640AbhFNPw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 11:52:29 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:41133 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233035AbhFNPw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 11:52:28 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623685825; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=5pyRclwcm2/LSGhYfSsEWdIddpSVgZ8qFjIq5uFIgaU=;
 b=Wg1Au2lLMkr6UkGcPDJCda2b7WdLl6fsvmgpw7gDxraPVRCA+jrUFMIu/Pdi2RyF502Z4oLm
 xRaFUU8gBxM2ej796zn+TQdoWfjO2iJaPmnOF8pkQU7DXAS4Wi4JAJNtC+pZSmUN8pecygjf
 B1QpOaigxCMPkpYWQfitWrWTjrc=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 60c77aa7e27c0cc77f78c735 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 14 Jun 2021 15:49:59
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 525A0C43217; Mon, 14 Jun 2021 15:49:58 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 29E98C433D3;
        Mon, 14 Jun 2021 15:49:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 29E98C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [wireless-drivers-next,1/4] wlcore: tidy up use of
 fw_log.actual_buff_size
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <E1lolvS-0003Ql-NJ@rmk-PC.armlinux.org.uk>
References: <E1lolvS-0003Ql-NJ@rmk-PC.armlinux.org.uk>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210614154958.525A0C43217@smtp.codeaurora.org>
Date:   Mon, 14 Jun 2021 15:49:58 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Russell King <rmk+kernel@armlinux.org.uk> wrote:

> Tidy up the use of fw_log.actual_buff_size - rather than reading it
> multiple times and applying the endian conversion, read it once into
> actual_len and use that instead.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

4 patches applied to wireless-drivers-next.git, thanks.

913112398d5e wlcore: tidy up use of fw_log.actual_buff_size
98e94771cadc wlcore: make some of the fwlog calculations more obvious
87ab9cbaee7c wlcore: fix bug reading fwlog
01de6fe49ca4 wlcore: fix read pointer update

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/E1lolvS-0003Ql-NJ@rmk-PC.armlinux.org.uk/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

