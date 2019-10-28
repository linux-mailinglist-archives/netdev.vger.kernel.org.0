Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3E42E7A95
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 21:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388542AbfJ1Uyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 16:54:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44900 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfJ1Uyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 16:54:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F396414B7A8A0;
        Mon, 28 Oct 2019 13:54:38 -0700 (PDT)
Date:   Mon, 28 Oct 2019 13:54:38 -0700 (PDT)
Message-Id: <20191028.135438.2267133222843425996.davem@davemloft.net>
To:     mcroce@redhat.com
Cc:     netdev@vger.kernel.org, antoine.tenart@bootlin.com,
        maxime.chevallier@bootlin.com, mw@semihalf.com,
        stefanc@marvell.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/3] mvpp2 improvements in rx path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191024172458.7956-1-mcroce@redhat.com>
References: <20191024172458.7956-1-mcroce@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 28 Oct 2019 13:54:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@redhat.com>
Date: Thu, 24 Oct 2019 19:24:55 +0200

> Refactor some code in the RX path to allow prefetching some data from the
> packet header. The first patch is only a refactor, the second one
> reduces the data synced, while the third one adds the prefetch.
> 
> The packet rate improvement with the second patch is very small (1606 => 1620 kpps),
> while the prefetch bumps it up by 14%: 1620 => 1853 kpps.

Series applied to net-next, thanks Matteo.
