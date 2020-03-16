Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10B2A18752F
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 22:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732719AbgCPVz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 17:55:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48408 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732636AbgCPVz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 17:55:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 731FA156B95AC;
        Mon, 16 Mar 2020 14:55:55 -0700 (PDT)
Date:   Mon, 16 Mar 2020 14:55:52 -0700 (PDT)
Message-Id: <20200316.145552.114479252418690423.davem@davemloft.net>
To:     petrm@mellanox.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, mrv@mojatatu.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [PATCH net-next v2 0/6] RED: Introduce an ECN tail-dropping
 mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <878sk0y3gk.fsf@mellanox.com>
References: <20200311173356.38181-1-petrm@mellanox.com>
        <20200314.210402.573725635566592048.davem@davemloft.net>
        <878sk0y3gk.fsf@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Mar 2020 14:55:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>
Date: Mon, 16 Mar 2020 11:54:51 +0100

> Dave, there were v3 and v4 for this patchset as well. They had a
> different subject, s/taildrop/nodrop/, hence the confusion I think.
> Should I send a delta patch with just the changes, or do you want to
> revert-and-reapply, or...?

I prefer deltas, thank you.
