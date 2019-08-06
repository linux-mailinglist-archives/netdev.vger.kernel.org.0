Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3CA83153
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 14:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730833AbfHFM3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 08:29:41 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55466 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbfHFM3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 08:29:41 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BB8896074F; Tue,  6 Aug 2019 12:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565094580;
        bh=/2rANzPNu+fmIIhCG4/y17LYPGKbT0KCS3C5GpdhO8w=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=gGuUmK/jIPtkwECOk2r1iO4CRX9ynXJkfkEXLfnMoEV1PQqOAW4mSEK/RKB086pm1
         eA3tZatHBFxLngLolZ6M2ziH0eLukbNwRUL1XiPM7N9lrYt4lS8ulv9zmjDpdKhMBv
         aa1a1V6oE4vdsUJit4554q57DE6yMsFKypdc7YU0=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0AD636019D;
        Tue,  6 Aug 2019 12:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565094580;
        bh=/2rANzPNu+fmIIhCG4/y17LYPGKbT0KCS3C5GpdhO8w=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=gGuUmK/jIPtkwECOk2r1iO4CRX9ynXJkfkEXLfnMoEV1PQqOAW4mSEK/RKB086pm1
         eA3tZatHBFxLngLolZ6M2ziH0eLukbNwRUL1XiPM7N9lrYt4lS8ulv9zmjDpdKhMBv
         aa1a1V6oE4vdsUJit4554q57DE6yMsFKypdc7YU0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0AD636019D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     amitkarwar@gmail.com, nishants@marvell.com, gbhat@marvell.com,
        huxinming820@gmail.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] marvell wireless: cleanup -- make error values consistent
References: <20190724095015.GA6592@amd>
Date:   Tue, 06 Aug 2019 15:29:35 +0300
In-Reply-To: <20190724095015.GA6592@amd> (Pavel Machek's message of "Wed, 24
        Jul 2019 11:50:15 +0200")
Message-ID: <87y306eats.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

> Surrounding code uses -ERRNO as a result, so don't pass plain -1.
>
> Signed-off-by: Pavel Machek <pavel@denx.de>

For some reason patchwork (or my patchwork script) didn't like this
patch:

Failed to apply the patch: ['git', 'am', '-s', '-3'] failed: 128
Patch is empty. Was it split wrong?

So I applied this manually:

6334dea8880a mwifiex: make error values consistent in mwifiex_update_bss_desc_with_ie()

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
