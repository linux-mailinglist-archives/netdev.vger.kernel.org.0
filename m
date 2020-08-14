Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2346244BB5
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 17:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728481AbgHNPMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 11:12:46 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:43909 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726320AbgHNPMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 11:12:46 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1597417965; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=pNN2ZqU5l5I1aDtdajbDVZMae5TVPajU+Yoe2FUShBo=; b=u2RDoOBkpzMqQOGSIly0zGyOHwCXgkFCKwdhv6KccCwoFXnrSmrOkj4iDTGtlW7lSF7Tr0dh
 pv/FY6SBevx1yUushJdmjxLflzawew6OsTvIm/G5HKX8IOeQhAJ6C7YRHxGKViwzU+HIUQ2p
 7akRDGe+sjP0+c+3Zt2PvrLzW4E=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 5f36a9e203528d402486b23e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 14 Aug 2020 15:12:34
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 11D01C433AF; Fri, 14 Aug 2020 15:12:33 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 95919C433CA;
        Fri, 14 Aug 2020 15:12:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 95919C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        Martin Langer <martin-langer@gmx.de>,
        Stefano Brivio <stefano.brivio@polimi.it>,
        Michael Buesch <m@bues.ch>, van Dyk <kugelfang@gentoo.org>,
        Andreas Jaggi <andreas.jaggi@waterwave.ch>,
        Albert Herranz <albert_herranz@yahoo.es>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 07/30] net: wireless: broadcom: b43: main: Add braces around empty statements
References: <20200814113933.1903438-1-lee.jones@linaro.org>
        <20200814113933.1903438-8-lee.jones@linaro.org>
Date:   Fri, 14 Aug 2020 18:12:27 +0300
In-Reply-To: <20200814113933.1903438-8-lee.jones@linaro.org> (Lee Jones's
        message of "Fri, 14 Aug 2020 12:39:10 +0100")
Message-ID: <87v9hll0ro.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> writes:

> Fixes the following W=3D1 kernel build warning(s):
>
>  drivers/net/wireless/broadcom/b43/main.c: In function =E2=80=98b43_dummy=
_transmission=E2=80=99:
>  drivers/net/wireless/broadcom/b43/main.c:785:3: warning: suggest braces =
around empty body in an =E2=80=98if=E2=80=99 statement [-Wempty-body]
>  drivers/net/wireless/broadcom/b43/main.c: In function =E2=80=98b43_do_in=
terrupt_thread=E2=80=99:
>  drivers/net/wireless/broadcom/b43/main.c:2017:3: warning: suggest braces=
 around empty body in an =E2=80=98if=E2=80=99 statement [-Wempty-body]
>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Martin Langer <martin-langer@gmx.de>
> Cc: Stefano Brivio <stefano.brivio@polimi.it>
> Cc: Michael Buesch <m@bues.ch>
> Cc: van Dyk <kugelfang@gentoo.org>
> Cc: Andreas Jaggi <andreas.jaggi@waterwave.ch>
> Cc: Albert Herranz <albert_herranz@yahoo.es>
> Cc: linux-wireless@vger.kernel.org
> Cc: b43-dev@lists.infradead.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/net/wireless/broadcom/b43/main.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Please don't copy the full directory structure to the title. I'll change
the title to more simple version:

b43: add braces around empty statements

I'll do similar changes to other wireless-drivers patches.

--=20
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
