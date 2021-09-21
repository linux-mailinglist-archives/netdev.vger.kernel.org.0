Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B923413836
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 19:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbhIURYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 13:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbhIURX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 13:23:59 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8E1C061575
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 10:22:31 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id h3-20020a17090a580300b0019ce70f8243so2480319pji.4
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 10:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6fNJZGTYbWt1FDVZnIfaIJu93NNlXsUhzn7NiJ74lnM=;
        b=qhf+cenA+lpe9kDF+vyCnQ7c5sbyKwJTngsEimzMi/D52L22DkiigHInOtRaAPlWMf
         cAvmCYun4TNv48GKPJymwvwTXiY9Byfbt2d1npSFRgsDiJ3OCUv3UE9BEQHtZM/Iq2tq
         3QD1B1Gufzr1rNvgSnH2TL5wPSS/TPmWs17T+t+HAdwkBr16TJHeodCHil8Md4AcYqnf
         bEYhFYYFKR38OctiQqfhPtkARqXQWFiDwpa+DJ/BUhPEHz6VqObhNhCT9XqlDXW+ZZUs
         7ZclIe3+Vmw3s34X8vQwsUM9SqBeeYiJfuGbndUNKcV8FCzJMwHbPdh2Kf52RYN1GWY9
         YPcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6fNJZGTYbWt1FDVZnIfaIJu93NNlXsUhzn7NiJ74lnM=;
        b=AeKnSK5xUvvxU6ZYK4+USK9ieVqxdIMJPlI7UWzHK9UwhAhX0u8QHHw4OVRsrmpMke
         j8gp5ARHovmMrI10yIabzQUo7wxhy7MRgF6LXnssX2TKEx6sbT/m+5kUVspGaOQA/a9U
         ImCc3DNrBB+3NkdkCn9GrS8qfZiUT2eB/dJZxIROYG1BbdpBOKxOUO4o3FkON6de1JEe
         GsnXQcyl1QSn2HWLXB51ukMPlzkw7qVwYoHCW17+rlu1VMPtDG+DwtSPf6SMYnVTrgX9
         RZRhE/fMqkfwomcZ/TriUwOmMBXb5UnXb2Ci7rJFLV/mwzj8+KpqmdIhWnJKfGXkUyuG
         Veag==
X-Gm-Message-State: AOAM533MIICw3dsPyCkRNMcg7oIvU5ojdTOIW81DU819gPoO13GqJohp
        TLuexFNfwYjLqqdlUJDSuR/ioGQds1GVew==
X-Google-Smtp-Source: ABdhPJzETGP5tm0PmGLvSiHBVB8cgM6jbBQ6Tls2B2ii41RBnOhpxGqqKl4FY+cWU9sBt5fgtyyDrw==
X-Received: by 2002:a17:90a:19d2:: with SMTP id 18mr6506281pjj.217.1632244950547;
        Tue, 21 Sep 2021 10:22:30 -0700 (PDT)
Received: from lattitude ([49.206.117.224])
        by smtp.gmail.com with ESMTPSA id b85sm18769014pfb.0.2021.09.21.10.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 10:22:29 -0700 (PDT)
Date:   Tue, 21 Sep 2021 22:52:04 +0530
From:   Gokul Sivakumar <gokulkumar792@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>, netdev@vger.kernel.org
Subject: Re: [iproute2] concern regarding the color option usage in "bridge"
 & "tc" cmd
Message-ID: <20210921172204.GA96823@lattitude>
References: <20210829094953.GA59211@lattitude>
 <e1cfb620-7c87-ce63-2bb4-6e9b3df0863e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1cfb620-7c87-ce63-2bb4-6e9b3df0863e@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 08:41:01PM -0700, David Ahern wrote:
> On 8/29/21 2:49 AM, Gokul Sivakumar wrote:
> > Hi Stephen, David,
> > 
> > Recently I have added a commit 82149efee9 ("bridge: reorder cmd line arg parsing
> > to let "-c" detected as "color" option") in iproute2 tree bridge.c which aligns
> > the behaviour of the "bridge" cmd with the "bridge" man page description w.r.t
> > the color option usage. Now I have stumbled upon a commit f38e278b8446 ("bridge:
> > make -c match -compressvlans first instead of -color") that was added back in
> > 2018 which says that "there are apps and network interface managers out there
> > that are already using -c to prepresent compressed vlans".
> > 
> > So after finding the commit f38e278b8446, now I think the man page should have
> > fixed instead of changing the bridge.c to align the behaviour of the "bridge" cmd
> > with the man page. Do you think we can revert the bridge.c changes 82149efee9,
> > so that the "bridge" cmd detects "-c" as "-compressedvlans" instead of "-color"?
> > 
> > If we are reverting the commit 82149efee9, then "-c" will be detected as
> > "-compressedvlans" and I will send out a patch to change the "bridge" man page
> > to reflect the new "bridge" cmd behaviour. If we are not reverting the commit
> > 82149efee9, then "-c" will be detected as "-color" and I will send a out a patch
> > to change the "bridge" cmd help menu to reflect the current "bridge" cmd behaviour.
> > Please share your thoughts.
> > 
> > And also regarding the "tc" cmd, in the man/man8/tc.8 man page, the "-c" option
> > is mentioned to be used as a shorthand option for "-color", but instead it is
> > detected as "-conf". So here also, we need to decide between fixing the man page
> > and fixing the "tc" cmd behaviour w.r.t to color option usage.
> > 
> > I understand that "matches()" gives a lot of trouble and I see that you both are
> > now preferring full "strcmp()" over "matches()" for newly added cmd line options.
> > 
> 
> 
> Stephen: This should be reverted for 5.14 release given the change in
> behavior. I will take a wild guess that ifupdown2 is the interface
> manager that will notice.

Thanks David.

Hi Stephen, I see that the iproute2 5.14 got released before reverting the
commit 82149efee9. I would like to bring my concern regarding "the color
option usage" to your notice in case if you have missed this email thread
earlier.

Gokul
