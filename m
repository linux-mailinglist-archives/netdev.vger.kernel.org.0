Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B825E2C29F9
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 15:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389244AbgKXOoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 09:44:55 -0500
Received: from z5.mailgun.us ([104.130.96.5]:38689 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388913AbgKXOoy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 09:44:54 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606229094; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=GJYW42IjQPe76onlnrQnVKos7pxA3IfstGH6J+iXtwQ=;
 b=h6o34MxU31gkKwM7jpTcS6knMJGWTnAIXl0RphHio3S9TObAL3xvHtrdINVnjLfhoWt2Oxio
 YxezI5CDXMZ7VKwqIkSlZGin5g+xxwnxuxlwAYteXal+R0VzG2oaBn/i3OHnHyVF0L08fwIY
 q3cxEgys1jkgjvg19oetqdd0YA0=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 5fbd1c61a5c560669c94b940 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 24 Nov 2020 14:44:49
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 532C5C43461; Tue, 24 Nov 2020 14:44:48 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B24EDC43460;
        Tue, 24 Nov 2020 14:44:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B24EDC43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] [v7] wireless: Initial driver submission for pureLiFi STA
 devices
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201116092253.1302196-1-srini.raju@purelifi.com>
References: <20201116092253.1302196-1-srini.raju@purelifi.com>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     unlisted-recipients:; (no To-header on input)
        mostafa.afgani@purelifi.com,
        Srinivasan Raju <srini.raju@purelifi.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
Illegal-Object: Syntax error in Cc: address found on vger.kernel.org:
        Cc:     unlisted-recipients:; (no To-header on input)mostafa.afgani@purelifi.com
                                                                     ^-missing end of address
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201124144448.532C5C43461@smtp.codeaurora.org>
Date:   Tue, 24 Nov 2020 14:44:48 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Srinivasan Raju <srini.raju@purelifi.com> wrote:

> This introduces the pureLiFi LiFi driver for LiFi-X, LiFi-XC
> and LiFi-XL USB devices.
> 
> This driver implementation has been based on the zd1211rw driver.
> 
> Driver is based on 802.11 softMAC Architecture and uses
> native 802.11 for configuration and management.
> 
> The driver is compiled and tested in ARM, x86 architectures and
> compiled in powerpc architecture.
> 
> Signed-off-by: Srinivasan Raju <srini.raju@purelifi.com>
> 
> Changes v6->v7:
> - Magic numbers removed and used IEEE80211 macors
> - usb.c is split into two files firmware.c and dbgfs.c
> - Other code style and timer function fixes (mod_timer)
> Changes v5->v6:
> - Code style fix patch from Joe Perches
> Changes v4->v5:
> - Code refactoring for clarity and redundnacy removal
> - Fix warnings from kernel test robot
> Changes v3->v4:
> - Code refactoring based on kernel code guidelines
> - Remove multi level macors and use kernel debug macros
> Changes v2->v3:
> - Code style fixes kconfig fix
> Changes v1->v2:
> - v1 was submitted to staging, v2 submitted to wireless-next
> - Code style fixes and copyright statement fix

I haven't had a chance to review this yet but we have some documentation for new drivers:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#new_driver

Is the firmware publically available?

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201116092253.1302196-1-srini.raju@purelifi.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

