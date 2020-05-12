Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470831CEF97
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 10:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729320AbgELIyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 04:54:21 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:62215 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729302AbgELIyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 04:54:20 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1589273660; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=4myBv0Eb7CjTFQWgbEm87difECtLoTIZZdLheI+zz60=;
 b=ONdj6k7RtxjLyLcyM3/G83Eo2KM9VByCCh/HECj9Iy0hh6dm/QFVmlZdXk1uIeh3IUceXVoQ
 XN2VFaxjZ1m2cpClzrI7GKukK9UthPU7wu7VA0ExKIVOhPoxqnYoTyQ5njm09rQYrFgrwDht
 vTet3QaF/sGSyzDEMwUF4RcSxbc=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eba6429.7f5a33950fb8-smtp-out-n05;
 Tue, 12 May 2020 08:54:01 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B5FC6C44788; Tue, 12 May 2020 08:54:00 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6B1F5C433CB;
        Tue, 12 May 2020 08:53:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6B1F5C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] b43: remove dead function b43_rssinoise_postprocess()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200507110741.37757-1-yanaijie@huawei.com>
References: <20200507110741.37757-1-yanaijie@huawei.com>
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <davem@davemloft.net>, <tglx@linutronix.de>,
        <linux-wireless@vger.kernel.org>, <b43-dev@lists.infradead.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jason Yan <yanaijie@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200512085400.B5FC6C44788@smtp.codeaurora.org>
Date:   Tue, 12 May 2020 08:54:00 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jason Yan <yanaijie@huawei.com> wrote:

> This function is dead for more than 10 years. Remove it.
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

f2cd32a443da rndis_wlan: Remove logically dead code

-- 
https://patchwork.kernel.org/patch/11533111/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
