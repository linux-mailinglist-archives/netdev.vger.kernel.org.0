Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A44363412
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 08:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbhDRGd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 02:33:26 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:32964 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229871AbhDRGdZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Apr 2021 02:33:25 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1618727578; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=AbkSR2sdys2ByIHjFH62xDi3FJMqmZV3XS5P/RsVMKo=;
 b=L8snOcinuf1PUpwC8IklqKuZ0xV67gh5G+93Kb7dHA6Ude6Tr2aGdPA/tKN/9fHNZaFoWEDh
 aB4a+6agz4cSVDl9FRweAYcMzf2ck3dSKwoCUuhStZf9SezRy6ZF1HqFLgsNADvCKZS8Rq/s
 RGOLkLI3UnTKtN3aYSgIazPyf3M=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 607bd292a817abd39ad37e58 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 18 Apr 2021 06:32:50
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0EF6EC43217; Sun, 18 Apr 2021 06:32:50 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C37F1C433F1;
        Sun, 18 Apr 2021 06:32:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C37F1C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [2/2] wl3501: fix typo of 'Networks' in comment
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210331010418.1632816-2-dslin1010@gmail.com>
References: <20210331010418.1632816-2-dslin1010@gmail.com>
To:     Eric Lin <dslin1010@gmail.com>
Cc:     romieu@fr.zoreil.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, gustavoars@kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210418063250.0EF6EC43217@smtp.codeaurora.org>
Date:   Sun, 18 Apr 2021 06:32:50 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Lin <dslin1010@gmail.com> wrote:

> Signed-off-by: Eric Lin <dslin1010@gmail.com>
> Reported-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Patch applied to wireless-drivers-next.git, thanks.

7f50ddc5d4fe wl3501: fix typo of 'Networks' in comment

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210331010418.1632816-2-dslin1010@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

