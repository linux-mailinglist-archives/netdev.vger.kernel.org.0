Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E38235C5BF
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 13:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240650AbhDLLzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 07:55:19 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:41390 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240467AbhDLLzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 07:55:18 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1618228500; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=vdPB/4mlyh2rNRzqrJP2XjppQ3JehxA6cUhYVRcwhQc=; b=KZdUbUW2AdG3ThJtCGMa+3Hhd5VuVtXwp2ygEBvtHPlGQZQhI5yxursUoHBc7gvXfPu50hrX
 JTD4zl7yt1QzzFTQ8jJ75F8hfp8L72DjrjUA3Xv70hUl9xMo2WLVc5MPUmUP6I4lIGx5DcOE
 0+7RySAZtOiiyKDuJKwueyiWdeQ=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 6074350d03cfff34528bdc40 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 12 Apr 2021 11:54:53
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 29BEEC43463; Mon, 12 Apr 2021 11:54:53 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D3890C433C6;
        Mon, 12 Apr 2021 11:54:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D3890C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Shawn Guo <shawn.guo@linaro.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: Re: [PATCH 1/2] dt-binding: bcm43xx-fmac: add optional brcm,ccode-map
References: <20210408113022.18180-1-shawn.guo@linaro.org>
        <20210408113022.18180-2-shawn.guo@linaro.org>
        <87k0p9mewt.fsf@codeaurora.org> <20210412012528.GB15093@dragon>
Date:   Mon, 12 Apr 2021 14:54:46 +0300
In-Reply-To: <20210412012528.GB15093@dragon> (Shawn Guo's message of "Mon, 12
        Apr 2021 09:25:29 +0800")
Message-ID: <87im4rlnuh.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Shawn Guo <shawn.guo@linaro.org> writes:

> On Sun, Apr 11, 2021 at 10:57:54AM +0300, Kalle Valo wrote:
>> Shawn Guo <shawn.guo@linaro.org> writes:
>> 
>> > Add optional brcm,ccode-map property to support translation from ISO3166
>> > country code to brcmfmac firmware country code and revision.
>> >
>> > Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
>> > ---
>> >  .../devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt | 7 +++++++
>> >  1 file changed, 7 insertions(+)
>> >
>> > diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
>> > index cffb2d6876e3..a65ac4384c04 100644
>> > --- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
>> > +++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
>> > @@ -15,6 +15,12 @@ Optional properties:
>> >  	When not specified the device will use in-band SDIO interrupts.
>> >   - interrupt-names : name of the out-of-band interrupt, which must be set
>> >  	to "host-wake".
>> > + - brcm,ccode-map : multiple strings for translating ISO3166 country code to
>> > +	brcmfmac firmware country code and revision.  Each string must be in
>> > +	format "AA-BB-num" where:
>> > +	  AA is the ISO3166 country code which must be 2 characters.
>> > +	  BB is the firmware country code which must be 2 characters.
>> > +	  num is the revision number which must fit into signed integer.
>> >  
>> >  Example:
>> >  
>> > @@ -34,5 +40,6 @@ mmc3: mmc@1c12000 {
>> >  		interrupt-parent = <&pio>;
>> >  		interrupts = <10 8>; /* PH10 / EINT10 */
>> >  		interrupt-names = "host-wake";
>> > +		brcm,ccode-map = "JP-JP-78", "US-Q2-86";
>> 
>> The commit log does not answer "Why?". Why this needs to be in device
>> tree and, for example, not hard coded in the driver?
>
> Thanks for the comment, Kalle.  Actually, this is something I need some
> input from driver maintainers.  I can see this country code mapping
> table is chipset specific, and can be hard coded in driver per chip id
> and revision.  But on the other hand, it makes some sense to have this
> table in device tree, as the country code that need to be supported
> could be a device specific configuration.

Could be? Does such a use case exist at the moment or are just guessing
future needs?

From what I have learned so far I think this kind of data should be in
the driver, but of course I might be missing something.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
