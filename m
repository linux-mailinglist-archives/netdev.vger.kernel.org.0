Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 171DEC8D68
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 17:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbfJBPw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 11:52:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33206 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729058AbfJBPw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 11:52:26 -0400
Received: from localhost (unknown [172.58.43.221])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7844914D67515;
        Wed,  2 Oct 2019 08:52:23 -0700 (PDT)
Date:   Wed, 02 Oct 2019 11:52:19 -0400 (EDT)
Message-Id: <20191002.115219.1233859945590634038.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, idosch@mellanox.com, pabeni@redhat.com,
        edumazet@google.com, petrm@mellanox.com, sd@queasysnail.net,
        f.fainelli@gmail.com, stephen@networkplumber.org,
        mlxsw@mellanox.com
Subject: Re: [patch net-next 0/3] net: introduce per-netns netdevice
 notifiers and use them in mlxsw
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190930081511.26915-1-jiri@resnulli.us>
References: <20190930081511.26915-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 02 Oct 2019 08:52:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Mon, 30 Sep 2019 10:15:08 +0200

> From: Jiri Pirko <jiri@mellanox.com>
> 
> Some drivers, like mlxsw, are not interested in notifications coming in
> for netdevices from other network namespaces. So introduce per-netns
> notifiers and allow to reduce overhead by listening only for
> notifications from the same netns.
> 
> This is also a preparation for upcoming patchset "devlink: allow devlink
> instances to change network namespace". This resolves deadlock during
> reload mlxsw into initial netns made possible by
> 328fbe747ad4 ("net: Close race between {un, }register_netdevice_notifier() and setup_net()/cleanup_net()").

Series applied.
