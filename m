Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBAAC421E7C
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 07:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbhJEF7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 01:59:05 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:25588 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbhJEF7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 01:59:04 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633413434; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=YmROy8vchD7nTW7VEG0tMTR10D8w5HdNqectY0pOlr4=; b=e4rvkttDUkyohCvvjdJotPocXH04+NV+ZWvAcBuXjF0r6iQO0/6jCUxcCOknLccMS+tmInXF
 //aNnOyuAC2aDcKJTWQ5HAquCLJ77Mln6ldcH1szE1z8R0sx5QSG32Ch2er+u8r3XXOxyaPN
 LtXIWZgTDSF0E64ns7uooSJ91go=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 615be92e0d9325367bd699ff (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 05 Oct 2021 05:57:02
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 91D7AC43617; Tue,  5 Oct 2021 05:57:02 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C83CBC4338F;
        Tue,  5 Oct 2021 05:56:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org C83CBC4338F
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
Subject: Re: [PATCH v7 05/24] wfx: add main.c/main.h
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com>
        <20210920161136.2398632-6-Jerome.Pouiller@silabs.com>
        <87y27dkslb.fsf@codeaurora.org> <3660480.PpQ1LQVJpD@pc-42>
Date:   Tue, 05 Oct 2021 08:56:53 +0300
In-Reply-To: <3660480.PpQ1LQVJpD@pc-42> (=?utf-8?B?IkrDqXLDtG1l?=
 Pouiller"'s message of "Fri,
        01 Oct 2021 17:29:57 +0200")
Message-ID: <8735pgggka.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com> writes:

> On Friday 1 October 2021 11:22:08 CEST Kalle Valo wrote:
>> CAUTION: This email originated from outside of the organization. Do
>> not click links or open attachments unless you recognize the sender
>> and know the content is safe.
>>=20
>>=20
>> Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
>>=20
>> > From: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
>> >
>> > Signed-off-by: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
>>=20
>> [...]
>>=20
>> > +/* The device needs data about the antenna configuration. This inform=
ation in
>> > + * provided by PDS (Platform Data Set, this is the wording used in WF=
200
>> > + * documentation) files. For hardware integrators, the full process t=
o create
>> > + * PDS files is described here:
>> > + *   https:github.com/SiliconLabs/wfx-firmware/blob/master/PDS/README=
.md
>> > + *
>> > + * So this function aims to send PDS to the device. However, the PDS =
file is
>> > + * often bigger than Rx buffers of the chip, so it has to be sent in =
multiple
>> > + * parts.
>> > + *
>> > + * In add, the PDS data cannot be split anywhere. The PDS files conta=
ins tree
>> > + * structures. Braces are used to enter/leave a level of the tree (in=
 a JSON
>> > + * fashion). PDS files can only been split between root nodes.
>> > + */
>> > +int wfx_send_pds(struct wfx_dev *wdev, u8 *buf, size_t len)
>> > +{
>> > +     int ret;
>> > +     int start, brace_level, i;
>> > +
>> > +     start =3D 0;
>> > +     brace_level =3D 0;
>> > +     if (buf[0] !=3D '{') {
>> > + dev_err(wdev->dev, "valid PDS start with '{'. Did you forget to
>> > compress it?\n");
>> > +             return -EINVAL;
>> > +     }
>> > +     for (i =3D 1; i < len - 1; i++) {
>> > +             if (buf[i] =3D=3D '{')
>> > +                     brace_level++;
>> > +             if (buf[i] =3D=3D '}')
>> > +                     brace_level--;
>> > +             if (buf[i] =3D=3D '}' && !brace_level) {
>> > +                     i++;
>> > +                     if (i - start + 1 > WFX_PDS_MAX_SIZE)
>> > +                             return -EFBIG;
>> > +                     buf[start] =3D '{';
>> > +                     buf[i] =3D 0;
>> > +                     dev_dbg(wdev->dev, "send PDS '%s}'\n", buf + sta=
rt);
>> > +                     buf[i] =3D '}';
>> > +                     ret =3D hif_configuration(wdev, buf + start,
>> > +                                             i - start + 1);
>> > +                     if (ret > 0) {
>> > + dev_err(wdev->dev, "PDS bytes %d to %d: invalid data (unsupported
>> > options?)\n",
>> > +                                     start, i);
>> > +                             return -EINVAL;
>> > +                     }
>> > +                     if (ret =3D=3D -ETIMEDOUT) {
>> > + dev_err(wdev->dev, "PDS bytes %d to %d: chip didn't reply (corrupted
>> > file?)\n",
>> > +                                     start, i);
>> > +                             return ret;
>> > +                     }
>> > +                     if (ret) {
>> > + dev_err(wdev->dev, "PDS bytes %d to %d: chip returned an unknown
>> > error\n",
>> > +                                     start, i);
>> > +                             return -EIO;
>> > +                     }
>> > +                     buf[i] =3D ',';
>> > +                     start =3D i;
>> > +             }
>> > +     }
>> > +     return 0;
>> > +}
>>=20
>> I'm not really fond of having this kind of ASCII based parser in the
>> kernel. Do you have an example compressed file somewhere?
>>=20
>> Does the device still work without these PDS files? I ask because my
>> suggestion is to remove this part altogether and revisit after the
>> initial driver is moved to drivers/net/wireless. A lot simpler to review
>> complex features separately.
>
> Do you want I remove this function from this patch and place it a new
> patch at the end of this series?

I don't understand, how that would help? The problem here is the file
format and that's what we should try to fix.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
