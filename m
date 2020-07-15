Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7838220A20
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 12:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731187AbgGOKg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 06:36:56 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:52535 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731167AbgGOKgz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 06:36:55 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1594809415; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=WaOxlPyfSHay8BRBP3nto7aXSzb/V/iBqWby18Sm0eI=;
 b=oXXUaI1TSnW31WAaIZ7aqABQ5cRXLMGYrNr6PcKBGx5Txl466ZPTkm7ZN5Plm1SMveeySVh0
 SlOp2FK5c9AlJNz7/1BvypvMU+jGi/pXxuJPlwNPhDbE6Ud4Wqb+pHOwJDZVvh8VpPljyRjo
 sJADHUnqTuFVHpS8Aq93l6hN3a8=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n16.prod.us-west-2.postgun.com with SMTP id
 5f0edc25512812c070d04d4d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 15 Jul 2020 10:36:21
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8EC1AC4339C; Wed, 15 Jul 2020 10:36:20 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A4AAAC433C9;
        Wed, 15 Jul 2020 10:36:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A4AAAC433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/1] orinoco_usb: fix spelling mistake
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200619093102.29487-1-f.suligoi@asem.it>
References: <20200619093102.29487-1-f.suligoi@asem.it>
To:     Flavio Suligoi <f.suligoi@asem.it>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Aditya Pakki <pakki001@umn.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Gustavo A . R . Silva" <gustavo@embeddedor.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Flavio Suligoi <f.suligoi@asem.it>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200715103620.8EC1AC4339C@smtp.codeaurora.org>
Date:   Wed, 15 Jul 2020 10:36:20 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Flavio Suligoi <f.suligoi@asem.it> wrote:

> Fix typo: "EZUSB_REQUEST_TRIGER" --> "EZUSB_REQUEST_TRIGGER"
> 
> Signed-off-by: Flavio Suligoi <f.suligoi@asem.it>

Patch applied to wireless-drivers-next.git, thanks.

ad806454c3cb orinoco_usb: fix spelling mistake

-- 
https://patchwork.kernel.org/patch/11613589/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

