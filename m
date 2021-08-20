Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3EDB3F26C5
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 08:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238369AbhHTG0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 02:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbhHTG0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 02:26:50 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC1BC061575
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 23:26:12 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id i9so18220233lfg.10
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 23:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=xM/5hg73CAO5nDlUiWnC06sBYRoGEVNZps4ThjEK80g=;
        b=SM1DxTrgTQmc/EbSc5o/ZKIU4t62Dau5mNSp1bsk7iNoKcDtfvVrYZ+dAjdNqwDI4x
         nzZKOWr7tfhFVPyHPSlQURghDVLrbMfgs43M7gPs+0Uio3Cpz2RTkontu83Eb5mqdD3x
         OfK85T0Upyl6y/12E5n1WE0FwhaPhAS68b7KKXmpmZfkRI286LwpC3WlK4agL7LGhxYo
         xeYHLXxFaBRst7J9z64xRfBl0XEtWNcH9VGL5vGE/T6AMbtDcdvXM8PAmExa+LN6S9qr
         5RKsTcMQqfMeaucp4c3MObUiIn8thVESL/Uxh5Vp5kfczH7zxWIx/+QUw3kXePwqCkPM
         meGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=xM/5hg73CAO5nDlUiWnC06sBYRoGEVNZps4ThjEK80g=;
        b=etZ53SWuueHuBBMreslvnGMy0/1X8bdLseex6PRfB9nahuVvwAbV/jF5D30sELrmbS
         Rw+Hl09sjJXElC9ASoym4oJyBPNj2PsjVE+qRPQzRQxxYxhg7gyo8u/Swbla9W+t6w3S
         e0Jh0hAdnQcO/RmYcHLoaE4xd2KvYRMbIFUaLUrBoalSlUFWVXSMRQWerOcp17BROHIe
         L2VDVAHbg8eO8aaGdCiIbMG036dHJkayteSh7FQeYS4c3ccY40JSJfWpvxjn388zHlvV
         5HRBuIw7sYlNyh6AQQdwMwb+nlnJVYQ8GgFg4Sw7QB6ye06EIPlapziSZmLZgRd/cl0a
         cGoQ==
X-Gm-Message-State: AOAM530l8r+gaeuZRqX3qSMGlR0fXzeyK0Z6esS7doD0iiAjBUFO6Msa
        x9V4ORTpcrbsJNfM4YHMV+g=
X-Google-Smtp-Source: ABdhPJygigIOh3nwUm5DE31I2p4oPZ2Dma+yQlZ7L6UHOGLe18iCJvkPJk3AuAOtuy+WJR7ClhlHbw==
X-Received: by 2002:a05:6512:401a:: with SMTP id br26mr9465748lfb.539.1629440771118;
        Thu, 19 Aug 2021 23:26:11 -0700 (PDT)
Received: from wbg (h-155-4-221-58.NA.cust.bahnhof.se. [155.4.221.58])
        by smtp.gmail.com with ESMTPSA id bu31sm529124lfb.153.2021.08.19.23.26.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 23:26:10 -0700 (PDT)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: [PATCH net-next 00/15] net: bridge: multicast: add vlan support
In-Reply-To: <458e3729-0bf0-8c45-9e45-352da76eaeb6@blackwall.org>
References: <20210719170637.435541-1-razor@blackwall.org> <875yw1qv9a.fsf@gmail.com> <458e3729-0bf0-8c45-9e45-352da76eaeb6@blackwall.org>
Date:   Fri, 20 Aug 2021 08:26:09 +0200
Message-ID: <871r6or5ry.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 19, 2021 at 19:22, Nikolay Aleksandrov <razor@blackwall.org> wrote:
> On 19/08/2021 19:01, Joachim Wiberg wrote:
>> On Mon, Jul 19, 2021 at 20:06, Nikolay Aleksandrov <razor@blackwall.org> wrote:
>>> From: Nikolay Aleksandrov <nikolay@nvidia.com>
>> Curious, are you planning querier per-vlan, including use-ifaddr support
>> as well?  In our in-house hack, which I posted a few years ago, we added
>> some "dumpster diving" to inet_select_addr(), but it got rather tricky.
>> So I've been leaning towards having that in userspace instead.
> Yes, that is already supported (use-ifaddr needs attention though). In my next
> patch-set where I added the initial global vlan mcast options I added control
> for per-vlan querier with per-vlan querier elections and so on. The use-ifaddr
> needs more work though, that's why I still haven't added that option. I need
> to add the per-vlan/port router control option so we'll have mostly everything
> ready in a single release.

Wow, OK now we're talking, yeah that would be great to have in place as well!

>>> Future patch-sets which build on this one (in order):
>>>  - iproute2 support for all the new uAPIs
>> I'm very eager to try out all the new IGMP per-VLAN stuff, do you have
>> any branch of the iproute2 support available yet for testing?
> I don't have it public yet because I need to polish the support, currently
> it's very rough, enough for testing purposes for these patch-sets. :)
> I plan to work on that after I finish with the per-vlan/port router control.

Alright, I can appreciate that.  Really looking forward to this, I'll be
patiently waiting here in the wings, testing this out.

Fantastic work with this, again! :)

All the best
 /Joachim
 
