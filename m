Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5D631273B
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 20:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbhBGTjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 14:39:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbhBGTjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 14:39:02 -0500
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 935A7C06174A;
        Sun,  7 Feb 2021 11:38:22 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id C480CCC0171;
        Sun,  7 Feb 2021 20:38:20 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Sun,  7 Feb 2021 20:38:18 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 8FD05CC0119;
        Sun,  7 Feb 2021 20:38:18 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 4A4C4340D5D; Sun,  7 Feb 2021 20:38:18 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id 45855340D5C;
        Sun,  7 Feb 2021 20:38:18 +0100 (CET)
Date:   Sun, 7 Feb 2021 20:38:18 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
X-X-Sender: kadlec@blackhole.kfki.hu
To:     Reindl Harald <h.reindl@thelounge.net>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net 1/4] netfilter: xt_recent: Fix attempt to update
 deleted entry
In-Reply-To: <3018f068-62b1-6dae-2dde-39d1a62fbcb2@thelounge.net>
Message-ID: <alpine.DEB.2.23.453.2102072036220.16338@blackhole.kfki.hu>
References: <20210205001727.2125-1-pablo@netfilter.org> <20210205001727.2125-2-pablo@netfilter.org> <69957353-7fe0-9faa-4ddd-1ac44d5386a5@thelounge.net> <alpine.DEB.2.23.453.2102051448220.10405@blackhole.kfki.hu> <a51d867a-3ca9-fd36-528a-353aa6c42f42@thelounge.net>
 <3018f068-62b1-6dae-2dde-39d1a62fbcb2@thelounge.net>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 7 Feb 2021, Reindl Harald wrote:

> > well, the most important thing is that the firewall-vm stops to 
> > kernel-panic
> 
> why is that still not part of 5.10.14 given how old that issue is :-(
> 
> https://cdn.kernel.org/pub/linux/kernel/v5.x/ChangeLog-5.10.14

Probably we missed the window when patches were accepted for the new 
release. That's all.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
