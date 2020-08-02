Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E88922357C6
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 16:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbgHBO5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 10:57:05 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:64488 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725951AbgHBO5E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Aug 2020 10:57:04 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596380224; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=FGzGKZ5VVbzebKb6/1zAkWlel4gAZKDM5dA3vVO4/jk=;
 b=CIrs6chBk0w81OtqhhkQEQJTzX3wiv6nRjeWV2zBw5ll5wC+lYQhlBfHx6zin54o0ANuWDgh
 u14BAM7aylX7+EHR0tiD4pY2aa9nAZehVEE60BJHr4ZzG/OCrj8M8EwDi18ljp5RwDjSmm3S
 2uneEoHnyBFZK0x5npkojk20Uk0=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n15.prod.us-west-2.postgun.com with SMTP id
 5f26d41aba6d142d1c2cf7a3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 02 Aug 2020 14:56:26
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 353DCC433CA; Sun,  2 Aug 2020 14:56:26 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 07F30C433C6;
        Sun,  2 Aug 2020 14:56:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 07F30C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mwifiex: 11n_rxreorder: Remove unnecessary cast in
 kfree()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200727020405.8476-1-vulab@iscas.ac.cn>
References: <20200727020405.8476-1-vulab@iscas.ac.cn>
To:     Xu Wang <vulab@iscas.ac.cn>
Cc:     amitkarwar@gmail.com, ganapathi.bhat@nxp.com,
        huxinming820@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xu Wang <vulab@iscas.ac.cn>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200802145626.353DCC433CA@smtp.codeaurora.org>
Date:   Sun,  2 Aug 2020 14:56:26 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xu Wang <vulab@iscas.ac.cn> wrote:

> Remove unnecassary casts in the argument to kfree.
> 
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>

Patch applied to wireless-drivers-next.git, thanks.

614946480f8f mwifiex: 11n_rxreorder: Remove unnecessary cast in kfree()

-- 
https://patchwork.kernel.org/patch/11686265/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

