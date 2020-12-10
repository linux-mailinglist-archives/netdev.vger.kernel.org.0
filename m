Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E39612D5465
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 08:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387782AbgLJHRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 02:17:39 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:21413 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387768AbgLJHRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 02:17:32 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607584630; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=MulsTy2xpIxQLZhs1lE1ZqTDtAkjh+cX5VXMZpxMts0=; b=pFJWIrcIOHEakNM2ywjpYnYirCOeh2MY1tGdSl4QcAtPSA/ssT4JT2H1okDKnfEUL+MOT46f
 CdSZtRzwxiRCQiDeu4AthHYO3xRafnEceSotStlsxlC8u67FM5MihWTQKoKrm+mZLsx6D3fr
 YxKLdcp9Fxa3qE2mxOB4UA74Nuk=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 5fd1cb4e27e7db2389e2eca8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 10 Dec 2020 07:16:30
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6AB22C43464; Thu, 10 Dec 2020 07:16:29 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C7255C433C6;
        Thu, 10 Dec 2020 07:16:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C7255C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Souptick Joarder <jrdr.linux@gmail.com>
Cc:     nbd@nbd.name, lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mt76: Fixed kernel test robot warning
References: <1607542617-4005-1-git-send-email-jrdr.linux@gmail.com>
Date:   Thu, 10 Dec 2020 09:16:23 +0200
In-Reply-To: <1607542617-4005-1-git-send-email-jrdr.linux@gmail.com> (Souptick
        Joarder's message of "Thu, 10 Dec 2020 01:06:57 +0530")
Message-ID: <87ft4e9lmg.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Souptick Joarder <jrdr.linux@gmail.com> writes:

> Kernel test robot throws below warning ->
>
>    drivers/net/wireless/mediatek/mt76/tx.c: In function
> 'mt76_txq_schedule':
>>> drivers/net/wireless/mediatek/mt76/tx.c:499:21: warning: variable 'q'
>>> set but not used [-Wunused-but-set-variable]
>      499 |  struct mt76_queue *q;
>          |                     ^
>
> This patch will silence this warning.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>

I would like to take this directly to wireless-drivers-next, ok?

I'll also change the title to:

mt76: remove unused variable q

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
