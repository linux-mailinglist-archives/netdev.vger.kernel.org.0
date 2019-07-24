Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 998747276D
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 07:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbfGXFjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 01:39:54 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:34300 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfGXFjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 01:39:53 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5C0C160CED; Wed, 24 Jul 2019 05:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563946793;
        bh=MMhai2COm8cnkYrv/dvMLvXqAKcjY56ENAXvop82H7U=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=nb4y6vBnz9vkLD+pOIry/36Icm3pzibY3vWq8Hw/MKQk82eZN5Xu6Okz/p+xD/O/y
         ptqssP+qM/GHEx2FfIlUYfZ691DgfRilOS8wG7jEGNl++sl3BwFuKqoiVbclW4Z5Fw
         5JADz9BIvRZB2Z5DxpSR28lazd8EYRCy8omMlSmw=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D2C8760CED;
        Wed, 24 Jul 2019 05:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563946792;
        bh=MMhai2COm8cnkYrv/dvMLvXqAKcjY56ENAXvop82H7U=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=D4xHNZx0wfHaVp+2Zls4zbfCKV0fk4Pci1I4X0elSeXXAysqDci8QeoH8tvJsPoCn
         mRLFfiOzGaCcEshfsMkjJN1XN0KolGQb7SAuADNhT5iPtkHzpShOCeIimSYsxOnUgu
         gXinv+XQvHWvapDGY0gjfSm7yP3ERjLIBR0LVE5Y=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D2C8760CED
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        secalert@redhat.com, Jakub Kicinski <kubakici@wp.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mt76_init_sband_2g: null check the allocation
References: <20190723221954.9233-1-navid.emamdoost@gmail.com>
Date:   Wed, 24 Jul 2019 08:39:46 +0300
In-Reply-To: <20190723221954.9233-1-navid.emamdoost@gmail.com> (Navid
        Emamdoost's message of "Tue, 23 Jul 2019 17:19:54 -0500")
Message-ID: <87d0i00z4t.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Navid Emamdoost <navid.emamdoost@gmail.com> writes:

> devm_kzalloc may fail and return NULL. So the null check is needed.
>
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> ---
>  drivers/net/wireless/mediatek/mt7601u/init.c | 3 +++
>  1 file changed, 3 insertions(+)

The prefix in the title should be "mt7601u:".

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#commit_title_is_wrong

-- 
Kalle Valo
