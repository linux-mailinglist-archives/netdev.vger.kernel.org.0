Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7C014D808
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 09:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgA3I4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 03:56:33 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52394 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbgA3I4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 03:56:33 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9D3B815380173;
        Thu, 30 Jan 2020 00:56:30 -0800 (PST)
Date:   Thu, 30 Jan 2020 09:56:29 +0100 (CET)
Message-Id: <20200130.095629.1691702887527418741.davem@davemloft.net>
To:     geert@linux-m68k.org
Cc:     pabeni@redhat.com, cpaasch@apple.com,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        kuba@kernel.org, netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mptcp: MPTCP_HMAC_TEST should depend on MPTCP
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200129180224.700-1-geert@linux-m68k.org>
References: <20200129180224.700-1-geert@linux-m68k.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Jan 2020 00:56:32 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 29 Jan 2020 19:02:24 +0100

> As the MPTCP HMAC test is integrated into the MPTCP code, it can be
> built only when MPTCP is enabled.  Hence when MPTCP is disabled, asking
> the user if the test code should be enabled is futile.
> 
> Wrap the whole block of MPTCP-specific config options inside a check for
> MPTCP.  While at it, drop the "default n" for MPTCP_HMAC_TEST, as that
> is the default anyway.
> 
> Fixes: 65492c5a6ab5df50 ("mptcp: move from sha1 (v0) to sha256 (v1)")
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied.
