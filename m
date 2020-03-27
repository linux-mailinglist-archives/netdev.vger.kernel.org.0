Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17047194ED7
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 03:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbgC0CU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 22:20:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57434 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727495AbgC0CUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 22:20:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 18DBA15CE4DF2;
        Thu, 26 Mar 2020 19:20:55 -0700 (PDT)
Date:   Thu, 26 Mar 2020 19:20:52 -0700 (PDT)
Message-Id: <20200326.192052.575550840173150215.davem@davemloft.net>
To:     petrm@mellanox.com
Cc:     netdev@vger.kernel.org, idosch@mellanox.com, jiri@mellanox.com,
        alexpe@mellanox.com
Subject: Re: [PATCH net-next 0/3] Implement stats_update callback for pedit
 and skbedit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1585255467.git.petrm@mellanox.com>
References: <cover.1585255467.git.petrm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Mar 2020 19:20:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>
Date: Thu, 26 Mar 2020 22:45:54 +0200

> The stats_update callback is used for adding HW counters to the SW ones.
> Both skbedit and pedit actions are actually recognized by flow_offload.h,
> but do not implement these callbacks. As a consequence, the reported values
> are only the SW ones, even where there is a HW counter available.
> 
> Patch #1 adds the callback to action skbedit, patch #2 adds it to action
> pedit. Patch #3 tweaks an skbedit selftest with a check that would have
> caught this problem.
> 
> The pedit test is not likewise tweaked, because the iproute2 pedit action
> currently does not support JSON dumping. This will be addressed later.

Series applied, thanks Petr.
