Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD28E219417
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 01:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgGHXJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 19:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbgGHXJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 19:09:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E220BC061A0B;
        Wed,  8 Jul 2020 16:09:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7E0FD12780FED;
        Wed,  8 Jul 2020 16:09:26 -0700 (PDT)
Date:   Wed, 08 Jul 2020 16:09:25 -0700 (PDT)
Message-Id: <20200708.160925.601637997950999733.davem@davemloft.net>
To:     jarod@redhat.com
Cc:     linux-kernel@vger.kernel.org,
        syzbot+582c98032903dcc04816@syzkaller.appspotmail.com,
        huyn@mellanox.com, saeedm@mellanox.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jeffrey.t.kirsher@intel.com,
        kuba@kernel.org, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next] bonding: don't need RTNL for ipsec helpers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200708225849.25198-1-jarod@redhat.com>
References: <20200708225849.25198-1-jarod@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jul 2020 16:09:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jarod Wilson <jarod@redhat.com>
Date: Wed,  8 Jul 2020 18:58:49 -0400

> The bond_ipsec_* helpers don't need RTNL, and can potentially get called
> without it being held, so switch from rtnl_dereference() to
> rcu_dereference() to access bond struct data.
> 
> Lightly tested with xfrm bonding, no problems found, should address the
> syzkaller bug referenced below.
> 
> Reported-by: syzbot+582c98032903dcc04816@syzkaller.appspotmail.com
> Signed-off-by: Jarod Wilson <jarod@redhat.com>

Applied, thank you.
