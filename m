Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4752E31D763
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 11:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbhBQKPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 05:15:00 -0500
Received: from m42-2.mailgun.net ([69.72.42.2]:12323 "EHLO m42-2.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232294AbhBQKN7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 05:13:59 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1613556821; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=0GnC3gzb6NPfiHDXGrS5DaD4rAkL1uIis8KU0WkuDck=; b=xTVVXoirDOIMtq7zrTkmodPgqXnxhEz0MGqa1M2T9KTVb6qTnRkeAQmjnTnWLBcoGPE5TWPg
 pb3cQorDzM7C0yrz0t8DHIGhW9MoToj/6bPLBEeSKa6khOVcXAH7JROHOAhuap6wUM5aJzYN
 F/L97yQhH13cQmNxePFvtV2/N0c=
X-Mailgun-Sending-Ip: 69.72.42.2
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 602cec31a294c935b76047d7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 17 Feb 2021 10:13:05
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8D6EEC43462; Wed, 17 Feb 2021 10:13:04 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 480F0C433C6;
        Wed, 17 Feb 2021 10:13:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 480F0C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     mostafa.afgani@purelifi.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list),
        linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
Subject: Re: [PATCH] [v13] wireless: Initial driver submission for pureLiFi STA devices
References: <20200928102008.32568-1-srini.raju@purelifi.com>
        <20210212115030.124490-1-srini.raju@purelifi.com>
        <87v9arovvo.fsf@codeaurora.org>
Date:   Wed, 17 Feb 2021 12:13:00 +0200
In-Reply-To: <87v9arovvo.fsf@codeaurora.org> (Kalle Valo's message of "Wed, 17
        Feb 2021 12:02:03 +0200")
Message-ID: <87mtw3gfyr.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> writes:

> Srinivasan Raju <srini.raju@purelifi.com> writes:
>
>> This introduces the pureLiFi LiFi driver for LiFi-X, LiFi-XC
>> and LiFi-XL USB devices.
>>
>> This driver implementation has been based on the zd1211rw driver.
>>
>> Driver is based on 802.11 softMAC Architecture and uses
>> native 802.11 for configuration and management.
>>
>> The driver is compiled and tested in ARM, x86 architectures and
>> compiled in powerpc architecture.
>>
>> Signed-off-by: Srinivasan Raju <srini.raju@purelifi.com>
>
> I pushed this now to the pending branch of wireless-drivers-next for
> build testing, let's see what kind of results we get.

Ah, kbuild bot had already reported few issues:

https://patchwork.kernel.org/project/linux-wireless/patch/20210212115030.124490-1-srini.raju@purelifi.com/

Please fix those and I recommend waiting few days in case the bot finds
more issues. After that you can submitt v14 fixing the comments you got
in this review round.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
