Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5811A31D748
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 11:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbhBQKGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 05:06:13 -0500
Received: from m42-2.mailgun.net ([69.72.42.2]:11975 "EHLO m42-2.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231793AbhBQKGG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 05:06:06 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1613556342; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=NACBgSaVoKefO4nYlVVRVr55kz4pXx2DcmCofVFHH7Q=; b=QJsJ3wHXrpmCsqRSTHzeCzZ6b96xCZiIH/Fj4giz9UNoszqfEKUUbHu/QmXU2kPxPnai9hyQ
 en0DVEsIoIbTCK4gLnqXiEoWlIMWjY/FVze3H0bhCgoSX+9PynivvbNQjM+kxHcIJizbAY3Z
 tNmy8vt/TVIXwB+O6A0DNEaCOrU=
X-Mailgun-Sending-Ip: 69.72.42.2
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 602cea58eb4f89cdf827e582 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 17 Feb 2021 10:05:12
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 19129C433C6; Wed, 17 Feb 2021 10:05:12 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F2ABFC433C6;
        Wed, 17 Feb 2021 10:05:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F2ABFC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Srinivasan Raju <srini.raju@purelifi.com>,
        mostafa.afgani@purelifi.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list\:NETWORKING DRIVERS \(WIRELESS\)" 
        <linux-wireless@vger.kernel.org>,
        "open list\:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: Re: [PATCH] [v13] wireless: Initial driver submission for pureLiFi STA devices
References: <20200928102008.32568-1-srini.raju@purelifi.com>
        <20210212115030.124490-1-srini.raju@purelifi.com>
        <ceb485a8811719e1d4f359b48ae073726ab4b3ba.camel@sipsolutions.net>
Date:   Wed, 17 Feb 2021 12:05:06 +0200
In-Reply-To: <ceb485a8811719e1d4f359b48ae073726ab4b3ba.camel@sipsolutions.net>
        (Johannes Berg's message of "Fri, 12 Feb 2021 14:44:05 +0100")
Message-ID: <87r1lfovql.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

>> +++ b/drivers/net/wireless/purelifi/Makefile
>> @@ -0,0 +1,2 @@
>> +# SPDX-License-Identifier: GPL-2.0-only
>> +obj-$(CONFIG_WLAN_VENDOR_PURELIFI)		:= plfxlc/
>
> Although this one doesn't do anything, so all you did was save a level
> of Kconfig inclusion I guess ... no real objection to that.

I think this should use obj-$(CONFIG_PLFXLC).

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
