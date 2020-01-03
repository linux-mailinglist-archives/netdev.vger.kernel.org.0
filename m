Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1361312FE19
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 21:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgACUpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 15:45:18 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48042 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727848AbgACUpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 15:45:18 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9A5F5158BFE2F;
        Fri,  3 Jan 2020 12:45:17 -0800 (PST)
Date:   Fri, 03 Jan 2020 12:45:17 -0800 (PST)
Message-Id: <20200103.124517.1721098411789807467.davem@davemloft.net>
To:     tom@herbertland.com
Cc:     ahabdels.dev@gmail.com, netdev@vger.kernel.org,
        simon.horman@netronome.com, willemdebruijn.kernel@gmail.com
Subject: Re: [PATCH v8 net-next 0/9] ipv6: Extension header infrastructure
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CALx6S361vkhp8rLzP804oMz2reuDgQDjm9G_+eXfq5oQpVscyg@mail.gmail.com>
References: <CALx6S37uWDOgWqx_8B0YunQZRGCyjeBY_TLczxmKZySDK4CteA@mail.gmail.com>
        <20200103081147.8c27b18aec79bb1cd8ad1a1f@gmail.com>
        <CALx6S361vkhp8rLzP804oMz2reuDgQDjm9G_+eXfq5oQpVscyg@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 Jan 2020 12:45:17 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Herbert <tom@herbertland.com>
Date: Fri, 3 Jan 2020 09:35:08 -0800

> The real way to combat this provide open implementation that
> demonstrates the correct use of the protocols and show that's more
> extensible and secure than these "hacks".

Keep dreaming, this won't stop Cisco from doing whatever it wants to do.
