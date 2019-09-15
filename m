Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA66BB2F92
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 12:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbfIOKcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 06:32:55 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38432 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbfIOKcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 06:32:54 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C58CD60A50; Sun, 15 Sep 2019 10:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568543573;
        bh=gs/ND/F6K7DLw8cSGbuUu5/eaiv+V+mcgfHLpbSPP1A=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=lV0ChBn56UVenYq8S6XyEFeKwtz/kPmn5TvPMFd5Ip+pVlyq1WeZKMi3xVQVz8mNK
         wnaBF72PP6ArKzGw/5oydeSvBNTipyeHoU2fnSTtpJ88hyqLZJetpQOFg9j/1GJRiT
         h8Zozps60lwqQsrzR+8MQkK5AvJx/AVfEVt0oup0=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 22A7C602F8;
        Sun, 15 Sep 2019 10:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568543573;
        bh=gs/ND/F6K7DLw8cSGbuUu5/eaiv+V+mcgfHLpbSPP1A=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=lV0ChBn56UVenYq8S6XyEFeKwtz/kPmn5TvPMFd5Ip+pVlyq1WeZKMi3xVQVz8mNK
         wnaBF72PP6ArKzGw/5oydeSvBNTipyeHoU2fnSTtpJ88hyqLZJetpQOFg9j/1GJRiT
         h8Zozps60lwqQsrzR+8MQkK5AvJx/AVfEVt0oup0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 22A7C602F8
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next 2019-09-14
References: <87r24jchgv.fsf@kamboji.qca.qualcomm.com>
        <20190914.140843.945413345284987204.davem@davemloft.net>
Date:   Sun, 15 Sep 2019 13:32:49 +0300
In-Reply-To: <20190914.140843.945413345284987204.davem@davemloft.net> (David
        Miller's message of "Sat, 14 Sep 2019 14:08:43 +0100 (WEST)")
Message-ID: <87muf5df3i.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Kalle Valo <kvalo@codeaurora.org>
> Date: Sat, 14 Sep 2019 13:14:40 +0300
>
>> here's a pull request to net-next tree for v5.4, more info below. Please
>> let me know if there are any problems.
>
> Pulled, thanks Kalle.

Thanks for pulling this but I don't see it in net-next, maybe you forgot
to push? Nothing important, just making sure it didn't get lost.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
