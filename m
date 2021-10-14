Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B793042D745
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 12:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhJNKpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 06:45:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229468AbhJNKpR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 06:45:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A50A561029;
        Thu, 14 Oct 2021 10:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634208193;
        bh=aWMglBh9pGCOmiZ88eOVpvJvmJl3/pOcN/7VDiuqDNU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SgFxRO+6xvvs5vx4lximIeqbNre80UgWO61jBHG29uq9+hp3FdKUOtf3hnfj8t3vN
         3fMS2d15RPSusAQrIolmMnc084ndG+ddTGle9/JPozqJkpZrBw34XcGzXuBPBsGd9N
         yeKiij+uvhRAGUngk2tQYS9UHUOvQrnjvmd2jQmwH012Dy5u6mL0g/j0hzGPw4oQFO
         uaecRUm+jRy5ZfklXzFJG//cU3xo1U8hbSnZbLIORBw3BMlqRiSgiJ1ngVcq012ahW
         eCGa/teKbGSsAI40NV3AMCMB0Me/W9JN/znRwWNjv/HVAJ+248zKhJkkQSjddpy1ZS
         kQCH9WBIoO9JA==
Date:   Thu, 14 Oct 2021 12:43:09 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     devicetree@vger.kernel.org, linux-leds@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, robh+dt@kernel.org,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] dt-bindings: leds: Add `excludes` property
Message-ID: <20211014124309.10b42043@dellmb>
In-Reply-To: <20211014102918.GA21116@duo.ucw.cz>
References: <20211013204424.10961-1-kabel@kernel.org>
        <20211013204424.10961-2-kabel@kernel.org>
        <20211014102918.GA21116@duo.ucw.cz>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Oct 2021 12:29:18 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> > Some RJ-45 connectors have LEDs wired in the following way:
> > 
> >          LED1
> >       +--|>|--+
> >       |       |
> >   A---+--|<|--+---B
> >          LED2
> > 
> > With + on A and - on B, LED1 is ON and LED2 is OFF. Inverting the
> > polarity turns LED1 OFF and LED2 ON.
> > 
> > So these LEDs exclude each other.
> > 
> > Add new `excludes` property to the LED binding. The property is a
> > phandle-array to all the other LEDs that are excluded by this LED.  
> 
> I don't think this belongs to the LED binding.
> 
> This is controller limitation, and the driver handling the controller
> needs to know about it... so it does not need to learn that from the
> LED binding.

It's not necessarily a controller limitation, rather a limitation of
the board (or ethernet connector, in the case of LEDs on an ethernet
connector).

But I guess we could instead document this property in the ethernet PHY
controller binding for a given PHY.

Marek
