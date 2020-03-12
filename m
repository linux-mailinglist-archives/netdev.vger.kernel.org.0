Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 057C51831D4
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 14:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbgCLNnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 09:43:06 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:34578 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727007AbgCLNnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 09:43:06 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1584020586; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=Y/dcz94yMDkLEqXytCTThtLkiGIChjJJikH8kQiomQU=;
 b=LkRxFw1HUjmhhxq1LA6YV1b0zWBg4QfvHggJywU0eVAbrH8ssdKw5DBIR5j+nRQ8i55j5ycG
 4zQgG+XXYrxDKAvF9Q5lG0WTulcPns3a9GXMw0uSiu+gGz2jUvkMQNIgnaMGYjV4/ElTxwAB
 FGLg6Ze0wiMWUlu1wvJRnvLGUL4=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e6a3c68.7fc4bb397d50-smtp-out-n01;
 Thu, 12 Mar 2020 13:43:04 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 82B12C4478C; Thu, 12 Mar 2020 13:43:02 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 473FFC433CB;
        Thu, 12 Mar 2020 13:42:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 473FFC433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] libertas: Use new structure for SPI transfer delays
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200227140634.9286-1-sergiu.cuciurean@analog.com>
References: <20200227140634.9286-1-sergiu.cuciurean@analog.com>
To:     Sergiu Cuciurean <sergiu.cuciurean@analog.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        <libertas-dev@lists.infradead.org>, <davem@davemloft.net>,
        <gregkh@linuxfoundation.org>, <dcbw@redhat.com>,
        <allison@lohutok.net>, <tglx@linutronix.de>,
        Sergiu Cuciurean <sergiu.cuciurean@analog.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200312134302.82B12C4478C@smtp.codeaurora.org>
Date:   Thu, 12 Mar 2020 13:43:02 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sergiu Cuciurean <sergiu.cuciurean@analog.com> wrote:

> In a recent change to the SPI subsystem [1], a new `delay` struct was added
> to replace the `delay_usecs`. This change replaces the current
> `delay_usecs` with `delay` for this driver.
> 
> The `spi_transfer_delay_exec()` function [in the SPI framework] makes sure
> that both `delay_usecs` & `delay` are used (in this order to preserve
> backwards compatibility).
> 
> [1] commit bebcfd272df6 ("spi: introduce `delay` field for
> `spi_transfer` + spi_transfer_delay_exec()")
> 
> Signed-off-by: Sergiu Cuciurean <sergiu.cuciurean@analog.com>

Patch applied to wireless-drivers-next.git, thanks.

32521a913852 libertas: Use new structure for SPI transfer delays

-- 
https://patchwork.kernel.org/patch/11408719/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
