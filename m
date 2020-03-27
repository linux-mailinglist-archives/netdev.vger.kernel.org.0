Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABC35194F83
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 04:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgC0DGX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 26 Mar 2020 23:06:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57884 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgC0DGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 23:06:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2AA1E15CDF073;
        Thu, 26 Mar 2020 20:06:22 -0700 (PDT)
Date:   Thu, 26 Mar 2020 20:06:21 -0700 (PDT)
Message-Id: <20200326.200621.1074393855940705004.davem@davemloft.net>
To:     zenczykowski@gmail.com
Cc:     maze@google.com, netdev@vger.kernel.org, ek@google.com,
        furry@google.com, lorenzo@google.com, mharo@google.com
Subject: Re: [PATCH] net-ipv6-ndisc: add support for 'PREF64' dns64 prefix
 identifier
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200324011019.248392-1-zenczykowski@gmail.com>
References: <20200324011019.248392-1-zenczykowski@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Mar 2020 20:06:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej ¯enczykowski <zenczykowski@gmail.com>
Date: Mon, 23 Mar 2020 18:10:19 -0700

> From: Maciej ¯enczykowski <maze@google.com>
> 
> This is trivial since we already have support for the entirely
> identical (from the kernel's point of view) RDNSS, DNSSL, etc. that
> also contain opaque data that needs to be passed down to userspace
> for further processing.
> 
> As specified in draft-ietf-6man-ra-pref64-09 (while it is still a draft,
> it is purely waiting on the RFC Editor for cleanups and publishing):
>   PREF64 option contains lifetime and a (up to) 96-bit IPv6 prefix.
> 
> The 8-bit identifier of the option type as assigned by the IANA is 38.
> 
> Since we lack DNS64/NAT64/CLAT support in kernel at the moment,
> thus this option should also be passed on to userland.
> 
> See:
>   https://tools.ietf.org/html/draft-ietf-6man-ra-pref64-09
>   https://www.iana.org/assignments/icmpv6-parameters/icmpv6-parameters.xhtml#icmpv6-parameters-5
> 
> Cc: Erik Kline <ek@google.com>
> Cc: Jen Linkova <furry@google.com>
> Cc: Lorenzo Colitti <lorenzo@google.com>
> Cc: Michael Haro <mharo@google.com>
> Signed-off-by: Maciej ¯enczykowski <maze@google.com>

Applied to net-next.
