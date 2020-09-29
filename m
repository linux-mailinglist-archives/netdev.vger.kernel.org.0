Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9659E27BF4A
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 10:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbgI2IZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 04:25:47 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:36761 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbgI2IZr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 04:25:47 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1601367946; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=Mmer3bugB2xRynpfernBH9+GUGVN6Z0ZBCnOlNL98jk=;
 b=DzxxLE0GZS8xmGMDc9XszgVW9ihorQSF0CQWEgGFwOBOytFuHA996Fbtk9tNgfgPtpCeHlRB
 a5UuSpWTYCVVrTN5Q0huxp3ylnkwnexmiB2EkoCtbUJZ/wdue2xMYZcwCln/B1BQ7ZjQxG8Z
 f+sGoYsvGVQUXm3IX6IPDrjKz8A=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5f72ef8a9a923ee7a55e7861 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 29 Sep 2020 08:25:46
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4D176C433FE; Tue, 29 Sep 2020 08:25:46 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0E720C433F1;
        Tue, 29 Sep 2020 08:25:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0E720C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wl3501_cs: Remove unnecessary NULL check
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200926174558.9436-1-alex.dewar90@gmail.com>
References: <20200926174558.9436-1-alex.dewar90@gmail.com>
To:     Alex Dewar <alex.dewar90@gmail.com>
Cc:     unlisted-recipients:; (no To-header on input)
        Alex Dewar <alex.dewar90@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Illegal-Object: Syntax error in Cc: address found on vger.kernel.org:
        Cc:     unlisted-recipients:; (no To-header on input)Alex Dewar <alex.dewar90@gmail.com>
                                                                     ^-missing end of address
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200929082546.4D176C433FE@smtp.codeaurora.org>
Date:   Tue, 29 Sep 2020 08:25:46 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alex Dewar <alex.dewar90@gmail.com> wrote:

> In wl3501_detach(), link->priv is checked for a NULL value before being
> passed to free_netdev(). However, it cannot be NULL at this point as it
> has already been passed to other functions, so just remove the check.
> 
> Addresses-Coverity: CID 710499: Null pointer dereferences (REVERSE_INULL)
> Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

1d2a85382282 wl3501_cs: Remove unnecessary NULL check

-- 
https://patchwork.kernel.org/patch/11801615/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

