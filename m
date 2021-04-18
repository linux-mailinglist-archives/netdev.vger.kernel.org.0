Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D003363401
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 08:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbhDRG2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 02:28:37 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:48225 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229993AbhDRG2f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Apr 2021 02:28:35 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1618727287; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=bm+tkpQ53HLk1k9+6qSXhjzzG6TPcgOuJEz3b8pjvqs=;
 b=bbjOOl+O6qzo9p3c3k96uywjajCpYSZRVctvi32s31hw2SbBr6FQvO6NfmgcNc02dE6mIiWR
 wNJMCGbntH3CzRJk2iFuzLaEGD9cI4tLVQij3y1aw0WCYR0Nr5ml/mt8ELthRO8K0PlxWwQV
 jP3lstmc21BxqzZ81iSwsybwiC4=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 607bd177215b831afb218103 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 18 Apr 2021 06:28:07
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3F3A9C4338A; Sun, 18 Apr 2021 06:28:07 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 76F01C433D3;
        Sun, 18 Apr 2021 06:28:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 76F01C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] rsi: fix comment syntax in file headers
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210315173259.8757-1-yashsri421@gmail.com>
References: <20210315173259.8757-1-yashsri421@gmail.com>
To:     Aditya Srivastava <yashsri421@gmail.com>
Cc:     yashsri421@gmail.com, lukas.bulwahn@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        amitkarwar@gmail.com, siva8118@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210418062807.3F3A9C4338A@smtp.codeaurora.org>
Date:   Sun, 18 Apr 2021 06:28:07 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Aditya Srivastava <yashsri421@gmail.com> wrote:

> The opening comment mark '/**' is used for highlighting the beginning of
> kernel-doc comments.
> There are some files in drivers/net/wireless/rsi which follow this syntax
> in their file headers, i.e. start with '/**' like comments, which causes
> unexpected warnings from kernel-doc.
> 
> E.g., running scripts/kernel-doc -none on drivers/net/wireless/rsi/rsi_coex.h
> causes this warning:
> "warning: wrong kernel-doc identifier on line:
>  * Copyright (c) 2018 Redpine Signals Inc."
> 
> Similarly for other files too.
> 
> Provide a simple fix by replacing such occurrences with general comment
> format, i.e., "/*", to prevent kernel-doc from parsing it.
> 
> Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
> Reviewed-by: Randy Dunlap <rdunlap@infradead.org>

Patch applied to wireless-drivers-next.git, thanks.

3051946056c3 rsi: fix comment syntax in file headers

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210315173259.8757-1-yashsri421@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

