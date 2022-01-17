Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66D4B491219
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 00:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234685AbiAQXCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 18:02:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiAQXCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 18:02:20 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED5EC061574;
        Mon, 17 Jan 2022 15:02:19 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id q9-20020a7bce89000000b00349e697f2fbso1501320wmj.0;
        Mon, 17 Jan 2022 15:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2RnGSQ02/RpmYLSQxk4nsoT5sgfNdq/mzwgcygCLAqk=;
        b=Uf7pQayo8b/IbRISkFplBnqRhooTsRsticeSWAPommr/ZIArOVRzB1WU9oQp96fGf+
         s2FxPGqsjE2G1zKntqhRt8awJzzYOgFyLHn7aAQJloMBVHNVzAkCbckRqxA963l1ekLS
         8VwuiKwE1lH5wIHDvDx0zUvEf5qvGp1NtdXq3dA8p2VMKb/N15oc4zJaJ0ItLPYjpa7D
         FCpuuyoTOz/v/PepjgCdqzLzwPekDGuuSchIBhVQ59UqVHzJr5ZqBx81o5FK0vuy5+s3
         6Q6HWsF+uxsPXhf7uehZXKdZA7/GbCNAT443sVSkPySre/4AevQLVQt/IJZmei2Fpcyl
         pBOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2RnGSQ02/RpmYLSQxk4nsoT5sgfNdq/mzwgcygCLAqk=;
        b=UejticVqThRIPFKdXA60druOCqYl/oTsPWkVdIbR53AH4MhyVL6YphCDvNK182pOjU
         MubJSDFhI24D8I7ztEu7RCdah41CvKbEG+ORPGhT3h6kAw9idtx7vW7lw3539QGf+ITf
         Fug0oAZpwD4soO8B9SXr5p1i+2BlFbMo40OnJLbaAT9HToXg01JLigYOoBeowpHyl1vo
         Cz4oOFyvNp358klAO6banvOQmv5nw6PqwsAak+hgCi2zgwRmn+qqUpua2RA5+/A1qExZ
         97jXnVWInkniQL1CwHtizWwYp9zse9HyBtlZRwdb03oIyUaBFShapuV7uGyYM81wQSIX
         IhZg==
X-Gm-Message-State: AOAM532VE20ZElQhxJQDG4f1kgmiMbzVzMGUAQJh3ZiQ2M9pypG38qjt
        idu3AEKNkrZJKw2tRW3XkDOI3+Bisw37ES+4KuY=
X-Google-Smtp-Source: ABdhPJzg7Pb0dPUP/0Ku3weDJPwDLtuChDuBQnsnA0ujbPmwtao/Q7HAEHaGPGqe3KC3vths3FZqEB+DBAO++PeivC8=
X-Received: by 2002:a1c:ed01:: with SMTP id l1mr29886282wmh.185.1642460537613;
 Mon, 17 Jan 2022 15:02:17 -0800 (PST)
MIME-Version: 1.0
References: <20220117115440.60296-1-miquel.raynal@bootlin.com>
In-Reply-To: <20220117115440.60296-1-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Mon, 17 Jan 2022 18:02:06 -0500
Message-ID: <CAB_54W4q9a1MRdfK6yJHMRt+Zfapn0ggie9RbbUYi4=Biefz_A@mail.gmail.com>
Subject: Re: [PATCH v3 00/41] IEEE 802.15.4 scan support
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, 17 Jan 2022 at 06:54, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hello,
>
>         *** TLDR ***
>
> Here is a series attempting to bring support for scans in the
> IEEE 802.15.4 stack. A number of improvements had to be made, including:
> * a better handling of the symbol durations
> * a few changes in Kconfig
> * a better handling of the tx queues
> * a synchronous Tx API
>
> Active and passive scans can be locally tested only with hwsim.
>
> Sorry for the big series, might be split in the near future.
>
>         ************
>
> A second series aligning the tooling with these changes is related,
> bringing support for a number of new features such as:
>
> * Sending (or stopping) beacons. Intervals ranging from 0 to 14 are
>   valid for passively sending beacons at regular intervals. An interval
>   of 15 would request the core to answer to received BEACON_REQ.
>   # iwpan dev wpan0 beacons send interval 2 # send BEACON at a fixed rate
>   # iwpan dev wpan0 beacons send interval 15 # answer BEACON_REQ only
>   # iwpan dev wpan0 beacons stop # apply to both cases
>
> * Scanning all the channels or only a subset:
>   # iwpan dev wpan1 scan type passive duration 3 # will not trigger BEACON_REQ
>   # iwpan dev wpan1 scan type active duration 3 # will trigger BEACON_REQ
>
> * If a beacon is received during a scan, the internal PAN list is
>   updated and can be dumped, flushed and configured with:
>   # iwpan dev wpan1 pans dump
>   PAN 0xffff (on wpan1)
>       coordinator 0x2efefdd4cdbf9330
>       page 0
>       channel 13
>       superframe spec. 0xcf22
>       LQI 0
>       seen 7156ms ago
>   # iwpan dev wpan1 pans flush
>   # iwpan dev wpan1 set max_pan_entries 100
>   # iwpan dev wpan1 set pans_expiration 3600
>
> * It is also possible to monitor the events with:
>   # iwpan event
>
> * As well as triggering a non blocking scan:
>   # iwpan dev wpan1 scan trigger type passive duration 3
>   # iwpan dev wpan1 scan done
>   # iwpan dev wpan1 scan abort
>
> The PAN list gets automatically updated by dropping the expired PANs
> each time the user requests access to the list.
>
> Internally, both requests (scan/beacons) are handled periodically by
> delayed workqueues when relevant.
>
> So far the only technical point that is missing in this series is the
> possibility to grab a reference over the module driving the net device
> in order to prevent module unloading during a scan or when the beacons
> work is ongoing.
>
> Finally, this series is a deep reshuffle of David Girault's original
> work, hence the fact that he is almost systematically credited, either
> by being the only author when I created the patches based on his changes
> with almost no modification, or with a Co-developped-by tag whenever the
> final code base is significantly different than his first proposal while
> still being greatly inspired from it.
>

can you please split this patch series, what I see is now:

1. cleanup patches
2. sync tx handling for mlme commands
3. scan support

we try to bring the patches upstream in this order.

Thanks.

- Alex
