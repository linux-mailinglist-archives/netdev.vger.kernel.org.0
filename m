Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCB141C6BC0
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 10:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728710AbgEFIai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 04:30:38 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:61172 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726935AbgEFIai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 04:30:38 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588753838; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=kOsCE+K1+9vGSPSNsL0vsTI07a8frxFk3jreyDx93Jg=;
 b=k7B/WAvYmV073emRTGr4qIe8P/WnRWENOhRsFmHeTbkNaReoTV/w2Ub85J1gd9ky2F4ezdw0
 5iovSUVYbfz0WxWUl7if/pkHWSmt0s/8S43t1/563+sIvwN0F7iA292c+YCD5QslFNHpGsFp
 8xWTlC5kLf0qelAmtumXZbN+CbI=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eb27592.7f42392bf730-smtp-out-n02;
 Wed, 06 May 2020 08:30:10 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DE136C44798; Wed,  6 May 2020 08:30:08 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 695A9C44793;
        Wed,  6 May 2020 08:30:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 695A9C44793
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/2] iopoll: Introduce read_poll_timeout_atomic macro
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200424184918.30360-1-kai.heng.feng@canonical.com>
References: <20200424184918.30360-1-kai.heng.feng@canonical.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     yhchuang@realtek.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dejin Zheng <zhengdejin5@gmail.com>,
        Allison Randal <allison@lohutok.net>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org (open list)
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200506083008.DE136C44798@smtp.codeaurora.org>
Date:   Wed,  6 May 2020 08:30:08 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kai-Heng Feng <kai.heng.feng@canonical.com> wrote:

> Like read_poll_timeout, an atomic variant for multiple parameter read
> function can be useful.
> 
> Will be used by a later patch.
> 
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

57a29df34146 iopoll: Introduce read_poll_timeout_atomic macro

-- 
https://patchwork.kernel.org/patch/11508809/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
