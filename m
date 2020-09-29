Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E804D27BE44
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 09:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbgI2HnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 03:43:02 -0400
Received: from z5.mailgun.us ([104.130.96.5]:15470 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbgI2HnB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 03:43:01 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1601365381; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=oqlmjzVRyWPtw3R2pIJ5rZv2jG/Zpd+i0rqfebSzAUw=; b=GA+BfBqq2a34RumZKC0Vr6esV9DrYI0PHEljCDvCWvwUP6vEeQMzGe8vBlDyYwyrLHwJ8mYv
 geQKmDGIvRrXPviGwsAMvcu4UlyGEmIduLLSPQcScDSlMI3zHYpvCGISh7C2XxD9qrwiXRSi
 99vzJAYe1CsrpjfVuhePw0decwM=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5f72e5857e9d6827ecf9dd19 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 29 Sep 2020 07:43:01
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 00D92C433F1; Tue, 29 Sep 2020 07:43:01 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8E213C433FE;
        Tue, 29 Sep 2020 07:42:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8E213C433FE
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Alex Dewar <alex.dewar90@gmail.com>
Cc:     Julian Calaby <julian.calaby@gmail.com>,
        linux-wireless@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, ath10k@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH v2] ath10k: sdio: remove redundant check in for loop
References: <c2987351e3bdad16510dd35847991c2412a9db6b.camel@nvidia.com>
        <20200916165748.20927-1-alex.dewar90@gmail.com>
        <CAGRGNgWoFfCnK9FcWTf_f0b57JNEjsm6ZNQB5X_AMf8L3FyNcQ@mail.gmail.com>
        <87h7rnnnrb.fsf@codeaurora.org>
        <20200927105828.522fabbpyxx2mt3n@medion>
Date:   Tue, 29 Sep 2020 10:42:56 +0300
In-Reply-To: <20200927105828.522fabbpyxx2mt3n@medion> (Alex Dewar's message of
        "Sun, 27 Sep 2020 11:58:28 +0100")
Message-ID: <87wo0ddo5b.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alex Dewar <alex.dewar90@gmail.com> writes:

>> I agree. Anyone can come up with a patch?
>
> Hi Kalle,
>
> I was thinking of having a go at this. Have you applied the v2 of this
> patch yet though? I couldn't see it in wireless-drivers-next. I just
> don't want to have to rebase the patch if you were going to apply this
> v2.

I have not applied this yet. It's in my pending branch but I can easily
drop it. Just let me know what you prefer.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
