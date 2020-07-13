Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBBCC21E282
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 23:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgGMVgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 17:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727888AbgGMVgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 17:36:16 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB01C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 14:36:15 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id w17so6093228ply.11
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 14:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=tf3aKP5xFXm+vtojuHJF42JOCJu7ZH0+iBonKIfwMQk=;
        b=jnM2aEhGiWk7atj84BaidjHdFf+1nZzK7lUnzb8/8HhhToIqwLfgB05aDJ0Bjt+vHr
         gxnCMfU8SXCw9J+MVk6tJgjMGosUmfGdNreEhE7u4xYT3Pw7+G7rbesIQzcdkMuzksSH
         0dcXr5L4vCA3WIuCHsCA9XQMoIHF1hvdBs/RQ3tXJq2SDMnWnChKOvD5NSZlW7UqUxn9
         9RfBHL1HRLXqqiHwmBWQkJ3Zy/M1tTTYqQvw6QlPzbm/fXCvyU1GTpwrdoXcI5rMxyCe
         DyySjcDGZpAu+2f5Cb6G7LLIma6qFPGZ4PIInXiRscbQSRtJ49xqfS2jds1TvSBAReYD
         1t0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tf3aKP5xFXm+vtojuHJF42JOCJu7ZH0+iBonKIfwMQk=;
        b=AgljKsZLilWbqGACjZA89OujPlxp9x9Yzh7A0I8RiXs/nGAOrghnSohghJwwWgQSqc
         5vjv10w8ypyCyL3mIAgC6bF73c1v8slxi2OjesznqP7aOSNHIpByAButj/1jITjZGOn9
         IkYvhvwm8n4sGfQRwnAz03aongmXYH0sKba8Tsl+BUHlbZ6149bS5+3/P9I6/y3UD+RW
         fFdPENsS/kLCjIi5oOtdQFRuc2ADeSVNnssWf7avmwPTZ8RpRJU43zhHlFxtpWU+9v/N
         r0LZeWD3rQ1UYqu0e9i7BhIORByvifQwWdQ0/jFVnbc6pU1B56ajI2nrYaFAMryIuBqU
         H2fw==
X-Gm-Message-State: AOAM530EpulAcI7i9HOnS+M2nVZjkSVnbqP+CKk2MwJXUGp/4ZajlEAO
        taTEOfemh+EI27gGo0KVPcFy+Hft
X-Google-Smtp-Source: ABdhPJzWtb9xbMKzxquswbynGv21PBnf0J1asD+yWY0MruMPLpKI2DlawOt9pKTyklkwpz1Zjom88A==
X-Received: by 2002:a17:90b:3c1:: with SMTP id go1mr1297473pjb.129.1594676173098;
        Mon, 13 Jul 2020 14:36:13 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id x13sm9492856pfj.122.2020.07.13.14.36.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2020 14:36:12 -0700 (PDT)
Subject: Re: [RFC] bonding driver terminology change proposal
To:     Jarod Wilson <jarod@redhat.com>, Netdev <netdev@vger.kernel.org>
References: <CAKfmpSdcvFG0UTNJFJgXwNRqQb-mk-PsrM5zQ_nXX=RqaaawgQ@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7fb02008-e469-38b7-735b-6bfb8beab414@gmail.com>
Date:   Mon, 13 Jul 2020 14:36:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CAKfmpSdcvFG0UTNJFJgXwNRqQb-mk-PsrM5zQ_nXX=RqaaawgQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/13/20 11:51 AM, Jarod Wilson wrote:
> As part of an effort to help enact social change, Red Hat is
> committing to efforts to eliminate any problematic terminology from
> any of the software that it ships and supports. Front and center for
> me personally in that effort is the bonding driver's use of the terms
> master and slave, and to a lesser extent, bond and bonding, due to
> bondage being another term for slavery. Most people in computer
> science understand these terms aren't intended to be offensive or
> oppressive, and have well understood meanings in computing, but
> nonetheless, they still present an open wound, and a barrier for
> participation and inclusion to some.
> 
> To start out with, I'd like to attempt to eliminate as much of the use
> of master and slave in the bonding driver as possible. For the most
> part, I think this can be done without breaking UAPI, but may require
> changes to anything accessing bond info via proc or sysfs.
> 
> My initial thought was to rename master to aggregator and slaves to
> ports, but... that gets really messy with the existing 802.3ad bonding
> code using both extensively already. I've given thought to a number of
> other possible combinations, but the one that I'm liking the most is
> master -> bundle and slave -> cable, for a number of reasons. I'd
> considered cable and wire, as a cable is a grouping of individual
> wires, but we're grouping together cables, really -- each bonded
> ethernet interface has a cable connected, so a bundle of cables makes
> sense visually and figuratively. Additionally, it's a swap made easier
> in the codebase by master and bundle and slave and cable having the
> same number of characters, respectively. Granted though, "bundle"
> doesn't suggest "runs the show" the way "master" or something like
> maybe "director" or "parent" does, but those lack the visual aspect
> present with a bundle of cables. Using parent/child could work too
> though, it's perhaps closer to the master/slave terminology currently
> in use as far as literal meaning.
> 
> So... Thoughts?
> 

So you considered : aggregator/ports, bundle/cable.

I thought about cord/strand, since this is less likely to be used already in networking land
(like worker, thread, fiber, or wire ...)

Although a cord with two strands is probably not very common :/

