Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6763B48C421
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 13:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353237AbiALMpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 07:45:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240547AbiALMpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 07:45:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B3AC06173F;
        Wed, 12 Jan 2022 04:45:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BCBE618AC;
        Wed, 12 Jan 2022 12:45:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11578C36AE9;
        Wed, 12 Jan 2022 12:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641991520;
        bh=izcITvnbn3eRk7EuxKjfXB5/A1HR1stA4bPdJSHT784=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=JdalBd1hee3fOcfK3y+gyjG7syal6TOpysOc+CCFa3gx8T5JX/ePUdW50xMAAXK2R
         5f4imQYbL37jsl9NtNM0brHcj5P9was8N6j8PlaHQ+jtD0o3veE7MnG2+qJub6F/FM
         rbO3uu6bWxf4IhAoA7JXU48fTl1rxDLqiVkTBGzObwuzudUX6T1UMyFCkAg2NormIs
         5tE7n/WwYTYZ8T2q5kvgJHnAZojVGNO6auD6KJFLegPt7ntavoe3fvqZ4DP5EKXziN
         UfN+eQ0Uv67I0uF/oKrApqVkYYsTZUVM11Yxuqjltt3l8vvKZoFQPc07bLMC2SwhCJ
         kulZ834X1K+zQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Jerome Pouiller <Jerome.Pouiller@silabs.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        Pali =?utf-8?Q?Roh?= =?utf-8?Q?=C3=A1r?= <pali@kernel.org>
Subject: Re: [PATCH v9 01/24] mmc: sdio: add SDIO IDs for Silabs WF200 chip
References: <20220111171424.862764-1-Jerome.Pouiller@silabs.com>
        <20220111171424.862764-2-Jerome.Pouiller@silabs.com>
        <CAPDyKFreu2S3Okc9pXckDjUQ2ieb-urSM0riysFnEHRhEqXBKg@mail.gmail.com>
Date:   Wed, 12 Jan 2022 14:45:13 +0200
In-Reply-To: <CAPDyKFreu2S3Okc9pXckDjUQ2ieb-urSM0riysFnEHRhEqXBKg@mail.gmail.com>
        (Ulf Hansson's message of "Wed, 12 Jan 2022 11:58:27 +0100")
Message-ID: <87k0f5t95y.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ulf Hansson <ulf.hansson@linaro.org> writes:

> On Tue, 11 Jan 2022 at 18:14, Jerome Pouiller
> <Jerome.Pouiller@silabs.com> wrote:
>>
>> From: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
>>
>> Note that the values used by Silabs are uncommon. A driver cannot fully
>> rely on the SDIO PnP. It should also check if the device is declared in
>> the DT.
>>
>> So, to apply the quirks necessary for the Silabs WF200, we rely on the
>> DT rather than on the SDIO VID/PID.
>>
>> Signed-off-by: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
>
> I guess the series is getting close to getting queued up?
>
> As an option to make sure $subject patch doesn't cause a problem for
> that, I can queue it up and send it for the 5.17-rcs or if Kalle
> prefer to carry this in this tree with my ack?
>
> Kalle?

The easiest is if you can take it to your tree, tack!

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
