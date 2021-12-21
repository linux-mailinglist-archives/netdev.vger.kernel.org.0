Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28DF447C3C6
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 17:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239407AbhLUQ2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 11:28:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232746AbhLUQ2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 11:28:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D57C061574;
        Tue, 21 Dec 2021 08:28:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 726AE61688;
        Tue, 21 Dec 2021 16:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F4AC36AE9;
        Tue, 21 Dec 2021 16:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640104114;
        bh=nN4AHR3OkqAY7NOiMkBeo+hddknNIcMQ8QywF/aa76g=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=bc6mUS8RQv6q9L0CJA7/vZsM8uA1wd5crSSm9cMrYVbRKmHDAHle0eGji83fIltBp
         hsylPpODCtiiVBZc4lSKjdpETl/OmAvuEq3V9+To7LYNZD2wYCN1LSfn3RFA4+7KZY
         FaXJYpdKZ6BwUiTLKVGDCjqlltkA28I63BfdOjOXoizZYmLmpoEUGC99ihQBp32J0A
         WnxiHGx7VbgFdZD7XMKx92000oCpkvHY35I3hwQF8il2GdZaKea1ft1KCDqKGPlXsY
         2ngEf56EaWNpzVyCWYknqLM4sxzqCsuSC+1DUJmcqkh1hB8mk4r1OviPpnUCot20S2
         UaWBjGYqiJ2VQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     David Mosberger-Tang <davidm@egauge.net>
Cc:     Rob Herring <robh@kernel.org>,
        Ajay Singh <ajay.kathat@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Adham Abozaeid <adham.abozaeid@microchip.com>
Subject: Re: [PATCH v6 2/2] wilc1000: Document enable-gpios and reset-gpios properties
References: <20211220180334.3990693-1-davidm@egauge.net>
        <20211220180334.3990693-3-davidm@egauge.net>
        <YcHu8qkzguAPZcKx@robh.at.kernel.org>
        <5f4ab50b4773effafd0a43c8c541d49621f78980.camel@egauge.net>
Date:   Tue, 21 Dec 2021 18:28:30 +0200
In-Reply-To: <5f4ab50b4773effafd0a43c8c541d49621f78980.camel@egauge.net>
        (David Mosberger-Tang's message of "Tue, 21 Dec 2021 09:06:48 -0700")
Message-ID: <87a6gt53dd.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Mosberger-Tang <davidm@egauge.net> writes:

> On Tue, 2021-12-21 at 11:12 -0400, Rob Herring wrote:
>> On Mon, 20 Dec 2021 18:03:38 +0000, David Mosberger-Tang wrote:
>> > Add documentation for the ENABLE and RESET GPIOs that may be needed
>> > by
>> > wilc1000-spi.
>> > 
>> > Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
>> > ---
>> >  .../net/wireless/microchip,wilc1000.yaml      | 19
>> > +++++++++++++++++++
>> >  1 file changed, 19 insertions(+)
>> > 
>> 
>> Please add Acked-by/Reviewed-by tags when posting new versions. 
>
> Ah, sorry about that.
>
>> However,
>> there's no need to repost patches *only* to add the tags. The
>> upstream
>> maintainer will do that for acks received on the version they apply.
>> 
>> If a tag was not added on purpose, please state why and what changed.
>
> Not on purpose.  I just didn't know how this is handled.

No worries, we have a lot of special rules :) I'll add Rob's tag from v5
when I commit the patch.

Actually, I'm lazy and patchwork can pick it up automatically:

Reviewed-by: Rob Herring <robh@kernel.org>

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
