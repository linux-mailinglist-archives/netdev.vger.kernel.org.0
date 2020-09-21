Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F82C2724FA
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbgIUNMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:12:47 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:44531 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727231AbgIUNMl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 09:12:41 -0400
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2020 09:12:41 EDT
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600693961; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=jPYut+8RHNZBwsOgqTf/k1AnklrA0DOtviGDY6GteVw=;
 b=WBjbg+lHCpJWBARf4mdREuFUZLZxA8pwxzwK2UyntAynEZ3nS9Avbwqcjl+dKJ2R3aDiQsZ4
 k90sWfcRat1ouybhOLYRI5c4BSSecri7UW4zdprOdUsHeuvxeQBsHKHrRGl2QRQYfaxzWQ6r
 WI0KQWqWUGWiGV/M+f/gRQChkJk=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5f68a49e6ace44caccfba944 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 21 Sep 2020 13:03:26
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 86C53C433FF; Mon, 21 Sep 2020 13:03:25 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8C6E0C433CA;
        Mon, 21 Sep 2020 13:03:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8C6E0C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH -next 1/9] rtlwifi: rtl8192ee: fix comparison to bool
 warning
 in hw.c
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200918102505.16036-2-zhengbin13@huawei.com>
References: <20200918102505.16036-2-zhengbin13@huawei.com>
To:     Zheng Bin <zhengbin13@huawei.com>
Cc:     <pkshih@realtek.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <yi.zhang@huawei.com>,
        <zhengbin13@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200921130325.86C53C433FF@smtp.codeaurora.org>
Date:   Mon, 21 Sep 2020 13:03:25 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zheng Bin <zhengbin13@huawei.com> wrote:

> Fixes coccicheck warning:
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c:797:6-33: WARNING: Comparison to bool
> 
> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>

9 patches applied to wireless-drivers-next.git, thanks.

027a4c9c305f rtlwifi: rtl8192ee: fix comparison to bool warning in hw.c
4cff897cb2f8 rtlwifi: rtl8192c: fix comparison to bool warning in phy_common.c
03ce81593951 rtlwifi: rtl8192cu: fix comparison to bool warning in mac.c
d87a8d4d5eef rtlwifi: rtl8821ae: fix comparison to bool warning in hw.c
07cc5f0345ae rtlwifi: rtl8821ae: fix comparison to bool warning in phy.c
77205bc3db80 rtlwifi: rtl8192cu: fix comparison to bool warning in hw.c
d544707ae078 rtlwifi: rtl8192ce: fix comparison to bool warning in hw.c
9dbde387e283 rtlwifi: rtl8192de: fix comparison to bool warning in hw.c
02686841d58f rtlwifi: rtl8723be: fix comparison to bool warning in hw.c

-- 
https://patchwork.kernel.org/patch/11784543/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

