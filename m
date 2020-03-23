Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F92618FB99
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 18:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbgCWRgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 13:36:36 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:24671 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727000AbgCWRgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 13:36:35 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1584984994; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=sMKzO7VMmSiDEKm+iag8bUI3yWB0fYYk5tZ+Aj8NAxQ=;
 b=mPAeF4SF5ukHYeBr6Tdi2kFMwvbaqgLXSZzZ3bDOJy/KOlu38/yUURWmSUuMdSlIp0SUzQKN
 2pJkBRMbBIpPF+umCCSrgUkC00LgAuP4naD6UC2+JXWZxDCu5l6BsGKxCEP/4oJD+Dgo6eIQ
 7jU7cWo8jiMxUx8IR1ZHoJCkv4M=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e78f38a.7fd0d5675f48-smtp-out-n05;
 Mon, 23 Mar 2020 17:36:10 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 12273C44791; Mon, 23 Mar 2020 17:36:08 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 46C9AC433D2;
        Mon, 23 Mar 2020 17:36:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 46C9AC433D2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtl8xxxu: Fix sparse warning: cast from restricted __le16
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200319064341.49500-1-chiu@endlessm.com>
References: <20200319064341.49500-1-chiu@endlessm.com>
To:     Chris Chiu <chiu@endlessm.com>
Cc:     Jes.Sorensen@gmail.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com,
        kbuild test robot <lkp@intel.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200323173609.12273C44791@smtp.codeaurora.org>
Date:   Mon, 23 Mar 2020 17:36:08 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chris Chiu <chiu@endlessm.com> wrote:

> Fix the warning reported by sparse as:
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:4819:17: sparse: sparse: cast from restricted __le16
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:4892:17: sparse: sparse: cast from restricted __le16
> 
> Signed-off-by: Chris Chiu <chiu@endlessm.com>
> Reported-by: kbuild test robot <lkp@intel.com>
> Acked-by: Jes Sorensen <jes@trained-monkey.org>

Patch applied to wireless-drivers-next.git, thanks.

8d4ccd7770e7 rtl8xxxu: Fix sparse warning: cast from restricted __le16

-- 
https://patchwork.kernel.org/patch/11446567/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
