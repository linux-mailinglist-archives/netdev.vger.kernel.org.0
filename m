Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E684E476B77
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 09:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234736AbhLPIKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 03:10:55 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47314 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbhLPIKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 03:10:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DC1261C7B;
        Thu, 16 Dec 2021 08:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292D4C36AE4;
        Thu, 16 Dec 2021 08:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639642253;
        bh=Fiuiji4pBps1Qhzw2rF+T8tIH7RQWsYMKKFFg9hAkhU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Gl/W8pqQC9hHrV3lyvkZNRB1fsMwdtqfByHWRUxs3offZnX9HkW9ix+xx6ysO/gWy
         wPC7NNyeP0HUSgME17YSCbAhH0omxZFUM1cPqYMppb5NnhG5yM3VbbRKk+Tb20e7hz
         3Z03W0/aITkhiAwaDDi6Z06eaovzCiG5lFRC135ylXigYFdlvSWdMFGkZNqVkvFvGN
         EOCFvkJDw8I9W5dwbRc0lQPutnuynFyWxJWVWaVzKRxrNNowabAY1rHSniYxcMf4Zf
         F4A3IAxWfo7app/bZJBodo8wbfa+eSpJcB+vAmuzf2/M0va8GWTv2EhFO/s9eiFQUA
         wS8JvziTwn5UQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     David Mosberger-Tang <davidm@egauge.net>
Cc:     Claudiu.Beznea@microchip.com, Ajay.Kathat@microchip.com,
        adham.abozaeid@microchip.com, davem@davemloft.net,
        devicetree@vger.kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, robh+dt@kernel.org
Subject: Re: [PATCH v5 1/2] wilc1000: Add reset/enable GPIO support to SPI driver
References: <20211215030501.3779911-1-davidm@egauge.net>
        <20211215030501.3779911-2-davidm@egauge.net>
        <d55a2558-b05d-5995-b0f0-f234cb3b50aa@microchip.com>
        <9cfbcc99f8a70ba2c03a9ad99f273f12e237e09f.camel@egauge.net>
Date:   Thu, 16 Dec 2021 10:10:48 +0200
In-Reply-To: <9cfbcc99f8a70ba2c03a9ad99f273f12e237e09f.camel@egauge.net>
        (David Mosberger-Tang's message of "Wed, 15 Dec 2021 07:59:05 -0700")
Message-ID: <87zgp1c6lz.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Mosberger-Tang <davidm@egauge.net> writes:

>> > +       } else {
>> > +               gpiod_set_value(gpios->reset, 1);       /* assert RESET */
>> > +               gpiod_set_value(gpios->enable, 0);      /* deassert ENABLE */
>> 
>> I don't usually see comments near the code line in kernel. Maybe move them
>> before the actual code line or remove them at all as the code is impler enough?
>
> You're kidding, right?

I agree with Claudiu, the comments are not really providing more
information from what can be seen from the code. And the style of having
the comment in the same line is not commonly used in upstream.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
