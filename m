Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD6AD4612CD
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 11:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353842AbhK2Ktk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 05:49:40 -0500
Received: from so254-9.mailgun.net ([198.61.254.9]:25613 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347736AbhK2Krh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 05:47:37 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1638182660; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=EYy6b5hWFicfkIWvWrRxTiyTV5nFfypYwlZhDzMSd6w=;
 b=f8iqjCGrsr6ECx4QOj4mXE5fSYwrzT63YBgR88bGr1pjGk095D5xRWdtxl6/nyXv0fVAOpWL
 rm1XGzuEpQqzL6c0mo+WjBWjBAlKCDeO3AuZwmBfkoMtxcxQuam47tiM64iNI3cjo4OqCVGD
 Hh0FIml0QnTXLqmcSvm2JPXvEoA=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n08.prod.us-east-1.postgun.com with SMTP id
 61a4af04df12ba53c4f6110e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 29 Nov 2021 10:44:20
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 60918C4360C; Mon, 29 Nov 2021 10:44:19 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F095CC4338F;
        Mon, 29 Nov 2021 10:44:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org F095CC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wlcore: no need to initialise statics to false
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20211113063551.257804-1-wangborong@cdjrlc.com>
References: <20211113063551.257804-1-wangborong@cdjrlc.com>
To:     Jason Wang <wangborong@cdjrlc.com>
Cc:     davem@davemloft.net, kuba@kernel.org, wangborong@cdjrlc.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163818265478.17830.9997465466705669475.kvalo@codeaurora.org>
Date:   Mon, 29 Nov 2021 10:44:19 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jason Wang <wangborong@cdjrlc.com> wrote:

> Static variables do not need to be initialized to false. The
> compiler will do that.
> 
> Signed-off-by: Jason Wang <wangborong@cdjrlc.com>

Patch applied to wireless-drivers-next.git, thanks.

fa4408b0799a wlcore: no need to initialise statics to false

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211113063551.257804-1-wangborong@cdjrlc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

