Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED2B62212F3
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 18:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbgGOQsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 12:48:32 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:33685 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725770AbgGOQsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 12:48:32 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1594831712; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=Gk5I0Q4UUjtMKZvYOanMDGLRBzXb4Zpiap8jy7XxLrw=;
 b=jZk6Uc29jLtVV0KbjmbZO10Rz69ebknYDxoidRzQIS+FZRKPJUwF01hbsLsvz1EFn0V4tYhw
 1qJybj/xZKd4D+Rlumw1/Q5gLgj5vY7HmSZ2WF9HHm3db/gZOQ7jlqi5ZPRldOiyIn39ZL0u
 VCr/52I2+GzL3bvsE1z7UmWB/uM=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n13.prod.us-west-2.postgun.com with SMTP id
 5f0f335f166c1c54946e32b6 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 15 Jul 2020 16:48:31
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 54DE0C43395; Wed, 15 Jul 2020 16:48:31 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A843BC433C9;
        Wed, 15 Jul 2020 16:48:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A843BC433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 4/8] wireless: Fix trivial spelling
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200715124839.252822-5-kieran.bingham+renesas@ideasonboard.com>
References: <20200715124839.252822-5-kieran.bingham+renesas@ideasonboard.com>
To:     Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc:     trivial@kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Wenwen Wang <wenwen@cs.uga.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        ath10k@lists.infradead.org (open list:QUALCOMM ATHEROS ATH10K WIRELESS
        DRIVER),
        linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200715164831.54DE0C43395@smtp.codeaurora.org>
Date:   Wed, 15 Jul 2020 16:48:31 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kieran Bingham <kieran.bingham+renesas@ideasonboard.com> wrote:

> The word 'descriptor' is misspelled throughout the tree.
> 
> Fix it up accordingly:
>     decriptors -> descriptors
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Patch applied to wireless-drivers-next.git, thanks.

0e20c3e10333 wireless: Fix trivial spelling

-- 
https://patchwork.kernel.org/patch/11665283/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

