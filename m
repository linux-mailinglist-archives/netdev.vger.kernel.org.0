Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAAD86865E
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 11:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729633AbfGOJcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 05:32:41 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:37758 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729598AbfGOJck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 05:32:40 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4D18C60A50; Mon, 15 Jul 2019 09:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563183160;
        bh=lYstfhNXFss73ifzPEP+0gLV51khNw6rqOGncRTDN8o=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=FBFXRjg8p2/Zz7bVeHNb572FVTPLTYwSKUgOqOjTHAcU3MXr4z6Ad2oB0mKzeTJdO
         IU5OnMEVhC0g5R0S7RL+MD3hHF54KDyHqA1QrsKz5iSYd30RQXWisoU7b/k+Kxk45l
         if7fds/OHbt+uaT37utvK3R9qA8AsitfLAr4uRRw=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2F26D60591;
        Mon, 15 Jul 2019 09:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563183159;
        bh=lYstfhNXFss73ifzPEP+0gLV51khNw6rqOGncRTDN8o=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=F+FWrVn9wFIk75Pr57NwX/i4pnd7rs8qiHAtBQFzwHF4Z/yfPIL/BV989uqS0gvAp
         7fHAgFYAE3LQtASnabekp4WrhNRGZ5rPVlddbnRghpaGo31ZTAi43CWracrHK0SvWw
         Xl0QzEca/eyUAt4SaWqV1hzx8pFlCNegdIZXeAeQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2F26D60591
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Solomon Peachy <pizza@shaftnet.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/30] net/wireless: Use kmemdup rather than duplicating its implementation
References: <20190703131614.25408-1-huangfq.daxian@gmail.com>
Date:   Mon, 15 Jul 2019 12:32:35 +0300
In-Reply-To: <20190703131614.25408-1-huangfq.daxian@gmail.com> (Fuqian Huang's
        message of "Wed, 3 Jul 2019 21:16:14 +0800")
Message-ID: <878sszr6bw.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fuqian Huang <huangfq.daxian@gmail.com> writes:

> kmemdup is introduced to duplicate a region of memory in a neat way.
> Rather than kmalloc/kzalloc + memset, which the programmer needs to
> write the size twice (sometimes lead to mistakes), kmemdup improves
> readability, leads to smaller code and also reduce the chances of mistakes.
> Suggestion to use kmemdup rather than using kmalloc/kzalloc + memset.
>
> Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>

I assume I can take this to wireless-drivers-next. If not, please
holler.

Fuqian, it would help the maintainers a lot if you could clearly
indicate to which tree the patches are planned to be commited. If I just
see one patch from a 30 patch set I have no clue what is your plan,
either is someone else going to apply the full patchset or the
maintainers should pick respective patches individually.

-- 
Kalle Valo
