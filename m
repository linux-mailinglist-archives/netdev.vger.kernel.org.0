Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBAE1220A4C
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 12:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731267AbgGOKkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 06:40:40 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:57675 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731196AbgGOKkk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 06:40:40 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1594809639; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=sLdqw6vO/Dx5gVEAynTfPJwz0Jq0muScd1+nrlQdM8c=;
 b=ArzoTwlpQEAxCDcCi2x/6QXPXLZXLf4PHPY3BnFUtwJ9IgnyXXrSrOHjZ0twhysquqE8SBgY
 tEhJjwQq59ZVteAyyt09i443h7gAXY/7yheJz2Y6VEYt3KYYlGiX50QBaSVoPiOJdcXpWdpp
 ify0vr8XqdZbuvDMwXm8+TIxfWs=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 5f0edd27e3bee12510d09f72 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 15 Jul 2020 10:40:39
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7B85BC433C9; Wed, 15 Jul 2020 10:40:38 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 728C1C433CB;
        Wed, 15 Jul 2020 10:40:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 728C1C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] airo: use set_current_state macro
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200702015701.8606-1-vulab@iscas.ac.cn>
References: <20200702015701.8606-1-vulab@iscas.ac.cn>
To:     Xu Wang <vulab@iscas.ac.cn>
Cc:     davem@davemloft.net, kuba@kernel.org, mpe@ellerman.id.au,
        akpm@linux-foundation.org, wenwen@cs.uga.edu, adobriyan@gmail.com,
        dan.carpenter@oracle.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xu Wang <vulab@iscas.ac.cn>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200715104038.7B85BC433C9@smtp.codeaurora.org>
Date:   Wed, 15 Jul 2020 10:40:38 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xu Wang <vulab@iscas.ac.cn> wrote:

> Use set_current_state macro instead of current->state = TASK_RUNNING.
> 
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>

Patch applied to wireless-drivers-next.git, thanks.

b28bd97c1c19 airo: use set_current_state macro

-- 
https://patchwork.kernel.org/patch/11637715/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

