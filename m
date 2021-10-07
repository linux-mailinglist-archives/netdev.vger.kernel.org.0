Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2A4424F59
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 10:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240621AbhJGIhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 04:37:51 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:64222 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232500AbhJGIhu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 04:37:50 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633595757; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=THqy+F0YtKNfeYDAR6Uu0AL5jJ4BrmAfvTC+DB6h4Dw=; b=EjfAbrh/FhmOPJ6/BT9ZCjp89ZRPrxt65WmJGkWEfF+rxbLvXtVA4expr2Hj1PNa63eKdVs4
 /Q4B87MgGtdfwPPayupzyLJ201F5NwX7NwNA7yCzMDecNtgWyiQX6+a/S0omOG9iLKUamhvi
 UP+CfX3F5xeqmy1MLSw2hujUdxo=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 615eb169b8ab9916b3ee7ae0 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 07 Oct 2021 08:35:53
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7136FC43616; Thu,  7 Oct 2021 08:35:52 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D47DBC4338F;
        Thu,  7 Oct 2021 08:35:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org D47DBC4338F
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
        <2723787.uDASXpoAWK@pc-42> <87k0ixj5vn.fsf@codeaurora.org>
        <3570035.Z1gqkuQO5x@pc-42>
Date:   Thu, 07 Oct 2021 11:35:43 +0300
In-Reply-To: <3570035.Z1gqkuQO5x@pc-42> (=?utf-8?B?IkrDqXLDtG1l?=
 Pouiller"'s message of "Wed,
        06 Oct 2021 09:32:49 +0200")
Message-ID: <875yu9cjvk.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com> writes:

> Hi Kalle,
>
> On Friday 1 October 2021 14:18:04 CEST Kalle Valo wrote:
>> J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com> writes:
>>=20
>> > On Friday 1 October 2021 11:22:08 CEST Kalle Valo wrote:
>> >> Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
>> >>=20
>> >> > From: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
>> >> >
>> >> > Signed-off-by: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.co=
m>
>> >>=20
>> >> [...]
>> >>=20
>> >> > +/* The device needs data about the antenna configuration. This inf=
ormation in
>> >> > + * provided by PDS (Platform Data Set, this is the wording used in=
 WF200
>> >> > + * documentation) files. For hardware integrators, the full proces=
s to create
>> >> > + * PDS files is described here:
>> >> > + *   https:github.com/SiliconLabs/wfx-firmware/blob/master/PDS/REA=
DME.md
>> >> > + *
>> >> > + * So this function aims to send PDS to the device. However, the P=
DS file is
>> >> > + * often bigger than Rx buffers of the chip, so it has to be sent =
in multiple
>> >> > + * parts.
>> >> > + *
>> >> > + * In add, the PDS data cannot be split anywhere. The PDS files co=
ntains tree
>> >> > + * structures. Braces are used to enter/leave a level of the tree =
(in a JSON
>> >> > + * fashion). PDS files can only been split between root nodes.
>> >> > + */
>> >> > +int wfx_send_pds(struct wfx_dev *wdev, u8 *buf, size_t len)
>> >> > +{
>> >> > +     int ret;
>> >> > +     int start, brace_level, i;
>> >> > +
>> >> > +     start =3D 0;
>> >> > +     brace_level =3D 0;
>> >> > +     if (buf[0] !=3D '{') {
>> >> > + dev_err(wdev->dev, "valid PDS start with '{'. Did you forget to
>> >> > compress it?\n");
>> >> > +             return -EINVAL;
>> >> > +     }
>> >> > +     for (i =3D 1; i < len - 1; i++) {
>> >> > +             if (buf[i] =3D=3D '{')
>> >> > +                     brace_level++;
>> >> > +             if (buf[i] =3D=3D '}')
>> >> > +                     brace_level--;
>> >> > +             if (buf[i] =3D=3D '}' && !brace_level) {
>> >> > +                     i++;
>> >> > +                     if (i - start + 1 > WFX_PDS_MAX_SIZE)
>> >> > +                             return -EFBIG;
>> >> > +                     buf[start] =3D '{';
>> >> > +                     buf[i] =3D 0;
>> >> > +                     dev_dbg(wdev->dev, "send PDS '%s}'\n", buf + =
start);
>> >> > +                     buf[i] =3D '}';
>> >> > +                     ret =3D hif_configuration(wdev, buf + start,
>> >> > +                                             i - start + 1);
>> >> > +                     if (ret > 0) {
>> >> > + dev_err(wdev->dev, "PDS bytes %d to %d: invalid data (unsupported
>> >> > options?)\n",
>> >> > +                                     start, i);
>> >> > +                             return -EINVAL;
>> >> > +                     }
>> >> > +                     if (ret =3D=3D -ETIMEDOUT) {
>> >> > + dev_err(wdev->dev, "PDS bytes %d to %d: chip didn't reply (corrup=
ted
>> >> > file?)\n",
>> >> > +                                     start, i);
>> >> > +                             return ret;
>> >> > +                     }
>> >> > +                     if (ret) {
>> >> > + dev_err(wdev->dev, "PDS bytes %d to %d: chip returned an unknown
>> >> > error\n",
>> >> > +                                     start, i);
>> >> > +                             return -EIO;
>> >> > +                     }
>> >> > +                     buf[i] =3D ',';
>> >> > +                     start =3D i;
>> >> > +             }
>> >> > +     }
>> >> > +     return 0;
>> >> > +}
>> >>=20
>> >> I'm not really fond of having this kind of ASCII based parser in the
>> >> kernel. Do you have an example compressed file somewhere?
>> >
>> > An example of uncompressed configuration file can be found here[1]. On=
ce
>> > compressed with [2], you get:
>> >
>> >     {a:{a:4,b:1},b:{a:{a:4,b:0,c:0,d:0,e:A},b:{a:4,b:0,c:0,d:0,e:B},c:=
{a:4,b:0,c:0,d:0,e:C},d:{a:4,b:0,c:0,d:0,e:D},e:{a:4,b:0,c:0,d:0,e:E},f:{a:=
4,b:0,c:0,d:0,e:F},g:{a:4,b:0,c:0,d:0,e:G},h:{a:4,b:0,c:0,d:0,e:H},i:{a:4,b=
:0,c:0,d:0,e:I},j:{a:4,b:0,c:0,d:0,e:J},k:{a:4,b:0,c:0,d:0,e:K},l:{a:4,b:0,=
c:0,d:1,e:L},m:{a:4,b:0,c:0,d:1,e:M}},c:{a:{a:4},b:{a:6},c:{a:6,c:0},d:{a:6=
},e:{a:6},f:{a:6}},e:{b:0,c:1},h:{e:0,a:50,b:0,d:0,c:[{a:1,b:[0,0,0,0,0,0]}=
,{a:2,b:[0,0,0,0,0,0]},{a:[3,9],b:[0,0,0,0,0,0]},{a:A,b:[0,0,0,0,0,0]},{a:B=
,b:[0,0,0,0,0,0]},{a:[C,D],b:[0,0,0,0,0,0]},{a:E,b:[0,0,0,0,0,0]}]},j:{a:0,=
b:0}}
>>=20
>> So what's the grand idea with this braces format? I'm not getting it.
>
>   - It allows to describe a tree structure
>   - It is ascii (easy to dump, easy to copy-paste)
>   - It is small (as I explain below, size matters)
>   - Since it is similar to JSON, the structure is obvious to many people
>
> Anyway, I am not the author of that and I have to deal with it.

