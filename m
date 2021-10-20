Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5395434881
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 12:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbhJTKGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 06:06:07 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:63565 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhJTKGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 06:06:06 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634724232; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=o0gcgeYG2TFJIRmkEmj991GpVd5q7c0MmgaoWSpdXII=; b=Ai0Pf75h9oyQhncYcvkuaEsbtDXaSLifSn1t/sI3w0JaeUEhFA+8c1FuDvIMHJjJdivzzbPk
 LFYSY5P11pyhndlkhBbZFvzrd6ojnkYJYVTuYaM+dCws8yQOpLJEqgKoFXRu8BcvkLDq4w5I
 9/e8d0XJJR08pD6ub5/vetacBIQ=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 616fe984b03398c06cf37809 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 20 Oct 2021 10:03:48
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0F4C1C4360D; Wed, 20 Oct 2021 10:03:48 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 01675C4338F;
        Wed, 20 Oct 2021 10:03:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 01675C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Pkshih <pkshih@realtek.com>
Cc:     "cgel.zte\@gmail.com" <cgel.zte@gmail.com>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "kuba\@kernel.org" <kuba@kernel.org>,
        "lv.ruyi\@zte.com.cn" <lv.ruyi@zte.com.cn>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] rtw89: fix error function parameter
References: <20211019035311.974706-1-lv.ruyi@zte.com.cn>
        <163471982441.1743.9901035714649893101.kvalo@codeaurora.org>
        <3aa076f0e39a485ca090f8c14682b694@realtek.com>
Date:   Wed, 20 Oct 2021 13:03:43 +0300
In-Reply-To: <3aa076f0e39a485ca090f8c14682b694@realtek.com> (Pkshih's message
        of "Wed, 20 Oct 2021 09:46:09 +0000")
Message-ID: <878ryof1xc.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pkshih <pkshih@realtek.com> writes:

>> -----Original Message-----
>> From: kvalo=codeaurora.org@mg.codeaurora.org
>> <kvalo=codeaurora.org@mg.codeaurora.org> On Behalf Of Kalle
>> Valo
>> Sent: Wednesday, October 20, 2021 4:50 PM
>> To: cgel.zte@gmail.com
>> Cc: davem@davemloft.net; kuba@kernel.org; Pkshih
>> <pkshih@realtek.com>; lv.ruyi@zte.com.cn;
>> linux-wireless@vger.kernel.org; netdev@vger.kernel.org;
>> linux-kernel@vger.kernel.org; Zeal Robot
>> <zealci@zte.com.cn>
>> Subject: Re: [PATCH] rtw89: fix error function parameter
>> 
>> cgel.zte@gmail.com wrote:
>> 
>> > From: Lv Ruyi <lv.ruyi@zte.com.cn>
>> >
>> > This patch fixes the following Coccinelle warning:
>> > drivers/net/wireless/realtek/rtw89/rtw8852a.c:753:
>> > WARNING  possible condition with no effect (if == else)
>> >
>> > Reported-by: Zeal Robot <zealci@zte.com.cn>
>> > Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
>> > Acked-by: Ping-Ke Shih <pkshih@realtek.com>
>> 
>> Failed to apply, please rebase on top of wireless-drivers-next.
>> 
>> error: patch failed: drivers/net/wireless/realtek/rtw89/rtw8852a.c:753
>> error: drivers/net/wireless/realtek/rtw89/rtw8852a.c: patch does not apply
>> error: Did you hand edit your patch?
>> It does not apply to blobs recorded in its index.
>> hint: Use 'git am --show-current-patch' to see the failed patch
>> Applying: rtw89: fix error function parameter
>> Using index info to reconstruct a base tree...
>> Patch failed at 0001 rtw89: fix error function parameter
>> 
>> Patch set to Changes Requested.
>> 
>
> I think this is because the patch is translated into spaces instead of tabs, 
> in this and following statements.
> "                if (is_2g)"

Ah, I did wonder why it failed as I didn't see any similar patches. We
have an item about this in the wiki:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#format_issues

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
