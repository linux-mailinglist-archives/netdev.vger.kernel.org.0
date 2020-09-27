Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C0C27A402
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 22:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgI0UYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 16:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgI0UYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 16:24:01 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603F4C0613CE
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 13:24:01 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8FB3513BAFAC8;
        Sun, 27 Sep 2020 13:07:13 -0700 (PDT)
Date:   Sun, 27 Sep 2020 13:24:00 -0700 (PDT)
Message-Id: <20200927.132400.700160456852122583.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, idosch@nvidia.com
Subject: Re: [PATCH net] mlxsw: spectrum_acl: Fix
 mlxsw_sp_acl_tcam_group_add()'s error path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200927064211.1412383-1-idosch@idosch.org>
References: <20200927064211.1412383-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 27 Sep 2020 13:07:13 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Sun, 27 Sep 2020 09:42:11 +0300

> From: Ido Schimmel <idosch@nvidia.com>
> 
> If mlxsw_sp_acl_tcam_group_id_get() fails, the mutex initialized earlier
> is not destroyed.
> 
> Fix this by initializing the mutex after calling the function. This is
> symmetric to mlxsw_sp_acl_tcam_group_del().
> 
> Fixes: 5ec2ee28d27b ("mlxsw: spectrum_acl: Introduce a mutex to guard region list updates")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Applied and queued up for -stable.
