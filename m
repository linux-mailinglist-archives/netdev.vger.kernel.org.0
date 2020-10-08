Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B855E286F6C
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 09:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgJHHaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 03:30:16 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:11877 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725916AbgJHHaP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 03:30:15 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1602142215; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=BSHe7bjq6nASZP/I6WI8Us5JI4n8DYQ9onuwRyS8E8Y=; b=VzUXSmY6iw5jdxyE3K4NsBs9MrtwyKn1RnNX1fgHSOKyz/9QwN7n6ZxpMHN5J7ChVxW9pPg6
 zSHN8KjNQXEaEdx9F6OSP90QKJ86rHui3fluMKZMHmjfPzzavCqdz6jb6lEoZud2HHlq0EE/
 /c4i+VMnaxhDPACq8r9noKAnsyE=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5f7ec004aad2c3cd1c82bee4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 08 Oct 2020 07:30:12
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 541C2C433FF; Thu,  8 Oct 2020 07:30:11 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0E4E3C433F1;
        Thu,  8 Oct 2020 07:30:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0E4E3C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jerome Pouiller <Jerome.Pouiller@silabs.com>,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 0/7] wfx: move out from the staging area
References: <20201007101943.749898-1-Jerome.Pouiller@silabs.com>
        <20201007105513.GA1078344@kroah.com>
Date:   Thu, 08 Oct 2020 10:30:06 +0300
In-Reply-To: <20201007105513.GA1078344@kroah.com> (Greg Kroah-Hartman's
        message of "Wed, 7 Oct 2020 12:55:13 +0200")
Message-ID: <87ft6p2n0h.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> On Wed, Oct 07, 2020 at 12:19:36PM +0200, Jerome Pouiller wrote:
>> From: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
>>=20
>> I think the wfx driver is now mature enough to be accepted in the
>> drivers/net/wireless directory.
>>=20
>> There is still one item on the TODO list. It is an idea to improve the r=
ate
>> control in some particular cases[1]. However, the current performances o=
f the
>> driver seem to satisfy everyone. In add, the suggested change is large e=
nough.
>> So, I would prefer to implement it only if it really solves an issue. I =
think it
>> is not an obstacle to move the driver out of the staging area.
>>=20
>> In order to comply with the last rules for the DT bindings, I have conve=
rted the
>> documentation to yaml. I am moderately happy with the result. Especially=
, for
>> the description of the binding. Any comments are welcome.
>>=20
>> The series also update the copyrights dates of the files. I don't know e=
xactly
>> how this kind of changes should be sent. It's a bit weird to change all =
the
>> copyrights in one commit, but I do not see any better way.
>>=20
>> I also include a few fixes I have found these last weeks.
>>=20
>> [1] https://lore.kernel.org/lkml/3099559.gv3Q75KnN1@pc-42
>
> I'll take the first 6 patches here, the last one you should work with
> the wireless maintainers to get reviewed.
>
> Maybe that might want to wait until after 5.10-rc1 is out, with all of
> these changes in it, making it an easier move.

Yes, the driver needs to be reviewed in linux-wireless list. I recommend
submitting the whole driver in a patchset with one file per patch, which
seems to be the easiest way to review a full driver. The final move will
be in just one commit moving the driver, just like patch 7 does here. As
an example see how wilc1000 review was done.

Device tree bindings needs to be reviewed by the DT maintainer so CC
devicetree on that patch.

But do note that there's currently one new driver in review queue, so it
will most likely take some time before wfx is reviewed.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
