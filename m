Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830792CDA8C
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 16:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731090AbgLCP7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 10:59:37 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:55811 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728985AbgLCP7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 10:59:36 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607011150; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=cdvGZQjxy9e6wl42BhTU4hW30soCXTbLj1f9vFO1CQk=; b=bup7jRdyZF2vGbVDXL8s28j+b57ATsm6rXsouEGX4z67uHxD6czofqG5gy1KK+CmqO4O0ldq
 tf+lUb25/CWwBsqehyUXXYBwdc1e12YJE/s80+kJbNxxfFazDoSjDhRE+EnfOP5FmAq3SRrp
 EXK0ixLE5sr+N9fpwtMlQSRU6Fk=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-east-1.postgun.com with SMTP id
 5fc90b2d0b3fb596c8809fc3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 03 Dec 2020 15:58:37
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 61742C433ED; Thu,  3 Dec 2020 15:58:36 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2EB66C433C6;
        Thu,  3 Dec 2020 15:58:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2EB66C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     Mostafa Afgani <mostafa.afgani@purelifi.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list\:NETWORKING DRIVERS \(WIRELESS\)" 
        <linux-wireless@vger.kernel.org>,
        "open list\:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: Re: [PATCH] [v7] wireless: Initial driver submission for pureLiFi STA devices
References: <20201116092253.1302196-1-srini.raju@purelifi.com>
        <20201124144448.4E95EC43460@smtp.codeaurora.org>
        <CWXP265MB17998453F1460D55FA667E51E0F90@CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM>
        <CWXP265MB17995D2233C32796091FFEE4E0F20@CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM>
Date:   Thu, 03 Dec 2020 17:58:30 +0200
In-Reply-To: <CWXP265MB17995D2233C32796091FFEE4E0F20@CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM>
        (Srinivasan Raju's message of "Thu, 3 Dec 2020 04:43:30 +0000")
Message-ID: <87h7p2hoex.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Srinivasan Raju <srini.raju@purelifi.com> writes:

> we will be submitting to linux-firmware repository @
> https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
> I will share the link once it is accpeted, we have sent another
> version of the patch v8 , please review and provide your comments

What will be the directory structure in linux-firmware? It should be
unique so that it's not possible to mix with other drivers.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
