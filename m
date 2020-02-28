Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B16C1740A4
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 21:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgB1UBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 15:01:51 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55714 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbgB1UBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 15:01:51 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D1274159742F2;
        Fri, 28 Feb 2020 12:01:50 -0800 (PST)
Date:   Fri, 28 Feb 2020 12:01:50 -0800 (PST)
Message-Id: <20200228.120150.302053489768447737.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     kyk.segfault@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net: Make skb_segment not to compute checksum if
 network controller supports checksumming
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CA+FuTSfaTYB0p1yBuJK4226D-vjhhO_-zN3PUFKFdvyKVT5JdA@mail.gmail.com>
References: <CA+FuTSe8VKTMO9CA2F-oNvZLbtfMqhyf+ZjruXbqz_WTrj-F1A@mail.gmail.com>
        <CABGOaVRF9D21--aFi6VJ9MWMn0GxR-s8PssXnzbEjSneafbh5A@mail.gmail.com>
        <CA+FuTSfaTYB0p1yBuJK4226D-vjhhO_-zN3PUFKFdvyKVT5JdA@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 28 Feb 2020 12:01:51 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Fri, 28 Feb 2020 09:30:56 -0500

> Can you contrast this against a run with your changes? The thought is
> that the majority of this cost is due to the memory loads and stores, not
> the arithmetic ops to compute the checksum. When enabling checksum
> offload, the same stalls will occur, but will simply be attributed to
> memcpy instead of to do_csum.

Agreed.
