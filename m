Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A465E2872D5
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 12:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729628AbgJHKws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 06:52:48 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:34405 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgJHKws (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 06:52:48 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1602154367; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=TG7j4a33OXv/9QSBNRmWQ1+MuRmM+sFz0/eucFHIWxo=;
 b=byF5wDYSNiFso5kQyELfQ6obK+GqaxRK+GiE7CAc3mw+JOhqp4Vgkc8nYDf4JPA0y+i24UsC
 42JcNbWHPhj9/cx1gebLQiMx31CsyHytqkkyXph6nmhYcF9aMFmh3xSXknKvIo0bznMJx9mj
 JdlfnaoFEV72YXs7qcJM5Zg+4fE=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5f7eef7e319d4e9cb5bd3fab (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 08 Oct 2020 10:52:46
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EB687C43382; Thu,  8 Oct 2020 10:52:45 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3FACFC433CB;
        Thu,  8 Oct 2020 10:52:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3FACFC433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] ath11k: fix memory leak of 'combinations'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201006174225.545919-1-colin.king@canonical.com>
References: <20201006174225.545919-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201008105245.EB687C43382@smtp.codeaurora.org>
Date:   Thu,  8 Oct 2020 10:52:45 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the error return path when 'limits' fails to allocate
> does not free the memory allocated for 'combinations'. Fix this
> by adding a kfree before returning.
> 
> Addresses-Coverity: ("Resource leak")
> Fixes: 2626c269702e ("ath11k: add interface_modes to hw_params")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Alex already sent an identical patch:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/?id=8431350eee2e27ae60f5250e0437ab298329070e

Patch set to Superseded.

-- 
https://patchwork.kernel.org/patch/11819025/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

