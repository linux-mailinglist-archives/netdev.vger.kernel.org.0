Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55DC424F15
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 10:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240506AbhJGIVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 04:21:35 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:33720 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240564AbhJGIVd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 04:21:33 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633594780; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=LSxmq3rMA8NZvaYFl3dGhnm4Cba8lTjnSx3hcXv6438=; b=exIDu+C0DhY/34HkFZw7Yxlay+ps4PKTf14+qKaP9cB5iMY65QxjKK63D9Tob+Hapo93k4X0
 guKhMSlCV1RnGIxfuad+C6qrZB9RVdBcEFbt3ekhtnXSPtZm5Hh5tanvkvsVRY5VzWCYOLil
 G1Xv4vPHdvz38n29PiNWzi4y1/o=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 615ead857ae92c7fc9457dd8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 07 Oct 2021 08:19:17
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 645C6C43616; Thu,  7 Oct 2021 08:19:16 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 65074C4338F;
        Thu,  7 Oct 2021 08:19:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 65074C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>
Cc:     Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v7 10/24] wfx: add fwio.c/fwio.h
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com>
        <2174509.SLDT7moDbM@pc-42> <20211001160832.ozxc7bhlwlmjeqbo@pali>
        <19961646.Mslci0rqIs@pc-42>
Date:   Thu, 07 Oct 2021 11:19:10 +0300
In-Reply-To: <19961646.Mslci0rqIs@pc-42> (=?utf-8?B?IkrDqXLDtG1l?=
 Pouiller"'s message of "Fri,
        01 Oct 2021 18:46:44 +0200")
Message-ID: <87lf35ckn5.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com> writes:

> On Friday 1 October 2021 18:08:32 CEST Pali Roh=C3=A1r wrote:
>> On Friday 01 October 2021 17:09:41 J=C3=A9r=C3=B4me Pouiller wrote:
>> > On Friday 1 October 2021 13:58:38 CEST Kalle Valo wrote:
>> > > Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
>> > >
>> > > > From: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
>> > > >
>> > > > Signed-off-by: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.c=
om>
>> > >
>> > > [...]
>> > >
>> > > > +static int get_firmware(struct wfx_dev *wdev, u32 keyset_chip,
>> > > > +                     const struct firmware **fw, int *file_offset)
>> > > > +{
>> > > > +     int keyset_file;
>> > > > +     char filename[256];
>> > > > +     const char *data;
>> > > > +     int ret;
>> > > > +
>> > > > +     snprintf(filename, sizeof(filename), "%s_%02X.sec",
>> > > > +              wdev->pdata.file_fw, keyset_chip);
>> > > > +     ret =3D firmware_request_nowarn(fw, filename, wdev->dev);
>> > > > +     if (ret) {
>> > > > +             dev_info(wdev->dev, "can't load %s, falling back to =
%s.sec\n",
>> > > > +                      filename, wdev->pdata.file_fw);
>> > > > +             snprintf(filename, sizeof(filename), "%s.sec",
>> > > > +                      wdev->pdata.file_fw);
>> > > > +             ret =3D request_firmware(fw, filename, wdev->dev);
>> > > > +             if (ret) {
>> > > > +                     dev_err(wdev->dev, "can't load %s\n", filena=
me);
>> > > > +                     *fw =3D NULL;
>> > > > +                     return ret;
>> > > > +             }
>> > > > +     }
>> > >
>> > > How is this firmware file loading supposed to work? If I'm reading t=
he
>> > > code right, the driver tries to load file "wfm_wf200_??.sec" but in
>> > > linux-firmware the file is silabs/wfm_wf200_C0.sec:
>> > >
>> > > https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmw=
are.git/tree/silabs
>> > >
>> > > That can't work automatically, unless I'm missing something of cours=
e.
>> >
>> > The firmware are signed. "C0" is the key used to sign this firmware. T=
his
>> > key must match with the key burned into the chip. Fortunately, the dri=
ver
>> > is able to read the key accepted by the chip and automatically choose =
the
>> > right firmware.
>> >
>> > We could imagine to add a attribute in the DT to choose the firmware to
>> > load. However, it would be a pity to have to specify it manually where=
as
>> > the driver is able to detect it automatically.
>> >
>> > Currently, the only possible key is C0. However, it exists some intern=
al
>> > parts with other keys. In addition, it is theoretically possible to ask
>> > to Silabs to burn parts with a specific key in order to improve securi=
ty
>> > of a product.
>> >
>> > Obviously, for now, this feature mainly exists for the Silabs firmware
>> > developers who have to work with other keys.
>> >
>> > > Also I would prefer to use directory name as the driver name wfx, bu=
t I
>> > > guess silabs is also doable.
>> >
>> > I have no opinion.
>> >
>> >
>> > > Also I'm not seeing the PDS files in linux-firmware. The idea is that
>> > > when user installs an upstream kernel and the linux-firmware everyth=
ing
>> > > will work automatically, without any manual file installations.
>> >
>> > WF200 is just a chip. Someone has to design an antenna before to be ab=
le
>> > to use.
>> >
>> > However, we have evaluation boards that have antennas and corresponding
>> > PDS files[1]. Maybe linux-firmware should include the PDS for these bo=
ards
>>=20
>> So chip vendor provides firmware and card vendor provides PDS files.
>
> Exactly.
>
>> In
>> my opinion all files should go into linux-firmware repository. If Silabs
>> has PDS files for its devel boards (which are basically cards) then I
>> think these files should go also into linux-firmware repository.
>>=20
>> And based on some parameter, driver should load correct PDS file. Seems
>> like DT can be a place where to put something which indicates which PDS
>> file should be used.
>>=20
>> But should be in DT directly name of PDS file? Or should be in DT just
>> additional compatible string with card vendor name and then in driver
>> itself should be mapping table from compatible string to filename? I do
>> not know what is better.
>
> The DT already accepts the attribute silabs,antenna-config-file (see
> patch #2).
>
> I think that linux-firmware repository will reject the pds files if
> no driver in the kernel directly point to it. Else how to detect
> orphans?

This (linux-firmware rejecting files) is news to me, do you have any
pointers?

> So, I think it is slightly better to use a mapping table.

Not following you here.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
