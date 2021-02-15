Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D04D31B592
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 08:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbhBOHXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 02:23:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbhBOHXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 02:23:05 -0500
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944DCC061574;
        Sun, 14 Feb 2021 23:22:25 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id E70B76740155;
        Mon, 15 Feb 2021 08:21:11 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Mon, 15 Feb 2021 08:21:09 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp0.kfki.hu (Postfix) with ESMTP id A2ADA6740151;
        Mon, 15 Feb 2021 08:21:09 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 725A7340D5D; Mon, 15 Feb 2021 08:21:09 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id 6EA3A340D5C;
        Mon, 15 Feb 2021 08:21:09 +0100 (CET)
Date:   Mon, 15 Feb 2021 08:21:09 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Reindl Harald <h.reindl@thelounge.net>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net 1/4] netfilter: xt_recent: Fix attempt to update
 deleted entry
In-Reply-To: <303fdd83-a324-5d0c-b45e-9584ea0c9cd5@thelounge.net>
Message-ID: <a4ae43e-d1ec-6b14-6544-ee1f6f1a49f@netfilter.org>
References: <20210205001727.2125-1-pablo@netfilter.org> <20210205001727.2125-2-pablo@netfilter.org> <69957353-7fe0-9faa-4ddd-1ac44d5386a5@thelounge.net> <alpine.DEB.2.23.453.2102051448220.10405@blackhole.kfki.hu> <a51d867a-3ca9-fd36-528a-353aa6c42f42@thelounge.net>
 <3018f068-62b1-6dae-2dde-39d1a62fbcb2@thelounge.net> <alpine.DEB.2.23.453.2102072036220.16338@blackhole.kfki.hu> <303fdd83-a324-5d0c-b45e-9584ea0c9cd5@thelounge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Feb 2021, Reindl Harald wrote:

> > > why is that still not part of 5.10.14 given how old that issue is 
> > > 
> > > https://cdn.kernel.org/pub/linux/kernel/v5.x/ChangeLog-5.10.14
> > 
> > Probably we missed the window when patches were accepted for the new
> > release. That's all
> 
> probably something is broken in the whole process given that 5.10.15 still
> don't contain the fix while i am tired of a new "stable release" every few
> days and 5.10.x like every LTS release in the past few years has a peak of it
> 
> https://cdn.kernel.org/pub/linux/kernel/v5.x/ChangeLog-5.10.15

The process is a multi-step one: netfilter patches are sent for 
reviewing/accepting/rejecting to the net maintaners, and after that they 
send the patches to the kernel source maintainers. A single patch is 
rarely picked out to handle differently.

The patch has entered the queue for the stable trees.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
