Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D11E21BF46
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 23:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgGJVeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 17:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbgGJVeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 17:34:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0707C08C5DC
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 14:34:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4D61A12868404;
        Fri, 10 Jul 2020 14:34:19 -0700 (PDT)
Date:   Fri, 10 Jul 2020 14:34:18 -0700 (PDT)
Message-Id: <20200710.143418.1831636589394537781.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net 0/2] mlxsw: Various fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200710134139.599811-1-idosch@idosch.org>
References: <20200710134139.599811-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 Jul 2020 14:34:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Fri, 10 Jul 2020 16:41:37 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Fix two issues found by syzkaller.
> 
> Patch #1 removes inappropriate usage of WARN_ON() following memory
> allocation failure. Constantly triggered when syzkaller injects faults.
> 
> Patch #2 fixes a use-after-free that can be triggered by 'devlink dev
> info' following a failed devlink reload.

Series applied and queued up for -stable, thanks.
