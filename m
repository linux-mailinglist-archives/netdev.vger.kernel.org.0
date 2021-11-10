Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E59AB44BE2C
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 10:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbhKJKBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 05:01:43 -0500
Received: from m43-7.mailgun.net ([69.72.43.7]:35694 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230515AbhKJKBm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 05:01:42 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1636538335; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=fcAghAoVZ0JxeVWaGkjHk7dhQU80Wv79lwRh7/w5leA=; b=V1vAwLE1cLqHMDa9jXWTP9amL4SrS+8gTU4T8SPF4GKqmaIfwhqRi9RFCxlsHEiL0TWKJ3LH
 GO9FdP81I1IX+Y+KhgAQ2vZJbUCNfSpb1pwSJdvmviSpywvG7e9pHTOV+XpQn+ZRf9cs26H7
 JRv7/GjsCAcYOlVpdJ4tFHoCDgI=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 618b97db0f34c3436a4a4aae (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 10 Nov 2021 09:58:51
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8A01DC43616; Wed, 10 Nov 2021 09:58:50 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 85DE0C4338F;
        Wed, 10 Nov 2021 09:58:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 85DE0C4338F
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
        <87zgrl86cx.fsf@codeaurora.org> <87v92985ys.fsf@codeaurora.org>
        <6117440.dvjIZRh6BQ@pc-42>
Date:   Wed, 10 Nov 2021 11:58:41 +0200
In-Reply-To: <6117440.dvjIZRh6BQ@pc-42> (=?utf-8?B?IkrDqXLDtG1l?=
 Pouiller"'s message of "Thu,
        07 Oct 2021 13:22:14 +0200")
Message-ID: <87lf1wnxgu.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com> writes:

> On Thursday 7 October 2021 12:49:47 CEST Kalle Valo wrote:
>> CAUTION: This email originated from outside of the organization. Do
>> not click links or open attachments unless you recognize the sender
>> and know the content is safe.
>>=20
>>=20
>> Kalle Valo <kvalo@codeaurora.org> writes:
>>=20
>> > J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com> writes:
>> >
>> >>> >> >> I'm not really fond of having this kind of ASCII based parser =
in the
>> >>> >> >> kernel. Do you have an example compressed file somewhere?
>> >>> >> >
>> >>> >> > An example of uncompressed configuration file can be found here=
[1]. Once
>> >>> >> > compressed with [2], you get:
>> >>> >> >
>> >>> >> >     {a:{a:4,b:1},b:{a:{a:4,b:0,c:0,d:0,e:A},b:{a:4,b:0,c:0,d:0,=
e:B},c:{a:4,b:0,c:0,d:0,e:C},d:{a:4,b:0,c:0,d:0,e:D},e:{a:4,b:0,c:0,d:0,e:E=
},f:{a:4,b:0,c:0,d:0,e:F},g:{a:4,b:0,c:0,d:0,e:G},h:{a:4,b:0,c:0,d:0,e:H},i=
:{a:4,b:0,c:0,d:0,e:I},j:{a:4,b:0,c:0,d:0,e:J},k:{a:4,b:0,c:0,d:0,e:K},l:{a=
:4,b:0,c:0,d:1,e:L},m:{a:4,b:0,c:0,d:1,e:M}},c:{a:{a:4},b:{a:6},c:{a:6,c:0}=
,d:{a:6},e:{a:6},f:{a:6}},e:{b:0,c:1},h:{e:0,a:50,b:0,d:0,c:[{a:1,b:[0,0,0,=
0,0,0]},{a:2,b:[0,0,0,0,0,0]},{a:[3,9],b:[0,0,0,0,0,0]},{a:A,b:[0,0,0,0,0,0=
]},{a:B,b:[0,0,0,0,0,0]},{a:[C,D],b:[0,0,0,0,0,0]},{a:E,b:[0,0,0,0,0,0]}]},=
j:{a:0,b:0}}
>> >>> >>
>> >>> >> So what's the grand idea with this braces format? I'm not getting=
 it.
>> >>> >
>> >>> >   - It allows to describe a tree structure
>> >>> >   - It is ascii (easy to dump, easy to copy-paste)
>> >>> >   - It is small (as I explain below, size matters)
>> >>> >   - Since it is similar to JSON, the structure is obvious to many =
people
>> >>> >
>> >>> > Anyway, I am not the author of that and I have to deal with it.
>> >>>
>> >>> I'm a supported for JSON like formats, flexibility and all that. But
>> >>> they belong to user space, not kernel.
>> >>>
>> >>> >> Usually the drivers just consider this kind of firmware configura=
tion
>> >>> >> data as a binary blob and dump it to the firmware, without knowin=
g what
>> >>> >> the data contains. Can't you do the same?
>> >>> >
>> >>> > [I didn't had received this mail :( ]
>> >>> >
>> >>> > The idea was also to send it as a binary blob. However, the firmwa=
re use
>> >>> > a limited buffer (1500 bytes) to parse it. In most of case the PDS=
 exceeds
>> >>> > this size. So, we have to split the PDS before to send it.
>> >>> >
>> >>> > Unfortunately, we can't split it anywhere. The PDS is a tree struc=
ture and
>> >>> > the firmware expects to receive a well formatted tree.
>> >>> >
>> >>> > So, the easiest way to send it to the firmware is to split the tree
>> >>> > between each root nodes and send each subtree separately (see also=
 the
>> >>> > comment above wfx_send_pds()).
>> >>> >
>> >>> > Anyway, someone has to cook this configuration before to send it t=
o the
>> >>> > firmware. This could be done by a script outside of the kernel. Th=
en we
>> >>> > could change the input format to simplify a bit the processing in =
the
>> >>> > kernel.
>> >>>
>> >>> I think a binary file with TLV format would be much better, but I'm =
sure
>> >>> there also other good choises.
>> >>>
>> >>> > However, the driver has already some users and I worry that changi=
ng
>> >>> > the input format would lead to a mess.
>> >>>
>> >>> You can implement a script which converts the old format to the new
>> >>> format. And you can use different naming scheme in the new format so
>> >>> that we don't accidentally load the old format. And even better if y=
ou
>> >>> add a some kind of signature in the new format and give a proper err=
or
>> >>> from the driver if it doesn't match.
>> >>
>> >> Ok. I am going to change the input format. I think the new function is
>> >> going to look like:
>> >>
>> >> int wfx_send_pds(struct wfx_dev *wdev, u8 *buf, size_t buf_len)
>> >> {
>> >>      int ret;
>> >>      int start =3D 0;
>> >>
>> >>      if (buf[start] !=3D '{') {
>> >>              dev_err(wdev->dev, "valid PDS start with '{'. Did you fo=
rget to compress it?\n");
>> >>              return -EINVAL;
>> >>      }
>> >>      while (start < buf_len) {
>> >>              len =3D strnlen(buf + start, buf_len - start);
>> >>              if (len > WFX_PDS_MAX_SIZE) {
>> >>                      dev_err(wdev->dev, "PDS chunk is too big (legacy=
 format?)\n");
>> >>                      return -EINVAL;
>> >>              }
>> >>              dev_dbg(wdev->dev, "send PDS '%s'\n", buf + start);
>> >>              ret =3D wfx_hif_configuration(wdev, buf + start, len);
>> >>              /* FIXME: Add error handling here */
>> >>              start +=3D len;
>> >>      }
>> >>      return 0;
>> >
>> > Did you read at all what I wrote above? Please ditch the ASCII format
>> > completely.
>>=20
>> Sorry, I read this too hastily. I just saw "buf[start] !=3D '{'" and
>> assumed this is the same ASCII format, but not sure anymore. Can you
>> explain what changes you made now?
>
> The script I am going to write will compute where the PDS have to be split
> (this work is currently done by the driver). The script will add a
> separating character (let's say '\0') between each chunk.
>
> The driver will just have to find the separating character, send the
> chunk and repeat.

I would forget ASCII altogether and implement a proper binary format
like TLV. For example, ath10k uses TLV with board-2.bin files (grep for
enum ath10k_bd_ie_type).

Also I recommend changing the file "signature" ('{') to something else
so that the driver detects incorrect formats. And maybe even use suffix
.pds2 or something like that to make it more obvious and avoid
confusion?

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
