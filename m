Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8DE1E8483
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 19:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbgE2RQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 13:16:46 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:32922 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726954AbgE2RQp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 13:16:45 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1590772605; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=mJKUz4CIZUqI98CIevAKDZtR27eFLL8hGZq/6XQOjX0=;
 b=XMcvWgZt5863NntMtTthbctB4BcaDKTfz1tlD0tbT6lGlMeUrDBYmdDiONRHeIBratL/9ZHb
 vzikaEn5UVofAVbWSZ29bbUcZRbrQ9/jWYk6DlF7+FSuYHPpVMYznYdcG0halSakBGY4bbIk
 4sd2WRQv0flcrOjidbZ+xPjwTOQ=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 5ed1437844a25e00521de032 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 29 May 2020 17:16:40
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 82EF1C4339C; Fri, 29 May 2020 17:16:39 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 64A4CC433C6;
        Fri, 29 May 2020 17:16:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 64A4CC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] atmel: Use shared constant for rfc1042 header
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200523212735.32364-1-pterjan@google.com>
References: <20200523212735.32364-1-pterjan@google.com>
To:     Pascal Terjan <pterjan@google.com>
Cc:     Simon Kelley <simon@thekelleys.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pascal Terjan <pterjan@google.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200529171639.82EF1C4339C@smtp.codeaurora.org>
Date:   Fri, 29 May 2020 17:16:39 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pascal Terjan <pterjan@google.com> wrote:

> This is one of the 9 drivers redefining rfc1042_header.
> 
> Signed-off-by: Pascal Terjan <pterjan@google.com>

Patch applied to wireless-drivers-next.git, thanks.

e78e5d18c653 atmel: Use shared constant for rfc1042 header

-- 
https://patchwork.kernel.org/patch/11567013/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

