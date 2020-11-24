Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3B82C2AE1
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 16:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389611AbgKXPHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 10:07:42 -0500
Received: from z5.mailgun.us ([104.130.96.5]:15926 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730758AbgKXPHk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 10:07:40 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606230460; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=CQE5ufHjtN/HwwZQ6dfn1CRRN+SBia1nMPaNnSfSMcY=;
 b=LJ5aJSr1LX3sHI2lKUo0l4WuoLlmTczHeGpEvEilbWzvd5w0HSdnMTVMbDifGVebTh8x0nBe
 F2jwVUOcTMCFlkXNr454dZhMMnViUDTL3MlPTAJAyTquAKGj3WBQ/3Xz5RLkZYw1pQHtQZ1q
 JlWWBqXzqZqX38A102EAUP7cPXY=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 5fbd21b777b63cdb34180f1d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 24 Nov 2020 15:07:35
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 80599C43465; Tue, 24 Nov 2020 15:07:35 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AB763C433C6;
        Tue, 24 Nov 2020 15:07:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AB763C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mwifiex: Remove duplicated REG_PORT definition
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201119101204.72fd5f0a@xhacker.debian>
References: <20201119101204.72fd5f0a@xhacker.debian>
To:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201124150735.80599C43465@smtp.codeaurora.org>
Date:   Tue, 24 Nov 2020 15:07:35 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jisheng Zhang <Jisheng.Zhang@synaptics.com> wrote:

> The REG_PORT is defined twice, so remove one of them.
> 
> Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>

Patch applied to wireless-drivers-next.git, thanks.

3c72d3843e22 mwifiex: Remove duplicated REG_PORT definition

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201119101204.72fd5f0a@xhacker.debian/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

