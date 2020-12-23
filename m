Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491452E184E
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 06:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgLWFRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 00:17:04 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:63354 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725270AbgLWFRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 00:17:04 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608700601; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=p7NLYtLBCwi9t9Vj9dPZlOCGeUoDz8AD5ZLf0+IFHLk=; b=n4O4U5ja/SUkiUDixKrqvbq87WIasJNLu/LCAntbJAZ7nQCWWoRXgoUoETTmFJJVT2iYoxcb
 2MYLsswHES4p1HOaAlsdK7x8a4PaRatFA/KLBqwLF0nWxnNLbL5Dsoo5Ry04k+v8PGZJXlcF
 /mMd9K0xpq7vc6i4NevEk/MCTQY=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n08.prod.us-west-2.postgun.com with SMTP id
 5fe2d29dcfe5dd67db5d7a69 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 23 Dec 2020 05:16:13
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EFC86C43465; Wed, 23 Dec 2020 05:16:12 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 59070C433CA;
        Wed, 23 Dec 2020 05:16:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 59070C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
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
Subject: Re: [PATCH v3 03/24] wfx: add Makefile/Kconfig
References: <20201104155207.128076-1-Jerome.Pouiller@silabs.com>
        <20201104155207.128076-4-Jerome.Pouiller@silabs.com>
        <8735zxanox.fsf@codeaurora.org> <9810105.nUPlyArG6x@pc-42>
Date:   Wed, 23 Dec 2020 07:16:06 +0200
In-Reply-To: <9810105.nUPlyArG6x@pc-42> (=?utf-8?B?IkrDqXLDtG1l?=
 Pouiller"'s message of "Tue,
        22 Dec 2020 22:19:52 +0100")
Message-ID: <8735zx6r1l.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com> writes:

> On Tuesday 22 December 2020 16:02:38 CET Kalle Valo wrote:
>> Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
>>=20
>> > From: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
>> >
>> > Signed-off-by: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
>>=20
>> [...]
>>=20
>> > +wfx-$(CONFIG_SPI) +=3D bus_spi.o
>> > +wfx-$(subst m,y,$(CONFIG_MMC)) +=3D bus_sdio.o
>>=20
>> Why this subst? And why only for MMC?
>
> CONFIG_SPI is a boolean (y or empty). The both values make senses.
>
> CONFIG_MMC is a tristate (y, m or empty). The substitution above
> ensure that bus_sdio.o will included in wfx.ko if CONFIG_MMC is 'm'
> ("wfx-$(CONFIG_MMC) +=3D bus_sdio.o" wouldn't make the job).
>
> You may want to know what it happens if CONFIG_MMC=3Dm while CONFIG_WFX=
=3Dy.
> This line in Kconfig prevents to compile wfx statically if MMC is a
> module:
>        depends on MMC || !MMC # do not allow WFX=3Dy if MMC=3Dm

Ok, thanks for explaining this.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
