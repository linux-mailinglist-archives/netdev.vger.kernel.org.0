Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4D2F1E847E
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 19:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgE2RQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 13:16:21 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:32922 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726803AbgE2RQU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 13:16:20 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1590772580; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=BGui0kTfIvgcz8lNEynqPe2IR/LmNWw9UsE5DP5ka5Q=;
 b=rEeLMD709Jpoq/MJdbpUI7GAXjHRM/hWUW+9KU5WZVLGHyFuB+Ds1e6iHuMMuPze+KBgQRMT
 Vz0Xv67Mzi8g+OAXzaNYc0qRgwpssjgPWpJq1PsaFgJ8dGzs/LSj1Ju1E1VMdhD7gaVWNon5
 UfPbdBiTrAzO/sIeUXIyzhWZHDs=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 5ed14360ea0dfa490e7a61d5 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 29 May 2020 17:16:16
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 13332C433CA; Fri, 29 May 2020 17:16:16 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F2E91C433C9;
        Fri, 29 May 2020 17:16:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F2E91C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] libertas: Use shared constant for rfc1042 header
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200523212628.31526-1-pterjan@google.com>
References: <20200523212628.31526-1-pterjan@google.com>
To:     Pascal Terjan <pterjan@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pascal Terjan <pterjan@google.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200529171616.13332C433CA@smtp.codeaurora.org>
Date:   Fri, 29 May 2020 17:16:16 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pascal Terjan <pterjan@google.com> wrote:

> This is one of the 9 drivers redefining rfc1042_header.
> 
> Signed-off-by: Pascal Terjan <pterjan@google.com>

Patch applied to wireless-drivers-next.git, thanks.

729ef6b614a1 libertas: Use shared constant for rfc1042 header

-- 
https://patchwork.kernel.org/patch/11567011/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

