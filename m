Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C926424EB6
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 10:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240613AbhJGILA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 04:11:00 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:30359 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240524AbhJGIK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 04:10:57 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633594144; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=rymlx8B6bw8yxJ8xBhaQ8zo8wYKa5Xa5SyFLyKfvVOI=; b=DAzuFKQQ58n+qV46VXj9OVza/4JJFF7uhMeOvgi4xzOhM3l0QB88LkfG1cbIRwcJ/8RPBt1l
 DB9SM3nP6aQ8jyjgcN2+oC4yv3JCCVfdJ86+YkDsjTmroxf5m2HbkQVSgjQTscqq/4cV56Lt
 2X5MfXH2cL/ESxCDnWdeP8kdIHY=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 615eab1f7ae92c7fc93f21de (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 07 Oct 2021 08:09:03
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A1984C4363B; Thu,  7 Oct 2021 08:09:02 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2FF48C4360D;
        Thu,  7 Oct 2021 08:08:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 2FF48C4360D
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
Subject: Re: [PATCH v7 10/24] wfx: add fwio.c/fwio.h
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com>
        <20210920161136.2398632-11-Jerome.Pouiller@silabs.com>
        <87sfxlj6s1.fsf@codeaurora.org> <2174509.SLDT7moDbM@pc-42>
Date:   Thu, 07 Oct 2021 11:08:53 +0300
In-Reply-To: <2174509.SLDT7moDbM@pc-42> (=?utf-8?B?IkrDqXLDtG1l?=
 Pouiller"'s message of "Fri,
        01 Oct 2021 17:09:41 +0200")
Message-ID: <87tuhtcl4a.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com> writes:

> On Friday 1 October 2021 13:58:38 CEST Kalle Valo wrote:
>> Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
>>=20
>> > From: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
>> >
>> > Signed-off-by: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
>>=20
>> [...]
>>=20
>> > +static int get_firmware(struct wfx_dev *wdev, u32 keyset_chip,
>> > +                     const struct firmware **fw, int *file_offset)
>> > +{
>> > +     int keyset_file;
>> > +     char filename[256];
>> > +     const char *data;
>> > +     int ret;
>> > +
>> > +     snprintf(filename, sizeof(filename), "%s_%02X.sec",
>> > +              wdev->pdata.file_fw, keyset_chip);
>> > +     ret =3D firmware_request_nowarn(fw, filename, wdev->dev);
>> > +     if (ret) {
>> > +             dev_info(wdev->dev, "can't load %s, falling back to %s.s=
ec\n",
>> > +                      filename, wdev->pdata.file_fw);
>> > +             snprintf(filename, sizeof(filename), "%s.sec",
>> > +                      wdev->pdata.file_fw);
>> > +             ret =3D request_firmware(fw, filename, wdev->dev);
>> > +             if (ret) {
>> > +                     dev_err(wdev->dev, "can't load %s\n", filename);
>> > +                     *fw =3D NULL;
>> > +                     return ret;
>> > +             }
>> > +     }
>>=20
>> How is this firmware file loading supposed to work? If I'm reading the
>> code right, the driver tries to load file "wfm_wf200_??.sec" but in
>> linux-firmware the file is silabs/wfm_wf200_C0.sec:
>>=20
>> https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.=
git/tree/silabs
>>=20
>> That can't work automatically, unless I'm missing something of course.
>
> The firmware are signed. "C0" is the key used to sign this firmware. This
> key must match with the key burned into the chip. Fortunately, the driver
> is able to read the key accepted by the chip and automatically choose the
> right firmware.
>
> We could imagine to add a attribute in the DT to choose the firmware to
> load. However, it would be a pity to have to specify it manually whereas
> the driver is able to detect it automatically.
>
> Currently, the only possible key is C0. However, it exists some internal
> parts with other keys. In addition, it is theoretically possible to ask
> to Silabs to burn parts with a specific key in order to improve security
> of a product.=20
>
> Obviously, for now, this feature mainly exists for the Silabs firmware
> developers who have to work with other keys.

My point above was about the directory "silabs". If I read the code
correctly, wfx driver tries to load "foo.bin" but in the linux-firmware
file is "silabs/foo.bin". So the should also include directory name in
the request and use "silabs/foo.bin".

>> Also I would prefer to use directory name as the driver name wfx, but I
>> guess silabs is also doable.
>
> I have no opinion.
>
>
>> Also I'm not seeing the PDS files in linux-firmware. The idea is that
>> when user installs an upstream kernel and the linux-firmware everything
>> will work automatically, without any manual file installations.
>
> WF200 is just a chip. Someone has to design an antenna before to be able
> to use.

Doesn't that apply to all wireless chips? :) Some store that information
to the EEPROM inside the chip, others somewhere outside of the chip.

> However, we have evaluation boards that have antennas and corresponding
> PDS files[1]. Maybe linux-firmware should include the PDS for these boards
> and the DT should contains the name of the design. eg:
>
>     compatible =3D "silabs,brd4001a", "silabs,wf200";
>
> So the driver will know which PDS it should use.=20
>
> In fact, I am sure I had this idea in mind when I have started to write
> the wfx driver. But with the time I have forgotten it.=20
>
> If you agree with that idea, I can work on it next week.

This sounds very similar what we have in ath10k, only that in ath10k we
call them board files. The way ath10k works is that we have board-2.bin
which is a container file containg multiple board files and then during
firmware initialisation ath10k automatically chooses the correct board
file based on various parameters like PCI subsystem ids, an id stored in
the eeprom, Device Tree etc. And then ath10k pushes the chosed board
file to the firmware.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
