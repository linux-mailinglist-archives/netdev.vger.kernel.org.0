Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A729113666
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 21:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbfLDU1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 15:27:30 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36190 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727889AbfLDU1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 15:27:30 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0510C14D6CFD0;
        Wed,  4 Dec 2019 12:27:29 -0800 (PST)
Date:   Wed, 04 Dec 2019 12:27:27 -0800 (PST)
Message-Id: <20191204.122727.891591348848637971.davem@davemloft.net>
To:     sd@queasysnail.net
Cc:     netdev@vger.kernel.org, xiyou.wangcong@gmail.com, xmu@redhat.com
Subject: Re: [PATCH net 0/2] net: convert ipv6_stub to ip6_dst_lookup_flow
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1575458463.git.sd@queasysnail.net>
References: <cover.1575458463.git.sd@queasysnail.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 04 Dec 2019 12:27:30 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>
Date: Wed,  4 Dec 2019 15:35:51 +0100

> Xiumei Mu reported a bug in a VXLAN over IPsec setup:
> 
>   IPv6 | ESP | VXLAN
> 
> Using this setup, packets go out unencrypted, because VXLAN over IPv6
> gets its route from ipv6_stub->ipv6_dst_lookup (in vxlan6_get_route),
> which doesn't perform an XFRM lookup.
> 
> This patchset first makes ip6_dst_lookup_flow suitable for some
> existing users of ipv6_stub->ipv6_dst_lookup by adding a 'net'
> argument, then converts all those users.

Series applied, thanks.
