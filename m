Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 639F62C0FB0
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 17:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389845AbgKWP7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 10:59:22 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:42828 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389608AbgKWP7W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 10:59:22 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606147161; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=00OpK4o0NPNd7XNVkSwBJiMIlV8DgX3BA73j/1v6x6E=; b=SfWrm4m9c+lKIMaqFppTN1lr29Jtyd9osGFuD34go1KXVH/8uqZmNCuTmIr5wrAEQnH0mlXU
 71A+WHqzQCJUzqeh63+tMVUcEGmZpfb8BE/sAMUh+tKlg7ONza5ZauIhO5LBjF1QyMRxvmte
 EootcuavzZe3AjeROtRgFb49JDM=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n08.prod.us-east-1.postgun.com with SMTP id
 5fbbdc599e87e1635248db5a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 23 Nov 2020 15:59:20
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 28A9DC43463; Mon, 23 Nov 2020 15:59:20 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CD0D6C433C6;
        Mon, 23 Nov 2020 15:59:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CD0D6C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     hby <hby2003@163.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: Fix the Raspberry Pi debug version compile
References: <20201122100606.20289-1-hby2003@163.com>
Date:   Mon, 23 Nov 2020 17:59:12 +0200
In-Reply-To: <20201122100606.20289-1-hby2003@163.com> (hby's message of "Sun,
        22 Nov 2020 18:06:06 +0800")
Message-ID: <87r1okqd2n.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hby <hby2003@163.com> writes:

> enable the DEBUG in source code, and it will compile fail,
> modify the DEBUG macro, to adapt the compile
>
> Signed-off-by: hby <hby2003@163.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

This has nothing to do with Raspberry Pi, so the title should be:

brmcfmac: fix compile when DEBUG is defined

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
