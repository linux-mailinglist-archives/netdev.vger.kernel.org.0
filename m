Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD45A2C6CF
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 14:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbfE1MnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 08:43:09 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:52428 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727201AbfE1MnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 08:43:09 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9879C60850; Tue, 28 May 2019 12:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559047388;
        bh=lCVRucRy9Sh6Z/3jPpo/oYImhufsBY/lliFa5yolGa4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=o25HtyBqfNi2i01JLZ5hxBYQjJ7vyTAKInSln/u1L+DO0giyKEgKn/FpCsMoR2jaO
         AcvOYi0p0bedIgz6LLgIUvsX28CApYTkpMxbugUvZdDxiM4Fmt9vjj/n0HdA5Qlc6u
         nqdxJiet48XhlVRYxzH9dHenkxiu4z5fEtpjs8qo=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7736B6070D;
        Tue, 28 May 2019 12:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559047387;
        bh=lCVRucRy9Sh6Z/3jPpo/oYImhufsBY/lliFa5yolGa4=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=awL5ZifMTWVpkswr4/nnP/KgwlWZaQqhJMqj+EwH2ZKy9jFreXTNSPTrqSsNTDnoy
         ZeXeLFO95+9oBDBHIbTvrC+1Ka7a8mldwzNljH7gnV0ejZmnshlkoX9O2SuEqArqDp
         /MaJbIZ3YTzR3Fx6TNH+hG/GOmGNsMH6/rMh2oqc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7736B6070D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] libertas: fix spelling mistake "Donwloading" ->
 "Downloading"
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190514211406.6353-1-colin.king@canonical.com>
References: <20190514211406.6353-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190528124308.9879C60850@smtp.codeaurora.org>
Date:   Tue, 28 May 2019 12:43:08 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> There is are two spelling mistakes in lbtf_deb_usb2 messages, fix these.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>

Patch applied to wireless-drivers-next.git, thanks.

aeffda6b10f8 libertas: fix spelling mistake "Donwloading" -> "Downloading"

-- 
https://patchwork.kernel.org/patch/10943765/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

