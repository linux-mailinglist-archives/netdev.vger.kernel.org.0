Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45204220A42
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 12:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731284AbgGOKkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 06:40:17 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:16406 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731273AbgGOKkQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 06:40:16 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1594809616; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=rhesm/uxAsVx8OaDzy9XmswXBa8f6uDYdnz29ayNJX4=;
 b=KWAbhQCWWC/szIqygX5uZJSHsBbJn9XUrBq1LEHoP24cAwQHf+ju+Jkte3D5YyMRe+TwL9yW
 nut9hvNgV5DE51UQlG7YvaCrGthM9gGReHtSioTKN6tk2DqnkYovJz+XYDz+ZATl9CzyQIx9
 QLJnA2PSIsNJ3E334blOCEn/Wns=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n14.prod.us-west-2.postgun.com with SMTP id
 5f0edd0fc9bd2efa2e289c08 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 15 Jul 2020 10:40:15
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4BE75C43391; Wed, 15 Jul 2020 10:40:15 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 06901C433C9;
        Wed, 15 Jul 2020 10:40:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 06901C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] iwlegacy: remove redundant initialization of variable
 tid
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200701135221.549700-1-colin.king@canonical.com>
References: <20200701135221.549700-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Stanislaw Gruszka <stf_xl@wp.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200715104015.4BE75C43391@smtp.codeaurora.org>
Date:   Wed, 15 Jul 2020 10:40:15 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable tid is being initialized with a value that is never read
> and it is being updated later with a new value.  The initialization is
> redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

ddfa943f246a iwlegacy: remove redundant initialization of variable tid

-- 
https://patchwork.kernel.org/patch/11636467/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

