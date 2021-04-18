Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF8C8363404
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 08:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236897AbhDRG3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 02:29:22 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:42853 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236807AbhDRG3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 02:29:18 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1618727330; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=MeN09NuswJR/Ed1K0FGBULBdthOWFD5NUyEd/XoXkcU=;
 b=qTFWuoccUtPQUon5sKPgTSkPUs0WRhAfu0eZz7xC7ADIzBt19zgrNsqL8FJdTEVOK0/iVJTQ
 t0ajLpa4H4pCVq7r0bqUgq5NaqfNL++HNjRGUNK6pogdeleXpd4hfO/qArDgoMny6Nh+izW7
 KGvMMPggko5buYlYsz47OFmgC5Y=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 607bd1a1a817abd39ad108a7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 18 Apr 2021 06:28:49
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7D958C433D3; Sun, 18 Apr 2021 06:28:48 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 40189C433D3;
        Sun, 18 Apr 2021 06:28:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 40189C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmfmac: A typo fix
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210323043657.1466296-1-unixbhaskar@gmail.com>
References: <20210323043657.1466296-1-unixbhaskar@gmail.com>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@infineon.com,
        wright.feng@infineon.com, chung-hsien.hsu@infineon.com,
        davem@davemloft.net, kuba@kernel.org, unixbhaskar@gmail.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210418062848.7D958C433D3@smtp.codeaurora.org>
Date:   Sun, 18 Apr 2021 06:28:48 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bhaskar Chowdhury <unixbhaskar@gmail.com> wrote:

> s/revsion/revision/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

705b5cfab183 brcmfmac: A typo fix

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210323043657.1466296-1-unixbhaskar@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

