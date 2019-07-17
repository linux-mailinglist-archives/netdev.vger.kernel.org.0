Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 813AB6C310
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 00:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbfGQWUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 18:20:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42936 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727410AbfGQWUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 18:20:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CCDCE14EB4AFE;
        Wed, 17 Jul 2019 15:20:09 -0700 (PDT)
Date:   Wed, 17 Jul 2019 15:20:07 -0700 (PDT)
Message-Id: <20190717.152007.1089694603909987748.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net 0/2] mlxsw: Two fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190717202908.1547-1-idosch@idosch.org>
References: <20190717202908.1547-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 17 Jul 2019 15:20:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Wed, 17 Jul 2019 23:29:06 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> This patchset contains two fixes for mlxsw.
> 
> Patch #1 from Petr fixes an issue in which DSCP rewrite can occur even
> if the egress port was switched to Trust L2 mode where priority mapping
> is based on PCP.
> 
> Patch #2 fixes a problem where packets can be learned on a non-existing
> FID if a tc filter with a redirect action is configured on a bridged
> port. The problem and fix are explained in detail in the commit message.

Series applied.

> Please consider both patches for 5.2.y

I'll queue them up for -stable, thanks.
