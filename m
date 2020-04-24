Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B80F1B821B
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 00:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgDXWmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 18:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgDXWmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 18:42:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24998C09B049
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 15:42:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3A91914E88DA8;
        Fri, 24 Apr 2020 15:42:12 -0700 (PDT)
Date:   Fri, 24 Apr 2020 15:42:09 -0700 (PDT)
Message-Id: <20200424.154209.1645447397331548392.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next 0/5] mlxsw: Mirroring cleanups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200424154345.3677009-1-idosch@idosch.org>
References: <20200424154345.3677009-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Apr 2020 15:42:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Fri, 24 Apr 2020 18:43:40 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> This patch set contains various cleanups in SPAN (mirroring) code
> noticed by Amit and I while working on future enhancements in this area.
> No functional changes intended. Tested by current mirroring selftests.
> 
> Patches #1-#2 from Amit reduce nesting in a certain function and rename
> a callback to a more meaningful name.
> 
> Patch #3 removes debug prints that have little value.
> 
> Patch #4 converts a reference count to 'refcount_t' in order to catch
> over/under flows.
> 
> Patch #5 replaces a zero-length array with flexible-array member in
> order to get a compiler warning in case the flexible array does not
> occur last in the structure.

Series applied, thanks.
