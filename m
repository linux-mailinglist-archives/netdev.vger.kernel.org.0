Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE24C0AC9
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 20:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbfI0SIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 14:08:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34990 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfI0SIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 14:08:51 -0400
Received: from localhost (231-157-167-83.reverse.alphalink.fr [83.167.157.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A3D8E153E6F5B;
        Fri, 27 Sep 2019 11:08:48 -0700 (PDT)
Date:   Fri, 27 Sep 2019 20:08:47 +0200 (CEST)
Message-Id: <20190927.200847.1360645307800189687.davem@davemloft.net>
To:     paulb@mellanox.com
Cc:     pshelar@ovn.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, vladbu@mellanox.com,
        netdev@vger.kernel.org, jiri@resnulli.us, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com, simon.horman@netronome.com, gerlitz.or@gmail.com
Subject: Re: [PATCH net v2] net/sched: Set default of CONFIG_NET_TC_SKB_EXT
 to N
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1569423755-1544-1-git-send-email-paulb@mellanox.com>
References: <1569423755-1544-1-git-send-email-paulb@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Sep 2019 11:08:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>
Date: Wed, 25 Sep 2019 18:02:35 +0300

> This a new feature, it is preferred that it defaults to N.
> We will probe the feature support from userspace before actually using it.
> 
> Fixes: 95a7233c452a ('net: openvswitch: Set OvS recirc_id from tc chain index')
> Signed-off-by: Paul Blakey <paulb@mellanox.com>

Applied.
