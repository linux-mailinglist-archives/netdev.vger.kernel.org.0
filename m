Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D73972466CC
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 15:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbgHQNAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 09:00:23 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:53289 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728505AbgHQNAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 09:00:20 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1597669219; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=EPNl9HJgep9wWTGfsP2AiKKlUSHnaYCKHEIDUjeMiqk=; b=YfimGfTrsTOYmPxZHHkCaU0saw3cUtOTENHgqoLnhl9ia6ktD8c4Av3bpoFeyHfivtI6oa8z
 0J9G51BGkbOq1b/7l1jDYeucbaLaruY7ZhnwLE/g6orrRl3mBnsgvnkmWn7ZL+3iOe6mnJTd
 AsPqfQICyIJFN3b6q3vN8N0UKx8=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5f3a7f4aba4c2cd3671651bd (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 17 Aug 2020 12:59:54
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 46AF5C4339C; Mon, 17 Aug 2020 12:59:53 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3AAF0C433C6;
        Mon, 17 Aug 2020 12:59:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3AAF0C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Christian Lamparter <chunkeey@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        Christian Lamparter <chunkeey@googlemail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 08/30] net: wireless: ath: carl9170: Mark 'ar9170_qmap' as __maybe_unused
References: <20200814113933.1903438-1-lee.jones@linaro.org>
        <20200814113933.1903438-9-lee.jones@linaro.org>
        <7ef231f2-e6d3-904f-dc3a-7ef82beda6ef@gmail.com>
        <9776eb47-6b83-a891-f057-dd34d14ea16e@rasmusvillemoes.dk>
Date:   Mon, 17 Aug 2020 15:59:47 +0300
In-Reply-To: <9776eb47-6b83-a891-f057-dd34d14ea16e@rasmusvillemoes.dk> (Rasmus
        Villemoes's message of "Mon, 17 Aug 2020 10:26:16 +0200")
Message-ID: <87eeo5mnr0.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rasmus Villemoes <linux@rasmusvillemoes.dk> writes:

> On 14/08/2020 17.14, Christian Lamparter wrote:
>> On 2020-08-14 13:39, Lee Jones wrote:
>>> 'ar9170_qmap' is used in some source files which include carl9170.h,
>>> but not all of them.=C2=A0 Mark it as __maybe_unused to show that this =
is
>>> not only okay, it's expected.
>>>
>>> Fixes the following W=3D1 kernel build warning(s)
>>=20
>> Is this W=3D1 really a "must" requirement? I find it strange having
>> __maybe_unused in header files as this "suggests" that the
>> definition is redundant.
>
> In this case it seems one could replace the table lookup with a
>
> static inline u8 ar9170_qmap(u8 idx) { return 3 - idx; }
>
> gcc doesn't warn about unused static inline functions (or one would have
> a million warnings to deal with). Just my $0.02.

Yeah, this is much better.

And I think that static variables should not even be in the header
files. Doesn't it mean that there's a local copy of the variable
everytime the .h file is included? Sure, in this case the overhead is
small (4 bytes per include) but still it's wrong. Having a static inline
function would solve that problem as well the compiler warning.

--=20
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
