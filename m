Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A172B141D95
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 12:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgASLbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 06:31:17 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47380 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbgASLbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 06:31:16 -0500
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4E18514C823D9;
        Sun, 19 Jan 2020 03:31:15 -0800 (PST)
Date:   Fri, 17 Jan 2020 04:13:32 -0800 (PST)
Message-Id: <20200117.041332.907915356252413057.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jacob.e.keller@intel.com,
        jiri@mellanox.com, mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next] Documentation: Fix typo in devlink
 documentation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200116175944.1958052-1-idosch@idosch.org>
References: <20200116175944.1958052-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 Jan 2020 03:31:16 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Thu, 16 Jan 2020 19:59:44 +0200

> From: Ido Schimmel <idosch@mellanox.com>
> 
> The driver is named "mlxsw", not "mlx5".
> 
> Fixes: d4255d75856f ("devlink: document info versions for each driver")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Applied, thanks.
