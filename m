Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726C62FA799
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 18:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407080AbhARRcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 12:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393558AbhARRcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 12:32:02 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2293C061573
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 09:31:21 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id b10so19053373ljp.6
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 09:31:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=kI3z0Zw7DyWlwtRQaoanL8tWTNAqXdnl6uhydQ5oE5Y=;
        b=QxMkdudxh1udFbgCl5IU19pXNeW7+ji9wYeF0sYsx1htbXNpWytHQhY3qUfU9r5oQj
         j2Aa3HhToobvU4CrYUMvuzOF1MUsYg9HR4tJArK4Y7V4EztWt6VEYJfgTZKunctK/QKl
         3y3IWvfjtRxqdZ/X5xU8N/gYJImUtiGVanPjDzmv9WmECz1KtzUoHI5FnMgHhv6AZ42Q
         HU38WlBlSgwLMqVU0ZMh6EGiIT7xKSa7ujOB2rjjUorxT9TdvXqxKwOSemcNCSuM29V1
         KZJhIoJx/j+iHjxDySqkDGRuNTTout+wUhyuRfhwgC/u/VDWeWUesrkI12JD1YbQmRdp
         VbdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=kI3z0Zw7DyWlwtRQaoanL8tWTNAqXdnl6uhydQ5oE5Y=;
        b=hlZBGz5NrDtDJILYlN+YbAtevPFPiDem9liu2KHnPGBezCnfbTXV1axBoZJiXOFlfr
         XVmYdGHfZ3M3nfn1myeEJYtZV5SPpPkcdqt1hJwZv3Aow/ik4nE0DrbR2clJL3AZO8/V
         MAFinuR/YVp/pFh8c/4s+rg256/E1DaxWDU+cYUyn8JAUxSIp7GK1jh847eDfpKG2Lld
         KPUTNX/g/OV72v8ZvL5yfBATg829GrTVe8nwfQdJKo1Bu8irJFlE+P+lXTtrM1tpS70S
         7F6xdyFPcLFfxqlU93mhKDR++tl64kRY9hHOM8XOr+e9pnJdypm1zIdgM8R5atGBbXCc
         B4Sg==
X-Gm-Message-State: AOAM532GJVav4cMlsCak8Z8KoOiefT5DRsZRQNhld2QPXHNKQZdu70Oa
        soe3nn9hsYuQl4yuPuoNS2TARIoJFaSjOA==
X-Google-Smtp-Source: ABdhPJxi1Fw8dIqPwjFceWbRMUINvna96d+3D40hy2YWrJ+ln7qjeF2icEGJolfBdsaVCl1ePY/kJA==
X-Received: by 2002:a2e:b0c3:: with SMTP id g3mr288261ljl.57.1610991080375;
        Mon, 18 Jan 2021 09:31:20 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id g69sm1961539lfd.161.2021.01.18.09.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 09:31:19 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Chris Healy <cphealy@gmail.com>, Marek Behun <marek.behun@nic.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>
Subject: Re: bug: net: dsa: mv88e6xxx: serdes Unable to communicate on fiber with vf610-zii-dev-rev-c
In-Reply-To: <CAFXsbZrHRexg5zAsR1cah4p8HAZVc3tjKdMGKWO6Ha4jXux3QA@mail.gmail.com>
References: <CAFXsbZodM0W87aH=qeZCRDSwyNOAXwF=aO8zf1UpkhwNkSAczA@mail.gmail.com> <20200718164239.40ded692@nic.cz> <CAFXsbZoMcOQTY8HE+E359jT6Vsod3LiovTODpjndHKzhTBZcTg@mail.gmail.com> <20200718150514.GC1375379@lunn.ch> <20200718172244.59576938@nic.cz> <CAFXsbZrHRexg5zAsR1cah4p8HAZVc3tjKdMGKWO6Ha4jXux3QA@mail.gmail.com>
Date:   Mon, 18 Jan 2021 18:31:19 +0100
Message-ID: <8735yykv88.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 19, 2020 at 14:43, Chris Healy <cphealy@gmail.com> wrote:
> On Sat, Jul 18, 2020 at 8:22 AM Marek Behun <marek.behun@nic.cz> wrote:
>>
>> On Sat, 18 Jul 2020 17:05:14 +0200
>> Andrew Lunn <andrew@lunn.ch> wrote:
>>
>> > > If the traces were broken between the fiber module and the SERDES, I
>> > > should not see these counters incrementing.
>> >
>> > Plus it is reproducible on multiple boards, of different designs.
>> >
>> > This is somehow specific to the 6390X ports 9 and 10.
>> >
>> >      Andrew
>>
>> Hmm.
>>
>> What about the errata setup?
>> It says:
>> /* The 6390 copper ports have an errata which require poking magic
>>  * values into undocumented hidden registers and then performing a
>>  * software reset.
>>  */
>> But then the port_hidden_write function is called for every port in the
>> function mv88e6390_setup_errata, not just for copper ports. Maybe Chris
>> should try to not write this hidden register for SerDes ports.
>
> I just disabled the mv88e6390_setup_errata all together and this did
> not result in any different behaviour on this broken fiber port.

Hi Chris,

Did you manage to track this down?

I am seeing the exact same issue. I have tried both a 1000base-x SFP and
a copper 1000base-T and get the same result on both - transmit is fine
but rx only works up to the SERDES, no rx MAC counters are moving.
