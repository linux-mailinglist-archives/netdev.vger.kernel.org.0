Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E82DF3F3B96
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 19:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbhHURPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 13:15:38 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:51548 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229767AbhHURPi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Aug 2021 13:15:38 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1629566098; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=8tuWtJdm0gv8MeU2PK5j9T89Ac8ieg+gtnkJSLcZI/U=;
 b=uh7/JAQVI/QYECkEi3U/f0G39wb6DfuMBT3N+SqysfSajQm51bVVrs/xlm1XRowtCE/thURG
 YxL4S4+FPAgeTKKlUwk2I1GZuNAbpe1iHNkJ33y/Zlnrt2679ohvAVEDPt86ubo/8E8Y3sPm
 EKOE2kDu+eYJQbXoYrWOWNHlYcA=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 6121347989fbdf3ffe762e4d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 21 Aug 2021 17:14:33
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B996DC4360C; Sat, 21 Aug 2021 17:14:32 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 744FAC4338F;
        Sat, 21 Aug 2021 17:14:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 744FAC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v1 1/1] ray_cs: use %*ph to print small buffer
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210712142943.23981-1-andriy.shevchenko@linux.intel.com>
References: <20210712142943.23981-1-andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210821171432.B996DC4360C@smtp.codeaurora.org>
Date:   Sat, 21 Aug 2021 17:14:32 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> Use %*ph format to print small buffer as hex string.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Patch applied to wireless-drivers-next.git, thanks.

502213fd8fca ray_cs: use %*ph to print small buffer

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210712142943.23981-1-andriy.shevchenko@linux.intel.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

