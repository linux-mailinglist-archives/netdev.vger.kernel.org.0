Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C755E1305A8
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 05:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgAEEH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jan 2020 23:07:26 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50534 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbgAEEHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jan 2020 23:07:25 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 24F8F159E7DBE;
        Sat,  4 Jan 2020 20:07:25 -0800 (PST)
Date:   Sat, 04 Jan 2020 20:07:22 -0800 (PST)
Message-Id: <20200104.200722.625603214153899073.davem@davemloft.net>
To:     Jason@zx2c4.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] WireGuard bug fixes and cleanups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAHmME9pMPPmuHz-Cxi9e1UDThwQey8n1e3QJ2ic1ZxzjJZPP5Q@mail.gmail.com>
References: <20200102164751.416922-1-Jason@zx2c4.com>
        <CAHmME9pMPPmuHz-Cxi9e1UDThwQey8n1e3QJ2ic1ZxzjJZPP5Q@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 04 Jan 2020 20:07:25 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Sat, 4 Jan 2020 22:04:33 -0500

> I think this might have gotten lost in the post-New Years onslaught of
> patches that have been coming your way in the last few days. So, just
> a friendly poke.

Check patchwork, you never need to "poke" me.
