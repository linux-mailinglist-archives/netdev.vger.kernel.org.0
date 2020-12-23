Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A77B82E1887
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 06:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgLWF3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 00:29:46 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:34354 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgLWF3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 00:29:46 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608701365; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=+PgCftFCNKFXUIzjrZaJrrb1dDkJP0N7TDJaNh3c03M=; b=P8KGtr8Ih/acNhKj7ec2Y1pWv6wpuKN2gGELepv2/Rkq6HBI5L4rIsRoxsauN8DTcFUUdJ2n
 umyAHf7D6MgqXH0NUzyjkqpQMiPc8frZangTw+VvT99oSDk33e0x3iBNXumqu2Ih7CwTMH6Z
 ke+BfXB0Xvm9FFcbqGIzZTmPewE=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5fe2d591da471981883969b9 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 23 Dec 2020 05:28:49
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DC5C9C43461; Wed, 23 Dec 2020 05:28:49 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 460EBC433C6;
        Wed, 23 Dec 2020 05:28:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 460EBC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, linux-mmc@vger.kernel.org,
        Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3 09/24] wfx: add hwio.c/hwio.h
References: <20201104155207.128076-1-Jerome.Pouiller@silabs.com>
        <87lfdp98rw.fsf@codeaurora.org> <X+IQRct0Zsm87H4+@kroah.com>
        <4279510.LvFx2qVVIh@pc-42>
Date:   Wed, 23 Dec 2020 07:28:44 +0200
In-Reply-To: <4279510.LvFx2qVVIh@pc-42> (=?utf-8?B?IkrDqXLDtG1l?=
 Pouiller"'s message of "Tue,
        22 Dec 2020 22:02:09 +0100")
Message-ID: <87im8t5bw3.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com> writes:

> On Tuesday 22 December 2020 16:27:01 CET Greg Kroah-Hartman wrote:
>>=20
>> On Tue, Dec 22, 2020 at 05:10:11PM +0200, Kalle Valo wrote:
>> > Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
>> >
>> > > +/*
>> > > + * Internal helpers.
>> > > + *
>> > > + * About CONFIG_VMAP_STACK:
>> > > + * When CONFIG_VMAP_STACK is enabled, it is not possible to run DMA=
 on stack
>> > > + * allocated data. Functions below that work with registers (aka fu=
nctions
>> > > + * ending with "32") automatically reallocate buffers with kmalloc.=
 However,
>> > > + * functions that work with arbitrary length buffers let's caller t=
o handle
>> > > + * memory location. In doubt, enable CONFIG_DEBUG_SG to detect badl=
y located
>> > > + * buffer.
>> > > + */
>> >
>> > This sounds very hacky to me, I have understood that you should never
>> > use stack with DMA.
>>=20
>> You should never do that because some platforms do not support it, so no
>> driver should ever try to do that as they do not know what platform they
>> are running on.
>
> Yes, I have learned this rule the hard way.
>
> There is no better way than a comment to warn the user that the argument
> will be used with a DMA? A Sparse annotation, for example?

I have not seen anything, but something like sparse annotation would be
useful. Please let me know if you find anything like that.

But I think that CONFIG_VMAP_STACK is irrelevant and the comment should
be clarified that using stack memory must NOT be used for DMA operations
in any circumstances.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
