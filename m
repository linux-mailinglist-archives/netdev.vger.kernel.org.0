Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C29C12F67C3
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 18:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbhANRcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 12:32:12 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:62273 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbhANRcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 12:32:11 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610645507; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=9qH3IVRNhjrMOUv0NJoR4vJLOQLOtLb8+zpJNAaKVFU=;
 b=aVzdZUJifbWtVF12zzP8LXGPmEUT1JXDhiZHUzg9C+7EvLt4mwXtnuC9wDGo1WjdVjc9rUzD
 7fivK4dSP9naK5zEQxb36dENkJ1NoxQY8nH+y5p3eR2JFR65XlknDQXXtgY4eN7W/eEQitAt
 V4u/DUSbC2KhZXvojjOTqwexSOw=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 60007ff3415a6293c5b6ee96 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 14 Jan 2021 17:31:31
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2207DC433CA; Thu, 14 Jan 2021 17:31:31 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DBE79C433C6;
        Thu, 14 Jan 2021 17:31:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DBE79C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] qtnfmac_pcie: Use module_pci_driver
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201221075735.197255-1-ameynarkhede03@gmail.com>
References: <20201221075735.197255-1-ameynarkhede03@gmail.com>
To:     Amey Narkhede <ameynarkhede03@gmail.com>
Cc:     imitsyanko@quantenna.com, geomatsi@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Amey Narkhede <ameynarkhede03@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210114173131.2207DC433CA@smtp.codeaurora.org>
Date:   Thu, 14 Jan 2021 17:31:31 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Amey Narkhede <ameynarkhede03@gmail.com> wrote:

> Use module_pci_driver for drivers whose init and exit functions
> only register and unregister, respectively.
> 
> Signed-off-by: Amey Narkhede <ameynarkhede03@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

0924ba9fbc26 qtnfmac_pcie: Use module_pci_driver

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201221075735.197255-1-ameynarkhede03@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

