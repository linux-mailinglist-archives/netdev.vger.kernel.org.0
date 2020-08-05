Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E288523D02F
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbgHETbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728951AbgHETbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 15:31:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC004C061575;
        Wed,  5 Aug 2020 12:31:05 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2DB3A152F10F1;
        Wed,  5 Aug 2020 12:14:19 -0700 (PDT)
Date:   Wed, 05 Aug 2020 12:31:03 -0700 (PDT)
Message-Id: <20200805.123103.464522080473075661.davem@davemloft.net>
To:     sbrivio@redhat.com
Cc:     sfr@canb.auug.org.au, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        heiko.carstens@de.ibm.com, xiyou.wangcong@gmail.com
Subject: Re: [PATCH RESEND net-next] ip_tunnel_core: Fix build for archs
 without _HAVE_ARCH_IPV6_CSUM
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200805153931.50a3d518@redhat.com>
References: <20200805153931.50a3d518@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Aug 2020 12:14:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>
Date: Wed, 5 Aug 2020 15:39:31 +0200

> On architectures defining _HAVE_ARCH_IPV6_CSUM, we get
> csum_ipv6_magic() defined by means of arch checksum.h headers. On
> other architectures, we actually need to include net/ip6_checksum.h
> to be able to use it.
> 
> Without this include, building with defconfig breaks at least for
> s390.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Fixes: 4cb47a8644cc ("tunnels: PMTU discovery support for directly bridged IP packets")
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>

Applied, thank you.
