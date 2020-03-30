Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48EF9198200
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 19:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729089AbgC3RPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 13:15:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39780 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729012AbgC3RPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 13:15:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C3C4815BDE727;
        Mon, 30 Mar 2020 10:15:14 -0700 (PDT)
Date:   Mon, 30 Mar 2020 10:15:14 -0700 (PDT)
Message-Id: <20200330.101514.2008477908593683891.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [pull request][net-next 0/4] Mellanox, mlx5 updates-2020-03-29
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200330.101425.961059775247403424.davem@davemloft.net>
References: <20200330071655.169823-1-saeedm@mellanox.com>
        <20200330.101425.961059775247403424.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Mar 2020 10:15:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Mon, 30 Mar 2020 10:14:25 -0700 (PDT)

> I'll pull this, but even before that I'm now getting these warnings in
> my tree so if you'd correct them I'd apprecite it.

Ignore this, they are mlxsw warnings not mlx5 ones :-)
