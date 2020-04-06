Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1427F19FC68
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 20:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgDFSEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 14:04:15 -0400
Received: from mail-wm1-f49.google.com ([209.85.128.49]:50910 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgDFSEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 14:04:14 -0400
Received: by mail-wm1-f49.google.com with SMTP id x25so358976wmc.0
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 11:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eMrcu1lUf8Ybh2ME+7QFfXehbRdvRyBXcKLe3Wj1Wuo=;
        b=L34/nM47mtKqqxBFLr6Vr1legN7Ys34Eg61QxdGR6Mw5KkIRsnjjlvAm2bXodGWFmv
         c5GUBlWHQNMlqW6Ydb2v4D28nn3lr+LyARAfj1OVLeevD0hL1VBbuqgHX83MIz47oz+J
         viKME/sWyt15EEV9xiRE403npYMlSyvZRAL8IvsDDT1zdFnOzmK+gs1MF+JnWtWSa2ZJ
         V73HKe3guLtrN3CFoHY/gfot1jvQBFNvyyOJ6QcOr3cuWWpwaEapOuwMUAUe5FnlYiNH
         E33/NgbQd/y+qLf8oLjj7Y9DL+dby6tZS0dKaAKvwPN530JTgh42i2hI88Kp/YXDW4/z
         +BBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eMrcu1lUf8Ybh2ME+7QFfXehbRdvRyBXcKLe3Wj1Wuo=;
        b=rfr5NSE7JCOBrba4y6LiN9W3VHGbOhgAWxBA2U/Wp+IArz291mGyCVNqRoxR17C95s
         NUCJG/MgNng/4eTcJHax7mqfA8azn/nL6pas3aaGtuiKdg5dsiMpgyLeWndxMI5FAs5J
         vvHNaJgPlX1P7oOJk4WMIUCYVyqpiYo6cFSKUwVzxrtoJvQt4X5vvs2t6W5JnGG7KQdH
         jvcGggGeGYYLVHm/9N+PaGiiws+nkHGCCIThZ0jWwKsWZq9fBv2NuFteXvnUQLt8Da7X
         osRcwL/pXDkG9J1CJs4gD7gf0HMXvJmYAYouQY0WM17oPZVPk61SBm3BKbWKe16R6uds
         YZbA==
X-Gm-Message-State: AGi0PuZYcpa5Nup8gIxyKyRIC1QnkdH560y6L2ZNB0U4I8DKaVwmCBEZ
        RxSMrn6SEDoJADLPGDNgYesUbgHDOfE=
X-Google-Smtp-Source: APiQypJH/83lHogCja5Rdf8CH5O3juIARYeM4IldC7pVqPa7WE2cb3DaHRawoEMf5RcvpWcz8zA7og==
X-Received: by 2002:a1c:b144:: with SMTP id a65mr279500wmf.54.1586196252793;
        Mon, 06 Apr 2020 11:04:12 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id q11sm434701wme.0.2020.04.06.11.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 11:04:11 -0700 (PDT)
Date:   Mon, 6 Apr 2020 20:04:10 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: Changing devlink port flavor dynamically for DSA
Message-ID: <20200406180410.GB2354@nanopsycho.orion>
References: <ef16b5bb-4115-e540-0ffd-1531e5982612@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef16b5bb-4115-e540-0ffd-1531e5982612@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Apr 05, 2020 at 10:42:29PM CEST, f.fainelli@gmail.com wrote:
>Hi all,
>
>On a BCM7278 system, we have two ports of the switch: 5 and 8, that
>connect to separate Ethernet MACs that the host/CPU can control. In
>premise they are both interchangeable because the switch supports
>configuring the management port to be either 5 or 8 and the Ethernet
>MACs are two identical instances.
>
>The Ethernet MACs are scheduled differently across the memory controller
>(they have different bandwidth and priority allocations) so it is
>desirable to select an Ethernet MAC capable of sustaining bandwidth and
>latency for host networking. Our current (in the downstream kernel) use
>case is to expose port 5 solely as a control end-point to the user and
>leave it to the user how they wish to use the Ethernet MAC behind port
>5. Some customers use it to bridge Wi-Fi traffic, some simply keep it
>disabled. Port 5 of that switch does not make use of Broadcom tags in
>that case, since ARL-based forwarding works just fine.
>
>The current Device Tree representation that we have for that system
>makes it possible for either port to be elected as the CPU port from a
>DSA perspective as they both have an "ethernet" phandle property that
>points to the appropriate Ethernet MAC node, because of that the DSA
>framework treats them as CPU ports.
>
>My current line of thinking is to permit a port to be configured as
>either "cpu" or "user" flavor and do that through devlink. This can
>create some challenges but hopefully this also paves the way for finally
>supporting "multi-CPU port" configurations. I am thinking something like
>this would be how I would like it to be configured:
>
># First configure port 8 as the new CPU port
>devlink port set pci/0000:01:00.0/8 type cpu
># Now unmap port 5 from being a CPU port
>devlink port set pci/0000:01:00.0/1 type eth

You are mixing "type" and "flavour".

Flavours: cpu/physical. I guess that is what you wanted to set, correct?

I'm not sure, it would make sense. The CPU port is still CPU port, it is
just not used. You can never make is really "physical", am I correct? 


btw, we already implement port "type" setting. To "eth" and "ib". This
is how you can change the type of fabric for mlx4 driver.


>
>and this would do a simple "swap" of all user ports being now associated
>with port 8, and no longer with port 5, thus permitting port 5 from
>becoming a standard user port. Or maybe, we need to do this as an atomic
>operation in order to avoid a switch being configured with no CPU port
>anymore, so something like this instead:
>
>devlink port set pci/0000:01:00.0/5 type eth mgmt pci/0000:01:00.0/8
>
>The latter could also be used to define groups of ports within a switch
>that has multiple CPU ports, e.g.:
>
># Ports 1 through 4 "bound" to CPU port 5:
>
>for i in $(seq 0 3)
>do
>	devlink port set pci/0000:01:00.0/$i type eth mgmt pci/0000:01:00.0/5
>done
>
># Ports 7 bound to CPU port 8:
>
>devlink port set pci/0000:01:00.0/1 type eth mgmt pci/0000:01:00.0/8

It is basically a mapping of physical port to CPU port, isn't it?

How about something like?
devlink port set pci/0000:01:00.0/1 cpu_master pci/0000:01:00.0/5
devlink port set pci/0000:01:00.0/2 cpu_master pci/0000:01:00.0/5
devlink port set pci/0000:01:00.0/7 cpu_master pci/0000:01:00.0/8

If CPU port would have 0 mapped ports, it would mean it is disabled.
What do you think?


>
>Let me know what you think!
>
>Thanks
>-- 
>Florian
