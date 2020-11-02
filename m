Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4FD2A2ED4
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 16:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgKBP6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 10:58:18 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:26900 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726612AbgKBP6R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 10:58:17 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604332697; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=kP87ryMp5ujlGNQxxe2/b+S1KvTJacb5RVmVXpD9rUg=; b=xYDiwjLHekZsbhAuuYi86SCTmaW5hKz6QlfFYO03WsE9UA5rgkp6gMPzvUmK20SpQ/BudA+i
 XmI750xub7XQzEme1xwqKepROb88iYI8yIjaqKkpMNAA026TWDdSdsxJs8rre5BxBaWlNvUU
 lO2VfPoFV1O6aKfbUigmajEBYQM=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5fa02c98d8a9d167f347e713 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 02 Nov 2020 15:58:16
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 890B6C433FE; Mon,  2 Nov 2020 15:58:16 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7C085C433C9;
        Mon,  2 Nov 2020 15:58:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7C085C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>
Cc:     Rob Herring <robh@kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 01/23] dt-bindings: introduce silabs,wfx.yaml
References: <20201012104648.985256-1-Jerome.Pouiller@silabs.com>
        <20201012104648.985256-2-Jerome.Pouiller@silabs.com>
        <20201013164935.GA3646933@bogus> <3929101.dIHeVNgAIR@pc-42>
Date:   Mon, 02 Nov 2020 17:58:11 +0200
In-Reply-To: <3929101.dIHeVNgAIR@pc-42> (=?utf-8?B?IkrDqXLDtG1l?=
 Pouiller"'s message of "Wed,
        14 Oct 2020 15:49:12 +0200")
Message-ID: <87imanpx7w.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com> writes:

> On Tuesday 13 October 2020 18:49:35 CEST Rob Herring wrote:
>> On Mon, Oct 12, 2020 at 12:46:26PM +0200, Jerome Pouiller wrote:
>> > From: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
> [...]
>> > +  Note that in add of the properties below, the WFx driver also suppo=
rts
>> > +  `mac-address` and `local-mac-address` as described in
>> > +  Documentation/devicetree/bindings/net/ethernet.txt
>>=20
>> Note what ethernet.txt contains... This should have a $ref to
>> ethernet-controller.yaml to express the above.
>>=20
>> You can add 'mac-address: true' if you want to be explicit about what
>> properties are used.
>
> Here, only mac-address and local-mac-address are supported. So, would the
> code below do the job?
>
>   local-mac-address:
>     $ref: ethernet-controller.yaml#/properties/local-mac-address
>
>   mac-address:
>     $ref: ethernet-controller.yaml#/properties/mac-address
>
>
> [...]
>> > +  spi-max-frequency:
>> > +    description: (SPI only) Maximum SPI clocking speed of device in H=
z.
>>=20
>> No need to redefine a common property.
>
> When a property is specific to a bus, I would have like to explicitly
> say it. That's why I redefined the description.
>
>
> [...]
>> > +  config-file:
>> > +    description: Use an alternative file as PDS. Default is `wf200.pd=
s`. Only
>> > +      necessary for development/debug purpose.
>>=20
>> 'firmware-name' is typically what we'd use here. Though if just for
>> debug/dev, perhaps do a debugfs interface for this instead. As DT should
>> come from the firmware/bootloader, requiring changing the DT for
>> dev/debug is not the easiest workflow compared to doing something from
>> userspace.
>
> This file is not a firmware. It mainly contains data related to the
> antenna. At the beginning, this property has been added for
> development. With the time, I think it can be used to  have one disk
> image for several devices that differ only in antenna.
>
> I am going to remove the part about development/debug purpose.

config-file doesn't sound right either. So what kind of data is this,
calibration data or what?

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
