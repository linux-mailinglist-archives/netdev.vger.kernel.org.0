Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03994232534
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 21:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgG2TQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 15:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726779AbgG2TQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 15:16:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18974C061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 12:16:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0AEBF11D53F8B;
        Wed, 29 Jul 2020 11:59:54 -0700 (PDT)
Date:   Wed, 29 Jul 2020 12:16:38 -0700 (PDT)
Message-Id: <20200729.121638.1693113360021781177.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@mellanox.com,
        amitc@mellanox.com, alexve@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net 0/6] mlxsw fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200729092648.2055488-1-idosch@idosch.org>
References: <20200729092648.2055488-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Jul 2020 11:59:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Wed, 29 Jul 2020 12:26:42 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> This patch set contains various fixes for mlxsw.
> 
> Patches #1-#2 fix two trap related issues introduced in previous cycle.
> 
> Patches #3-#5 fix rare use-after-frees discovered by syzkaller. After
> over a week of fuzzing with the fixes, the bugs did not reproduce.
> 
> Patch #6 from Amit fixes an issue in the ethtool selftest that was
> recently discovered after running the test on a new platform that
> supports only 1Gbps and 10Gbps speeds.

Series applied, thank you.
