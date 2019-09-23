Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 651CBBAF94
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 10:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406178AbfIWIam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 04:30:42 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:59192 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404824AbfIWIaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 04:30:39 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C8F5360850; Mon, 23 Sep 2019 08:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569227438;
        bh=HnVJwJj5gHPia0BvUBaqff8A/iNw+l5vst68Tr3N/wc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=kiAR8ZIHao1pQs13hKha1x/JKGbQjIH1jPav2rr2uOwx+O3dRvuRxe4pENeyeoszX
         3QT6Et+F4jpSZDqLparwjzFWJM9OYODtT/8CtJlxJ/LSTnMK7WSdNas/o5an3nqWAZ
         lVAvT1DBYttVy/BTHQhBlxrmRjYW141yM3Jtn4BI=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id ED8E66034D;
        Mon, 23 Sep 2019 08:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569227438;
        bh=HnVJwJj5gHPia0BvUBaqff8A/iNw+l5vst68Tr3N/wc=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=jOn1C3cwpkY5l/Q8GPPzdvehHy/RTXK8Eh/7pzSYj3BnRI0IbqEQcSk1gRC528yjN
         o7Dk+uuuKQMbqGBDU+ri+4EDNOP6pbznwHhO3eVe4CKYVGte4DxjoDeMepHFSroUS5
         Nz+WFL6FQU7XVqX7ZKYWWSyxZ8llGG0ajGe1oYGs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org ED8E66034D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: fix memory leak
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190920013632.30796-1-navid.emamdoost@gmail.com>
References: <20190920013632.30796-1-navid.emamdoost@gmail.com>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     unlisted-recipients:; (no To-header on input) emamd001@umn.edu,
        smccaman@umn.edu, kjlu@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Illegal-Object: Syntax error in Cc: address found on vger.kernel.org:
        Cc:     unlisted-recipients:; (no To-header on input)emamd001@umn.edu
                                                                     ^-missing end of address
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190923083038.C8F5360850@smtp.codeaurora.org>
Date:   Mon, 23 Sep 2019 08:30:38 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Navid Emamdoost <navid.emamdoost@gmail.com> wrote:

> In ath10k_usb_hif_tx_sg the allocated urb should be released if
> usb_submit_urb fails.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

b8d17e7d93d2 ath10k: fix memory leak

-- 
https://patchwork.kernel.org/patch/11153699/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

