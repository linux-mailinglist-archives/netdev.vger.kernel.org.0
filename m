Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731A6253FB1
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 09:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbgH0HzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 03:55:02 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:41127 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728486AbgH0Hyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 03:54:55 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598514894; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=R3GfTB2n3TnLY699vSjPfiKPod4E8AJXYwtplDEpXT0=; b=DfEISsinezeZJX3ajJu0VK56DTSk1H/ejylpqZdngH+oZ8fyx/90CKxAkR8IX0MmSnYxWTZX
 T0+0YXuZcLGQnG0ZB+DYKRUVPbgVwbG9yrkMubD/9hSfGIxBpF0pFR3fxqHjx76kjcwjrPGc
 Fft3CLcHQt4PXJGVPgjMMi0AXxM=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 5f4766b44b23cecfe27dd07c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 27 Aug 2020 07:54:28
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A4E04C433A0; Thu, 27 Aug 2020 07:54:27 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8D16FC433C6;
        Thu, 27 Aug 2020 07:54:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8D16FC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Christian Lamparter <chunkeey@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        Christian Lamparter <chunkeey@googlemail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 08/30] net: wireless: ath: carl9170: Mark 'ar9170_qmap' as __maybe_unused
References: <20200814113933.1903438-1-lee.jones@linaro.org>
        <20200814113933.1903438-9-lee.jones@linaro.org>
        <7ef231f2-e6d3-904f-dc3a-7ef82beda6ef@gmail.com>
        <9776eb47-6b83-a891-f057-dd34d14ea16e@rasmusvillemoes.dk>
        <87eeo5mnr0.fsf@codeaurora.org> <20200818095024.GZ4354@dell>
Date:   Thu, 27 Aug 2020 10:54:21 +0300
In-Reply-To: <20200818095024.GZ4354@dell> (Lee Jones's message of "Tue, 18 Aug
        2020 10:50:24 +0100")
Message-ID: <87r1rsle1e.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> writes:

> On Mon, 17 Aug 2020, Kalle Valo wrote:
>
>> Rasmus Villemoes <linux@rasmusvillemoes.dk> writes:
>>=20
>> > On 14/08/2020 17.14, Christian Lamparter wrote:
>> >> On 2020-08-14 13:39, Lee Jones wrote:
>> >>> 'ar9170_qmap' is used in some source files which include carl9170.h,
>> >>> but not all of them.=C2=A0 Mark it as __maybe_unused to show that th=
is is
>> >>> not only okay, it's expected.
>> >>>
>> >>> Fixes the following W=3D1 kernel build warning(s)
>> >>=20
>> >> Is this W=3D1 really a "must" requirement? I find it strange having
>> >> __maybe_unused in header files as this "suggests" that the
>> >> definition is redundant.
>> >
>> > In this case it seems one could replace the table lookup with a
>> >
>> > static inline u8 ar9170_qmap(u8 idx) { return 3 - idx; }
>> >
>> > gcc doesn't warn about unused static inline functions (or one would ha=
ve
>> > a million warnings to deal with). Just my $0.02.
>>=20
>> Yeah, this is much better.
>>=20
>> And I think that static variables should not even be in the header
>> files. Doesn't it mean that there's a local copy of the variable
>> everytime the .h file is included? Sure, in this case the overhead is
>> small (4 bytes per include) but still it's wrong.
>
> It happens a lot.
>
> As I stated before, the 2 viable options are to a) move it into the
> source files; ensuring code duplication, unnecessary maintenance
> burden and probably disparity over time, or b) create (or locate if
> there is one already) a special header file which is only to be
> included by the users.
>
> The later option gets really complicated if there are a variety of
> tables which are included by any given number of source file
> permutations.
>
> The accepted answer in all of the other subsystems I've worked with so
> far, is to use __maybe_unused.  It's simple, non-intrusive and doesn't
> rely on any functional changes.
>
>> Having a static inline
>> function would solve that problem as well the compiler warning.
>
> This time yes, but it's a hack that will only work with simple,
> linear data.=20=20

To me __maybe_unused is a hack and a static inline function is a much
better solution.

> Try doing that with some of the other, more complicated
> tables, like mwifiex_sdio_sd8*.

Then the table should be moved to a .c file and the .h file should have
"extern const int foo[]"

--=20
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
