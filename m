Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF251422F66
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 19:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234559AbhJERv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 13:51:56 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:41156 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234217AbhJERvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 13:51:54 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633456203; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=umNYz8pA01LGfst/ZDKb/BGeTkpsTgzCMazCvgWWhM4=; b=VjtQjJwQyacALVa+HJ4owpHSoS/5KMh/aHpaHvdiNdxhl+jU0qH3E7xovWXv2Z9m/khV//r1
 QSeZOBkC01lBripgAbe6v9DOmGqmB532zFgGmcLPCugGixT2lB8IK8/EqgJeR7V0xor8Eni9
 S02aHQlcckY4RLA28AYAoY8l6yk=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 615c903a003e680efbce267c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 05 Oct 2021 17:49:46
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9EE95C4338F; Tue,  5 Oct 2021 17:49:45 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E2E1DC4338F;
        Tue,  5 Oct 2021 17:49:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org E2E1DC4338F
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
        <875yubfthh.fsf@codeaurora.org> <2810333.gDgIz5hftg@pc-42>
Date:   Tue, 05 Oct 2021 20:49:37 +0300
In-Reply-To: <2810333.gDgIz5hftg@pc-42> (=?utf-8?B?IkrDqXLDtG1l?=
 Pouiller"'s message of "Tue,
        05 Oct 2021 18:22:31 +0200")
Message-ID: <87o883e4zy.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com> writes:

> On Tuesday 5 October 2021 16:15:22 CEST Kalle Valo wrote:
>> Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
>>=20
>> > From: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
> [...]
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
>>=20
>> For the PDS file problem it would help if you could actually describe
>> what the firmware requires/needs and then we can start from that. I had
>> some questions about this in v7 but apparently you missed those.
>
> Did you received this reply[1]?
>
> [1]: https://lore.kernel.org/all/2723787.uDASXpoAWK@pc-42/

I did and I even made further questions:

https://lore.kernel.org/all/87k0ixj5vn.fsf@codeaurora.org/

Can we please continue the discussion on that thread instead of passing
out lore links to each other :)

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
