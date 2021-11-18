Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0EA9455454
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 06:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243122AbhKRFis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 00:38:48 -0500
Received: from so254-9.mailgun.net ([198.61.254.9]:14902 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242431AbhKRFip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 00:38:45 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1637213745; h=Content-Type: MIME-Version: Message-ID: Date:
 References: In-Reply-To: Subject: Cc: To: From: Sender;
 bh=oE5G/DRHgBHhIanOB0mL65M21ZsqgnalhQhS5iDkss8=; b=uGa8rSud93h/MrkqNpU7kmgCNmGociC5n4GQa2ORaCaZbonUR7y7X0i0vVLZGIfXIBfc79Mm
 JmlZD90qfp38LhMpaNFK/TDil6JVnU6wRMpGTuxfgcOMOGukeVDeeysb5NPsa3StHlnLc9xd
 mld6uXK68WZVvkidcHRspvDa0zk=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 6195e630665450d43a1048d2 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 18 Nov 2021 05:35:44
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8A2F4C43460; Thu, 18 Nov 2021 05:35:43 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BA1ECC4338F;
        Thu, 18 Nov 2021 05:35:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org BA1ECC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        ajay.kathat@microchip.com, claudiu.beznea@microchip.com,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH net-next 3/9] wilc1000: copy address before calling wilc_set_mac_address
In-Reply-To: <20211118041501.3102861-4-kuba@kernel.org> (Jakub Kicinski's
        message of "Wed, 17 Nov 2021 20:14:55 -0800")
References: <20211118041501.3102861-1-kuba@kernel.org>
        <20211118041501.3102861-4-kuba@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Thu, 18 Nov 2021 07:35:38 +0200
Message-ID: <87czmydo0l.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> wilc_set_mac_address() calls IO routines which don't guarantee
> the pointer won't be written to. Make a copy.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Kalle Valo <kvalo@codeaurora.org>

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
