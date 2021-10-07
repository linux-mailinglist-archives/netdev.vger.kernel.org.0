Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA68424F2D
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 10:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240710AbhJGIZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 04:25:00 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:33166 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240580AbhJGIZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 04:25:00 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633594987; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=WaZcbZfDqeaUTo7u2ooF6EKbTrALivgM4HMtK+FbJdQ=; b=nOcP6Y4opfjZd5Jm9BNy0qivZFEaNJ0wjC044RAmYD7Oe+i9rKmEx8Il+x/gHb9HhC9wMj7I
 G02eYSaZ9NTv/O3eWJHdgzigFIoh3fl+nYurkxHVxJux4D8XuYRyM/1vIDUuT12aMlZ4LM8g
 cQFppjqDlCWmS1ReyUpyoaByQmQ=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 615eae6309ab553889b44a1d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 07 Oct 2021 08:22:59
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A7C6AC4361A; Thu,  7 Oct 2021 08:22:58 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D86F6C4338F;
        Thu,  7 Oct 2021 08:22:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org D86F6C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        Pali =?utf-8?Q?Roh?= =?utf-8?Q?=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v8 00/24] wfx: get out from the staging area
References: <20211005135400.788058-1-Jerome.Pouiller@silabs.com>
        <871r4zft98.fsf@codeaurora.org> <4889546.ZpuqzhuOv5@pc-42>
Date:   Thu, 07 Oct 2021 11:22:50 +0300
In-Reply-To: <4889546.ZpuqzhuOv5@pc-42> (=?utf-8?B?IkrDqXLDtG1l?=
 Pouiller"'s message of "Tue,
        05 Oct 2021 17:51:57 +0200")
Message-ID: <87h7dtckh1.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com> writes:

> On Tuesday 5 October 2021 16:20:19 CEST Kalle Valo wrote:
>> Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
>>=20
>> > From: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
> [...]
>> >
>> > v8:
>> >   - Change the way the DT is handled. The user can now specify the nam=
e of
>> >     the board (=3D chip + antenna) he use. It easier for board designe=
rs to
>> >     add new entries. I plan to send a PR to linux-firmware to include =
PDS
>> >     files of the developpement boards belong the firmware (I also plan=
 to
>> >     relocate these file into wfx/ instead of silabs/). (Kalle, Pali)
>> >   - Prefix visible functions and structs with "wfx_". I mostly kept the
>> >     code under 80 columns. (Kalle, Pali, Greg)
>> >   - Remove support for force_ps_timeout for now. (Kalle)
>> >   - Fix licenses of Makefile, Kconfig and hif_api*.h. (Kalle)
>> >   - Do not mix and match endianess in struct hif_ind_startup. (Kalle)
>> >   - Remove magic values. (Kalle)
>> >   - Use IS_ALIGNED(). (BTW, PTR_IS_ALIGNED() does not exist?) (Kalle)
>> >   - I have also noticed that some headers files did not declare all the
>> >     struct they used.
>> >
>> >   These issues remain (I hope they are not blockers):
>> >   - I have currently no ideas how to improve/simplify the parsing PDS =
file.
>> >     (Kalle)
>> >   - We would like to relate the SDIO quirks into mmc/core/quirks.h, bu=
t the
>> >     API to do that does not yet exist. (Ulf, Pali)
>>=20
>> So is this a direct version from staging-next? If yes, what commit id did
>> you use? Or do you have your own set of patches on top of staging-next?
>
> I am based on 5e57c668dc09 from staging-next. (I have not rebased it betw=
een
> v7 and v8)

Commit 5e57c668dc09 is from Sep 14th, so I take it that you have your on
patches on top of staging-next.

But please don't send a new version of the patchset too often, at least
try to keep two weeks between versions but preferably even more. It's
quite difficult when you send a new version and there are still ongoing
discussions in the previous version.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
