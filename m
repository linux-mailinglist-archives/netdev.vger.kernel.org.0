Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED78942ABC8
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 20:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbhJLSVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 14:21:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:43202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232502AbhJLSVX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 14:21:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EB3360D07;
        Tue, 12 Oct 2021 18:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634062761;
        bh=7geCBcQxNYfw3HDTy7+xtj+I5CJqP+USU3KpuOBXvmE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eqpT56fd60qzGryyjuqoO2Zjag05V20VSaL43P7XJpNv58jUDRuU9pZC9SZqvTFdN
         j1jRd8vuQrloSt6PnrygAuT0qJ0QkDsKlb1rlzmZsggPmjKPlttvml5X8ecaCtYclm
         bfDyUE3AK+7RnnLNyWv+EujkDK6QA9cjD1Vy+HI3BxIBbxTZKOYz5931sgjyvopEzm
         x+Z5C0V4i3A/u2F8cknfycNsZsCbUXmB507rBon7Rd+ysrjeuuOjwQXDFMB58tMMu3
         y0TwkOO/TIhdIuH7g2+RR/CoRrTVKeyLAcTyvp2hi4jNjr2kAQvjum6GORKfJPqQsP
         IuB1ti4LO+0Ww==
Date:   Tue, 12 Oct 2021 11:19:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: Re: [PATCH net-next v3 00/14] Add functional support for Gigabit
 Ethernet driver
Message-ID: <20211012111920.1f3886b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211012163613.30030-1-biju.das.jz@bp.renesas.com>
References: <20211012163613.30030-1-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Oct 2021 17:35:59 +0100 Biju Das wrote:
> set_feature patch will send as separate RFC patch along with rx_checksum
> patch, as it needs further discussion related to HW checksum.

Is this part relating to the crash you observed because of TCP csum
offload?

I'm trying to understand the situation before and after this series.
What makes the crash possible to trigger?
