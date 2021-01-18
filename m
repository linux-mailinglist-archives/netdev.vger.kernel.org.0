Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8DF52FA7E1
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 18:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436721AbhARRsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 12:48:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436641AbhARRrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 12:47:53 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81004C061575
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 09:47:12 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id u11so19069273ljo.13
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 09:47:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=BGvLrp2zpy8YcpaIORxg9ulGzs2XDHGn/66fRdpnHhc=;
        b=IY8b4hTJ+gwKmZSUI4/nI0QjvFDdIa1lsimcmvZUS4VwxiLIZPRnQ1nru6WQXbLUaV
         S0/T49NhSPj6nHIlch+hEBmyjuXu9PWzCSEaKDbtFB7xj9y01EyySF03UqBeMvnK9CDE
         rs1C5uLOkarMov13iB8mZPARtTNWV018I6Vc5aMcCsUq1KpFt0fN4R9qT2F112DyVLYT
         Ynny/hLiCVFueKmbWb3tA+ld+jU1NGeROQEN1F9yDHhudlbsrZg7MeIOmb2htmiWcs+S
         w0CnxTmTrR+9H8prF5OdA1c5tSZRBEQmq7KRPwj24N8+r4HM1rCwQ+3N13oNIO524p2e
         uBkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=BGvLrp2zpy8YcpaIORxg9ulGzs2XDHGn/66fRdpnHhc=;
        b=h2hN1XK84P3t8u+9kMB6PLvZ9rZ+gXg4cheJt6MTl1BTp/iVbBMA4Zi6aBw6X1T1sO
         yQBTMOJKazSW1Q5uCAAzI3fS2Ym6zWZdt9HwSWHk1gTSfSMm8Bgjb+Nt3PaGtklJGgr4
         xYmY7H95VINUAFDJJn5s3U5Te/CpwYf4knhEpvC6J0Jg5qtMmPEicR5phNWYrLV2ObY8
         Rc87AeBOdDEkmQvDNgf3FOGLM6Qa1ANHybl7Pt5fQGONq4ViZVVnNLnH+XQbA1jSih2f
         CUJ21ceadOq2aVQHT6PmFw7jvVznCUqm1SlDGKBuTbRWirnhWeTamWCqI+U5diGIewDz
         2hmg==
X-Gm-Message-State: AOAM5332PJ3l5wnwL84wdFtZzHmSIbVJVppDceGDkJ1HxjRvd6opnwiM
        6Zl4MeIDlUmLlNN+X/lUPyhRRj7MYc5u6g==
X-Google-Smtp-Source: ABdhPJxjE5w64D5YhUF49jLTKHlph5y7jfKYG7l3x0NMuLh9D7IqfvG8grUQ6iI9HLeaEE8Vrunqig==
X-Received: by 2002:a2e:85d5:: with SMTP id h21mr306400ljj.182.1610992031050;
        Mon, 18 Jan 2021 09:47:11 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id x186sm1964434lff.76.2021.01.18.09.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 09:47:10 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Chris Healy <cphealy@gmail.com>, Marek Behun <marek.behun@nic.cz>,
        netdev <netdev@vger.kernel.org>
Subject: Re: bug: net: dsa: mv88e6xxx: serdes Unable to communicate on fiber with vf610-zii-dev-rev-c
In-Reply-To: <YAXILTCNepv8eZnj@lunn.ch>
References: <CAFXsbZodM0W87aH=qeZCRDSwyNOAXwF=aO8zf1UpkhwNkSAczA@mail.gmail.com> <20200718164239.40ded692@nic.cz> <CAFXsbZoMcOQTY8HE+E359jT6Vsod3LiovTODpjndHKzhTBZcTg@mail.gmail.com> <20200718150514.GC1375379@lunn.ch> <20200718172244.59576938@nic.cz> <CAFXsbZrHRexg5zAsR1cah4p8HAZVc3tjKdMGKWO6Ha4jXux3QA@mail.gmail.com> <8735yykv88.fsf@waldekranz.com> <YAXILTCNepv8eZnj@lunn.ch>
Date:   Mon, 18 Jan 2021 18:47:10 +0100
Message-ID: <87zh16jfxd.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 18, 2021 at 18:41, Andrew Lunn <andrew@lunn.ch> wrote:
> On Mon, Jan 18, 2021 at 06:31:19PM +0100, Tobias Waldekranz wrote:
>> On Sun, Jul 19, 2020 at 14:43, Chris Healy <cphealy@gmail.com> wrote:
>> > On Sat, Jul 18, 2020 at 8:22 AM Marek Behun <marek.behun@nic.cz> wrote:
>> >>
>> >> On Sat, 18 Jul 2020 17:05:14 +0200
>> >> Andrew Lunn <andrew@lunn.ch> wrote:
>> >>
>> >> > > If the traces were broken between the fiber module and the SERDES, I
>> >> > > should not see these counters incrementing.
>> >> >
>> >> > Plus it is reproducible on multiple boards, of different designs.
>> >> >
>> >> > This is somehow specific to the 6390X ports 9 and 10.
>> >> >
>> >> >      Andrew
>> >>
>> >> Hmm.
>> >>
>> >> What about the errata setup?
>> >> It says:
>> >> /* The 6390 copper ports have an errata which require poking magic
>> >>  * values into undocumented hidden registers and then performing a
>> >>  * software reset.
>> >>  */
>> >> But then the port_hidden_write function is called for every port in the
>> >> function mv88e6390_setup_errata, not just for copper ports. Maybe Chris
>> >> should try to not write this hidden register for SerDes ports.
>> >
>> > I just disabled the mv88e6390_setup_errata all together and this did
>> > not result in any different behaviour on this broken fiber port.
>> 
>> Hi Chris,
>> 
>> Did you manage to track this down?
>> 
>> I am seeing the exact same issue. I have tried both a 1000base-x SFP and
>> a copper 1000base-T and get the same result on both - transmit is fine
>> but rx only works up to the SERDES, no rx MAC counters are moving.
>
> Hi Tobias
>
> We never tracked this down. I spent many hours bashing my head against
> this. I could not bisect it, which did not help.

Well that is disheartening :) "I could not bisect it", does that mean
that it did work at some point but your CPU platform was not supported
far enough back, or has it never worked?

> FYI: Chris has moved onto a new job, and is unlikely to be involved
> with Marvell switches any more.

Good to know, thanks.
