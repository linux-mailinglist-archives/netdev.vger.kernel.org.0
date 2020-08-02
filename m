Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07B2A2357EB
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 17:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgHBPIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 11:08:24 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:52398 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725951AbgHBPIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 11:08:24 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596380903; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=cvxSc4gEUIcYIWyzJ4Mw59VlVD4leSyPqAxWEQCt5i8=;
 b=WehmUc4OjSF5VrNTzYG3jZPWxQihbVw+j9LbWVdRyl7D8Qr7rE2w5bwB55W3xSfCLtP6Grsi
 ci6KMSJ9wAtfOofDx1b2+l0Ae2K7NdnWFNdKrcy1iv3aRok4pvJ66Y1Vc0e+WbwaDqqUMkLf
 VWuPa5KLlGm02NUyq7qFDpr5XaY=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-west-2.postgun.com with SMTP id
 5f26d6e7849144fbcb4609f8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 02 Aug 2020 15:08:23
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 19DF5C43391; Sun,  2 Aug 2020 15:08:23 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 68956C433C9;
        Sun,  2 Aug 2020 15:08:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 68956C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC PATCH] iwlwifi: yoyo: don't print failure if debug firmware
 is
 missing
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200625165210.14904-1-wsa@kernel.org>
References: <20200625165210.14904-1-wsa@kernel.org>
To:     Wolfram Sang <wsa@kernel.org>
Cc:     linux-wireless@vger.kernel.org, Wolfram Sang <wsa@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200802150823.19DF5C43391@smtp.codeaurora.org>
Date:   Sun,  2 Aug 2020 15:08:23 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wolfram Sang <wsa@kernel.org> wrote:

> Missing this firmware is not fatal, my wifi card still works. Even more,
> I couldn't find any documentation what it is or where to get it. So, I
> don't think the users should be notified if it is missing. If you browse
> the net, you see the message is present is in quite some logs. Better
> remove it.
> 
> Signed-off-by: Wolfram Sang <wsa@kernel.org>

Patch applied to wireless-drivers-next.git, thanks.

3f4600de8c93 iwlwifi: yoyo: don't print failure if debug firmware is missing

-- 
https://patchwork.kernel.org/patch/11625759/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

