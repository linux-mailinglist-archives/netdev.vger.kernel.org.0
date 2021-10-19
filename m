Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 545C2433814
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 16:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhJSOLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 10:11:41 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:21504 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232726AbhJSOLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 10:11:40 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634652567; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=WY2I3/9Ukehmx/Ml8RRSY/034uNGRLFMxiyy7ZlPyKo=; b=w29hNv4FRxFTPbMyQPfgMcAgQbvVdwrgXAn8II9d8UDevbMGINqvuGCR0oWGafZEyQPoqZFJ
 ydd32IVKItx10Nr9NKj+XwnDBnJZPqWFRo0YSnguzcI3hZo/1C9U7j9RMsr9ZaGnHPSVrpwg
 cY0NIA0odHFuE2hm97LEGmxz4oU=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 616ed0b8b03398c06c521e8d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 19 Oct 2021 14:05:44
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 386C5C4360C; Tue, 19 Oct 2021 14:05:44 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B3E66C4338F;
        Tue, 19 Oct 2021 14:05:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org B3E66C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?utf-8?Q?Beno?= =?utf-8?Q?=C3=AEt?= Cousson 
        <bcousson@baylibre.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@armlinux.org.uk>,
        David Lechner <david@lechnology.com>,
        Sebastian Reichel <sre@kernel.org>,
        "open list\:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "open list\:TI ETHERNET SWITCH DRIVER \(CPSW\)" 
        <linux-omap@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH 0/3] dt-bindings: net: TI wlcore json schema conversion and fix
References: <cover.1634646975.git.geert+renesas@glider.be>
        <87a6j5gmvg.fsf@codeaurora.org>
        <CAMuHMdWEwsK=jUt=T8irpAdjocLtAjajBCacGHnu4fKKio6ZbA@mail.gmail.com>
Date:   Tue, 19 Oct 2021 17:05:37 +0300
In-Reply-To: <CAMuHMdWEwsK=jUt=T8irpAdjocLtAjajBCacGHnu4fKKio6ZbA@mail.gmail.com>
        (Geert Uytterhoeven's message of "Tue, 19 Oct 2021 15:48:03 +0200")
Message-ID: <8735oxgle6.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> On Tue, Oct 19, 2021 at 3:33 PM Kalle Valo <kvalo@codeaurora.org> wrote:
>> Geert Uytterhoeven <geert+renesas@glider.be> writes:
>> > This patch series converts the Device Tree bindings for the Texas
>> > Instruments Wilink Wireless LAN and Bluetooth Controllers to
>> > json-schema, after fixing an issue in a Device Tree source file.
>> >
>> > Thanks for your comments!
>> >
>> > Geert Uytterhoeven (3):
>> >   ARM: dts: motorola-mapphone: Drop second ti,wlcore compatible value
>> >   dt-bindings: net: wireless: ti,wlcore: Convert to json-schema
>> >   dt-bindings: net: ti,bluetooth: Convert to json-schema
>> >
>> >  .../devicetree/bindings/net/ti,bluetooth.yaml |  91 ++++++++++++
>> >  .../devicetree/bindings/net/ti-bluetooth.txt  |  60 --------
>> >  .../bindings/net/wireless/ti,wlcore,spi.txt   |  57 --------
>> >  .../bindings/net/wireless/ti,wlcore.txt       |  45 ------
>> >  .../bindings/net/wireless/ti,wlcore.yaml      | 134 ++++++++++++++++++
>> >  .../boot/dts/motorola-mapphone-common.dtsi    |   2 +-
>> >  arch/arm/boot/dts/omap3-gta04a5.dts           |   2 +-
>> >  7 files changed, 227 insertions(+), 164 deletions(-)
>> >  create mode 100644 Documentation/devicetree/bindings/net/ti,bluetooth.yaml
>> >  delete mode 100644 Documentation/devicetree/bindings/net/ti-bluetooth.txt
>> >  delete mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wlcore,spi.txt
>> >  delete mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wlcore.txt
>> >  create mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wlcore.yaml
>>
>> Via which tree should these go?
>
> The DTS change should go through the OMAP tree.
> The binding changes through the net or DT trees.
>
> I kept everything together for an improved overview.

Good, thanks. I'll then drop these from my queue.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
