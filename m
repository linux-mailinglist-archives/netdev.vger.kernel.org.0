Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E29A278F8
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 11:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729797AbfEWJOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 05:14:23 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:34738 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfEWJOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 05:14:22 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B267B61112; Thu, 23 May 2019 09:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1558602861;
        bh=g/aF1fcs87FAU4oWz/pX9QK9P8kUWlwdWV9pHD7nOlE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=MBdhBgQxRamHtmzoI0eXKv484ccT7Vs7gaRulzQ32ALQpezPdbHcAZMaQXLhBR2nh
         UIq0Hg56GldP4LJDWCO9rohIRVGcofZe2+zjkHRp5dw9lcBNpGPk9Gq4wrN33+qN4I
         6Lto9BLJIZuREYKi9U4zk+nkxqgiQW+47i5KFPCo=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3499161112;
        Thu, 23 May 2019 09:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1558602860;
        bh=g/aF1fcs87FAU4oWz/pX9QK9P8kUWlwdWV9pHD7nOlE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=d1dwCVEK3jRwdE20TYG54xzHgUg2QyZlMYTa2zHEzPBZ5hz/Rj5LgWh5WLVZ85Esb
         TrKKCE5NIa7EeeRuyRrOxfnn7sDMEhOT/LIzVqzP7DiAVnrDQev/HA6jAqhqGrbnDh
         bz7iJlHKN63FiQeq2BY8nby4yd7wLgE/sMLFE2BA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3499161112
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Weitao Hou <houweitaoo@gmail.com>
Cc:     stas.yakovlev@gmail.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless: fix intel typos in code comments
References: <20190519033114.20271-1-houweitaoo@gmail.com>
Date:   Thu, 23 May 2019 12:14:16 +0300
In-Reply-To: <20190519033114.20271-1-houweitaoo@gmail.com> (Weitao Hou's
        message of "Sun, 19 May 2019 11:31:14 +0800")
Message-ID: <875zq1ednb.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Weitao Hou <houweitaoo@gmail.com> writes:

> fix lengh to length
>
> Signed-off-by: Weitao Hou <houweitaoo@gmail.com>
> ---
>  drivers/net/wireless/intel/ipw2x00/ipw2200.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Correct prefix is "ipw2x00:".

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#commit_title_is_wrong

-- 
Kalle Valo
