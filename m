Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF2E4424F04
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 10:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240678AbhJGITC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 04:19:02 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:62142 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240573AbhJGISv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 04:18:51 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633594618; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=QtdtID0lZUv7mMN6G3/7I0C2S5hVbgargd1smzYRWEw=; b=QsTN9LIyzFLJfrnlX0VWE89DUUGr+Mjsa7RgtDoqqsJxlXtjNfTEQ7NARsu+HRjHfELIiD9X
 3oDM2UJerQGB5oKP+WTcLbw4SQeT8WUlQhu9QP6MXYrN0greZH/NesM/fCiiIKX2Kn97psy1
 vJrcXBONCbtWJYDR6CrX2XnPR44=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 615eace603355859c81bf4e9 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 07 Oct 2021 08:16:38
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EEBECC4360C; Thu,  7 Oct 2021 08:16:37 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2B20BC4338F;
        Thu,  7 Oct 2021 08:16:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 2B20BC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>
Cc:     =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v7 10/24] wfx: add fwio.c/fwio.h
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com>
        <20210920161136.2398632-11-Jerome.Pouiller@silabs.com>
        <87sfxlj6s1.fsf@codeaurora.org> <2174509.SLDT7moDbM@pc-42>
        <20211001160832.ozxc7bhlwlmjeqbo@pali>
Date:   Thu, 07 Oct 2021 11:16:29 +0300
In-Reply-To: <20211001160832.ozxc7bhlwlmjeqbo@pali> ("Pali \=\?utf-8\?Q\?Roh\?\=
 \=\?utf-8\?Q\?\=C3\=A1r\=22's\?\= message of
        "Fri, 1 Oct 2021 18:08:32 +0200")
Message-ID: <87pmshckrm.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pali Roh=C3=A1r <pali@kernel.org> writes:

> On Friday 01 October 2021 17:09:41 J=C3=A9r=C3=B4me Pouiller wrote:
>> On Friday 1 October 2021 13:58:38 CEST Kalle Valo wrote:
>> > Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
>> >=20
>> > > From: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
>> > >
>> > > Signed-off-by: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
>> >=20
>> > [...]
>> >=20
>> > > +static int get_firmware(struct wfx_dev *wdev, u32 keyset_chip,
>> > > +                     const struct firmware **fw, int *file_offset)
>> > > +{
>> > > +     int keyset_file;
>> > > +     char filename[256];
>> > > +     const char *data;
>> > > +     int ret;
>> > > +
>> > > +     snprintf(filename, sizeof(filename), "%s_%02X.sec",
>> > > +              wdev->pdata.file_fw, keyset_chip);
>> > > +     ret =3D firmware_request_nowarn(fw, filename, wdev->dev);
>> > > +     if (ret) {
>> > > +             dev_info(wdev->dev, "can't load %s, falling back to %s=
.sec\n",
>> > > +                      filename, wdev->pdata.file_fw);
>> > > +             snprintf(filename, sizeof(filename), "%s.sec",
>> > > +                      wdev->pdata.file_fw);
>> > > +             ret =3D request_firmware(fw, filename, wdev->dev);
>> > > +             if (ret) {
>> > > +                     dev_err(wdev->dev, "can't load %s\n", filename=
);
>> > > +                     *fw =3D NULL;
>> > > +                     return ret;
>> > > +             }
>> > > +     }
>> >=20
>> > How is this firmware file loading supposed to work? If I'm reading the
>> > code right, the driver tries to load file "wfm_wf200_??.sec" but in
>> > linux-firmware the file is silabs/wfm_wf200_C0.sec:
>> >=20
>> > https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmwar=
e.git/tree/silabs
>> >=20
>> > That can't work automatically, unless I'm missing something of course.
>>=20
>> The firmware are signed. "C0" is the key used to sign this firmware. This
>> key must match with the key burned into the chip. Fortunately, the driver
>> is able to read the key accepted by the chip and automatically choose the
>> right firmware.
>>=20
>> We could imagine to add a attribute in the DT to choose the firmware to
>> load. However, it would be a pity to have to specify it manually whereas
>> the driver is able to detect it automatically.
>>=20
>> Currently, the only possible key is C0. However, it exists some internal
>> parts with other keys. In addition, it is theoretically possible to ask
>> to Silabs to burn parts with a specific key in order to improve security
>> of a product.=20
>>=20
>> Obviously, for now, this feature mainly exists for the Silabs firmware
>> developers who have to work with other keys.
>>=20=20
>> > Also I would prefer to use directory name as the driver name wfx, but I
>> > guess silabs is also doable.
>>=20
>> I have no opinion.
>>=20
>>=20
>> > Also I'm not seeing the PDS files in linux-firmware. The idea is that
>> > when user installs an upstream kernel and the linux-firmware everything
>> > will work automatically, without any manual file installations.
>>=20
>> WF200 is just a chip. Someone has to design an antenna before to be able
>> to use.
>>=20
>> However, we have evaluation boards that have antennas and corresponding
>> PDS files[1]. Maybe linux-firmware should include the PDS for these boar=
ds
>
> So chip vendor provides firmware and card vendor provides PDS files. In
> my opinion all files should go into linux-firmware repository. If Silabs
> has PDS files for its devel boards (which are basically cards) then I
> think these files should go also into linux-firmware repository.

I agree, all files required for normal functionality should be in
linux-firmware. The upstream philosophy is that a user can just install
the latest kernel and latest linux-firmware, and everything should work
out of box (without any manual work).

> And based on some parameter, driver should load correct PDS file. Seems
> like DT can be a place where to put something which indicates which PDS
> file should be used.

Again I agree.

> But should be in DT directly name of PDS file? Or should be in DT just
> additional compatible string with card vendor name and then in driver
> itself should be mapping table from compatible string to filename? I do
> not know what is better.

This is also what I was wondering, to me it sounds wrong to have a
filename in DT. I was more thinking about calling it "antenna name" (and
not the actually filename), but using compatible strings sounds good to
me as well. But of course DT maintainers know this better.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
