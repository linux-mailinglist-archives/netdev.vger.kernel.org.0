Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE3CE1786A5
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 00:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbgCCXoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 18:44:04 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37178 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728023AbgCCXoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 18:44:04 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DA8F215AA8100;
        Tue,  3 Mar 2020 15:44:03 -0800 (PST)
Date:   Tue, 03 Mar 2020 15:44:03 -0800 (PST)
Message-Id: <20200303.154403.2134473467599378075.davem@davemloft.net>
To:     paulb@mellanox.com
Cc:     saeedm@mellanox.com, ozsh@mellanox.com,
        jakub.kicinski@netronome.com, vladbu@mellanox.com,
        netdev@vger.kernel.org, jiri@mellanox.com, roid@mellanox.com
Subject: Re: [PATCH net-next v5 0/3] act_ct: Software offload of
 conntrack_in
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1583245281-25999-1-git-send-email-paulb@mellanox.com>
References: <1583245281-25999-1-git-send-email-paulb@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Mar 2020 15:44:04 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Ugh, so I see that I applied v4 and even this v5 is going to have some
follow-up changes.

I can revert v4 from net-next, or let you just build fixup patches
against the current tree.

Let me know how you want me to resolve this, sorry.
