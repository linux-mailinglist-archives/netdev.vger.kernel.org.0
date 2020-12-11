Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1CC2D7E17
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 19:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405841AbgLKS26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 13:28:58 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:26059 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731564AbgLKS2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 13:28:55 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607711312; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=oryGkYBZLctiChHEbMyugddvyjEotYdnJsGqR/JGfDo=;
 b=nV9WivCpfikcWR1Q6NFrl09Vh3waQDanNulTZuokrpXRaD/FwzpB1ZJvBP2uU1lV8BJ1gimF
 2SAz12kwRdPm6vVKvKFQcMnTBvvzRHhBkB0PToL7aFlPL8dVMrHzYi83wAP7eec6ZLj/kigf
 hes6EBKBjDEgYBH7bYmlywTZEPk=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5fd3ba3053d7c5ba600ef9a8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 11 Dec 2020 18:28:00
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2C244C43463; Fri, 11 Dec 2020 18:28:00 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B8F4FC433C6;
        Fri, 11 Dec 2020 18:27:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B8F4FC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: mt76: remove unused variable q
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1607542617-4005-1-git-send-email-jrdr.linux@gmail.com>
References: <1607542617-4005-1-git-send-email-jrdr.linux@gmail.com>
To:     Souptick Joarder <jrdr.linux@gmail.com>
Cc:     nbd@nbd.name, lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Souptick Joarder <jrdr.linux@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201211182800.2C244C43463@smtp.codeaurora.org>
Date:   Fri, 11 Dec 2020 18:28:00 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Souptick Joarder <jrdr.linux@gmail.com> wrote:

> Kernel test robot reported warning:
> 
>    drivers/net/wireless/mediatek/mt76/tx.c: In function
> 'mt76_txq_schedule':
> >> drivers/net/wireless/mediatek/mt76/tx.c:499:21: warning: variable 'q'
> >> set but not used [-Wunused-but-set-variable]
>      499 |  struct mt76_queue *q;
>          |                     ^
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

7f469b6dc484 mt76: remove unused variable q

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1607542617-4005-1-git-send-email-jrdr.linux@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

