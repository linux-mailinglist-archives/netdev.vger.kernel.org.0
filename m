Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7123509A6
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 23:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232672AbhCaVjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 17:39:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39828 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbhCaVjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 17:39:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 4BD5D4D25BD70;
        Wed, 31 Mar 2021 14:38:59 -0700 (PDT)
Date:   Wed, 31 Mar 2021 14:38:55 -0700 (PDT)
Message-Id: <20210331.143855.2005036124197875041.davem@davemloft.net>
To:     edumazet@google.com
Cc:     eric.dumazet@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net-next] ip6_tunnel: sit: proper dev_{hold|put} in
 ndo_[un]init methods
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CANn89i+YuMR6DuNk8YFZvHavxRCSNRp8MpC=rWz75N0CtN82DQ@mail.gmail.com>
References: <20210330064551.545964-1-eric.dumazet@gmail.com>
        <CANn89i+YuMR6DuNk8YFZvHavxRCSNRp8MpC=rWz75N0CtN82DQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 31 Mar 2021 14:38:59 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 31 Mar 2021 08:00:24 +0200

> Can you merge this patch so that I can send my global fix for fallback
> tunnels, with a correct Fixes: tag for this patch ?

Done.
