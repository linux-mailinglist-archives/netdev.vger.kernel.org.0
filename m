Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24B7D12FDDA
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 21:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbgACUXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 15:23:48 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46514 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727221AbgACUXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 15:23:48 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 73B9115976311;
        Fri,  3 Jan 2020 12:23:47 -0800 (PST)
Date:   Fri, 03 Jan 2020 12:23:47 -0800 (PST)
Message-Id: <20200103.122347.601753673262850200.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net] selftests: loopback.sh: skip this test if the
 driver does not support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200103074124.30369-1-liuhangbin@gmail.com>
References: <20200103074124.30369-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 Jan 2020 12:23:47 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Fri,  3 Jan 2020 15:41:24 +0800

> The loopback feature is only supported on a few drivers like broadcom,
> mellanox, etc. The default veth driver has not supported it yet. To avoid
> returning failed and making the runner feel confused, let's just skip
> the test on drivers that not support loopback.
> 
> Fixes: ad11340994d5 ("selftests: Add loopback test")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Applied, thanks.
