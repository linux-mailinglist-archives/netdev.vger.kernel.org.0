Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78CB1EC549
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 16:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbfKAPGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 11:06:44 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:50986 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727465AbfKAPGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 11:06:44 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id AFB5C60A73; Fri,  1 Nov 2019 15:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572620803;
        bh=QGrjxP0Q1hxFgggIGBv/txhGkOPTwLFgXJunU9zrvVw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=fLUMWRNGsCSQr8oc0dnamddDWuaQejGe/GaEAK9NNmQGEtam/Wmj347FXJryhyODw
         Aw76sUqcgIL3MOFH/025jj3W5I6wxe6LOU7xNBZBDKQmFTdL4Cc271ZDtouOkrzDAi
         Epo6l8jhbz9gJ3P5F/KQt1VTrKN95av0oO0B+o5c=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B91D060159;
        Fri,  1 Nov 2019 15:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572620803;
        bh=QGrjxP0Q1hxFgggIGBv/txhGkOPTwLFgXJunU9zrvVw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=fLUMWRNGsCSQr8oc0dnamddDWuaQejGe/GaEAK9NNmQGEtam/Wmj347FXJryhyODw
         Aw76sUqcgIL3MOFH/025jj3W5I6wxe6LOU7xNBZBDKQmFTdL4Cc271ZDtouOkrzDAi
         Epo6l8jhbz9gJ3P5F/KQt1VTrKN95av0oO0B+o5c=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B91D060159
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-2019-11-01
References: <20191101150116.2D76860A96@smtp.codeaurora.org>
Date:   Fri, 01 Nov 2019 17:06:40 +0200
In-Reply-To: <20191101150116.2D76860A96@smtp.codeaurora.org> (Kalle Valo's
        message of "Fri, 1 Nov 2019 15:01:16 +0000 (UTC)")
Message-ID: <87imo3d4an.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> writes:

> Hi,
>
> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.
>
> Kalle
>
> The following changes since commit d79749f7716d9dc32fa2d5075f6ec29aac63c76d:
>
>   ath10k: fix latency issue for QCA988x (2019-10-14 11:43:36 +0300)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-2019-11-01
>
> for you to fetch changes up to 3d206e6899a07fe853f703f7e68f84b48b919129:
>
>   iwlwifi: fw api: support new API for scan config cmd (2019-10-30 17:00:26 +0200)
>
> ----------------------------------------------------------------
> wireless-drivers fixes for 5.4
>
> Third set of fixes for 5.4. Most of them are for iwlwifi but important
> fixes also for rtlwifi and mt76, the overflow fix for rtlwifi being
> most important.
>
> iwlwifi
>
> * fix merge damage on earlier patch
>
> * various fixes to device id handling
>
> * fix scan config command handling which caused firmware asserts
>
> rtlwifi
>
> * fix overflow on P2P IE handling
>
> * don't deliver too small frames to mac80211
>
> mt76
>
> * disable PCIE_ASPM
>
> * fix buffer DMA unmap on certain cases
>
> ----------------------------------------------------------------

Finally I wrote a script for sending the pull request, after all these
years :) Everything looks to be ok, but please take a closer look just
in case I missed something.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