I'm a supported for JSON like formats, flexibility and all that. But
they belong to user space, not kernel.

>> Usually the drivers just consider this kind of firmware configuration
>> data as a binary blob and dump it to the firmware, without knowing what
>> the data contains. Can't you do the same?
>
> [I didn't had received this mail :( ]
>
> The idea was also to send it as a binary blob. However, the firmware use
> a limited buffer (1500 bytes) to parse it. In most of case the PDS exceeds
> this size. So, we have to split the PDS before to send it.
>
> Unfortunately, we can't split it anywhere. The PDS is a tree structure and
> the firmware expects to receive a well formatted tree.
>
> So, the easiest way to send it to the firmware is to split the tree
> between each root nodes and send each subtree separately (see also the
> comment above wfx_send_pds()).
>
> Anyway, someone has to cook this configuration before to send it to the
> firmware. This could be done by a script outside of the kernel. Then we
> could change the input format to simplify a bit the processing in the
> kernel.

I think a binary file with TLV format would be much better, but I'm sure
there also other good choises.

> However, the driver has already some users and I worry that changing
> the input format would lead to a mess.

You can implement a script which converts the old format to the new
format. And you can use different naming scheme in the new format so
that we don't accidentally load the old format. And even better if you
add a some kind of signature in the new format and give a proper error
from the driver if it doesn't match.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
