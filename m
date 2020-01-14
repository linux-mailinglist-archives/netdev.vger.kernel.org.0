Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0440413AB48
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 14:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgANNom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 08:44:42 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:42961 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728880AbgANNok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 08:44:40 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1579009479; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=xVs39pFzdxC0AYVqKrc2ELfrFrxwiZjTOESKySUWCss=; b=LziO/rPAMeiVL0LfHuD5nnizigmLRJ+sMS0WJNssFWCVMU5sdo5odX/6gJ97slyfe/i8a5iz
 /uBdyuqdsHAdjovPeTeCR2wKq4YZlREypMK1JtIKTlD1eGGF2DMI3zIwfzRpRffLhV0XZQ/v
 5ZxFfs9DsPH7s9h2Qp0T2kIJSRY=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e1dc5c3.7f48b9847810-smtp-out-n03;
 Tue, 14 Jan 2020 13:44:35 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 73359C4479F; Tue, 14 Jan 2020 13:44:35 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from x230.qca.qualcomm.com (85-76-19-103-nat.elisa-mobile.fi [85.76.19.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A70ECC433CB;
        Tue, 14 Jan 2020 13:44:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A70ECC433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Nicolai Stange <nstange@suse.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Wen Huang <huangwenabc@gmail.com>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Miroslav Benes <mbenes@suse.cz>
Subject: Re: [PATCH 2/2] libertas: make lbs_ibss_join_existing() return error code on rates overflow
References: <87woa04t2v.fsf@suse.de> <20200114103903.2336-1-nstange@suse.de>
        <20200114103903.2336-3-nstange@suse.de>
Date:   Tue, 14 Jan 2020 15:44:30 +0200
In-Reply-To: <20200114103903.2336-3-nstange@suse.de> (Nicolai Stange's message
        of "Tue, 14 Jan 2020 11:39:03 +0100")
Message-ID: <87k15uqhj5.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nicolai Stange <nstange@suse.de> writes:

> Commit e5e884b42639 ("libertas: Fix two buffer overflows at parsing bss
> descriptor") introduced a bounds check on the number of supplied rates to
> lbs_ibss_join_existing() and made it to return on overflow.
>
> However, the aforementioned commit doesn't set the return value accordingly
> and thus, lbs_ibss_join_existing() would return with zero even though it
> failed.
>
> Make lbs_ibss_join_existing return -EINVAL in case the bounds check on the
> number of supplied rates fails.
>
> Fixes: e5e884b42639 ("libertas: Fix two buffer overflows at parsing bss
>                       descriptor")

This should be in one line, I'll fix it during commit.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
