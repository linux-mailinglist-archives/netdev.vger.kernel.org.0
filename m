Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E62244D84
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 19:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728418AbgHNRZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 13:25:55 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:10902 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727894AbgHNRZw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Aug 2020 13:25:52 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1597425951; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=78OfwuaCwHC0ol+hDTUUpWv1nDFOyPEEK9sBLT+15ss=; b=Wq4foldn5wC+47d1i++/i2a33DyJAytAWaBaVK/ufRomPn2JnYRhDPzXKsBG7djSUJb7zHTf
 FUEmjs03kYOtq+A3ZgEzxbnEwCfCVid3+Yyi4HRgovun5dTasgsLK0zoJptQr2m0PL1AnHFM
 9Fz2jkTNS1MyO9TiWNDTPW09OQU=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 5f36c9123f2ce11020af2a2a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 14 Aug 2020 17:25:38
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1BC04C433C9; Fri, 14 Aug 2020 17:25:37 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BD71FC433CA;
        Fri, 14 Aug 2020 17:25:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BD71FC433CA
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
        <87v9hll0ro.fsf@codeaurora.org> <20200814164322.GP4354@dell>
Date:   Fri, 14 Aug 2020 20:25:31 +0300
In-Reply-To: <20200814164322.GP4354@dell> (Lee Jones's message of "Fri, 14 Aug
        2020 17:43:22 +0100")
Message-ID: <87eeo9kulw.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> writes:

> On Fri, 14 Aug 2020, Kalle Valo wrote:
>
>> Lee Jones <lee.jones@linaro.org> writes:
>>=20
>> > Fixes the following W=3D1 kernel build warning(s):
>> >
>> >  drivers/net/wireless/broadcom/b43/main.c: In function =E2=80=98b43_du=
mmy_transmission=E2=80=99:
>> >  drivers/net/wireless/broadcom/b43/main.c:785:3: warning: suggest
>> > braces around empty body in an =E2=80=98if=E2=80=99 statement [-Wempty=
-body]
>> >  drivers/net/wireless/broadcom/b43/main.c: In function =E2=80=98b43_do=
_interrupt_thread=E2=80=99:
>> >  drivers/net/wireless/broadcom/b43/main.c:2017:3: warning: suggest
>> > braces around empty body in an =E2=80=98if=E2=80=99 statement [-Wempty=
-body]
>> >
>> > Cc: Kalle Valo <kvalo@codeaurora.org>
>> > Cc: "David S. Miller" <davem@davemloft.net>
>> > Cc: Jakub Kicinski <kuba@kernel.org>
>> > Cc: Martin Langer <martin-langer@gmx.de>
>> > Cc: Stefano Brivio <stefano.brivio@polimi.it>
>> > Cc: Michael Buesch <m@bues.ch>
>> > Cc: van Dyk <kugelfang@gentoo.org>
>> > Cc: Andreas Jaggi <andreas.jaggi@waterwave.ch>
>> > Cc: Albert Herranz <albert_herranz@yahoo.es>
>> > Cc: linux-wireless@vger.kernel.org
>> > Cc: b43-dev@lists.infradead.org
>> > Cc: netdev@vger.kernel.org
>> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
>> > ---
>> >  drivers/net/wireless/broadcom/b43/main.c | 6 ++++--
>> >  1 file changed, 4 insertions(+), 2 deletions(-)
>>=20
>> Please don't copy the full directory structure to the title. I'll change
>> the title to more simple version:
>>=20
>> b43: add braces around empty statements
>
> This seems to go the other way.
>
> "net: wireless: b43" seems sensible.

Sorry, not understanding what you mean here.

>> I'll do similar changes to other wireless-drivers patches.
>
> Thanks.
>
> Does that mean it's been applied, or is this future tense?

It's not applied yet, there will be an automatic "applied" email once I
have done that.

--=20
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
