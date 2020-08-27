Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DABE8253F6B
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 09:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbgH0HmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 03:42:22 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:43177 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727084AbgH0HmV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 03:42:21 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598514140; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=9qnthhnWenta0Q9mzx17Q48ImmKaAAh3E0dlFmqXnTA=; b=CIuYdkT+deeBtLz0m/iv7vUGGo9GpYiF9iEOV9HUYNRG6NCS0i70+PV6FP4h22lLNwhFb+DC
 GMFA3SHgqY/dEbkt9K17SmlsEbfaCadyHDR4ooqrbwHUlP8M0VrSlTTW5VezGM5wygqMaSSu
 X8X1rIZtgvDJGvyET7G/xYuKPi4=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 5f4763db4413b7d5dbe882fa (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 27 Aug 2020 07:42:19
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 41603C433CB; Thu, 27 Aug 2020 07:42:19 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E4ECCC433CA;
        Thu, 27 Aug 2020 07:42:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E4ECCC433CA
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
        <87eeo9kulw.fsf@codeaurora.org> <20200817085018.GT4354@dell>
Date:   Thu, 27 Aug 2020 10:42:12 +0300
In-Reply-To: <20200817085018.GT4354@dell> (Lee Jones's message of "Mon, 17 Aug
        2020 09:50:18 +0100")
Message-ID: <87zh6gleln.fsf@codeaurora.org>
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
>> > On Fri, 14 Aug 2020, Kalle Valo wrote:
>> >
>> >> Lee Jones <lee.jones@linaro.org> writes:
>> >>=20
>> >> > Fixes the following W=3D1 kernel build warning(s):
>> >> >
>> >> >  drivers/net/wireless/broadcom/b43/main.c: In function =E2=80=98b43=
_dummy_transmission=E2=80=99:
>> >> >  drivers/net/wireless/broadcom/b43/main.c:785:3: warning: suggest
>> >> > braces around empty body in an =E2=80=98if=E2=80=99 statement [-Wem=
pty-body]
>> >> >  drivers/net/wireless/broadcom/b43/main.c: In function =E2=80=98b43=
_do_interrupt_thread=E2=80=99:
>> >> >  drivers/net/wireless/broadcom/b43/main.c:2017:3: warning: suggest
>> >> > braces around empty body in an =E2=80=98if=E2=80=99 statement [-Wem=
pty-body]
>> >> >
>> >> > Cc: Kalle Valo <kvalo@codeaurora.org>
>> >> > Cc: "David S. Miller" <davem@davemloft.net>
>> >> > Cc: Jakub Kicinski <kuba@kernel.org>
>> >> > Cc: Martin Langer <martin-langer@gmx.de>
>> >> > Cc: Stefano Brivio <stefano.brivio@polimi.it>
>> >> > Cc: Michael Buesch <m@bues.ch>
>> >> > Cc: van Dyk <kugelfang@gentoo.org>
>> >> > Cc: Andreas Jaggi <andreas.jaggi@waterwave.ch>
>> >> > Cc: Albert Herranz <albert_herranz@yahoo.es>
>> >> > Cc: linux-wireless@vger.kernel.org
>> >> > Cc: b43-dev@lists.infradead.org
>> >> > Cc: netdev@vger.kernel.org
>> >> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
>> >> > ---
>> >> >  drivers/net/wireless/broadcom/b43/main.c | 6 ++++--
>> >> >  1 file changed, 4 insertions(+), 2 deletions(-)
>> >>=20
>> >> Please don't copy the full directory structure to the title. I'll cha=
nge
>> >> the title to more simple version:
>> >>=20
>> >> b43: add braces around empty statements
>> >
>> > This seems to go the other way.
>> >
>> > "net: wireless: b43" seems sensible.
>>=20
>> Sorry, not understanding what you mean here.
>
> So I agree that:
>
>   "net: wireless: broadcom: b43: main"
>
> ... seems unnecessarily long and verbose.  However, IMHO:
>
>   "b43:"
>
> ... is too short and not forthcoming enough.  Obviously this fine when
> something like `git log -- net/wireless`, as you already know what the
> patch pertains to, however when someone who is not in the know (like I
> would be) does `git log` and sees a "b43:" patch, they would have no
> idea which subsystem this patch is adapting.  Even:
>
>   "wireless: b43:"
>
> ... would be worlds better.
>
> A Git log which omitted all subsystem tags would be of limited use.

There are good reasons why the style is like it is. If I would start
adding "wireless:" tags to the title it would clutter 'git log
--oneline' and gitk output, which I use all the time. And I'm not
interested making my work harder, there would need to be really strong
reasons why I would even recondiser changing it.

BTW, this is also documented in our wiki:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes#commit_title_is_wrong

--=20
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
