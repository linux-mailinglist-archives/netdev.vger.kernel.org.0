Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE8631C6BFB
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 10:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbgEFIlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 04:41:21 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:62037 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728362AbgEFIlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 04:41:20 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588754479; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=i7nuZc8uwgW1O87RmeOuyyULvnez8iy3arBS76U4f/Y=;
 b=fNNbXuEINx4Jol8+EFMJgR0xWo4HO5vCJdW2+LsiCz8lvU2WzDIwGlvyIzw/R3iv+wNGBhdy
 4J2ME/Fr7DToeap+DtCpw/rGvW5vVjlq/uK4wG8SQcMivc/962tivIxH1rekb97AGuE8O3iv
 ZF9jKxhsyVFfQLMOJnya/gu3zQo=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eb2782e.7f698d848d18-smtp-out-n03;
 Wed, 06 May 2020 08:41:18 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 66713C4478F; Wed,  6 May 2020 08:41:18 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C30CAC433BA;
        Wed,  6 May 2020 08:41:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C30CAC433BA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmfmac: remove Comparison to bool in
 brcmf_p2p_send_action_frame()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200504113346.41342-1-yanaijie@huawei.com>
References: <20200504113346.41342-1-yanaijie@huawei.com>
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <arend.vanspriel@broadcom.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <chi-hsien.lin@cypress.com>,
        <wright.feng@cypress.com>, <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jason Yan <yanaijie@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200506084118.66713C4478F@smtp.codeaurora.org>
Date:   Wed,  6 May 2020 08:41:18 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jason Yan <yanaijie@huawei.com> wrote:

> Fix the following coccicheck warning:
> 
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:1781:9-12:
> WARNING: Comparison to bool
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:1785:5-8:
> WARNING: Comparison to bool
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> Reviewed-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>

Failed to apply, please rebase to top of wireless-drivers-next and send
v2.

Recorded preimage for 'drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c'
error: Failed to merge in the changes.
Applying: brcmfmac: remove Comparison to bool in brcmf_p2p_send_action_frame()
Using index info to reconstruct a base tree...
M	drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
CONFLICT (content): Merge conflict in drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
Patch failed at 0001 brcmfmac: remove Comparison to bool in brcmf_p2p_send_action_frame()
The copy of the patch that failed is found in: .git/rebase-apply/patch

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/11525539/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
