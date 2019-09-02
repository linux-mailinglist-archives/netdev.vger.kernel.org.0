Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46655A5C5D
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 20:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfIBSpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 14:45:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35552 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbfIBSpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 14:45:03 -0400
Received: from localhost (unknown [63.64.162.234])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6AA7215404841;
        Mon,  2 Sep 2019 11:45:02 -0700 (PDT)
Date:   Mon, 02 Sep 2019 11:45:01 -0700 (PDT)
Message-Id: <20190902.114501.908712630459133289.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, saeedm@mellanox.com, leon@kernel.org,
        roid@mellanox.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v2] mlx5: Add missing init_net check in FIB
 notifier
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190830082530.8958-1-jiri@resnulli.us>
References: <20190830082530.8958-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 02 Sep 2019 11:45:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Fri, 30 Aug 2019 10:25:30 +0200

> From: Jiri Pirko <jiri@mellanox.com>
> 
> Take only FIB events that are happening in init_net into account. No other
> namespaces are supported.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> ---
> v1->v2:
> - no change, just cced maintainers (fat finger made me avoid them in v1)

Applied, thanks Jiri.
