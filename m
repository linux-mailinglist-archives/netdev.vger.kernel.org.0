Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808EA3F3AD0
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 15:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234466AbhHUNnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 09:43:32 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:33056 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234424AbhHUNnb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Aug 2021 09:43:31 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1629553372; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=+3hD0keNjM2fSKlKxzNlIIPlWObJlXI+6cdOTa4unVo=; b=V5+rSgeq6FRJ5sZjqWqUwEAHDf/rxUO3Ckj5PJSevz4O2qNznllQ8il+Eyu0B42mDNcrmQae
 aJnBsM6Jpsjd6NBmX6/80ogFn3KitIA1DPaEBAuQRXg79USNK+IqIWoX4FLKMcP6pYzfzY6e
 OOUJCAT7/Jsbh9zqadQEElxQAzQ=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 612102da89fbdf3ffe7a9bf8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 21 Aug 2021 13:42:50
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1F626C43618; Sat, 21 Aug 2021 13:42:50 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A1E14C43460;
        Sat, 21 Aug 2021 13:42:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org A1E14C43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     Mostafa Afgani <mostafa.afgani@purelifi.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list\:NETWORKING DRIVERS \(WIRELESS\)" 
        <linux-wireless@vger.kernel.org>,
        "open list\:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: Re: [PATCH] [v14] wireless: Initial driver submission for pureLiFi STA devices
References: <20200928102008.32568-1-srini.raju@purelifi.com>
        <20210226130810.119216-1-srini.raju@purelifi.com>
        <CWLP265MB17945FD418D1D242756B2AC4E0499@CWLP265MB1794.GBRP265.PROD.OUTLOOK.COM>
        <CWLP265MB321782CCA0CC2130A2D59A53E0F79@CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM>
Date:   Sat, 21 Aug 2021 16:42:44 +0300
In-Reply-To: <CWLP265MB321782CCA0CC2130A2D59A53E0F79@CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM>
        (Srinivasan Raju's message of "Tue, 10 Aug 2021 13:02:46 +0000")
Message-ID: <87eeamud63.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Srinivasan Raju <srini.raju@purelifi.com> writes:

> Could you please review this patch and let us know if there are any comments.
> And please let us know if any changes has to be made to the driver for getting into wireless-next. 
> We have already submitted the firmware for review as well. The patch is in "Awaiting Upstream" state for a long time. 
> Please let us know.

Reviewing new drivers is time consuming and it's not always easy to find
time for that. It's unfortunate that the review takes so long, but
please take into account that we are volunteers.

> https://patchwork.kernel.org/project/netdevbpf/patch/20210226130810.119216-1-srini.raju@purelifi.com/

You are looking at the wrong patchwork project, you should follow
linux-wireless project. Direct link below.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
