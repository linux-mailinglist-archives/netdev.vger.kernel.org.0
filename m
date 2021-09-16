Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFC540DDCB
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 17:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238610AbhIPPTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 11:19:20 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:49754 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238479AbhIPPTT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 11:19:19 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1631805479; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=W6szQ/LiyIiaf2JeeBlcAruOxPvIgc68+ew5H7jm+GE=; b=OP0KbVMtBWF/pk2auc0kk/As7qPgNn45+glDq/txAxx7W29yNDRwVI4nZERfKyao/zo8UXdm
 +U3+vo62GzXWAiQVD5IKgi4moslUsinfu3BfW8FP9IponbYMcitOsDx/f4Ci8xz2ipLVrAur
 AWfRibWZWb8PIQdVEYiyvzSN8Ak=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 6143601265c3cc8c6365f456 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 16 Sep 2021 15:17:38
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9E2EFC4361C; Thu, 16 Sep 2021 15:17:38 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9BCC1C4338F;
        Thu, 16 Sep 2021 15:17:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 9BCC1C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Len Baker <len.baker@gmx.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kees Cook <keescook@chromium.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] brcmfmac: Replace zero-length array with flexible array member
References: <20210904092217.2848-1-len.baker@gmx.com>
        <20210912191536.GB146608@embeddedor>
Date:   Thu, 16 Sep 2021 18:17:31 +0300
In-Reply-To: <20210912191536.GB146608@embeddedor> (Gustavo A. R. Silva's
        message of "Sun, 12 Sep 2021 14:15:36 -0500")
Message-ID: <87o88sy2gk.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavoars@kernel.org> writes:

> On Sat, Sep 04, 2021 at 11:22:17AM +0200, Len Baker wrote:
>> There is a regular need in the kernel to provide a way to declare
>> having a dynamically sized set of trailing elements in a structure.
>> Kernel code should always use "flexible array members"[1] for these
>> cases. The older style of one-element or zero-length arrays should
>> no longer be used[2].
>> 
>> Also, make use of the struct_size() helper in devm_kzalloc().
>> 
>> [1] https://en.wikipedia.org/wiki/Flexible_array_member
>> [2] https://www.kernel.org/doc/html/v5.14/process/deprecated.html#zero-length-and-one-element-arrays
>> 
>> Signed-off-by: Len Baker <len.baker@gmx.com>
>
> Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>
> I'll take this in my -next tree. :)

Why? It should go to wireless-drivers-next.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
