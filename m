Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1148BF26CD
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 06:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbfKGFRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 00:17:13 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33672 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbfKGFRN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 00:17:13 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EAFFD1510CDF8;
        Wed,  6 Nov 2019 21:17:12 -0800 (PST)
Date:   Wed, 06 Nov 2019 21:17:12 -0800 (PST)
Message-Id: <20191106.211712.663655987109482181.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/9] Netfilter fixes for net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191106111237.3183-1-pablo@netfilter.org>
References: <20191106111237.3183-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Nov 2019 21:17:13 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Wed,  6 Nov 2019 12:12:28 +0100

> The following patchset contains Netfilter fixes for net:
> 
> 1) Missing register size validation in bitwise and cmp offloads.
> 
> 2) Fix error code in ip_set_sockfn_get() when copy_to_user() fails,
>    from Dan Carpenter.
> 
> 3) Oneliner to copy MAC address in IPv6 hash:ip,mac sets, from
>    Stefano Brivio.
> 
> 4) Missing policy validation in ipset with NL_VALIDATE_STRICT,
>    from Jozsef Kadlecsik.
> 
> 5) Fix unaligned access to private data area of nf_tables instructions,
>    from Lukas Wunner.
> 
> 6) Relax check for object updates, reported as a regression by
>    Eric Garver, patch from Fernando Fernandez Mancera.
> 
> 7) Crash on ebtables dnat extension when used from the output path.
>    From Florian Westphal.
> 
> 8) Fix bogus EOPNOTSUPP when updating basechain flags.
> 
> 9) Fix bogus EBUSY when updating a basechain that is already offloaded.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks Pablo.
