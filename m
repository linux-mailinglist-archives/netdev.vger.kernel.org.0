Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37B8B3A8042
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 15:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbhFONhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 09:37:25 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:35644 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbhFONhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 09:37:18 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623764114; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=UKtsXMpVK9SiGqVXzkLqYeEov0vtg1GMx8MgB0t1nN0=;
 b=oMxS76syRRg+bIKUHgzPSosUuKNlI9T8YONIQwUdkphAs++29LIA3CZsz9MGyyhTF4OFJy6+
 tX9rjXgyX+90Rt9E17EvynDWnCL2H7k/HF+bLEKzlhrYeJGbp+63z4pN9pLsD8tOzWpulbFF
 q/wjnHaRTHa7AznCQx+mkrUJiXk=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 60c8ac88ed59bf69ccf64755 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 15 Jun 2021 13:35:04
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1900CC4314A; Tue, 15 Jun 2021 13:35:03 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E82F4C43143;
        Tue, 15 Jun 2021 13:34:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E82F4C43143
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] ipw2x00: Minor documentation update
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1619348088-6887-1-git-send-email-jrdr.linux@gmail.com>
References: <1619348088-6887-1-git-send-email-jrdr.linux@gmail.com>
To:     Souptick Joarder <jrdr.linux@gmail.com>
Cc:     stas.yakovlev@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Souptick Joarder <jrdr.linux@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210615133504.1900CC4314A@smtp.codeaurora.org>
Date:   Tue, 15 Jun 2021 13:35:03 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Souptick Joarder <jrdr.linux@gmail.com> wrote:

> Kernel test robot throws below warning ->
> 
> drivers/net/wireless/intel/ipw2x00/ipw2100.c:5359: warning: This comment
> starts with '/**', but isn't a kernel-doc comment. Refer
> Documentation/doc-guide/kernel-doc.rst
> 
> Minor update in documentation.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Acked-by: Randy Dunlap <rdunlap@infradead.org>

Fails to apply, please rebase.

Recorded preimage for 'drivers/net/wireless/intel/ipw2x00/ipw2100.c'
error: Failed to merge in the changes.
hint: Use 'git am --show-current-patch' to see the failed patch
Applying: ipw2x00: Minor documentation update
Using index info to reconstruct a base tree...
M	drivers/net/wireless/intel/ipw2x00/ipw2100.c
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/intel/ipw2x00/ipw2100.c
CONFLICT (content): Merge conflict in drivers/net/wireless/intel/ipw2x00/ipw2100.c
Patch failed at 0001 ipw2x00: Minor documentation update

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1619348088-6887-1-git-send-email-jrdr.linux@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

