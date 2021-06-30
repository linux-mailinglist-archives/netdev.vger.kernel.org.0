Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5783B7E43
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 09:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233085AbhF3Hl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 03:41:29 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:47950 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232812AbhF3Hl1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 03:41:27 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1625038738; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=uJxVvsiCedprGjRzxY3ikvKab0oW98BYPa0SrJjrBh0=; b=hXY4iPjdEA4vO6qDghTct5fLeWS5ZWqSsDgRaaV4Pq7aiQy5KQRcgRkULHS04Gx0JjLQFsGG
 nz0+EYKUI8FDMk+BGFyz968CiA3zwX2QdDNyF2xYXPyECyh/kljetC9khZ3WCPGgsZOGXVRK
 tDnm6pBzOAHlR4Tzi+4OXz+i2Zc=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 60dc1f923a8b6d0a4521bf1b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 30 Jun 2021 07:38:58
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D8187C43460; Wed, 30 Jun 2021 07:38:57 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 32558C4338A;
        Wed, 30 Jun 2021 07:38:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 32558C4338A
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Networking for v5.14
References: <20210630051855.3380189-1-kuba@kernel.org>
Date:   Wed, 30 Jun 2021 10:38:49 +0300
In-Reply-To: <20210630051855.3380189-1-kuba@kernel.org> (Jakub Kicinski's
        message of "Tue, 29 Jun 2021 22:18:55 -0700")
Message-ID: <871r8jhkdy.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> This is the networking PR for 5.14.

[...]

>  - Qualcomm 60GHz WiFi (wcn36xx)
>     - Wake-on-WLAN support with magic packets and GTK rekeying

wcn36xx is actually a driver for older Qualcomm mobile chipsets
supporting 802.11n and 802.11ac. But wil6210 driver supports Qualcomm
802.11ad devices working on 60GHz band. Not a big deal and very easy to
confuse the two, just wanted to clarify here :)

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
