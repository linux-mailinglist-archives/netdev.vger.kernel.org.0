Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A32D429C6E4
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 19:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1823193AbgJ0SZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 14:25:31 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:42821 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1827550AbgJ0SZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 14:25:20 -0400
Received: by mail-lf1-f65.google.com with SMTP id a7so3566999lfk.9
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 11:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=6gFel0DGZErLuumgXyjzK8FxUbLVuOJzCnwS4EDS7qM=;
        b=A0e5oZwImo1f+OHVZFuhbSHuMy7TnmXFOcaZqN/PRNkZiF3dy+boLSKh7Z0cGtyjOd
         AvaWhnn3ylfNi0AanUnkKIYiTCd2ZXM4I0QV/QKbaWDB2Ini5ey7Quv+hhpEXscGNJgg
         TVrck0B74AveBi69Je5YZEsXm8M9/9ipGvvHXQ8rIjabOLTFzpMrWUs/+WOdmbWgVEeG
         wFAdP+QhZfOxSrdA47wR5CocB9xHWhSF0vYZXqdmHglBTvaokSAMj9Tno/pVH5Qw2MqO
         IyLVGqJrDDLoQq1gEjVm2fD+zWjyx/1wuf+KpW6QFs6/DXMxkenU+xtumj54vDo9yrF9
         PzQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=6gFel0DGZErLuumgXyjzK8FxUbLVuOJzCnwS4EDS7qM=;
        b=fEWuDJ2HSykRLm+JnYXQ0sSxYg5JlkfZ6QNJoc3ZsDaQMAlS5WiT7W1PUgwlq5JKwf
         x6VtWe3JVsFRNZdypkZmGXZ110cs0SQax+NYVnbo7307z8TQZdUlI3Rj8pk3/QmQ8Cz9
         piL/Tf+8XQ3S5IsqKxr+jxYPpl6xamkb6v1GQ6kapJ6XV1zkAXc2/KQ56V8xXhJUTXov
         rmzxWmTOtAZoN2pvai+jtjbYY6ZSq3Wq1iA1JE0AZxNFFtQiXfSZeH0U7nyVMRidw4In
         S4aT2tMKveL++pc2JFHJyp3m4/aQtNEfDdkYL8WFnfrnv7W1/2UU+ZwXkdLrCqqFIeKl
         3kXA==
X-Gm-Message-State: AOAM532Vg9yMBM8s02QDBtjtIezS6ffBBijbZh3Dfp5RsIRodwiCEAzm
        jdIBxeXy322jFFi3ZuOt7UaVJX0/OyL8WF6j
X-Google-Smtp-Source: ABdhPJw3oOxFyKHtDNov7NjvxiBEPb+XF+EXFE/HlaHodciXvinIB+9yfsFrOf0fWKqPcBnrws473g==
X-Received: by 2002:ac2:5dea:: with SMTP id z10mr1431872lfq.468.1603823117372;
        Tue, 27 Oct 2020 11:25:17 -0700 (PDT)
Received: from wkz-x280 (h-79-28.A259.priv.bahnhof.se. [79.136.79.28])
        by smtp.gmail.com with ESMTPSA id f24sm254391lfh.73.2020.10.27.11.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 11:25:16 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Andrew Lunn <andrew@lunn.ch>, Marek Behun <marek.behun@nic.cz>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] net: dsa: link aggregation support
In-Reply-To: <20201027152330.GF878328@lunn.ch>
References: <20201027105117.23052-1-tobias@waldekranz.com> <20201027160530.11fc42db@nic.cz> <20201027152330.GF878328@lunn.ch>
Date:   Tue, 27 Oct 2020 19:25:16 +0100
Message-ID: <87k0vbv84z.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 16:23, Andrew Lunn <andrew@lunn.ch> wrote:
> Hi Marek
>
> trunking is something i've looked at once, but never had time to work
> on. There are three different use cases i thought of:
>
> 1) trunk user ports, with team/bonding controlling it
> 2) trunk DSA ports, i.e. the ports between switches in a D in DSA setup
> 3) trunk CPU ports.
>
> What Tobias is implementing here is 1). This seems like a good first
> step.
>
> I'm not sure 3) is even possible. Or it might depend on the switch
> generation. The 6352 for example, the CPU Dest field is a port
> number. It does not appear to allow for a trunk. 6390 moved this
> register, but as far as i know, it did not add trunk support.  It
> might be possible to have multiple SoC interfaces sending frames to
> the Switch using DSA tags, but i don't see a way to have the switch
> send frames to the SoC using multiple ports.

I think that (2) and (3) are essentially the same problem, i.e. creating
LAGs out of DSA links, be they switch-to-switch or switch-to-cpu
connections. I think you are correct that the CPU port can not be a
LAG/trunk, but I believe that limitation only applies to TO_CPU packets.
If the CPU ports configured as a LAG, all FORWARDs, i.e. the bulk
traffic, would benefit from the load-balancing. Something like this:

.-----. TO_CPU, FORWARD .-----. TO_CPU, FORWARD .-----.
|     +-----------------+     +-----------------+     |
| CPU |                 | sw0 |                 | sw1 |
|     +-----------------+     +-----------------+     |
'-----'    FORWARD      '-+-+-'    FORWARD      '-+-+-'
                          | |                     | |
                       swp1 swp2               swp3 swp4

So the links selected as the CPU ports will see a marginally higher load
due to all TO_CPU being sent over it. But the hashing is not that great
on this hardware anyway (DA/SA only) so some imbalance is unavoidable.

In order for this to work on transmit, we need to add forward offloading
to the bridge so that we can, for example, send one FORWARD from the CPU
to send an ARP broadcast to swp1..4 instead of four FROM_CPUs.

	Tobias
