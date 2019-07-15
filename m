Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B949C68666
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 11:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729627AbfGOJdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 05:33:44 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38046 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729451AbfGOJdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 05:33:44 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8321060E3F; Mon, 15 Jul 2019 09:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563183223;
        bh=bKDRQ5Q1xApBte+/v0rOlSUIL+4/NKgeP0jwHbZy5oY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Xaq697mIyOTC12VC970aNYaW3KStrFo/6aw3qo0J950Tau6XU1keg5fSpnLZ5R3KB
         bJj/mZuigh859RyqLBD54bFECA+iAyiR0FEdNuRg+le8lxx9Hj63m0qyFmGzGyGKdC
         GQHSQOaRIjyiKr6NQFjz1VVS5yo7Kgd23QPmciII=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 87B4860A50;
        Mon, 15 Jul 2019 09:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563183223;
        bh=bKDRQ5Q1xApBte+/v0rOlSUIL+4/NKgeP0jwHbZy5oY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Xaq697mIyOTC12VC970aNYaW3KStrFo/6aw3qo0J950Tau6XU1keg5fSpnLZ5R3KB
         bJj/mZuigh859RyqLBD54bFECA+iAyiR0FEdNuRg+le8lxx9Hj63m0qyFmGzGyGKdC
         GQHSQOaRIjyiKr6NQFjz1VVS5yo7Kgd23QPmciII=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 87B4860A50
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Solomon Peachy <pizza@shaftnet.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 17/35] net/wireless: Use kmemdup rather than duplicating its implementation
References: <20190703162934.32645-1-huangfq.daxian@gmail.com>
Date:   Mon, 15 Jul 2019 12:33:39 +0300
In-Reply-To: <20190703162934.32645-1-huangfq.daxian@gmail.com> (Fuqian Huang's
        message of "Thu, 4 Jul 2019 00:29:34 +0800")
Message-ID: <874l3nr6a4.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fuqian Huang <huangfq.daxian@gmail.com> writes:

> kmemdup is introduced to duplicate a region of memory in a neat way.
> Rather than kmalloc/kzalloc + memcpy, which the programmer needs to
> write the size twice (sometimes lead to mistakes), kmemdup improves
> readability, leads to smaller code and also reduce the chances of mistakes.
> Suggestion to use kmemdup rather than using kmalloc/kzalloc + memcpy.
>
> Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>

I'm planning to take this.

-- 
Kalle Valo
