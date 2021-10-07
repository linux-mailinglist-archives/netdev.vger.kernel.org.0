Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 191CB42514D
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 12:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240899AbhJGKn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 06:43:27 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:42211 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241089AbhJGKnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 06:43:23 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633603290; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=FZv7up9pezh0ULf63JB/fz3Zol9bcHG9+0bdesm9Xmw=; b=utyb0q4heUQHjM2xN4LBCviAs239efIyXmbwlc52JhK8grYJ8zjtpaUEhUl5wVgYZWQe055F
 Kp5XzUmeSGMsv4hfTZj/u1mT3ZLMGrVeu9JLOILnQuKw+KTQUH/xLWZCda4asNGNW1E3h2Y8
 mbe9wNbqoUyXdWJMOMZOGd9Ui3o=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 615eced603355859c85c5817 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 07 Oct 2021 10:41:26
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3896BC43617; Thu,  7 Oct 2021 10:41:26 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0DED9C4338F;
        Thu,  7 Oct 2021 10:41:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 0DED9C4338F
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
        <3570035.Z1gqkuQO5x@pc-42> <875yu9cjvk.fsf@codeaurora.org>
        <2672405.M38RcEoSet@pc-42>
Date:   Thu, 07 Oct 2021 13:41:18 +0300
In-Reply-To: <2672405.M38RcEoSet@pc-42> (=?utf-8?B?IkrDqXLDtG1l?=
 Pouiller"'s message of "Thu,
        07 Oct 2021 12:00:18 +0200")
Message-ID: <87zgrl86cx.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com> writes:

>> >> >> I'm not really fond of having this kind of ASCII based parser in t=
he
>> >> >> kernel. Do you have an example compressed file somewhere?
>> >> >
>> >> > An example of uncompressed configuration file can be found here[1].=
 Once
>> >> > compressed with [2], you get:
>> >> >
>> >> >     {a:{a:4,b:1},b:{a:{a:4,b:0,c:0,d:0,e:A},b:{a:4,b:0,c:0,d:0,e:B}=
,c:{a:4,b:0,c:0,d:0,e:C},d:{a:4,b:0,c:0,d:0,e:D},e:{a:4,b:0,c:0,d:0,e:E},f:=
{a:4,b:0,c:0,d:0,e:F},g:{a:4,b:0,c:0,d:0,e:G},h:{a:4,b:0,c:0,d:0,e:H},i:{a:=
4,b:0,c:0,d:0,e:I},j:{a:4,b:0,c:0,d:0,e:J},k:{a:4,b:0,c:0,d:0,e:K},l:{a:4,b=
:0,c:0,d:1,e:L},m:{a:4,b:0,c:0,d:1,e:M}},c:{a:{a:4},b:{a:6},c:{a:6,c:0},d:{=
a:6},e:{a:6},f:{a:6}},e:{b:0,c:1},h:{e:0,a:50,b:0,d:0,c:[{a:1,b:[0,0,0,0,0,=
0]},{a:2,b:[0,0,0,0,0,0]},{a:[3,9],b:[0,0,0,0,0,0]},{a:A,b:[0,0,0,0,0,0]},{=
a:B,b:[0,0,0,0,0,0]},{a:[C,D],b:[0,0,0,0,0,0]},{a:E,b:[0,0,0,0,0,0]}]},j:{a=
:0,b:0}}
>> >>
>> >> So what's the grand idea with this braces format? I'm not getting it.
>> >
>> >   - It allows to describe a tree structure
>> >   - It is ascii (easy to dump, easy to copy-paste)
>> >   - It is small (as I explain below, size matters)
>> >   - Since it is similar to JSON, the structure is obvious to many peop=
le
>> >
>> > Anyway, I am not the author of that and I have to deal with it.
>>=20
>> I'm a supported for JSON like formats, flexibility and all that. But
>> they belong to user space, not kernel.
>>=20
>> >> Usually the drivers just consider this kind of firmware configuration
>> >> data as a binary blob and dump it to the firmware, without knowing wh=
at
>> >> the data contains. Can't you do the same?
>> >
>> > [I didn't had received this mail :( ]
>> >
>> > The idea was also to send it as a binary blob. However, the firmware u=
se
>> > a limited buffer (1500 bytes) to parse it. In most of case the PDS exc=
eeds
>> > this size. So, we have to split the PDS before to send it.
>> >
>> > Unfortunately, we can't split it anywhere. The PDS is a tree structure=
 and
>> > the firmware expects to receive a well formatted tree.
>> >
>> > So, the easiest way to send it to the firmware is to split the tree
>> > between each root nodes and send each subtree separately (see also the
>> > comment above wfx_send_pds()).
>> >
>> > Anyway, someone has to cook this configuration before to send it to the
>> > firmware. This could be done by a script outside of the kernel. Then we
>> > could change the input format to simplify a bit the processing in the
>> > kernel.
>>=20
>> I think a binary file with TLV format would be much better, but I'm sure
>> there also other good choises.
>>=20
>> > However, the driver has already some users and I worry that changing
>> > the input format would lead to a mess.
>>=20
>> You can implement a script which converts the old format to the new
>> format. And you can use different naming scheme in the new format so
>> that we don't accidentally load the old format. And even better if you
>> add a some kind of signature in the new format and give a proper error
>> from the driver if it doesn't match.
>
> Ok. I am going to change the input format. I think the new function is
> going to look like:
>
> int wfx_send_pds(struct wfx_dev *wdev, u8 *buf, size_t buf_len)
> {
> 	int ret;
> 	int start =3D 0;
>
> 	if (buf[start] !=3D '{') {
> 		dev_err(wdev->dev, "valid PDS start with '{'. Did you forget to compres=
s it?\n");
> 		return -EINVAL;
> 	}
> 	while (start < buf_len) {
> 		len =3D strnlen(buf + start, buf_len - start);
> 		if (len > WFX_PDS_MAX_SIZE) {
> 			dev_err(wdev->dev, "PDS chunk is too big (legacy format?)\n");
> 			return -EINVAL;
> 		}
> 		dev_dbg(wdev->dev, "send PDS '%s'\n", buf + start);
> 		ret =3D wfx_hif_configuration(wdev, buf + start, len);
> 		/* FIXME: Add error handling here */
> 		start +=3D len;
> 	}
> 	return 0;

Did you read at all what I wrote above? Please ditch the ASCII format
completely.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
