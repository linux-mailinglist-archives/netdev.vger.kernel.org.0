Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADEDBF233
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 13:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfIZLzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 07:55:16 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:43557 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfIZLzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 07:55:14 -0400
Received: by mail-yb1-f195.google.com with SMTP id y204so596299yby.10;
        Thu, 26 Sep 2019 04:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+HkFg/R+Th5vUTZD7bWbocNnmhAgTliB8YPalzjGoDQ=;
        b=JELLo2vmXqR42xoRQQB/WTCyciiRcm6x/OhbFf7XRKFx8bzV6rjkonbkzuKx8ekQO0
         l/8lLMDhpTjR52Vw0FBq6ZWs7Peo1IhKT5K0vH+IVVx/jcpytZPoxOenGS0dXqeC8JK8
         HJkTtPjvtowYdksjO6YVWy8cbaxWYe5IoD/NRXxqCyjM6X9Jdk1J/woy6LcZ6CtS0gFx
         /cc3vFyxJGh58dRXqW5waWSMNgfhwh3b+XDFtHuQQ9dKM+86OPZ4wQa1EoNd/d73AOy4
         6XN0ZPj93cxBcdAiZBrUluuCtWQl6WE8712RyNCMgOMA2VDyNj3iVExShcZ6qBl0kHaY
         PuWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+HkFg/R+Th5vUTZD7bWbocNnmhAgTliB8YPalzjGoDQ=;
        b=ooZjxkku+/dTu3RlcHV8EjjuDh//tVjwIsFiPDWIun82P9qCKY+o7mAS4SDZYPCYDX
         iVepBNRAiF81z4y1UZ8kwY3fg7lv8CuDCpqgYeWZOJzRvmpZ1Iy7MTlcGc0HaWamRPN9
         Bq5BS1vvS/IaPVZ0cVv5DugP6UabC1nAhL+ZQboEclb0xgkaRYyLA1y1vPakZaYvN2U/
         b2gA5NNPyaI0ugGQwIhoSax+Zx/4fdBuzYN9F5md2NSr4LQMHdne63GfRsqA88HpNoA1
         0T48CAsUr+dtRfBrNShvAp876oRMRABjUaUn9JtGErpG4w9tFyvrOqw/daCphYz38D8w
         S6Xw==
X-Gm-Message-State: APjAAAVd0Sxf1BZTCB2i5UtnubHfFt6rnT3TRud/EbEAx9UGWtgS1/ZN
        9yTMpOcRw706Si7/gRZCEY4EUWWl3sgX0ShOn2TWrXJK
X-Google-Smtp-Source: APXvYqzDq1+J6uPKwSnR0YZ7ruh5+OAN6lhbWq+iG1lLg1cYEsLECfvs0ykUXFlFQGXc7w+TIteNwROUSckkkwXRv5E=
X-Received: by 2002:a5b:4d:: with SMTP id e13mr1737275ybp.455.1569498912048;
 Thu, 26 Sep 2019 04:55:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190920133708.15313-1-zajec5@gmail.com> <20190920140143.GA30514@w1.fi>
In-Reply-To: <20190920140143.GA30514@w1.fi>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date:   Thu, 26 Sep 2019 13:55:00 +0200
Message-ID: <CACna6rwi6ZmE5-zJvP1X8homzMGkdVfAcMWpciW6-G645odSYA@mail.gmail.com>
Subject: Re: [PATCH RFC] cfg80211: add new command for reporting wiphy crashes
To:     Jouni Malinen <j@w1.fi>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        wpa_supplicant <hostap@lists.infradead.org>,
        OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resending from my subscribed e-mail

On 20.09.2019 16:01, Jouni Malinen wrote:
> On Fri, Sep 20, 2019 at 03:37:08PM +0200, Rafa=C5=82 Mi=C5=82ecki wrote:
>> Hardware or firmware instability may result in unusable wiphy. In such
>> cases usually a hardware reset is needed. To allow a full recovery
>> kernel has to indicate problem to the user space.
>
> Why? Shouldn't the driver be able to handle this on its own since all
> the previous configuration was done through the driver anyway. As far as
> I know, there are drivers that do indeed try to do this and handle it
> successfully at least for station mode. AP mode may be more complex, but
> for that one, I guess it would be fine to drop all associations (and
> provide indication of that to user space) and just restart the BSS.

Indeed my main concert is AP mode. I'm afraid that cfg80211 doesn't
cache all settings, consider e.g. nl80211_start_ap(). It builds
struct cfg80211_ap_settings using info from nl80211 message and
passes it to the driver (rdev_start_ap()). Once it's done it
caches only a small subset of all setup data.

In other words driver doesn't have enough info to recover interfaces
setup.


>> This new nl80211 command lets user space known wiphy has crashed and has
>> been just recovered. When applicable it should result in supplicant or
>> authenticator reconfiguring all interfaces.
>
> For me, that is not really "recovered" if some additional
> reconfiguration steps are needed.. I'd like to get a more detailed view
> on what exactly might need to be reconfigured and how would user space
> know what exactly to do. Or would the plan here be that the driver would
> not even indicate this crash if it is actually able to internally
> recover fully from the firmware restart?

I meant that hardware has been recovered & is operational again (driver
can talk to it). I expected user space to reconfigure all interfaces
using the same settings that were used on previous run.

If driver were able to recover interfaces setup on its own (with a help
of cfg80211) then user space wouldn't need to be involved.


>> I'd like to use this new cfg80211_crash_report() in brcmfmac after a
>> successful recovery from a FullMAC firmware crash.
>>
>> Later on I'd like to modify hostapd to reconfigure wiphy using a
>> previously used setup.
>
> So this implies that at least something would need to happen in AP mode.
> Do you have a list of items that the driver cannot do on its own and why
> it would be better to do them from user space?

First of all I was wondering how to handle interfaces creation. After a
firmware crash we have:
1) Interfaces created in Linux
2) No corresponsing interfaces in firmware

Syncing that (re-creating in-firmware firmwares) may be a bit tricky
depending on a driver and hardware. For some cases it could be easier to
delete all interfaces and ask user space to setup wiphy (create required
interfaces) again. I'm not sure if that's acceptable though?

If we agree interfaces should stay and driver simply should configure
firmware properly, then we need all data as explained earlier. struct
cfg80211_ap_settings is not available during runtime. How should we
handle that problem?


>> I'm OpenWrt developer & user and I got annoyed by my devices not auto
>> recovering after various failures. There are things I cannot fix (hw
>> failures or closed fw crashes) but I still expect my devices to get
>> back to operational state as soon as possible on their own.
>
> I fully agree with the auto recovery being important thing to cover for
> this, but I'm not yet convinced that this needs user space action. Or if
> it does, there would need to be more detailed way of indicating what
> exactly is needed for user space to do. The proposed change here is just
> saying "hey, I crashed and did something to get the hardware/firmware
> responding again" which does not really tell much to user space other
> than potentially requiring full disable + re-enable for the related
> interfaces. And that is something that should not actually be done in
> all cases of firmware crashes since there are drivers that handle
> recovery in a manner that is in practice completely transparent to user
> space.

I was aiming for a brutal force solution: just make user space
interfaces need a full setup just at they were just created.
