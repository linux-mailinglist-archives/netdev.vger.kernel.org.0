Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8590C273B93
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 09:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729768AbgIVHRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 03:17:02 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:62821 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729738AbgIVHRC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 03:17:02 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600759021; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=OaeM4NEyqjWeIso9yycjVyZDWBUr25mwctkFpUJli5U=;
 b=TBlL4g3ojx//BoJxGAxaRittMXkyTJeQ5eY8r3jLJhwuNKuhMSDqMhwvA0+EKWHMtFDyPu/a
 wYx0M+zn2fpHAOlpHfterStbG4LC6181NsewMlh7UW4WycwAYngZESjvoNSwxWz/Qhlx73X/
 h10TGErqCYd2JtI/XgamyOD2wrI=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 5f69a4ed4ab73023a7b197de (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 22 Sep 2020 07:17:01
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 583CCC433FF; Tue, 22 Sep 2020 07:17:01 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 06030C433C8;
        Tue, 22 Sep 2020 07:16:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 06030C433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: Use ffs in <foo>_phy_calculate_bit_shift
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <e2ab424d24b74901bc0c39f0c60f75e871adf2ba.camel@perches.com>
References: <e2ab424d24b74901bc0c39f0c60f75e871adf2ba.camel@perches.com>
To:     Joe Perches <joe@perches.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200922071701.583CCC433FF@smtp.codeaurora.org>
Date:   Tue, 22 Sep 2020 07:17:01 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Joe Perches <joe@perches.com> wrote:

> Remove the loop and use the generic ffs instead.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Patch applied to wireless-drivers-next.git, thanks.

6c1d61913570 rtlwifi: Use ffs in <foo>_phy_calculate_bit_shift

-- 
https://patchwork.kernel.org/patch/11786667/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

