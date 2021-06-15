Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 622D73A8103
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 15:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbhFONnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 09:43:53 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:25884 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231966AbhFONnS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 09:43:18 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623764474; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=DK3Tduj6WlNA4XTIQukfQbq6VdSpL/NzxsUFxSPPKBs=;
 b=wr0hYaYEv2QLlziXrgWMkPWIjXIM4XPSLVFv5WAFwnQbDatiVmEcRf3qlsOmsvexcrs7bsXS
 QN5Tt7GjKo52qupTBGn8fnvo/VM4L99JuX+x3EUeswjKX5kpqXHqmqvO2Uj7vSFY3B8eEsKT
 H3JENeIXdmvzMW8LvJHel+lSDwI=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 60c8adf2abfd22a3dc94f808 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 15 Jun 2021 13:41:06
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DEE84C43147; Tue, 15 Jun 2021 13:41:04 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2DE4DC43145;
        Tue, 15 Jun 2021 13:41:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2DE4DC43145
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: rtlwifi: Fix spelling of 'download'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210521062734.21284-1-dingsenjie@163.com>
References: <20210521062734.21284-1-dingsenjie@163.com>
To:     dingsenjie@163.com
Cc:     pkshih@realtek.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ding Senjie <dingsenjie@yulong.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210615134104.DEE84C43147@smtp.codeaurora.org>
Date:   Tue, 15 Jun 2021 13:41:04 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dingsenjie@163.com wrote:

> From: Ding Senjie <dingsenjie@yulong.com>
> 
> downlaod -> download
> 
> Signed-off-by: Ding Senjie <dingsenjie@yulong.com>

Patch applied to wireless-drivers-next.git, thanks.

03611cc526f9 rtlwifi: Fix spelling of 'download'

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210521062734.21284-1-dingsenjie@163.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

