Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1CA31553E
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 18:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233274AbhBIRie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 12:38:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233280AbhBIRg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 12:36:57 -0500
Received: from smtpout-55.fbg1.glesys.net (smtpout-52.fbg1.glesys.net [IPv6:2a02:751:100:2::52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCCFC061793
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 09:36:16 -0800 (PST)
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
        by mail-halon-02.fbg1.glesys.net (Halon) with ESMTPSA
        id 4c26b8b6-6afd-11eb-969d-ebc997f73d07;
        Tue, 09 Feb 2021 18:36:13 +0100 (CET)
Received: by mail-qt1-f171.google.com with SMTP id n28so6539020qtv.12
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 09:36:13 -0800 (PST)
X-Gm-Message-State: AOAM5302cDq1HpgRQst7mmVjYkRqashJsjycZxybALADNBgqE8HXhelx
        J6Ig6nUg/N23GCWup98MQPgLrHoNiXSqo91dYcQ=
X-Google-Smtp-Source: ABdhPJxZmD2cCa6eoOBN+6e315kQ/YxzNEDOTN+gB6LMvvYRQu5UbWDbjn72ome1YaVrgNku7XLpvwPX+J+I+V73Ysc=
X-Received: by 2002:ac8:548d:: with SMTP id h13mr11594351qtq.315.1612892169722;
 Tue, 09 Feb 2021 09:36:09 -0800 (PST)
MIME-Version: 1.0
From:   Anton Hvornum <anton@hvornum.se>
Date:   Tue, 9 Feb 2021 18:35:54 +0100
X-Gmail-Original-Message-ID: <CAG2iS6oP+8JG=wCueFuE3HwPsnpnkqxhUx8Br84AnL+AoLi1KQ@mail.gmail.com>
Message-ID: <CAG2iS6oP+8JG=wCueFuE3HwPsnpnkqxhUx8Br84AnL+AoLi1KQ@mail.gmail.com>
Subject: Request for feature: force carrier up/on flag
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi.

I am a bit new to ethtool, kernel drivers and all the surrounding aspects.
I also recognize that my use case is of low priority and a bit niche,
but any response would be greatly appreciated.

I'm modifying an existing Intel driver, and I'm looking for a way to
integrate/add another ethtool hook to force call `netif_carrier_on`.
There's plenty of hooks/listeners (not clear as to what you call
these) between the Intel driver and ethtool via C API's today that
allows for ethtool to control the driver. Many of which are for speed,
autonegotiation etc. But I don't see any flags/functions to force a
carrier state to up.

This would be very useful for many reasons, primarily on fiber optic
setups where you are developing hardware such as switches, routers and
even developing network cards. Or if you've got a passive device such
as IDS or something similar that passively monitors network traffic
and can't/shouldn't send out link requests.
There are commercial products with modified drivers that support this,
but since the Intel hardware in this case seems to support it - just
that there's no way controlling it with the tools that exist today. I
would therefore request a feature for consideration to ethtool that
can force carrier states up/down.

A intuitive option I think would be:
ethtool --change carrier on

Assuming that drivers follow suit and allow this. But a first step
would be for the tools to support it in the API so drivers have
something to call/listen for. In the meantime, I can probably
integrate a private flag and go that route, but that feels hacky and
won't foster driver developers to follow suit. My goal is to empower
more open source alternatives to otherwise expensive commercials
solutions.

Best wishes,
Anton Hvornum
