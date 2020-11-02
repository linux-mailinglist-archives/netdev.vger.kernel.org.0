Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B3C2A32D4
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 19:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgKBSXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 13:23:12 -0500
Received: from z5.mailgun.us ([104.130.96.5]:61233 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgKBSXM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 13:23:12 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604341391; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=dqjj5XYPLOsBUZFci9McQXFyjyvLlgH1shqiGfMW2TQ=;
 b=bGtXDREocsPmOBRJqV2huibRTpuCY3dWOJr9u2ZNCPI9suS/6N+f9EJYzrCqij/uOAssuo9P
 TqOBBl/o2XKi/ZcbWZkvrH83facql/iFzOAZmVIeDYJsaev/r2hcZMmV6hKygwdZrnXZ57o0
 eOf3xhdty8kxNvve+bL1lPSk/EM=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5fa04e52978460d05b92d27e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 02 Nov 2020 18:22:10
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 37565C433FF; Mon,  2 Nov 2020 18:22:10 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1DE90C433C6;
        Mon,  2 Nov 2020 18:22:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1DE90C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath9k: revert "ath9k: hif_usb: fix race condition between
 usb_get_urb() and usb_kill_anchored_urbs()"
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201012220809.23225-1-brookebasile@gmail.com>
References: <20201012220809.23225-1-brookebasile@gmail.com>
To:     Brooke Basile <brookebasile@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Brooke Basile <brookebasile@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201102182210.37565C433FF@smtp.codeaurora.org>
Date:   Mon,  2 Nov 2020 18:22:10 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Brooke Basile <brookebasile@gmail.com> wrote:

> A bug in USB/IP previously caused all syzkaller USB fuzzing instances to
> return false positives when testing crash reproducers.
> This patch reverts changes made in commit 03fb92a432ea which, due to
> this bug, returned false positives when tested and introduced new
> regressions.
> 
> Fixes: 03fb92a432ea ("ath9k: hif_usb: fix race condition between usb_get_urb() and usb_kill_anchored_urbs()")
> Signed-off-by: Brooke Basile <brookebasile@gmail.com>

More background info is needed so that I'm not reverting the revert soon. What
were the new regressions? Do you have a pointer to the discussion? All this
should be in the commit log. But I can add those, just provide them in this
thread.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201012220809.23225-1-brookebasile@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

