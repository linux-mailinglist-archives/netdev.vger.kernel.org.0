Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 472B5368299
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 16:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236584AbhDVOlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 10:41:36 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:48208 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237457AbhDVOle (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 10:41:34 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1619102459; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=x1vvDozinm7jk7m1TjKGp29FQDnz/k2DrKuj47qUZe8=;
 b=pG/jIMTvWzt8h6zt3zc+txFLnigE/t4bYOt2jbCa9Bgyt+q5gE1gyuwTHeETGDju8rZSvKBz
 LqoLnLroqRst+rwUBNVN/sM3pkAgjdS5rJru8/KpxQaa6DrcjaT5+AQ/28/BBLpSYZz0opl6
 eKcmdUFxNhAZ3Enimwj+7A4fZXs=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 60818af7febcffa80f71686b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 22 Apr 2021 14:40:55
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3613EC433D3; Thu, 22 Apr 2021 14:40:55 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DE639C433F1;
        Thu, 22 Apr 2021 14:40:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DE639C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] qtnfmac: Fix possible buffer overflow in
 qtnf_event_handle_external_auth
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210419145842.345787-1-leegib@gmail.com>
References: <20210419145842.345787-1-leegib@gmail.com>
To:     Lee Gibson <leegib@gmail.com>
Cc:     imitsyanko@quantenna.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lee Gibson <leegib@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210422144055.3613EC433D3@smtp.codeaurora.org>
Date:   Thu, 22 Apr 2021 14:40:55 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Gibson <leegib@gmail.com> wrote:

> Function qtnf_event_handle_external_auth calls memcpy without
> checking the length.
> A user could control that length and trigger a buffer overflow.
> Fix by checking the length is within the maximum allowed size.
> 
> Signed-off-by: Lee Gibson <leegib@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

130f634da1af qtnfmac: Fix possible buffer overflow in qtnf_event_handle_external_auth

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210419145842.345787-1-leegib@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

