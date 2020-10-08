Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41691287309
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 13:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728630AbgJHLCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 07:02:16 -0400
Received: from z5.mailgun.us ([104.130.96.5]:17299 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726164AbgJHLCN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 07:02:13 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1602154932; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=eJBexxd8ncXOiQfY+iAAWapiGqaBRPOkeIcaQjW/Sdw=; b=uIhigipyjx5lAbsjRcPw7nJMz+Xjt4YoaiuXpSu06c31gWBldvcwI1YmraFeapleROj9jZAd
 H1YrRvfwl+rS9mQFNH2/SZZLT+4CC0WksUNm9M7gtn73Jbz2CYnJEKChyk7fdAQdqJLGJ2nS
 kZr1HSfHXx3bdepa/RqlPW4n/Uk=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5f7ef170856d9308b50ff987 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 08 Oct 2020 11:01:04
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0C905C433F1; Thu,  8 Oct 2020 11:01:04 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C6B91C433CA;
        Thu,  8 Oct 2020 11:01:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C6B91C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 0/7] wfx: move out from the staging area
References: <20201007101943.749898-1-Jerome.Pouiller@silabs.com>
        <20201007105513.GA1078344@kroah.com> <87ft6p2n0h.fsf@codeaurora.org>
        <16184307.3FagCOgvEJ@pc-42>
Date:   Thu, 08 Oct 2020 14:00:59 +0300
In-Reply-To: <16184307.3FagCOgvEJ@pc-42> (=?utf-8?B?IkrDqXLDtG1l?=
 Pouiller"'s message of "Thu,
        08 Oct 2020 12:10:08 +0200")
Message-ID: <87tuv50yok.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com> writes:

> On Thursday 8 October 2020 09:30:06 CEST Kalle Valo wrote:
> [...]
>> Yes, the driver needs to be reviewed in linux-wireless list. I recommend
>> submitting the whole driver in a patchset with one file per patch, which
>> seems to be the easiest way to review a full driver. The final move will
>> be in just one commit moving the driver, just like patch 7 does here. As
>> an example see how wilc1000 review was done.
>
> I see. I suppose it is still a bit complicated to review? Maybe I could
> try to make things easier.
>
> For my submission to staging/ I had taken time to split the driver in an
> understandable series of patches[1]. I think it was easier to review than
> just sending files one by one. I could do the same thing for the
> submission to linux-wireless. It would ask me a bit of work but, since I
> already have a template, it is conceivable.
>
> Do you think it is worth it, or it would be an unnecessary effort?
>
> [1]
> https://lore.kernel.org/driverdev-devel/20190919142527.31797-1-Jerome.Pou=
iller@silabs.com/
>      or commits a7a91ca5a23d^..40115bbc40e2

I don't know how others think, but I prefer to review new drivers "one
file per patch" style as I get to see the big picture easily. And
besides, splitting the driver like that would be a huge job for you. I
don't think it's worth your time in this case. And making changes in the
driver during review process becomes even more complex.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
