Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCADA4843
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 09:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbfIAH6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 03:58:06 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53810 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728625AbfIAH6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Sep 2019 03:58:06 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 351C86076C; Sun,  1 Sep 2019 07:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567324685;
        bh=974SjN6QZWsWEDFEeAki0OUAagPFk6IXJOeZ9hxmZG4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Ypp3RiUnaf4UjG4JFBRk0KtJJpq+c1ED0evTexNyC2Fq8qVxDSP//JtQmMLLLCBvR
         WngVBWZlZmzdkStJYWoIfsAb7D2wAuyyagKLjIwWBzc0wNcCGK5jbrB+h3CxS80wgv
         9WO8SkCHSv/GN2L+35EvRRTSARk0ydINGxSqiJjc=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C597D60271;
        Sun,  1 Sep 2019 07:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567324684;
        bh=974SjN6QZWsWEDFEeAki0OUAagPFk6IXJOeZ9hxmZG4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=R9tUyQ8RiV2L9eV9/tVYrtdLtEd8GnG4XU1+3GYiVtCYqcMqA3g9R7E24mlI21far
         v9LSrRUnRzTH7l/2lFlZu3i1dgLYcxuOrNu8tYKNfJVlOcuqog6+fXPiemhWLSuOen
         Y5f5pqwxaSMpyFHNMsGRmp4oX6V81fpyfuMJegy0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C597D60271
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Hui Peng <benquike@gmail.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        "David S. Miller" <davem@davemloft.net>,
        Mathias Payer <mathias.payer@nebelwelt.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Fix a NULL-ptr-deref bug in ath6kl_usb_alloc_urb_from_pipe
References: <20190804002905.11292-1-benquike@gmail.com>
        <20190831180219.GA20860@roeck-us.net>
        <CAKpmkkXyhuTviRfJG9dG-=Pt0KKdoHaxhXdvW9tSadOoKfnP1w@mail.gmail.com>
Date:   Sun, 01 Sep 2019 10:58:00 +0300
In-Reply-To: <CAKpmkkXyhuTviRfJG9dG-=Pt0KKdoHaxhXdvW9tSadOoKfnP1w@mail.gmail.com>
        (Hui Peng's message of "Sat, 31 Aug 2019 14:16:53 -0400")
Message-ID: <87o904qwhj.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hui Peng <benquike@gmail.com> writes:

> The reason that this patch is still in the pending state is that it
> has not reviewed by maintainers (they are not responding).
> @Greg: can we apply it?

Who is "we" in this case? But anyway, I'll review the patch and if it's
ok I'll take it through my ath.git tree, as normal.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
