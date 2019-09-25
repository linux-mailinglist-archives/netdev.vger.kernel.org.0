Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1C9DBDFDF
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 16:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730636AbfIYORl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 10:17:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36260 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727078AbfIYORl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 10:17:41 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CEBC7154F586D;
        Wed, 25 Sep 2019 07:17:38 -0700 (PDT)
Date:   Wed, 25 Sep 2019 16:17:36 +0200 (CEST)
Message-Id: <20190925.161736.1762079756836895920.davem@davemloft.net>
To:     paulb@mellanox.com
Cc:     pshelar@ovn.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, vladbu@mellanox.com,
        netdev@vger.kernel.org, jiri@resnulli.us, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com, simon.horman@netronome.com, gerlitz.or@gmail.com
Subject: Re: [PATCH net-next] net/sched: Set default of
 CONFIG_NET_TC_SKB_EXT to N
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1569414509-22445-1-git-send-email-paulb@mellanox.com>
References: <1569414509-22445-1-git-send-email-paulb@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Sep 2019 07:17:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>
Date: Wed, 25 Sep 2019 15:28:29 +0300

> This a new feature, it is preferred that it defaults to N.
> We will probe the feature support from userspace before actually using it.
> 
> Fixes: 95a7233c452a ('net: openvswitch: Set OvS recirc_id from tc chain index')
> Signed-off-by: Paul Blakey <paulb@mellanox.com>

net-next is not an appropriate target tree
