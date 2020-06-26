Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908B120BD0B
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 01:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgFZXJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 19:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgFZXJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 19:09:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15CA5C03E979
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 16:09:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A17911275150C;
        Fri, 26 Jun 2020 16:09:18 -0700 (PDT)
Date:   Fri, 26 Jun 2020 16:09:04 -0700 (PDT)
Message-Id: <20200626.160904.1659419582967743181.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/8] net: organize driver docs by device type
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200626172731.280133-1-kuba@kernel.org>
References: <20200626172731.280133-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 26 Jun 2020 16:09:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Fri, 26 Jun 2020 10:27:23 -0700

> This series finishes off what I started in
> commit b255e500c8dc ("net: documentation: build a directory structure for drivers").
> The objective is to de-clutter our documentation folder so folks
> have a chance of finding relevant info. I _think_ I got all the
> driver docs from the main documentation directory this time around.
> 
> While doing this I realized that many of them are of limited relevance
> these days, so I went ahead and sliced the drivers directory by
> technology. Those feeling nostalgic are free to dive into the FDDI,
> ATM etc. docs, but for most Ethernet is what we care about.
> 
> v1:
>  - simplify Intel's docs list in MAINTAINERS.

Series applied, thanks Jakub.
