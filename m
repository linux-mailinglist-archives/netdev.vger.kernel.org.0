Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC1A220848
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 11:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730513AbgGOJLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 05:11:23 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:33885 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728206AbgGOJLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 05:11:22 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1594804282; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=0/YCW5B7Rgcqq/98N36ELNpltv7+ewePsKHphVBSOPU=;
 b=SiwsoZsP5/2O5ZH/JKDU0XlxJZUs08kRyQVwC7Gpu+AVB3dNcKg0ZYLAYjfaWDj4goz+a/m0
 ESgIqabSOOMQjx/r2XFzyqLavxS6GE1ZYE/T2mYNyVY46K6iRiRNEyxdMBhdCpJ8K92Bs/hc
 bSYMJeSRLqJc+3W2MDkldJBeOyE=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5f0ec83975eeb235f65200f6 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 15 Jul 2020 09:11:21
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 76DB6C433CB; Wed, 15 Jul 2020 09:11:21 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 53C1DC433C9;
        Wed, 15 Jul 2020 09:11:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 53C1DC433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtw88: 8822ce: add support for device ID 0xc82f
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200612082745.204400-1-aaron.ma@canonical.com>
References: <20200612082745.204400-1-aaron.ma@canonical.com>
To:     Aaron Ma <aaron.ma@canonical.com>
Cc:     aaron.ma@canonical.com, yhchuang@realtek.com, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200715091121.76DB6C433CB@smtp.codeaurora.org>
Date:   Wed, 15 Jul 2020 09:11:21 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Aaron Ma <aaron.ma@canonical.com> wrote:

> New device ID 0xc82f found on Lenovo ThinkCenter.
> Tested it with c822 driver, works good.
> 
> PCI id:
> 03:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd.
> Device [10ec:c82f]
>         Subsystem: Lenovo Device [17aa:c02f]
> 
> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

7d428b1c9ffc rtw88: 8822ce: add support for device ID 0xc82f

-- 
https://patchwork.kernel.org/patch/11601385/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

