Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6CEAF9A4F
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 21:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbfKLUMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 15:12:14 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48946 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbfKLUMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 15:12:09 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8A7F9154D250E;
        Tue, 12 Nov 2019 12:12:08 -0800 (PST)
Date:   Mon, 11 Nov 2019 14:44:08 -0800 (PST)
Message-Id: <20191111.144408.866345901632784244.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, tgraf@suug.ch,
        jbenc@redhat.com
Subject: Re: [PATCH net-next] lwtunnel: ignore any TUNNEL_OPTIONS_PRESENT
 flags set by users
From:   David Miller <davem@davemloft.net>
In-Reply-To: <8f830b0757f1c24aaebe19c771f274913174d6a5.1573359981.git.lucien.xin@gmail.com>
References: <8f830b0757f1c24aaebe19c771f274913174d6a5.1573359981.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Nov 2019 12:12:08 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 10 Nov 2019 12:26:21 +0800

> TUNNEL_OPTIONS_PRESENT (TUNNEL_GENEVE_OPT|TUNNEL_VXLAN_OPT|
> TUNNEL_ERSPAN_OPT) flags should be set only according to
> tb[LWTUNNEL_IP_OPTS], which is done in ip_tun_parse_opts().
> 
> When setting info key.tun_flags, the TUNNEL_OPTIONS_PRESENT
> bits in tb[LWTUNNEL_IP(6)_FLAGS] passed from users should
> be ignored.
> 
> While at it, replace all (TUNNEL_GENEVE_OPT|TUNNEL_VXLAN_OPT|
> TUNNEL_ERSPAN_OPT) with 'TUNNEL_OPTIONS_PRESENT'.
> 
> Fixes: 3093fbe7ff4b ("route: Per route IP tunnel metadata via lightweight tunnel")
> Fixes: 32a2b002ce61 ("ipv6: route: per route IP tunnel metadata via lightweight tunnel")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
