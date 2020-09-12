Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38EBB267841
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 08:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbgILGfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 02:35:02 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:44730 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725813AbgILGe6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Sep 2020 02:34:58 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1599892497; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=TZbeRycGRlE5zMmEDJ3WaYnEdaM+rXIMHX3RcmeDB2w=;
 b=eStWslLvbM6tI+/rBxUeifkKt+8vUp8wMiboWKvPGjlpRA4ZMosNGvx6Ash4iHiJLJFgGw6d
 FvIURuULAbdGH21PqU32jmXNCBBw34jT4helVD+teh3p3vAfTWqXC12lZpP6iJ0ea6fA84mP
 PXDeG8fXn5vMEzFbXYEPhbLSRpk=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5f5c6c10238e1efa37b2c9c6 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 12 Sep 2020 06:34:56
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C3FA3C433CA; Sat, 12 Sep 2020 06:34:55 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D0377C433CA;
        Sat, 12 Sep 2020 06:34:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D0377C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 06/29] wil6210: Fix a couple of formatting issues in
 'wil6210_debugfs_init'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200910065431.657636-7-lee.jones@linaro.org>
References: <20200910065431.657636-7-lee.jones@linaro.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200912063455.C3FA3C433CA@smtp.codeaurora.org>
Date:   Sat, 12 Sep 2020 06:34:55 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> wrote:

> Kerneldoc expects attributes/parameters to be in '@*.: ' format and
> gets confused if the variable does not follow the type/attribute
> definitions.
> 
> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/wireless/ath/wil6210/debugfs.c:456: warning: Function parameter or member 'wil' not described in 'wil6210_debugfs_init_offset'
>  drivers/net/wireless/ath/wil6210/debugfs.c:456: warning: Function parameter or member 'dbg' not described in 'wil6210_debugfs_init_offset'
>  drivers/net/wireless/ath/wil6210/debugfs.c:456: warning: Function parameter or member 'base' not described in 'wil6210_debugfs_init_offset'
>  drivers/net/wireless/ath/wil6210/debugfs.c:456: warning: Function parameter or member 'tbl' not described in 'wil6210_debugfs_init_offset'
> 
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: wil6210@qti.qualcomm.com
> Cc: netdev@vger.kernel.org
> Reviewed-by: Maya Erez <merez@codeaurora.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Aren't these also applied already? Please don't resend already applied
patches.

8 patches set to Rejected.

11766845 [06/29] wil6210: Fix a couple of formatting issues in 'wil6210_debugfs_init'
11766747 [16/29] wil6210: wmi: Fix formatting and demote non-conforming function headers
11766827 [17/29] wil6210: interrupt: Demote comment header which is clearly not kernel-doc
11766825 [18/29] wil6210: txrx: Demote obvious abuse of kernel-doc
11766823 [19/29] wil6210: txrx_edma: Demote comments which are clearly not kernel-doc
11766821 [20/29] wil6210: pmc: Demote a few nonconformant kernel-doc function headers
11766819 [21/29] wil6210: wil_platform: Demote kernel-doc header to standard comment block
11766817 [22/29] wil6210: wmi: Correct misnamed function parameter 'ptr_'

-- 
https://patchwork.kernel.org/patch/11766845/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

